# Files API
The Files API provides a generic platform to clients for persisting and retrieving files, such as documents,
attachments, and reports. The file can be associated with the URI of another identifiable object (for example, a parentUri).
Every file must have an assigned content type and name.  Files can be retrieved individually by using the file's
identifier or as a list of files by using a parentUri. Each file has its content stream associated with it.

After creation, the metadata that is associated with the file or the actual content can be updated.
A single file can be deleted by using a specific ID. Multiple files can be deleted by specifying a parentUri.

A file can be uploaded via raw request or multipart form request.

#### Supported Features
The Files API provides the following functions, each with associated default user settings:

* Store a file - an authenticated user can perform this function
* Retrieve file meta information - an authorized user can perform this function
* Retrieve file content - an authorized user can perform this function
* Update file meta information - an authorized user can perform this function
* Update file content - an authorized user can perform this function
* Delete a file - an authorized user can perform this function
* Copy a file - a user with Read access to a file can create a copy of the file

#### File Service Administration
By default, the Files API blocks a file upload when any of the following conditions exist:

* No file is specified in the request.
* The file size is greater than 100 megabytes (MB). This value is configurable.
* The file media type is application/x-msdownload (.exe file). This type is configurable.



**Change the Permissible File Size**

To modify the 100 MB upload limit, specify the applicable value (in bytes) to the files.maxFileSize Consul property. For example, to set a 10 MB limit, set files.maxFileSize=10485760.

**Change Blocked Media Types**

To determine whether uploading is permitted for a specific file type, the Files API checks the Content-Type in the request. If approved, the Files API then scans the file content to determine the actual content type. To modify the list of blocked types, specify the applicable types to the files.blockedTypes Consul property. Separate multiple values by using a comma. For example, to block .zip, .exe, and plain text files, set files.blockedTypes=application/zip,application/x-msdownload,text/plain.

**Prevent Content Scan for Secured Types**

To skip content scanning by the Files API, specify the applicable media types to the sas.files.securedTypes Consul property. Separate multiple values by using a comma. If the Content-Type value for a request matches a type specified for the sas.files.securedTypes property, the Files API does not perform a content scan. It is recommended that you use this feature only if absolutely necessary and, if used, you should specify a local media type for the sas.files.securedTypes property and for the Content-Type when uploading the file.

## API Request Examples

