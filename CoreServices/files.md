# Files API
The Files API provides a generic platform for clients to persist and retrieve such files as documents, attachments, and reports. You can associate the file with the URI of another identifiable object (for example, a parentUri). You must assign a content type and name to every file.  You can retrieve files individually by using the file identifier or as a list of files by using a parentUri. A content stream is associated with each file.

After you create the file, you can update the metadata that is associated with the file or the actual content. You can delete a single file by using a specific ID. You can delete multiple files by specifying a parentUri.

You can upload a file using a raw request or a multipart form request.

#### Supported Features
This API provides these functions, each has an associated default user value that can perform the function.

| Function                       | Default User                          |
|--------------------------------|---------------------------------------|
| Store a file                   | authenticated                         |
| Retrieve file meta information | authorized                            |
| Retrieve file content          | authorized                            |
| Update file meta information   | authorized                            |
| Update file content            | authorized                            |
| Delete a file                  | authorized                            |
| Copy a file                    | any user with Read access to the file |

#### File Service Administration
By default, the Files API blocks a file upload when any of these conditions exists.

* No file is specified in the request.
* The file size is greater than 100 megabytes (MB). This value is configurable.
* The file media type is application/x-msdownload (.exe file). This type is configurable.

##### Change the Permissible File Size

To modify the 100 MB upload limit, specify the applicable value in bytes in the files.maxFileSize Consul property. For example, to specify a 10 MB limit, specify files.maxFileSize=10485760.

##### Change Blocked Media Types

To determine whether uploading is permitted for a specific file type, the Files API checks the Content-Type in the request. If approved, the Files API then scans the file content to determine the actual content type. To modify the list of blocked types, specify the applicable types in the files.blockedTypes Consul property. Separate multiple values with a comma.  For example, to block .zip, .exe, and plain text files, specify files.blockedTypes=application/zip,application/x-msdownload,text/plain.

##### Prevent Content Scan for Secured Types

If you want the Files API to skip content scanning, specify the applicable media types in the sas.files.securedTypes Consul property. Separate multiple values with a comma. If the Content-Type value for a request matches a type that is specified in the sas.files.securedTypes property, the Files API does not perform a content scan. 
It is recommended that you use this feature only if it is absolutely necessary. If you use this feature, you should specify a local media type in the sas.files.securedTypes property and for the Content-Type when you upload the file.



## API Request Examples

