# Append-Table Postman collection

The postman collection in append-table.postman_collection.json contains the steps to load, append, and save a data table in SAS Viya using Cloud Analytics Services (CAS) REST APIs.

The collection uses OAuth2 to connect to SAS Viya. The collections uses pre and post request scripts to get an access token. Several variables are used as well. You should have the following variables created in your Postman environment:

| Token | Description |
| -------- | -------------- |
| token_url | endpoint for the authentiction server |
| encoded_id_secret | base64 encoded clientid:clientsecret |
| OAUTH_USERNAME | username used for authentication |
| OAUTH_PASSWORD | password used for authentication |
| sasserver | SAS Viya server | 

Other variables will be created during the execution of the collection. It is not required that these exist prior to beginning.