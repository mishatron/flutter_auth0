# auth0

Dart package for authentication using Auth0 API.Contains basic set of methods like passwordRealm, sendOtp, getUser, logout etc.

## Usage

```
final Auth0Client client = Auth0Client(clientId: "abcdefg", domain: "site.url"
        connectTimeout: const Duration(seconds:10), sendTimeout: const Duration(seconds:10), receiveTimeout: const Duration(seconds:60),
        useLoggerInterceptor: true, accessToken: "abcdefg");
```
Domain should be without https, it is added automatically

## Available methods


`updateToken` - Updates current access token for Auth0 connection  
`authorizeUrl` - Builds the full authorize endpoint url in the Authorization Server (AS) with given parameters.  
`passwordRealm` - Performs Auth with user credentials using the Password Realm Grant  
`passwordGrant` - Performs Auth with user credentials using the Password Grant without Realm  
`refreshToken` - Obtains new tokens using the Refresh Token obtained during Auth (requesting offline_access scope)  
`getUserInfo` - Returns user information using an access token  
`resetPassword` - Requests an email with instructions to change password of a user  
`logout` - Makes logout API call  
`createUser` - Performs creating user with specified values  
`revoke` - Revokes an issued refresh token  
`exchange` - Exchanges a code obtained via /authorize (w/PKCE) for the user's tokens  
`sendOtpCode` - Performs sending sms code on phone number  
`verifyPhoneWithOTP` - Performs verification of phone number  
`exchangeAppleAuthCode1` - Exchanges a code obtained from SignIn-with-Apple social login for the user's tokens
