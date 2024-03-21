# Data Mining API
The Data Mining API provides resources for training, scoring, and comparing data mining models.

## API Request Examples Grouped by Object Type

<details>
<summary>Modules</summary>

* [Score a model](#score-model)
</details>

<details>
<summary>Retraining</summary>

* [Download retraining sample code](#download-retraining-sample-code)
* [Initiate retraining](#initiate-retraining)
* [Perform batch retraining](#perform-batch-retraining)
* [Set the project retrain state](#set-project-retrain-state)
</details>


#### <a name='score-model'>Score a Model</a>
Here is an example of an endpoint with no HATEOAS links, but it is surfaced in the UI from the *Download Score API* action.
```
POST /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/models/2aa54b31-4a9d-426b-980f-d60286cef227/scoreExecutions?holdoutDataUri=/dataTables/dataSources/cas~fs~cas~fs~DMINE/tables/HMEQ HTTP/1.1

Host: example.com:80
Accept: application/vnd.sas.score.execution+json
```
*Note: This POST does not require a body.*


#### <a name='download-retraining-sample-code'>Download Retraining Sample Code</a>
Here is an example of an endpoint that is referenced by the link with the *batchSampleCode* relation on a data mining project.
```
GET /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/retrainingSampleCode?type=sas HTTP/1.1
Host: example.com:80
Accept: application/vnd.sas.source.text+json
```

#### <a name='initiate-retraining'>Initiate Retraining</a>
Here is an example of an endpoint that is referenced by the link with the *startRetraining* relation on a data mining project.
```
POST /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/retrainJobs?dataUri=/dataTables/dataSources/cas~fs~cas~fs~DMINE HTTP/1.1
Host: example.com:80
Accept: application/vnd.sas.job.execution.job+json
```
*Note: This POST does not require a body.*

#### <a name='perform-batch-retraining'>Perform Batch Retraining</a>
Here is an example of an endpoint that is referenced by the link with the *startBatchRetraining* relation on a data mining project.
```
POST /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/retrainJobs?action=batch&dataUri=/dataTables/dataSources/cas~fs~cas~fs~DMINE HTTP/1.1
Host: example.com:80
Accept: application/vnd.sas.job.execution.job+json
```
*Note: This POST does not require a body.*

#### <a name='set-project-retrain-state'>Set the Project Retrain State</a>
Here is an example of an endpoint that is referenced by the link with the *retrainingState* relation on a data mining project.

```
PUT /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/retrainJobs?state=needed HTTP/1.1
Host: example.com:80
Accept: application/vnd.sas.analytics.project+json
```


version 5, last updated 19 NOV, 2019
