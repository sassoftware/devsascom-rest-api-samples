# SAS Logon API
Most SAS Viya APIs require authentication for all operations, and many require authorization. For SAS Viya APIs, authentication and authorization
require a valid access token. The SAS Logon API provides the standard OAuth protocol endpoints through which clients obtain access tokens to make
subsequent API calls. Access tokens are obtained when a client makes a request and authenticates to the SAS Logon service with a valid form of authorization,
which is expressed in the form of an authorization grant.

Developers must first have their SAS administrator register a client identifier. The SAS administrator then provides API developers 
with the client identifier and client secret to use in API calls. Developers must use the client identifier and secret in all API calls.

## API Request Examples
* [Obtain an Access Token Using Client Credentials](#ObtainAccessTokenUsingClientCredentials)
* [Obtain an Access Token Using Resource Owner Password Credentials](#ObtainAccessTokenUsingResourceOwnerPasswordCredentials)
* [List clients](#ListClients)
* [Retrieve client](#RetrieveClient)
* [Create client](#CreateClient)
* [Update client](UpdateClient)
* [Change secret](#ChangeSecret)
* [Delete client](#DeleteClient)
* [Obtain token to create client](#ObtainTokenCreateClient)

#### <a name='ObtainAccessTokenUsingClientCredentials'>Obtain an Access Token Using Client Credentials</a>
Example: A client application wants to obtain an access token using its client credentials.

```
POST /SASLogon/oauth/token
    Content-Type: application/x-www-form-urlencoded
    Authorization: Basic YXBwOnNlY3JldA==
    Accept: application/json
```

`Body:`

```text
grant_type=client_credentials
```

`Response:`

```json
{
    "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImxlZ2FjeS10b2tlbi1rZXkiLCJ0eXAiOiJKV1QifQ.eyJqdGkiOiIzMjJmZGIyOTAyYzg0YTUxYTY2N2I5MGI5OWZhMWYwNiIsInN1YiI6ImFwcCIsImF1dGhvcml0aWVzIjpbInVhYS5ub25lIl0sInNjb3BlIjpbInVhYS5ub25lIl0sImNsaWVudF9pZCI6ImFwcCIsImNpZCI6ImFwcCIsImF6cCI6ImFwcCIsImdyYW50X3R5cGUiOiJjbGllbnRfY3JlZGVudGlhbHMiLCJyZXZfc2lnIjoiNjY4ZjYzYjkiLCJpYXQiOjE1MjIxNjY2MTEsImV4cCI6MTUyMjIwOTgxMSwiaXNzIjoiaHR0cHM6Ly9leGFtcGxlLnNhcy5jb20vU0FTTG9nb24vb2F1dGgvdG9rZW4iLCJ6aWQiOiJ1YWEiLCJhdWQiOlsiYXBwIl19.VPuBsB2Yod-OKtt87nhjPFlkkhG3eN48CvFkbxvWli5hDYMihTmTBVTSuAAdqaZoesNwSICYWmjBbS0FJkIp5kNKxuxb8sEtwUa8zVS5FZy0D9Ocir1mS5Fgz7ox0u6YQDXKe_mC6tij8YaYzRxJiS-fcVe6vCaRjXHbIRqVQ3U",
    "token_type": "bearer",
    "expires_in": 43199,
    "scope": "uaa.none",
    "jti": "322fdb2902c84a51a667b90b99fa1f06"
}
```

#### <a name='ObtainAccessTokenUsingResourceOwnerPasswordCredentials'>Obtain an Access Token Using Resource Owner Password Credentials</a>
Example: A client application wants to obtain an access token on behalf on an end user by providing the user's password credentials.

```
POST /SASLogon/oauth/token
    Content-Type: application/x-www-form-urlencoded
    Authorization: Basic YXBwOnNlY3JldA==
    Accept: application/json
```

`Body:`

```text
grant_type=password&username=bob&password=bobspassword
```

`Response:`

```json
{
    "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImxlZ2FjeS10b2tlbi1rZXkiLCJ0eXAiOiJKV1QifQ.eyJqdGkiOiIzNTM4ZTQxNTEyNDY0NmU3YTJiZjA1NDBlNTM3MjNlNSIsInN1YiI6IjAzMzNiODlkLTc5MjUtNDllZS04N2Y3LTQ4YzY1Mzg2N2RlZCIsInNjb3BlIjpbIm9wZW5pZCIsImdyb3VwMSIsImdyb3VwMiIsImdyb3VwMyJdLCJjbGllbnRfaWQiOiJhcHAiLCJjaWQiOiJhcHAiLCJhenAiOiJhcHAiLCJncmFudF90eXBlIjoicGFzc3dvcmQiLCJ1c2VyX2lkIjoiMDMzM2I4OWQtNzkyNS00OWVlLTg3ZjctNDhjNjUzODY3ZGVkIiwib3JpZ2luIjoidWFhIiwidXNlcl9uYW1lIjoiYm9iIiwiZW1haWwiOiJub25lIiwiYXV0aF90aW1lIjoxNTIyMTY3MTY3LCJyZXZfc2lnIjoiOWEzYzI0ZWQiLCJpYXQiOjE1MjIxNjcxNjcsImV4cCI6MTUyMjIxMDM2NywiaXNzIjoiaHR0cHM6Ly9leGFtcGxlLnNhcy5jb20vU0FTTG9nb24vb2F1dGgvdG9rZW4iLCJ6aWQiOiJ1YWEiLCJhdWQiOlsiYXBwIiwib3BlbmlkIl19.EOpYXf5acyiTn1wY5Tjr9vdu5Ez_UyPnYriMPlR9DkDTPtxxphdCiQweMEx8bjevWmFhDV-m4MDFm9F551F36cyhkpaXq39Xu6My_iDdc-xdAMvm04PHhz6p2NDSjCrmg9L5remIK-WQDyN3klkKNQvuN2V8jklVoXVMj_bBgpg",
    "token_type": "bearer",
    "expires_in": 43199,
    "scope": "openid group1 group2 group3",
    "jti": "322fdb2902c84a51a667b90b99fa1f06"
}
```

### <a name='ListClients'>List clients</a>

```
GET /SASLogon/oauth/clients?filter=client_id+eq+%22XCUNhS%22&sortBy=client_id&sortOrder=descending&startIndex=1&count=10
    Authorization: Bearer 4c24145d284840feb9e1d4e247dfee56
    Accept: application/json
```

`Response:`

```json
{
  "resources" : [ {
    "scope" : [ "clients.read", "clients.write" ],
    "client_id" : "XCUNhS",
    "resource_ids" : [ "none" ],
    "authorized_grant_types" : [ "client_credentials" ],
    "redirect_uri" : [ "http://ant.path.wildcard/**/passback/*", "http://test1.com" ],
    "autoapprove" : [ "true" ],
    "authorities" : [ "clients.read", "clients.write" ],
    "token_salt" : "tCZeCV",
    "allowedproviders" : [ "uaa", "ldap", "my-saml-provider" ],
    "name" : "My Client Name",
    "lastModified" : 1548439765963
  } ],
  "startIndex" : 1,
  "itemsPerPage" : 1,
  "totalResults" : 1,
  "schemas" : [ "http://cloudfoundry.org/schema/scim/oauth-clients-1.0" ]
}
```

### <a name='RetrieveClient'>Retrieve client</a>

```
GET /SASLogon/oauth/clients/dm13Sn
    Authorization: Bearer 4c24145d284840feb9e1d4e247dfee56
    Accept: application/json
```

`Response:`

```json
{
  "scope" : [ "clients.read", "clients.write" ],
  "client_id" : "dm13Sn",
  "resource_ids" : [ "none" ],
  "authorized_grant_types" : [ "client_credentials" ],
  "redirect_uri" : [ "http://ant.path.wildcard/**/passback/*", "http://test1.com" ],
  "autoapprove" : [ "true" ],
  "authorities" : [ "clients.read", "clients.write" ],
  "token_salt" : "KWIYYl",
  "allowedproviders" : [ "uaa", "ldap", "my-saml-provider" ],
  "name" : "My Client Name",
  "lastModified" : 1548439766817,
  "required_user_groups" : [ ]
}
```

### <a name='CreateClient'>Create client</a>

```
POST /SASLogon/oauth/clients
    Content-Type: application/json
    Authorization: Bearer 6eb2f4f9eeee48d4ac40c4c86509e3d7
    Accept: application/json
```

`Body:`

```json
{
  "scope" : [ "clients.read", "clients.write" ],
  "client_id" : "FYBc34",
  "client_secret" : "secret",
  "resource_ids" : [ ],
  "authorized_grant_types" : [ "client_credentials" ],
  "redirect_uri" : [ "http://test1.com", "http://ant.path.wildcard/**/passback/*" ],
  "authorities" : [ "clients.read", "clients.write" ],
  "token_salt" : "mOxTVD",
  "autoapprove" : true,
  "allowedproviders" : [ "uaa", "ldap", "my-saml-provider" ],
  "name" : "My Client Name"
}
```

`Response:`

```json
{
  "scope" : [ "clients.read", "clients.write" ],
  "client_id" : "FYBc34",
  "resource_ids" : [ "none" ],
  "authorized_grant_types" : [ "client_credentials" ],
  "redirect_uri" : [ "http://ant.path.wildcard/**/passback/*", "http://test1.com" ],
  "autoapprove" : [ "true" ],
  "authorities" : [ "clients.read", "clients.write" ],
  "token_salt" : "mOxTVD",
  "allowedproviders" : [ "uaa", "ldap", "my-saml-provider" ],
  "name" : "My Client Name",
  "lastModified" : 1548439765169,
  "required_user_groups" : [ ]
}
```

### <a name='UpdateClient'>Update client</a>

```
PUT /SASLogon/oauth/clients/P5yPMY
    Content-Type: application/json
    Authorization: Bearer 6eb2f4f9eeee48d4ac40c4c86509e3d7
    Accept: application/json
```

`Body:`

```json
{
  "scope" : [ "clients.new", "clients.autoapprove" ],
  "client_id" : "P5yPMY",
  "authorized_grant_types" : [ "client_credentials" ],
  "redirect_uri" : [ "http://redirect.url" ],
  "autoapprove" : [ "clients.autoapprove" ]
}
```

`Response:`

```json
{
  "scope" : [ "clients.new", "clients.autoapprove" ],
  "client_id" : "P5yPMY",
  "resource_ids" : [ "none" ],
  "authorized_grant_types" : [ "client_credentials" ],
  "redirect_uri" : [ "http://redirect.url" ],
  "autoapprove" : [ "clients.autoapprove" ],
  "authorities" : [ "clients.read", "clients.write" ],
  "token_salt" : "9UnUQG",
  "allowedproviders" : [ "uaa", "ldap", "my-saml-provider" ],
  "name" : "My Client Name",
  "lastModified" : 1548439762286,
  "required_user_groups" : [ ]
}
```

### <a name='ChangeSecret'>Change secret</a>

```
PUT /SASLogon/oauth/clients/1le3s6/secret
    Content-Type: application/json
    Authorization: Bearer 6eb2f4f9eeee48d4ac40c4c86509e3d7
    Accept: application/json
```

`Body:`

```json
{
  "clientId" : "1le3s6",
  "secret" : "new_secret"
}
```

`Response:`

```json
{
  "status" : "ok",
  "message" : "secret updated"
}
```

### <a name='DeleteClient'>Delete client</a>

```
DELETE /SASLogon/oauth/clients/8h4yGk
```

### <a name='ObtainTokenCreateClient'>Obtain token to create client</a>
Use a consul ACL token to obtain an OAuth access token that can be used to create a new client.

```
POST /SASLogon/oauth/clients/consul
    X-Consul-Token: 29c4700f-ea89-41cd-8bc4-4198ccaa5bf9
    Accept: application/json
```

`Response:`

```json
{
  "access_token" : "eyJhbGciOiJSUzI1NiIsImtpZCI6ImxlZ2FjeS10b2tlbi1rZXkiLCJ0eXAiOiJKV1QifQ.eyJqdGkiOiIzNTM4ZTQxNTEyNDY0NmU3YTJiZjA1NDBlNTM3MjNlNSIsInN1YiI6IjAzMzNiODlkLTc5MjUtNDllZS04N2Y3LTQ4YzY1Mzg2N2RlZCIsInNjb3BlIjpbIm9wZW5pZCIsImdyb3VwMSIsImdyb3VwMiIsImdyb3VwMyJdLCJjbGllbnRfaWQiOiJhcHAiLCJjaWQiOiJhcHAiLCJhenAiOiJhcHAiLCJncmFudF90eXBlIjoicGFzc3dvcmQiLCJ1c2VyX2lkIjoiMDMzM2I4OWQtNzkyNS00OWVlLTg3ZjctNDhjNjUzODY3ZGVkIiwib3JpZ2luIjoidWFhIiwidXNlcl9uYW1lIjoiYm9iIiwiZW1haWwiOiJub25lIiwiYXV0aF90aW1lIjoxNTIyMTY3MTY3LCJyZXZfc2lnIjoiOWEzYzI0ZWQiLCJpYXQiOjE1MjIxNjcxNjcsImV4cCI6MTUyMjIxMDM2NywiaXNzIjoiaHR0cHM6Ly9leGFtcGxlLnNhcy5jb20vU0FTTG9nb24vb2F1dGgvdG9rZW4iLCJ6aWQiOiJ1YWEiLCJhdWQiOlsiYXBwIiwib3BlbmlkIl19.EOpYXf5acyiTn1wY5Tjr9vdu5Ez_UyPnYriMPlR9DkDTPtxxphdCiQweMEx8bjevWmFhDV-m4MDFm9F551F36cyhkpaXq39Xu6My_iDdc-xdAMvm04PHhz6p2NDSjCrmg9L5remIK-WQDyN3klkKNQvuN2V8jklVoXVMj_bBgpg",
  "token_type" : "bearer",
  "expires_in" : 43199,
  "scope" : "uaa.admin",
  "jti" : "fd558f0226df43cfbe12e044e3ac1d45"
}
```

version 1, last updates 31 Jul, 2019
