# Model Publish API 
The Model Publish API provides support for publishing objects to CAS, Git, Hadoop, Private Docker, SAS Micro Analytic Service, or Teradata, as well as Azure Machine Learning (AML), and container destinations such as Amazon Web Services (AWS), Azure, and Private Docker.

Here are the functions that this API provides:

* Define, update, and delete publishing destinations
* Publish models, decisions, or rule sets to a predefined destination
* Retrieve a list of published objects (such as models, decisions, and rule sets)

<b>Note:</b> By default, only SAS Administrators can define, update, and delete publishing destinations. Authenticated users can perform all of the other functions.

## API Request Examples Grouped by Object Type

<details>
<summary>Destinations</summary>

- [Create a CAS destination](#create-cas-destination)
- [Create an Amazon Web Services destination](#create-aws-destination)
- [Create a Private Docker destination](#create-docker-destination)
- [Create an Azure destination](#create-azure-destination)
- [Create an Azure Machine Learning destination](#create-aml-destination)
- [Create a Git repository destination](#create-git-destination)
- [Create a Teradata destination](#create-teradata-destination)
- [Create a Hadoop destination](#create-hadoop-destination)
- [Update a CAS destination](#update-cas-destination)
- [Update a Teradata destination](#update-teradata-destination)
- [Update a Hadoop destination](#update-hadoop-destination)
- [Get a destination](#get-destination)
- [Delete a destination](#delete-destination)
- [Get the collection of destinations](#get-collection-destinations)
- [Get the collection of Git folders](#get-git-folders)
- [Get a Git folder](#get-git-folder)

</details>

<details>
<summary>Publish Models</summary>

- [Publish a model to a destination](#publish-model-destination)
- [Publish a model with an analytic store to a destination](#publish-model-analytic-store-destination)
- [Get the collection of published models](#get-collection-published-models)
- [Get the published model](#get-published-model)

</details>

<details>
<summary>See Also</summary>

- [Model Publish API documentation](https://developer.sas.com/rest-apis/modelPublish)
- [Publish a decision to the maslocal destination API tutorial](https://documentation.sas.com/?cdcId=edmcdc&cdcVersion=default&docsetId=edmresttut&docsetTarget=p0scry8g4y8v6gn13esxsf9jg9xp.htm)

</details>

#### <a name='create-cas-destination'>Create a CAS Destination</a>

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

#### <a name='create-aws-destination'>Create an Amazon Web Services Destination</a>

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

#### <a name='create-docker-destination'>Create a Private Docker Destination</a>

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

#### <a name='create-azure-destination'>Create an Azure Destination</a>

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

#### <a name='create-aml-destination'>Create an Azure Machine Learning Destination</a>

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

#### <a name='create-git-destination'>Create a Git Repository Destination</a>

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

#### <a name='create-teradata-destination'>Create a Teradata Destination</a>

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

#### <a name='create-hadoop-destination'>Create a Hadoop Destination</a>

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

#### <a name='update-cas-destination'>Update a CAS Destination</a>

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

#### <a name='update-teradata-destination'>Update a Teradata Destination</a>

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

#### <a name='update-hadoop-destination'>Update a Hadoop Destination</a>

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

#### <a name='get-destination'>Get a Destination</a>

Here is an example of retrieving the definition for a specified destination name.

```json
{
  "GET": "/modelPublish/destinations/{destinationName}",
  "headers": {
    "Accept": "application/vnd.sas.models.publishing.destination+json"
  }
}
```

#### <a name='delete-destination'>Delete a Destination</a>

Here is an example of deleting the publishing destination for a specified destination name.

```json
{
  "DELETE": "/modelPublish/destinations/{destinationName}"
}
```

#### <a name='get-collection-destinations'>Get the Collection of Destinations</a>

Here is an example of retrieving a list of the publishing destinations.

```json
{
  "GET": "/modelPublish/destinations",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```

#### <a name='publish-model-destination'>Publish a Model to a Destination</a>

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

#### <a name='publish-model-analytic-store-destination'>Publish a Model with an Analytic Store to a Destination</a>

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

#### <a name='get-collection-published-models'>Get the Collection of Published Models</a>

Here is an example of retrieving a list of published models.

```json
{
  "GET": "/modelPublish/models",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```

#### <a name='get-published-model'>Get the Published Model</a>

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

#### <a name='get-git-folders'>Get the Collection of Git Folders</a>

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

#### <a name='get-git-folder'>Get a Git Folder</a>

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

version 12, last updated on 29 October, 2024