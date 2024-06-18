class ApiEndPoints {
  static const String baseUrl = 'https://monu-talk-production.up.railway.app/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'auth/register';
  final String loginEmail = 'auth/login';
}