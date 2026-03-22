import 'dart:io';
import 'dart:typed_data';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/storage/frederic_storage_interface.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class PocketbaseStorageImplementation implements FredericStorageInterface {
  PocketbaseStorageImplementation(this.pb, this.backend);

  final PocketBase pb;
  final FredericBackend backend;

  @override
  Future<String?> uploadImage(XFile image, String name) async {
    try {
      Uint8List? imageData = await _convertXFileToRawJPEG(image);
      if (imageData == null) return null;

      final userId = backend.userManager.state.id;
      
      // Upload to 'userdata' collection
      final record = await pb.collection('userdata').create(
        body: {
          'owner': userId,
          'name': name,
        },
        files: [
          http.MultipartFile.fromBytes(
            'file',
            imageData,
            filename: '${name}.jpg',
          ),
        ],
      );

      // Return the file URL
      return pb.getFileUrl(record, record.getStringValue('file')).toString();
    } catch (e) {
      print('PocketBase Storage Error: $e');
      return null;
    }
  }

  Future<Uint8List?> _convertXFileToRawJPEG(XFile file, [int quality = 80]) async {
    Image? image = decodeNamedImage(file.path, await File(file.path).readAsBytes());
    if (image == null) return null;
    var jpeg = encodeJpg(image, quality: quality);
    return Uint8List.fromList(jpeg);
  }
}
