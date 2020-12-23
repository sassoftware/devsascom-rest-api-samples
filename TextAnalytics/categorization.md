# Categorization API
The Categorization API allows a categorization model to be applied to a collection
of documents. The categorization model defines the categories, the taxonomic structure in which the categories reside
(think of organizing things in folder), and the rules defining how a document is considered a member of a category. A category is a label
applied to a document.

This API provides two different interactions for category scoring: scoring CAS tables containing documents and scoring
documents that are uploaded directly into the API. In both cases, the API uses an asynchronous execution model. The client
creates a categorization job that runs in the background after the Create operation returns. The API provides resource endpoints for checking the
state of the job. Then, when complete, the results are retrieved using either the `/results` endpoint on the job, or by 
interacting with the result table directly by using another SAS API such as the Row Sets API.

When scoring a table as input, the API views each row in the input table as a document. Thus, the API requires
two input parameters: `documentIdVariable` and `textVariable`. The `documentIdVariable` is a unique identifier for the document 
and the `textVariable` is the actual document text. For example, consider a table containing tweets from @SASSoftware:

| ID                 | Date Created                   | Message                                                      |
| ------------------ | ------------------------------ | ------------------------------------------------------------ |
| 850007368138018817 | Thu Apr 06 15:28:43 +0000 2017 | Real-time and #AI are changing marketing: join 9/13 #SASWebinar with special guest from @Forrester |
| 787452347508998458 | Thu Apr 06 12:54:02 +0000 2017 | US has over 4 million miles of roads that could have 10 million fully or semi autonomous cars by 2020 #IoT |
| 774598598680208850 | Thu Apr 06 12:28:22 +0000 2017 | Need help with your fight against #fraud?                    |

In this example, the `documentIdVariable` is ID and the `textVariable` is Message.

The API supports the use of all models provided by SAS as well as user-created models. The `modelUri` input parameter takes a
URI to a CAS table containing one or more category models.

## API Request Examples Grouped by Object Type

<details>
<summary>Root</summary>

