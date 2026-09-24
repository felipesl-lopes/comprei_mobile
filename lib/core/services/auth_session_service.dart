class AuthSessionService {
  String? _token;
  DateTime? _expiryDate;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token => isAuth ? _token : null;

  void updateSession({
    required String? token,
    required DateTime? expiryDate,
  }) {
    _token = token;
    _expiryDate = expiryDate;
  }

  void clear() {
    _token = null;
    _expiryDate = null;
  }
}
