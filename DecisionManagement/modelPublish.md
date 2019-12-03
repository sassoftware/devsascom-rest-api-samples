# Model Publish API
The Model Publish API provides support for publishing objects (such as models) to Amazon Web Services (AWS), CAS, Hadoop, Private Docker, SAS Micro Analytic Service, or Teradata.

Here are the functions that this service API provides:

* Define, update, and delete publishing destinations
* Publish models, decisions, or rule sets to a predefined destination
* Retrieve a list of published models

<b>Note:</b> By default only SAS Administrators can define, update, and delete publishing destinations. Authenticated users can perform all of the other functions.

#### Why Use this API?
This API enables users to publish objects to a predefined destination and can be called by other REST API services. For example, SAS Decision Manager can publish decisions and rule sets by calling the Model Publish service.

## API Request Examples Grouped by Object Type

<details>
<summary>Destinations</summary>

* [Create a CAS destination](#CreateCASDestination)
* [Create a SAS Micro Analytic Service destination](#CreateSASMASDestination)
* [Create an Amazon Web Services destination](#CreateAWSDestination)
* [Create a private docker destination](#CreateDockerDestination)
* [Create a Teradata destination](#CreateTeradataDestination)
* [Create a Hadoop destination](#CreateHadoopDestination)
* [Update a CAS destination](#UpdateCASDestination)
* [Update a Teradata destination](#UpdateTeradataDestination)
* [Update a Hadoop destination](#UpdateHadoopDestination)
* [Get a destination](#GetDestination)
* [Delete a destination](#DeleteDestination)
* [Get the collection of destinations](#GetCollectionDestinations)
</details>

<details>
<summary>Publish Models</summary>

* [Publish a model to a destination](#PublishModelDestination)
* [Publish a model with an analytic store to a destination](#PublishModelAnalyticStoreDestination)
* [Get the collection of published models](#GetCollectionPublishedModels)
* [Get the published model](#GetPublishedModel)
</details>

<details>
<summary>See Also</summary>

* [Model Publish API documentation](https://developer.sas.com/apis/rest/DecisionManagement/#model-publish)
* [Define a remote SAS Micro Analytic Service publishing destination API tutorial](https://documentation.sas.com/?cdcId=edmcdc&cdcVersion=5.4&docsetId=edmresttut&docsetTarget=n11fzlp8s4zvson1gwv1xjty0099.htm&locale=en)
* [Publish a decision to the maslocal destination API tutorial](https://documentation.sas.com/?cdcId=edmcdc&cdcVersion=5.4&docsetId=edmresttut&docsetTarget=p0scry8g4y8v6gn13esxsf9jg9xp.htm&locale=en)
</details>

#### <a name='CreateCASDestination'>Create a CAS Destination</a>
Here is an example of creating a definition for a CAS (SAS Cloud Analytic Services) publishing destination.

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.cas",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"casDestination",
	"casServerName":"cas-shared-default",
	"casLibrary" : "Public",
	"destinationTable" : "sasmodels",
	"destinationType":"cas"
  }
}
```
<br>

#### <a name='CreateSASMASDestination'>Create a SAS Micro Analytic Service Destination</a>
Here is an example of creating a definition for a SAS Micro Analytic Service publishing destination that exists on an alternate SAS Viya deployment.

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.cas",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"remoteMasEnv",
	"masUri":"http://remoteViyaEnv.com",
	"authenticationDomain" : "remoteDomain",
	"destinationType":"microAnalyticService"
  }
}
```
<br>

#### <a name='CreateAWSDestination'>Create an Amazon Web Services Destination</a>
Here is an example of creating a definition for an Amazon Web Services (AWS) publishing destination.
If the property `accessKeyId` or `secretAccessKey` is not specified, the service uses the default AWS credentials provider chain.
If the property 'region' is not specified, the `us-east-1` property value is used by default.

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.aws",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"myAWS",
    "destinationType":"aws",
    "properties": [{"name": "accessKeyId",                
                 "value": "myKeyId"},
                {"name": "secretAccessKey",                 
                 "value": "myAccessKey"},
                {"name": "region",                 
                 "value": "us-east-1"},
                {"name": "kubernetesCluster",                 
                 "value": "myEks"}
                   ]
  }
}
```
<br>

#### <a name='CreateDockerDestination'>Create a Private Docker Destination</a>
Here is an example of creating a definition for a private docker publishing destination. 
The property `baseRepoUrl` is required. If the property `dockerHost` is not specified, the service uses the docker socket in the local system by default.

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.privatedocker",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"myDocker",
    "destinationType":"privateDocker",
    "properties": [{"name": "baseRepoUrl",                
                 "value": "docker.mycompany.com/myfolder"},
                 {"name": "dockerHost",                
                 "value": "tcp://10.10.10.88:2375"}
                  ]
  }
}
```
<br>

#### <a name='CreateTeradataDestination'>Create a Teradata Destination</a>
Here is an example of creating a definition for a Teradata publishing destination.

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.teradata",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
        "name":"teradataDestination",
        "casServerName":"cas-shared-default",
        "casLibrary" : "Public",
        "destinationType":"teradata",
        "databaseCasLibrary": "teradatalibrary",
        "destinationTable":"ModelTable"
  }
}
```
<br>

#### <a name='CreateHadoopDestination'>Create a Hadoop Destination</a>
Here is an example of creating a definition for a Hadoop publishing destination.

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.hadoop",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"hadoopDestination",
	"casServerName":"cas-shared-default",
	"casLibrary" : "hadoopLibrary",
	"destinationType":"hadoop",
	"hdfsDir":"/data/model/dlm/ds2",
	"configDir":"/opt/sas/hadoop/hadoopjars/cdh58p1/prod:/opt/sas/hadoop/hadoopcfg/cdh58p1/prod"
  }
}
```
<br>

#### <a name='UpdateCASDestination'>Update a CAS Destination</a>
Here is an example of updating the description for a CAS publishing destination.

```json
{
  "PUT": "/modelPublish/destinations/{destinationId}",
  "headers": {
    "If-Match": "<etag>",
    "Content-Type": "application/vnd.sas.models.publishing.destination.cas",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"casDestination",
	"casServerName":"cas-shared-default",
	"casLibrary" : "Public",
	"destinationTable" : "sasmodels",
	"destinationType":"cas",
	"description":"new description"
  }
}
```
<br>

#### <a name='UpdateTeradataDestination'>Update a Teradata Destination</a>
Here is an example of updating the description for a Teradata publishing destination.

```json
{
  "PUT": "/modelPublish/destinations/{destinationId}",
  "headers": {
    "If-Match": "<etag>",
    "Content-Type": "application/vnd.sas.models.publishing.destination.teradata",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
        "name":"teradataDestination",
        "casServerName":"cas-shared-default",
        "casLibrary" : "Public",
        "destinationType":"teradata",
        "databaseCasLibrary": "teradatalibrary",
        "destinationTable":"ModelTable",
        "description":"new description"
  }
}
```
<br>

#### <a name='UpdateHadoopDestination'>Update a Hadoop Destination</a>
Here is an example of updating the description for a Hadoop publishing destination.

```json
{
  "POST": "/modelPublish/destinations/{destinationId}",
  "headers": {
    "If-Match": "<etag>",
    "Content-Type": "application/vnd.sas.models.publishing.destination.hadoop",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"hadoopDestination",
	"casServerName":"cas-shared-default",
	"casLibrary" : "hadoopLibrary",
	"destinationType":"hadoop",
	"hdfsDir":"/data/model/dlm/ds2",
	"configDir":"/opt/sas/hadoop/hadoopjars/cdh58p1/prod:/opt/sas/hadoop/hadoopcfg/cdh58p1/prod",
	"description":"new description"
  }
}
```
<br>

#### <a name='GetDestination'>Get a Destination</a>
Here is an example of retrieving the definition for a specified destination name.

```json
{
  "GET": "/modelPublish/destinations/{destinationName}",
  "headers": {
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  }
}
```
<br>

#### <a name='DeleteDestination'>Delete a Destination</a>
Here is an example of deleting the publishing destination for a specified destination name.

```json
{
  "DELETE": "/modelPublish/destinations/{destinationName}"
}
```
<br>

#### <a name='GetCollectionDestinations'>Get the Collection of Destinations</a>
Here is an example of retrieving a list of the publishing destinations.

```json
{
  "GET": "/modelPublish/destinations",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='PublishModelDestination'>Publish a Model to a Destination</a>
Here is an example of publishing a model to a specified publishing destination.

```json
{
  "POST": "/modelPublish/models",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.request",
    "Accept": "application/vnd.sas.models.publishing.model+json"
  },
  "body": {
	"name": "Published model name",
    "note": "Publishing a model",
    "modelContents":[
        {
            "modelName": "model1",
            "modelId": "modelId1",
            "codeType": "datastep",
            "code":"Enter valid DATA step code here",
            "analyticStoreUri": "",
            "sourceUri": "/modelRepository/models/{modelId}"
         }
         ],
     "destinationName":"teradataDestination"
  }
}
```
<br>


#### <a name='PublishModelAnalyticStoreDestination'>Publish a Model with an Analytic Store to a Destination</a>
Here is an example of publishing a model that contains an analytic store CAS table to a specified destination.

```json
{
  "POST": "/modelPublish/models",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.request",
    "Accept": "application/vnd.sas.models.publishing.model+json"
  },
  "body": {
	"name": "Published model name",
    "note": "Publishing a model",
    "modelContents":[
        {
            "modelName": "model1",
            "modelId": "modelId1",
            "codeType": "ds2",
            "code":"valid ds2 EP code",
            "analyticStoreUri":"/dataTables/dataSources/cas~fs~cas-shared-default~fs~HPS/tables/astortablename",
            "sourceUri": "/modelRepository/models/{modelId}"
         }
         ],
     "destinationName":"teradataDestination"
  }
}
```
<br>

#### <a name='GetCollectionPublishedModels'>Get the Collection of Published Models</a>
Here is an example of retrieving a list of published models.

```json
{
  "GET": "/modelPublish/models",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='GetPublishedModel'>Get the Published Model</a>
Here is an example of retrieving a published model.

```json
{
  "GET": "/modelPublish/models/{modelId}",
  "headers": {
    "Accept": "application/json"
  }
}
```


version 4, last updated on 21 Nov, 2019
