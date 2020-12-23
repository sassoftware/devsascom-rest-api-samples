#### Resource Relationships


| Type         | Attribute | Description                                                                     |
|--------------|--------|---------------------------------------------------------------------------------|
| String         |`id`    | The identifier for the file. This is set internally and cannot be changed.  |
|       |  `contentType`  | The content type of the source file. This is set and managed internally. |
|          |`createdBy`   | The owner of the file. This is set internally and cannot be changed.  |
|       |  `encoding`  | The character encoding of the content. This is set and managed internally. |
|          |`modifiedBy`   | The user who last modified the file. This is set and managed internally.  |
|       |  `name`  | The name of the file. This is initialized internally and can be changed after initialization. |
|          |`parentUri`   | The reference URI of the parent, owner, or associated object. This is managed by the end user.  |
|       |  `contentDisposition`  | The content disposition to use while downloading the file. This is managed by the end user.|
|          |`description`   | A brief description of the files. This is managed by the end user.  |
|       |  `documentType`  | The document type of the file. This is managed by the end user.|
|          |`expirationTimeStamp`   | The date and time at which the file expires or is deleted. This is managed by the end user. |
|Date       |  `creationTimeStamp`  | The date of file creation. This is set internally and cannot be changed.|
|          |`modifiedTimeStamp`   | The date that the file was last modified. This is set and managed internally. |
|List      |  `<Link> links`  | A collection of links that represent the supported operations for the current resource. The following links are supported: <br> <li> `self : GET` - A link to retrieve the metadata of the file. </li> <li> `patch : PATCH` - A link to update the metadata of the file. </li> <li> `delete : DELETE` - A link to delete the current file resource. </li> <li> `content : GET` - A link to download the actual content of the file. </li> <li> `updateContent : PUT` - A link to update the actual content of the file. </li>|
|Long      |  `size`  | The size of the actual content. This is set and managed internally.|
|Map   |  `<String, String> properties`  | A mapping of key/value pairs that can be used to provide more information about the file. This is managed by the end user.|

#### <a name='Root'>Root</a>

Path: `/`

The root of the API. This resource contains links to the top-level resources in the API.
##### Links
The `GET /` response includes the following links:

| Relation          | Method | Description                                                                     |
|--------------|--------|---------------------------------------------------------------------------------|
| checkState         | HEAD    | Checks the state of the service.  <br/> URI: `/files/files`  <br/> Response type: [`application/json`] |
|  create      |  POST  | Uploads a file. Note that Type `*/*` indicates that the content-type is dynamic. The end user must provide the actual content-type to file service, not `*/*`.  <br/> URI: `/files/files` <br/> Request type: `*/*` <br/> Response type: `application/vnd.sas.file` |
| files   | GET   | Returns a collection of files.   <br/> URI: `/files/files`   <br/> Response type: `application/vnd.sas.collection` |
| bulkFiles   | POST   | Returns a collection of files for multiple parentUri entries using `application/vnd.sas.selection` in the request body. <br/> URI: `/files/files` <br/> Request type: `application/vnd.sas.selection`  <br/> Response type: `application/vnd.sas.collection` |

#### <a name='File'>File</a>

Path: `/files/{fileId}`

This endpoint returns the file resource or metadata of the file.

##### Links
Links from the file resource include the following:

| Relation          | Method | Description                                                                     |
|--------------|--------|---------------------------------------------------------------------------------|
|  self      |  GET  | Returns the meta representation of the file resource.  <br/> URI: `/files/files/{fileId}`  <br/> Response type: [`application/vnd.sas.file`] |
|  alternate      |  GET  |Returns the summary representation of the file resource.   <br/> URI: `/files/files/{fileId}`  <br/> Response type: [`application/vnd.sas.summary`] |
|  content      |  GET  | Downloads the actual content of the file. The type is the contentType from vnd.sas.file. <br/> URI: `/files/files/{fileId}/content`  <br/> Response type: [`*/*`] |
|  update      |  PUT  | Updates the meta information of the file resource.  <br/> URI: `/files/files/{fileId}`  <br/> Request type: `application/vnd.sas.file` <br/> Response type: `application/vnd.sas.file`|
|  patch      |  PATCH  | Updates the meta information of the file resource.  <br/> URI: `/files/files/{fileId}`  <br/> Request type: `application/vnd.sas.file` <br/> Response type: `application/vnd.sas.file`|
|  updateContent      |  PUT  | Updates the actual content of the file. Note that Type `*/*` indicates that content-type is dynamic. The end-user must pass on actual content-type to file service, not `*/*`.  <br/> URI: `/files/files/{fileId}/content` <br/> Request type: `*/*` <br/> Response type: `application/vnd.sas.file` |
|  delete      |  DELETE  | Removes the file resource.  <br/> URI: `/files/files/{fileId}`|
|  create      |  POST  | Uploads a file. Note that Type `*/*` indicates that content-type is dynamic. The end user must pass on actual content-type to file service, not `*/*`.  <br/> URI: `/files/files` <br/> Request type: `*/*` <br/> Response type: `application/vnd.sas.file` |
|  copyFile    |  POST  | If the user has Read access to the file, copies the file.<br/> URI: `/files/files/{fileId}/copy` <br/> Response type: `application/vnd.sas.file` |


#### <a name='File Collection'>File Collection</a>

Path: `/files`

This endpoint returns the collection of file resource.

##### Links

Links from the collection include the following:

| Relation          | Method | Description                                                                     |
|--------------|--------|---------------------------------------------------------------------------------|
|  self        |  GET   | Returns the current page from the collection. |
|  prev        |  GET   | Returns the previous page of the collection. This link is omitted if the current view is on the first page. |
|  next        |  GET   | Returns the next page of the collection. This link is omitted if the current view is on the last page of the collection. |
|  first       |  GET   | Returns the first page of the collection. This link is omitted if the current view is on the first page. |

 
