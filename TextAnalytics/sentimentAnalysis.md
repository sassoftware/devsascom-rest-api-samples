# Sentiment Analysis API
The Sentiment Analysis API allows a client to assign a sentiment score to a
document or a collection of documents. Knowing the sentiment of a document allows a client to better understand the overall tone
of a document. Currently, this service supports document-level sentiment. For each document, the service returns a sentiment
score and a probability for the sentiment score. A sentiment score is a string that contains one of three values: positive,
negative, or neutral. The probability score is a number between 0.0 and 1.0 that indicates how positive or negative the score
is.

This API provides two different interactions for scoring: scoring CAS tables containing documents and scoring documents that
are uploaded directly into the API. In both cases, the service uses an asynchronous execution model. The client creates an analysis
job that runs in the background after the Create operation returns. The API provides resource endpoints for checking the state of the job.
Then, when complete, the results are retrieved using either the `/results` endpoint on the job, or by interacting with the 
result table directly by using another SAS service such as the Row Sets API.

One of the values the API takes as input is a `language` parameter. For English, the `language` parameter must take the form
of `en` (<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes" target="_blank">ISO-639-1 short code</a> for English). 
The `language` parameter is used to select the sentiment binary model that scores the documents. The language 
binaries are considered to be domain-independent because they are designed to work across different domains.

When scoring a table as input, the API views each row in the input table as a document. Thus, the API requires
two input parameters: `documentIdVariable` and `textVariable`. The `documentIdVariable` is a unique identifier for the document 
and the `textVariable` is the actual document text. For example, consider a table containing tweets from @SASSoftware:

| ID                 | Date Created                   | Message            |
|--------------------|--------------------------------|--------------------|
| 850007368138018817 | Thu Apr 06 15:28:43 +0000 2017 | Real-time and #AI are changing marketing: join 9/13 #SASWebinar with special guest from @Forrester |
| 787452347508998458 | Thu Apr 06 12:54:02 +0000 2017 | US has over 4 million miles of roads that could have 10 million fully or semi autonomous cars by 2020 #IoT |
| 774598598680208850 | Thu Apr 06 12:28:22 +0000 2017 | Need help with your fight against #fraud? |

In this example, the `documentIdVariable` is ID and the `textVariable` is Message.

The API supports all models provided by SAS as well as user-defined models.
The modelUri input parameter takes a URI to a CAS table containing one or more sentiment models.


## API Request Examples Grouped by Object Type

<details>
<summary>Root</summary>

* [Discover top-level links for the sentiment analysis API](#top-level-api)
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


### <a name='top-level-api'>Discover Top-Level Links for the Sentiment Analysis API</a>
Here is an example of a  call that retrieves the application/vnd.sas.api+json representation of the APIs top-level links. 

* The available links (as per [Resources: Root](#Root)) are `"jobs"` and `"startAnalysis"`.

```json
{
  "version": 1,
  "links": [
    {
      "method": "GET",
      "rel": "jobs",
      "href": "/sentiment/jobs",
      "uri": "/sentiment/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.sentiment.job"
    },
    {
      "method": "POST",
      "rel": "startAnalysis",
      "href": "/sentiment/jobs",
      "uri": "/sentiment/jobs",
      "type": "application/vnd.sas.text.sentiment.job.request",
      "responseType": "application/vnd.sas.text.sentiment.job"
    }
  ]
}
```


### <a name='StartJobUsingTableData'>Start a Job by Using Data in a Table</a>
Here is an example of a call that uses the POST method to submit a job request to the service.

* The request body contains the configuration information of the job, including the location of the input data.
* The `Content-Type` header is `application/vnd.sas.text.sentiment.job.request+json`.
* A separate operation is available to submit a job to analyze documents in the request, see [createJobByDocuments](#op:createJobByDocuments).
* The response code is 202 (Accepted for processing), and the response body is a JSON representation of the job with HATEOAS links.
* The API representation contains `self`, `delete`, `state`, `log`, and `caslib` links as  described in [Resources: Jobs](#Jobs). 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and the results are available.

```json
{
  "version": 1,
  "id": "37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
  "state": "pending",
  "language": "en",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/input",
  "documentIdVariable": "id",
  "textVariable": "reviewbody",
  "creationTimeStamp": "2017-09-08T20:15:13.273Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
      "type": "application/vnd.sas.text.sentiment.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/state",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/state?value=canceled",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/state?value=canceled"
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

* The request body contains the configuration information of the job,  including where to store the input data as well as the text documents to analyze. 
* The `Content-Type` header is `application/vnd.sas.text.sentiment.job.request.documents+json`.
* A separate operation is available that submits a job to analyze documents in a table, see [createJobByTable](#op:createJobByTable).
* The response code is 202 (Accepted for processing), and the response body is a JSON representation of the job with HATEOAS links.
* The API representation contains `self`, `delete`, `state`, `log` and `caslib` links as  described in [Resources: Jobs](#Jobs). 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and the results are available.

```json
{
  "version": 1,
  "language": "en",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/user-82191d11-ab88-44f1-ba5a-084b424dfbf1",
  "documentIdVariable": "id",
  "textVariable": "text",
  "id": "ba607364-3bb1-4576-8771-899c8752291e",
  "state": "pending",
  "creationTimeStamp": "2017-09-08T20:18:10.833Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e",
      "uri": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e",
      "type": "application/vnd.sas.text.parsing.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e",
      "uri": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e/state",
      "uri": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e/log",
      "uri": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e/state?value=canceled",
      "uri": "/parsing/jobs/ba607364-3bb1-4576-8771-899c8752291e/state?value=canceled"
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
      "href": "/parsing/jobs?start=3&limit=1",
      "uri": "/parsing/jobs?start=3&limit=1",
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
  "count": 4,
  "items": [
    {
      "version": 1,
      "language": "en",
      "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/input",
      "documentIdVariable": "id",
      "textVariable": "reviewbody",
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
  ],
  "limit": 1,
  "version": 2
}
```


### <a name='GetInfoByJobID'>Get Information about a Job by jobId</a>
Here is an example of getting job information for a specific job ID, using the `/jobs/{jobId}` path. 

* This example gets the job resource with job ID `"37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7"`.
* The request asks for the resource by using the representation `application/vnd.sas.text.sentiment.job+json`.
* The response is a JSON object. 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and its results are available.

```json
{
  "version": 1,
  "id": "37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
  "state": "completed",
  "language": "en",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/input",
  "documentIdVariable": "id",
  "textVariable": "reviewbody",
  "creationTimeStamp": "2017-09-08T20:15:13.273Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
      "type": "application/vnd.sas.text.sentiment.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/state",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "results",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results",
      "type": "application/vnd.sas.collection"
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
2017-09-18T23:22:12.712 INFO  s.t.s.t.AnalysisTask - [JOB_STARTING_EXECUTION] Starting job execution.
2017-09-18T23:22:12.722 INFO  s.t.s.t.AnalysisTask - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080
2017-09-18T23:22:12.722 INFO  s.t.s.t.AnalysisTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:22:13.101 DEBUG s.t.s.t.AnalysisTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:22:13.102 INFO  s.t.s.t.AnalysisTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:22:13.102 INFO  s.t.s.t.AnalysisTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:22:13.122 DEBUG s.t.s.t.AnalysisTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:22:13.123 INFO  s.t.s.t.AnalysisTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:22:13.123 INFO  s.t.s.t.AnalysisTask - [CAS_LOADING_ACTION_SET] Loading the "sentimentAnalysis" action set.
2017-09-18T23:22:13.323 DEBUG s.t.s.t.AnalysisTask - Result from loadActionSet[builtins]: {
	 actionset="sentimentAnalysis"
	}
2017-09-18T23:22:13.324 INFO  s.t.s.t.AnalysisTask - [CAS_ACTION_SET_LOADED] The "sentimentAnalysis" action set was loaded.
2017-09-18T23:22:13.327 INFO  s.t.s.t.AnalysisTask - [CAS_CALLING_ACTION] Calling the "applySent" action.
2017-09-18T23:22:13.329 INFO  s.t.s.t.AnalysisTask - [CAS_LUA_STRING] LUA string: s:sentimentAnalysis_applySent{casOut={caslib="DMINE",name="user-7b3a9b7a-b902-4de2-a3e5-d2a188c6d32f_SENTIMENT_OUT_fcdb0d2f-b4b5-48f8-ba35-7fd23affcb60",promote=true},docId="id",language="english",table={caslib="DMINE",name="user-7b3a9b7a-b902-4de2-a3e5-d2a188c6d32f"},text="text"}
2017-09-18T23:22:13.929 INFO  s.t.s.t.AnalysisTask - [CAS_ACTION_COMPLETE] The "applySent" action is complete.
2017-09-18T23:22:13.931 INFO  s.t.s.t.AnalysisTask - [JOB_COMPLETED] Job completed. (00:00:01)
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
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log?start=0&limit=2",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log?start=0&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log?start=2&limit=2",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log?start=2&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log?start=10&limit=2",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/log?start=10&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/",
      "type": "application/vnd.sas.text.sentiment.job"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.compute.log.line",
  "start": 0,
  "count": 12,
  "items": [
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T23:22:12.712 - [JOB_STARTING_EXECUTION] Starting job execution."
    },
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T23:22:12.722 - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080"
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
  "errorCode": 6030268,
  "message": "com.sas.cas.CASException: Could not find the text variable in the input CAS table. (severity=2 reason=6 statusCode=6030268)",
  "details": [
    "ERROR: The action stopped due to errors."
  ],
  "links": [
    {
      "method": "GET",
      "rel": "up",
      "href": "/sentiment/jobs/4ccd838b-ed42-49f1-a6b7-8c5f3405a135",
      "uri": "/sentiment/jobs/4ccd838b-ed42-49f1-a6b7-8c5f3405a135",
      "type": "application/vnd.sas.text.sentiment.job"
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
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.sentiment.job.result"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results?start=0&limit=2",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results?start=0&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.sentiment.job.result"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results?start=2&limit=2",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results?start=2&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.sentiment.job.result"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results?start=1828&limit=2",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/results?start=1828&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.sentiment.job.result"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/",
      "uri": "/sentiment/jobs/37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7/",
      "type": "application/vnd.sas.text.sentiment.job"
    },
    {
      "method": "GET",
      "rel": "documentSentimentTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/input_SENTIMENT_OUT_37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/input_SENTIMENT_OUT_37b0db7b-c02e-4fb6-9e7c-c1261f97fdf7",
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
  "accept": "application/vnd.sas.text.sentiment.job.result",
  "start": 0,
  "count": 1830,
  "items": [
    {
      "version": 1,
      "id": "r1",
      "sentiment": "positive",
      "probability": 0.692307710647583,
      "links": []
    },
    {
      "version": 1,
      "id": "r10",
      "sentiment": "positive",
      "probability": 0.9746471643447876,
      "links": []
    }
  ],
  "limit": 2,
  "version": 2
}
```


### <a name='DeleteJob'>Delete a Job</a>
Here is an example of a call that deletes the job resource for the specified job ID.

* Invoking this endpoint deletes the job and all related resources.
* If the request to delete is successful, the response body is empty and the status code is 204 (No content).


version 1, last updated 20 NOV, 2019
