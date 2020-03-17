part of auth0;

void handleError(DioError error, JsonDecoder _decoder) {
  if (error.error is SocketException)
    throw error.error;
  else if (error.type == DioErrorType.RECEIVE_TIMEOUT ||
      error.type == DioErrorType.SEND_TIMEOUT ||
      error.type == DioErrorType.CONNECT_TIMEOUT) {
    throw SocketException(error.toString());
  } else {
    throw AuthException(description: error.error.toString());
  }
}
