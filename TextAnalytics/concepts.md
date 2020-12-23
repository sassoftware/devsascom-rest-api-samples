# Concepts API
The Concepts API allows a concept model to be applied to a collection
of documents. The concept model defines the concepts, the taxonomic structure in which
the concepts reside (think of organizing things in folders), and the rules that define how a region of text is assigned to a specific concept.

The Concepts API provides two different interactions for concepts:
* scoring CAS tables that contain documents
* scoring documents that are uploaded directly into the API.

In both cases, the Concepts API uses an asynchronous execution model.
The client creates a concepts job that runs in the background after the operation returns. The Concepts API provides resource endpoints for checking the state of the job. When the job is complete, the results are retrieved by using either the `/results` endpoint on the job, or by
interacting with the result table directly by using another SAS API such as the Row Sets API.

One of the parameter values the Concepts API uses as input is a `language` parameter. For English, the `language` parameter must take the form of `en` (<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes" target="_blank">ISO-639-1 short code</a>
for English). The `language` parameter is used to select the concept binary model that scores the documents if a custom binary is
not provided. The language binaries are considered to be domain-independent.

The Concepts API also takes an optional `matchType` parameter as input. The match type indicates what matches to return.
Possible values for `matchType` are `all`, `best`, and `longest`.  If the user chooses `all`, all of the terms that match any of the Language Interpretation for Textual Information (LITI) concept definitions in the model are returned. With `best`, only matches with the highest priority setting are returned.
The `longest` match type returns the longest match for the concept definition. The Concept API returns all matches by default.

When scoring a table as input, the Concepts API views each row in the input table as a document. Therefore, the Concepts API requires
two input parameters:
* `documentIdVariable`
* `textVariable`
  
The `documentIdVariable` is a unique identifier for the document. 
The `textVariable` is the actual document text. For example, consider a table containing tweets from @SASSoftware:

| ID                 | Date Created                   | Message            |
|--------------------|--------------------------------|--------------------|
| 850007368138018817 | Thu Apr 06 15:28:43 +0000 2017 | Real-time and #AI are changing marketing: join 9/13 #SASWebinar with special guest from @Forrester |
| 787452347508998458 | Thu Apr 06 12:54:02 +0000 2017 | US has over 4 million miles of roads that could have 10 million fully or semi autonomous cars by 2020 #IoT |
| 774598598680208850 | Thu Apr 06 12:28:22 +0000 2017 | Need help with your fight against #fraud? |

In this example, the `documentIdVariable` is ID and the `textVariable` is Message.

The Concepts API supports the use of the default models that are associated with each language, as well as user-created models.  The `modelUri` input parameter contains a URI that links to a CAS table containing one or more concept models.


## API Request Examples Grouped by Object Type

<details>
<summary>Root</summary>

