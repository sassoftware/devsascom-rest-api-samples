# Model Publish API 
The Model Publish API provides support for publishing objects to CAS, Git, Hadoop, Private Docker, SAS Micro Analytic Service, or Teradata, as well as Azure Machine Learning (AML), and container destinations such as Amazon Web Services (AWS), Azure, and Private Docker.

Here are the functions that this API provides:

* Define, update, and delete publishing destinations
* Publish models, decisions, or rule sets to a predefined destination
* Retrieve a list of published objects (such as models, decisions, and rule sets)

<b>Note:</b> By default only SAS Administrators can define, update, and delete publishing destinations. Authenticated users can perform all of the other functions.

## API Request Examples Grouped by Object Type

<details>
<summary>Destinations</summary>

* [Create a CAS destination](#CreateCASDestination)
* [Create an Amazon Web Services destination](#CreateAWSDestination)
* [Create a Private Docker destination](#CreateDockerDestination)
* [Create an Azure destination](#CreateAzureDestination)
* [Create an Azure Machine Learning destination](#CreateAMLDestination)
* [Create a Git repository destination](#CreateGitDestination)
* [Create a Teradata destination](#CreateTeradataDestination)
* [Create a Hadoop destination](#CreateHadoopDestination)
* [Update a CAS destination](#UpdateCASDestination)
* [Update a Teradata destination](#UpdateTeradataDestination)
* [Update a Hadoop destination](#UpdateHadoopDestination)
* [Get a destination](#GetDestination)
* [Delete a destination](#DeleteDestination)
* [Get the collection of destinations](#GetCollectionDestinations)
* [Get the collection of Git folders](#GetGitFolders)
* [Get a Git folder](#GetGitFolder)
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
* [Publish a decision to the maslocal destination API tutorial](https://documentation.sas.com/?docsetId=edmresttut&docsetTarget=p0scry8g4y8v6gn13esxsf9jg9xp.htm&docsetVersion=v_001&locale=en)
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

#### <a name='CreateAWSDestination'>Create an Amazon Web Services Destination</a>
Here is an example of creating a definition for an Amazon Web Services (AWS) publishing destination.
The property `credDomainId` is created by the SAS Credentials service. These credential attributes are used to create credential domain ID (`domainId`, `identityType`, `identityId`, `domainType`, `properties: userId`, `secrets : password`)
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
    "properties": [{"name": "credDomainId",                
                 "value": "domainName"},
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
Here is an example of creating a definition for a private Docker publishing destination.
The property `credDomainId` is created by the SAS Credentials service. These credential attributes are used to create credential domain ID (`domainId`, `identityType`, `identityId`, `domainType`, `properties: dockerRegistryUserId`, `secrets : dockerRegistryPasswd`)
The property `baseRepoUrl` is required.

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
    "properties": [{"name": "credDomainId",
                   "value": "domainName"},
                   {"name": "baseRepoUrl",                
                   "value": "docker.mycompany.com/myfolder"}
                  ]
  }
}
```
<br>

#### <a name='CreateAzureDestination'>Create an Azure Destination</a>
Here is an example of creating a definition for an Azure publishing destination.
The property `credDomainId` is created by the SAS Credentials service. These credential attributes are used to create credential domain ID (`domainId`, `identityType`, `identityId`, `domainType`, `properties: dockerRegistryUserId, azureAppId`, `secrets : dockerRegistryPasswd, azureAppPasswd`)

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.azure",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"myAzure",
    "destinationType":"azure",
    "properties": [{"name": "credDomainId",                
                 "value": "<myDomainId>"},
                 {"name": "baseRepoUrl",                
                 "value": "<baseRepoUrl>"},
                 {"name": "tenantId",                
                 "value": "<tenantId>"},
                 {"name": "subscriptionId",                
                 "value": "<subscriptionId>"},
                 {"name": "resourceGroupName",                
                 "value": "<resourceGroupName>"},
                 {"name": "kubernetesCluster",                
                 "value": "<kubernetesCluster>"},
                 {"name": "externalIP",                
                 "value": "<externalIP>"}
                  ]
  }
}
```
<br>

#### <a name='CreateAMLDestination'>Create an Azure Machine Learning Destination</a>
Here is an example of creating a definition for an Azure Machine Learning publishing destination.
The property `credDomainId` is created by the SAS Credentials service. These credential attributes are used to create credential domain ID (`domainId`, `identityType`, `identityId`, `domainType`, `properties: dockerRegistryUserId, amlAppId`, `secrets : dockerRegistryPasswd, amlAppPasswd`)

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.aml",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"myAml",
    "destinationType":"aml",
    "properties": [{"name": "credDomainId",                
                 "value": "<myDomainId>"},
                 {"name": "baseRepoUrl",                
                 "value": "<baseRepoUrl>"},
                 {"name": "subscriptionId",                
                 "value": "<subscriptionId>"}
                  ]
  }
}
```
<br>

#### <a name='CreateGitDestination'>Create a Git Repository Destination</a>
Here is an example of creating a definition for a Git repository publishing destination.
The property `credDomainId` is created by the SAS Credentials service. These credential attributes are used to create credential domain ID (`domainId`, `identityType`, `identityId`, `domainType`, `properties: gitUserId`, `secrets : gitAccessToken`)

```json
{
  "POST": "/modelPublish/destinations",
  "headers": {
    "Content-Type": "application/vnd.sas.models.publishing.destination.git+json",
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  },
  "body": {
	"name":"myGit",
    "destinationType":"git",
    "properties": [{"name": "credDomainId",                
                 "value": "<myDomainId>"},
                 {"name": "remoteRepositoryURL",                
                 "value": "<remoteRepositoryURL>"},
                 {"name": "localRepositoryLocation",                
                 "value": "<localRepositoryLocation>"},
                 {"name": "userEmail",                
                 "value": "<userEmail>"}
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
  "GET": "/modelPublish/models/{publishId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
Here is an example of retrieving the Dockerfile metadata for a published model.

```json
{
  "GET": "/modelPublish/models/{publishId}/dockerfile",
  "headers": {
    "Accept": "application/vnd.sas.file+json"
  }
}
```

Here is an example of retrieving the Dockerfile content for a published model.

```json
{
  "GET": "/modelPublish/models/{publishId}/dockerfile/content",
  "headers": {
    "Accept": "text/plain"
  }
}
```

<br>

#### <a name='GetGitFolders'>Get the Collection of Git Folders</a>
Here is an example of retrieving a list of the Git destination folders.

```json
{
  "GET": "/modelPublish/destinations/{gitDestinationName}/gitFolders",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
```json
{
  "GET": "/modelPublish/destinations/{gitDestinationName}/gitFolders?parentGitFolder={/parentFolder}",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```

<br>

#### <a name='GetGitFolder'>Get a Git Folder</a>
Here is an example of retrieving a Git destination folder.

```json
{
  "GET": "/modelPublish/destinations/{gitDestinationName}/gitFolders/{gitFolderName}",
  "headers": {
    "Accept": "application/vnd.sas.models.publishing.destination.git.folder+json"
  }
}
```
```json
{
  "GET": "/modelPublish/destinations/{gitDestinationName}/gitFolders/{gitFolderName}?parentGitFolder={/parentFolder}",
  "headers": {
    "Accept": "application/vnd.sas.models.publishing.destination.git.folder+json"
  }
}
```

version 12, last updated on 14 December 2023