# Text Parsing API
Parsing is a key operation in understanding your data. Parsing a document
involves the following analyses:

* Identifying terms used in the document
* Recognizing parts of speech for each term
* Identifying which terms are entities (person, country, and so on)
* Resolving synonyms, misspellings, and so on

The output tables that are generated during parsing can also be used in downstream analyses such as topic generation.

This service provides two different interactions for parsing: parsing documents in CAS tables and parsing documents that are 
uploaded directly into the API. In both cases, the service uses an asynchronous execution model. The client creates an analysis
job that runs in the background after the Create operation returns. The API provides resource endpoints for checking the state of the job. Then, when
it is complete, you retrieve the results by using either the `/results` endpoint on the job or by interacting with the result table
directly. To interact with the results table directly you use another API, such as the Row Sets API.

When parsing documents in a table, the service views each row in the input table as a document. Thus, the API
requires two input parameters: `documentIdVariable` and `textVariable`. The `documentIdVariable` is a unique identifier for the 
document and the `textVariable` is the actual document text. For example, consider a table containing tweets from @SASSoftware:

| ID                 | Date Created                   | Message            |
|--------------------|--------------------------------|--------------------|
| 850007368138018817 | Thu Apr 06 15:28:43 +0000 2017 | Real-time and #AI are changing marketing: join 9/13 #SASWebinar with special guest from @Forrester |
| 787452347508998458 | Thu Apr 06 12:54:02 +0000 2017 | US has over 4 million miles of roads that could have 10 million fully or semi autonomous cars by 2020 #IoT |
| 774598598680208850 | Thu Apr 06 12:28:22 +0000 2017 | Need help with your fight against #fraud? |

In this example, the `documentIdVariable` would be ID and the `textVariable` would be Message.