* [Upload a File via Raw Request or Multipart Form Request](#UploadFileRequest)
* [Discover Top-Level Links for the Files API](#DiscoverTopLevelLinksFilesAPI)
* [Create a File](#CreateFile)
* [Get all files](#GetFiles)
* [Get File Resource by fileId](#GetFileResourceFileId)
* [Get the Content of a File by fileId](#GetContentFileFileId)
* [Update the File Metadata by fileId](#UpdateFileMetadataFileId)
* [Delete File by fileId](#DeleteFileFileId)
* [Copy a File](#CopyFile)

The examples are expressed in [UnRAVL](http://www.github.com/sassoftware/unravl) notation.

###  <a name='UploadFileRequest'>Upload a File via Raw Request or Multipart Form Request</a>

##### Raw Request Headers
```
     content-type=text/plain
     accept=application/vnd.sas.file+json
     user-agent=Jakarta Commons-HttpClient/3.1
     host=localhost:50099
     content-length=90
     Sample Request Body=This is the content of a simple text file.
```

##### Multipart Form Request Headers
```
   accept=application/vnd.sas.file+json
   content-length=303
   content-type=multipart/form-data;boundary=do2GjT2wETrsu7pTNIKF3i2d2pyXFjf2B;charset=US-ASCII
   host=localhost:60132
   connection=Keep-Alive
   user-agent=Apache-HttpClient/4.5.2(Java/1.8.0_45)
   Sample Request Body=
   --do2GjT2wETrsu7pTNIKF3i2d2pyXFjf2B
   Content-Disposition: form-data; name="file"; filename="simpleText.txt"
   Content-Type: text/plain
   Content-Transfer-Encoding: binary

   This is the content of a simple text file.
   --do2GjT2wETrsu7pTNIKF3i2d2pyXFjf2B--
```


### <a name='DiscoverTopLevelLinksFilesAPI'>Discover Top-Level Links for the Files API</a>

This call retrieves the application/vnd.sas.api+json representation
of the API's top-level links.
There are two links (as per [Resources: Root](CoreServices/resources/resources.md#Root)),
`"apis"` and `"publishApi"`.

```yaml
{
 "GET" : "http://www.example.com/files",
 "headers": { "Accept" : "application/vnd.sas.api+json" },
 "assert" : [
   { "headers" : { "Content-Type": "application/vnd.sas.api+json;charset=UTF-8" } },
   { "json" :
        {
    "version": 1,
    "links": [
        {
            "method": "HEAD",
            "rel": "checkState",
            "href": "/files/files",
            "uri": "/files/files",
            "type": "application/json"
        },
        {
            "method": "POST",
            "rel": "create",
            "href": "/files/files",
            "uri": "/files/files",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "GET",
            "rel": "files",
            "href": "/files/files",
            "uri": "/files/files",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "POST",
            "rel": "bulkFiles",
            "href": "/files/files",
            "uri": "/files/files",
            "type": "application/vnd.sas.selection",
            "responseType": "application/vnd.sas.collection"
        }
    ]
}
   }
   ]
}
```

### <a name='CreateFile'>Create a File</a>

This call uses the POST method to submit a file. The request body is a file stream. The `Content-Disposition` header is used to fetch the filename. If a filename is not provided, the API assigns a default filename.

The response code is 201 Created, and the response body is a JSON
representation of the API with HATEOAS links.
The API representation contains `self`, `update`, `delete` as 
described in [Resources: File](./resources/resources.md#File).

```json
{
  "POST" : "http://www.example.com/files/files",
  "headers": { "Content-Disposition": "attachment; filename=Attributes.csv;" }
  "body" :
      {  // file stream
     }

  "assert" :  [
    { "status" : "201" }
    { "headers": { "Location": "/files/files/{{fileId}}" } }
    { "json" : 

    {
    "creationTimeStamp": "2017-10-31T10:12:12.164Z",
    "modifiedTimeStamp": "2017-10-31T10:12:12.164Z",
    "createdBy": "sasdemo",
    "modifiedBy": "sasdemo",
    "id": "317359c7-f70e-49fb-95a7-78fb2e02c0f0",
    "properties": {},
    "contentDisposition": "attachment; filename=Attributes.csv;",
    "contentType": "text/plain",
    "encoding": "UTF-8",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file"
        },
        {
            "method": "GET",
            "rel": "alternate",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.summary"
        },
        {
            "method": "PATCH",
            "rel": "patch",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0"
        },
        {
            "method": "GET",
            "rel": "content",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "updateContent",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "POST",
            "rel": "create",
            "href": "/files/files",
            "uri": "/files/files",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "POST",
            "rel": "copyFile",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/copy",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/copy",
            "responseType": "application/vnd.sas.file"
        }
    ],
    "name": "FileResource1509444732163",
    "size": 4918,
    "expirationTimeStamp": "2017-12-04T15:14:40.084Z",
    "version": 2
}
  ]
}
```

### <a name='GetFiles'>Get all files</a>

This call retrieves a paginated list of all files in the repository.
The collection contains up to __limit__ items.
The collection links include the pagination links, `prev`, `first`, `next`, when available from the current page, as described in [Resources: File Collection](#File Collection).

```json
{
   "GET":  "http://www.example.com/files/files",
   "headers": { "Accept": "application/vnd.sas.collection+json" },
   "assert" : [
     { "headers" : {"Accept-Item" : "application/vnd.sas.file+json;version=2" } }
     { "json" :


  {
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/files/files?sortBy=name&start=3&limit=2",
            "uri": "/files/files?sortBy=name&start=3&limit=2",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "GET",
            "rel": "first",
            "href": "/files/files?sortBy=name&start=0&limit=2",
            "uri": "/files/files?sortBy=name&start=0&limit=2",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "GET",
            "rel": "prev",
            "href": "/files/files?sortBy=name&start=1&limit=2",
            "uri": "/files/files?sortBy=name&start=1&limit=2",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "GET",
            "rel": "next",
            "href": "/files/files?sortBy=name&start=5&limit=2",
            "uri": "/files/files?sortBy=name&start=5&limit=2",
            "type": "application/vnd.sas.collection"
        }
    ],
    "name": "files",
    "accept": "application/vnd.sas.file+json",
    "start": 3,
    "count": 21,
    "items": [
        {
            "creationTimeStamp": "2017-10-31T07:34:15.626Z",
            "modifiedTimeStamp": "2017-10-31T07:34:15.626Z",
            "createdBy": "sasdemo",
            "modifiedBy": "sasdemo",
            "id": "9504285d-5ee5-4754-8430-730ffab4d7e5",
            "properties": {},
            "contentDisposition": "attachment; filename=Attributes.csv;",
            "contentType": "text/plain",
            "encoding": "UTF-8",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "uri": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "type": "application/vnd.sas.file"
                },
                {
                    "method": "GET",
                    "rel": "alternate",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "uri": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "type": "application/vnd.sas.summary"
                },
                {
                    "method": "PATCH",
                    "rel": "patch",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "uri": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "type": "application/vnd.sas.file",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "PUT",
                    "rel": "update",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "uri": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "type": "application/vnd.sas.file",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "DELETE",
                    "rel": "delete",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "uri": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5"
                },
                {
                    "method": "GET",
                    "rel": "content",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5/content",
                    "uri": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5/content",
                    "type": "text/plain"
                },
                {
                    "method": "PUT",
                    "rel": "updateContent",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5/content",
                    "uri": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5/content",
                    "type": "*/*",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "POST",
                    "rel": "create",
                    "href": "/files/files",
                    "uri": "/files/files",
                    "type": "*/*",
                    "responseType": "application/vnd.sas.file"
                },
                {
                  "method": "POST",
                  "rel": "copyFile",
                  "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5/copy",
                  "uri": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5/copy",
                  "responseType": "application/vnd.sas.file"
                }
            ],
            "name": "FileResource1509435255625",
            "size": 4918,
            "version": 2
        },
        {
            "creationTimeStamp": "2017-10-31T09:32:44.313Z",
            "modifiedTimeStamp": "2017-10-31T09:32:44.313Z",
            "createdBy": "sasdemo",
            "modifiedBy": "sasdemo",
            "id": "ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
            "properties": {},
            "contentDisposition": "attachment; filename=Attributes.csv;",
            "contentType": "text/plain",
            "encoding": "UTF-8",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "type": "application/vnd.sas.file"
                },
                {
                    "method": "GET",
                    "rel": "alternate",
                    "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "type": "application/vnd.sas.summary"
                },
                {
                    "method": "PATCH",
                    "rel": "patch",
                    "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "type": "application/vnd.sas.file",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "PUT",
                    "rel": "update",
                    "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "type": "application/vnd.sas.file",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "DELETE",
                    "rel": "delete",
                    "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8"
                },
                {
                    "method": "GET",
                    "rel": "content",
                    "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/content",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/content",
                    "type": "text/plain"
                },
                {
                    "method": "PUT",
                    "rel": "updateContent",
                    "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/content",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/content",
                    "type": "*/*",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "POST",
                    "rel": "create",
                    "href": "/files/files",
                    "uri": "/files/files",
                    "type": "*/*",
                    "responseType": "application/vnd.sas.file"
                },
                {
                  "method": "POST",
                  "rel": "copyFile",
                  "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/copy",
                  "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/copy",
                  "responseType": "application/vnd.sas.file"
                }
            ],
            "name": "FileResource1509442364313",
            "size": 4918,
            "version": 2
        }
    ],
    "limit": 2,
    "version": 2
}
}
```

### <a name='GetFileResourceFileId'>Get File Resource by fileId</a>

This call looks up a file resource by specifying a fileId.
The response is a JSON object.

```json
{
   "GET" : "http://www.example.com/files/files/{{fileId}}",
   "headers" : { "Accept": "application/vnd.sas.file+json" },
   "assert" : [
      { "status" : "200" },
      { "json" : 

{
    "creationTimeStamp": "2017-10-31T10:12:12.164Z",
    "modifiedTimeStamp": "2017-10-31T10:12:47.097Z",
    "createdBy": "sasdemo",
    "modifiedBy": "sasdemo",
    "id": "317359c7-f70e-49fb-95a7-78fb2e02c0f0",
    "parentUri": "/reports/reports/9504285d-5ee5-4754-8430-730ffab4d7e5",
    "properties": {
        "myprop2": "propVal2",
        "myprop1": "propVal1",
        "myprop4": "propVal4",
        "myprop3": "propVal3"
    },
    "contentDisposition": "attachment; filename=Attributes.csv;",
    "contentType": "text/plain",
    "description": "This file is crated for temporary purpose",
    "documentType": "Plain_TextDoc",
    "encoding": "UTF-8",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file"
        },
        {
            "method": "GET",
            "rel": "alternate",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.summary"
        },
        {
            "method": "PATCH",
            "rel": "patch",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0"
        },
        {
            "method": "GET",
            "rel": "content",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "updateContent",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "POST",
            "rel": "create",
            "href": "/files/files",
            "uri": "/files/files",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
          "method": "POST",
          "rel": "copyFile",
          "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/copy",
          "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/copy",
          "responseType": "application/vnd.sas.file"
        }
    ],
    "name": "TempFile",
    "size": 4918,
    "expirationTimeStamp": "2017-12-04T15:14:40.084Z",
    "version": 2
}
   ]
}
```

### <a name='GetContentFileFileId'>Get the Content of a File by fileId</a>

This call retrieves the content of a file by specifying a fileId.

```json
{
   "GET" : "http://www.example.com/files/files/{{fileId}}/content",
   
   assert" : [
      { "status" : "200" },
      { "json" : 

   ]
}
```

### <a name='UpdateFileMetadataFileId'>Update the File Metadata by fileId</a>

This call updates the existing metadata of a file by specifying a fileId.

```json
{
   "PATCH": "http://www.example.com/files/files",
   "headers": { "Content-Type": "application/vnd.sas.file+json" },
   "body" :
      {
  "parentUri": "/reports/reports/9504285d-5ee5-4754-8430-730ffab4d7e5",
  "name": "TempFile",
  "description": "This file is crated for temporary purpose",
  "documentType": "Plain_TextDoc",
   "properties": {
		"myprop2": "propVal2",
		"myprop1": "propVal1",
		"myprop4": "propVal4",
		"myprop3": "propVal3"
	}
   
   "assert" : [
      { "headers": { "Content-Type" : "application/vnd.sas.file+json" } }
      { "json" : 
				{
    "creationTimeStamp": "2017-10-31T10:12:12.164Z",
    "modifiedTimeStamp": "2017-10-31T10:12:47.097Z",
    "createdBy": "sasdemo",
    "modifiedBy": "sasdemo",
    "id": "317359c7-f70e-49fb-95a7-78fb2e02c0f0",
    "parentUri": "/reports/reports/9504285d-5ee5-4754-8430-730ffab4d7e5",
    "properties": {
        "myprop2": "propVal2",
        "myprop1": "propVal1",
        "myprop4": "propVal4",
        "myprop3": "propVal3"
    },
    "contentDisposition": "attachment; filename=Attributes.csv;",
    "contentType": "text/plain",
    "description": "This file is crated for temporary purpose",
    "documentType": "Plain_TextDoc",
    "encoding": "UTF-8",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file"
        },
        {
            "method": "GET",
            "rel": "alternate",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.summary"
        },
        {
            "method": "PATCH",
            "rel": "patch",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0"
        },
        {
            "method": "GET",
            "rel": "content",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "updateContent",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "POST",
            "rel": "create",
            "href": "/files/files",
            "uri": "/files/files",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
          "method": "POST",
          "rel": "copyFile",
          "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/copy",
          "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/copy",
          "responseType": "application/vnd.sas.file"
        }
    ],
    "name": "TempFile",
    "size": 4918,
    "expirationTimeStamp": "2017-12-04T15:14:40.084Z",
    "version": 2
}
        }
     }
   ]
}
```

### <a name='DeleteFileFileId'>Delete File by fileId</a>

This call deletes the file resource and its content by specifying a fileId.


```json
[
    {
       "DELETE" : "http://www.example.com/files/files/{{fileId}}",
       "assert" : { "status" : 204 }
    },
    
]
```

### <a name='CopyFile'>Copy a File</a>

This call uses POST to copy a file if the user has 'READ' permission on the file. The file to be copied is provided as a part of the URI. The `Content-Disposition` header can be used to specify the filename. If a filename is not provided, the API assigns the same name as the source file. The file to be created can be made a member of an existing folder by specifying request parameter 'parentFolderUri'.

The response code is 201 Created, and the response body is a JSON
representation of the API with HATEOAS links.
The API representation contains `self`, `update`, `delete` as 
described in [Resources: File](#File).

```json
{
  "POST" : "http://www.example.com/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0g2/copy",
  "headers": { "Content-Disposition": "attachment; filename=Attributes.csv;" }

  "assert" :  [
    { "status" : "201" }
    { "headers": { "Location": "/files/files/{{fileId}}" } }
    { "json" : 

    {
    "creationTimeStamp": "2017-10-31T10:12:12.164Z",
    "modifiedTimeStamp": "2017-10-31T10:12:12.164Z",
    "createdBy": "sasin",
    "modifiedBy": "sasin",
    "id": "317359c7-f70e-49fb-95a7-78fb2e02c0f0",
    "properties": {},
    "contentDisposition": "attachment; filename=Attributes.csv;",
    "contentType": "text/plain",
    "encoding": "UTF-8",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file"
        },
        {
            "method": "GET",
            "rel": "alternate",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.summary"
        },
        {
            "method": "PATCH",
            "rel": "patch",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "type": "application/vnd.sas.file",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0"
        },
        {
            "method": "GET",
            "rel": "content",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "type": "text/plain"
        },
        {
            "method": "PUT",
            "rel": "updateContent",
            "href": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "uri": "/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0f0/content",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "POST",
            "rel": "create",
            "href": "/files/files",
            "uri": "/files/files",
            "type": "*/*",
            "responseType": "application/vnd.sas.file"
        },
        {
            "method": "POST",
            "rel": "copyFile",
            "href": "/files/files/{fileId}/copy",
            "uri": "/files/files/{fileId}/copy",
            "responseType": "application/vnd.sas.file"
        }
    ],
    "name": "Attributes.csv",
    "size": 4918,
    "expirationTimeStamp": "2017-12-04T15:14:40.084Z",
    "version": 2
}
  ]
}
```

version 3, last updated 19 Dec, 2018