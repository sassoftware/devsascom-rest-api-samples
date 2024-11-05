#### Create, Read, Update, and Delete Term Types
##### Overview
This program leverages the Glossary API to create, read, update, and delete term types.

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
- [/glossary/termTypes] (https://developer.sas.com/rest-apis/glossary/getTermTypes) - Get Term Types via filter
- [/glossary/termTypes] (https://developer.sas.com/rest-apis/glossary/createTermType) - Create a Term Type
- [/glossary/termTypes/{termTypeId}] (https://developer.sas.com/rest-apis/glossary/getTermType) - Get a Term Type by its ID
- [/glossary/termTypes/{termTypeId}] (https://developer.sas.com/rest-apis/glossary/updateTermType) - Update a Term Type by its ID
- [/glossary/termTypes/{termTypeId}] (https://developer.sas.com/rest-apis/glossary/deleteTermType) - Delete a Term Type by its ID

##### Supported Versions
- Viya 4

##### Additional Resources