* [Discover top-level links for the concepts API](#top-level-api)
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
* [Get the concept results for a specific job](#GetConceptJobResults)
* [Get fact results for a specific job](#GetFactJobResults)
* [Delete a job](#DeleteJob)
</details>


### <a name='top-level-api'>Discover Top-Level Links for the Concepts API</a>
Here is an example of a  call that retrieves the application/vnd.sas.api+json representation of the APIs top-level links. 

* The available links (as per [Resources: Root](#Root)) are `"jobs"` and `"startConcepts"`.

```json
{
  "version": 1,
  "links": [
    {
      "method": "GET",
      "rel": "jobs",
      "href": "/concepts/jobs",
      "uri": "/concepts/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "POST",
      "rel": "startConcepts",
      "href": "/concepts/jobs",
      "uri": "/concepts/jobs",
      "type": "application/vnd.sas.text.concepts.job.request",
      "responseType": "application/vnd.sas.text.concepts.job"
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
  "description": "My inline document request",
  "modelUri": "/casManagement/servers/cas/caslibs/lib/tables/model",
  "language": "en",
  "matchType": "all",
  "enableFacts": true,
  "outputTableNamePostfix": "-TMP",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/input",
  "documentIdVariable": "name",
  "textVariable": "text",
  "id": "2584ec7b-34c3-4917-94d7-d159910cf758",
  "state": "pending",
  "creationTimeStamp": "2017-09-08T18:10:54.463Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758",
      "type": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/state",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/log",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/state?value=canceled",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/state?value=canceled"
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
  "version": 1,
  "language": "en",
  "matchType": "all",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/user-e1795c72-983d-4f61-af00-d03d4f3acb63",
  "documentIdVariable": "id",
  "textVariable": "text",
  "id": "78e76133-8129-49ee-902a-26072d11f2a8",
  "state": "pending",
  "creationTimeStamp": "2017-09-08T15:32:07.354Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8",
      "uri": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8",
      "type": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8",
      "uri": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8/state",
      "uri": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8/log",
      "uri": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8/log",
      "type": "text/plain"
    },
    {
      "method": "PUT",
      "rel": "cancel",
      "href": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8/state?value=canceled",
      "uri": "/concepts/jobs/78e76133-8129-49ee-902a-26072d11f2a8/state?value=canceled"
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
      "href": "/concepts/jobs",
      "uri": "/concepts/jobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/concepts/jobs?start=0&limit=1",
      "uri": "/concepts/jobs?start=0&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/concepts/jobs?start=1&limit=1",
      "uri": "/concepts/jobs?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/concepts/jobs?start=6&limit=1",
      "uri": "/concepts/jobs?start=6&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/concepts/",
      "uri": "/concepts/",
      "type": "application/vnd.sas.api"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.text.concepts.job",
  "start": 0,
  "count": 7,
  "items": [
    {
      "version": 1,
      "language": "en",
      "matchType": "all",
      "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/user-6aafb1ce-3cf7-4328-a931-a477f9bbf05d",
      "documentIdVariable": "id",
      "textVariable": "text",
      "id": "aa43f983-ab7a-420e-972a-4a66e3e2ee5b",
      "state": "completed",
      "creationTimeStamp": "2017-09-08T16:47:08.497Z",
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b",
          "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b",
          "type": "application/vnd.sas.text.concepts.job"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b",
          "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b"
        },
        {
          "method": "GET",
          "rel": "state",
          "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/state",
          "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/state",
          "type": "text/plain"
        },
        {
          "method": "GET",
          "rel": "log",
          "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log",
          "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log",
          "type": "text/plain"
        },
        {
          "method": "GET",
          "rel": "results",
          "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/results",
          "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/results",
          "type": "application/vnd.sas.text.concepts.job.results"
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
 
* This example uses the job ID `"aa43f983-ab7a-420e-972a-4a66e3e2ee5b"` to get the job information.
* The request asks for the resource by using the representation `application/vnd.sas.text.concepts.job+json`.
* The response is a JSON object. 
* The `cancel` link is included if the job can be canceled. 
* The `results` link is included if the job has completed successfully and its results are available.

```json
{
  "version": 1,
  "language": "en",
  "matchType": "all",
  "inputUri": "/casManagement/servers/cas/caslibs/lib/tables/user-6aafb1ce-3cf7-4328-a931-a477f9bbf05d",
  "documentIdVariable": "id",
  "textVariable": "text",
  "id": "aa43f983-ab7a-420e-972a-4a66e3e2ee5b",
  "state": "completed",
  "creationTimeStamp": "2017-09-08T16:47:08.497Z",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b",
      "type": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/state",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "log",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "results",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/results",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/results",
      "type": "application/vnd.sas.text.concepts.job.results"
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
2017-09-18T23:24:27.422 INFO  s.t.c.t.ConceptsTask - [JOB_STARTING_EXECUTION] Starting job execution.
2017-09-18T23:24:27.446 INFO  s.t.c.t.ConceptsTask - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080
2017-09-18T23:24:27.446 DEBUG s.t.c.t.ConceptsTask - No custom concept model provided, the default language model will be used for scoring.
2017-09-18T23:24:27.446 INFO  s.t.c.t.ConceptsTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:24:27.843 DEBUG s.t.c.t.ConceptsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:24:27.844 INFO  s.t.c.t.ConceptsTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:24:27.844 INFO  s.t.c.t.ConceptsTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:24:27.864 DEBUG s.t.c.t.ConceptsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:24:27.865 INFO  s.t.c.t.ConceptsTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:24:27.865 INFO  s.t.c.t.ConceptsTask - [CAS_SESSION_TABLE_CHECK] Checking for the existence of a session table.
2017-09-18T23:24:27.885 DEBUG s.t.c.t.ConceptsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:24:27.885 INFO  s.t.c.t.ConceptsTask - [CAS_SESSION_TABLE_DOES_NOT_EXIST] Session table does not exist.
2017-09-18T23:24:27.885 INFO  s.t.c.t.ConceptsTask - [CAS_GLOBAL_TABLE_CHECK] Checking for the existence of a global table.
2017-09-18T23:24:27.905 DEBUG s.t.c.t.ConceptsTask - Result from tableExists[table]: {
	 exists=0
	}
2017-09-18T23:24:27.905 INFO  s.t.c.t.ConceptsTask - [CAS_GLOBAL_TABLE_DOES_NOT_EXIST] Global table does not exist.
2017-09-18T23:24:27.905 INFO  s.t.c.t.ConceptsTask - [CAS_LOADING_ACTION_SET] Loading the "textRuleScore" action set.
2017-09-18T23:24:28.106 DEBUG s.t.c.t.ConceptsTask - Result from loadActionSet[builtins]: {
	 actionset="textRuleScore"
	}
2017-09-18T23:24:28.107 INFO  s.t.c.t.ConceptsTask - [CAS_ACTION_SET_LOADED] The "textRuleScore" action set was loaded.
2017-09-18T23:24:28.111 INFO  s.t.c.t.ConceptsTask - [CAS_CALLING_ACTION] Calling the "applyConcept" action.
2017-09-18T23:24:28.113 INFO  s.t.c.t.ConceptsTask - [CAS_LUA_STRING] LUA string: s:textRuleScore_applyConcept{casOut={caslib="DMINE",name="user-52990cee-3e96-4ab5-af10-3d1c6b3e291a_CONCEPTS_OUT_7f19b758-257a-43d6-a264-8f15179a86d3",promote=true},docId="id",language="english",matchType="ALL",table={caslib="DMINE",name="user-52990cee-3e96-4ab5-af10-3d1c6b3e291a"},text="text"}
2017-09-18T23:24:29.458 DEBUG s.t.c.t.ConceptsTask - Result from applyConcept[textRuleScore]: {
	 OutputCasTablesFull=OutputCasTablesFull Output CAS Tables
	CAS Library Name                                                                                           Label Number of Rows Number of Columns
	----------- ---------------------------------------------------------------------------------------------- ----- -------------- -----------------
	DMINE       user-52990cee-3e96-4ab5-af10-3d1c6b3e291a_CONCEPTS_OUT_7f19b758-257a-43d6-a264-8f15179a86d3                    1                 7
	1 row
	
	}
2017-09-18T23:24:29.460 INFO  s.t.c.t.ConceptsTask - [CAS_ACTION_COMPLETE] The "applyConcept" action is complete.
2017-09-18T23:24:29.461 INFO  s.t.c.t.ConceptsTask - [JOB_COMPLETED] Job completed. (00:00:02)
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
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log?start=0&limit=2",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log?start=0&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log?start=2&limit=2",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log?start=2&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log?start=14&limit=2",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/log?start=14&limit=2",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.compute.log.line"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/",
      "uri": "/concepts/jobs/aa43f983-ab7a-420e-972a-4a66e3e2ee5b/",
      "type": "application/vnd.sas.text.concepts.job"
    }
  ],
  "name": "items",
  "accept": "application/vnd.sas.compute.log.line",
  "start": 0,
  "count": 15,
  "items": [
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T23:24:27.422 - [JOB_STARTING_EXECUTION] Starting job execution."
    },
    {
      "type": "note",
      "line": "NOTE: 2017-09-18T23:24:27.446 - [CAS_RUNNING_ON_SERVER] Running on CAS server example.sas.com:8080"
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
      "href": "/concepts/jobs/4ccd838b-ed42-49f1-a6b7-8c5f3405a135",
      "uri": "/concepts/jobs/4ccd838b-ed42-49f1-a6b7-8c5f3405a135",
      "type": "application/vnd.sas.text.concepts.job"
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
  "version": 1,
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results",
      "type": "application/vnd.sas.text.concepts.job.results"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758",
      "type": "application/vnd.sas.text.concepts.job"
    },
    {
      "method": "GET",
      "rel": "caslib",
      "href": "/casManagement/servers/cas/caslibs/lib",
      "uri": "/casManagement/servers/cas/caslibs/lib",
      "type": "application/vnd.sas.cas.caslib"
    },
    {
      "method": "GET",
      "rel": "concepts",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts",
      "type": "application/vnd.sas.collection",
      "responseItemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "conceptsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/EXAMPLE_CONCEPTS_OUT_-TMP",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/EXAMPLE_CONCEPTS_OUT_-TMP",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "factsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/EXAMPLE_FACTS_OUT_-TMP",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/EXAMPLE_FACTS_OUT_-TMP",
      "type": "application/vnd.sas.cas.table"
    },
    {
      "method": "GET",
      "rel": "facts",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts",
      "type": "application/vnd.sas.collection",
      "responseItemType": "application/vnd.sas.text.concepts.fact.result"
    }
  ]
}
```


### <a name='GetConceptJobResults'>Get the Concept Results for a Specific Job</a>
Here is an example of a call that returns the concept results as a collection for a specified job, if any are available. 

* The endpoint returns concept results only when the job state is `completed`. 
* The endpoint returns a 404 (No results exist).
* The collection contains up to __limit__ items.
* The collection links include the pagination links `prev`, `first`, `next`, `last`, if those pages are available from the current page.

```json
{
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts?start=0&limit=1",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts?start=0&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts?start=1&limit=1",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts?start=49&limit=1",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/concepts?start=49&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/",
      "type": "application/vnd.sas.text.concepts.job.results"
    },
    {
      "method": "GET",
      "rel": "conceptsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/EXAMPLE_CONCEPTS_OUT_-TMP",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/EXAMPLE_CONCEPTS_OUT_-TMP",
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
  "accept": "application/vnd.sas.text.concepts.concept.result",
  "start": 0,
  "count": 50,
  "items": [
    {
      "version": 1,
      "id": "01.txt",
      "concepts": [
        {
          "name": "nlpNounGroup",
          "term": "contemporary-looking aquarium",
          "startOffset": 17,
          "endOffset": 45
        },
        {
          "name": "NOUNS",
          "term": "aquarium",
          "startOffset": 38,
          "endOffset": 45
        }
      ]
    }
  ],
  "limit": 1,
  "version": 2
}
```


### <a name='GetFactJobResults'>Get Fact Results for a Specific Job</a>
Here is an example of a call that returns the fact results as a collection for a specified job, if results are available.

* The endpoint returns fact results only when the job state is `completed`. 
* The endpoint returns 404 (No results exist).
* The collection contains up to __limit__ items.
* The collection links include the pagination links `prev`, `first`, `next`, `last`, if those pages are available from the current page.

```json
{
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts?start=0&limit=1",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts?start=0&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts?start=1&limit=1",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts?start=1&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts?start=43&limit=1",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/facts?start=43&limit=1",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.text.concepts.concept.result"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/",
      "uri": "/concepts/jobs/2584ec7b-34c3-4917-94d7-d159910cf758/results/",
      "type": "application/vnd.sas.text.concepts.job.results"
    },
    {
      "method": "GET",
      "rel": "factsTable",
      "href": "/casManagement/servers/cas/caslibs/lib/tables/EXAMPLE_FACTS_OUT_-TMP",
      "uri": "/casManagement/servers/cas/caslibs/lib/tables/EXAMPLE_FACTS_OUT_-TMP",
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
  "accept": "application/vnd.sas.text.concepts.fact.result",
  "start": 0,
  "count": 44,
  "items": [
    {
      "version": 1,
      "id": "01.txt",
      "facts": [
        {
          "name": "VERBS",
          "term": "is",
          "startOffset": 12,
          "endOffset": 13,
          "arguments": [
            {
              "name": "verb",
              "matchedText": "is"
            }
          ]
        },
        {
          "name": "VERBS",
          "term": "is",
          "startOffset": 253,
          "endOffset": 254,
          "arguments": [
            {
              "name": "verb",
              "matchedText": "is"
            }
          ]
        },
        {
          "name": "VERBS",
          "term": "are",
          "startOffset": 891,
          "endOffset": 893,
          "arguments": [
            {
              "name": "verb",
              "matchedText": "are"
            }
          ]
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




version 2, last updated 20 NOV, 2019