#### Create, Read, Update, and Delete Drafts
##### Overview
This program uses the Glossary API to create, read, update, and delete draft terms.

##### Variables to assign:
- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `username`
- `password`

##### Packages and Python Version
- python 3
- requests, json

##### Usage
1. Download the Python program or the Jupyter Notebook file.
2. Edit your variables to match your environment.
3. Proceed to run the program or Notebook commands.

##### Endpoints Used
- [/glossary/termTypes](https://developer.sas.com/rest-apis/glossary/createTermType) - Create a Term Type
- [/glossary/terms?publish=true](https://developer.sas.com/rest-apis/glossary/createTerm) - Create a Term
- [/glossary/terms?publish=false](https://developer.sas.com/rest-apis/glossary/createTerm) - Create a Draft
- [/glossary/terms/{termId}/draft](https://developer.sas.com/rest-apis/glossary/createDraftFromTerm) - Create a Draft from a Term
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
