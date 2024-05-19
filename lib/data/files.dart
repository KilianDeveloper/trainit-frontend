import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:trainit/data/datasource.dart';

class LocalFiles extends LocalDataSource {
  static const String profilePhotoFileName = "photo.webp";

  Future<File> getProfilePhotoFile() async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/$profilePhotoFileName');
  }

  LocalFiles._create();
  static LocalFiles? _instance;

  static LocalFiles get instance {
    _instance ??= LocalFiles._create();
    return _instance!;
  }

  static void recreateInstance() {
    _instance ??= LocalFiles._create();
  }

  @override
  Future<void> deleteAll() async {
    final profilePhoto = await getProfilePhotoFile();
    if (await profilePhoto.exists()) {
      await profilePhoto.delete();
    }
  }
}
