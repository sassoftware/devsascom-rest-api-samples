# Topics API
Topics are statistically generated categories. You create the name of a topic using the top-level terms in the topic such as "wii, nintendo, mario, gamecube, zelda."

The Topics API takes two tables as inputs:
  - a parent table that provides a term or document matrix
  - a term table

Typically, you produce these tables using the Text Parsing API. The the names of two tables that contain the topics and the topic terms are the output for the API.

This API uses an asynchronous execution model. The client creates a topics job that runs in the background after the CREATE operation returns. The API provides resource endpoints for checking the state of the request. After this completes, results are retrieved using either the `/results` endpoint on the job or by interacting with the result table directly using another SAS service such as the CAS Management service.

## API Request Examples Grouped by Object Type

<details>
<summary>Root</summary>

* [Discover top-level links for the topics API](#top-level-api)
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


### <a name='top-level-api'>Discover Top-Level Links for the Topics API</a>
Here is an example of a  call that retrieves the application/vnd.sas.api+json representation of the APIs top-level links. 

* The available links (as per [Resources: Root](#Root)) are `"jobs"` and `"startTopics"`.

```json
{
  "version": 1,
  "links": [
    {
      "method": "GET",
      "rel": "jobs",
      "href": "/topics/jobs",
      "uri": "/topics/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job"
    },
    {
      "method": "POST",
      "rel": "startTopics",
      "href": "/topics/jobs",
      "uri": "/topics/jobs",
      "type": "application/vnd.sas.text.topics.job.request",
      "responseType": "application/vnd.sas.text.topics.job"
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
  "version": 1,
  "parentUri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_PARENT_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
  "parentTermIdVariable": "_TERMNUM_",
  "parentDocumentIdVariable": "_DOCUMENT_",
  "termsUri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
  "id": "35794141-01a1-45e7-b760-24bef36d127a",
  "state": "pending",
  "creationTimeStamp": "2017-09-08T20:48:01.053Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
      "type": "application/vnd.sas.text.topics.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state?value=canceled",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state?value=canceled"
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
      "href": "/topics/jobs",
      "uri": "/topics/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/topics/jobs?start=0&limit=1",
      "uri": "/topics/jobs?start=0&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/topics/jobs?start=1&limit=1",
      "uri": "/topics/jobs?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/topics/jobs?start=1&limit=1",
      "uri": "/topics/jobs?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/topics/",
      "uri": "/topics/",
      "type": "application/vnd.sas.api"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.text.topics.job",
  "start": 0,
  "count": 2,
  "items": [
    {
      "version": 1,
      "parentUri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_PARENT_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "parentTermIdVariable": "_TERMNUM_",
      "parentDocumentIdVariable": "_DOCUMENT_",
      "termsUri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
      "id": "35794141-01a1-45e7-b760-24bef36d127a",
      "state": "running",
      "creationTimeStamp": "2017-09-08T20:48:01.053Z",
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
          "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
          "type": "application/vnd.sas.text.topics.job"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
          "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a"
        },
        {
          "method": "GET",
          "rel": "state",
          "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state",
          "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state",
          "type": "text/plain"
        },
        {
          "method": "GET",
          "rel": "log",
          "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log",
          "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log",
          "type": "text/plain"
        },
        {
          "method": "PUT",
          "rel": "cancel",
          "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state?value=canceled",
          "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state?value=canceled"
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
 
* This example retrieves the job resource with job ID `"35794141-01a1-45e7-b760-24bef36d127a"`.  
* The request asks for the resource by using the representation `application/vnd.sas.text.concepts.job+json`.
* The response is a JSON object. 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and its results are available.

```json
{
  "version": 1,
  "parentUri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_PARENT_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
  "parentTermIdVariable": "_TERMNUM_",
  "parentDocumentIdVariable": "_DOCUMENT_",
  "termsUri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9",
  "id": "35794141-01a1-45e7-b760-24bef36d127a",
  "state": "completed",
  "creationTimeStamp": "2017-09-08T20:48:01.053Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
      "type": "application/vnd.sas.text.topics.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "results",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results",
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
2017-09-18T23:18:26.266 INFO  c.s.t.t.t.TopicsTask - [JOB_STARTING_EXECUTION] Starting job execution.
2017-09-18T23:18:26.272 INFO  c.s.t.t.t.TopicsTask - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080
2017-09-18T23:18:26.272 INFO  c.s.t.t.t.TopicsTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:18:26.647 DEBUG c.s.t.t.t.TopicsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:18:26.648 INFO  c.s.t.t.t.TopicsTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:18:26.649 INFO  c.s.t.t.t.TopicsTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:18:26.667 DEBUG c.s.t.t.t.TopicsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:18:26.667 INFO  c.s.t.t.t.TopicsTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:18:26.667 INFO  c.s.t.t.t.TopicsTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:18:26.688 DEBUG c.s.t.t.t.TopicsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:18:26.688 INFO  c.s.t.t.t.TopicsTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:18:26.688 INFO  c.s.t.t.t.TopicsTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:18:26.708 DEBUG c.s.t.t.t.TopicsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:18:26.708 INFO  c.s.t.t.t.TopicsTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:18:26.709 INFO  c.s.t.t.t.TopicsTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:18:26.728 DEBUG c.s.t.t.t.TopicsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:18:26.729 INFO  c.s.t.t.t.TopicsTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:18:26.729 INFO  c.s.t.t.t.TopicsTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:18:26.749 DEBUG c.s.t.t.t.TopicsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:18:26.761 INFO  c.s.t.t.t.TopicsTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:18:26.761 INFO  c.s.t.t.t.TopicsTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:18:26.782 DEBUG c.s.t.t.t.TopicsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:18:26.785 INFO  c.s.t.t.t.TopicsTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:18:26.785 INFO  c.s.t.t.t.TopicsTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:18:26.804 DEBUG c.s.t.t.t.TopicsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:18:26.805 INFO  c.s.t.t.t.TopicsTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:18:26.805 INFO  c.s.t.t.t.TopicsTask - [CAS_LOADING_ACTION_SET] Loading the "textMining" action set.
2017-09-18T23:18:27.005 DEBUG c.s.t.t.t.TopicsTask - Result from loadActionSet[builtins]: {
	 actionset="textMining"
	}
2017-09-18T23:18:27.006 INFO  c.s.t.t.t.TopicsTask - [CAS_ACTION_SET_LOADED] The "textMining" action set was loaded.
2017-09-18T23:18:27.006 INFO  c.s.t.t.t.TopicsTask - [CAS_CALLING_ACTION] Calling the "tmSvd" action.
2017-09-18T23:18:27.007 INFO  c.s.t.t.t.TopicsTask - [CAS_LUA_STRING] LUA string: s:textMining_tmSvd{docId="_DOCUMENT_",docPro={caslib="DMINE",name="amazon_PARSING_TERMS_OUT_6200b88b-622b-4c01-9782-2230e0d79ffd_TOPICS_DOCUMENT_PROJECTIONS_OUT_cfa7398d-0d8a-4db4-889f-68ab804b3567",promote=true},parent={caslib="DMINE",name="amazon_PARSING_PARENT_OUT_6200b88b-622b-4c01-9782-2230e0d79ffd"},termId="_TERMNUM_",terms={caslib="DMINE",name="amazon_PARSING_TERMS_OUT_6200b88b-622b-4c01-9782-2230e0d79ffd"},termTopics={caslib="DMINE",name="amazon_PARSING_TERMS_OUT_6200b88b-622b-4c01-9782-2230e0d79ffd_TOPICS_TERM_TOPICS_OUT_cfa7398d-0d8a-4db4-889f-68ab804b3567",promote=true},topicDecision=true,topics={caslib="DMINE",name="amazon_PARSING_TERMS_OUT_6200b88b-622b-4c01-9782-2230e0d79ffd_TOPICS_OUT_cfa7398d-0d8a-4db4-889f-68ab804b3567",promote=true},wordPro={caslib="DMINE",name="amazon_PARSING_TERMS_OUT_6200b88b-622b-4c01-9782-2230e0d79ffd_TOPICS_WORD_PROJECTIONS_OUT_cfa7398d-0d8a-4db4-889f-68ab804b3567",promote=true}}
2017-09-18T23:19:05.913 DEBUG c.s.t.t.t.TopicsTask - Result from tmSvd[textMining]: {
	 0
	}
2017-09-18T23:19:05.915 INFO  c.s.t.t.t.TopicsTask - [CAS_ACTION_COMPLETE] The "tmSvd" action is complete.
2017-09-18T23:19:05.917 INFO  c.s.t.t.t.TopicsTask - [JOB_COMPLETED] Job completed. (00:00:39)
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
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log?start=0&limit=2",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log?start=0&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log?start=2&limit=2",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log?start=2&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log?start=22&limit=2",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/log?start=22&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/",
      "type": "application/vnd.sas.text.topics.job"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.compute.log.line",
  "start": 0,
  "count": 23,
  "items": [
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T23:18:26.266 - [JOB_STARTING_EXECUTION] Starting job execution."
    },
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T23:18:26.272 - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080"
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
      "href": "/topics/jobs/4ccd838b-ed42-49f1-a6b7-8c5f3405a135",
      "uri": "/topics/jobs/4ccd838b-ed42-49f1-a6b7-8c5f3405a135",
      "type": "application/vnd.sas.text.topics.job"
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
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job.result"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results?start=1&limit=2",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results?start=1&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job.result"
    },
    {
      "method": "GET",
      "rel": "first",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results?start=0&limit=2",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results?start=0&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job.result"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results?start=3&limit=2",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results?start=3&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job.result"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results?start=8&limit=2",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/results?start=8&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.topics.job.result"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/",
      "uri": "/topics/jobs/35794141-01a1-45e7-b760-24bef36d127a/",
      "type": "application/vnd.sas.text.topics.job"
    },
    {
      "method": "GET",
      "rel": "topicsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9_TOPICS_OUT_35794141-01a1-45e7-b760-24bef36d127a",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9_TOPICS_OUT_35794141-01a1-45e7-b760-24bef36d127a",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "termTopicsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9_TOPICS_TERM_TOPICS_OUT_35794141-01a1-45e7-b760-24bef36d127a",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9_TOPICS_TERM_TOPICS_OUT_35794141-01a1-45e7-b760-24bef36d127a",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "documentProjectionsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9_TOPICS_DOCUMENT_PROJECTIONS_OUT_35794141-01a1-45e7-b760-24bef36d127a",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9_TOPICS_DOCUMENT_PROJECTIONS_OUT_35794141-01a1-45e7-b760-24bef36d127a",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "wordProjectionsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9_TOPICS_WORD_PROJECTIONS_OUT_35794141-01a1-45e7-b760-24bef36d127a",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/input_PARSING_TERMS_OUT_f0250e89-5475-4de5-bddf-1f78b3a3a4f9_TOPICS_WORD_PROJECTIONS_OUT_35794141-01a1-45e7-b760-24bef36d127a",
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
  "accept": "application/vnd.sas.text.topics.job.result",
  "start": 1,
  "count": 10,
  "items": [
    {
      "version": 1,
      "id": "2",
      "name": "hdd, psp, slim, capable, +accessory",
      "termCutOff": 0.031,
      "numberOfTerms": 275,
      "documentCutOff": 0.333,
      "numberOfDocuments": 285
    },
    {
      "version": 1,
      "id": "3",
      "name": "kinect, adventures, +mini-game, accurate, +degree",
      "termCutOff": 0.03,
      "numberOfTerms": 242,
      "documentCutOff": 0.393,
      "numberOfDocuments": 266
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
* 


version 3, last updated 20 NOV, 2019