import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/admin_panel/models/admin_icon_model.dart';

class AdminIconManager extends Bloc<AdminIconEvent, AdminIconListData> {
  AdminIconManager() : super(AdminIconListData(<AdminIconModel>[])) {
    reload();
  }

  void reload() async {
    List<AdminIconModel> iconList = await _getAllIcons('icons');
    add(new AdminIconEvent(iconList));
  }

  Future<List<AdminIconModel>> _getAllIcons(String folder) async {
    List<AdminIconModel> icons = <AdminIconModel>[];
    ListResult result = await FirebaseStorage.instance.ref(folder).listAll();

    List<Future<AdminIconModel>> futures = <Future<AdminIconModel>>[];
    Completer<List<AdminIconModel>> completer =
        Completer<List<AdminIconModel>>();

    for (var ref in result.items) {
      futures.add(_getAdminIconModelFromReference(ref));
    }
    Future.wait(futures).then((value) {
      for (var icon in value) {
        icons.add(icon);
      }
      completer.complete(icons);
    });

    return completer.future;
  }

  Future<AdminIconModel> _getAdminIconModelFromReference(
      Reference reference) async {
    FullMetadata metadata = await reference.getMetadata();
    String? tagString = metadata.customMetadata?['tags'];
    List<String> tags = <String>[];
    if (tagString != null) {
      tags = tagString.split(',');
    }
    return AdminIconModel(
        reference.name, await reference.getDownloadURL(), tags, reference);
  }

  Stream<AdminIconListData> mapEventToState(AdminIconEvent event) async* {
    yield AdminIconListData(event.icons);
  }
}

class AdminIconEvent {
  AdminIconEvent(this.icons);
  List<AdminIconModel> icons;
}

class AdminIconListData {
  AdminIconListData(this.icons);

  List<AdminIconModel> icons;

  List<AdminIconModel> filtered(String searchTagsString, bool matchAll) {
    List<String> searchTags = searchTagsString.split(',');
    for (int i = 0; i < searchTags.length; i++) {
      searchTags[i] = searchTags[i].trim();
    }

    return icons
        .where((element) => element.matchTags(searchTags, matchAll))
        .toList();
  }
}
