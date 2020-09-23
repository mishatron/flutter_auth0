part of auth0;

class TokenInterceptor extends InterceptorsWrapper {
  Dio previous;
  Dio refreshDio = Dio();
  Auth0Client auth0client;

  TokenInterceptor(previous, this.auth0client) {
    this.previous = previous;
  }

  @override
  onRequest(RequestOptions options) async {
    String accessToken = await Auth0PreferenceManager().getAccessToken();

    if (accessToken == null) {
      await Auth0PreferenceManager().clear();
      throw Auth0UnauthorizedException(message: "Token not found");
    }

    options.headers["Authorization"] = "Bearer $accessToken";
    return options;
  }

  @override
  Future<Response> onResponse(Response response) async {
    return response;
  }

  @override
  onError(DioError error) async {
    if (error.response?.statusCode == 401) {
      RequestOptions options = error.request;

      String accessToken = await Auth0PreferenceManager().getAccessToken();

      String token = "Bearer $accessToken";
      if (token != options.headers["Authorization"]) {
        options.headers["Authorization"] = token;
        return previous.request(options.path, options: options);
      }

      // Lock to block the incoming request until the token updated
      previous.lock();
      previous.interceptors.responseLock.lock();
      previous.interceptors.errorLock.lock();

      try {
        String refreshToken = await Auth0PreferenceManager().getRefreshToken();
        await auth0client.refreshToken(refreshToken);

        previous.unlock();
        previous.interceptors.responseLock.unlock();
        previous.interceptors.errorLock.unlock();

        // repeat the request with a new options
        return previous.request(options.path, options: options);
      } catch (e) {
        await Auth0PreferenceManager().clear();
        throw Auth0UnauthorizedException(message: e.toString());
      }
    }
    return error;
  }
}
