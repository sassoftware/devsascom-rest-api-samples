#### Term Use Cases
##### Overview
This program uses the Glossary and Catalog API to search, create, read, update, and delete terms.

##### Variables to assign:
The Postman collection comes with variables that you must assign either at the collection or environment level. Assign values to the following variables prior to running the collection:
- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `username`
- `password`
Other variables are assigned programmatically during the REST calls using code in the Postman Tests tab.

##### Usage
1. Download the JSON collection and the sasserver.env. Import the files into Postman.
2. Select sasserver.env as the environment. Edit your environment variables to match those contained in the collection requests (sasserver, access_token).
3. Authenticate to your server before testing the endpoints by running the first request: `0. Get token`.

##### Endpoints Used
- [/glossary/termTypes](https://developer.sas.com/rest-apis/glossary/createTermType) - Create a Term Type
- [/glossary/termTypes/{termTypeId}](https://developer.sas.com/rest-apis/glossary/deleteTermType) - Delete a Term Type
- [/glossary/terms](https://developer.sas.com/rest-apis/glossary/createTerm) - Create a Term
- [/glossary/terms/{termId}](https://developer.sas.com/rest-apis/glossary/getTerm) - Get a Term by its ID
- [/glossary/terms](https://developer.sas.com/rest-apis/glossary/getTerms) - Get a Term by Filter
- [/glossary/terms/{termId}](https://developer.sas.com/rest-apis/glossary/updateTerm) - Update a Term by its ID
- [/glossary/terms/{termId}](https://developer.sas.com/rest-apis/glossary/patchTerm) - Patch a Term by its ID
- [/glossary/terms/{termId}](https://developer.sas.com/rest-apis/glossary/deleteTerm) - Delete a Term by its ID
- [/catalog/search](https://developer.sas.com/rest-apis/catalog/getSearchResults) -Search for Terms
- [/catalog/instances](https://developer.sas.com/rest-apis/catalog/createInstance) - Create an Instance
- [/catalog/instances/{instanceId}](https://developer.sas.com/rest-apis/catalog/deleteInstance) - Delete an Instance

##### Supported Versions
- Viya 4

##### Additional Resources
