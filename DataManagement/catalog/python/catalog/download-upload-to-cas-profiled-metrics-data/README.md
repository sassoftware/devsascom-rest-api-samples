# Download or Upload Metadata

You can perform operations to download metadata to a file or upload metadata to a library in the CAS server. You can handle metadata as in-memory tables in a library. The metadata can be of various levels of detail, such as data dictionaries, detailed metrics, or a combination of data dictionaries and additional profile metrics.

## Overview

This collection utilizes the Catalog API to either download metadata for datasets or upload metadata to a library in a CAS server.

You can specify the type of metadata to download or upload to the CAS server through the `level` parameter. Below are the three different values for the `level` option:

1. `datadictionary`: This option provides basic metadata about the table and the columns such as tablesize,row count, column count, and others.

2. `detailedMetrics`: This option provides metadata about the columns with additional metrics such as dataType,columnOrdinalPosition, and others.

3. `dataDictionaryAndProfile`: This option provides extensive metadata combining both data dictionary and profile metrics. The metadata includes computed metrics such as sentiment analysis, useful keywords, privacy, and others.

The `delimiter` parameter allows you to specify the type of delimiter used to separate fields in a row when downloading metadata. With the `prefix` parameter, you can provide a prefix, while the `dateTimeStampSuffix` boolean parameter determines whether a date timestamp suffix should be added to the downloaded file name. The `prefix` and `dateTimeStampSuffix` parameters influence the downloadable file name. This can be seen in the Content-Disposition response header.

To upload table metadata to CAS, you need to provide the `serverName` (the name of the CAS Server) and `casLibName` (the name of the accessible CAS library for data upload). You can also specify `level`, `prefix`, and `dateTimeStampSuffix` parameters.

In this Python notebook, the first few requests are setup to create and execute discovery agent to retrieve metadata about tables that are in in the Samples CASLibrary. The second set of requests provides examples of downloading metadata using different values for `level`, `prefix`, and `dateTimeStampSuffix` parameters.
There are examples to demonstrate how to upload metadata to a "Public" library in CAS that uses parameters like `level`, `prefix`, and `dateTimeStampSuffix`.

## Prerequisites

#### Variables to assign:
- sasserver - the SAS Viya server URL
- username
- password

### Packages and Python Version
- python 3.7+
- requests, json, time
## Usage
1. Download the Python program or the Jupyter Notebook file.
2. Edit your variables to match your environment.
3. Proceed to run the program or Notebook commands.
## Endpoints Used
Create and execute Agent
- [/catalog/bots](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/createAgent) - Create an Agent
- [/catalog/bots/{agentId}/state](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/updateAgentRunState) - Update an Agent's run state
- [/catalog/bots/{agentId}/state](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/getAgentRunState) - Get an Agent's execution status
- [/catalog/instances/](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/instances/downloadInstances) - Download instances
- [/catalog/instances/](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/instances/uploadInstances) - Upload instances metadata to CAS

## Supported Versions
- Viya 4
- 2023.10
## Additional Resources