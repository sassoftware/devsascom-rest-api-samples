# Data Tables API
The Data Tables API is used to retrieve table and column metadata that is contained in the SAS Viya ecosystem.

#### Context

The Data Tables API works with the Data Sources and Row Sets APIs to navigate, reference, and retrieve data in the SAS Viya ecosystem. The Data Tables API enables retrieval of data table and column metadata.

## API Request Examples


* [Retrieving tables](#example-get-tables)
* [Retrieving column metadata](#example-get-columns)
* [Session handling](#example-session-handling)
* [Moving a table](#example-move-table)
* [Polling a job's state](#example-polling-job-state)
* [Polling a job's state with "long polling"](#example-long-polling)
* [Deleting a table](#example-delete-table)
* [Creating a table in CAS](#example-create-cas-table)


In the example below, the *data source* is a CAS caslib named "CasTestTmp", which includes the table, AIRLINES.
To see how to navigate to a caslib, see the [Data Sources API](https://developer.sas.com/apis/rest/DataManagement/#data-sources) documentation.

#### <a name='example-get-tables'>Retrieving Tables</a>

The entry point into this service must be from a [data source's `tables` link](https://developer.sas.com/apis/rest/DataManagement/#data-sources) to retrieve a collection of
[`application/vnd.sas.data.table`](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.table) resources.
For example, perform a GET request on the [`application/vnd.sas.data.source`](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.source) resource below:

**Tables Link from the application/vnd.sas.data.source**

```
{
      "method": "GET",
      "rel": "tables",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.table"
 }
```

Perform a GET request using the URI `/dataTables/dataSources/rowSets/tables/cas~fs~cas~fs~CASTestTmp/tables` to return an [`application/vnd.sas.collection`](https://developer.sas.com/apis/rest/Topics/#collections "application/vnd.sas.collection")
resource that contains [`application/vnd.sas.data.table`](https://developer.sas.com/apis/rest/DataManagement/#tocStable "Data Tables API") resources.

For information about paginating the tables of this collection, see [Pagination, Sorting, and Filtering](https://developer.sas.com/apis/rest/DataManagement/#get-a-collection-of-tables).

**Note:** *The syntax of the table URI above is for illustrative purposes only.
Do not use the format of these URIs to construct URIs.
Obtain table and other resource URIs using links in the API responses only.*

#### Retrieving Table URI Elements

Some cases might require you to break apart the table URI into various parts. For example, you might need to use the GET method to obtain the elements of a URI in order to execute a report and connect to CAS.

Given a table URI `/dataTables/dataSources/rowSets/tables/cas~fs~cas~fs~CASTestTmp/tables/myTable`
make the request `GET /dataTables/dataSources/rowSets/tables/cas~fs~cas~fs~CASTestTmp/tables/myTable`
with the header `Accept: application/vnd.sas.attributes+json`.

**The application/vnd.sas.attributes+json Resource**

```
 {
      "providerId": "cas",
      "casServer": "cas",
      "caslib": "myCasTestTmp",
      "tableName": "myTable"
 }
```

#### <a name='example-get-columns'>Retrieving Column Metadata</a>

The [`application/vnd.sas.data.table`](https://developer.sas.com/apis/rest/DataManagement/#tocStable) resource includes a `columns` link. Use this link to request an
[`application/vnd.sas.collection`](https://developer.sas.com/apis/rest/Topics/#collections "application/vnd.sas.collection")
resource that contains [`application/vnd.sas.data.column.summary`](https://developer.sas.com/apis/rest/DataManagement/#tocScolumnsummary) resources.
You can also set the Accept-Item header value to application/vnd.sas.data.column+json to retrieve the full column representation in the collection. See the example link below:

**Columns Link from the application/vnd.sas.data.table**

```
{
      "method": "GET",
      "rel": "columns",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES/columns",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES/columns",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.column.summary"
 }
```

#### Retrieving Row Data

The [`application/vnd.sas.data.table`](https://developer.sas.com/apis/rest/DataManagement/#tocStable) resource includes `rows` link that you can follow to request either
[`application/vnd.sas.collection`](https://developer.sas.com/apis/rest/Topics/#collections "application/vnd.sas.collection") of
[`application/vnd.sas.data.row`](https://developer.sas.com/apis/rest/DataManagement/#tocSrow "application/vnd.sas.data.row")
resource. Use the `rows` link to get the full row of data for the table, regardless of the number of columns. 

**Rows Link from the application/vnd.sas.data.table**

```
{
     "method": "GET",
     "rel": "rows",
     "href": "/rowSets/tables/cas~fs~cas~fs~CASTestTmp~fs~AIRLINES/rows",
     "uri": "/rowSets/tables/cas~fs~cas~fs~CASTestTmp~fs~AIRLINES/rows",
     "type": "application/vnd.sas.collection",
     "itemType": "application/vnd.sas.data.row",
}
```

#### <a name='example-session-handling'>Session Handling</a>

Certain Data Tables service providers support session-based data retrieval.
You can query `/dataTables/providers/{providerId}` to retrieve the media type
[`application/vnd.sas.data.provider`](https://developer.sas.com/apis/rest/DataManagement/#schemaprovider) and check the value of the `usesSessions` member.

##### Query Parameters

If the provider supports sessions, the following query parameters are supported for calls to `/dataTables/dataSources/{dataSourceId}/tables`, `/dataTables/dataSources/{dataSourceId}/tables/{tableName}`, `/dataTables/dataSources/{dataSourceId}/tables/{tableName}/columns` and `/dataTables/dataSources/{dataSourceId}/tables/{tableName}/columns/{columnName}`:

| Name               | Type      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|--------------------|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `?sessionId`       | `string`  | The unique identifier of the session that is used to access the data service provider's backing service. When this string is not specified, the data service provider creates a temporary session, and then terminates it after the request is complete. If this string is specified, all returned links, except the `self` link, contain the sessionId query parameter in their respective URIs. Also, they contain an additional session link to the application/vnd.sas.data.session resource that corresponds to the provided sessionId.                                                                  |
| `?preserveSession` | `boolean` | This parameter only has effect when the `?sessionId` query parameter is not specified. If set to true, no `?sessionId` is provided. The session that is created by the data service provider is not terminated. All returned links, except the "self" link, contain the `?sessionId`query parameter in their respective URIs. Also, they contain an additional session link to the application/vnd.sas.data.session resource that corresponds to the provided `?sessionId`. If set to false, or not specified, the session is terminated after the request is complete. The default is false. |

#### Link Relations

##### Session Link

The `session` link is added if the user provides the `sessionId` or if the `preserveSession` query parameter is set to true.
This `session` link must be the
[`application/vnd.sas.data.session`](https://developer.sas.com/apis/rest/DataManagement/#tocSsession) [media type](http://developer.sas.com/reference/Media_type "Media type"), and the href must be `/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}`.
The session link is provided so that the client can obtain further links to terminate the session if required.

##### sessionScoped Link

The `sessionScoped` link is added when the `sessionId` is provided by the user or the `preserveSession` query parameter is set to true.
This link gives the user access to a session-scoped version of the `self` link, and notifies the user that the session is temporary.
The `self` link must be the resource identifier that the user persists. The `sessionScoped` link can be used for immediate access and work being done with the resource by the client.


##### Use Case: Client Provides sessionId

If you know the session identifier, you can pass it as the query parameter `sessionId`. This session identifier is used when connecting to the data service provider's backing service; for example, CAS.
If the `sessionId` does not exist, a 404 error is returned.
Also, a session link must be provided that points to the appropriate session in the path `/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}`
where `sourceId` corresponds to the level of the data hierarchy that the session is associated with (for example, for CAS it would be the first level cas server).
The `sessionId` must be appended as a query parameter to all links except the `self` link, and the `sessionScoped` link to the respective resource must be added.

**Example CAS Data Provider Table**

```
# HTTP GET request to get a table passing their session identifier as the query parameter sessionId
GET /dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96
#Response application/vnd.sas.data.table+json
```

```
{
  "name": "AIRLINES",
  "providerId": "cas",
  "dataSourceId": "cas~fs~cas~fs~CASTestTmp",
  "creationTimeStamp": "2016-03-03T14:59:52.000Z",
  "modifiedTimeStamp": "2016-03-03T14:59:52.000Z",
  "createdBy": "etlguest",
  "modifiedBy": "etlguest",
  "type": "table",
  "attributes": {
    "loaded": true,
    "sourceTableName": null,
    "characterSet": "UTF8",
    "global": true,
    "caslibId": "CASTestTmp",
    "rowCount": 6048,
    "columnCount": 8,
    "sessionId": "feb250ff-15fc-ed44-913c-28c3f311c17b",
    "encoding": "utf-8",
    "serverId": "cas"
  },
  "version": 1,
  "links": \[
    {
      "method": "GET",
      "rel": "self",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES",
      "type": "application/vnd.sas.data.table"
    },
    {
      "method": "GET",
      "rel": "sessionScoped",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "type": "application/vnd.sas.data.table"
    },
    {
      "method": "GET",
      "rel": "session",
      "href": "/dataSources/providers/cas/sources/cas/sessions/d5272d22-ef57-4761-8b80-4998f114cc96",
      "uri": "/dataSources/providers/cas/sources/cas/sessions/d5272d22-ef57-4761-8b80-4998f114cc96",
      "type": "application/vnd.sas.data.session"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.table"
    },
    {
      "method": "GET",
      "rel": "dataSource",
      "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "type": "application/vnd.sas.data.source"
    },
   {
      "method": "GET",
      "rel": "provider",
      "href": "/dataTables/providers/cas",
      "uri": "/dataTables/providers/cas",
      "type": "application/vnd.sas.data.provider"
    },
    {
      "method": "GET",
      "rel": "rows",
      "href": "/rowSets/tables/cas~fs~cas~fs~CASTestTmp~fs~AIRLINES/rows?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "uri": "/rowSets/tables/cas~fs~cas~fs~CASTestTmp~fs~AIRLINES/rows?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.row.summary"
    },
    {
      "method": "GET",
      "rel": "columns",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES/columns?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES/columns?sessionId=d5272d22-ef57-4761-8b80-4998f114cc96",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.column.summary"
    }
  \]
}
```

##### Use Case: Client Does Not Specify the sessionId

If the user does not provide the session identifier, the data provider service creates a temporary session to request the data from the backing service, and then terminates that session upon completion of the request.

**Example CAS Data Provider Table**

```
# HTTP GET request to get a table that doesn't specify a sessionId
GET /dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES
#Response application/vnd.sas.data.table+json
```

```
{
  "name": "AIRLINES",
  "providerId": "cas",
  "dataSourceId": "cas~fs~cas~fs~CASTestTmp",
  "creationTimeStamp": "2016-03-03T14:59:52.000Z",
  "modifiedTimeStamp": "2016-03-03T14:59:52.000Z",
  "createdBy": "etlguest",
  "modifiedBy": "etlguest",
  "type": "table",
  "attributes": {
    "loaded": true,
    "sourceTableName": null,
    "characterSet": "UTF8",
    "global": true,
    "caslibId": "CASTestTmp",
    "rowCount": 6048,
    "columnCount": 8,
    "sessionId": "feb250ff-15fc-ed44-913c-28c3f311c17b",
    "encoding": "utf-8",
    "serverId": "cas"
  },
  "version": 1,
  "links": \[
    {
      "method": "GET",
      "rel": "self",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES",
      "type": "application/vnd.sas.data.table"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.table"
    },
    {
      "method": "GET",
      "rel": "dataSource",
      "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
      "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
      "type": "application/vnd.sas.data.source"
    },
   {
      "method": "GET",
      "rel": "provider",
      "href": "/dataTables/providers/cas",
      "uri": "/dataTables/providers/cas",
      "type": "application/vnd.sas.data.provider"
    },
    {
      "method": "GET",
      "rel": "rows",
      "href": "/rowSets/tables/cas~fs~cas~fs~CASTestTmp~fs~AIRLINES/rows",
      "uri": "/rowSets/tables/cas~fs~cas~fs~CASTestTmp~fs~AIRLINES/rows",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.row.summary"
    },
    {
      "method": "GET",
      "rel": "columns",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES/columns",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES/columns",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.column.summary"
    }
  ]
}
```

##### Use Case: Client Does Not Specify the sessionId and Specifies preserveSession=true\[[edit](http://sww.sas.com/saspediawiki/index.php?title=Data_Tables_Microservice_REST_API_(v2)&action=edit&section=18 "Edit section: Use Case: Client Does Not Specify sessionId and specifies preserveSession=true")\]

If the user does not provide the session identifier, the data provider service creates a temporary session to request the data from the backing service, and then terminates that session upon completion of the request. However, if the user sets the `preserveSession` query parameter to true, then that temporary session is preserved and placed on the returned links. In the example below, the session identifier b51875c6-0561-45e1-bad3-ea7c2053d65f is the temporal session that is preserved. Also, a session link must be provided that points to the appropriate session in the path `/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}` where `sourceId` corresponds to the level of the data hierarchy that the session is associated with (for example, for CAS it would be the first level cas server). The `sessionId` must be appended as a query parameter to all links, except the `self` link. The `sessionScoped` link to the respective resource must be added.

**Example CAS Data Provider Table**

```
# HTTP GET request to get a table while setting preserveSession to true
GET /dataTables/dataSources/cas~fs~casServer~fs~CASTestTmp/tables/AIRLINES?preserveSession=true
#Response application/vnd.sas.data.table+json
```

```
{
  "name": "AIRLINES",
  "providerId": "cas",
  "dataSourceId": "cas~fs~cas~fs~CASTestTmp",
  "creationTimeStamp": "2016-03-03T14:59:52.000Z",
  "modifiedTimeStamp": "2016-03-03T14:59:52.000Z",
  "createdBy": "etlguest",
  "modifiedBy": "etlguest",
  "type": "table",
  "attributes": {
    "loaded": true,
    "sourceTableName": null,
    "characterSet": "UTF8",
    "global": true,
    "caslibId": "CASTestTmp",
    "rowCount": 6048,
    "columnCount": 8,
    "sessionId": "feb250ff-15fc-ed44-913c-28c3f311c17b",
    "encoding": "utf-8",
    "serverId": "cas"
  },
  "version": 1,
  "links": \[
    {
      "method": "GET",
      "rel": "self",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES",
      "type": "application/vnd.sas.data.table"
    },
    {
      "method": "GET",
      "rel": "sessionScoped",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "type": "application/vnd.sas.data.table"
    },
    {
      "method": "GET",
      "rel": "session",
      "href": "/dataSources/providers/cas/sources/cas/sessions/b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "uri": "/dataSources/providers/cas/sources/cas/sessions/b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "type": "application/vnd.sas.data.session"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.table"
    },
    {
      "method": "GET",
      "rel": "dataSource",
      "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "type": "application/vnd.sas.data.source"
    },
   {
      "method": "GET",
      "rel": "provider",
      "href": "/dataTables/providers/cas",
      "uri": "/dataTables/providers/cas",
      "type": "application/vnd.sas.data.provider"
    },
    {
      "method": "GET",
      "rel": "rows",
      "href": "/rowSets/tables/cas~fs~cas~fs~CASTestTmp~fs~AIRLINES/rows?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "uri": "/rowSets/tables/cas~fs~cas~fs~CASTestTmp~fs~AIRLINES/rows?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.row.summary"
    },
    {
      "method": "GET",
      "rel": "columns",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES/columns?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES/columns?sessionId=b51875c6-0561-45e1-bad3-ea7c2053d65f",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.column.summary"
    }
  ]
}
```


#### Data Movement

Starting with version 3 of this API, clients can create and delete tables. All table creation and deletion operations are asynchronous, and support
a `?wait` query parameter for long polling.

##### <a name='example-move-table'>Use Case: Moving a Table</a>

To move a table, you must identify the source's data table URI, and the target's data source table collection URI. In this example, the source table is `AIRLINES` with URI `/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES`, and
the target source `Public` with URI `/dataSources/providers/cas/sources/cas~fs~Public`. To get the target data source's table collection URI, use the data source's `table` link, which provides
the URI `/dataTables/dataSources/cas~fs~cas~fs~Public/tables`. You can use the source table URI and the target table collection URI to submit a request to copy the table
from the source to the target.

##### <a name='example-create-table'>Creating a Table</a>

The request below uses the media type [application/vnd.sas.data.table.request+json](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.table.request~json), which creates the table with all of the default options
for a given source data table that is defined by the `tableUri` member of the `sourceArguments` object. For more information, see [available request media types](https://developer.sas.com/apis/rest/DataManagement/#media-types-3).

```
POST /dataTables/dataSources/cas~fs~cas~fs~CasTestTemp/tables
Accept: application/vnd.sas.data.table.job+json
Content-Type: application/vnd.sas.data.table.request+json
```

```
{
    "sourceArguments": {
        "tableUri" : "/dataTables/dataSources/cas~fs~cas~fs~Public/tables/AIRLINES"
    },
    "targetArguments": {
        "tableName": "AIRLINES"
    }
}
```

The service runs an asynchronous job to load the table and returns a status of `201 Created` HTTP Status Code if completed, or a `202 Accepted` if still running.
For this example, the returned response is an [application/vnd.sas.data.table.job+json](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.table.job~json) resource.

```
202 Accepted
Location: /dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408
Content-Type: application/vnd.sas.data.table.job+json
```
```
{
    "creationTimeStamp": "2018-03-11T01:14:05.885Z",
    "modifiedTimeStamp": "2018-03-11T01:14:05.885Z",
    "createdBy": "sasuser",
    "modifiedBy": "sasuser",
    "version": 1,
    "id": "cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408",
    "providerId": "cas",
    "state": "running",
    "type": "create",
    "duration": 0.153,
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408",
            "uri": "/dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408",
            "type": "application/vnd.sas.data.table.job"
        },
        {
            "method": "GET",
            "rel": "alternate",
            "href": "/jobExecution/jobs/a86b95df-b179-409b-a327-83d141749408",
            "uri": "/jobExecution/jobs/a86b95df-b179-409b-a327-83d141749408",
            "type": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408/state",
            "uri": "/dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408/state",
            "type": "text/plain"
        },
        {
            "method": "GET",
            "rel": "sourceTable",
            "href": "/dataTables/dataSources/cas~fs~cas~fs~Public/tables/CANADA",
            "uri": "/dataTables/dataSources/cas~fs~cas~fs~Public/tables/CANADA",
            "type": "application/vnd.sas.data.table"
        },
        {
            "method": "GET",
            "rel": "targetTable",
            "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/CANADA",
            "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/CANADA",
            "type": "application/vnd.sas.data.table"
        }
    ]
}

```

#### Monitoring the Table Create Job

You can select the `state` link or the `self` link to check if the job is in the `pending` or `running` state.
If additional information is needed by the [application/vnd.sas.data.table.job+json](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.table.job~json) resource, use the `alternate` link to access the backing [`application/vnd.sas.job.execution.job+json`](http://developer.sas.com/reference/schema/application-vnd.job.execution.job~json).

##### <a name='example-polling-job-state'>Polling the Job's State</a>

To poll the state of the job, use the `state` link and perform the request below.

```
GET /dataTables/jobs/cas~fs~jes~fs~myUUIDSub/state
Accept: text/plain
```

The state of the job is returned. In this case, the state of the job is:

```
200 OK
Content-Type: text/plain

completed
```

After the job has completed, follow the job resource's `targetTable` link to retrieve the newly created table.

##### <a name='example-long-polling'>Long Polling</a>

To determine whether the job is complete, you can use the long polling functionality. You can use the `self` link of the job resource, and add the `?wait` query parameter
with a float value of up to 30 seconds. In this example, use `25.5`:

```
GET /dataTables/jobs/cas~fs~jes~fs~myUUIDSub?wait=25.5
Accept: application/vnd.sas.data.table.job+json
```

The job returns upon completion or when the float value `25.5` seconds has passed without the job reaching a terminal state. In this case, the job completed within the specified time:

```
200 OK
Content-Type: application/vnd.sas.data.table.job+json
```
```
{
    "creationTimeStamp": "2018-03-11T01:14:05.885Z",
    "endTimeStamp": "2018-03-11T01:14:08.194Z",
    "modifiedTimeStamp": "2018-03-11T01:14:08.464Z",
    "createdBy": "sasuser",
    "modifiedBy": "sasuser",
    "version": 1,
    "id": "cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408",
    "providerId": "cas",
    "state": "completed",
    "type": "create",
    "elapsedTime": 153,
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408",
            "uri": "/dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408",
            "type": "application/vnd.sas.data.table.job"
        },
        {
            "method": "GET",
            "rel": "alternate",
            "href": "/jobExecution/jobs/a86b95df-b179-409b-a327-83d141749408",
            "uri": "/jobExecution/jobs/a86b95df-b179-409b-a327-83d141749408",
            "type": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408/state",
            "uri": "/dataTables/jobs/cas~fs~jes~fs~a86b95df-b179-409b-a327-83d141749408/state",
            "type": "text/plain"
        },
        {
            "method": "GET",
            "rel": "sourceTable",
            "href": "/dataTables/dataSources/cas~fs~cas~fs~Public/tables/AIRLINES",
            "uri": "/dataTables/dataSources/cas~fs~cas~fs~Public/tables/AIRLINES",
            "type": "application/vnd.sas.data.table"
        },
        {
            "method": "GET",
            "rel": "targetTable",
            "href": "/dataTables/dataSources/cas~fs~cas~fs~CasTestTmp/tables/AIRLINES",
            "uri": "/dataTables/dataSources/cas~fs~cas~fs~CasTestTmp/tables/AIRLINES",
            "type": "application/vnd.sas.data.table"
        },
        {
            "method": "GET",
            "rel": "log",
            "href": "/files/files/64bd2b10-82c0-4c85-b9eb-a95e0832f86d",
            "uri": "/files/files/64bd2b10-82c0-4c85-b9eb-a95e0832f86d"
        }
    ]
}
```

After the job has completed, you can follow the job resource's `targetTable` link to retrieve the newly created table.

#### <a name='example-delete-table'>Deleting the Source Table</a>

To delete the source table and complete the table move, issue
the request below, which uses the long polling `?wait` query parameter with the maximum value of `30` seconds.

```
DELETE /dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables/AIRLINES?wait=30
Accept: application/vnd.sas.data.table.job+json
```

The service runs an asynchronous job to delete the table. A `204 No Content` HTTP status code returns if the job completed with no body, or a `202 Accepted` returns if the job is running
and the body contains a [application/vnd.sas.data.table.job+json](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.table.job~json) resource. In both cases, a `Location` header exists in the response
that contains the URI of the associated delete job. In this example, the request completed within the `30` second long polling time, and returned the response below.

```
204 No Content
Location: /dataTables/jobs/cas~fs~jes~fs~a5e8945e-06bb-454a-a475-703ad6546f42
```

#### <a name='example-create-cas-table'>Creating a CAS Table from CSV</a>

To create a table in CAS from a CSV file, you must identify the source CSV file's respective CAS server, caslib and path to the file within its caslib.
In this example, the cas server is `cas`, the caslib is `CasTestTmp`, and the source CSV file path is `airlines.csv`.

##### Creating the Table

The request below uses the media type [application/vnd.sas.data.table.cas.delimited.request+json](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.table.cas.delimited.request~json),
which creates the table from the source that is defined by the `casServer`, `caslib`, and `tablePath` member of the `sourceArguments` object. Note that `delimiter` is specified
below. If the `delimiter` is not specified, the default is `,`. For more information, see [media types](https://developer.sas.com/apis/rest/DataManagement/#media-types-3).

```
POST /dataTables/dataSources/cas~fs~cas~fs~Public/tables?wait=30
Accept: application/vnd.sas.data.table.job+json
Content-Type: application/vnd.sas.data.table.cas.delimited.request+json
```
```
{
    "sourceArguments": {
        "casServer" : "cas",
        "caslib" : "CasTestTmp",
        "tablePath" : "airlines.csv",
        "delimiter" : ","
    },
    "targetArguments": {
        "tableName": "AIRLINES"
    }
}
```

The request above uses [long polling](#example-long-polling), and in this case the job completes with the `201 Created` Http Status Code within the 30 second wait period.
For this example, the returned response is an [application/vnd.sas.data.table.job+json](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.table.job~json) resource. After the job has
completed, you can follow the job resource's `targetTable` link to retrieve the new table.

```
201 Created
Location: /dataTables/jobs/cas~fs~jes~fs~c19e11d2-75c5-4ecb-a9e0-e1c173c8adcc
Content-Type: application/vnd.sas.data.table.job+json
```
```
{
    "creationTimeStamp": "2018-03-14T01:14:05.885Z",
    "modifiedTimeStamp": "2018-03-14T01:14:05.985Z",
    "createdBy": "sasuser",
    "modifiedBy": "sasuser",
    "version": 1,
    "id": "cas~fs~jes~fs~c19e11d2-75c5-4ecb-a9e0-e1c173c8adcc",
    "providerId": "cas",
    "state": "completed",
    "type": "create",
    "duration": 0.100,
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/dataTables/jobs/cas~fs~jes~fs~c19e11d2-75c5-4ecb-a9e0-e1c173c8adcc",
            "uri": "/dataTables/jobs/cas~fs~jes~fs~c19e11d2-75c5-4ecb-a9e0-e1c173c8adcc",
            "type": "application/vnd.sas.data.table.job"
        },
        {
            "method": "GET",
            "rel": "alternate",
            "href": "/jobExecution/jobs/c19e11d2-75c5-4ecb-a9e0-e1c173c8adcc",
            "uri": "/jobExecution/jobs/c19e11d2-75c5-4ecb-a9e0-e1c173c8adcc",
            "type": "application/vnd.sas.job.execution.job"
        },
        {
            "method": "GET",
            "rel": "state",
            "href": "/dataTables/jobs/cas~fs~jes~fs~c19e11d2-75c5-4ecb-a9e0-e1c173c8adcc/state",
            "uri": "/dataTables/jobs/cas~fs~jes~fs~c19e11d2-75c5-4ecb-a9e0-e1c173c8adcc/state",
            "type": "text/plain"
        },
        {
            "method": "GET",
            "rel": "targetTable",
            "href": "/dataTables/dataSources/cas~fs~cas~fs~Public/tables/CANADA",
            "uri": "/dataTables/dataSources/cas~fs~cas~fs~Public/tables/CANADA",
            "type": "application/vnd.sas.data.table"
        }
    ]
}
```


version 3, last updated 13 OCT, 2020