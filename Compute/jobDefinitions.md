# Job Definitions API
The Job Definitions API manages jobs using the create, read, update, and delete operations. A Job Definition is a batch execution that contains a list of input parameters, a job type, and a "code" attribute. A job definition can run in multiple execution environments,
based on the type of the job.  Possible types might include "cas", "compute", or "rest".  The "code" for a job definition
depends on the job definition type.  For example, for a job of type "compute", the code is SAS code; and
for a job of type "rest", the code is an UnRAVL script.

## API Request Examples

* [Discover top level links for jobDefinitions](#top-level-link)
* [Get a List of job definitions](#GetJobDefinitions)
* [Create a job definition](#CreateJobDefinition)
* [Update a job definition](#UpdateJobDefinition)
* [Delete a job definition](#DeleteJobDefinition)

#### <a name='top-level-link'>Get API Links for Root Resource</a>
Example: Using a HATEOS approach, find the link that returns the
list of job definitions that is defined in the system.

```
GET /jobDefinitions/
   Accept: application/vnd.sas.api+json
```

`Response:`

```json
{
    "version": 1,
    "links": [
        {
            "method": "GET",
            "rel": "job-definitions",
            "href": "/jobDefinitions/definitions",
            "uri": "/jobDefinitions/definitions",
            "type": "application/vnd.sas.collection"
        }
    ]
}
```

#### <a name='GetJobDefinitions'>Get a List of Job Definitions</a>
Example: Using the link obtained from the previous example, the administrative type program
gets the list of job definitions that is defined in the system to display in a UI.

```
GET /jobDefinitions/definitions
    Accept: application/vnd.sas.collection+json
```

#### <a name='CreateJobDefinition'>Create a Job Definition</a>
Example: A user that is using the administrative program needs to create a job definition to run on a SAS Compute server.  The response contains the ID of the newly created job.  This ID is used for updates or Delete operations on this job.

```
POST /jobDefinitions/definitions
    Content-Type: application/vnd.sas.job.definition+json
    Accept: application/vnd.sas.job.definition+json
```

`Body:`

```json
{
  "version":2,
  "name":"Simple proc print",
  "description":"Show the contents of sashelp.class using PROC PRINT",
  "type":"Compute",
  "parameters":[
        {
        "version": 1,
        "name": "_contextName",
        "defaultValue": "SAS Job Execution compute context",
        "type": "CHARACTER",
        "label": "Context Name",
        "required": false
    }
  ],
  "code":"ods html style=HTMLBlue;\nproc print data=sashelp.class; run; quit;\nods html close;"
}
```

`Response:`

```json
{
    "creationTimeStamp": "2018-03-16T13:39:58.210Z",
    "modifiedTimeStamp": "2018-03-16T13:39:58.211Z",
    "createdBy": "omitest",
    "modifiedBy": "omitest",
    "version": 2,
    "id": "35d7b64c-bd29-4a28-9d16-94d897224487",
    "name": "Simple proc print",
    "description": "Show the contents of sashelp.class using PROC PRINT",
    "type": "Compute",
    "parameters": [
        {
            "version": 1,
            "name": "_contextName",
            "defaultValue": "SAS Job Execution compute context",
            "type": "CHARACTER",
            "label": "Context Name",
            "required": false
        }
    ],
    "code": "ods html style=HTMLBlue;\nproc print data=sashelp.class; run; quit;\nods html close;",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "uri": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "type": "application/vnd.sas.job.definition"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "uri": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "type": "application/vnd.sas.job.definition",
            "responseType": "application/vnd.sas.job.definition"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "uri": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487"
        }
    ],
    "properties": []
}
```

#### <a name='UpdateJobDefinition'>Update a Job Definition</a>
Example: The user needs to modify the SAS code in the job just created to enable filtering by AGE and add a second parameter in the Job definition for AGE.  Since the API supports conditional PUT based on ETags, an If-Match header with the ETag must be present in the PUT request to modify the job.

```
PUT /jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487
    Content-Type: application/vnd.sas.job.definition+json
    Accept: application/vnd.sas.job.definition+json
    If-Match: "jetzq6wz"
```

`Body:`

```json
  "version":2,
  "id": "35d7b64c-bd29-4a28-9d16-94d897224487",
  "name":"Proc print with AGE filter",
  "description": "Show the contents of sashelp.class using PROC PRINT and filtering by AGE.",
  "type":"Compute",
  "parameters":[
        {
        "version": 1,
        "name": "_contextName",
        "defaultValue": "SAS Job Execution compute context",
        "type": "CHARACTER",
        "label": "Context Name",
        "required": false
        },
        {
        "version": 1,
        "name": "AGE",
        "defaultValue": "10",
        "type": "NUMERIC",
        "label": "Lowest age for report",
        "required": false
        }
  ],
  "code":"ods html style=HTMLBlue;\nproc print data=sashelp.class; where age > &AGE; run; quit;\nods html close;"
}
```

`Response:`

```json
{
    "creationTimeStamp": "2018-03-16T13:39:58.210Z",
    "modifiedTimeStamp": "2018-03-16T13:47:45.397Z",
    "createdBy": "omitest",
    "modifiedBy": "omitest",
    "version": 2,
    "id": "35d7b64c-bd29-4a28-9d16-94d897224487",
    "name": "Proc print with AGE filter",
    "description": "Show the contents of sashelp.class using PROC PRINT and filtering by AGE.",
    "type": "Compute",
    "parameters": [
        {
            "version": 1,
            "name": "_contextName",
            "defaultValue": "SAS Job Execution compute context",
            "type": "CHARACTER",
            "label": "Context Name",
            "required": false
        },
        {
            "version": 1,
            "name": "AGE",
            "defaultValue": "10",
            "type": "NUMERIC",
            "label": "Lowest age for report",
            "required": false
        }
    ],
    "code": "ods html style=HTMLBlue;\nproc print data=sashelp.class; where age > &AGE; run; quit;\nods html close;",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "uri": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "type": "application/vnd.sas.job.definition"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "uri": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "type": "application/vnd.sas.job.definition",
            "responseType": "application/vnd.sas.job.definition"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487",
            "uri": "/jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487"
        }
    ],
    "properties": []
}
```

#### <a name='DeleteJobDefinition'>Delete a Job Definition</a>
Example: The user no longer needs the job and decides to delete it.

```
DELETE /jobDefinitions/definitions/35d7b64c-bd29-4a28-9d16-94d897224487
```

version 2, last updated 26 Nov, 2019