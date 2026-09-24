class AppHttpException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  AppHttpException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}
