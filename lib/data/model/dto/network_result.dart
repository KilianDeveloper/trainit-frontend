class NetworkResult {
  bool success;
  NetworkResult({required this.success});

  factory NetworkResult.fromJson(Map<String, dynamic> json) {
    return NetworkResult(success: json['success']);
  }
}
