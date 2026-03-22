import 'package:image_picker/image_picker.dart';

abstract class FredericStorageInterface {
  Future<String?> uploadImage(XFile image, String name);
}
