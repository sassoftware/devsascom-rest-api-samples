
# Download or Upload Metadata

You can perform operations to download metadata to a file or upload metadata to a library in the CAS server. You can handle metadata as in-memory tables in a library. The metadata can be of various levels of detail, such as data dictionaries, detailed metrics, or a combination of data dictionaries and additional profile metrics.

## Overview

This collection utilizes the Catalog API to either download metadata for datasets or upload metadata to a library in a CAS server.

You can specify the type of metadata to download or upload to the CAS server through the `level` parameter. Below are the three different values for the `level` option:

1. `datadictionary`: This option provides basic metadata about the table and the columns such as tablesize, row count, column count, and others.

2. `detailedMetrics`: This option provides metadata about the columns with additional metrics such as dataType, columnOrdinalPosition, and others.

3. `dataDictionaryAndProfile`: This option provides extensive metadata combining both data dictionary and profile metrics. The metadata includes computed metrics such as sentiment analysis, useful keywords, privacy, and others.

The `delimiter` parameter allows you to specify the type of delimiter used to separate fields in a row when downloading metadata. With the `prefix` parameter, you can provide a prefix. The `dateTimeStampSuffix` boolean parameter determines whether a date timestamp suffix should be added to the downloaded file name. The `prefix` and `dateTimeStampSuffix` parameters influence the downloadable file name. They can be seen in the Content-Disposition response header.

To upload table metadata to CAS, you need to provide the `serverName` (the name of the CAS Server) and `casLibName` (the name of the accessible CAS library for data upload). Users can also specify `level`, `prefix`, and `dateTimeStampSuffix` parameters.

In this Postman collection:

- Steps 1 through 4 execute a discovery agent to generate metrics for datasets stored in the Samples CAS Library.
- Steps 5 through 9 offer examples of downloading metadata using different values for `level`, `prefix`, and `dateTimeStampSuffix` parameters.
- Steps 10 through 12 demonstrate how to upload metadata to a "Public" library in CAS that uses various parameters like `level`, `prefix`, and `dateTimeStampSuffix`.

## Prerequisites

### Variables
The Postman collection comes with variables you must assign either at the collection or the environment level. Assign values to the following variables prior to running the collection:
- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `access_token`
Other variables are assigned programmatically during the REST calls using code in the Postman Tests tab.

## Usage
1. Download the JSON collection and the sasserver.env. Then import the files into Postman.
2. Select sasserver.env as the environment and edit your environment variables to match those contained in the collection requests (sasserver and access_token).
3. Be sure to authenticate to your server before testing the endpoints.
4. You can run one request at a time or run the collection. The first step is to run a Discovery Agent to generate the data. Then you can run requests to download the metadata.

## Endpoints Used
Create and execute Agent
- [/catalog/bots](https://developer.sas.com/rest-apis/catalog/createAgent) - Create an Agent
- [/catalog/bots/{agentId}/state](https://developer.sas.com/rest-apis/catalog/updateAgentRunState) - Update an Agent's run state
- [/catalog/bots/{agentId}/state](https://developer.sas.com/rest-apis/catalog/getAgentRunState) - Get an Agent's execution status
- [/catalog/instances/](https://developer.sas.com/rest-apis/catalog/downloadInstances) - Download instances
- [/catalog/instances/](https://developer.sas.com/rest-apis/catalog/uploadInstances) - Upload instances metadata to CAS

## Supported Versions
- Viya 4
- 2023.09
## Additional Resources
