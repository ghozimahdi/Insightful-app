import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import '../models/media_object.dart';

class FilePickerService {
  static final FilePickerService _instance = FilePickerService._();

  factory FilePickerService() => _instance;

  FilePickerService._();

  static final _imagePicker = ImagePicker();
  static Directory? tempDir;

  static Future<XFile?> pickImageFromGallery() async {

    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final compressedFile = await compressImage(File(pickedFile.path));
      return compressedFile;
    }
    return null;
  }

  static Future<List<XFile>> pickImagesFromGallery() async {
    final List<XFile> pickedFiles = await _imagePicker.pickMultiImage();
    final List<XFile> compressedFiles = [];

    for (final XFile file in pickedFiles) {
      final compressedFile = await compressImage(File(file.path));
      compressedFiles.add(compressedFile!);
    }

    return compressedFiles;
  }

  static Future<XFile?> pickMedia() async {
    final XFile? pickedFile = await _imagePicker.pickMedia();
    return pickedFile;
  }

  static Future<XFile?> pickVideoFromGallery() async => _imagePicker.pickVideo(source: ImageSource.gallery);

  static Future<XFile?> pickFile() async {
    final result = await file_picker.FilePicker.platform.pickFiles(
      type: file_picker.FileType.custom,
      allowedExtensions: ['pdf', 'csv', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
    );

    if (result != null) {
      final file = result.files.single;
      return XFile(file.path!);
    }
    return null;
  }

  static Future<XFile?> pickImageFromCamera() async => _imagePicker.pickImage(source: ImageSource.camera);

  static bool isFileImage(String filePath) => lookupMimeType(filePath)?.contains('image') ?? false;

  static bool isFileVideo(String filePath) => lookupMimeType(filePath)?.contains('video') ?? false;

  static bool isFileAudio(String filePath) => lookupMimeType(filePath)?.contains('audio') ?? false;

  static bool isFileDocument(String filePath) {
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    return mimeType.contains('application') || mimeType.contains('text');
  }

  static FileType getFileType(String filePath) {
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

    switch (mimeType.split('/')[0]) {
      case 'image':
        return FileType.image;
      case 'video':
        return FileType.video;
      case 'audio':
        return FileType.audio;
      case 'application':
      case 'text':
        return FileType.file;
      default:
        throw Exception('Unsupported file type');
    }
  }

  static Future<XFile?> compressImage(File file) async {
    tempDir ??= await getTemporaryDirectory();
    final targetPath = path.join(tempDir!.path, '${path.basenameWithoutExtension(file.path)}_compressed.jpg');
    return FlutterImageCompress.compressAndGetFile(file.absolute.path, targetPath, quality: 40);
  }
}
