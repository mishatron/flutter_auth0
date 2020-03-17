part of auth0;

class AuthException implements Exception {
  final String name;
  final String description;

  AuthException(
      {this.name = 'a0.response.invalid', this.description = 'unknown error'});

  @override
  String toString() {
    return "$name $description";
  }
}
