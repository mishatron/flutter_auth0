part of auth0;

class Auth0Client {
  final DioWrapper _dioWrapper = DioWrapper();
  final String clientId;
  final String domain;

  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;
  final bool useLoggerInterceptor;

  Auth0Client(
      {required this.clientId,
      required this.domain,
      required String accessToken,
      required this.connectTimeout,
      required this.sendTimeout,
      required this.receiveTimeout,
      this.useLoggerInterceptor = false}) {
    _dioWrapper.configure('https://$domain', connectTimeout, sendTimeout,
        receiveTimeout, accessToken, this,
        useLoggerInterceptor: useLoggerInterceptor);
  }

  /// Updates current access token for Auth0 connection
  void updateToken(String newAccessToken) {
    _dioWrapper.configure('https://$domain', connectTimeout, sendTimeout,
        receiveTimeout, newAccessToken, this);
  }

  /// Builds the full authorize endpoint url in the Authorization Server (AS) with given parameters.
  /// parameters [params] to send to /authorize
  /// @param [String] params.responseType type of the response to get from /authorize.
  /// @param [String] params.redirectUri where the AS will redirect back after success or failure.
  /// @param [String] params.state random string to prevent CSRF attacks.
  /// @returns [String] authorize url with specified params to redirect to for AuthZ/AuthN.
  /// [ref link]: https://auth0.com/docs/api/authentication#authorize-client
  //
  String authorizeUrl(dynamic params) {
    assert(params['redirectUri'] != null &&
        params['responseType'] != null &&
        params['state'] != null);
    var query = Map.from(params)
      ..addAll({
        'redirect_uri': params['redirectUri'],
        'response_type': params['responseType'],
        'state': params['state'],
      });
    return _dioWrapper.url(
      '/authorize',
      query: Map.from({'client_id': this.clientId})..addAll(query),
      includeTelemetry: true,
    );
  }

  /// Performs Auth with user credentials using the Password Realm Grant
  /// [clientSecret] is a secret key from auth0 account.
  /// [params] to send realm parameters
  /// @param [String] params.username user's username or email
  /// @param [String] params.password user's password
  /// @param [String] params.realm name of the Realm where to Auth (or connection name)
  /// @param [String] - [params.audience] identifier of Resource Server (RS) to be included as audience (aud claim) of the issued access token
  /// @param [String] - [params.scope] scopes requested for the issued tokens. e.g. openid profile
  /// @returns a [Future] with [Auth0User]
  /// [ref link]: https://auth0.com/docs/api-auth/grant/password#realm-support
  Future<Auth0User> passwordGrant(
      Map<String, String> params, String clientSecret) async {
    assert(params['username'] != null && params['password'] != null);

    var payload = {
      ...params,
      'client_id': this.clientId,
      'client_secret': clientSecret,
      'grant_type': params['realm'] != null
          ? 'http://auth0.com/oauth/grant-type/password-realm'
          : 'password'
    };

    Response res = await _dioWrapper.post('/oauth/token', body: payload);
    return Auth0User.fromMap(res.data as Map);
  }

  /// Performs Auth with user credentials using the Password Realm Grant
  /// [params] to send realm parameters
  /// @param [String] params.username user's username or email
  /// @param [String] params.password user's password
  /// @param [String] params.realm name of the Realm where to Auth (or connection name)
  /// @param [String] - [params.audience] identifier of Resource Server (RS) to be included as audience (aud claim) of the issued access token
  /// @param [String] - [params.scope] scopes requested for the issued tokens. e.g. openid profile
  /// @returns a [Future] with [Auth0User]
  /// [ref link]: https://auth0.com/docs/api-auth/grant/password#realm-support
  Future<Auth0User> passwordRealm(dynamic params) async {
    assert(params['username'] != null &&
        params['password'] != null &&
        params['realm'] != null);

    var payload = Map.from(params)
      ..addAll({
        'client_id': this.clientId,
        'grant_type': 'http://auth0.com/oauth/grant-type/password-realm',
      });

    Response res = await _dioWrapper.post('/oauth/token', body: payload);
    return Auth0User.fromMap(res.data);
  }

  /// Performs sending sms code on phone number
  /// [params] to send parameters
  /// [connectionType] connection type to use, possible values: "sms", "email", defaults to sms
  /// [connectionType] send code type to use, possible: "code", "link", defaults to code
  /// @param [String] params.phone_number user's phone number (if using phone)
  /// @param [String] params.email user's email address (is using email)
  /// @returns a [Future] with [bool]
  Future<bool> sendOtpCode(dynamic params,
      [String? connectionType, String? send]) async {
    assert(params['phone_number'] != null || params['email'] != null);

    var payload = Map.from(params)
      ..addAll({
        'client_id': this.clientId,
        'connection': connectionType ?? "sms",
        'send': send ?? "code",
        "authParams": {"scope": "offline_access", "grant_type": "refresh_token"}
      });

    await _dioWrapper.post('/passwordless/start', body: payload);
    return true;
  }

  /// Performs verification of phone number
  /// [params] to send parameters
  /// [realm] realm for authentication, possible values: "sms", "email", defaults to sms
  /// @param [String] params.otp - code form sms/email
  /// @param [String] params.username - users phone is sms realm or email, if email realm is being used
  /// @returns a [Future] with [Auth0User]
  Future<Auth0User> verifyOTP(dynamic params, [String? realm]) async {
    assert(params['username'] != null && params['otp'] != null);

    var payload = Map.from(params)
      ..addAll({
        'client_id': this.clientId,
        'realm': realm ?? "sms",
        'grant_type': 'http://auth0.com/oauth/grant-type/passwordless/otp',
      });

    Response res = await _dioWrapper.post('/oauth/token', body: payload);
    Auth0User user = Auth0User.fromMap(res.data);
    return user;
  }

