# Workflow
The SAS Visual Investigator Workflow API enables clients to manage workflows used in case management to investigate and process threat analysis.

## API Request Examples

Here are the typical steps a user might do while working through the case management workflows:

* [Create a new workflow](#createWorkflow)
* [Get list of workflows](#getWorkflow)
* [Start a workflow process](#startWorkflow)
* [View pending tasks](#listTasks)
* [Claim a task to work](#claimTask)
* [Complete a task](#completeTask)
* [View the active process](#viewProcess)
* [Suspend the process](#suspendProcess)
* [Suspend multiple workflow processes](#suspendMultiSelectedProcesses)
* [Resume the process](#resumeProcess)
* [View task metrics per each entity](#getEntityMetrics)
* [Administrator release task claim](#adminReleaseClaimOnTask)
* [Administrator release task claim multiple tasks](#adminMultiReleaseClaimOnTask)
* [View workflow process history](#viewWorkflowProcessHistory)

(Note, white space added in the below examples for readability)

<a name="createWorkflow"></a>
### Create a new workflow
This will define and deploy a BPMN based workflow that is ready to run.

**Request**
```
POST /svi-datahub/workflows
Headers:
 * Accept: application/vnd.sas.investigation.workflow.workflow+json
 * Content-Type: application/vnd.sas.investigation.workflow.workflow+json
Body:
{  
   "label":"Intel Report Workflow",
   "description":"",
   "graphicalModel":"{\"class\":\"go.GraphLinksModel\",\"linkFromPortIdProperty\":\"fromPort\",
            \"linkToPortIdProperty\":\"toPort\",\"modelData\":{\"version\":10.21,\"entityIdsUpdated\":true},
            \"nodeDataArray\":[{\"key\":\"StartEvent1534937812963\",\"category\":\"event\",\"loc\":\"0 0\",
            \"text\":\"Start\",\"item\":\"StartEvent\",\"currentlySelected\":true},{\"key\":\"UserTask1534937831345\",
            \"category\":\"activity\",\"loc\":\"0.5 105\",\"text\":\"User Task\",\"item\":\"UserTask\",\"taskActions\":[{\"name\":\"Completed\",\"id\":\"taskOption1534937831345\",\"value\":\"taskOption1534937831345\",\"processVariables\":[],\"entityFieldVariables\":[]}],\"participants\":[{\"id\":\"user2\",\"type\":\"user\",\"name\":\"Test user2\"},{\"id\":\"sviusrs\",\"type\":\"group\",\"name\":\"Visual Investigator Users\"}],\"activityNodeShapeHeight\":70,\"activityNodePanelSize\":{\"class\":\"go.Size\",\"width\":200,\"height\":70},\"size\":{\"class\":\"go.Size\",\"width\":200,\"height\":70},\"activityNodeShapeSize\":{\"class\":\"go.Size\",\"width\":200,\"height\":70},\"currentlySelected\":false},{\"key\":\"EndEvent1534937834926\",\"category\":\"event\",\"loc\":\"0.5 335\",\"text\":\"End\",\"item\":\"EndEvent\",\"currentlySelected\":false}],\"linkDataArray\":[{\"from\":\"StartEvent1534937812963\",\"to\":\"UserTask1534937831345\",\"visible\":true,\"fromPort\":\"bottomPort\",\"toPort\":\"topPort\",\"points\":[0.5,25,0.5,55,0.5000000000000071,55,0.5000000000000071,42.15685424949238,0.5000000000000142,42.15685424949238,0.5000000000000142,72.15685424949238],\"text\":\"\"},{\"from\":\"UserTask1534937831345\",\"to\":\"EndEvent1534937834926\",\"fromPort\":\"bottomPort\",\"toPort\":\"topPort\",\"key\":\"UserTask1534937831345_EndEvent1534937834926\",\"points\":[0.5000000000000142,137.84314575050763,0.5000000000000142,167.84314575050763,0.5000000000000142,224.92157287525382,1,224.92157287525382,1,282,1,312]}]}",
   "entityId":100515,
   "entityName":"intel_report",
   "name":"intel_report_workflow",
   "userDefinedProcessVariables":[
      {
         "id":"WorkflowVariable1",
         "label":"AUTO_ASSIGN_VAR",
         "name":"AUTO_ASSIGN_VAR",
         "isEntity":false,
         "type":"USER_GROUP",
         "defaultValue":"[{\"type\":\"user\",\"id\":\"user2\"}]",
         "userSelectionStrategy":"USERS",
         "allowMultipleSelections":false
      },
      {
         "id":"WorkflowVariable2",
         "label":"GET_RUNNING_TASK_USER",
         "name":"GET_RUNNING_TASK_USER",
         "isEntity":false,
         "type":"USER_GROUP",
         "defaultValue":"",
         "userSelectionStrategy":"USERS",
         "allowMultipleSelections":false
      },
      {
         "id":"WorkflowVariable3",
         "label":"STATUS",
         "name":"STATUS",
         "isEntity":false,
         "type":"STRING",
         "defaultValue":""
      }
   ],
   "entityDefinedProcessVariables":[
      "svi_first_name",
      "svi_last_name"
   ]
}
```

**Response**
```
Status: 201
Headers:
 * Content-Type: application/vnd.sas.investigation.workflow.workflow+json
 * Location: /workflows/workflows/intel_report_workflow:1:f17ee9e4-a5ff-11e8-9397-0242ac110013
 * Last-Modified: Wed, 22 Aug 2018 11:38:52 GMT
Body:
{
   "links":[
      {
         "method":"GET",
         "rel":"self",
         "href":"/workflows/workflows/intel_report_workflow:1:f17ee9e4-a5ff-11e8-9397-0242ac110013",
         "uri":"/workflows/workflows/intel_report_workflow:1:f17ee9e4-a5ff-11e8-9397-0242ac110013",
         "type": "application/vnd.sas.investigation.workflow.workflow",
         "responseType": "application/vnd.sas.investigation.workflow.workflow+json"
      },
      {
         "method":"PUT",
         "rel":"create new version",
         "href":"/workflows/workflows/intel_report_workflow:1:f17ee9e4-a5ff-11e8-9397-0242ac110013",
         "uri":"/workflows/workflows/intel_report_workflow:1:f17ee9e4-a5ff-11e8-9397-0242ac110013",
         "type": "application/vnd.sas.investigation.workflow.workflow",
         "responseType": "application/vnd.sas.investigation.workflow.workflow+json"
      }
   ],
   "version":1,
   "entityId":100515,
   "entityName":"intel_report",
   "entityLabel":"Intel Report",
   "id":"intel_report_workflow:1:f17ee9e4-a5ff-11e8-9397-0242ac110013",
   "labelResource":"svi.workflow.intel_report.1534937931623.label.txt",
   "descriptionResource":"svi.workflow.intel_report.1534937931623.description.txt",
   "graphicalModel":"{\"linkFromPortIdProperty\":\"fromPort\",\"linkToPortIdProperty\":\"toPort\",\"modelData\":{\"version\":10.21,\"entityIdsUpdated\":true},\"nodeDataArray\":[{\"key\":\"StartEvent1534937812963\",\"category\":\"event\",\"text\":\"Start\",\"textResource\":\"svi.workflow.intel_report.1534937931623.StartEvent1534937812963.name.txt\",\"item\":\"StartEvent\",\"descriptionResource\":\"svi.workflow.intel_report.1534937931623.StartEvent1534937812963.description.txt\",\"loc\":\"0 0\"},{\"key\":\"UserTask1534937831345\",\"category\":\"activity\",\"text\":\"User Task\",\"textResource\":\"svi.workflow.intel_report.1534937931623.UserTask1534937831345.name.txt\",\"item\":\"UserTask\",\"descriptionResource\":\"svi.workflow.intel_report.1534937931623.UserTask1534937831345.description.txt\",\"participants\":[{\"id\":\"user2\",\"type\":\"user\",\"name\":\"Test user2\"},{\"id\":\"sviusrs\",\"type\":\"group\",\"name\":\"Visual Investigator Users\"}],\"loc\":\"0.5 105\",\"size\":{\"width\":200,\"height\":70,\"class\":\"go.Size\"},\"taskActions\":[{\"id\":\"taskOption1534937831345\",\"name\":\"Completed\",\"processVariables\":[],\"entityFieldVariables\":[],\"nameResource\":\"svi.workflow.intel_report.1534937931623.UserTask1534937831345.action.taskOption1534937831345.name.txt\",\"value\":\"taskOption1534937831345\"}]},{\"key\":\"EndEvent1534937834926\",\"category\":\"event\",\"text\":\"End\",\"textResource\":\"svi.workflow.intel_report.1534937931623.EndEvent1534937834926.name.txt\",\"item\":\"EndEvent\",\"descriptionResource\":\"svi.workflow.intel_report.1534937931623.EndEvent1534937834926.description.txt\",\"loc\":\"0.5 335\"}],\"linkDataArray\":[{\"from\":\"StartEvent1534937812963\",\"to\":\"UserTask1534937831345\",\"visible\":true,\"fromPort\":\"bottomPort\",\"toPort\":\"topPort\",\"points\":[0,25,0,55,0,55,0,42,0,42,0,72],\"text\":\"\",\"textResource\":\"svi.workflow.intel_report.1534937931623.StartEvent1534937812963_UserTask1534937831345.name.txt\",\"descriptionResource\":\"svi.workflow.intel_report.1534937931623.StartEvent1534937812963_UserTask1534937831345.description.txt\"},{\"from\":\"UserTask1534937831345\",\"to\":\"EndEvent1534937834926\",\"fromPort\":\"bottomPort\",\"toPort\":\"topPort\",\"points\":[0,137,0,167,0,224,1,224,1,282,1,312],\"textResource\":\"svi.workflow.intel_report.1534937931623.UserTask1534937831345_EndEvent1534937834926.name.txt\",\"key\":\"UserTask1534937831345_EndEvent1534937834926\",\"descriptionResource\":\"svi.workflow.intel_report.1534937931623.UserTask1534937831345_EndEvent1534937834926.description.txt\"}],\"class\":\"go.GraphLinksModel\"}",
   "userDefinedProcessVariables":[
      {
         "id":"WorkflowVariable1",
         "name":"AUTO_ASSIGN_VAR",
         "label":"AUTO_ASSIGN_VAR",
         "defaultValue":"[{\"id\":\"user2\",\"type\":\"user\"}]",
         "type":"USER_GROUP",
         "isEntity":false,
         "userSelectionStrategy":"USERS",
         "allowMultipleSelections":false
      },
      {
         "id":"WorkflowVariable2",
         "name":"GET_RUNNING_TASK_USER",
         "label":"GET_RUNNING_TASK_USER",
         "defaultValue":"[]",
         "type":"USER_GROUP",
         "isEntity":false,
         "userSelectionStrategy":"USERS",
         "allowMultipleSelections":false
      },
      {
         "id":"WorkflowVariable3",
         "name":"STATUS",
         "label":"STATUS",
         "defaultValue":"",
         "defaultValueResource":"svi.workflow.intel_report.1534937931623.WorkflowVariable3.defaultValue.txt",
         "type":"STRING",
         "isEntity":false
      }
   ],
   "entityDefinedProcessVariables":[
      "svi_first_name",
      "svi_last_name"
   ],
   "resourceStrings":{
      "svi.workflow.intel_report.1534937931623.EndEvent1534937834926.description.txt":"",
      "svi.workflow.intel_report.1534937931623.EndEvent1534937834926.name.txt":"End",
      "svi.workflow.intel_report.1534937931623.StartEvent1534937812963.description.txt":"",
      "svi.workflow.intel_report.1534937931623.StartEvent1534937812963.name.txt":"Start",
      "svi.workflow.intel_report.1534937931623.StartEvent1534937812963_UserTask1534937831345.description.txt":"",
      "svi.workflow.intel_report.1534937931623.StartEvent1534937812963_UserTask1534937831345.name.txt":"",
      "svi.workflow.intel_report.1534937931623.UserTask1534937831345.action.taskOption1534937831345.name.txt":"Completed",
      "svi.workflow.intel_report.1534937931623.UserTask1534937831345.description.txt":"",
      "svi.workflow.intel_report.1534937931623.UserTask1534937831345.name.txt":"User Task",
      "svi.workflow.intel_report.1534937931623.UserTask1534937831345_EndEvent1534937834926.description.txt":"",
      "svi.workflow.intel_report.1534937931623.UserTask1534937831345_EndEvent1534937834926.name.txt":"",
      "svi.workflow.intel_report.1534937931623.WorkflowVariable3.defaultValue.txt":"",
      "svi.workflow.intel_report.1534937931623.description.txt":"",
      "svi.workflow.intel_report.1534937931623.label.txt":"Intel Report Workflow"
   },
   "startOnNewEntityInstance":false,
   "createAt":"2018-08-22T11:38:52.236Z",
   "createBy":"videmo",
   "lastUpdateAt":"2018-08-22T11:38:52.236Z",
   "lastUpdateBy":"videmo",
   "name":"intel_report_workflow",
   "label":"Intel Report Workflow",
   "workflowVersion":1
}

```


<a name="getWorkflow"></a>
### Get a list of workflows 
This list will display workflows available to run for the user to start a new process

**Request**
```
GET /svi-datahub/workflows/
     ?fields=id,name,entityLabel,startOnNewEntityInstance,workflowVersion,graphicalModel,lastUpdateBy,label
     &start=0&limit=20&sortBy=label%3Aascending

Headers:
 * Accept: application/vnd.sas.collection+json
```

**Response**
```
Status: 200
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
   "links":[
      {
         "method":"GET",
         "rel":"self",
         "href":"/workflows",
         "uri":"/workflows",
         "type": "application/vnd.sas.collection+json"
      },
      {
         "method":"POST",
         "rel":"create",
         "href":"/workflows",
         "uri":"/workflows",
         "type": "application/vnd.sas.investigation.workflow.workflow",
         "responseType": "application/vnd.sas.investigation.workflow.workflow+json"
      }
   ],
   "name":"workflows",
   "accept": "application/vnd.sas.investigation.workflow.workflow",
   "start":0,
   "count":1,
   "items":[
      {
         "links":[
            {
               "method":"GET",
               "rel":"self",
               "href":"/workflows/workflows/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac110013",
               "uri":"/workflows/workflows/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac110013",
               "type": "application/vnd.sas.investigation.workflow.workflow",
               "responseType": "application/vnd.sas.investigation.workflow.workflow+json"
            },
            {
               "method":"PUT",
               "rel":"create new version",
               "href":"/workflows/workflows/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac110013",
               "uri":"/workflows/workflows/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac110013",
               "type": "application/vnd.sas.investigation.workflow.workflow",
               "responseType": "application/vnd.sas.investigation.workflow.workflow+json"
            }
         ],
         "version":1,
         "entityLabel":"Intelligence Report",
         "id":"intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac110013",
         "startOnNewEntityInstance":true,
         "lastUpdateBy":"videmo",
         "name":"intel_report_workflow",
         "label":"Intel Report Workflow",
         "workflowVersion":4
      }
   ],
   "limit":2,
   "version":2
}

```

<a name="startWorkflow"></a>
### Start a new workflow process 
This will start workflow processes against the selected entity instances.  The return response includes the ids of the processes that were started from the request. There will be one process started per entity instance.

**Request**
```
POST /svi-datahub/workflows/workflows/intel_report_workflow:4:08e1a3a5-a179-11e8-9397-0242ac110013/processes
Headers:
 * Accept: application/vnd.sas.collection+json
 * Content-Type: application/vnd.sas.investigation.workflow.instance.context+json
Body:
[ { "entityInstanceId": "c9cea4e9-bc05-42ea-8666-64cedb04804a" } ]
```

**Response**
```
Status: 200
Headers:
  * Content-Type: application/vnd.sas.collection+json
Body:
{
   "links":[
      {
         "method":"GET",
         "rel":"self",
         "href":"/workflows/processes",
         "uri":"/workflows/processes",
         "type":"application/vnd.sas.fcs.workflow.workflowProcess"
      }
   ],
   "name":"workflowProcesses",
   "accept": "application/vnd.sas.investigation.workflow.process",
   "start":0,
   "count":1,
   "items":[
      {
         "links": [{
              "method": "GET",
              "rel": "self",
              "href": "/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac111543",
              "uri": "/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac111543",
              "type": "application/vnd.sas.investigation.workflow.process",
              "responseType": "application/vnd.sas.investigation.workflow.process+json"
            }, {
              "method": "PUT",
              "rel": "suspend",
              "href": "/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac111543/suspended",
              "uri": "/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac111543/suspended"
            }, {
              "method": "PUT",
              "rel": "resume",
              "href": "/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac111543/resumed",
              "uri": "/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac111543/resumed"
            }, {
              "method": "DELETE",
              "rel": "cancel",
              "href": "/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac111543",
              "uri": "/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac111543"
         }],
         "id":"5ef6f52f-a5fa-11e8-9397-0242ac111543"
      }
   ],
   "limit":1,
   "version":2
}
```

<a name="listTasks"></a>
### Get the pending tasks 
In this example, the user is retrieving the list of pending tasks they are allowed to work. A calling user can work a task if they are a valid participant (i.e. the participant list contains either the user  or a group the user belongs to) of the task and they pass the ELS check if the task requires a page prompt for the user to complete before completing the task. 

**Request**
```
GET /svi-datahub/workflows/processes/tasks?includeOnlyWorkableTasks=true&start=0&limit=20
     &sortBy=dueDateTimestamp%3Aascending
     &filter=and(eq(%24primary%2Cassignee%2C%27videmo%27)%2Ceq(isProcessInstanceSuspended%2Cfalse))
Headers:
 * Accept: application/vnd.sas.collection+json
 * VI-Client-Application: mobile
```

**Response**
```
Status: 200
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
   "links":[
      {
         "method":"GET",
         "rel":"self",
         "href":"/workflows/processes/tasks",
         "uri":"/workflows/processes/tasks",
         "type": "application/vnd.sas.collection"
      }
   ],
   "name":"workflowTasks",
   "accept": "application/vnd.sas.investigation.workflow.task",
   "start":0,
   "count":1,
   "items":[
      {
         "links":[
            {
               "method":"GET",
               "rel":"self",
               "href":"/workflows/processes/tasks/tasks/153f9964-a182-11e8-9397-0242ac110013",
               "uri":"/workflows/processes/tasks/tasks/153f9964-a182-11e8-9397-0242ac110013",
               "type": "application/vnd.sas.investigation.workflow.task",
               "responseType": "application/vnd.sas.investigation.workflow.task"
            },
            {
               "method":"PUT",
               "rel":"claim",
               "href":"/workflows/processes/tasks/tasks/153f9964-a182-11e8-9397-0242ac110013/claimed",
               "uri":"/workflows/processes/tasks/tasks/153f9964-a182-11e8-9397-0242ac110013/claimed",
               "type": "application/vnd.sas.investigation.workflow.task"
            },
            {
               "method":"PUT",
               "rel":"release",
               "href":"/workflows/processes/tasks/tasks/153f9964-a182-11e8-9397-0242ac110013/claimReleased",
               "uri":"/workflows/processes/tasks/tasks/153f9964-a182-11e8-9397-0242ac110013/claimReleased"
            },
            {
               "method":"PUT",
               "rel":"complete",
               "href":"/workflows/processes/tasks/tasks/153f9964-a182-11e8-9397-0242ac110013/completed",
               "uri":"/workflows/processes/tasks/tasks/153f9964-a182-11e8-9397-0242ac110013/completed",
               "type": "application/vnd.sas.investigation.workflow.action"
            }
         ],
         "version":1,
         "entityId":100514,
         "entityName":"person",
         "entityLabel":"Person",
         "workflowDefinitionId":"intel_report_workflow:4:08e1a3a5-a179-11e8-9397-0242ac110013",
         "workflowName":"intel_report_workflow",
         "workflowLabel":"Person Workflow",
         "workflowLabelResource":"svi.workflow.person.1534358933384.label.txt",
         "workflowDescriptionResource":"svi.workflow.person.1534358933384.description.txt",
         "workflowVersion":4,
         "entityInstanceId":"c9cea4e9-bc05-42ea-8666-64cedb04804a",
         "entityInstanceLabel":"sdf sdf",
         "id":"153f9964-a182-11e8-9397-0242ac110013",
         "name":"User Task 2",
         "definitionId":"UserTask1534358817462",
         "description":"User Task 2",
         "assignee":"videmo",
         "processInstanceId":"153deb9e-a182-11e8-9397-0242ac110013",
         "claimAt":"2018-08-16T18:33:37.998Z",
         "dueDateTimestamp":"2018-08-13T00:00:00.000Z",
         "participants":[
            {
               "id":"videmo",
               "type":"user",
               "name":"Test videmo"
            }
         ],
         "participantsVariable":{

         },
         "isClaimedByCurrentUser":true,
         "isProcessInstanceSuspended":false,
         "createAt":"2018-08-16T18:27:50.911Z",
         "actions":[
            {
               "id":"taskOption1534358817462",
               "name":"Completed",
               "pagePrompt" : {
                       "mobile": [{
                           "id": "5937c503-0869-4ba0-b11b-8ddafbc19656",
                           "name": "Person" }]
                }
            }
         ],
         "autoAssigneeVariable":{

         },
         "savedAssigneeOnCompleteVariable":{

         }
      }
   ],
   "limit":1,
   "version":2
}

```

<a name="claimTask"></a>
### Claim a task to work

**Request**
```
PUT /svi-datahub/workflows/processes/tasks/5ef79175-a5fa-11e8-9397-0242ac110013/claimed
Headers:
 * Content-Type = application/vnd.sas.investigation.workflow.task+json
 * VI-Client-Application: desktop
Body:
{assignee: "videmo"}
```

**Response**
```
Status: HTTP code
Status: 204
```

<a name="completeTask"></a>
### Complete a task 

**Request**

As a task may be completed via different actions, the user specifies which action to use.
```
PUT /svi-datahub/workflows/processes/tasks/5ef79175-a5fa-11e8-9397-0242ac110013/completed
Headers:
 * Content-Type = application/vnd.sas.investigation.workflow.action+json
 * VI-Client-Application: desktop
Body:
{id: "taskOption1534446735993"}
```

**Response**
```
Status: HTTP status code
Status: 204
```

<a name="viewProcess"></a>
### View the active processes
**Request**
```
GET /svi-datahub/workflows/processes/actives?start=0&limit=500&sortBy=entityLabel%3Aascending%2Cworkflow
Headers:
 * Accept: application/vnd.sas.collection+json
```

**Response**
```
Status: 200
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
   "links":[
      {
         "method":"GET",
         "rel":"self",
         "href":"/workflows/processes",
         "uri":"/workflows/processes",
         "type":"application/vnd.sas.fcs.workflow.workflowProcess"
      }
   ],
   "name":"workflowProcesses",
   "accept": "application/vnd.sas.investigation.workflow.process",
   "start":0,
   "count":1,
   "items":[
      {
         "links": [{
              "method": "GET",
              "rel": "self",
              "href": "/workflows/processes/processes/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac11001",
              "uri": "/workflows/processes/processes/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac11001",
              "type": "application/vnd.sas.investigation.workflow.process",
              "responseType": "application/vnd.sas.investigation.workflow.process+json"
            }, {
              "method": "PUT",
              "rel": "suspend",
              "href": "/workflows/processes/processes/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac11001/suspended",
              "uri": "/workflows/processes/processes/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac11001/suspended"
            }, {
              "method": "PUT",
              "rel": "resume",
              "href": "/workflows/processes/processes/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac11001/resumed",
              "uri": "/workflows/processes/processes/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac11001/resumed"
            }, {
              "method": "DELETE",
              "rel": "cancel",
              "href": "/workflows/processes/processes/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac11001",
              "uri": "/workflows/processes/processes/intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac11001"
         }],
         "version":1,
         "entityId":100513,
         "entityName":"intel_report",
         "entityLabel":"Intelligence Report",
         "workflowDefinitionId":"intel_report_workflow:4:4e4bfd6e-a5fa-11e8-9397-0242ac110013",
         "workflowName":"intel_report_workflow",
         "workflowLabel":"Intel Report Workflow",
         "workflowLabelResource":"svi.workflow.intel_report.1534446766062.label.txt",
         "workflowDescriptionResource":"svi.workflow.intel_report.1534446766062.description.txt",
         "workflowVersion":4,
         "entityInstanceId":"7a739103-9d8e-49ab-b8e5-fa120a298c06",
         "entityInstanceLabel":"test test",
         "id":"5ef6f52f-a5fa-11e8-9397-0242ac110013",
         "isSuspended":false,
         "lastResumeAt":"2018-08-22T11:12:20.470Z",
         "lastResumeBy":"videmo",
         "resumeFailed":false,
         "lastSuspendAt":"2018-08-22T11:11:16.468Z",
         "lastSuspendBy":"videmo",
         "suspendFailed":false,
         "startBy":"videmo",
         "startAt":"2018-08-22T10:58:58.845Z",
         "state":"RUNNING"
      }
   ],
   "limit":1,
   "version":2
}

```

<a name="suspendProcess"></a>
### Suspend the process 
**Request**
```
PUT /svi-datahub/workflows/processes/5ef6f52f-a5fa-11e8-9397-0242ac110013/suspended
```

**Response**
```
Status: HTTP status code
Status: 204 
```

<a name="suspendMultiSelectedProcesses"></a>
### Suspend multiple processes
In this request the user is suspending multiple processes that they have selected.  The user provides the list of process IDs to suspend. This request format also applies when the user attempts to resume or cancel multiple processes they have selected.

**Request**
```
POST /svi-datahub/workflows/processes
Headers:
 * Content-Type: application/vnd.sas.investigation.workflow.selection+json
Body:
{
  "resource":[
    "0d5bde1b-cd8c-11e8-9332-f4939fed3251",
    "408d6296-d31d-11e8-87d3-f4939fed3251",
    "d848bd93-d212-11e8-ba26-f4939fed3251"
  ]
}
```

**Response**
```
Status: HTTP status code
Status: 204
```

<a name="resumeProcess"></a>
### Resume the process 
**Request**
```
PUT /svi-datahub/workflows/processes/processes/5ef6f52f-a5fa-11e8-9397-0242ac110013/resumed
```

**Response**
```
Status: HTTP status code
Status: 204
```

<a name="getEntityMetrics"></a>
### View task metrics per entity 
This list will display workflow task metrics rolled-up to the entity level.

**Request**
```
GET /svi-datahub/workflows/entity/processes/history/metrics
     &startAt=2019-01-17 05:00:00.000&endAt=2019-02-01 05:00:00.000

Headers:
 * Accept: application/vnd.sas.collection+json
```

**Response**
```
Status: 200
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:

{
  "links": [{
    "method": "GET",
    "rel": "self",
    "href": "/workflows/processes",
    "uri": "/workflows/processes",
    "type": "application/vnd.sas.collection"
  }],
  "name": "workflowProcessHistoryMetricSummary",
  "accept": "application/vnd.sas.investigation.workflow.historical.metrics.summary",
  "start": 0,
  "count": 1,
  "items": [{
    "version": 1,
    "name": "person",
    "id": "person",
    "label": "Person",
    "meanTimePerTask": 8861798.406982422,
    "medianTimePerTask": 4412228.406982422,
    "timeOnCompletedTasks": 1906564.0,
    "timeOnUncompletedTasks": 1.0443501688378906E8,
    "meanTimePerTaskClaimTimeBasis": 8643283.656982422,
    "medianTimePerTaskClaimTimeBasis": 3508049.406982422,
    "timeOnCompletedTasksClaimTimeBasis": 1.0371940388378906E8,
    "timeOnUncompletedTasksClaimTimeBasis": 1.0371203688378906E8,
    "workflowNames": [{
      "id": "person_workflow",
      "name": "Person Workflow"
    }]
  }],
  "limit": 1,
  "version": 2
}

```

<a name="adminReleaseClaimOnTask"></a>
### Administrator release claim on a task

**Request**
```
PUT http://acme.localhost/svi-datahub/workflows/processes/tasks/tasks/ad74ba74-2baf-11e9-9fc0-f4939fed3251/claimReleased/administrator
```

**Response**
```
Status: HTTP code
Status: 204
```

<a name="adminMultiReleaseClaimOnTask"></a>
### Administrator release claim on multiple tasks
In this request the user with administrator capability is releasing the claims on multiple 
tasks that they have selected.  The user provides the list of task IDs on which to release 
the claim. This request format is consistent with other workflow batch requests (user 
without capaibity releasing claims, suspending/resuming/cancelling multiple processes).

**Request**
```
POST /svi-datahub/workflows/processes/tasks/claimReleased/administrator
Headers:
 * Content-Type: application/vnd.sas.investigation.workflow.selection+json
Body:
{
  "resource":[
    "b42bc89f-2baf-11e9-9fc0-f4939fed3251",
    "335f35cc-2d72-11e9-86c8-f4939fed3251",
    "094a707b-2cca-11e9-930f-f4939fed3251",
    "d37ed601-2bc4-11e9-b00f-f4939fed3251",
    "d37f242a-2bc4-11e9-b00f-f4939fed3251",
    "d7c3abbc-2bc4-11e9-b00f-f4939fed3251",
    "e10339dc-2bc4-11e9-b00f-f4939fed3251".
    "e523498d-2bc4-11e9-b00f-f4939fed3251"
  ]
}
```

**Response**
```
Status: HTTP status code
Status: 204 
```

<a name="viewWorkflowProcessHistory"></a>
### View workflow process history
In this example, the user is retrieving the history of all workflows except for those processes that a user chose to cancel.

**Request**
```
GET /svi-datahub/workflows/processes/history?removeCancelledProcesses=true&start=0&limit=100
    &sortBy=startedAt:descending
Headers:
 * Accept: application/vnd.sas.collection+json
```

**Response**
```
Status: 200
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
  "links": [{
    "method": "GET",
    "rel": "self",
    "href": "/workflows/processes/history",
    "uri": "/workflows/processes/history",
    "type": "application/vnd.sas.collection"
  }],
  "name": "workflowProcessHistory",
  "accept": "application/vnd.sas.investigation.workflow.historical.workflow.task",
  "start": 0,
  "count": 443,
  "items": [{
    "version": 1,
    "entityId": 100514,
    "entityName": "person",
    "entityLabel": "Person",
    "workflowDefinitionId": "person_workflow:2:877ed08b-2bc4-11e9-b00f-f4939fed3251",
    "workflowName": "person_workflow",
    "workflowLabel": "Person Workflow",
    "workflowLabelResource": "svi.workflow.person.1549633087059.label.txt",
    "workflowDescriptionResource": "svi.workflow.person.1549633087059.description.txt",
    "workflowVersion": 2,
    "entityInstanceId": "85490a37-e537-4352-90b1-8eb26906fa48",
    "entityInstanceLabel": "ll ll",
    "id": "036cbc80-2bc5-11e9-b00f-f4939fed3251",
    "name": "User Task PG2 All PP",
    "definitionId": "UserTask1549632873900",
    "processInstanceId": "036c9560-2bc5-11e9-b00f-f4939fed3251",
    "participants": [{
      "id": "sviusrs",
      "type": "group",
      "name": "Visual Investigator Users"
    }],
    "duration": 0,
    "startedAt": "2019-02-08T17:14:37.752Z"
  }, 
  :
  :
  ],
  "limit": 100,
  "version": 2
}

```

version 4, last updated on 19 March, 2021