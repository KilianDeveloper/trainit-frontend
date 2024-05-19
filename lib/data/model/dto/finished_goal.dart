import 'dart:typed_data';

import 'package:trainit/data/model/goal.dart';

class FinishedGoal {
  final Uint8List imageBytes;
  final Goal goal;

  FinishedGoal({
    required this.imageBytes,
    required this.goal,
  });
}
