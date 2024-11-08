import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class CameraService {
  static Future<CustomFile?> selectPhoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image == null) return null;

    final Uint8List bytes = await image.readAsBytes();
    final int size = bytes.lengthInBytes;
    final String name = image.name;

    return CustomFile(
      bytes: bytes,
      name: name,
      size: size,
    );
  }

  static Future<CustomFile?> takePhoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;

    final Uint8List bytes = await photo.readAsBytes();
    final int size = bytes.lengthInBytes;
    final String name = photo.name;

    return CustomFile(
      bytes: bytes,
      name: name,
      size: size,
    );
  }
}

class CustomFile {
  final Uint8List bytes;
  final String name;
  final int size;

  // Getter para el tamaño en KB
  int get sizeInKB => (size / 1024).round();

  CustomFile({
    required this.bytes,
    required this.name,
    required this.size,
  });
}
