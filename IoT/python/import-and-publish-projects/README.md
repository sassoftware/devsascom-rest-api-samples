# Create and Use Asset

## Overview

This notebook leverages the IOT ESP API to import, publish and run projects on K8s clusters.

In this notebook we will loop through all XML projects in xml_projects folder and do the following:
1. Check if projects have already been imported
2. If yes, import it using next version number. Otherwise import it normally with version 1
3. Make project public so all users can see it
4. Publish project
5. Synchronize projects from Studio to ESM
6. Create ESM Deployment Cluster on which to run the projects
7. Start projects on K8s cluster on ESM

## Prerequisites

#### XML Projects

- This example will assume that at same level as this Jupyter Notebook there is an *xml_projects* folder with XML files representing proejcts the user wants to import and publish to ESP.
- 
#### Variables to assign

- server - the SAS Viya server URL
- username
- password
- chosen_deployment_name - the nmae of the ESM deployment cluster we want to create

### Packages and Python Version
- python 3
- requests
- json
- epoch
- urllib3
- ElementTree
- time

## Usage
1. Download the Python program or the Jupyter Notebook file.
2. Edit your variables to match your environment.
3. Proceed to run the program or Notebook commands.

## Endpoints Used

### SAS Event Stream Processing Studio
- [/esp-project](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=getListModels) - List all projects
- [/esp-project](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=createProject) - Create a project
- [/project-versions/projects/{projectId}/nextVersion](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=getNextVersion) - Get the next version of a project
- [/project-versions/projects/{projectId}](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=createVersion) - Publish a file to the Files service
- [/project-versions/projects/synchronize/{folderId}](https://developers.sas.com/rest-apis/SASEventStreamProcessingStudio-v3?operation=createSynchronizeProject) - Synchronize a published project with SAS Event Stream Manager

### SAS Event Stream Manager
- [/deployment](https://developers.sas.com/rest-apis/SASEventStreamManager-v3?operation=getListDeployments) - List all deployments
- [/deployment](https://developers.sas.com/rest-apis/SASEventStreamManager-v3?operation=createDeployment) - Create a deployment
- [/server/cluster](https://developers.sas.com/rest-apis/SASEventStreamManager-v3?operation=createStartProjectOnCluster) - Run a project on a cluster

## Supported Versions

- Viya 4
- 2023.08 onwards