* [Discover top-level links for categorization API](#top-level-api)
</details>

<details>
<summary>Jobs</summary>

* [Start a job using data in a table](#StartJobUsingTableData)
* [Start a job using inline data](#StartJobInlineData)
* [Get information about all jobs](#GetInfoAllJobs)
* [Get information about a job by jobId](#GetInfoJobID)
* [Get the state of a specific job](#GetJobState)
* [Get the log as text for a specific job](#GetTextLog)
* [Get the log as a formatted collection for a specific job](#GetFormattedCollectionLog)
* [Get the errors for a specific job](#GetJobErrors)
* [Get the results for a specific job](#GetJobResults)
* [Delete a job](#DeleteJob)
</details>


#### <a name='top-level-api'>Discover Top-Level Links for Categorization API</a>
Here is an example of a  call that retrieves the application/vnd.sas.api+json representation of the APIs top-level links.

* The available links (as per [Resources: Root](#Root)) are `"jobs"` and `"startCategorization"`.

```json
{
  "version": 1,
  "links": [
    {
      "method": "GET",
      "rel": "jobs",
      "href": "/categorization/jobs",
      "uri": "/categorization/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "POST",
      "rel": "startCategorization",
      "href": "/categorization/jobs",
      "uri": "/categorization/jobs",
      "type": "application/vnd.sas.text.categorization.job.request",
      "responseType": "application/vnd.sas.text.categorization.job"
    }
  ]
}
```


#### <a name='StartJobUsingTableData'>Start a Job Using Data in a Table</a>
Here is an example of a call that uses the POST method to submit a job request to the service.

* The request body contains the configuration information of the job, including where the input data resides. 
* The `Content-Type` header is `application/vnd.sas.text.categorization.job.request+json`.
* A separate operation is available to submit a job to categorize documents in the request, see [createJobByDocuments](#op:createJobByDocuments).
* The response code is 202 (Accepted for processing), and the response body is a JSON representation of the job with HATEOAS links.
* The API representation contains `self`, `delete`, `state`, `log`, and `caslib` links as  described in [Resources: Jobs](#Jobs). 
* The `cancel` is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and its results are available.

```json
{
  "version": 1,
  "modelUri": "/casManagement/servers/cas/caslibs/lib/tables/model",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/input",
  "documentIdVariable": "id",
  "textVariable": "text",
  "id": "4dd4f43e-abc2-4ecc-9391-341a334562f9",
  "state": "pending",
  "creationTimeStamp": "2017-09-08T12:40:38.751Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "type": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/state",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/state?value=canceled",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/state?value=canceled"
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


#### <a name='StartJobInlineData'>Start a Job Using Inline Data</a>
Here is an example of a call that uses the POST method to submit a job request to the service.

* The request body contains the configuration information of the job,  including where to store the input data as well as the text documents to categorize. 
* The `Content-Type` header is `application/vnd.sas.text.categorization.job.request.documents+json`.
* A separate operation is available that submits a job to categorize documents in a table, see [createJobByTable](#op:createJobByTable).
* The response code is 202 (Accepted for processing), and the response body is a JSON representation of the job with HATEOAS links.
* The API representation contains `self`, `delete`, `state`, `log`, and `caslib` links as  described in [Resources: Jobs](#Jobs). 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and its results are available.

```json
{
  "version": 1,
  "modelUri": "/casManagement/servers/cas/caslibs/lib/tables/model",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/username-eba5509b-a37e-4ae8-abc7-16efcb1ff1da",
  "documentIdVariable": "id",
  "textVariable": "text",
  "id": "db3f2f61-59a7-4a7a-adaa-9cdf2fba2981",
  "state": "pending",
  "creationTimeStamp": "2017-09-08T12:49:47.386Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981",
      "uri": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981",
      "type": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981",
      "uri": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981/state",
      "uri": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981/log",
      "uri": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981/state?value=canceled",
      "uri": "/categorization/jobs/db3f2f61-59a7-4a7a-adaa-9cdf2fba2981/state?value=canceled"
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
* The collection links include the pagination links, `prev`, `first`, `next`, and `last`, if those pages are available from the current page as described in [Resources: Jobs](#Jobs).
* (Optional) You can filter and sort the list.

```json
{
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/categorization/jobs",
      "uri": "/categorization/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/categorization/jobs?start=0&limit=1",
      "uri": "/categorization/jobs?start=0&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/categorization/jobs?start=1&limit=1",
      "uri": "/categorization/jobs?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/categorization/jobs?start=1&limit=1",
      "uri": "/categorization/jobs?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/categorization/",
      "uri": "/categorization/",
      "type": "application/vnd.sas.api"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.text.categorization.job",
  "start": 0,
  "count": 2,
  "items": [
    {
      "version": 1,
      "modelUri": "/casManagement/servers/cas/caslibs/lib/tables/model",
      "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/input",
      "documentIdVariable": "id",
      "textVariable": "text",
      "id": "4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "state": "failed",
      "creationTimeStamp": "2017-09-08T12:40:38.751Z",
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
          "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
          "type": "application/vnd.sas.text.categorization.job"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
          "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9"
        },
        {
          "method": "GET",
          "rel": "state",
          "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/state",
          "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/state",
          "type": "text/plain"
        },
        {
          "method": "GET",
          "rel": "log",
          "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log",
          "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log",
          "type": "text/plain"
        },
        {
          "method": "GET",
          "rel": "errors",
          "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/errors",
          "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/errors",
          "type": "application/vnd.sas.error"
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


#### <a name='GetInfoJobID'>Get Information about a Job by jobId</a>
Here is an example of getting job information for a specific job ID, using the `/jobs/{jobId}` path. 

* This example gets the job resource with job ID `"4dd4f43e-abc2-4ecc-9391-341a334562f9"`.
* The request asks for the resource using the representation `application/vnd.sas.text.categorization.job+json`.
* The response is a JSON object. 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and its results are available.

```json
{
  "version": 1,
  "modelUri": "/casManagement/servers/cas/caslibs/lib/tables/model",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/input",
  "documentIdVariable": "id",
  "textVariable": "text",
  "id": "4dd4f43e-abc2-4ecc-9391-341a334562f9",
  "state": "failed",
  "creationTimeStamp": "2017-09-08T12:40:38.751Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "type": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/state",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "errors",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/errors",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/errors",
      "type": "application/vnd.sas.error"
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


#### <a name='GetJobState'>Get the State of a Specific Job</a>
Here is an example of a call that returns the current state of a job for a job ID that you specify. 
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


#### <a name='GetTextLog'>Get the Log as Text for a Specific Job</a>
Here is an example of a call that retrieves the log of a job for a given job ID, where each line is separated by one line break (`\n`).
* The response body is `text/plain` and the status code is 200 (Request succeeded).
* If no log is available, an empty response is returned, and the `Content-Length` header has a value of `0`.

```
2017-09-18T23:26:41.961 INFO  t.CategorizationTask - [JOB_STARTING_EXECUTION] Starting job execution.
2017-09-18T23:26:41.980 INFO  t.CategorizationTask - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080
2017-09-18T23:26:41.982 INFO  t.CategorizationTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:26:42.370 DEBUG t.CategorizationTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:26:42.373 INFO  t.CategorizationTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:26:42.373 INFO  t.CategorizationTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:26:42.396 DEBUG t.CategorizationTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:26:42.397 INFO  t.CategorizationTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:26:42.397 INFO  t.CategorizationTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:26:42.420 DEBUG t.CategorizationTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:26:42.421 INFO  t.CategorizationTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:26:42.421 INFO  t.CategorizationTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:26:42.442 DEBUG t.CategorizationTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:26:42.442 INFO  t.CategorizationTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:26:42.443 INFO  t.CategorizationTask - [CAS_LOADING_ACTION_SET] Loading the "textRuleScore" action set.
2017-09-18T23:26:42.647 DEBUG t.CategorizationTask - Result from loadActionSet[builtins]: {
	 actionset="textRuleScore"
	}
2017-09-18T23:26:42.648 INFO  t.CategorizationTask - [CAS_ACTION_SET_LOADED] The "textRuleScore" action set was loaded.
2017-09-18T23:26:42.651 INFO  t.CategorizationTask - [CAS_CALLING_ACTION] Calling the "applyCategory" action.
2017-09-18T23:26:42.654 INFO  t.CategorizationTask - [CAS_LUA_STRING] LUA string: s:textRuleScore_applyCategory{casOut={caslib="DMINE",name="user-dca3a9b5-c3ad-4cc3-967b-3e7ca86b913e_CATEGORIZATION_CATEGORY_OUT_a27084e8-d077-4c57-9aa4-14f1c0d68558",promote=true},docId="id",matchOut={caslib="DMINE",name="user-dca3a9b5-c3ad-4cc3-967b-3e7ca86b913e_CATEGORIZATION_OFFSET_OUT_a27084e8-d077-4c57-9aa4-14f1c0d68558",promote=true},model={caslib="lib",name="model"},table={caslib="DMINE",name="user-dca3a9b5-c3ad-4cc3-967b-3e7ca86b913e"},text="text"}
2017-09-18T23:26:42.683 ERROR t.CategorizationTask - The action was not successful.
2017-09-18T23:26:42.687 ERROR t.CategorizationTask - ERROR: The caslib 'lib' does not exist.
2017-09-18T23:26:42.687 ERROR t.CategorizationTask - ERROR: Table 'model' could not be loaded.
2017-09-18T23:26:42.687 ERROR t.CategorizationTask - ERROR: Failure opening table 'model'
2017-09-18T23:26:42.687 ERROR t.CategorizationTask - ERROR: The action stopped due to errors.
```

#### <a name='GetFormattedCollectionLog'>Get the Log as a Formatted Collection for a Specific Job</a>
Here is an example of getting a paginated list of all of the lines of the log for a given job ID.

* The collection contains up to __limit__ items.
* The collection links include pagination links, `prev`, `first`, `next`, and `last` if those pages are available from the current page.

```json
{
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log?start=0&limit=2",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log?start=0&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log?start=2&limit=2",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log?start=2&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log?start=2&limit=2",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/log?start=2&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9/",
      "type": "application/vnd.sas.text.categorization.job"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.compute.log.line",
  "start": 0,
  "count": 4,
  "items": [
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T23:26:41.961 - [JOB_STARTING_EXECUTION] Starting job execution."
    },
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T23:26:41.980 - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080"
    }
  ],
  "limit": 2,
  "version": 2
}

```


#### <a name='GetJobErrors'>Get the Errors for a Specific Job</a>
Here is an example of a call that retrieves any errors that occurred while the job was executing.

* The endpoint returns 204 (No content) if no errors have occurred.
* The endpoint returns 200 (Request succeeded) and the response body is an `application/vnd.sas.error+json;version=2` JSON payload.

```json
{
  "errorCode": 2710120,
  "message": "com.sas.cas.CASException: The caslib 'lib' does not exist in this session. (severity=2 reason=0 statusCode=2710120 CASLIB_NOT_FOUND)\n5 ERROR: The caslib 'lib' does not exist in this session.\n5 ERROR: The action stopped due to errors.\ndebug=0x887ff878:TKCASTAB_CASLIB_NOTFOUND",
  "details": [
    "ERROR: The caslib 'lib' does not exist in this session.",
    "ERROR: The action stopped due to errors."
  ],
  "links": [
    {
      "method": "GET",
      "rel": "up",
      "href": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "uri": "/categorization/jobs/4dd4f43e-abc2-4ecc-9391-341a334562f9",
      "type": "application/vnd.sas.text.categorization.job"
    }
  ],
  "version": 2,
  "httpStatusCode": 0
}
```


#### <a name='GetJobResults'>Get the Results for a Specific Job</a>
Here is an example of a call that retrieves the results for a given job, if they are available. 

* This endpoint is able to fetch categorization results only when the job state is `completed`, otherwise it returns a 404 (No results exist).
* If enabled, links to the fact results are present.

```json
{
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/results",
      "uri": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/results",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job.result"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/results?start=0&limit=10",
      "uri": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/results?start=0&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job.result"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/results?start=10&limit=10",
      "uri": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/results?start=10&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job.result"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/results?start=750&limit=10",
      "uri": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/results?start=750&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.categorization.job.result"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/",
      "uri": "/categorization/jobs/9ce20afe-b4b3-4746-8b5b-8215ab7861d1/",
      "type": "application/vnd.sas.text.categorization.job"
    },
    {
      "method": "GET",
      "rel": "documentCategorizationTable",
      "href": "/casManagement/servers/cas/caslibs/cas/tables/FOO_CATEGORIZATION_CATEGORY_OUT_9ce20afe-b4b3-4746-8b5b-8215ab7861d1",
      "uri": "/casManagement/servers/cas/caslibs/cas/tables/FOO_CATEGORIZATION_CATEGORY_OUT_9ce20afe-b4b3-4746-8b5b-8215ab7861d1",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "categorizationOffsetTable",
      "href": "/casManagement/servers/cas/caslibs/cas/tables/FOO_CATEGORIZATION_OFFSET_OUT_9ce20afe-b4b3-4746-8b5b-8215ab7861d1",
      "uri": "/casManagement/servers/cas/caslibs/cas/tables/FOO_CATEGORIZATION_OFFSET_OUT_9ce20afe-b4b3-4746-8b5b-8215ab7861d1",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "documentScoreTable",
      "href": "/casManagement/servers/cas/caslibs/cas/tables/FOO_CATEGORIZATION_OFFSET_OUT_9ce20afe-b4b3-4746-8b5b-8215ab7861d1",
      "uri": "/casManagement/servers/cas/caslibs/cas/tables/FOO_CATEGORIZATION_DOCUMENT_OUT_9ce20afe-b4b3-4746-8b5b-8215ab7861d1",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "caslib",
      "href": "/casManagement/servers/cas/caslibs/cas",
      "uri": "/casManagement/servers/cas/caslibs/cas",
      "type": "application/vnd.sas.cas.caslib"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.text.categorization.job.result",
  "start": 0,
  "count": 757,
  "items": [
    {
      "version": 1,
      "id": "r101",
      "categories": [
        {
          "name": "Top/01000000 - Arts, Culture and Entertainment",
          "relevancy": 3,
          "terms": [
            {
              "value": "Movies",
              "startOffset": 224,
              "endOffset": 229
            },
            {
              "value": "movies",
              "startOffset": 579,
              "endOffset": 584
            },
            {
              "value": "movies",
              "startOffset": 948,
              "endOffset": 953
            }
          ]
        },
        {
          "name": "Top/01000000 - Arts, Culture and Entertainment/01005000 - Cinema",
          "relevancy": 3,
          "terms": [
            {
              "value": "Movies",
              "startOffset": 224,
              "endOffset": 229
            },
            {
              "value": "movies",
              "startOffset": 579,
              "endOffset": 584
            },
            {
              "value": "movies",
              "startOffset": 948,
              "endOffset": 953
            }
          ]
        }
      ]
    },
    {
      "version": 1,
      "id": "r1000",
      "categories": [
        {
          "name": "Top/04000000 - Economy, Business and Finance",
          "relevancy": 2,
          "terms": [
            {
              "value": "xbox",
              "startOffset": 9,
              "endOffset": 12
            },
            {
              "value": "xbox",
              "startOffset": 248,
              "endOffset": 251
            }
          ]
        },
        {
          "name": "Top/04000000 - Economy, Business and Finance/04003000 - Computing and Information Technology",
          "relevancy": 2,
          "terms": [
            {
              "value": "xbox",
              "startOffset": 9,
              "endOffset": 12
            },
            {
              "value": "xbox",
              "startOffset": 248,
              "endOffset": 251
            }
          ]
        }
      ]
    }
  ],
  "limit": 10,
  "version": 2
}
```


#### <a name='DeleteJob'>Delete a Job</a>
Here is an example of a call that deletes the job resource for the specified job ID.

* Invoking this endpoint deletes the job and all related resources.
* If the request to delete is successful, the response body is empty and the status code is 204 (No content).




version 2, last updated 19 NOV, 2019