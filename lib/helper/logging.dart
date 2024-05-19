import 'package:logger/logger.dart';

class Loggers {
  static Logger get firebaseLogger {
    return Logger(
        printer: PrettyPrinter(
          printTime: true,
        ),
        output: ConsoleOutput());
  }

  static Logger get appLogger {
    return Logger(
        printer: PrettyPrinter(printTime: true), output: ConsoleOutput());
  }
}
