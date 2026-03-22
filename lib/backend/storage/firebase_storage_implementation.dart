import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/storage/frederic_storage_interface.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageImplementation implements FredericStorageInterface {
  FirebaseStorageImplementation(this.backend);

  final FredericBackend backend;

  @override
  Future<String?> uploadImage(XFile image, String name) async {
    try {
      Uint8List? imageData = await _convertXFileToRawJPEG(image);
      if (imageData == null) return null;
      Reference reference = FirebaseStorage.instance
          .ref('userdata/${backend.userManager.state.id}/$name');
      await reference.putData(imageData);
      return reference.getDownloadURL();
    } on FirebaseException catch (exception) {
      print('Firebase Storage Error: $exception');
      rethrow;
    }
  }

  Future<Uint8List?> _convertXFileToRawJPEG(XFile file, [int quality = 80]) async {
    Image? image = decodeNamedImage(file.path, await File(file.path).readAsBytes());
    if (image == null) return null;
    var jpeg = encodeJpg(image, quality: quality);
    return Uint8List.fromList(jpeg);
  }
}
