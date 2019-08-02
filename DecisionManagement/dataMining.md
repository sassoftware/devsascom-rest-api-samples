# Data Mining API
The Data Mining API provides resources for training, scoring, and comparing data mining models.

## API Request Examples Grouped by Object Type

<details>
<summary>Modules</summary>

* [Score a Model](#ScoreModel)
</details>

<details>
<summary>Retraining</summary>

* [Download Retraining Sample Code](#DownloadRetrainingSampleCode)
* [Initiate Retraining](#InitiateRetraining)
* [Perform Batch Retraining](#PerformBatchRetraining)
* [Set Project Retrain State](#SetProjectRetrainState)
</details>

### Model REST APIs

##### <a name='ScoreModel'>Score a Model</a>
There are no HATEOAS links to this endpoint, but it is surfaced in the UI from the *Download Score API* action.
```
POST /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/models/2aa54b31-4a9d-426b-980f-d60286cef227/scoreExecutions?holdoutDataUri=/dataTables/dataSources/cas~fs~cas~fs~DMINE/tables/HMEQ HTTP/1.1

Host: example.com:80
Accept: application/vnd.sas.score.execution+json
```
*Note: This POST does not require a body.*

####  Retraining APIs
##### <a name='DownloadRetrainingSampleCode'>Download Retraining Sample Code</a>
This endpoint is referenced by the link with the *batchSampleCode* relation on a data mining project.
```
GET /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/retrainingSampleCode?type=sas HTTP/1.1
Host: example.com:80
Accept: application/vnd.sas.source.text+json
```

##### <a name='InitiateRetraining'>Initiate Retraining</a>
This endpoint is referenced by the link with the *startRetraining* relation on a data mining project.
```
POST /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/retrainJobs?dataUri=/dataTables/dataSources/cas~fs~cas~fs~DMINE HTTP/1.1
Host: example.com:80
Accept: application/vnd.sas.job.execution.job+json
```
*Note: This POST does not require a body.*

##### <a name='PerformBatchRetraining'>Perform Batch Retraining</a>
This endpoint is referenced by the link with the *startBatchRetraining* relation on a data mining project.
```
POST /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/retrainJobs?action=batch&dataUri=/dataTables/dataSources/cas~fs~cas~fs~DMINE HTTP/1.1
Host: example.com:80
Accept: application/vnd.sas.job.execution.job+json
```
*Note: This POST does not require a body.*

##### <a name='SetProjectRetrainState'>Set Project Retrain State</a>
This endpoint is referenced by the link with the *retrainingState* relation on a data mining project.

```
PUT /dataMining/projects/9d226d3d-f719-4d7b-bf89-cee2f9088cd0/retrainJobs?state=needed HTTP/1.1
Host: example.com:80
Accept: application/vnd.sas.analytics.project+json
```

version 4, last updated 08 Jul, 2019
