#### Create, Read, Update, and Delete Term Types
##### Overview
This collection leverages the Glossary API to create, read, update, and delete term types.

##### Variables to assign:
The Postman collection comes with variables that you must assign either at the collection or environment level. Assign values to the following variables prior to running the collection:
- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `username`
- `password`
Other variables are assigned programmatically during the REST calls using code in the Postman Tests tab.

##### Usage
1. Download the JSON collection and the sasserver.env file. Then import the files into Postman.
2. Select sasserver.env as the environment. Edit your environment variables to match those contained in the collection requests (sasserver, username, password).
3. Authenticate to your server before testing the endpoints by running the first request: `0. Get token`.

##### Endpoints Used
- [/glossary/termTypes] (https://developer.sas.com/rest-apis/glossary/getTermTypes) - Get Term Types via filter
- [/glossary/termTypes] (https://developer.sas.com/rest-apis/glossary/createTermType) - Create a Term Type
- [/glossary/termTypes/{termTypeId}] (https://developer.sas.com/rest-apis/glossary/getTermType) - Get a Term Type by its ID
- [/glossary/termTypes/{termTypeId}] (https://developer.sas.com/rest-apis/glossary/updateTermType) - Update a Term Type by its ID
- [/glossary/termTypes/{termTypeId}] (https://developer.sas.com/rest-apis/glossary/deleteTermType) - Delete a Term Type by its ID

##### Supported Versions
- Viya 4

##### Additional Resources