One of the values the API takes as input is a `language` parameter. For English, the `language` parameter must take the form of `en`
(<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes" target="_blank">ISO-639-1 short codes</a>  for English). The `language` parameter is used to 
select the linguistic binaries that are used to parse documents.

The API also takes optional `startListUri`, `stopListUri`, and `synonymListUri` input table URIs.  If neither a `startListUri`
nor `stopListUri` is provided and the specified language has an associated default stop list, then this stop list is used.  Only
one of these two tables can be provided for a single job. 


## API Request Examples Grouped by Object Type

<details>
<summary>Root</summary>

* [Discover top-level links for the text parsing API](#top-level-api)
</details>

<details>
<summary>Jobs</summary>

* [Start a job using data in a table](#StartJobUsingTableData)
* [Start a job using inline data](#StartJobUsingInlineData)
* [Get information about all jobs](#GetInfoAllJobs)
* [Get information about a job by job ID](#GetInfoByJobID)
* [Get the state of a specific job](#GetStateSpecificJob)
* [Get the log as text for a specific job](#GetJobLogText)
* [Get the log as a formatted collection for a specific job](#GetFormattedCollectionJobLog)
* [Get the errors for a specific job](#GetJobErrors)
* [Get the results for a specific job](#GetJobResults)
* [Delete a job](#DeleteJob)
</details>


### <a name='top-level-api'>Discover Top-Level Links for the Text Parsing API</a>
Here is an example of a  call that retrieves the application/vnd.sas.api+json representation of the APIs top-level links.

* The available links (as per [Resources: Root](#Root)) are `"jobs"` and `"startParsing"`.

```json
{
  "version": 1,
  "links": [
    {
      "method": "GET",
      "rel": "jobs",
      "href": "/parsing/jobs",
      "uri": "/parsing/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "POST",
      "rel": "startParsing",
      "href": "/parsing/jobs",
      "uri": "/parsing/jobs",
      "type": "application/vnd.sas.text.parsing.job.request",
      "responseType": "application/vnd.sas.text.parsing.job"
    }
  ]
}
```


### <a name='StartJobUsingTableData'>Start a Job by Using Data in a Table</a>
Here is an example of a call that uses the POST method to submit a job request to the service.

* The request body contains the configuration information of the job, including the location of the input data.
* The `Content-Type` header is `application/vnd.sas.text.concepts.job.request+json`.
* A separate operation is available to submit a job to conceptualize documents in the request, see [createJobByDocuments](#op:createJobByDocuments).
* The response code is 202 (Accepted for processing), and the response body is a JSON representation of the job containing HATEOAS links.
* The API representation contains `self`, `delete`, `state`, `log`, and `caslib` links as  described in [Resources: Jobs](#Jobs). 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and the results are available.

```json
{
  "version": 2,
  "language": "en",
  "includeStandardEntities": false,
  "includeNounGroups": true,
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/table",
  "documentIdVariable": "id",
  "textVariable": "reviewbody",
  "enableSpellChecking": false,
  "id": "f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
  "state": "pending",
  "creationTimeStamp": "2017-09-08T19:26:42.472Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "type": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state?value=canceled",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state?value=canceled"
    },
    {
      "method": "GET",
      "rel": "caslib",
      "href": "/casManagement/servers/cas/caslibs/lib",
      "uri": "/casManagement/servers/cas/caslibs/lib",
      "type": "application/vnd.sas.cas.caslib"
    }
  ]
}
```


### <a name='StartJobUsingInlineData'>Start a Job by Using Inline Data</a>
Here is an example of a call that uses the POST method to submit a job request to the service.

* The request body contains the configuration information of the job, including where to store the input data and the text documents to conceptualize.
* The `Content-Type` header is `application/vnd.sas.text.concepts.job.request.documents+json`.
* A separate operation is available that submits a job to conceptualize documents in a table. See [createJobByTable](#op:createJobByTable).
* The response code is 202 (Accepted for processing), and the response body is a JSON representation of the job containing HATEOAS links.
* The API representation contains `self`, `delete`, `state`, `log`, and `caslib` links as described in [Resources: Jobs](#Jobs). 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and the results are available.

```json
{
  "version": 2,
  "language": "en",
  "includeStandardEntities": false,
  "includeNounGroups": true,
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/user-55abf708-20d5-450e-b751-bb14b542fcf4",
  "documentIdVariable": "id",
  "textVariable": "text",
  "enableSpellChecking": false,
  "id": "0e456b0a-593c-480b-82ba-16da22b67fd6",
  "state": "pending",
  "creationTimeStamp": "2017-09-08T19:28:02.667Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6",
      "uri": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6",
      "type": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6",
      "uri": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6/state",
      "uri": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6/log",
      "uri": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6/state?value=canceled",
      "uri": "/parsing/jobs/0e456b0a-593c-480b-82ba-16da22b67fd6/state?value=canceled"
    },
    {
      "method": "GET",
      "rel": "caslib",
      "href": "/casManagement/servers/cas/caslibs/lib",
      "uri": "/casManagement/servers/cas/caslibs/lib",
      "type": "application/vnd.sas.cas.caslib"
    }
  ]
}
```


#### <a name='GetInfoAllJobs'>Get Information about All Jobs</a>
Here is an example of getting a paginated list of all of the jobs in the repository. 

* The collection contains up to __limit__ items.
* The collection links include the pagination links `prev`, `first`, `next`, `last`, if those pages are available from the current page as described in [Resources: Jobs](#Jobs).
* (Optional) You can filter and sort the list.

```json
{
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/parsing/jobs",
      "uri": "/parsing/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/parsing/jobs?start=0&limit=1",
      "uri": "/parsing/jobs?start=0&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/parsing/jobs?start=1&limit=1",
      "uri": "/parsing/jobs?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/parsing/jobs?start=1&limit=1",
      "uri": "/parsing/jobs?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/parsing/",
      "uri": "/parsing/",
      "type": "application/vnd.sas.api"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.text.parsing.job",
  "start": 0,
  "count": 2,
  "items": [
    {
      "version": 2,
      "language": "en",
      "includeStandardEntities": false,
      "includeNounGroups": true,
      "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/example",
      "documentIdVariable": "id",
      "textVariable": "reviewbody",
      "enableSpellChecking": false,
      "id": "f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "state": "running",
      "creationTimeStamp": "2017-09-08T19:26:42.472Z",
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
          "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
          "type": "application/vnd.sas.text.parsing.job"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
          "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9"
        },
        {
          "method": "GET",
          "rel": "state",
          "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state",
          "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state",
          "type": "text/plain"
        },
        {
          "method": "GET",
          "rel": "log",
          "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log",
          "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log",
          "type": "text/plain"
        },
        {
          "method": "PUT",
          "rel": "cancel",
          "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state?value=canceled",
          "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state?value=canceled"
        },
        {
          "method": "GET",
          "rel": "caslib",
          "href": "/casManagement/servers/cas/caslibs/lib",
          "uri": "/casManagement/servers/cas/caslibs/lib",
          "type": "application/vnd.sas.cas.caslib"
        }
      ]
    }
  ],
  "limit": 1,
  "version": 2
}
```


### <a name='GetInfoByJobID'>Get Information about a Job by jobId</a>
Here is an example of getting job information for a specific job ID, using the `/jobs/{jobId}` path. 

* This example gets the job resource with job ID `"f0250e89-5475-4de5-bddf-1f78b3a3a4f9"`.
* The request asks for the resource using the representation `application/vnd.sas.text.parsing.job+json`.
* The response is a JSON object. 
* The `cancel` link is included if the job can be canceled.
 *The `results` link is included if the job has completed successfully, and its results are available.

```json
{
  "version": 2,
  "language": "en",
  "includeStandardEntities": false,
  "includeNounGroups": true,
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/example",
  "documentIdVariable": "id",
  "textVariable": "reviewbody",
  "enableSpellChecking": false,
  "id": "f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
  "state": "completed",
  "creationTimeStamp": "2017-09-08T19:26:42.472Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "type": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "results",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job.result"
    },
    {
      "method": "GET",
      "rel": "caslib",
      "href": "/casManagement/servers/cas/caslibs/lib",
      "uri": "/casManagement/servers/cas/caslibs/lib",
      "type": "application/vnd.sas.cas.caslib"
    }
  ]
}
```


### <a name='GetStateSpecificJob'>Get the State of a Specific Job</a>
Here is an example of a call that returns the current state of a job for a job ID that you specify. 
Valid values are:

 * pending
 * running
 * completed
 * failed
 * canceled
 
The response body is `text/plain` and the status code is 200 (Request succeeded).

```
running
```


### <a name='GetJobLogText'>Get the Log as Text for a Specific Job</a>
Here is an example of a call that retrieves the log of a job for a given job ID, where each line is separated by one line break (`\n`).

* The response body is `text/plain` and the status code is 200 (Request succeeded).
* If no log is available, an empty response is returned, and the `Content-Length` header has a value of `0`.

```
2017-09-18T22:58:08.495 INFO  c.s.t.p.t.ParseTask  - [JOB_STARTING_EXECUTION] Starting job execution.
2017-09-18T22:58:08.501 INFO  c.s.t.p.t.ParseTask  - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080
2017-09-18T22:58:08.502 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T22:58:08.878 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:08.879 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T22:58:08.879 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T22:58:08.903 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:08.904 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T22:58:08.904 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T22:58:08.922 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:08.923 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T22:58:08.923 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T22:58:08.944 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:08.944 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T22:58:08.944 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T22:58:08.963 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:08.964 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T22:58:08.964 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T22:58:08.985 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:08.985 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T22:58:08.985 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T22:58:09.010 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:09.010 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T22:58:09.010 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T22:58:09.031 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:09.032 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T22:58:09.032 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T22:58:09.052 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:09.053 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T22:58:09.053 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T22:58:09.073 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:09.074 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T22:58:09.074 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T22:58:09.094 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:09.095 INFO  c.s.t.p.t.ParseTask  - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T22:58:09.095 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T22:58:09.116 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T22:58:09.125 INFO  c.s.t.p.t.ParseTask  - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T22:58:09.146 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=2
	}
2017-09-18T22:58:09.172 DEBUG c.s.t.p.t.ParseTask  - Result from tableExists[table]: {
	 exists=2
	}
2017-09-18T22:58:09.178 INFO  c.s.t.p.t.ParseTask  - [STOP_LIST_ALREADY_LOADED] The "EN_STOPLIST" stop list has already been loaded.
2017-09-18T22:58:09.178 INFO  c.s.t.p.t.ParseTask  - [CAS_LOADING_ACTION_SET] Loading the "textParse" action set.
2017-09-18T22:58:09.390 DEBUG c.s.t.p.t.ParseTask  - Result from loadActionSet[builtins]: {
	 actionset="textParse"
	}
2017-09-18T22:58:09.391 INFO  c.s.t.p.t.ParseTask  - [CAS_ACTION_SET_LOADED] The "textParse" action set was loaded.
2017-09-18T22:58:09.399 INFO  c.s.t.p.t.ParseTask  - [JOB_DOESNT_HAVE_CONCEPT_MODEL] The parsing job does not have an explicit concept model. Standard entities are used.
2017-09-18T22:58:09.400 INFO  c.s.t.p.t.ParseTask  - [CAS_CALLING_ACTION] Calling the "tpParse" action.
2017-09-18T22:58:09.402 INFO  c.s.t.p.t.ParseTask  - [CAS_LUA_STRING] LUA string: s:textParse_tpParse{docId="id",entities="STD",language="ENGLISH",offset={caslib="DMINE",name="user-1ae9fa9c-664a-47f1-81bd-848740ab0def_PARSING_POSITION_OUT_fa2ffdc7-e5fb-4ab1-94fe-36149144f3fc",promote=true},parseConfig={caslib="DMINE",name="user-1ae9fa9c-664a-47f1-81bd-848740ab0def_PARSING_CONFIGURATION_OUT_fa2ffdc7-e5fb-4ab1-94fe-36149144f3fc",promote=true},table={caslib="DMINE",name="user-1ae9fa9c-664a-47f1-81bd-848740ab0def"},text="text"}
2017-09-18T22:58:10.411 INFO  c.s.t.p.t.ParseTask  - [CAS_ACTION_COMPLETE] The "tpParse" action is complete.
2017-09-18T22:58:10.412 INFO  c.s.t.p.t.ParseTask  - [CAS_CALLING_ACTION] Calling the "tpAccumulate" action.
2017-09-18T22:58:10.414 INFO  c.s.t.p.t.ParseTask  - [CAS_LUA_STRING] LUA string: s:textParse_tpAccumulate{child={caslib="DMINE",name="user-1ae9fa9c-664a-47f1-81bd-848740ab0def_PARSING_CHILD_OUT_fa2ffdc7-e5fb-4ab1-94fe-36149144f3fc",promote=true},includeEmptyDocument=true,language="ENGLISH",offset={caslib="DMINE",name="user-1ae9fa9c-664a-47f1-81bd-848740ab0def_PARSING_POSITION_OUT_fa2ffdc7-e5fb-4ab1-94fe-36149144f3fc"},parent={caslib="DMINE",name="user-1ae9fa9c-664a-47f1-81bd-848740ab0def_PARSING_PARENT_OUT_fa2ffdc7-e5fb-4ab1-94fe-36149144f3fc",promote=true},showDroppedTerms=true,stopList={caslib="ReferenceData",name="EN_STOPLIST"},terms={caslib="DMINE",name="user-1ae9fa9c-664a-47f1-81bd-848740ab0def_PARSING_TERMS_OUT_fa2ffdc7-e5fb-4ab1-94fe-36149144f3fc",promote=true}}
2017-09-18T22:58:11.200 INFO  c.s.t.p.t.ParseTask  - [TOO_FEW_DOCUMENT_NO_SVD] Too few documents to perform SVD computation. Skipping the SVD action.
2017-09-18T22:58:11.202 INFO  c.s.t.p.t.ParseTask  - [JOB_COMPLETED] Job completed. (00:00:02)
```


### <a name='GetFormattedCollectionJobLog'>Get the Log as a Formatted Collection for a Specific Job</a>
Here is an example of getting a paginated list of all of the lines of the log for a given job ID.

* The collection contains up to __limit__ items.
* The collection links include pagination links `prev`, `first`, `next`, `last`, if those pages are available from the current page.

```json
{
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log?start=0&limit=2",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log?start=0&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log?start=2&limit=2",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log?start=2&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log?start=36&limit=2",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/log?start=36&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/",
      "type": "application/vnd.sas.text.parsing.job"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.compute.log.line",
  "start": 0,
  "count": 37,
  "items": [
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T22:58:08.495 - [JOB_STARTING_EXECUTION] Starting job execution."
    },
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T22:58:08.501 - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080"
    }
  ],
  "limit": 2,
  "version": 2
}
```


### <a name='GetJobErrors'>Get the Errors for a Specific Job</a>
Here is an example of a call that retrieves any errors that occurred while the job was executing.

* The endpoint returns 204 (No content) if no errors have occurred.
* The endpoint returns 200 (Request succeeded) and the response body is an `application/vnd.sas.error+json;version=2` JSON payload.

```json
{
  "errorCode": 2720327,
  "message": "com.sas.cas.CASException: A table could not be loaded. (severity=2 reason=6 statusCode=2720327 TABLE_NOT_LOADED)",
  "details": [
    "ERROR: The file or path 'example' is not available in the file system.",
    "ERROR: Table 'example' could not be loaded.",
    "ERROR: Failure opening table 'example': A table could not be loaded.",
    "ERROR: The action stopped due to errors."
  ],
  "links": [
    {
      "method": "GET",
      "rel": "up",
      "href": "/parsing/jobs/d8d734f0-eb76-4eec-bbff-3ab12667818a",
      "uri": "/parsing/jobs/d8d734f0-eb76-4eec-bbff-3ab12667818a",
      "type": "application/vnd.sas.text.parsing.job"
    }
  ],
  "version": 2,
  "httpStatusCode": 0
}
```


### <a name='GetJobResults'>Get the Results for a Specific Job</a>
Here is an example of a call that retrieves the results for a given job, if they are available. 

* This endpoint is able to fetch categorization results only when the job state is `completed`, otherwise it returns a 404 (No results exist).
* If enabled, links to the fact results are present.

```json
{
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job.result"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results?showDroppedTerms=false&start=0&limit=1",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results?showDroppedTerms=false&start=0&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job.result"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results?showDroppedTerms=false&start=1&limit=1",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results?showDroppedTerms=false&start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job.result"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results?showDroppedTerms=false&start=1829&limit=1",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/results?showDroppedTerms=false&start=1829&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.parsing.job.result"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/",
      "uri": "/parsing/jobs/f0250e89-5475-4de5-bddf-1f78b3a3a4f9/",
      "type": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "GET",
      "rel": "positionTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_POSITION_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_POSITION_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "parentTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_PARENT_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_PARENT_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "childrenTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_CHILD_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_CHILD_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "termsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "configurationTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_CONFIGURATION_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_CONFIGURATION_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "svdTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_SVD_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/example_PARSING_SVD_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "caslib",
      "href": "/casManagement/servers/cas/caslibs/lib",
      "uri": "/casManagement/servers/cas/caslibs/lib",
      "type": "application/vnd.sas.cas.caslib"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.text.parsing.job.result",
  "start": 0,
  "count": 1830,
  "items": [
    {
      "version": 1,
      "id": "r1",
      "terms": [
        {
          "value": "very",
          "role": "ADV",
          "startOffset": 92,
          "endOffset": 95,
          "kept": true
        },
        {
          "value": "bought",
          "role": "V",
          "startOffset": 2,
          "endOffset": 7,
          "kept": true
        },
        {
          "value": "works",
          "role": "V",
          "startOffset": 75,
          "endOffset": 79,
          "kept": true
        },
        {
          "value": "perfectly",
          "role": "ADV",
          "startOffset": 81,
          "endOffset": 89,
          "kept": true
        },
        {
          "value": "good",
          "role": "A",
          "startOffset": 97,
          "endOffset": 100,
          "kept": true
        },
        {
          "value": "good",
          "role": "A",
          "startOffset": 97,
          "endOffset": 100,
          "kept": true
        },
        {
          "value": "system",
          "role": "N",
          "startOffset": 51,
          "endOffset": 56,
          "kept": true
        },
        {
          "value": "system",
          "role": "N",
          "startOffset": 102,
          "endOffset": 107,
          "kept": true
        },
        {
          "value": "system",
          "role": "N",
          "startOffset": 51,
          "endOffset": 56,
          "kept": true
        },
        {
          "value": "system",
          "role": "N",
          "startOffset": 102,
          "endOffset": 107,
          "kept": true
        },
        {
          "value": "brand new",
          "role": "A",
          "startOffset": 61,
          "endOffset": 69,
          "kept": true
        },
        {
          "value": "refurbished",
          "role": "V",
          "startOffset": 12,
          "endOffset": 22,
          "kept": true
        },
        {
          "value": "example",
          "role": "PN",
          "startOffset": 29,
          "endOffset": 34,
          "kept": true
        },
        {
          "value": "price",
          "role": "N",
          "startOffset": 117,
          "endOffset": 121,
          "kept": true
        },
        {
          "value": "price",
          "role": "N",
          "startOffset": 117,
          "endOffset": 121,
          "kept": true
        }
      ]
    }
  ],
  "limit": 1,
  "version": 2
}
```


### <a name='DeleteJob'>Delete a Job</a>
Here is an example of a call that deletes the job resource for the specified job ID.

* Invoking this endpoint deletes the job and all related resources.
* If the request to delete is successful, the response body is empty and the status code is 204 (No content).



version 3, last updated 20 NOV, 2019


