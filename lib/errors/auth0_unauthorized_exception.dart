part of auth0;

class Auth0UnauthorizedException implements Exception {
  final String message;

  Auth0UnauthorizedException({required this.message});

  @override
  String toString() {
    return "Auth0UnauthorizedException($message)";
  }
}
