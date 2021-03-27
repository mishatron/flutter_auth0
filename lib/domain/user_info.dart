part of auth0;

class Auth0User {
  final String accessToken;
  final String refreshToken;
  final String idToken;
  final String scope;
  final DateTime expiresDate;
  final String tokenType;

  Auth0User.fromMap(Map snapshot)
      : accessToken = snapshot['access_token'],
        refreshToken = snapshot['refresh_token'],
        idToken = snapshot['id_token'],
        scope = snapshot['scope'],
        expiresDate =
            DateTime.now().add(Duration(seconds: snapshot['expires_in'] ?? 0)),
        tokenType = snapshot['token_type'];

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'id_token': idToken,
      'scope': scope,
      'expires_in': expiresDate.difference(DateTime.now()).inSeconds,
      'token_type': tokenType
    };
  }
}
