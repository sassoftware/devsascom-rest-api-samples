#### Term Use Cases
##### Overview
This program uses the Glossary and Catalog API to search, create, read, update, and delete terms.

##### Variables to assign:
- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `username`
- `password`

##### Packages and Python Version
- python 3
- requests, json

##### Usage
1. Download the Python program or the Jupyter Notebook file.
2. Edit the variables to match the environment.
3. Proceed to run the program or Notebook commands.

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
