# Projects API

A project is a container that groups a set of resources along with a set of participants (users or groups).
This can be used for collaborative purposes where one or more participants are working on a set of related resources.
The resources contained in a project are referenced through a URI that points to that resource.
The Projects service has no other knowledge of the target resource.
That resource might be in the SAS service sphere, it might be external, or it might not actually exist at all.
When a resource is removed from a project, no attempt is made to delete the underlying resource.
However, if a target resource that is managed by a SAS service is deleted, that service fires an event and the Projects service removes that resource from any projects that contained it.

#### Resource Relationships

* A project is backed by a folder from the Folders service.
* When a project is created, a corresponding folder is created with the same name under the "Projects" root folder. A project contains a folderUri pointing to this folder.
* Any resources in this folder are considered to be part of the project.
* Clients can add or remove resources from the project by using the folderUri along with the Folders API directly.
* References to resources (in the form of a resourceUri) can be stored directly in the Projects service using the /projects/{projectId}/resources endpoint.
* When retrieving these resources, the Projects service attempts a GET request on the resourceUri with an Accept header of "application/json".
* If the Projects service receives a successful response, the service attempts to populate the "name", "description", and "contentType" fields of the [`application/vnd.sas.project.resource`](#application-vnd.sas.project.resource) object from fields of the same name from the response body. If any of those fields are not found, they are left blank.
* Errors fetching the resourceUri are ignored.
* Participants can be either users or groups from the Identity service and they are associated to projects with a role. The only roles are "owner" and "contributor".
* When a new project is created, the user creating the project is automatically the owner. Only the owner of a project or an administrator can delete a project.
* A project can contain more than one owner, and only an owner of a project or an administrator can add another participant as an owner.
* Only an owner or administrator can add participants to a project or remove participants from a project.
* If there is only one owner in a project, that owner cannot be removed until another owner is added (either by promoting an existing contributor or adding a new participant as an owner).
* Users can be participants of multiple projects.
* When a group is added as a participant, the role applies to all members of the group (and transitively for groups within groups).
* If a user is both an explicit participant and a member of a participant group, and there is a difference in the roles, then the elevated role holds. For example, if a user is added explicitly as a contributor and they are a member of a group that has been added as an owner, then that user is considered an owner.


The Projects service can also be used to retrieve information about various project-related activities. These activities include the following:
* Project created/renamed/deleted
* Project description changed
* Project avatar changed
* Participant added/modified/removed
* Resource added/modified/removed
* Folder member added/modified/removed
* Comment added/modified/removed







## API Request Examples
* [Get projects](#GetProjects)
* [Create a new project](#CreateProject)
* [Add resources and participants to a project](#AddResourcesParticipantsProject)
* [Querying](#Querying)
* [Deleting](#Deleting)


#### <a name='GetProjects'>Get Projects</a>
Here is an example of returning all projects.

```
   GET /projects/projects
```

Here is an example of using a unique projectID to return a specific project.

```
   GET /projects/projects/{projectId}
```


#### <a name='CreateProject'>Create a New Project</a>

Here is an example of creating a new project.

```
   POST /projects/projects {"name": "newProject"}
```

#### <a name='AddResourcesParticipantsProject'>Add Resources and Participants to a Project</a>

Here is an example of adding a resource to a project.

```
   POST /projects/projects/{projectId}/resources {"resourceUri": "resourceURI"}
```

Here is an example of adding a user participant to a project as the owner.

```
   POST /projects/projects/{projectId}/participants {"identityUri": "userURI", "role": "owner"}
```

Here is an example of adding a group participant to a project as the contributor.

```
   POST /projects/projects/{projectId}/participants {"identityUri": "groupURI", "role": "contributor"}
```


#### <a name='Querying'>Querying</a>
Here is an example of using a GET request to retrieve resources in a project.

```
   GET /projects/projects/{projectId}/resources
```

Here is an example of using a GET request to retrieve participants in a project.

```
   GET /projects/projects/{projectId}/participants
```

Here is an example of using a GET request to retrieve the projects containing a resource.

```
   GET /projects/projects?resourceUri={resourceUri}
```

Here is an example of using a GET request to retrieve the projects containing a participant.

```
   GET /projects/projects?identityUri={identityUri}
```

Here is an example of using a GET request to retrieve the activity for a project.

```
   GET /projects/projects/{projectId}/activities
```

Here is an example of using a GET request to retrieve the activity across all projects.

```
   GET /projects/activities
```

Here is an example of using a GET request to retrieve the activity across all projects for a given resource.

```
   GET /projects/activities?resourceUri={resourceUri}
```

Here is an example of using a GET request to retrieve the valid roles for a project.

```
   GET /projects/roles
```


#### <a name='Deleting'>Deleting</a>
Here is an example of deleting a project.

```
   DELETE /projects/projects/{projectId}
```

Here is an example of removing a resource from a project.

```
   DELETE /projects/projects/{projectId}/resources/{resourceId}
```

Here is an example of removing a participant from a project.

```
   DELETE /projects/projects/{projectId}/participants/{participantId}
```





version 1, last updated 21 NOV, 2019