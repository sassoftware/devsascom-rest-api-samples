#### Create, Read, Update, and Delete Drafts
##### Overview
This collection uses the Glossary API to create, read, update, and delete draft terms.

##### Variables to assign:
The Postman collection comes with variables that you must assign either at the collection or environment level. Assign values to the following variables prior to running the collection:
- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `username`
- `password`
Other variables are assigned programmatically during the REST calls using code in the Postman Tests tab.

##### Usage
1. Download the JSON collection and the sasserver.env file. Then Import the files into Postman.
2. Select sasserver.env as the environment. Edit your environment variables to match your collection requests.
3. Authenticate to your server before testing by running the first request: `0. Get Token`.

##### Endpoints Used
- [/glossary/termTypes](https://developer.sas.com/rest-apis/glossary/createTermType) - Create a Term Type
- [/glossary/terms?publish=true](https://developer.sas.com/rest-apis/glossary/createTerm) - Create a Term
- [/glossary/terms?publish=false](https://developer.sas.com/rest-apis/glossary/createTerm) - Create a Draft
- [/glossary/terms/{termId}/draft](https://developer.sas.com/rest-apis/glossary/createDraftFromTerm) - Create a Draft from a published Term
- [/glossary/terms/{termId}/draft/state](https://developer.sas.com/rest-apis/glossary/updatePublishDraft) - Publish a Draft by its ID
- [/glossary/terms/{termId}/draft](https://developer.sas.com/rest-apis/glossary/getDraft) - Get a Draft by its ID
- [/glossary/terms?allowDrafts=all](https://developer.sas.com/rest-apis/glossary/getTerms) - Get Drafts via filter
- [/glossary/terms/{termId}/draft](https://developer.sas.com/rest-apis/glossary/updateDraft) - Update a Draft by its ID
- [/glossary/terms/{termId}/draft](https://developer.sas.com/rest-apis/glossary/patchDraft) - Patch a Draft by its ID
- [/glossary/terms/{termId}/draft](https://developer.sas.com/rest-apis/glossary/deleteDraft) - Delete a Draft by its ID
- [/glossary/termTypes/{termTypeId}](https://developer.sas.com/rest-apis/glossary/deleteTermType) - Delete a Term Type by its ID

##### Supported Versions
- Viya 4

##### Additional Resources