The examples are expressed in [UnRAVL](https://github.com/DavidBiesack/unravl/blob/master/doc/Reference.md) notation.


<details>
<summary>Upload a File</summary>

* [Upload a file by raw request headers](#ByRawRequestHeaders)
* [Upload a file by multipart form request headers](#ByMultipartFormRequestHeaders)
</details>

<details>
<summary>Work with Files and Related Items</summary>

* [Discover top-level links for the Files API](#DiscoverTop-LevelLinksfortheFilesAPI)
* [Create a file](#CreateaFile)
* [Get all files](#GetAllFiles)
* [Get a file resource by fileId](#GetaFileResourcebyfileId)
* [Get the content of a file by fileId](#GettheContentofaFilebyfileId)
* [Update the file metadata by fileId](#UpdatetheFileMetadatabyfileId)
* [Delete a file by fileId](#DeleteaFilebyfileId)
* [Copy a file](#CopyaFile)
</details>


#### <a name='ByRawRequestHeaders'>Upload a File by Raw Request Headers</a>
Here is an example of uploading a file by raw request headers.
```
     content-type=text/plain
     accept=application/vnd.sas.file+json
     user-agent=Jakarta Commons-HttpClient/3.1
     host=localhost:50099
     content-length=90
     Sample Request Body=This is the content of a simple text file.
```

#### <a name='ByMultipartFormRequestHeaders'>Upload a File by Multipart Form Request Headers</a>
Here is an example of uploading a file by multipart form request headers.
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

#### <a name='DiscoverTop-LevelLinksfortheFilesAPI'>Discover Top-Level Links for the Files API</a>
Here is an example of a call that retrieves the application/vnd.sas.api+json representation of the top-level links for this API. 

* According to [Resources: Root](#Root), there are two links: `"apis"` and `"publishApi"`.

```yaml
{
 "GET": "http://www.example.com/files",
 "headers": { "Accept":  "application/vnd.sas.api+json" },
 "assert": [
   { "headers": { "Content-Type": "application/vnd.sas.api+json;charset=UTF-8" } },
   { "json":
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

#### <a name='CreateaFile'>Create a File</a>

This call uses the POST method to submit a file. The request body is a file stream. You use the `Content-Disposition` header to fetch the filename. If a filename is not provided, the API assigns a default filename.

The response code is 201 Created, and the response body is a JSON
representation of the API with HATEOAS links. The API representation contains `self`, `update`, and `delete`, as 
described in [Resources: File](#File).

```json
{
  "POST": "http://www.example.com/files/files",
  "headers": { "Content-Disposition": "attachment; filename=Attributes.csv;" },
  "body": 
      {
     },

  "assert": [
    { "status": "201" },
    { "headers": { "Location": "/files/files/{{fileId}}" } },
    { "json": 

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
  }
]}
```

#### <a name='GetAllFiles'>Get All Files</a>
Here is an example of a call that retrieves a paginated list of all files in the repository.

* The collection contains up to __limit__ items.
* The collection links include the pagination links, `prev`, `first`, and `next`, when available from the current page, as described in [Resources: File Collection](#File Collection).

```json
{
   "GET": "http://www.example.com/files/files",
   "headers": { "Accept": "application/vnd.sas.collection+json" },
   "assert" : [
     { "headers": {"Accept-Item": "application/vnd.sas.file+json;version=2" } },
     { "json":


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
                    "uri":  "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "type": "application/vnd.sas.file",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "PUT",
                    "rel": "update",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "uri":  "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "type": "application/vnd.sas.file",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "DELETE",
                    "rel": "delete",
                    "href": "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5",
                    "uri":  "/files/files/9504285d-5ee5-4754-8430-730ffab4d7e5"
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
                    "responseType":  "application/vnd.sas.file"
                },
                {
                    "method": "PUT",
                    "rel": "update",
                    "href":  "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "type": "application/vnd.sas.file",
                    "responseType": "application/vnd.sas.file"
                },
                {
                    "method": "DELETE",
                    "rel": "delete",
                    "href": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8",
                    "uri":  "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8"
                },
                {
                    "method": "GET",
                    "rel": "content",
                    "href":  "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/content",
                    "uri": "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/content",
                    "type": "text/plain"
                },
                {
                    "method": "PUT",
                    "rel": "updateContent",
                    "href":  "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/content",
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
                  "uri":  "/files/files/ca2fd21d-28b4-4a10-80c3-1380e0ab88c8/copy",
                  "responseType": "application/vnd.sas.file"
                }
            ],
            "name": "FileResource1509442364313",
            "size": 4918,
            "version": 2
        }
    ],
    "limit":  2,
    "version": 2
}
}]
}
```

#### <a name='GetaFileResourcebyfileId'>Get a File Resource by fileId</a>
Here is an example of a call that looks up a file resource by specifying a fileId. The response is a JSON object.

```json
{
   "GET": "http://www.example.com/files/files/{{fileId}}",
   "headers": { "Accept": "application/vnd.sas.file+json" },
   "assert": [
      { "status": "200" },
      { "json":

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
   }
]}
```

#### <a name='GettheContentofaFilebyfileId'>Get the Content of a File by fileId</a>
Here is an example of a call that retrieves the content of a file by specifying a fileId.

```json
{
   "GET": "http://www.example.com/files/files/{{fileId}}/content",
      "assert" : [
      { "status": "200" },
      { "json": "value"}
   ]
}
```

#### <a name='UpdatetheFileMetadatabyfileId'>Update the File Metadata by fileId</a>
Here is an example of a call that updates the existing metadata of a file by specifying a fileId.

```json
{
   "PATCH": "http://www.example.com/files/files",
   "headers": { "Content-Type": "application/vnd.sas.file+json" },
   "body":
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
	},
   
   "assert" :  [
      { "headers": { "Content-Type": "application/vnd.sas.file+json" } },
      { "json": 
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
     ]}
}
```

#### <a name='DeleteaFilebyfileId'>Delete a File by fileId</a>
Here is an example of a call that deletes the file resource and its content by specifying a fileId.

```json
[
    {
       "DELETE": "http://www.example.com/files/files/{{fileId}}",
       "assert": { "status": 204 }
    }
]
```

#### <a name='CopyaFile'>Copy a File</a>
Here is an example of a call that uses a POST request to copy a file if the user has 'READ' permission on the file.

* The file to be copied is provided as a part of the URI.
* You can use the `Content-Disposition` header to specify the filename.
* If a filename is not provided, the API assigns the same name as the source file.
* You can make the file to be created a member of an existing folder by specifying the request parameter, 'parentFolderUri'.
* The response code is 201 Created, and the response body is a JSON representation of the API with HATEOAS links.
* The API representation contains `self`, `update`, and `delete`, as  described in [Resources: File](#File).

```json
{
  "POST": "http://www.example.com/files/files/317359c7-f70e-49fb-95a7-78fb2e02c0g2/copy",
  "headers": { "Content-Disposition": "attachment; filename=Attributes.csv;" },

  "assert":  [
    { "status": "201" },
    { "headers": { "Location": "/files/files/{{fileId}}" } },
    { "json":

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
  }]
}
```

version 3, last updated 22 NOV, 2019
