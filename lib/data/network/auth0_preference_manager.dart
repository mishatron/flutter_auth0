
part of auth0;
class Auth0PreferenceManager {

  final String _kAccessToken = "_kAccessToken";
  final String _kRefreshToken = "_kRefreshToken";

  static final Auth0PreferenceManager singleton = Auth0PreferenceManager._internal();

  Auth0PreferenceManager._internal();

  factory Auth0PreferenceManager() => singleton;

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccessToken);
    await prefs.remove(_kRefreshToken);
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccessToken) ?? "";
  }

  Future<bool> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_kAccessToken, token);
  }

  Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRefreshToken) ?? "";
  }

  Future<bool> setRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_kRefreshToken, token);
  }
}
