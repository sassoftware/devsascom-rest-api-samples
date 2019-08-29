# Model Publish API
The Model Publish API provides support for publishing objects (such as models) to publishing destinations such as CAS, Hadoop, SAS Micro Analytic Service, or Teradata.

Here are the functions that this service API provides:

* Define, update, and delete publishing destinations
* Publish models to a predefined destination
* Retrieve a list of published models

<b>Note:</b> By default all authenticated users can perform these functions.

#### Why Use this API?
This API enables users to publish objects to a predefined destination and can be called by other REST API services. For example, SAS Decision Manager can publish decisions and rule sets by calling the Model Publish service.

## API Request Examples Grouped by Object Type

<details>
<summary>Destinations</summary>

* [Create a CAS Destination](#CreateCASDestination)
* [Create a SAS Micro Analytic Service Destination](#CreateSASMASDestination)
* [Get the Collection of Destinations](#GetCollectionDestinations)
* [Create a Teradata Destination](#CreateTeradataDestination)
* [Create a Hadoop Destination](#CreateHadoopDestination)
* [Update a CAS Destination](#UpdateCASDestination)
* [Update a Teradata Destination](#UpdateTeradataDestination)
* [Update a Hadoop Destination](#UpdateHadoopDestination)
* [Get a Destination](#GetDestination)
* [Delete a Destination](#DeleteDestination)
* [Get the Collection of Destinations](#GetCollectionDestinations)
</details>

<details>
<summary>Publish</summary>

* [Publish a Model to a Destination](#PublishModelDestination)
* [Publish a Model with an Analytic Store to a Destination](#PublishModelAnalyticStoreDestination)
* [Get the Collection of Published models](#GetCollectionPublishedModels)
* [Get the Published Model](#GetPublishedModel)
</details>

#### <a name='CreateCASDestination'>Create a CAS Destination</a>
Here is an example of creating a definition for a CAS (SAS Cloud Analytic Services) publishing destination.

```
json {
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

```
json {
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination+json",
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

#### <a name='CreateTeradataDestination'>Create a Teradata Destination</a>
Here is an example of creating a definition for a Teradata publishing destination.

```
json {
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

```
json {
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

```
json {
  "PUT": "/modelPublish/destinations/{destinationId}",
  "headers": {
    "If-Match": <etag>,
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

```
json {
  "PUT": "/modelPublish/destinations/{destinationId}",
  "headers": {
    "If-Match": <etag>,
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

```
json {
  "POST": "/modelPublish/destinations/{destinationId}",
  "headers": {
    "If-Match": <etag>,
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

```
json {
  "GET": "/modelPublish/destinations/{destinationName}",
  "headers": {
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  }
}
```
<br>

#### <a name='DeleteDestination'>Delete a Destination</a>
Here is an example of deleting the publishing destination for a specified destination name.

```
json {
  "DELETE": "/modelPublish/destinations/{destinationName}"
}
```
<br>

#### <a name='GetCollectionDestinations'>Get the Collection of Destinations</a>
Here is an example of retrieving a list of the publishing destinations.

```
json {
  "GET": "/modelPublish/destinations",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

### <a name='PublishModelDestination'>Publish a Model to a Destination</a>
Here is an example of publishing a model to a specified publishing destination.

```
json {
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

```
json {
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

#### <a name='GetCollectionPublishedModels'>Get the Collection of Published models</a>
Here is an example of retrieving a list of published models.
```
json {
  "GET": "/modelPublish/models",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='GetPublishedModel'>Get the Published Model</a>
Here is an example of retrieving a published model.
```
json {
  "GET": "/modelPublish/models/{modelId}",
  "headers": {
    "Accept": "application/json"
  }
}
```

version 3, last updated on 14 May, 2019
