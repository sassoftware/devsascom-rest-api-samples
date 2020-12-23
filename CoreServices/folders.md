The Folders API is used to create a virtual folder hierarchy for organizing and presenting resources. There is no physical backing
structure, such as a file system, DAV, or JCR. The Folders API persists only the URI of resources that are managed by other persistence
services. In general, the persistence services and the Folders API do not know about each other. The persistence services that own the resources that are members of the folders know nothing directly about the Folders API, and the Folders API knows nothing of the persistence services. This design maintains
the loose coupling that is a fundamental concept of the microservices architecture.

There are two exceptions where a persistence service and the Folders service know about each other:

- The persistence service knows about the Folders service when the persistence service is creating a new object. The persistence service might implement
the Creating objects in folders as a single transaction pattern, which accepts a parentFolderURI query parameter and makes a call to the
Folders API to add the new object to the specified folder as a child member. If the member creation fails,
the persistence service cleans up the newly created resource and returns a proper response that indicates why the member could not be created.

- The exception to the Folders API knowing about the persistence service is the event consumer. The Folders API listens for change
events (for example, an UPDATE or DELETE). If an object that is a child of a folder changes, it tries to retrieve the summary (application/vnd.sas.summary)
representation of the object and, if successful, updates the object's name, description, and modified time stamp. The
summary type should normally be recognized by content persistence
services. If the persistence service does not answer to the summary media type, or if any other error occurs, the member is not updated.
If the persistence service does not allow automatic updating by the folders service, a client uses the PUT operation to
update members with changes in the content.

#### Folder Types to Specify for the Type Field

There are three types of folders you can use in the type field:

- folder - This is just a basic folder,
    with no particular restrictions. If the type is not specified, this is the
    default value.

- favoritesFolder - This type of folder can hold
    only reference members, or other favoritesFolders.  Attempting to add a child of
    any other type results in an error response.

- historyFolder - This
    type of folder can contain only references. The folder has a property of "maxMembers" that limits the number of members the folder can
    hold. The default value of maxMembers is 40. When maxMembers is reached, members are evicted when a new member is added following this policy: 1) the member with the highest value of OrderNum and 2) the member with the oldest time stamp. History folders respond
    to some special endpoints under the /folders/{folderId}/histories
    path. These endpoints provide special behavior when adding or updating
    history entries.  A POST to /folders/{folderId}/histories "touches" the
    entry. That is, a POST creates a history entry if it is not there or updates the history entry's data,
    including the added attribute, if it already exists (based on an exact match
    of the uri field).

#### Folder Types that Are Returned when Creating a Folder

These three special folder types are returned and cannot be specified when creating a folder.

- userFolder - One folder of this type
        is created per user, named for the user's user name. This folder is the
        parent of the other special folders.

- myFolder - Users have one
        folder of this type for storing items that they do not want to share with
        other users. Items in this folder are not visible to other users except
        administrative users.

- applicationDataFolder - This folder is
        used by applications to store data specific to one user.

 All GET operations have a corresponding HEAD with identical signature and
            semantics except the resource body is not returned.

#### Rules for Folders and Folder Members

Folders are not managed on a per-user basis. In other words, in general, folders are intended to be shared by some group of users. The
exception is the user folder and the special folders that are stored under the user folder (myFolder, appDataFolder, myHistory, and myFavorites). Those
folders are intended solely for the use of the user for which they were created. Authorizations are created to enforce that level of
access.

There are two types of folder members: child and reference. A given resource URI can exist as a child in only one folder. An attempt to create
a child member with the same URI in a second folder results in a 412 response (precondition failed). If it is already in the same parent
folder, a 409 response (conflict) is returned. A resource URI can exist as a reference member in as many folders as desired. When an
attempt is made to delete a folder, only child members are considered when testing whether the folder is empty. Likewise, only child members
are considered when retrieving ancestors.





## API Request Examples

