## [2.1.1-beta1] - 04.12.2021.
* Updated documentation
* Added method exchangeAppleAuthCode (issue #9)

## [2.1.0-beta1] - 02.12.2021.
* Updated dependencies
* Support "passwordless" via email as well as SMS (issue #6)

## [2.0.2] - 12.10.2021.
* All fields in Auth0User are nullable
* More documentation for classes

## [2.0.1] - 07.06.2021.
* Updated dependencies and example

## [2.0.0-nullsafety.0] - 31.03.2021.
* Added nullsafety support, thanks @LockedThread


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
