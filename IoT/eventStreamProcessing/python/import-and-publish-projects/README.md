# Import, Publish, and Run Projects in a Kubernetes Cluster

## Overview

This Jupyter notebook uses the SAS Event Stream Processing Studio Rest API and the SAS Event Stream Manager Rest API to 
import, publish, and run projects in a Kubernetes cluster.

Use this example when SAS Event Stream Processing is deployed with other SAS Viya platform products, 
and you are using SAS Event Stream Processing 2023.08 or later. 

This Jupyter notebook uses the project XML files in the `xml_projects` folder and performs the following tasks:
1. Check whether the projects have already been imported to SAS Event Stream Processing Studio.
2. If a project has been previously imported, then import it using the next version number. Otherwise, import the project as version 1.
3. Make the projects public so that they are visible to all users.
4. Publish the projects from SAS Event Stream Processing Studio (ESP) to SAS Event Stream Manager (ESM).
5. Synchronize the projects.
6. Create a SAS Event Stream Manager deployment whose type is "Cluster".
7. Run the projects in the Kubernetes cluster. This action creates and starts an ESP server for each project.

## Check Prerequisites

Ensure that Python 3 is available and the following Python packages are available:
- requests
- json
- epoch
- urllib3
- ElementTree
- time

## Using the Example
1. Download the Python program or the Jupyter notebook file.
2. Ensure that the `xml_projects` folder (which contains the project XML files used by this example) is located at the same level as this Jupyter notebook.
3. Edit the following variables to match your environment:
   - `server`: the URL of the SAS Viya platform server
   - `username`
   - `password`
   - `chosen_deployment_name`: specify a name for the SAS Event Stream Manager deployment that this example creates
4. Run the program or Jupyter notebook commands.

## Endpoints Used by This Example

_**Note:** The IoT SAS Event Stream Processing Studio Rest API and the SAS Event Stream Manager Rest API documentation 
is currently for internal use only and not available to external customers on developers.sas.com. 
You must be signed in with your SAS email address to access the content on the external site._

### SAS Event Stream Processing Studio
- [/esp-project](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=getListModels) - List all projects
- [/esp-project](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=createProject) - Create a project
- [/project-versions/projects/{projectId}/nextVersion](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=getNextVersion) - Get the next version of a project
- [/project-versions/projects/{projectId}](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=createVersion) - Publish a file to the Files service
- [/project-versions/projects/synchronize/{folderId}](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=createSynchronizeProject) - Synchronize a published project with SAS Event Stream Manager

### SAS Event Stream Manager
- [/deployment](https://developers.sas.com/rest-apis/SASEventStreamManager-v3?operation=getListDeployments) - List all deployments
- [/deployment](https://developers.sas.com/rest-apis/SASEventStreamManager-v3?operation=createDeployment) - Create a deployment
- [/server/cluster](https://developers.sas.com/rest-apis/SASEventStreamManager-v3?operation=createStartProjectOnCluster) - Run a project in a cluster
