import 'dart:io';

extension HttpHeadersX on HttpHeaders {
  void addAll(Map<String, dynamic> headers) {
    headers.forEach((key, value) {
      add(key, value);
    });
  }
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
