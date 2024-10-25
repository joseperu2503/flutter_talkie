import 'package:image_picker/image_picker.dart';

class CameraService {
  static Future<String?> selectPhoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image == null) return null;
    return image.path;
  }

  static Future<String?> takePhoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;
    return photo.path;
  }
}
