part of auth0;

/// Class that presents exception unauthorized exception from auth0
class Auth0UnauthorizedException implements Exception {
  final String message;

  Auth0UnauthorizedException({required this.message});

  @override
  String toString() {
    return "Auth0UnauthorizedException($message)";
  }
}