  /// Obtain new tokens using the Refresh Token obtained during Auth (requesting offline_access scope)
  /// @param [Object] params refresh token params
  /// @param [String] params.refreshToken user's issued refresh token
  /// @param [String] - [params.scope] scopes requested for the issued tokens. e.g. openid profile
  /// @returns [Future]
  /// [ref link]: https://auth0.com/docs/tokens/refresh-token/current#use-a-refresh-token
  Future<dynamic> refreshToken(dynamic params) async {
    assert(params['refreshToken'] != null);
    var payload = Map.from(params)
      ..addAll({
        'refresh_token': params['refreshToken'],
        'client_id': this.clientId,
        'grant_type': 'refresh_token',
      });
    var res = await _dioWrapper.post('/oauth/token', body: payload);
    return res.data;
  }

  /// Return user information using an access token
  /// Param [String] token user's access token
  /// Returns [Future] with user info
  Future<dynamic> getUserInfo() async {
    var res = await _dioWrapper.get('/userinfo');
    return res.data;
  }

  /// Request an email with instructions to change password of a user
  /// @param [Object] parameters reset password parameters
  /// @param [String] parameters.email user's email
  /// @param [String] parameters.connection name of the connection of the user
  /// @returns [Future]
  Future<dynamic> resetPassword(dynamic params) async {
    assert(params['email'] != null && params['connection'] != null);
    var payload = Map.from(params)..addAll({'client_id': this.clientId});
    var res =
        await _dioWrapper.post('/dbconnections/change_password', body: payload);
    return res.data;
  }

  /// Performs creating user with specified values
  /// @param [Object] params create user params
  /// @param [String] params.email user's email
  /// @param [String] - [params.username] user's username
  /// @param [String] params.password user's password
  /// @param [String] params.connection name of the database connection where to create the user
  /// @param [String] - [params.metadata] additional user information that will be stored in user_metadata
  /// @returns [Future]
  Future<dynamic> createUser(dynamic params, {isEmail = true}) async {
    if (isEmail) {
      assert(params['email'] != null &&
          params['password'] != null &&
          params['connection'] != null);
    } else {}
    var payload = Map.from(params)..addAll({'client_id': this.clientId});
    if (params['metadata'] != null)
      payload..addAll({'user_metadata': params['metadata']});
    var res = await _dioWrapper.post(
      '/dbconnections/signup',
      body: payload,
    );
    return res.data;
  }

  /// Revoke an issued refresh token
  /// @param [Object] params revoke token params
  /// @param [String] params.refreshToken user's issued refresh token
  /// @returns [Future]
  Future<dynamic> revoke(dynamic params) async {
    assert(params['refreshToken'] != null);
    var payload = Map.from(params)
      ..addAll({
        'token': params['refreshToken'],
        'client_id': this.clientId,
      });
    var res = await _dioWrapper.post('/oauth/revoke', body: payload);
    return res.data;
  }

  /// Exchanges a code obtained via /authorize (w/PKCE) for the user's tokens
  /// [params] used to obtain tokens from a code
  /// @param [String] params.code code returned by /authorize.
  /// @param [String] params.redirectUri original redirectUri used when calling /authorize.
  /// @param [String] params.verifier value used to generate the code challenge sent to /authorize.
  /// @returns a [Future] with userInfo
  /// [ref link]: https://auth0.com/docs/api-auth/grant/authorization-code-pkce
  Future<dynamic> exchange(dynamic params) async {
    assert(params['code'] != null &&
        params['verifier'] != null &&
        params['redirectUri'] != null);
    var payload = Map.from(params)
      ..addAll({
        'code_verifier': params['verifier'],
        'redirect_uri': params['redirectUri'],
        'client_id': this.clientId,
        'grant_type': 'authorization_code',
      });
    var res = await _dioWrapper.post('/oauth/token', body: payload);
    return res.data;
  }

  /// Exchanges a code obtained from SignIn-with-Apple social login for the user's tokens
  /// @param subjectToken the auth code token issued by Sign-in-with-Apple service
  /// @param scope the scopes requested for the issued tokens. e.g. openid profile
  /// @returns a [Future] with userInfo
  /// [ref link]: https://auth0.com/docs/api-auth/grant/authorization-code-pkce
  Future<Auth0User> exchangeAppleAuthCode(
      {required String subjectToken, required String scope}) async {
    var payload = {
      'client_id': this.clientId,
      'subject_token': subjectToken,
      "scope": scope,
      "grant_type": 'urn:ietf:params:oauth:grant-type:token-exchange',
      "subject_token_type":
          'http://auth0.com/oauth/token-type/apple-authz-code',
    };
    var res = await _dioWrapper.post('/oauth/token', body: payload);
    Auth0User user = Auth0User.fromMap(res.data);
    return user;
  }

  /// Makes logout API call
  /// @returns a [Future]
  /// [ref link]: https://auth0.com/docs/api/authentication#logout
  Future<dynamic> logout() async {
    Map<String, dynamic> params = Map<String, dynamic>();
    params['auth0Client'] = _dioWrapper.encodedTelemetry();
    var res = await _dioWrapper.get('/v2/logout', params: params);
    return res.data;
  }
}
