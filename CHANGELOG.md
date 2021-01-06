## [1.3.0] - 06.01.2021.
* Removed useless shared preference and token interceptor
* Removed flutter as dependency
* Improved documentation

## [1.2.1] - 23.09.2020.
* Fixed documentation


## [1.2.0] - 23.09.2020.
* Added [passwordGrant] method
* Added [sendOtpCode] method for passwordless (OTP) auth
* Added [verifyPhoneWithOTP] method to confirm auth via OTP
* Added token interceptor for dio to automatically refresh token if needed. Tokens are saved via shared preferences
* Added [Auth0UnauthorizedException] that throws when no token or it can not be refreshed

## [1.1.0] - 17.03.2020.
* Fixed some methods

## [1.0.1] - 17.03.2020.
* Minor file format

## [1.0.0] - 17.03.2020.
* Basic set of API methods
