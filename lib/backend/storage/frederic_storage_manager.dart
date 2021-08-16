import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:frederic/backend/backend.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

class FredericStorageManager {
  FredericStorageManager(this.backend);
  final FredericBackend backend;

  Future<String?> uploadXFileImageToStorage(XFile image, String name) async {
    try {
      Uint8List? imageData = await _convertXFileToRawJPEG(image);
      if (imageData == null) return null;
      Reference reference = FirebaseStorage.instance
          .ref('userdata/${backend.userManager.state.uid}/$name');
      await reference.putData(imageData);
      return reference.getDownloadURL();
    } on FirebaseException catch (exception) {
      print(exception);
      rethrow;
    }
  }

  Future<Uint8List?> _convertXFileToRawJPEG(XFile file,
      [int quality = 80]) async {
    Image? image =
        decodeNamedImage(await File(file.path).readAsBytes(), file.name);
    if (image == null) return null;
    var jpeg = encodeJpg(image, quality: quality);
    var data = Uint8List.fromList(jpeg);
    return data;
  }
}
