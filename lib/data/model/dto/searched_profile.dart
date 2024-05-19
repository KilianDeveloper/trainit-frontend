import 'dart:typed_data';

import 'package:trainit/data/model/profile.dart';

class SearchedProfile {
  final Uint8List? profilePhoto;
  final Profile? profile;
  final bool wasFound;

  SearchedProfile({
    required this.profilePhoto,
    required this.profile,
    required this.wasFound,
  });
}
