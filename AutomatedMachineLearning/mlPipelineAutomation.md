# Machine Learning Pipeline Automation

The Machine Learning Pipeline Automation API provides a set of endpoints
that enable you to automatically train predictive models. Business users can use these models to make business decisions.

Leveraging statistics and machine learning expertise at SAS, the Machine Learning Pipeline Automation API takes modeling-ready data, and does the following:

*  Executes data pre-processing steps, including optimal transformations and imputations, variable selection, and feature engineering.
*  Generates data analysis pipelines.
*  Trains algorithms.
*  Optimizes models that can be used to predict outcomes or support business decisions.

Once initiated, this automated process requires no further user input, which
removes manual and repetitive tasks from the business user workflow.

The service runs multiple steps of pre-processing, modeling, post-processing (ensembling),
and evaluates top models. The result is a dynamic, automated machine learning project that is transparent to the user.
The project is accessible from SAS Model Studio, with model assessment and interpretability reports. The accuracy backed by the leading machine learning libraries helps
empower businesses to make decisions in an agile environment. No statistics expertise is required.

## API Request Examples Grouped by Object Type

*  [Entry point](#entry-point)
*  [Creating automation projects](#creating-automation-projects)
*  [Querying all automation projects](#querying-all-automation-projects)
*  [Querying individual automation projects](#querying-individual-automation-projects)
*  [Updating automation projects](#updating-automation-projects)
*  [Retraining an automation project](#retraining-an-automation-project)
*  [Querying automation project state](#querying-automation-project-state)
*  [Updating automation project state](#updating-automation-project-state)
*  [Deleting automation projects](#deleting-automation-projects)
*  [Propagating deletion of an automation project](#propagating-deletion-of-an-automation-project)
*  [Champion model](#champion-model)
*  [Pipeline templates](#pipeline-templates)

#### <a name='entry-point'>Entry Point</a>
An entry point to the service. The response to this GET request provides the links for users
to create an automation project and to query existing projects.

##### Request
```
GET /mlPipelineAutomation HTTP/1.1
Accept: application/vnd.sas.api+json
```

##### Response
```
{
    "version": 3,
    "links": [
        {
            "method": "GET",
            "rel": "collection",
            "href": "/mlPipelineAutomation/projects",
            "uri": "/mlPipelineAutomation/projects",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        },
        {
            "method": "POST",
            "rel": "createProject",
            "href": "/mlPipelineAutomation/projects",
            "uri": "/mlPipelineAutomation/projects",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        }
    ]
}
```

#### <a name='creating-automation-projects'>Creating Automation Projects</a>
A user begins using the service by creating an automation project. The Machine Learning Pipeline Automation
API uses the following attributes: user-supplied project
name, data table URI and target variable, and other attributes. The service creates an underlying analytics (VDMML) project, executes multiple steps of pre-processing, builds a data analysis
pipeline, and runs the pipeline to completion. The entire process is fully automated without further user intervention.

The request body is structured in three sections.

- Key information of the automation project
  - Automation project ID (automatically created by the service, read-only)
  - Name of the project (a random string is appended to ensure uniqueness)
  - Description of the project
  - Project type (only "predictive" type is supported)
  - Data table URI
  - Project state
  - The pipeline build method (either "automatic" or "template")
- Automation project settings, grouped under "settings"
  - A properties bag through which a user can pass arbitrary key/value pairs, regardless if they are
    used. The properties currently used are as follows.
    - applyGlobalMetadata (a flag to indicate whether to apply global metadata during project creation.
      Default is set to true.)
    - autoRun (a flag to indicate whether to automatically start pipeline run at the time of
      project creation. Default is set to true.)
    - locale (a locale string used for translating automatically generated content. Default is set to "en")
    - maxModelingTime (a positive double indicating the maximum amount of time in minutes to spend modeling.
      Default is set to 0.0)
    - modelingMode: (a string indicating the strategy to use when modeling. Default is set to Standard.)
    - numberOfModels (a positive integer to indicate maximum number of top models to return. Default
      is set to 5)

- Analytics project attributes, grouped under "analyticsProjectAttributes"

  - Analytics project ID (automatically created by the service, read-only)
  - Target variable
  - Target event level
  - classSelectionStatistic (a string to indicate class selection statistic, dependent upon the type
    of target variable. For 'BINARY' and 'NOMINAL' target variable types, the accepted values are
    listed below, where the default is set to 'ks'. The 'ORDINAL' target variable type is not
    supported.)
      - acc: Accuracy
      - ase: Average squared error
      - c: Area under curve (C statistic)
      - capturedResponse: Captured response
      - cumulativeCapturedResponse: Cumulative captured response
      - cumulativeLift: Cumulative lift
      - f1: F1 score
      - fdr: False discovery rate
      - fpr: False positive rate
      - gain: Gain
      - gini: Gini
      - ks: Kolmogorov-Smirnov statistic
      - ks2: ROC separation
      - lift: Lift
      - misclassificationEvent: Misclassification (Event)
      - mce: Misclassification (MCE)
      - mcll: Multiclass log loss
      - rase: Root average squared error
      - misclassificationCutoff: Misclassification at cutoff
  - intervalSelectionStatistic (a string to indicate interval selection statistic, dependent upon
    the type of target variable. For 'INTERVAL' target variable types, the accepted values are
    listed below, where the default is set to 'ase'. This field is ignored for all other types,
    like 'BINARY', 'NOMINAL', or 'ORDINAL'.)
      - ase: Average squared error
      - rase: Root average squared error
      - rmae: Root mean absolute error
      - rmsle: Root mean squared logarithmic error
  - Partition enabled flag
  - Selection depth
  - Selection partition
  - Override classification cutoff enabled flag
  - Override classification cutoff value
  - Cutoff percentage
  - Number of cutoff values
  - Sampling enabled flag
  - Sampling percentage

##### Request for Project with an Automatically Generated Pipeline
```
POST /mlPipelineAutomation/projects HTTP/1.1
Accept: application/vnd.sas.analytics.ml.pipeline.automation.project+json

{
    "name": "Test Project Creation",
    "dataTableUri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~Public/tables/APITESTHMEQ",
    "type": "predictive",
    "pipelineBuildMethod": "automatic",
    "analyticsProjectAttributes": {
        "targetVariable" : "BAD",
        "partitionEnabled" : true,
        "targetEventLevel" : "1"
    },
    "settings": {
        "applyGlobalMetadata" : false
    }
}
```

##### Response
```
202 Accepted
Content-Type: application/vnd.sas.analytics.ml.pipeline.automation.project+json

{
    "creationTimeStamp": "2018-11-29T21:03:42.397Z",
    "modifiedTimeStamp": "2018-11-29T21:04:10.372Z",
    "createdBy": "emduser4",
    "modifiedBy": "emduser4",
    "id": "7bb9805c-e981-44a9-bd10-4ccf18153cb3",
    "links": [
        {
            "method": "GET",
            "rel": "up",
            "href": "/mlPipelineAutomation/projects",
            "uri": "/mlPipelineAutomation/projects",
            "type": "application/vnd.sas.collection+json",
            "itemType": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        },
        {
            "method": "GET",
            "rel": "self",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3"
        },
        {
            "method": "DELETE",
            "rel": "propagateDelete",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3?propagate=true",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3?propagate=true"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3/state",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3/state",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "updateState",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3/state?value={value}",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3/state?value={value}",
            "responseType": "text/plain"
        }
    ],
    "name": "Test Project Creation (By MLPA FT4Pp)",
    "description": "",
    "revision": 2,
    "version": 3,
    "dataTableUri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~Public/tables/APITESTHMEQ",
    "type": "predictive",
    "pipelineBuildMethod": "automatic",
    "state": "pending",
    "analyticsProjectAttributes": {
      "analyticsProjectId": "37ca55af-e625-4062-b11e-55ba9ba0e742",
      "targetVariable": "BAD",
      "intervalSelectionStatistic": "ase",
      "classSelectionStatistic": "ks",
      "selectionDepth": 10,
      "selectionPartition": "default",
      "partitionEnabled": true,
      "cutoffPercentage": 50,
      "numberOfCutoffValues": 20,
      "samplingEnabled": "AUTO",
      "samplingPercentage": 50.0
    },
    "settings": {
      "numberOfModels": 5,
      "modelingMode": "Standard",
      "maxModelingTime": 0.0,
      "autoRun": true,
      "applyGlobalMetadata": true,
      "locale": "zh-CN"
    }
}
```

##### Request for Project with Pipeline Built from a Pre-defined Template

```
POST /mlPipelineAutomation/projects HTTP/1.1
Accept: application/vnd.sas.analytics.ml.pipeline.automation.project+json

{
    "name": "Test Project Creation",
    "dataTableUri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~Public/tables/APITESTHMEQ",
    "type": "predictive",
    "pipelineBuildMethod": "template",
    "analyticsProjectAttributes": {
        "targetVariable" : "BAD",
        "partitionEnabled" : true,
        "targetEventLevel" : "1"
    },
    "settings": {
        "applyGlobalMetadata" : false
    },
    "links": [
            {
                "method": "GET",
                "rel": "initialPipelineTemplate",
                "href": "/analyticsGateway/pipelineTemplates/dm.advancedbinarytargetautotunepl.template",
                "uri": "/analyticsGateway/pipelineTemplates/dm.advancedbinarytargetautotunepl.template",
                "type": "application/vnd.sas.analytics.pipeline.template"
            }
    ]
}
```

##### Response
```
202 Accepted
Content-Type: application/vnd.sas.analytics.ml.pipeline.automation.project+json

{
    "creationTimeStamp": "2018-11-29T21:03:42.397Z",
    "modifiedTimeStamp": "2018-11-29T21:04:10.372Z",
    "createdBy": "emduser4",
    "modifiedBy": "emduser4",
    "id": "7bb9805c-e981-44a9-bd10-4ccf18153cb3",
    "links": [
        {
            "method": "GET",
            "rel": "up",
            "href": "/mlPipelineAutomation/projects",
            "uri": "/mlPipelineAutomation/projects",
            "type": "application/vnd.sas.collection+json",
            "itemType": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        },
        {
            "method": "GET",
            "rel": "self",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3"
        },
        {
            "method": "DELETE",
            "rel": "propagateDelete",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3?propagate=true",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3?propagate=true"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3/state",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3/state",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "updateState",
            "href": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3/state?value={value}",
            "uri": "/mlPipelineAutomation/projects/7bb9805c-e981-44a9-bd10-4ccf18153cb3/state?value={value}",
            "responseType": "text/plain"
        }
    ],
    "name": "Test Project Creation (By MLPA FT4Pp)",
    "description": "",
    "revision": 2,
    "version": 3,
    "dataTableUri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~Public/tables/APITESTHMEQ",
    "type": "predictive",
    "pipelineBuildMethod": "template",
    "state": "waiting",
    "analyticsProjectAttributes": {
      "analyticsProjectId": "37ca55af-e625-4062-b11e-55ba9ba0e742",
      "targetVariable" : "BAD",
      "partitionEnabled" : true,
      "targetEventLevel" : "1"
    },
    "settings": {
      "applyGlobalMetadata" : false
    }
}
```

#### <a name='querying-all-automation-projects'>Querying All Automation Projects</a>
A GET request sent to the `/mlPipelineAutomation/projects` endpoint makes the service query its database and
return a collection of existing automation projects. The parameters for this query are as follows:

| Parameter | Format          | Description                                              | Example
|-----------|:---------------:|----------------------------------------------------------|----------
| start     | Int             | The starting index in the database to search from.       | start=42
| limit     | Int             | The max number of projects to return.                    | limit=10
| sortBy    | \<key>:\<value> | Upon which parameter the results should be sorted.       | sortBy=projectId:descending
| filter    | Expression      | The filter to apply to the query results.                | filter=eq(projectId, example-value)

##### Request
```
GET /mlPipelineAutomation/projects?start=0&limit=2&sortBy=projectId:ascending&filter=eq(projectId, exampleId) HTTP/1.1
Accept: application/vnd.sas.collection+json
```

#### <a name='querying-individual-automation-projects'>Querying Individual Automation Projects</a>
The response is similar to the [Creating Automation Projects](#creating-automation-projects)
section. The response includes links to various operations on the project, such as starting or stopping the project, updating project settings and attributes, deleting the project, and so on.

##### Request
```
GET /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992 HTTP/1.1
Accept: application/vnd.sas.analytics.ml.pipeline.automation.project+json
```

#### <a name='updating-automation-projects'>Updating Automation Projects</a>
In some cases, the user could select the wrong data set or target variables accidentally when creating
an automation project. The project might fail to run or the result might not be what the user intended.
The ability to update an automation project comes to rescue in those cases, where the user can update
the project's attributes and settings with the following request and rerun the project. See [Updating Automation Project State](#updating-automation-project-state).

This API is solely used for updating a project’s parameters. There is a separate endpoint for
updating the state of a project, such as stopping or restarting a project run.

We do not support PATCH operation to update the automation project with changes only. According to
standard, the user must enter the full project info in this PUT request, regardless if the parameters are to be changed.

List of parameters that can be updated.

- name
- description
- dataTableUri
- settings
- analyticsProjectAttributes (all analytics attributes can be changed, except analytics project ID)

List of parameters that cannot be updated. Any changes are ignored.

- id
- type
- analyticsProjectId
- common fields associated with all revision tracking resources
  - creationTimestamp
  - modifiedTimestamp
  - createdBy
  - modifiedBy
  - version

List of parameters that cannot be updated. Any changes cause 4xx error responses to be sent
back to the client.

- state (error code 409)
- revision (error code 412)

##### Request
```
PUT /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992 HTTP/1.1
If-Match: 'Y29tLnNhcy5hbmFseXRpY3MuZGF0YW1pbmluZy5zZXR0aW5ncy5Qcm9qZWN0U2V0dGluZ3M=2'
Content-Type: application/vnd.sas.analytics.ml.pipeline.automation.project+json
Accept: application/vnd.sas.analytics.ml.pipeline.automation.project+json

{
    "name": "Modified Project Name",
    "dataTableUri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~Public/tables/APITESTHMEQ",
    "type": "predictive",
    "analyticsProjectAttributes": {
        "targetVariable" : "JOB",
        "targetEventLevel" : "0"
    }
}
```
#### <a name='retraining-an-automation-project'>Retraining an Automation Project</a>
To retrain an automation project with changed parameters, use the retrainProject endpoint. By default, the service generates a new automated pipeline. This behavior can be overwritten with an optional query parameter
`replacePreviousPipelines`. When set to true, the parameter instructs the service to remove all previous
automatically generated pipelines before creating a new pipeline.

##### Request
```
PUT /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992?action=retrainProject HTTP/1.1
If-Match: 'Y29tLnNhcy5hbmFseXRpY3MuZGF0YW1pbmluZy5zZXR0aW5ncy5Qcm9qZWN0U2V0dGluZ3M=2'
Content-Type: application/vnd.sas.analytics.ml.pipeline.automation.project+json
Accept: application/vnd.sas.analytics.ml.pipeline.automation.project+json

{
    "name": "Modified Project Name",
    "dataTableUri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~Public/tables/APITESTHMEQ",
    "analyticsProjectAttributes": {
        "targetVariable" : "JOB",
        "targetEventLevel" : "1"
    }
}
```

#### <a name='querying-automation-project-state'>Querying Automation Project State</a>
Automation project state can be one of these enum values.

- pending: indicates that the underlying analytics project was created but has not been run yet.
- preparing: indicates that the underlying analytics project and pipeline metadata is being updated.
- waiting: indicates that the data is being profiled.
- ready: indicates that the underlying analytics project is prepared and ready to submit CASL code.
- modeling: indicates that models are being composed and compared on CASL server.
- constructingPipeline: indicates that pipelines are being built on CASL server.
- runningPipeline: indicates that pipelines are being run on CASL server.
- quiescing: indicates that the user request to quiesce the project modeling has been received.
- quiesced: indicates that project modeling is being stopped in response to the user's quiescing request.
- completed: indicates that the underlying analytics project has run to completion without errors.
- canceled: indicates that the underlying analytics project run was canceled by user.
- failed: indicates that the underlying analytics project has encountered errors during pipeline run and has stopped.
- oversampling: indicates that the data is being oversampled and must be profiled again before modeling continues.
- retraining: indicates that the retraining process has begun.

##### Request
```
GET /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/state HTTP/1.1
```

##### Response
```
200 Ok
Content-Type: text/plain

runningPipeline
```

#### <a name='updating-automation-project-state'>Updating Automation Project State</a>

To stop the automated modeling process, a user can issue a PUT request with
state 'quiescing'. This state transition is only valid when the automation
project is in the 'modeling' state. If the project has progressed past the
modeling state at the time of the request, the request will be ignored. After a
successful request, the project will reflect the updated 'quiescing' state,
complete any currently running models, and attempt to construct the best
available pipeline at that point.

##### Request to Update an Automation Project State

```html
PUT /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/state?value=quiescing HTTP/1.1
```

##### Response to Update an Automation Project State

```html
200 Ok
Content-Type: text/plain

quiescing
```

#### <a name='deleting-automation-projects'>Deleting Automation Projects</a>
When it is not needed anymore, the automation project can be deleted with the request below. By
default, this API deletes the automation project while keeping its associated analytics project.
To delete both projects, use this API
([Propagating Deletion of an Automation Project](#propagating-deletion-of-an-automation-project))

##### Request
```
DELETE /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992 HTTP/1.1
```

#### <a name='propagating-deletion-of-an-automation-project'>Propagating Deletion of an Automation Project</a>
This API can be used to delete both automation and analytics project.

##### Request
```
DELETE /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992?propagate=true HTTP/1.1
```

#### <a name='champion-model'>Champion Model</a>

##### Retrieving a Champion Model

###### Request
```
GET /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/models/@championModel HTTP/1.1
```

###### Response
```
200 OK
Content-Type: application/vnd.sas.analytics.ml.pipeline.automation.project.champion.model+json

{
    "name": "Forest",
    "links": [
        {
            "method": "GET",
            "rel": "up",
            "href": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06",
            "uri": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.project"
        },
        {
            "method": "GET",
            "rel": "self",
            "href": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel",
            "uri": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.project.champion.model"
        },
        {
            "method": "GET",
            "rel": "championModelReports",
            "href": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel/reports",
            "uri": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel/reports",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "PUT",
            "rel": "registerChampionModel",
            "href": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel?action=register",
            "uri": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel?action=register"
        },
        {
            "method": "PUT",
            "rel": "publishChampionModel",
            "href": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel?action=publish",
            "uri": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel?action=publish"
        },
        {
            "method": "POST",
            "rel": "scoreData",
            "href": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel/scoreData",
            "uri": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel/scoreData",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.score.data.input",
            "responseType": "application/vnd.sas.analytics.ml.pipeline.automation.score.data.output"
        }
    ],
    "publishDestinations": [
        {
            "name": "maslocal",
            "description": "The default publishing destination for the Micro Analytic Score service.",
            "destinationType": "microAnalyticService"
        }
    ]
}
```

##### Retrieving Champion Model Reports

###### Request
```
GET /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/models/@championModel/reports HTTP/1.1
```

###### Response
```
200 OK
Content-Type: application/vnd.sas.collection+json

{
    "version": 2,
    "accept": "application/vnd.sas.collection+json",
    "count": 2,
    "start": 0,
    "limit": 0,
    "name": "collection",
    "items": [
        {
            "creationTimeStamp": "0001-01-01T00:00:00Z",
            "modifiedTimeStamp": "0001-01-01T00:00:00Z",
            "revision": 0,
            "name": "iterplot",
            "description": "Average Squared Error",
            "links": [
                {
                    "method": "GET",
                    "rel": "document",
                    "href": "/naturalLanguageGeneration/documents/1539c745-166e-48cc-941b-08fb41190d9d",
                    "uri": "/naturalLanguageGeneration/documents/1539c745-166e-48cc-941b-08fb41190d9d",
                    "type": "application/vnd.sas.cognitive.natural.language.generation.document"
                }
            ],
            "version": 0,
            "groupName": "SAS",
            "order": 1001,
            "type": "seriesPlot",
            "parameterMap": {
                "ASE": {
                    "label": "Average Squared Error",
                    "length": 8,
                    "order": 4,
                    "parameter": "ASE",
                    "preformatted": false,
                    "type": "num",
                    "values": [
                        "ASE"
                    ]
                },
                // remainder omitted for brevity
            },
            "data": [
                {
                    "dataMap": {
                        "ASE": "0.0904249061688",
                        "DataSource": "TRAIN",
                        "MISC": "0.124161073826",
                        "Trees": "1"
                    },
                    "rowNumber": 1
                },
                // remainder omitted for brevity
            ],
            "xInteger": false,
            "yInteger": false
        },
        // remainder omitted for brevity
    ],
    "links": [
        {
            "method": "GET",
            "rel": "up",
            "href": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel",
            "uri": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel",
            "type": "application/vnd.sas.analytics.ml.pipeline.automation.project.champion.model"
        },
        {
            "method": "GET",
            "rel": "self",
            "href": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel/reports?reportName=iterplot&reportName=varimportance&reportName=dmcas_lift&reportName=dmcas_roc&reportName=dmcas_fitstat&reportName=dmcas_misc&reportName=dmcas_miscTable&reportName=dmcas_nommisc",
            "uri": "/mlPipelineAutomation/projects/f90e6f2e-8dcc-4bd5-9fcb-f7a4fa9b2d06/models/@championModel/reports?reportName=iterplot&reportName=varimportance&reportName=dmcas_lift&reportName=dmcas_roc&reportName=dmcas_fitstat&reportName=dmcas_misc&reportName=dmcas_miscTable&reportName=dmcas_nommisc",
            "type": "application/vnd.sas.collection"
        }
    ]
}
```

##### Retrieving Champion Model Reports with Filter
The `reportName` parameter can be used to specify one or multiple specific reports 
to be retrieved. If the reportName parameter is not included, a list of default
reports are returned. The default reports returned by target type are:
- Binary
    - iterplot
    - varimportance
    - dmcas_lift
    - dmcas_roc
    - dmcas_fitstat
    - dmcas_misc. The default
- Interval
    - iterplot
    - varimportance
    - dmcas_lift
    - dmcas_fitstat
- Nominal
    - dmcas_lift
    - dmcas_roc
    - dmcas_fitstat
    - dmcas_misc
    - dmcas_miscTable
    - dmcas_nommisc

###### Request
```
GET /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/models/@championModel/reports?reportName=iterplot&reportName=varimportance HTTP/1.1
```

##### Registering Champion Model with SAS Model Manager
```
PUT /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/models/@championModel?action=register HTTP/1.1
```

##### Publishing Champion Model
```
PUT /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/models/@championModel?action=publish&destinationName=maslocal HTTP/1.1
```

##### Score Individual Data
```
POST /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/models/@championModel/scoreData HTTP/1.1
Content-Type: application/vnd.sas.analytics.ml.pipeline.automation.score.data.input+json
Accept: application/vnd.sas.analytics.ml.pipeline.automation.score.data.output+json

{
    "scoreType": "Individual",
    "destinationName": "maslocal",
    "inputs": [
        {
            "name": "CLAGE",
            "value": 300
        },
        {
            "name": "DEBTINC",
            "value": 24.5
        },
        ...
        {
            "name": "JOB",
            "value": "Other"
        }
    ]
}
```

##### Score Bulk Data
```
POST /mlPipelineAutomation/projects/981738b3-10b4-48ce-8911-17b1132b7992/models/@championModel/scoreData HTTP/1.1
Content-Type: application/vnd.sas.analytics.ml.pipeline.automation.score.data.input+json
Accept: application/vnd.sas.analytics.ml.pipeline.automation.score.data.output+json

{
    "scoreType": "Bulk",
    "inputDataTableUri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~Public/tables/MyData",
    "scoreOutputCaslibUri": "/dataSources/providers/cas/sources/cas-shared-default~fs~Public",
    "scoreOutputTableName": "ScoreOutputs"
}
```

#### <a name='pipeline-templates'>Pipeline Templates</a>

##### Retrieving Pipeline Templates

###### Request
```
GET /mlPipelineAutomation/pipelineTemplates HTTP/1.1
```

##### Retrieving a Single Pipeline Template

###### Request
```
GET /mlPipelineAutomation/pipelineTemplates/dm.basicbinarytargetpl.template HTTP/1.1
```

###### Response
```
{
    "id": "dm.basicbinarytargetpl.template",
    "name": "Basic template for class target",
    "description": "Data mining pipeline that contains a Data, Imputation, Logistic Regression, and Model Comparison node connected in a linear flow.",
    "links": [
    {
        "method": "GET",
        "rel": "up",
        "href": "/mlPipelineAutomation/pipelineTemplates",
        "uri": "/mlPipelineAutomation/pipelineTemplates",
        "type": "application/vnd.sas.collection"
    },
    {
        "method": "GET",
        "rel": "self",
        "href": "/mlPipelineAutomation/pipelineTemplates/dm.basicbinarytargetpl.template",
        "uri": "/mlPipelineAutomation/pipelineTemplates/dm.basicbinarytargetpl.template",
        "type": "application/vnd.sas.analytics.machine.learning.pipeline.template"
    }],
    "creationTimeStamp": "2021-02-09T17:12:55.06Z",
    "createdBy": "sas.dataMining",
    "modifiedTimeStamp": "2021-02-09T17:12:55.064Z",
    "modifiedBy": "sas.dataMining",
}
```

version 3, last updated on 16 June, 2021
