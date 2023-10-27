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
- [/catalog/bots](https://developer.sas.com/apis/rest/DataManagement/#create-an-agent) - Create an Agent
- [/catalog/bots/{agentId}/state](https://developer.sas.com/apis/rest/DataManagement/#update-an-agent-39-s-run-state) - Update Agents run state
- [/catalog/bots/{agentId}/state](https://developer.sas.com/apis/rest/DataManagement/#get-an-agent-39-s-execution-status) - Get an Agent's execution state
- [/catalog/bots/{agentId}](https://developer.sas.com/apis/rest/DataManagement/#get-an-agent-by-its-id) - Get an Agent by its ID
- [catalog/bots/{agentId}](https://developer.sas.com/apis/rest/DataManagement/#delete-an-agent-by-its-id) - Delete an Agent by its ID
- [/catalog/bots](https://developer.sas.com/apis/rest/DataManagement/#get-agents) -Get a list of Agents
- [/catalog/bots](https://developer.sas.com/apis/rest/DataManagement/#update-an-agent-by-its-id) - Update an Agent by its ID

## Supported Versions

- Viya 4
- 2023.10

## Additional Resources