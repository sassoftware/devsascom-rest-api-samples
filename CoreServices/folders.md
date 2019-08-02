# Folders API 
The Folders API is used to create a virtual folder hierarchy for organizing and presenting resources. There is no physical backing
structure, such as a file system, DAV, or JCR. The Folders API persists only the URI of resources that are managed by other persistence
services. The persistence services that own the resources that are members of the folders know nothing directly about the Folders API
(with one possible exception, detailed below), and the Folders API knows nothing of them (with one other exception). This design maintains
the loose coupling that is a fundamental concept of the microservices architecture.

The one possible exception where a persistence service knows about the folders service is when it is creating a new object. It might implement
the Creating objects in folders as a single transaction pattern, which accepts a parentFolderURI query parameter and makes a call to the
Folders API to add the new object to the specified folder as a child member. If the member creation fails for any reason, it is the
responsibility of the persistence service to clean up the newly created resource, and return a proper response that indicates why the member could not be created.

The exception to the Folders API knowing about the persistence service is the event consumer. The Folders API listens for change
events (update or delete). If an object that is a child of a folder changes, it tries to get the summary (application/vnd.sas.summary)
representation of the object and updates its name, description, and modified time stamp if it is able to successfully retrieve it. The
summary type should normally be recognized by content persistence
services. If the persistence service does not answer to the summary media type, or if any other error occurs, the member is not updated.
If the persistence service does not allow automatic updating by the folders service, it would be up to a client to use the PUT operation to
keep members that it cares about up-to-date with changes in the content.

There are three types of folders you can use in the type field.

- folder - This is just a basic folder,
    with no particular restrictions. If the type is not specified, this is the
    default value.

- favoritesFolder - This type of folder can hold
    only reference members, or other favoritesFolders.  Attempting to add a child of
    any other type results in an error response.

- historyFolder - This
    type of folder can contain only references, and has a property of "maxMembers" with a default
    value of "40" that is used to limit the number of members the folder can
    hold.  It uses an eviction policy to determine which member to remove when
    a new member is added. It removes the highest value of
    orderNum, and then the member added the longest ago.  History folders respond
    to some special endpoints under the /folders/{folderId}/histories
    path. These endpoints provide special behavior when adding or updating
    history entries.  A POST to /folders/{folderId}/histories "touches" the
    entry. That is, it creates it if it is not there, or update its data,
    including the added attribute, if it already exists (based on an exact match
    of the uri field).

There are also three special types that are returned that you cannot
        specify when creating a folder.

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

* [Paginate Through Folders](#PaginateThroughFolders)
* [Get My Folder for the Current User](#GetMyFolderCurrentUser)
* [Create a Folder as a Child of My Folder](#CreateFolderChildMyFolder)
* [Create a Member in My Folder](#CreateMemberMyFolder)

### <a name='PaginateThroughFolders'>Paginate Through Folders</a>

```
GET /folders/folders?start=0&limit=20
    Accept: application/vnd.sas.collection+json
```
```
GET /preferences/preferences?start=20&limit=20
    Accept: application/vnd.sas.collection+json
```

### <a name='GetMyFolderCurrentUser'>Get My Folder for the Current User</a>

```
GET /folders/folders/@myFolder
    Accept: application/vnd.sas.content.folder+json
```

### <a name='CreateFolderChildMyFolder'>Create a Folder as a Child of My Folder</a>

```
POST /folders/folders?parentFolderUri=/folders/folders/@myFolder
    Content-Type: application/vnd.sas.content.folder+json
    Accept: application/vnd.sas.content.folder+json
```
```json
{
  "name": "A new folder"
}
```

### <a name='CreateMemberMyFolder'>Create a Member in My Folder</a>
```
POST /folders/folders/@myFolder/members
    Content-Type: application/vnd.sas.content.folder.member+json
    Accept: application/vnd.sas.content.folder.memeber+json
```
```json
{
    "name": "Test Report",
    "uri": "/reports/reports/1234567890",
    "type": "CHILD",
    "contentType": "report"
}
```

version 1, last updated 21 May, 2019