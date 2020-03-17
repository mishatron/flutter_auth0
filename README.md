# auth0

Flutter package for authentication using Auth0 API.Contains basic set of methods like passwordRealm, getUser, logout etc.

## Usage

```
Auth0Client(clientId, baseUrl,
        connectTimeout: 10000, sendTimeout: 10000, receiveTimeout: 60000);
```

## Available methods


`updateToken` - Updates current access token for Auth0 connection  
`authorizeUrl` - Builds the full authorize endpoint url in the Authorization Server (AS) with given parameters.  
`passwordRealm` - Performs Auth with user credentials using the Password Realm Grant  
`refreshToken` - Obtains new tokens using the Refresh Token obtained during Auth (requesting offline_access scope)  
`getUserInfo` - Returns user information using an access token  
`resetPassword` - Requests an email with instructions to change password of a user  
`logout` - Makes logout API call  
`createUser` - Performs creating user with specified values  
`revoke` - Revokes an issued refresh token  
`exchange` - Exchanges a code obtained via /authorize (w/PKCE) for the user's tokens

