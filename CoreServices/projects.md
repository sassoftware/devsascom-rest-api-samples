# Projects API

A project is a container that groups a set of resources along with a set of participants (users or groups).
This can be used for collaborative purposes where one or more participants are working on a set of related resources.
The resources contained in a project are referenced through a URI that points to that resource.
The Projects service has no other knowledge of the target resource.
That resource may be in the SAS service sphere, it may be external, or it may not actually exist at all.
When a resource is removed from a project, no attempt is made to delete the underlying resource.
However, if a target resource that is managed by a SAS service is deleted, that service will fire an event and the Projects service will remove that resource from any projects that contained it.

#### Resource Relationships

A project is backed by a folder from the folders service.
When a project is created, a corresponding folder will be created with the same name under the "Projects" root folder.
A project will contain a folderUri pointing to this folder.
Any resources in this folder are considered to be part of the project.
Clients can add or remove resources from the project by using the folderUri along with the folders API directly.

Alternatively, references to resources (in the form of a resourceUri) can be stored directly in the Projects service using the /projects/{projectId}/resources endpoint.
When retrieving these resources, the Projects service will attempt a GET on the resourceUri with an Accept header of "application/json".
If it receives a successful response, it will attempt to populate the "name", "description", and "contentType" fields of the application/vnd.sas.project.resource object from fields of the same name from the response body. If any of those fields are not found, they will be left blank.
Errors fetching the resourceUri will be ignored.

Participants can be either users or groups from the Identity service and they are associated to projects with a role. Currently the only roles are "owner" and "contributor".
When a new project is created, the user creating the project is automatically the owner. Only the owner of a project or an administrator can delete a project.
A project can contain more than one owner, and only an owner of a project or an administrator can add another participant as an owner.
Only an owner or administrator can add participants to a project or remove participants from a project.
If there is only one owner in a project, that owner cannot be removed until another owner is added (either by promoting an existing contributor or adding a new participant as an owner).
Users can be participants of multiple projects.

When a group is added as a participant, the role applies to all members of the group (and transitively for groups within groups).
If a user is both an explicit participant and a member of a participant group, and there is a difference in the roles, then the elevated role will hold.
For example, if a user is added explicitly as a contributor and they are a member of a group that has been added as an owner, then that user will be considered an owner.

The Projects service can also be used to retrieve information about various project-related activities. These activities include the following:
* Project created/renamed/deleted
* Project description changed
* Project avatar changed
* Participant added/modified/removed
* Resource added/modified/removed
* Folder member added/modified/removed
* Comment added/modified/removed




## API Request Examples
* [Get Projects](#GetProjects)
* [Create a new Project](#CreateProject)
* [Add resources and participants to a Project](#AddResourcesParticipantsProject)
* [Querying](#Querying)
* [Deleting](#Deleting)


#### <a name='GetProjects'>Get Projects</a>

You can get all projects with

```
   GET /projects/projects
```

or a single project with

```
   GET /projects/projects/{projectId}
```

#### <a name='CreateProject'>Create a new Project</a>

Create a new project with

```
   POST /projects/projects {"name": "newProject"}
```

#### <a name='AddResourcesParticipantsProject'>Add resources and participants to a Project</a>

Add a resource to a project

```
   POST /projects/projects/{projectId}/resources {"resourceUri": "resourceURI"}
```

Add a user to a project as an owner

```
   POST /projects/projects/{projectId}/participants {"identityUri": "userURI", "role": "owner"}
```

Add a group to a project as a contributor

```
   POST /projects/projects/{projectId}/participants {"identityUri": "groupURI", "role": "contributor"}
```

#### <a name='Querying'>Querying</a>

Get the resources in a project

```
   GET /projects/projects/{projectId}/resources
```

Get the participants in a project

```
   GET /projects/projects/{projectId}/participants
```

Get the projects containing a resource

```
   GET /projects/projects?resourceUri={resourceUri}
```

Get the projects containing a participant

```
   GET /projects/projects?identityUri={identityUri}
```

Get the activity for a project

```
   GET /projects/projects/{projectId}/activities
```

Get the activity across all projects

```
   GET /projects/activities
```

Get the activity across all projects for a given resource

```
   GET /projects/activities?resourceUri={resourceUri}
```

Get the valid roles for a project

```
   GET /projects/roles
```

#### <a name='Deleting'>Deleting</a>

Delete a project

```
   DELETE /projects/projects/{projectId}
```

Remove a resource from a project

```
   DELETE /projects/projects/{projectId}/resources/{resourceId}
```

Remove a participant from a project

```
   DELETE /projects/projects/{projectId}/participants/{participantId}
```

version 1, last updated 06 Jun, 2019