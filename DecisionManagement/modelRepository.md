# Model Repository API
The Model Repository API provides access to a common model repository and provides support for registering, organizing, and managing models.
Here are the functions that this API provides:

* Create, update, and delete repositories within the common model repository
* Create and import models within projects or folders
* Assess and compare model content and variables
* Versioning of projects and models
* Create, update, and delete models and projects
* Add, update, and delete model content and project content

Models that are located within projects can also be monitored for performance and scored.
The operations of the Model Repository API can be called by other APIs.  Here are some examples:

* Model Studio can register models within the common model repository by submitting a request to the Model Repository API.
* The Model Management API can submit a request to monitor performance of models that are managed by the Model Repository API.


For more information, see the <a href="https://support.sas.com/en/software/model-manager-support.html#documentation" target="_blank">SAS Model Manager</a> software product support page.

## API Request Examples Grouped by Object Type

<details>
<summary>Repositories</summary>

* [Create a repository](#create-repository-resources)
* [Get a repository](#get-repository-resources)
* [Delete a repository](#delete-repository-resources)
* [Get the collection of repositories](#get-repository-list-resources)
</details>

<details>
<summary>Project</summary>

* [Create a project](#create-project-resources)
* [Get a project](#get-project-resources)
* [Delete a project](#delete-project-resources)
* [Get the collection of projects](#get-project-list-resources)
* [Get the history of a project](#get-project-history)
</details>

<details>
<summary>Project Variables</summary>

* [Create a project variable](#create-project-variable-resources)
* [Get a project variable](#get-project-variable-resources)
* [Delete a project variable](#delete-project-variable-resources)
* [Get the collection of project variables](#get-project-variable-list-resources)
</details>

<details>
<summary>Project Versions</summary>

* [Create a project version](#create-project-version-resources)
* [Get a project version](#get-project-version)
* [Delete a project version](#delete-project-version)
* [Get the collection of project versions](#get-project-version-list)
* [Get the collection of models belong to the project version](#get-project-version-model-list)
</details>

<details>
<summary>Models</summary>

* [Create a model](#create-model-resources)
* [Get a model](#get-model-resources)
* [Delete a model](#delete-model-resources)
* [Get the collection of models](#get-model-list-resources)
* [Import a model with multipart form-data](#import-model-multipart-resources)
</details>

<details>
<summary>Model Variables</summary>

* [Create a model variable](#create-model-variable)
* [Get a model variable](#get-model-variable)
* [Delete a model variable](#delete-model-variable)
* [Get the collection of model variables](#get-model-variable-list)
</details>

<details>
<summary>Model Versions</summary>

* [Create a model version](#create-model-version)
* [Get a model version](#get-model-version)
* [Get the collection of model versions](#get-model-version-list)
</details>

<details>
<summary>Model Contents</summary>

* [Add a model file](#add-model-file)
* [Get model content metadata](#get-model-content-metadata)
* [Get model content](#get-model-content)
* [Delete model content](#delete-model-content)
* [Get the collection of model contents](#get-model-content-list)
* [Get the collection of analytic stores for a model](#get-model-astore-list)
* [Copy the collection of analytic stores for a model](#copy-astore)
</details>


#### Repository
##### <a name='create-repository-resources'>Create a Repository</a>
Here is an example of creating a model repository.

```json
{
  "POST": "/modelRepository/repositories",
  "headers": {
    "Content-Type": "application/vnd.sas.models.repository",
    "Accept": "application/json"
  },
  "body": {
	"name":"testRepository"
  }
}
```
<br>

##### <a name='get-repository-resources'>Get a Repository</a>
Here is an example of retrieving a model repository.

```json
{
  "GET": "/modelRepository/repositories/{repositoryId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='delete-repository-resources'>Delete a Repository</a>
Here is an example of deleting a model repository.

```json
{
  "DELETE": "/modelRepository/repositories/{repositoryId}"
}
```
<br>

##### <a name='get-repository-list-resources'>Get the Collection of Repositories</a>
Here is an example of retrieving a list of model repositories.

```json
{
  "GET": "/modelRepository/repositories",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### Project
##### <a name='create-project-resources'>Create a Project</a>
Here is an example of creating a project.

```json
{
  "POST": "/modelRepository/projects",
  "headers": {
    "Content-Type": "application/vnd.sas.models.project",
    "Accept": "application/json"
  },
  "body": {
	"name":"testProject",
	"repositoryId": "<repositoryID>"
  }
}
```
<br>

##### <a name='get-project-resources'>Get a Project</a>
Here is an example of retrieving a project.

```json
{
  "GET": "/modelRepository/projects/{projectId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='delete-project-resources'>Delete a Project</a>
Here is an example of deleting a project.

```json
{
  "DELETE": "/modelRepository/projects/{projectId}"
}
```
<br>

##### <a name='get-project-list-resources'>Get the Collection of Projects</a>

Here is an example of retrieving a list of projects.

```json
{
  "GET": "/modelRepository/projects",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### Project Variables
##### <a name='create-project-variable-resources'>Create a Project Variable</a>
Here is an example of creating a project variable.

```json
{
  "POST": "/modelRepository/projects/{projectId}/variables",
  "headers": {
    "Content-Type": "application/vnd.sas.models.model.variable",
    "Accept": "application/vnd.sas.models.model.variable+json"
  },
  "body": {
	"name":"VariableName",
	"role": "input",
	"description": "variable description",
	"level" : "",
	"type" : "string"
  }
}
```
<br>

##### <a name='get-project-variable-resources'>Get a Project Variable</a>
Here is an example of retrieving a project variable.

```json
{
  "GET": "/modelRepository/projects/{projectId}/variables/{variableId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='delete-project-variable-resources'>Delete a Project Variable</a>
Here is an example of deleting a project variable.

```json
{
  "DELETE": "/modelRepository/projects/{projectId}/variables/{variableId}"
}
```
<br>

##### <a name='get-project-variable-list-resources'>Get the Collection of Project Variables</a>
Here is an example of retrieving a list of project variables.

```json
{
  "GET": "/modelRepository/projects/{projectId}/variables",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### Project Versions
##### <a name='create-project-version-resources'>Create a Project Version</a>
Here is an example of creating a project version.

```json
{
  "POST": "/modelRepository/projects/{projectId}/projectVersions",
  "headers": {
    "Accept": "application/json"
  },
  "body": {
	"parentId":"aUUID",
	"sourceVersionId": "aUUID",
	"description": "variable description",
	"creationOption" : "major or minor",
	"versionNumber" : "aVersionNumber"
  }
}
```
<br>

##### <a name='get-project-version'>Get a Project Version</a>
Here is an example of retrieving a project version.

```json
{
  "GET": "/modelRepository/projects/{projectId}/projectVersions/{versionId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='delete-project-version'>Delete a Project Version</a>
Here is an example of deleting a project version.

```json
{
  "DELETE": "/modelRepository/projects/{projectId}/projectVersions/{versionId}"
}
```
<br>

##### <a name='get-project-version-list'>Get the Collection of Project Versions</a>
Here is an example of retrieving a list of project versions.

```json
{
  "GET": "/modelRepository/projects/{projectId}/projectVersions",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

##### <a name='get-project-version-model-list'>Get the Collection of Models Belong to the Project Version</a>
Here is an example of retrieving a list of models that belong to a specific project version.

```json
{
  "GET": "/modelRepository/projects/{projectId}/projectVersions/{versionId}/models",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

##### <a name='get-project-history'>Get the History of a Project</a>
Here is an example of retrieving the event history of a project.

```json
{
  "GET": "/modelRepository/projects/{projectId}/history",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### Models
##### <a name='create-model-resources'>Create a Model</a>
Here is an example of creating a model.

```json
{
  "POST": "/modelRepository/models",
  "headers": {
    "Content-Type": "application/vnd.sas.models.model",
    "Accept": "application/json"
  },
  "body": {
	"name":"testModel",
	"projectId": "<projectID>",
	"description": "create a model in a project",
	"externalModelId":"theModelIdFromClientApplication"
  }
}
```
<br>

##### <a name='get-model-resources'>Get a Model</a>
Here is an example of retrieving a model.

```json
{
  "GET": "/modelRepository/models/{modelId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='delete-model-resources'>Delete a Model</a>
Here is an example of deleting a model.

```json
{
  "DELETE": "/modelRepository/models/{modelId}"
}
```
<br>

##### <a name='get-model-list-resources'>Get the Collection of Models</a>
Here is an example of retrieving a list of models.

```json
{
  "GET": "/modelRepository/models",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

##### <a name='import-model-multipart-resources'>Import a Model with Multipart Form-data</a>
Here is a example of importing model with multipart form-data.

```python
headersContents = {
}
mfile = open("\\temp\\mytesting.spk", 'rb')
files = {'files': ('mytesting.spk', mfile, 'multipart/form-data')}
myContent = requests.post(hostport + "/modelRepository/models?name=mytesting&type=SPK&projectId=" + projectID, files=files, headers=headersContents)

```
<br>

#### Model Variables
##### <a name='create-model-variable'>Create a Model Variable</a>
Here is an example of creating a model variable.

```json
{
  "POST": "/modelRepository/models/{modelId}/variables",
  "headers": {
    "Content-Type": "application/vnd.sas.models.model.variable",
    "Accept": "application/vnd.sas.models.model.variable+json"
  },
  "body": {
	"name":"VariableName",
	"role": "input",
	"description": "variable description",
	"level" : "",
	"type" : "string"
  }
}
```
<br>

##### <a name='get-model-variable'>Get a Model Variable</a>
Here is an example of retrieving a model variable.


```json
{
  "GET": "/modelRepository/models/{modelId}/variables/{variableId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='delete-model-variable'>Delete a Model Variable</a>
Here is an example of deleting a model variable.

```json
{
  "DELETE": "/modelRepository/models/{modelId}/variables/{variableId}"
}
```
<br>

### <a name='get-model-variable-list'>Get the Collection of Model Variables</a>
Here is an example of retrieving a list of model variables.

```json
{
  "GET": "/modelRepository/models/{modelId}/variables",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### Model Versions
##### <a name='create-model-version'>Create a Model Version</a>

Here is an example of creating a model version.

```json
{
  "POST": "/modelRepository/models/{modelId}/modelVersions",
  "headers": {
    "Content-Type": "application/vnd.sas.models.model.version",
    "Accept": "application/vnd.sas.models.model.version+json"
  },
  "body": {
	"options":"major"
  }
}
```
<br>

##### <a name='get-model-version'>Get a Model Version</a>
Here is an example of retrieving a model version.

```json
{
  "GET": "/modelRepository/models/{modelId}/modelVersions/{versionId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='get-model-version-list'>Get the Collection of Model Versions</a>
Here is an example of retrieving a list of versions for a specific model.

```json
{
  "GET": "/modelRepository/models/{modelId}/modelVersions",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### Model Contents
##### <a name='add-model-file'>Add a Model File</a>
Here is a Python code example for adding a model file.

```python
headersContents = {
}
mfile = open("\\temp\\input.json", 'rb')
files = {'files': ('input.json', mfile, 'multipart/form-data')}
myContent = requests.post(hostport + "/modelRepository/models/{modelId}/contents", files=files, headers=headersContents)

```
<br>

##### <a name='get-model-content-metadata'>Get Model Content Metadata</a>
Here is an example of retrieving model content metadata.

```json
{
  "GET": "/modelRepository/models/{modelId}/contents/{contentId}",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='get-model-content'>Get Model Content</a>
Here is an example of retrieving content of a model.

```json
{
  "GET": "/modelRepository/models/{modelId}/contents/{contentId}/content",
  "headers": {
    "Accept": "application/json"
  }
}
```
<br>

##### <a name='delete-model-content'>Delete Model Content</a>
Here is an example of deleting the content of a model.

```json
{
  "DELETE": "/modelRepository/models/{modelId}/contents/{contentId}"
}
```
<br>

##### <a name='get-model-content-list'>Get the Collection of Model Contents</a>
Here is an example of retrieving list of contents for a model.

```json
{
  "GET": "/modelRepository/models/{modelId}/contents",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

##### <a name='get-model-astore-list'>Get the Collection of Analytic Stores for a Model</a>
Here is an example of retrieving a list of analytic stores for a model.

```json
{
  "GET": "/modelRepository/models/{modelId}/analyticStore",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```

The response contains analytic store metadata for all analytic store items in the model.
The response code is 200.
```json
{
  "links": [
  {
    "method": "GET",
    "rel": "self",
    "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore",
    "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore"
  },
  {
    "method": "GET",
    "rel": "up",
    "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d",
    "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d"
  }],
  "name": "items",
    "items": [
    {
      "name": "_CZYCKSR1VQAFF42SPNW51JELY_AST",
      "uri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~ModelStore/tables/_CZYCKSR1VQAFF42SPNW51JELY_AST",
      "key": "8D438794A9B720D019C6F2BE3D4E8CF9201347CA",
      "caslib": "ModelStore",
      "location": "file:///models/astores/viya/_CZYCKSR1VQAFF42SPNW51JELY_AST.astore",
      "host": "chevre.modelmanager.sashq-d.openstack.sas.com",
      "fullPath": "/opt/sas/viya/config/data/modelsvr/astore/_CZYCKSR1VQAFF42SPNW51JELY_AST.astore",
      "state": "success",
      "links": [
      {
        "method": "GET",
        "rel": "self",
        "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore/_CZYCKSR1VQAFF42SPNW51JELY_AST",
        "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore/_CZYCKSR1VQAFF42SPNW51JELY_AST"
      },
      {
        "method": "PUT",
        "rel": "copy",
        "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore/_CZYCKSR1VQAFF42SPNW51JELY_AST",
        "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore/_CZYCKSR1VQAFF42SPNW51JELY_AST"
      },
      {
        "method": "GET",
        "rel": "up",
        "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore",
        "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore"
      },
      {
        "method": "GET",
        "rel": "model",
        "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d",
        "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d"
      }]
    }],
  "version": 2
}
```

<br>

##### <a name='copy-astore'>Copy the Collection of Analytic Stores for a Model</a>
Here is an example of the analytic stores of the referenced model being copied from the ModelStore CAS library to the /opt/sas/viya/config/data/modelsvr/astore directory. 
<br/>This copy is intended for integration with Event Stream Processing and Micro Analytic Service. Please review the Model Manager product documentation for more details.

```json
{
  "PUT": "/modelRepository/models/{modelId}/analyticStore",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```

The response contains analytic store metadata for all analytic store items in the model.
The response code is 202.
```json
{
  "links": [
  {
    "method": "GET",
    "rel": "self",
    "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore",
    "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore"
  },
  {
    "method": "GET",
    "rel": "up",
    "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d",
    "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d"
  }],
  "name": "items",
    "items": [
    {
      "name": "_CZYCKSR1VQAFF42SPNW51JELY_AST",
      "uri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~ModelStore/tables/_CZYCKSR1VQAFF42SPNW51JELY_AST",
      "key": "8D438794A9B720D019C6F2BE3D4E8CF9201347CA",
      "caslib": "ModelStore",
      "location": "file:///models/astores/viya/_CZYCKSR1VQAFF42SPNW51JELY_AST.astore",
      "host": "chevre.modelmanager.sashq-d.openstack.sas.com",
      "fullPath": "/opt/sas/viya/config/data/modelsvr/astore/_CZYCKSR1VQAFF42SPNW51JELY_AST.astore",
      "state": "copying",
      "links": [
      {
        "method": "GET",
        "rel": "self",
        "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore/_CZYCKSR1VQAFF42SPNW51JELY_AST",
        "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore/_CZYCKSR1VQAFF42SPNW51JELY_AST"
      },
      {
        "method": "PUT",
        "rel": "copy",
        "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore/_CZYCKSR1VQAFF42SPNW51JELY_AST",
        "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore/_CZYCKSR1VQAFF42SPNW51JELY_AST"
      },
      {
        "method": "GET",
        "rel": "up",
        "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore",
        "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d/analyticStore"
      },
      {
        "method": "GET",
        "rel": "model",
        "href": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d",
        "uri": "/modelRepository/models/34ba78b7-a2d7-49b8-9d9e-508cf649f66d"
      }]
    }],
  "version": 2
}
```

<br>

version 3, last updated 21 Nov, 2019