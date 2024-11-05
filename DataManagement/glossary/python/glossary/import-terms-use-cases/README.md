#### Import Term Use Cases
##### Overview
This program uses the Glossary and Catalog APIs to import terms from a CSV file and retrieve the log.

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
- [/glossary/importTerms](https://developer.sas.com/rest-apis/glossary/importTerms) - Create Terms by Importing CSV File
- [/glossary/terms/{termId}](https://developer.sas.com/rest-apis/glossary/getTerm) - Get a Term
- [/glossary/terms](https://developer.sas.com/rest-apis/glossary/getTerms) - Get Terms by Filter
- [/glossary/terms/{termId}](https://developer.sas.com/rest-apis/glossary/deleteTerm) - Delete a Term
- [/jobs/{jobId}](https://developer.sas.com/rest-apis/jobExecution-v7?operation=getJob) - Get Import Job
- [/files/{fileId}/content](https://developer.sas.com/rest-apis/files-v9?operation=getfileContentForGivenId) - Get Import Log

##### Supported Versions
- Viya 4

##### Additional Resources
