## [1.2.0] - 23.09.2020.

* Added [passwordGrant] method
* Added [sendOtpCode] method for passwordless (OTP) auth
* Added [phoneVerificationOtp] method to confirm auth via OTP
* Added token interceptor for dio to automatically refresh token if needed. Tokens are saved via shared preferences
* Added [Auth0UnauthorizedException] that throws when no token or it can not be refreshed


## [1.1.0] - 17.03.2020.

* Fixed some methods


## [1.0.1] - 17.03.2020.

* Minor file format


## [1.0.0] - 17.03.2020.

* Basic set of API methods
