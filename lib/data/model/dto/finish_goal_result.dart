import 'dart:typed_data';

class FinishGoalResult {
  final Uint8List? imageBytes;
  final bool success;

  FinishGoalResult({
    this.imageBytes,
    required this.success,
  });
}