* [Discover top level links for folders service (non-admin user)](#top-level-links)
* [Paging through folder results](#paging-example)
* [Get the current user's My Folder](#get-my-folder)
* [Create a subfolder of My Folder](#create-subfolder)
* [Create a member in My Folder](#create-member)

#### <a name='top-level-links'>Discover top level links for folders service (non-admin user)</a>
Here is an example of using the GET request to retrieve the application/vnd.sas.api+json representation of the APIs top-level links.

```
 GET /folders/
 Headers:
 *  Accept: application/vnd.sas.api+json
```

Here is an example of the response:

```json
{
    "version": 1,
    "links": [
        {
            "method": "GET",
            "rel": "folders",
            "href": "/folders/folders",
            "uri": "/folders/folders",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "POST",
            "rel": "createFolder",
            "href": "/folders/folders",
            "uri": "/folders/folders",
            "type": "application/vnd.sas.content.folder"
        },
        {
            "method": "GET",
            "rel": "rootFolders",
            "href": "/folders/rootFolders",
            "uri": "/folders/rootFolders",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "GET",
            "rel": "folderTypes",
            "href": "/folders/folderTypes",
            "uri": "/folders/folderTypes",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "GET",
            "rel": "delegateInfo",
            "href": "/folders/delegateInfo",
            "uri": "/folders/delegateInfo",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "GET",
            "rel": "delegateFolders",
            "href": "/folders/delegateFolders",
            "uri": "/folders/delegateFolders",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "PUT",
            "rel": "validateRootFolderName",
            "href": "/folders/commons/validations/folders/@root/members/@new/name?value={newname}&type=folder",
            "uri": "/folders/commons/validations/folders/@root/members/@new/name?value={newname}&type=folder",
            "type": "application/vnd.sas.validation"
        },
        {
            "method": "GET",
            "rel": "ancestors",
            "href": "/folders/ancestors?childUri={resourceUri}",
            "uri": "/folders/ancestors?childUri={resourceUri}",
            "type": "application/vnd.sas.content.folder.ancestor"
        },
        {
            "method": "GET",
            "rel": "myFolder",
            "href": "/folders/folders/@myFolder",
            "uri": "/folders/folders/@myFolder",
            "type": "application/vnd.sas.content.folder",
            "title": "My Folder for current user"
        },
        {
            "method": "GET",
            "rel": "myHistory",
            "href": "/folders/folders/@myHistory",
            "uri": "/folders/folders/@myHistory",
            "type": "application/vnd.sas.content.folder",
            "title": "My History folder for current user"
        },
        {
            "method": "GET",
            "rel": "myFavorites",
            "href": "/folders/folders/@myFavorites",
            "uri": "/folders/folders/@myFavorites",
            "type": "application/vnd.sas.content.folder",
            "title": "My Favorites folder for current user"
        },
        {
            "method": "GET",
            "rel": "appData",
            "href": "/folders/folders/@appDataFolder",
            "uri": "/folders/folders/@appDataFolder",
            "type": "application/vnd.sas.content.folder",
            "title": "Application data folder for current user"
        },
        {
            "method": "GET",
            "rel": "recycleBin",
            "href": "/folders/folders/@myRecycleBin",
            "uri": "/folders/folders/@myRecycleBin",
            "type": "application/vnd.sas.content.folder",
            "title": "Recycle Bin folder for current user"
        },
        {
            "method": "GET",
            "rel": "public",
            "href": "/folders/folders/@public",
            "uri": "/folders/folders/@public",
            "type": "application/vnd.sas.content.folder",
            "title": "Public folder"
        },
        {
            "method": "GET",
            "rel": "products",
            "href": "/folders/folders/@products",
            "uri": "/folders/folders/@products",
            "type": "application/vnd.sas.content.folder",
            "title": "Products folder"
        },
        {
            "method": "PUT",
            "rel": "validateName",
            "href": "/folders/commons/validations/folders/@new/name?value={newname}&parentFolderUri={parentFolderUri}",
            "uri": "/folders/commons/validations/folders/@new/name?value={newname}&parentFolderUri={parentFolderUri}",
            "type": "application/vnd.sas.content.folder",
            "title": "Validate new folder name"
        },
        {
            "method": "POST",
            "rel": "createSubfolder",
            "href": "/folders/folders?parentFolderUri=/folders/folders/{parentId}",
            "uri": "/folders/folders?parentFolderUri=/folders/folders/{parentId}",
            "type": "application/vnd.sas.content.folder"
        }
    ]
}
```


#### <a name='paging-example'> Paging Through Folder Results</a>
Here is an example of using a GET request to page through folder results.

```
GET /folders/folders?start=0&limit=20
    Accept: application/vnd.sas.collection+json
```
Here is an example of the response:
```
{
    "links": [
        {
            "method": "GET",
            "rel": "collection",
            "href": "/folders/folders",
            "uri": "/folders/folders",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "GET",
            "rel": "self",
            "href": "/folders/folders?start=0&limit=20",
            "uri": "/folders/folders?start=0&limit=20",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "POST",
            "rel": "createFolder",
            "href": "/folders/folders",
            "uri": "/folders/folders",
            "type": "application/vnd.sas.content.folder",
            "responseType": "application/vnd.sas.content.folder"
        }
    ],
    "name": "folders",
    "accept": "application/vnd.sas.content.folder",
    "start": 0,
    "items": [
        *... Twenty folder representations would go here...*
    ],
    "limit": 20,
    "version": 2
}
```

***Request***
```
GET /preferences/preferences?start=20&limit=20
    Accept: application/vnd.sas.collection+json
```

***Response***
```
{
    "links": [
        {
            "method": "GET",
            "rel": "collection",
            "href": "/folders/folders",
            "uri": "/folders/folders",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "GET",
            "rel": "self",
            "href": "/folders/folders?start=0&limit=20",
            "uri": "/folders/folders?start=0&limit=20",
            "type": "application/vnd.sas.collection"
        },
        {
            "method": "POST",
            "rel": "createFolder",
            "href": "/folders/folders",
            "uri": "/folders/folders",
            "type": "application/vnd.sas.content.folder",
            "responseType": "application/vnd.sas.content.folder"
        }
    ],
    "name": "folders",
    "accept": "application/vnd.sas.content.folder",
    "start": 20,
    "items": [
           * ... The next 20 folders here ... *
            ],
            "version": 1
        }
    ],
    "limit": 20,
    "version": 2
}
```


#### <a name='get-my-folder'> Get the Current User's My Folder</a>
Here is an example of using a GET request to retrieve My Folder for the current user.

```
GET /folders/folders/@myFolder
    Accept: application/vnd.sas.content.folder+json
```
Here is an example of the response:
```
{
    "creationTimeStamp": "2019-08-08T12:53:51.309Z",
    "modifiedTimeStamp": "2019-08-08T12:53:51.309Z",
    "createdBy": "testuser",
    "modifiedBy": "testuser",
    "id": "6e6aa6e9-7c6a-4491-84fd-84051031a44d",
    "name": "My Folder",
    "parentFolderUri": "/folders/folders/f210f767-7f3a-4109-849b-f1b7d1c5d11a",
    "description": "My Folder for testuser",
    "type": "myFolder",
    "memberCount": 0,
    "properties": {
        "allowMove": "false"
    },
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "type": "application/vnd.sas.content.folder"
        },
        {
            "method": "GET",
            "rel": "up",
            "href": "/folders/folders/f210f767-7f3a-4109-849b-f1b7d1c5d11a",
            "uri": "/folders/folders/f210f767-7f3a-4109-849b-f1b7d1c5d11a",
            "type": "application/vnd.sas.content.folder"
        },
        {
            "method": "PUT",
            "rel": "validateNewMemberName",
            "href": "/folders/commons/validations/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/@new/name?value={newname}&type={newtype}",
            "uri": "/folders/commons/validations/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/@new/name?value={newname}&type={newtype}"
        },
        {
            "method": "GET",
            "rel": "ancestors",
            "href": "/folders/ancestors?childUri=/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "uri": "/folders/ancestors?childUri=/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "type": "application/vnd.sas.content.folder.ancestor"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d"
        },
        {
            "method": "DELETE",
            "rel": "deleteRecursively",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d?recursive=true",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d?recursive=true"
        },
        {
            "method": "GET",
            "rel": "members",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.content.folder.member"
        },
        {
            "method": "POST",
            "rel": "addMember",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members",
            "type": "application/vnd.sas.content.folder.member"
        },
        {
            "method": "POST",
            "rel": "createChild",
            "href": "/folders/folders?parentFolderUri=/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "uri": "/folders/folders?parentFolderUri=/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "type": "application/vnd.sas.content.folder"
        },
        {
            "method": "GET",
            "rel": "transferExport",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "responseType": "application/vnd.sas.transfer.object"
        },
        {
            "method": "PUT",
            "rel": "transferImportUpdate",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "type": "application/vnd.sas.transfer.object",
            "responseType": "application/vnd.sas.summary"
        }
    ],
    "version": 1
}
```


#### <a name='create-subfolder'> Create a Subfolder of My Folder</a>
Here is an example of using the POST method to create a folder as a child of the My Folder.

```
POST /folders/folders?parentFolderUri=/folders/folders/@myFolder
    Content-Type: application/vnd.sas.content.folder+json
    Accept: application/vnd.sas.content.folder+json
```
-Body
```json
{
  "name": "A new folder"
}
```
Here is an example of the response:
```
{
    "creationTimeStamp": "2019-08-08T12:55:20.420Z",
    "modifiedTimeStamp": "2019-08-08T12:55:20.420Z",
    "createdBy": "testuser",
    "modifiedBy": "testuser",
    "id": "f3277e88-01f2-4f2f-9ce2-cb575e849238",
    "name": "A new folder",
    "parentFolderUri": "/folders/folders/c0e8ccf9-ac43-4303-a1ce-40d7ffbd7450",
    "type": "folder",
    "memberCount": 0,
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "uri": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "type": "application/vnd.sas.content.folder"
        },
        {
            "method": "GET",
            "rel": "up",
            "href": "/folders/folders/c0e8ccf9-ac43-4303-a1ce-40d7ffbd7450",
            "uri": "/folders/folders/c0e8ccf9-ac43-4303-a1ce-40d7ffbd7450",
            "type": "application/vnd.sas.content.folder"
        },
        {
            "method": "PUT",
            "rel": "validateRename",
            "href": "/folders/commons/validations/folders/c0e8ccf9-ac43-4303-a1ce-40d7ffbd7450/members/35def691-e932-4bf2-a38a-9f38e906eb5e/name?value={newname}&type=folder",
            "uri": "/folders/commons/validations/folders/c0e8ccf9-ac43-4303-a1ce-40d7ffbd7450/members/35def691-e932-4bf2-a38a-9f38e906eb5e/name?value={newname}&type=folder"
        },
        {
            "method": "PUT",
            "rel": "validateNewMemberName",
            "href": "/folders/commons/validations/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238/members/@new/name?value={newname}&type={newtype}",
            "uri": "/folders/commons/validations/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238/members/@new/name?value={newname}&type={newtype}"
        },
        {
            "method": "GET",
            "rel": "ancestors",
            "href": "/folders/ancestors?childUri=/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "uri": "/folders/ancestors?childUri=/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "type": "application/vnd.sas.content.folder.ancestor"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "uri": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "type": "application/vnd.sas.content.folder",
            "responseType": "application/vnd.sas.content.folder"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "uri": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238"
        },
        {
            "method": "DELETE",
            "rel": "deleteRecursively",
            "href": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238?recursive=true",
            "uri": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238?recursive=true"
        },
        {
            "method": "GET",
            "rel": "members",
            "href": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238/members",
            "uri": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238/members",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.content.folder.member"
        },
        {
            "method": "POST",
            "rel": "addMember",
            "href": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238/members",
            "uri": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238/members",
            "type": "application/vnd.sas.content.folder.member"
        },
        {
            "method": "POST",
            "rel": "createChild",
            "href": "/folders/folders?parentFolderUri=/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "uri": "/folders/folders?parentFolderUri=/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "type": "application/vnd.sas.content.folder"
        },
        {
            "method": "GET",
            "rel": "transferExport",
            "href": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "uri": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "responseType": "application/vnd.sas.transfer.object"
        },
        {
            "method": "PUT",
            "rel": "transferImportUpdate",
            "href": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "uri": "/folders/folders/f3277e88-01f2-4f2f-9ce2-cb575e849238",
            "type": "application/vnd.sas.transfer.object",
            "responseType": "application/vnd.sas.summary"
        },
        {
            "method": "POST",
            "rel": "transferImport",
            "href": "/folders/folders",
            "uri": "/folders/folders",
            "type": "application/vnd.sas.transfer.object",
            "responseType": "application/vnd.sas.summary"
        }
    ],
    "version": 1
}
```


#### <a name='create-member'> Create a Member in My Folder</a>
Here is an example of using the POST method to create a member in My Folder.

```
POST /folders/folders/@myFolder/members
    Content-Type: application/vnd.sas.content.folder.member+json
    Accept: application/vnd.sas.content.folder.memeber+json
```
-Body
```json
{
    "name": "Test Report",
    "uri": "/reports/reports/1234567890",
    "type": "CHILD",
    "contentType": "report"
}
```
Here is an example of the response:
```
{
    "id": "2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
    "uri": "/reports/reports/1234567890",
    "added": "2019-08-08T12:59:08.775Z",
    "type": "child",
    "name": "Test Report",
    "parentFolderUri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
    "contentType": "report",
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "type": "application/vnd.sas.content.folder.member"
        },
        {
            "method": "GET",
            "rel": "up",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d",
            "type": "application/vnd.sas.content.folder"
        },
        {
            "method": "GET",
            "rel": "getResource",
            "href": "/reports/reports/1234567890",
            "uri": "/reports/reports/1234567890",
            "type": "application/vnd.sas.summary"
        },
        {
            "method": "PUT",
            "rel": "putResource",
            "href": "/reports/reports/1234567890",
            "uri": "/reports/reports/1234567890"
        },
        {
            "method": "DELETE",
            "rel": "deleteResource",
            "href": "/reports/reports/1234567890",
            "uri": "/reports/reports/1234567890"
        },
        {
            "method": "GET",
            "rel": "ancestors",
            "href": "/folders/ancestors?childUri=/reports/reports/1234567890",
            "uri": "/folders/ancestors?childUri=/reports/reports/1234567890",
            "type": "application/vnd.sas.content.folder.ancestor"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "type": "application/vnd.sas.content.folder.member"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f"
        },
        {
            "method": "PUT",
            "rel": "validateRename",
            "href": "/folders/commons/validations/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f/name?value={newname}&type={newtype}",
            "uri": "/folders/commons/validations/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f/name?value={newname}&type={newtype}",
            "type": "application/vnd.sas.validation"
        },
        {
            "method": "GET",
            "rel": "transferExport",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "responseType": "application/vnd.sas.transfer.object"
        },
        {
            "method": "PUT",
            "rel": "transferImportUpdate",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members/2ec3501d-4201-4e7d-8de6-0e2c4a7a022f",
            "type": "application/vnd.sas.transfer.object",
            "responseType": "application/vnd.sas.summary"
        },
        {
            "method": "POST",
            "rel": "transferImport",
            "href": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members",
            "uri": "/folders/folders/6e6aa6e9-7c6a-4491-84fd-84051031a44d/members",
            "type": "application/vnd.sas.transfer.object",
            "responseType": "application/vnd.sas.summary"
        }
    ],
    "version": 1
}
```


version 1, last updated 21 NOV, 2019