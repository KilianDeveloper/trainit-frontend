class DataSourceError {
  final ErrorType type;
  final dynamic data;

  DataSourceError({required this.type, this.data});
}

enum ErrorType { unknown, socket, timeout, responseCode, authentication }
