import 'package:frederic/backend/storage/frederic_storage_interface.dart';
import 'package:image_picker/image_picker.dart';

class FredericStorageManager {
  FredericStorageManager(this.storageImplementation);

  final FredericStorageInterface storageImplementation;

  Future<String?> uploadXFileImageToUserStorage(XFile image, String name) async {
    return storageImplementation.uploadImage(image, name);
  }
}

