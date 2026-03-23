import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/database/frederic_auth_interface.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class PocketbaseAuthInterface implements FredericAuthInterface {
  PocketbaseAuthInterface({required this.pb}) {
    _initializePersistence();

    // Listen to Pocketbase auth changes
    pb.authStore.onChange.listen((event) {
      _saveToDisk(event.token, event.model);

      if (pb.authStore.isValid && pb.authStore.model != null) {
        final record = pb.authStore.model as RecordModel;
        if (record.id != _lastSignaledId) {
          _lastSignaledId = record.id;
          final user = FredericUser.only(
              record.id, record.getStringValue('email', 'no-mail'));
          _onUpdateData?.call(user, true);
        }
      } else if (!pb.authStore.isValid) {
        _lastSignaledId = null;
      }
    });

    Hive.openBox<Map<dynamic, dynamic>>(_name).then((value) => _box = value);
  }

  static const String _tokenKey = 'pb_auth_token';
  static const String _modelKey = 'pb_auth_model';

  void _initializePersistence() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final modelRaw = prefs.getString(_modelKey);

    if (token != null && token.isNotEmpty) {
      dynamic model;
      if (modelRaw != null) {
        try {
          final Map<String, dynamic> decoded = jsonDecode(modelRaw);
          model = RecordModel(
            id: decoded['id'] ?? '',
            collectionId: decoded['collectionId'] ?? '',
            collectionName: decoded['collectionName'] ?? '',
            data: Map<String, dynamic>.from(decoded['data'] ?? {}),
          );
        } catch (e) {
          print('Error restoring PocketBase session: $e');
        }
      }
      pb.authStore.save(token, model);
    }
  }

  void _saveToDisk(String? token, dynamic model) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null || token.isEmpty) {
      prefs.remove(_tokenKey);
      prefs.remove(_modelKey);
    } else {
      prefs.setString(_tokenKey, token);
      if (model is RecordModel) {
        prefs.setString(
            _modelKey,
            jsonEncode({
              'id': model.id,
              'collectionId': model.collectionId,
              'collectionName': model.collectionName,
              'data': model.data,
            }));
      }
    }
  }

  final PocketBase pb;
  String? _lastSignaledId;
  void Function(FredericUser, bool)? _onUpdateData;
  final String _name = 'userdata_pocketbase';
  Box<Map<dynamic, dynamic>>? _box;

  @override
  Future<void> changePassword(FredericUser user, String newPassword) async {
    throw UnimplementedError(); // Need old password for PB, or use password reset
  }

  @override
  Future<bool> reAuthenticate(FredericUser user, String password) async {
    try {
      await pb.collection('users').authWithPassword(user.email, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteAccount(FredericUser user) async {
    await pb.collection('users').delete(user.id);
    pb.authStore.clear();
  }

  @override
  Future<FredericUser> logIn(
      {required String email, required String password}) async {
    try {
      final authData =
          await pb.collection('users').authWithPassword(email, password);
      final record = authData.record;
      if (record == null) {
        return FredericUser.noAuth(
            statusMessage: 'Login Error. Try Again later.');
      }
      return getUserData(record.id, record.getStringValue('email'));
    } on ClientException catch (e) {
      if (e.statusCode == 400) {
        return FredericUser.noAuth(
            statusMessage: 'Invalid credentials or missing user.');
      }
      return FredericUser.noAuth(
          statusMessage: 'Undefined login error: ${e.response}');
    } catch (e) {
      return FredericUser.noAuth(statusMessage: 'Undefined login error.');
    }
  }

  @override
  Future<FredericUser> logInOAuth(
      {required String provider,
      String? name,
      Map<String, dynamic>? params}) async {
    try {
      String pbProvider = provider;
      if (provider == 'apple.com') pbProvider = 'apple';

      RecordAuth authData;

      if (params != null &&
          params.containsKey('authorizationCode') &&
          params['authorizationCode'] != null) {
        final authMethods = await pb.collection('users').listAuthMethods();
        
        // Check if the provider is actually enabled on the backend to prevent crashes
        final hasProvider = authMethods.authProviders.any((p) => p.name == pbProvider);
        if (!hasProvider) {
          return FredericUser.noAuth(statusMessage: 'Apple Sign-In is not enabled on the server.');
        }

        final authProvider =
            authMethods.authProviders.firstWhere((p) => p.name == pbProvider);

        final redirectUrl = '${pb.baseUrl}/api/oauth2-redirect';
        authData = await pb.collection('users').authWithOAuth2Code(pbProvider,
            params['authorizationCode'], authProvider.codeVerifier, redirectUrl,
            createData: {
              'name': name ?? '',
              'has_purchased': !FredericBackend.instance.defaults.trialEnabled,
            });
      } else {
        // For PocketBase, we use the authWithOAuth2 flow.
        // In a mobile app, this usually requires a urlCallback to open the browser.
        authData = await pb.collection('users').authWithOAuth2(
          pbProvider,
          (url) async {
            // This will be called to open the auth URL.
            // The user must handle the redirect back to the app.
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        );
      }

      final record = authData.record;
      if (record == null) {
        return FredericUser.noAuth(
            statusMessage: 'OAuth Login Error. Try Again later.');
      }
      return getUserData(record.id, record.getStringValue('email'));
    } catch (e) {
      print('Pocketbase OAuth Error: $e');
      return FredericUser.noAuth(statusMessage: 'OAuth login error: $e');
    }
  }

  Future<FredericUser> _reloadUserData(
      String uid, String email, bool callCallback) async {
    try {
      final userRecord = await pb.collection('users').getOne(uid);

      // Update last login (non-blocking, don't fail login if this fails)
      pb.collection('users').update(uid, body: {
        'last_login': DateTime.now().toIso8601String(),
        'last_os': Platform.operatingSystem,
        'last_os_version': Platform.operatingSystemVersion,
        'login_count': userRecord.getIntValue('login_count', 0) + 1,
      }).catchError((e) {
        print('Warning: Could not update user metadata: $e');
        return RecordModel();
      });

      final fullData = Map<String, dynamic>.from(userRecord.data);
      
      final avatarStr = userRecord.getStringValue('avatar');
      if (avatarStr.isNotEmpty) {
        fullData['image'] = pb.getFileUrl(userRecord, avatarStr).toString();
      }
      
      fullData['uid'] =
          uid; // Ensure uid is in the map for caching/model consistency

      if (_box == null) _box = await Hive.openBox(_name);
      _box!.put(0, fullData);

      final user = FredericUser.fromMap(uid, email, fullData);
      if (callCallback) {
        _onUpdateData?.call(user, false);
      }
      return user;
    } catch (e) {
      print('PocketbaseAuthInterface Error in _reloadUserData: $e');
      return FredericUser.noAuth();
    }
  }

  @override
  Future<FredericUser> getUserData(String uid, String email) async {
    _box = await Hive.openBox(_name);
    if ((_box?.isEmpty ?? true)) return _reloadUserData(uid, email, false);
    final data = _box?.get(0);

    if (data != null && data['uid'] == uid) {
      FredericProfiler.log(
          'PocketbaseAuthInterface: UID matching, using cached data');
      _reloadUserData(uid, email, true);
      return FredericUser.fromMap(uid, email, Map<String, dynamic>.from(data));
    }
    return _reloadUserData(uid, email, false);
  }

  @override
  Future<void> logOut() async {
    pb.authStore.clear();
  }

  @override
  Future<FredericUser> signUp(
      {required String email,
      required String name,
      required String password}) async {
    try {
      final body = <String, dynamic>{
        "username": email.split('@')[0] +
            DateTime.now().millisecondsSinceEpoch.toString().substring(8),
        "email": email,
        "emailVisibility": true,
        "password": password,
        "passwordConfirm": password,
        "name": name,
        "has_purchased": !FredericBackend.instance.defaults.trialEnabled,
      };

      final record = await pb.collection('users').create(body: body);
      await pb.collection('users').authWithPassword(email, password);

      return _reloadUserData(record.id, email, false);
    } on ClientException catch (e) {
      print('Pocketbase SignUp Error: ${e.response}');
      String msg = e.response['message'] ?? e.toString();
      if (e.response['data'] != null) {
        msg += ' - ${e.response['data']}';
      }
      return FredericUser.noAuth(statusMessage: 'Sign up error: $msg');
    } catch (e) {
      return FredericUser.noAuth(
          statusMessage: 'Sign up error. Please contact support. [SUOE]');
    }
  }

  @override
  Future<void> update(FredericUser user) async {
    if (_box == null) _box = await Hive.openBox(_name);
    _box!.put(0, user.toMap());
    await pb.collection('users').update(user.id, body: user.toMap());
  }

  @override
  void registerDataChangedListener(
      void Function(FredericUser user, bool restoreLoginStatus) onDataChanged) {
    _onUpdateData = onDataChanged;

    // If we already have a valid session in the store, signal it now.
    // This handles the case where the session was loaded from disk before the listener was registered.
    if (pb.authStore.isValid && pb.authStore.model != null) {
      final record = pb.authStore.model as RecordModel;
      _lastSignaledId = record.id;
      _onUpdateData?.call(
          FredericUser.only(
              record.id, record.getStringValue('email', 'no-mail')),
          true);
    }
  }
}
