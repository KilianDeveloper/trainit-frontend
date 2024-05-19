import 'package:trainit/data/data_provider/local_tutorial_provider.dart';

class TutorialRepository {
  final LocalTutorialProvider _localProvider;

  TutorialRepository({
    LocalTutorialProvider? provider,
  }) : _localProvider = provider ?? LocalTutorialProvider();

  Future<String> readStatus() async {
    return await _localProvider.getTutorialStatus();
  }

  Future<void> writeStatus(String status) async {
    await _localProvider.setTutorialStatus(status);
  }
}
