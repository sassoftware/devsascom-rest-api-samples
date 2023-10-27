# Create and Run a Discovery Agent
## Overview
This collection leverages the Catalog API to create and run a Discovery Agent.

## Prerequisites

### Variables
The Postman collection comes with variables that you must assign either at the collection or environment level. Assign values to the following variables prior to running the collection:
- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `access_token`
Other variables are assigned programmatically during the REST calls using code in the Postman Tests tab.

## Usage
1. Download the JSON collection and the sasserver.env. Then import the files into Postman.
2. Select sasserver.env as the environment and edit your environment variables to match those contained in the collection requests (sasserver, access_token).
3. Be sure to authenticate to your server before testing the endpoints.
4. You can run one request at a time. You can also run the collection, but uncheck DELETE Discovery Agent, GET Discovery Agents, and PUT Update Discovery Agent if you do so.  The GET Discovery Agent State request has code in the Tests tab that will execute the request until the "running" state is ended.

 ## Endpoints Used
- [/catalog/bots](https://developer.sas.com/apis/rest/DataManagement/#create-an-agent) - Create an Agent
- [/catalog/bots/{agentId}/state](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/updateAgentRunState) - Update Agents run state
- [/catalog/bots/{agentId}/state](https://developer.sas.com/apis/rest/DataManagement/#get-an-agent-39-s-execution-status) - Get an Agent's execution state
- [/catalog/bots/{agentId}](https://developer.sas.com/apis/rest/DataManagement/#get-an-agent-by-its-id) - Get an Agent by its ID
- [catalog/bots/{agentId}](https://developer.sas.com/apis/rest/DataManagement/#delete-an-agent-by-its-id) - Delete an Agent by its ID
- [/catalog/bots](https://developer.sas.com/apis/rest/DataManagement/#get-agents) -Get a list of Agents
- [/catalog/bots](https://developer.sas.com/apis/rest/DataManagement/#update-an-agent-by-its-id) - Update an Agent by its ID

## Supported Versions
- Viya 4
- 2023.09
## Additional Resources
