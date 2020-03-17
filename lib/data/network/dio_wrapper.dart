part of auth0;

/// Class that makes API call easier
class DioWrapper {
  final Dio dio = Dio();
  final JsonDecoder _decoder = JsonDecoder();
  String host = "";
  String scheme = "";

  void configure(String baseUrl, int connectTimeout, int sendTimeout,
      int receiveTimeout, String accessToken) {
    var parsed = Uri.parse(baseUrl);
    scheme = parsed.scheme;
    host = parsed.host;

    dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = connectTimeout
      ..sendTimeout = sendTimeout
      ..receiveTimeout = receiveTimeout;
    if (accessToken != null) {
      dio
        ..interceptors
            .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
          dio.interceptors.requestLock.lock();
          String token = "Bearer $accessToken";
          options.headers["Authorization"] = token;
          dio.interceptors.requestLock.unlock();
          return options; //continue
        }));
    }
  }

  String encodedTelemetry() {
    return base64.encode(utf8.encode(jsonEncode(telemetry)));
  }

  String url(String path, {dynamic query, bool includeTelemetry = false}) {
    dynamic params = query ?? {};
    if (includeTelemetry) {
      params['auth0Client'] = this.encodedTelemetry();
    }
    var parsed = Uri(
      scheme: scheme,
      host: host,
      path: path,
      queryParameters: Map.from(params),
    );
    return parsed.query.isEmpty
        ? parsed.toString().replaceAll('?', '')
        : parsed.toString();
  }

  /// DIO GET
  /// take [url], concrete route
  Future<Response> get(String url, {Map<String, dynamic> params}) async =>
      await dio
          .get(url, queryParameters: params)
          .then((response) => response)
          .catchError((error) {
        handleError(error, _decoder);
      });

  /// DIO POST
  /// take [url], concrete route
  Future<Response> post(String url, {Map headers, body, encoding}) async =>
      await dio.post(url, data: body).then((response) {
        print(response);
        return response;
      }).catchError((error) {
        handleError(error, _decoder);
      });
}
