# Model Management API for SAS Viya 3.5
The Model Management API consists of functions that integrate with the Model Repository API.

Here are the functions that this API provides:

* Monitor performance of models
* Create model comparison reports
* Retrieve mapped model score code
* Retrieve publishable model code
* Associate an object with a workflow process

For more information, see [_SAS Model Manager: User's Guide_](https://documentation.sas.com/?cdcId=mdlmgrcdc&cdcVersion=15.3&docsetId=mdlmgrug).

## API Request Examples Grouped by Object Type

<details>
<summary>Performance Tasks</summary>

* [Create a performance task](#create-performance-task)
* [Execute a performance task](#execute-performance-task)
* [Create a performance job](#create-performance-job)
</details>

<details>
<summary>Publish Models</summary>

* [Publish a model](#publish-model)
</details>

<details>
<summary>Model Comparison Reports</summary>

* [Create a model comparison report](#create-model-comparison-report)
</details>

<details>
<summary>Workflow Associations</summary>

* [Create a workflow association](#create-workflow-association))
* [Retrieve workflow associations](#retrieve-workflow-associations)
* [Retrieve status Information for a workflow association](#retrieve-status-info-workflow-association)
</details>


<details>
<summary>Workflow Tasks</summary>

* [Retrieve a set of workflow tasks](#retrieve-workflow-tasks)
* [Retrieve a workflow prompt](#RetrieveWorkflowPrompt)
</details>

<details>
<summary>See Also</summary>

* [Model Management API documentation](https://developer.sas.com/rest-apis/modelManagement?cadence=Viya_35)
</details>

#### <a name='create-performance-task'>Create a Performance Task</a>
Here is an example of defining a performance task for a model. After submitting the request, a performance task definition is created and a task ID is returned. The task ID can be used later to execute a performance task.

```
POST /performanceTasks
    Content-Type: application/vnd.sas.models.performance.task+json
```
Here is an example of the response:
```json
{
    "creationTimeStamp": "2017-07-13T21:21:49.994Z",
    "modifiedTimeStamp": "2017-07-13T21:21:49.995Z",
    "createdBy": "sasdemo",
    "modifiedBy": "sasdemo",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/modelManagement/performanceJob/ea6edc51-ca3e-41f5-9776-84b1fae2746a",
            "uri": "/modelManagement/performanceJob/ea6edc51-ca3e-41f5-9776-84b1fae2746a"
        }
    ],
    "version": 2,
    "modelId": "8119dace-0162-4ea3-930b-f7b5be7e8ec1",
    "outputVariables": [
        "EM_EVENTPROBABILITY"
    ],
    "inputVariables": [
        "CLAGE",
        "CLNO",
        "DEBTINC",
        "DELINQ",
        "DEROG",
        "JOB",
        "LOAN",
        "MORTDUE",
        "NINQ",
        "REASON",
        "VALUE",
        "YOJ"
    ],
    "scoreExecutionRequired": false,
    "performanceResultSaved": false,
    "traceOn": false,
    "maxBins": 10,
    "characteristicAlert": "char_p1>2",
    "characteristicWarn": "char_p1>5 or char_p25>0",
    "stabilityAlert": "outputDeviation > 0.03",
    "stabilityWarn": "outputDeviation > 0.01",
    "assessAlert": "(lift5Decay>0.15 and lift10Decay>0.12) or giniDecay>0.1 or ksDecay>0.1",
    "assessWarn": "lift5Decay>0.05 or MCE > 0.1",
    "resultLibraryUri": "/casManagement/servers/cas/caslibs/hps",
    "dataLibraryUri": "/casManagement/servers/cas/caslibs/hps",
    "dataPrefix": "hmeq_scored_"
}
```

#### <a name='execute-performance-task'>Execute a Performance Task</a>
Here is an example of executing a performance task. The performance task SAS code is submitted, and performance output tables are generated. A performance job ID is also returned. Based on the tables that are generated, users can create charts for model performance.

```
POST /performanceTasks/{id}
```
Here is an example of the response:
```json
{
    "creationTimeStamp": "2018-01-22T19:04:58.057Z",
    "modifiedTimeStamp": "2018-01-22T19:04:58.057Z",
    "createdBy": "sasdemo",
    "modifiedBy": "sasdemo",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/modelManagement/performanceTasks/f349e9bb-3427-443a-a4fb-bf2ac148a175/performanceJobs/06406357-0dd1-49dd-a8eb-2ab91a7cc3e8",
            "uri": "/modelManagement/performanceTasks/f349e9bb-3427-443a-a4fb-bf2ac148a175/performanceJobs/06406357-0dd1-49dd-a8eb-2ab91a7cc3e8"
        }
    ],
    "version": 2,
    "id": "06406357-0dd1-49dd-a8eb-2ab91a7cc3e8",
    "taskId": "f349e9bb-3427-443a-a4fb-bf2ac148a175",
    "code": "cas _mmcas_;\r\ncaslib _all_ assign;",
    "state": "running",
    "prefix": "prefix",
    "model": "unit test 875"
}
```

#### <a name='create-performance-job'>Create a Performance Job</a>
Here is an example of defining a performance job for a model. After submitting the request, a performance job is created and a job ID is returned. The job ID can be used later to get a performance job.

```
POST /@defaultTask/performanceJobs
    Content-Type: application/vnd.sas.models.performance.job+json
```
Here is an example of the response:
```json
{
    "creationTimeStamp":"2018-05-04T15:12:16.133Z",
    "modifiedTimeStamp":"2018-05-04T15:12:50.551Z",
    "createdBy":"sasdemo",
    "modifiedBy":"sasdemo",
    "links":[
        {
            "method":"GET",
            "rel":"self","href":"/modelManagement/performanceTasks/6f8e3b8c-be53-4a14-88a3-8e36335f7f1a/performanceJobs/88a9b2bd-cb1c-4d66-9286-6cd131b90ec7",
            "uri":"/modelManagement/performanceTasks/6f8e3b8c-be53-4a14-88a3-8e36335f7f1a/performanceJobs/88a9b2bd-cb1c-4d66-9286-6cd131b90ec7"
        }
    ],
    "version":2,
    "id":"88a9b2bd-cb1c-4d66-9286-6cd131b90ec7",
    "taskId":"6f8e3b8c-be53-4a14-88a3-8e36335f7f1a",
    "task":"user score single",
    "code":"options cashost='myserver.com' casport=5570;\ncas _mmcas_;\ncaslib _all_ assign;\n%let _MM_PerfExecutor = 1;\n%let _MM_ProjectUUID = %nrstr(ce3a3bdd-bdb0-4477-8a38-17c866eb414e);\n%let _MM_TargetVar = bad;\n%let _MM_TargetLevel = BINARY;\n%let _MM_PredictedVar = ;\n%let _MM_TargetEvent = 1;\n%let _MM_EventProbVar = score;\n%let _MM_KeepVars = score;\n%let _MM_CAKeepVars = CLAGE CLNO DEBTINC DELINQ DEROG JOB LOAN MORTDUE NINQ REASON VALUE YOJ;\n%let _MM_Trace = OFF;\n%let _MM_Max_Bins = 10;\n%let _MM_PerfOutCaslib = ModelPerformanceData;\n%let _MM_PerfInCaslib = Public;\n%let _MM_Perf_InTablePrefix = ;\n%let _MM_TableNameLevel = 3;\n%let _MM_PerfStaticTable = HMEQ-SCORE_1_Q1;\n%let _MM_ForceRunAllData = N;\n%let _MM_RunScore = N;\n%let _MM_SAVEPERFRESULT = Y;\n%let _MM_JobID = %nrstr(88a9b2bd-cb1c-4d66-9286-6cd131b90ec7);\n%let _MM_ModelID = %nrstr(ae57f85c-8450-4361-8b36-a135bc7ed11d);\n%let _MM_ModelName = %nrstr(reg1);\n%let _MM_ModelFlag = 0;\n%let _MM_ScoreCodeType = DATASTEP;\n%let _MM_ScoreCodeURI = ;%let _MM_ScoreAstURI = ;\n%mm_performance_monitor(\nperfLib=&_MM_PerfInCaslib,\nperfDataNamePrefix=&_MM_Perf_InTablePrefix,\nmm_mart=&_MM_PerfOutCaslib,\nrunScore=&_MM_RunScore,\nscorecodeURI=&_MM_ScoreCodeURI,\ndebug=OFF\n);\n%put &syserr;\n%put &syscc;","state":"completed","prefix":"","model":"reg1","dataLibrary":"Public","resultLibrary":"ModelPerformanceData","modelId":"ae57f85c-8450-4361-8b36-a135bc7ed11d","startTime":"2018-05-04T15:12:16.347Z","stopTime":"2018-05-04T15:12:50.542Z",
    "dataTable":"HMEQ-SCORE_1_Q1",
    "projectVersion":"Version 1",
    "projectId":"ce3a3bdd-bdb0-4477-8a38-17c866eb414e"
}
```

#### <a name='publish-model'>Publish a Model</a>
Here is an example of publishing a model to a publishing destination.

* The `force` request parameter indicates to publish models and replace previously published models with the same name.

* The `destinationName` argument is the name of the publishing destination. You can get destinations by using the API `GET /modelPublish/destinations`, which is provided by the Model Publish service.

* The `sourceUri` argument is the URI of the model that is to be published.

* The `publishLevel` argument indicates the publish level from where the model is being published. Valid values are "`model`" or "`project`".

  Here are some examples:
  - If you publish models from a project version within the SAS Model Manager web application, the publish level is "`model`".
  - If you publish models of a project from the Projects category list within the SAS Model Manager web application, the publish level is "`project`".

```
POST /publish?force=true
    Content-Type: application/vnd.sas.models.publishing.request.asynchronous+json
    Request Payload:
      {
        "name" : "Published model DS2EP",
        "notes" : "Publish models",
        "modelContents" : [{
            "modelName" : "DS2EP",
            "sourceUri" : "/modelRepository/models/5aff81e6-9d07-41cc-a112-efe65a1fa737",
            "publishLevel" : "model"
          }
        ],
        "destinationName" : "_HADOOP_"
      }
```
The response is a collection of published models.

Here is an example of the response:
```json
{
  "links" : [{
      "method" : "GET",
      "rel" : "self",
      "href" : "/modelPublish/models?start=0&limit=1",
      "uri" : "/modelPublish/models?start=0&limit=1",
      "type" : "application/vnd.sas.collection+json"
    }, {
      "method" : "GET",
      "rel" : "up",
      "href" : "/modelPublish",
      "uri" : "/modelPublish",
      "type" : "application/vnd.sas.api"
    }
  ],
  "name" : "items",
  "start" : 0,
  "count" : 1,
  "items" : [{
      "creationTimeStamp" : "2017-11-06T06:07:45.123Z",
      "modifiedTimeStamp" : "2017-11-06T06:07:45.123Z",
      "createdBy" : "sasdemo",
      "modifiedBy" : "sasdemo",
      "version" : 1,
      "id" : "ec478942-ff17-42e4-8e15-ef8151720c31",
      "publishType" : "ep",
      "verified" : false,
      "targetServer" : {
        "links" : [],
        "version" : 1,
        "port" : 0,
        "restPort" : 0
      },
      "principalId" : "5aff81e6-9d07-41cc-a112-efe65a1fa737",
      "codeType" : "ds2",
      "analyticStoreUri" : [],
      "sourceUri" : "/modelRepository/models/5aff81e6-9d07-41cc-a112-efe65a1fa737",
      "modelId" : "5aff81e6-9d07-41cc-a112-efe65a1fa737",
      "publishLevel" : "model",
      "properties" : {},
      "links" : [{
          "method" : "GET",
          "rel" : "self",
          "href" : "/modelPublish/models/ec478942-ff17-42e4-8e15-ef8151720c31",
          "uri" : "/modelPublish/models/ec478942-ff17-42e4-8e15-ef8151720c31",
          "type" : "application/vnd.sas.models.publishing.publish"
        }
      ]
    }
  ],
  "limit" : 1,
  "version" : 2
}

```

#### <a name='create-model-comparison-report'>Create a Model Comparison Report</a>
Here is an example of generating model comparison report data. It is typically consumed by SAS Model Manager web application.

```
POST /reports
    Content-Type: application/vnd.sas.models.report.model.comparison+json
```
Here is an example of the response:
```json
{
    "name":"compareModels",
    "description":"",
    "modelUris":[
        "/modelRepository/models/1997700c-f3f0-493b-9a7d-67a6fca07f56",
        "/modelRepository/models/65f01d3e-aa1f-45cd-8327-0391aa7e3702"
    ]
}
```

#### <a name='create-workflow-association)'>Create a Workflow Association</a>
Here is an example of creating an association between a workflow process and a SAS Model Manager project. Creating the association allows automation of tasks that are related to SAS Model Manager projects.

The key data in this example are the following:

* The processId from the Workflow service.
* The objectType, which is a constant.
* The solutionObjectId from the Model Repository service.

The result is an association between the workflow process with the ID of "WF4bfbed47-9834-4717-bcbc-4651d77fee56" and the SAS Model Manager project with the ID of "d13d55b2-8b6d-450e-9ffc-abb586f0c4d3".

```
POST /workflowAssociations
    Content-Type: application/vnd.sas.workflow.object.association+json
```
Here is an example of the response:
```json
{
   "templateName":"SimpleTask",
   "processId":"WF4bfbed47-9834-4717-bcbc-4651d77fee56",
   "objectType":"MM_Project",
   "solutionObjectName":"MushroomAnalysis",
   "solutionObjectId":"d13d55b2-8b6d-450e-9ffc-abb586f0c4d3",
   "solutionObjectUri":"/modelRepository/projects/d13d55b2-8b6d-450e-9ffc-abb586f0c4d3",
   "solutionObjectMediaType":"application/vnd.sas.models.project+json"
}
```

#### <a name='retrieve-workflow-associations'>Retrieve Workflow Associations</a>
Here is an example of retrieving an association with a SAS Model Manager project URI that has already been created.

```
GET /workflowAssociations?filter=eq(solutionObjectUri,%20%27/modelRepository/projects/9e1cdc23-996b-4a0a-80cd-820dc0dab937%27)
    Accept: application/vnd.sas.collection+json
```
Here is an example of the response:
```json
{
    "links": [
        {
           "method": "GET",
           "rel": "self",
           "href": "/modelManagement/workflowAssociations?filter=eq(solutionObjectUri,'/modelRepository/projects/9e1cdc23-996b-4a0a-80cd-820dc0dab937')&start=0&limit=20",
           "uri": "/modelManagement/workflowAssociations?filter=eq(solutionObjectUri,%20'/modelRepository/projects/9e1cdc23-996b-4a0a-80cd-820dc0dab937')&start=0&limit=20",
           "type": "application/vnd.sas.collection",
           "itemType": "application/vnd.sas.workflow.object.association"
        },
        {
           "method": "GET",
           "rel": "collection",
           "href": "/modelManagement/workflowAssociations",
           "uri": "/modelManagement/workflowAssociations",
           "type": "application/vnd.sas.collection"
        }
    ],
    "name": "associations",
    "accept": "application/vnd.sas.workflow.object.association+json",
    "start": 0,
    "count": 1,
    "items": [
        {
            "id": "8ae8d56760d8d0e50160eb38a7800007",
            "processId": "WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8",
            "processName": "SimpleTask",
            "objectType": "MM_Project",
            "solutionObjectName": "SimpleProj1",
            "solutionObjectId": "9e1cdc23-996b-4a0a-80cd-820dc0dab937",
            "solutionObjectUri": "/modelRepository/projects/9e1cdc23-996b-4a0a-80cd-820dc0dab937",
            "creationTimeStamp": "2018-01-12T16:34:05.340Z",
            "createdBy": "wfuser",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/modelManagement/workflowAssociations/8ae8d56760d8d0e50160eb38a7800007",
                    "uri": "/modelManagement/workflowAssociations/8ae8d56760d8d0e50160eb38a7800007"
                },
                {
                    "method": "GET",
                    "rel": "process",
                    "href": "/modelManagement/workflow/processes/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8",
                    "uri": "/modelManagement/workflow/processes/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8"
                }
            ]
        }
    ],
    "limit": 20,
    "version": 2
}
```

#### <a name='retrieve-status-info-workflow-association'>Retrieve Status Information for a Workflow Association</a>
Here is an example for retrieving status information about a specific workflow process that is associated with a SAS Model Manager project. The purpose of this request call is to find out the status of the workflow process: In progress, Completed, Terminated, or Suspended.

```
GET /workflowProcesses/{processId}
    Accept: application/vnd.sas.workflow.object.process+json
```
Here is an example of the response:
```json
{
  "id": "WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8",
  "name": "SimpleProcess",
  "creationTimeStamp": "2018-01-12T16:34:05.340Z",
  "createdBy": "wfuser",
  "state": "In Progress",
  "links": [
      {
        "method": "GET",
        "rel": "self",
        "href": "/modelManagement/workflowProcesses/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8",
        "uri": "/modelManagement/workflowProcesses/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8"
      },
      {
        "method": "GET",
        "rel": "alternate",
        "href": "/workflowHistory/processes/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8",
        "uri": "/workflowHistory/processes/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8"
      },
      {
        "method": "GET",
        "rel": "process",
        "href": "/workflow/processes/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8",
        "uri": "/workflow/processes/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8"
      }
  ]
}
```

#### <a name='retrieve-workflow-tasks'>Retrieve a Set of Workflow Tasks</a>
Here is an example of retrieving a list of workflow tasks (steps from workflow processes) that are assigned to the current user. These tasks are for the authenticated user and are only for tasks within workflow processes that associated with projects. This reflects a task list of work assigned to SAS Model Manager users.

```
GET /workflowTasks
    Accept: application/vnd.sas.workflow.object.task+json
```
Here is an example of the response:
```json
{
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/modelManagement/workflowTasks",
      "uri": "/modelManagement/workflowTasks",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.workflow.object.process"
    },
    {
      "method": "GET",
      "rel": "collection",
      "href": "/modelManagement/workflowTasks",
      "uri": "/modelManagement/workflowTasks",
      "type": "application/vnd.sas.collection"
    }
  ],
  "name": "tasks",
  "accept": "application/+json",
  "start": 0,
  "count": 2,
  "items": [
    {
      "creationTimeStamp": "2018-01-12T16:34:06.058Z",
      "createdBy": "wfuser",
      "id": "8ae8d56760d8d0e50160eb38a46a0002",
      "processId": "WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8",
      "processTaskId": "WF56a6360b-6a54-4649-860b-c0432e7401c2",
      "definitionTaskId": "WF0C7E4858-AFF4-43E5-AB80-D1A29100D8C0",
      "name": "Task 1",
      "definitionName": "SimpleTask",
      "state": "Started",
      "stateTimeStamp": "2018-01-12T16:34:06.026Z",
      "associations": [
        {
          "solutionObjectType": "MM_Project",
          "solutionObjectName": "GJCProj1",
          "solutionObjectId": "9e1cdc23-996b-4a0a-80cd-820dc0dab937",
          "solutionObjectUri": "/modelRepository/projects/9e1cdc23-996b-4a0a-80cd-820dc0dab937"
        }
      ],
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/modelManagement/workflowTasks/8ae8d56760d8d0e50160eb38a46a0002",
          "uri": "/modelManagement/workflowTasks/8ae8d56760d8d0e50160eb38a46a0002"
        },
        {
          "method": "GET",
          "rel": "alternate",
          "href": "/workflow/processes/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8/tasks/WF56a6360b-6a54-4649-860b-c0432e7401c2",
          "uri": "/workflow/processes/WF7f8bb4e5-854d-4e72-b4d8-1fcd3ce09fe8/tasks/WF56a6360b-6a54-4649-860b-c0432e7401c2"
        }
      ]
    },
    {
      "creationTimeStamp": "2018-01-15T17:03:25.567Z",
      "createdBy": "wfuser",
      "id": "8ae8d56760d8d0e50160fac6917f000a",
      "processId": "WF4bfbed47-9834-4717-bcbc-4651d77fee56",
      "processTaskId": "WF488899eb-ad76-493a-a8cc-b247baf7d311",
      "definitionTaskId": "WF0C7E4858-AFF4-43E5-AB80-D1A29100D8C0",
      "name": "Task 1",
      "definitionName": "SimpleTask",
      "state": "Started",
      "stateTimeStamp": "2018-01-15T17:03:25.561Z",
      "associations": [
        {
          "solutionObjectType": "MM_Project",
          "solutionObjectName": "MushroomAnalysis",
          "solutionObjectId": "d13d55b2-8b6d-450e-9ffc-abb586f0c4d3",
          "solutionObjectUri": "/modelRepository/projects/d13d55b2-8b6d-450e-9ffc-abb586f0c4d3"
        }
      ],
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/modelManagement/workflowTasks/8ae8d56760d8d0e50160fac6917f000a",
          "uri": "/modelManagement/workflowTasks/8ae8d56760d8d0e50160fac6917f000a"
        },
        {
          "method": "GET",
          "rel": "alternate",
          "href": "/workflow/processes/WF4bfbed47-9834-4717-bcbc-4651d77fee56/tasks/WF488899eb-ad76-493a-a8cc-b247baf7d311",
          "uri": "/workflow/processes/WF4bfbed47-9834-4717-bcbc-4651d77fee56/tasks/WF488899eb-ad76-493a-a8cc-b247baf7d311"
        }
      ]
    }
  ],
  "limit": 2147483647,
  "version": 2
}
```

#### <a name='RetrieveWorkflowPrompt'>Retrieve a Workflow Prompt</a>
Here is an example of retrieving a workflow prompt that is associated with a specific task. The prompt provides a description of data that needs to be provided by a user before a workflow task can be completed.

```
GET /workflowTasks/WF9b2fe3df-6ff4-4f84-b98f-f4e26ee8349f/prompts/WFAD7ACD60-8B6B-4B58-A558-9A91B06
    Accept: application/vnd.sas.workflow.object.prompt+json
```
Here is an example of the response:
```json
{
  "id": "WFAD7ACD60-8B6B-4B58-A558-9A91B067442A",
  "name": "What is your name?",
  "variableType": "string",
  "variableName": "userName",
  "required": "false",
  "version": 1,
  "actualValue": "false",
  "links": [{
    "method": "GET",
    "rel": "self",
    "href": "/modelManagement/workflowTasks/WF9b2fe3df-6ff4-4f84-b98f-f4e26ee8349f/prompts/WFAD7ACD60-8B6B-4B58-A558-9A91B067442A",
    "uri": "/modelManagement/workflowTasks/WF9b2fe3df-6ff4-4f84-b98f-f4e26ee8349f/prompts/WFAD7ACD60-8B6B-4B58-A558-9A91B067442A",
    "type": "application/vnd.sas.workflow.object.prompt"
  },
  {
    "method": "GET",
    "rel": "up",
    "href": "/modelManagement/workflowTasks/WF9b2fe3df-6ff4-4f84-b98f-f4e26ee8349f/prompts",
    "uri": "/modelManagement/workflowTasks/WF9b2fe3df-6ff4-4f84-b98f-f4e26ee8349f/prompts",
    "type": "application/vnd.sas.collection"
  },
  {
    "method": "GET",
    "rel": "task",
    "href": "/modelManagement/workflowTasks/WF9b2fe3df-6ff4-4f84-b98f-f4e26ee8349f",
    "uri": "/modelManagement/workflowTasks/WF9b2fe3df-6ff4-4f84-b98f-f4e26ee8349f",
    "type": "application/vnd.sas.workflow.object.task"
  }]
}
```

version 3, last updated on 29 October, 2024