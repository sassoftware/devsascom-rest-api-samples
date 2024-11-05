#### Import Term Use Cases
##### Overview
This program uses the Glossary and Catalog APIs to import terms from a CSV file and retrieve the log.

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
- [/glossary/importTerms](https://developer.sas.com/rest-apis/glossary/importTerms) - Create Terms by Importing CSV File
- [/glossary/terms/{termId}](https://developer.sas.com/rest-apis/glossary/getTerm) - Get a Term
- [/glossary/terms](https://developer.sas.com/rest-apis/glossary/getTerms) - Get Terms by Filter
- [/glossary/terms/{termId}](https://developer.sas.com/rest-apis/glossary/deleteTerm) - Delete a Term
- [/jobs/{jobId}](https://developer.sas.com/rest-apis/jobExecution-v7?operation=getJob) - Get Import Job
- [/files/{fileId}/content](https://developer.sas.com/rest-apis/files-v9?operation=getfileContentForGivenId) - Get Import Log

##### Supported Versions
- Viya 4

##### Additional Resources
