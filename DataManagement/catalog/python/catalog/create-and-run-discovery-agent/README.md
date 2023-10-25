# Create and Run a Discovery Agent
## Overview
This program leverages the Catalog API to create and run a Discovery Agent.
#### Variables to assign:
- sasserver - the SAS Viya server URL
- username
- password
### Packages and Python Version
- python 3
- requests, json
## Usage
1. Download the Python program or the Jupyter Notebook file.
2. Edit your variables to match your environment.
3. Proceed to run the program or Notebook commands.
## Endpoints Used
- [/catalog/bots](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/createAgent) - Create an Agent
- [/catalog/bots/{agentId}/state](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/updateAgentRunState) - Update Agents run state
- [/catalog/bots/{agentId}/state](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/getAgentRunState) - Get an Agent's execution state
- [/catalog/bots/{agentId}](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/getAgent) - Get an Agent by its ID
- [catalog/bots/{agentId}](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/deleteAgent) - Delete an Agent by its ID
- [/catalog/bots](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/getAgents) -Get a list of Agents
- [/catalog/bots](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/updateAgent) - Update an Agent by its ID

## Supported Versions

- Viya 4
- 2023.10

## Additional Resources