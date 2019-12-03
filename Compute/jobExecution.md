# Job Execution API
The Job Execution API is intended to provide a common mechanism for executing and managing asynchronous jobs across various environments. It works in conjunction with the Job Definitions API. You can use the Job Definitions API to create a definition for any existing Job Execution Provider, and then execute this definition using the Job Execution API.

## API Request Examples Grouped by Object Type
<details>
<summary>Root</summary>

* [Discover top level links for jobExecutions](#top-level-link)
</details>

<details>
<summary>Jobs</summary>

* [Get a list of jobs](#GetJobsList)
* [Submit a job definition for execution](#SubmitJobDefinition)
* [Check the state of execution](#CheckExecutionState)
* [Job cleanup](#JobCleanup)
* [Submit a job definition for execution after overriding job definition parameters](#SubmitJobDefinitionOverride)
</details>

<details>
<summary>Job Requests</summary>

* [Get a list of job requests](#JobRequestsList)
* [Persist a job request](#PersistJobRequest)
* [Submit a persisted job request for execution](#SubmitPersistedJobRequest)
* [Update a job request](#UpdateJobRequest)
* [Deleting a job request](DeleteJobRequest)
* [Persist a job request with an embedded job definition](#PersistJobRequestEmbeddedJobDefinition)
</details>

#### <a name='top-level-link'>Root Links</a>
The root resource can be used by an administrative program to use a Hypermedia As The Engine Of Application State (HATEOAS) approach to find the links to list jobs, list job requests, and execute jobs.

```
GET /jobExecution/
   Accept: application/vnd.sas.api+json
```

`Response:`

```json
{
    "version": 1,
    "links": [
        {
            "method": "GET",
            "rel": "jobs",
            "href": "/jobExecution/jobs",
            "uri": "/jobExecution/jobs",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.job.execution.job",
            "responseItemType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "POST",
            "rel": "create",
            "href": "/jobExecution/jobs",
            "uri": "/jobExecution/jobs",
            "type": "application/vnd.sas.job.execution.job.request",
            "responseType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "GET",
            "rel": "jobRequests",
            "href": "/jobExecution/jobRequests",
            "uri": "/jobExecution/jobRequests",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.job.execution.job.request"
        }
    ]
}
```

#### <a name='GetJobsRequestList'>Get a List of Jobs</a>
The administrative program can use the "jobs" rel link that it obtained from the root resource to display the list of system-defined jobs in a user interface.

```
GET /jobExecution/jobs
    Accept: application/vnd.sas.collection+json
```

`Response:`

The response is a standard collection of objects that are jobs.

#### <a name='JobRequestsList'>Get a List of Job Requests</a>
The administrative program can use the "jobRequests" rel link that it obtained from the root resource to display the list of system-defined job requests in a user interface.

```
GET /jobExecution/jobRequests
    Accept: application/vnd.sas.collection+json
```

`Response:`

The response is a standard collection of objects that are job requests.


#### <a name='SubmitJobDefinition'>Submit a Job Definition for Execution</a>
The Job Definition API is used to define jobs. The Job Execution API is used to execute those jobs. An application can create a Job Request to execute an existing Job Definition.

```
POST /jobExecution/jobs
    Content-Type: application/vnd.sas.job.execution.job.request+json
    Accept: application/vnd.sas.job.execution.job+json
```

`Body:`

```json
{
  "jobDefinitionUri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af"
}
```

This is the minimum that is needed in a Job Request (application/vnd.sas.job.execution.job.request) to submit the job for execution.

`Response:`

```json
{
    "creationTimeStamp": "2018-03-12T18:48:29.471Z",
    "modifiedTimeStamp": "2018-03-12T18:48:30.065Z",
    "createdBy": "omitest",
    "modifiedBy": "omitest",
    "version": 3,
    "id": "6efcf389-7d63-4929-b532-13be28460eea",
    "jobRequest": {
        "version": 3,
        "name": "proc print",
        "description": "ods output",
        "jobDefinitionUri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
        "jobDefinition": {
            "creationTimeStamp": "2018-03-12T18:46:31.665Z",
            "modifiedTimeStamp": "2018-03-12T18:46:31.666Z",
            "createdBy": "omitest",
            "modifiedBy": "omitest",
            "version": 2,
            "id": "aa3065a0-8ef6-42d1-965d-e77652aea7af",
            "name": "Simple proc print",
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
                    "href": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "uri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "type": "application/vnd.sas.job.definition"
                },
                {
                    "method": "PUT",
                    "rel": "update",
                    "href": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "uri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "type": "application/vnd.sas.job.definition",
                    "responseType": "application/vnd.sas.job.definition"
                },
                {
                    "method": "DELETE",
                    "rel": "delete",
                    "href": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "uri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af"
                }
            ],
            "properties": []
        },
        "arguments": {
            "_contextName": "SAS Job Execution compute context"
        },
        "properties": [],
        "createdByApplication": "jobExecution"
    },
    "state": "running",
    "submittedByApplication": "jobExecution",
    "heartbeatInterval": 0,
    "elapsedTime": 719,
    "results": {},
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "type": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "type": "application/vnd.sas.job.execution.job",
            "responseType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea"
        },
        {
            "method": "PUT",
            "rel": "updateState",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state",
            "type": "text/plain"
        },
        {
            "method": "POST",
            "rel": "updateHeartbeatTimeStamp",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/heartbeatTimeStamp",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/heartbeatTimeStamp",
            "type": "text/plain"
        },
        {
            "method": "GET",
            "rel": "jobDefinition",
            "href": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
            "uri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
            "type": "application/vnd.sas.job.definition"
        }
    ]
}
```
Providers run a job asynchronously, and if there were no errors in the request, the returned job (application/vnd.sas.job.execution.job) shows a state of "running."

#### <a name='CheckExecutionState'>Check the State of Execution</a>

After submitting the job, the client checks for execution completion by using the "state" link in the created job.

```
GET /jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state
    Accept: text/plain
```

`Response:`

```
completed
```

If the job has failed, the response would be "failed" and the error member would provide additional information.

Alternatively, you can use the "self" link to return the entire job and check the "state" member.

```
GET /jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea
    Accept: application/vnd.sas.job.execution.job+json
```

`Response:`

```json
{
    "creationTimeStamp": "2018-03-12T18:48:29.471Z",
    "modifiedTimeStamp": "2018-03-12T18:48:42.753Z",
    "createdBy": "omitest",
    "modifiedBy": "omitest",
    "version": 3,
    "id": "6efcf389-7d63-4929-b532-13be28460eea",
    "jobRequest": {
        "version": 3,
        "name": "proc print",
        "description": "ods output",
        "jobDefinitionUri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
        "jobDefinition": {
            "creationTimeStamp": "2018-03-12T18:46:31.665Z",
            "modifiedTimeStamp": "2018-03-12T18:46:31.666Z",
            "createdBy": "omitest",
            "modifiedBy": "omitest",
            "version": 2,
            "id": "aa3065a0-8ef6-42d1-965d-e77652aea7af",
            "name": "Simple proc print",
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
                    "href": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "uri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "type": "application/vnd.sas.job.definition"
                },
                {
                    "method": "PUT",
                    "rel": "update",
                    "href": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "uri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "type": "application/vnd.sas.job.definition",
                    "responseType": "application/vnd.sas.job.definition"
                },
                {
                    "method": "DELETE",
                    "rel": "delete",
                    "href": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
                    "uri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af"
                }
            ],
            "properties": []
        },
        "arguments": {
            "_contextName": "SAS Job Execution compute context"
        },
        "properties": [],
        "createdByApplication": "jobExecution"
    },
    "state": "completed",
    "endTimeStamp": "2018-03-12T18:48:42.753Z",
    "submittedByApplication": "jobExecution",
    "heartbeatInterval": 0,
    "elapsedTime": 13282,
    "results": {
        "COMPUTE_CONTEXT": "SAS Job Execution compute context",
        "sashtml.htm": "/files/files/4908deb5-1b61-4473-a54a-aa02710b611b",
        "D4363A55-6BC1-1C49-B559-8CFFC570DCF3.log.txt": "/files/files/96fb540c-b6be-4fc0-b2c1-3dbb5a3873f4",
        "D4363A55-6BC1-1C49-B559-8CFFC570DCF3.list": "/files/files/f5e9d616-ad1b-49cf-a96c-26d2d2bfb567",
        "COMPUTE_JOB": "D4363A55-6BC1-1C49-B559-8CFFC570DCF3",
        "D4363A55-6BC1-1C49-B559-8CFFC570DCF3.list.txt": "/files/files/fcc792d1-bb57-4456-89fe-651c94d9f536",
        "COMPUTE_SESSION": "53cd7934-767d-4823-8fd0-24f0fe9af953-ses0000 Ended."
    },
    "logLocation": "/files/files/3303a3eb-2a6c-4123-9f9b-7d20993edd2b",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "type": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "type": "application/vnd.sas.job.execution.job",
            "responseType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea"
        },
        {
            "method": "PUT",
            "rel": "updateState",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/state",
            "type": "text/plain"
        },
        {
            "method": "POST",
            "rel": "updateHeartbeatTimeStamp",
            "href": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/heartbeatTimeStamp",
            "uri": "/jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea/heartbeatTimeStamp",
            "type": "text/plain"
        },
        {
            "method": "GET",
            "rel": "jobDefinition",
            "href": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
            "uri": "/jobDefinitions/definitions/aa3065a0-8ef6-42d1-965d-e77652aea7af",
            "type": "application/vnd.sas.job.definition"
        },
        {
            "method": "GET",
            "rel": "log",
            "href": "/files/files/3303a3eb-2a6c-4123-9f9b-7d20993edd2b",
            "uri": "/files/files/3303a3eb-2a6c-4123-9f9b-7d20993edd2b"
        }
    ]
}
```
#### Examining Results
Once execution has "completed", various execution artifacts can be obtained from the "results" member of the returned job (application/vnd.sas.job.execution.job). The items returned in the "results" map are **provider specific**. A log, if available, can be obtained from the "logLocation" member of the job.

#### <a name='JobCleanup'>Job Cleanup</a>
If the Job Request (application/vnd.sas.job.execution.job.request) is submitted without an "expiresAfter" setting, it is the client's responsibility to delete the job from the system when it is no longer needed. A delete request can be issued using the "delete" link.

```
DELETE /jobExecution/jobs/6efcf389-7d63-4929-b532-13be28460eea
```

#### Submit a Job Definition for Execution After Overriding Job Definition Parameters and using the submitter query parameter
A job definition uses default values to control execution, and this request overrides some or all of those. In this example, the following request overrides the "AGE" argument defined in the previous Job Definition.  This request is submitted in the workflow
 application and it uses the submitter query parameter since it monitors job state change events from itself.

```
POST /jobExecution/jobs?submitter=workflow
    Content-Type: application/vnd.sas.job.execution.job.request+json
    Accept: application/vnd.sas.job.execution.job+json
```

`Body:`

```json
{
  "name": "proc print example",
  "description": "ods output with age 14 cutoff",
  "jobDefinitionUri": "/jobDefinitions/definitions/2cbe5f60-1391-42db-a857-271e83eb7e48",
  "arguments" : {"AGE" : "14"}
}
```

The "name" and "description" members, not previously used, are optional. The "arguments" contain name-value pairs, which override values of similarly named parameters in the Job Definition, if they exist.

`Response:`

```json
{
    "creationTimeStamp": "2018-03-12T19:21:15.877Z",
    "modifiedTimeStamp": "2018-03-12T19:21:16.105Z",
    "createdBy": "omitest",
    "modifiedBy": "omitest",
    "version": 3,
    "id": "f9dbe76c-1a13-491e-b1e4-eda2219a2320",
    "jobRequest": {
        "version": 3,
        "name": "proc print example",
        "description": "ods output with age 14 cutoff",
        "jobDefinitionUri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
        "jobDefinition": {
            "creationTimeStamp": "2018-03-12T19:20:22.136Z",
            "modifiedTimeStamp": "2018-03-12T19:20:22.136Z",
            "createdBy": "omitest",
            "modifiedBy": "omitest",
            "version": 2,
            "id": "dabd2a63-ae2f-4559-b110-ad989ff642a5",
            "name": "Simple proc print",
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
                    "href": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "uri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "type": "application/vnd.sas.job.definition"
                },
                {
                    "method": "PUT",
                    "rel": "update",
                    "href": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "uri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "type": "application/vnd.sas.job.definition",
                    "responseType": "application/vnd.sas.job.definition"
                },
                {
                    "method": "DELETE",
                    "rel": "delete",
                    "href": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "uri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5"
                }
            ],
            "properties": []
        },
        "arguments": {
            "_contextName": "SAS Job Execution compute context",
            "AGE": "14"
        },
        "properties": [],
        "createdByApplication": "jobExecution"
    },
    "state": "running",
    "submittedByApplication": "workflow",
    "heartbeatInterval": 0,
    "elapsedTime": 546,
    "results": {},
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320",
            "uri": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320",
            "type": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320/state",
            "uri": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320/state",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320",
            "uri": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320",
            "type": "application/vnd.sas.job.execution.job",
            "responseType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320",
            "uri": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320"
        },
        {
            "method": "PUT",
            "rel": "updateState",
            "href": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320/state",
            "uri": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320/state",
            "type": "text/plain"
        },
        {
            "method": "POST",
            "rel": "updateHeartbeatTimeStamp",
            "href": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320/heartbeatTimeStamp",
            "uri": "/jobExecution/jobs/f9dbe76c-1a13-491e-b1e4-eda2219a2320/heartbeatTimeStamp",
            "type": "text/plain"
        },
        {
            "method": "GET",
            "rel": "jobDefinition",
            "href": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
            "uri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
            "type": "application/vnd.sas.job.definition"
        }
    ]
}
```

#### <a name='PersistJobRequest'>Persist a Job Request</a>
Job Requests can also be persisted for later use. For example, it can be used in the Scheduler.  In the example below,
the requested is created by the hypothetical "jobrequestui" web app.

```
POST /jobExecution/jobRequests
    Content-Type: application/vnd.sas.job.execution.job.request+json
    Accept: application/vnd.sas.job.execution.job.request+json
```

`Body:`

```json
{
  "name": "sashelp class distribution",
  "description": "ods output with age 14 cutoff",
  "jobDefinitionUri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
  "arguments" : {"AGE" : "14"},
  "createdByApplication" : "jobrequestui"
}
```

`Response:`

```json
{
    "creationTimeStamp": "2018-03-12T19:37:28.318Z",
    "modifiedTimeStamp": "2018-03-12T19:37:28.318Z",
    "createdBy": "omitest",
    "modifiedBy": "omitest",
    "version": 3,
    "id": "f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
    "name": "sashelp class distribution",
    "description": "ods output with age 14 cutoff",
    "jobDefinitionUri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
    "arguments": {
        "AGE": "14",
        "_contextName": "SAS Job Execution compute context"
    },
    "properties": [],
    "createdByApplication": "jobrequestui",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "GET",
            "rel": "export",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.transfer.object"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "PUT",
            "rel": "import",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.transfer.object",
            "responseType": "application/vnd.sas.summary"
        },
        {
            "method": "GET",
            "rel": "up",
            "href": "/jobExecution/jobRequests",
            "uri": "/jobExecution/jobRequests",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "GET",
            "rel": "jobs",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "POST",
            "rel": "submitJob",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs",
            "responseType": "application/vnd.sas.job.execution.job"
        }
    ]
}
```

#### <a name='SubmitPersistedJobRequest'>Submit a Persisted Job Request for Execution</a>
A persisted job request can be executed by using the "submitJob" link with no body.  Note: since there is no submitter query parameter
on the request, the value from the createdByApplication is used for the submittedByApplication in the JobRequest.

```
POST /jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs
    Accept: application/vnd.sas.job.execution.job+json
```

`Response:`

```json
{
    "creationTimeStamp": "2018-03-12T19:40:55.902Z",
    "modifiedTimeStamp": "2018-03-12T19:40:56.050Z",
    "createdBy": "omitest",
    "modifiedBy": "omitest",
    "version": 3,
    "id": "af14392d-98b6-4a75-b27a-7633bb288cb5",
    "jobRequest": {
        "creationTimeStamp": "2018-03-12T19:37:28.318Z",
        "modifiedTimeStamp": "2018-03-12T19:37:28.318Z",
        "createdBy": "omitest",
        "modifiedBy": "omitest",
        "version": 3,
        "id": "f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
        "name": "sashelp class distribution",
        "description": "ods output with age 14 cutoff",
        "jobDefinitionUri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
        "jobDefinition": {
            "creationTimeStamp": "2018-03-12T19:20:22.136Z",
            "modifiedTimeStamp": "2018-03-12T19:20:22.136Z",
            "createdBy": "omitest",
            "modifiedBy": "omitest",
            "version": 2,
            "id": "dabd2a63-ae2f-4559-b110-ad989ff642a5",
            "name": "Simple proc print",
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
                    "href": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "uri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "type": "application/vnd.sas.job.definition"
                },
                {
                    "method": "PUT",
                    "rel": "update",
                    "href": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "uri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "type": "application/vnd.sas.job.definition",
                    "responseType": "application/vnd.sas.job.definition"
                },
                {
                    "method": "DELETE",
                    "rel": "delete",
                    "href": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
                    "uri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5"
                }
            ],
            "properties": []
        },
        "arguments": {
            "_contextName": "SAS Job Execution compute context",
            "AGE": "14"
        },
        "properties": [],
        "createdByApplication": "jobrequestui",
        "links": [
            {
                "method": "GET",
                "rel": "self",
                "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
                "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
                "type": "application/vnd.sas.job.execution.job.request"
            }
        ]
    },
    "state": "running",
    "submittedByApplication": "jobrequestui",
    "heartbeatInterval": 0,
    "elapsedTime": 174,
    "results": {},
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5",
            "uri": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5",
            "type": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5/state",
            "uri": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5/state",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5",
            "uri": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5",
            "type": "application/vnd.sas.job.execution.job",
            "responseType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5",
            "uri": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5"
        },
        {
            "method": "PUT",
            "rel": "updateState",
            "href": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5/state",
            "uri": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5/state",
            "type": "text/plain"
        },
        {
            "method": "POST",
            "rel": "updateHeartbeatTimeStamp",
            "href": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5/heartbeatTimeStamp",
            "uri": "/jobExecution/jobs/af14392d-98b6-4a75-b27a-7633bb288cb5/heartbeatTimeStamp",
            "type": "text/plain"
        },
        {
            "method": "GET",
            "rel": "jobRequest",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "GET",
            "rel": "jobDefinition",
            "href": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
            "uri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
            "type": "application/vnd.sas.job.definition"
        }
    ]
}
```
At this point, the process of checking the completion state and obtaining results is no different from using the /jobExecution/jobs endpoint to submit a job.

#### <a name='UpdateJobRequest'>Update a Job Request</a>
This example shows how to update job requests. This requires a full replacement with the ETag specified in the header.

```
PUT /jobExecution/jobRequests/8e56d90e-3dfc-4827-83ab-7e3e1f9f5844
    Content-Type: application/vnd.sas.job.execution.job.request+json
    Accept: application/vnd.sas.job.execution.job.request+json
    If-Match: "jeomqj9a"
```

`Body:`

```json
{
  "id" : "{{JOBREQID}}",
  "name": "sashelp.class distribution",
  "description": "ods output with age 14 cutoff",
  "jobDefinitionUri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
  "arguments" : {"AGE" : "14"}
}
```

`Response:`

```json
{
    "creationTimeStamp": "2018-03-12T19:37:28.318Z",
    "modifiedTimeStamp": "2018-03-12T19:51:07.178Z",
    "createdBy": "omitest",
    "modifiedBy": "omitest",
    "version": 3,
    "id": "f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
    "name": "sashelp.class distribution",
    "description": "ods output with age 14 cutoff",
    "jobDefinitionUri": "/jobDefinitions/definitions/dabd2a63-ae2f-4559-b110-ad989ff642a5",
    "arguments": {
        "_contextName": "SAS Job Execution compute context",
        "AGE": "14"
    },
    "properties": [],
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "GET",
            "rel": "export",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.transfer.object"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "PUT",
            "rel": "import",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b",
            "type": "application/vnd.sas.transfer.object",
            "responseType": "application/vnd.sas.summary"
        },
        {
            "method": "GET",
            "rel": "up",
            "href": "/jobExecution/jobRequests",
            "uri": "/jobExecution/jobRequests",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "GET",
            "rel": "jobs",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "POST",
            "rel": "submitJob",
            "href": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs",
            "uri": "/jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b/jobs",
            "responseType": "application/vnd.sas.job.execution.job"
        }
    ]
}
```

#### <a name='DeleteJobRequest'>Deleting a Job Request</a>
If a job is no longer needed, a Job Request can be deleted using the "delete" link.

```
DELETE /jobExecution/jobRequests/f9c52f58-9639-45ae-b24c-23cfff0b2f5b
```

#### <a name='PersistJobRequestEmbeddedJobDefinition'>Persist a Job Request with an embedded Job Definition</a>
The previously illustrated example used a persisted Job Definition which was referred to in the Job Request using the "jobDefinitionUri" attribute.  Job Definitions can also be embedded in a Job Request using the "jobDefinition" attribute.

```
POST /jobExecution/jobRequests
    Content-Type: application/vnd.sas.job.execution.job.request+json
    Accept: application/vnd.sas.job.execution.job.request+json
```

`Body:`

```json
{
  "name": "proc print",
  "description": "ods output",
  "jobDefinition": {
	"version":1,
	"name":"Simple proc print",
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
}
```

`Response:`

```json
{
    "creationTimeStamp": "2018-06-19T19:37:00.666Z",
    "modifiedTimeStamp": "2018-06-19T19:37:00.666Z",
    "createdBy": "idbweb1",
    "modifiedBy": "idbweb1",
    "version": 3,
    "id": "2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
    "name": "proc print",
    "description": "ods output",
    "jobDefinition": {
        "version": 1,
        "name": "Simple proc print",
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
        "properties": []
    },
    "arguments": {
        "_contextName": "SAS Job Execution compute context"
    },
    "properties": [],
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "uri": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "type": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "GET",
            "rel": "alternate",
            "href": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "uri": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "type": "application/vnd.sas.summary"
        },
        {
            "method": "GET",
            "rel": "export",
            "href": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "uri": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "type": "application/vnd.sas.transfer.object"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "uri": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "uri": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "type": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "PUT",
            "rel": "import",
            "href": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "uri": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9",
            "type": "application/vnd.sas.transfer.object",
            "responseType": "application/vnd.sas.summary"
        },
        {
            "method": "GET",
            "rel": "up",
            "href": "/jobExecution/jobRequests",
            "uri": "/jobExecution/jobRequests",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.job.execution.job.request"
        },
        {
            "method": "GET",
            "rel": "jobs",
            "href": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9/jobs",
            "uri": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9/jobs",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "POST",
            "rel": "submitJob",
            "href": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9/jobs",
            "uri": "/jobExecution/jobRequests/2885d9c5-bc1d-4cdf-8ac5-c92a98a016e9/jobs",
            "responseType": "application/vnd.sas.job.execution.job"
        }
    ]
}
```


version 5, last updated 26 Nov, 2019
