# CAS Management API
The CAS Management API provides the ability to manage and perform actions on common resources
related to Cloud Analytic Services (CAS). This API can be used to manage servers, nodes, sessions,
libraries, and tables in CAS, as well as source tables available to load to CAS.

#### HEAD Support
Note that HEAD is supported for every GET request documented in the API. Simply change the
HTTP verb from GET to HEAD, leaving other parameters the same.

#### Provider Implementation
The CAS Management API implements endpoints necessary to be classified as both a data sources
provider and data tables provider for the Data Sources and Data Tables APIs. The Data Sources
and Data Tables APIs enable you to reference data sources and data tables independent of the
underlying provider.

Endpoints for the Data Sources and Data Tables APIs that contain the *Provider* tag support
additional provider-specific endpoint parameters. See the documentation for those APIs for
information about the provider endpoints.

This documentation details endpoints specific to the CAS Management API, as well as endpoints
that extend the Data Sources and Data Tables APIs. As a result, the API can be exercised in
the following ways:

  - using the endpoints specified in this document directly
  - using the endpoints for the Data Sources or Data Tables APIs, where the CAS Management API acts as a provider.

##### Note
When accessed via the provider endpoints, the term *source* is used to refer to a location containing tables
and, for this provider, CAS tables. A source in this context could be either a CAS server or a CAS library.

Within a CAS library, however, there is also the concept of a data source. In this context, a source refers
to the source table or tables accessible by a given CAS library. Endpoints within this documentation with a
`Sources` tag refer to the caslib sources, not provider sources. This is an important distinction to understand
when using the CAS Management API, as the CAS Management API sits between the data management standards and CAS,
which both use the term *source*.

#### Other Service Links
Note that some resource links might refer to other paths (such as /casProxy, /dataSources, /dataTables).
These links are operational only if the corresponding service has been deployed at the referenced location.


## API Request Examples Grouped by Object Type

<details>
<summary>Servers</summary>

* [Get servers](#GetServers)
* [Get a single server](#GetaSingleServer)
* [Determine whether a CAS server is running](#DetermineIfaCASServerIsRunning)
* [Get metrics from a CAS server](#GetMetricsfromaCASServer)
</details>

<details>
<summary>Sessions</summary>

* [Get sessions](#GetSessions)
* [Get a single session](#GetaSingleSession)
* [Create a new session](#CreateaNewSession)
* [Create a new session with options](#CreateaNewSessionwithOptions)
* [Create a new session in a Korean locale](#CreateaNewSessioninKoreanLocale)
* [Determine whether a session is running](#DetermineIfaSessionIsRunning)
* [End a session](#EndaSession)
</details>

<details>
<summary>Nodes</summary>

* [List nodes](#ListNodes)
* [List a single node](#ListaSingleNode)
* [Add a node](#AddaNode)
* [Remove a node](#RemoveaNode)
</details>

<details>
<summary>Caslibs</summary>

* [Get caslibs](#GetCaslibs)
* [Get a single caslib](#GetaSingleCaslib)
* [Edit a global caslib description or path](#EditaGlobalCaslibDescriptionorPath)
* [Create a path-based caslib](#CreateaPathBasedCaslib)
* [Create a DNFS caslib](#CreateaDNFSCaslib)
* [Create an HDFS caslib](#CreateanHDFSCaslib)
* [Create a Teradata caslib](#CreateaTeradataCaslib)
* [Create an Oracle caslib](#CreateanOracleCaslib)
* [Create a Greenplum caslib](#CreateaGreenplumCaslib)
* [Create a PostgreSQL caslib](#CreateaPostgreSQLcaslib)
* [Create a LASR caslib](#CreateaLASRCaslib)
* [Create an Amazon S3 caslib](#CreateanAmazonS3Caslib)
* [Create a YouTube caslib](#CreateaYouTubeCaslib)
* [Create a Google Analytics caslib](#CreateaGoogleAnalyticsCaslib)
* [Remove a caslib definition](#RemoveaCaslibDefinition)
</details>

<details>
<summary>Tables</summary>

* [List up to 50 tables in a caslib](#Listupto50TablesinaCaslib)
* [List only the loaded tables in a caslib](#ListOnlytheLoadedTablesinacaslib)
* [List a single table](#ListaSingleTable)
* [List a single table with all detail groups included](#ListaSingleTablewithAllDetailGroupsIncluded)
* [Load a table](#LoadaTable)
* [Load a table from a specific source file](#LoadaTablefromaSpecificSourceFile)
* [Load a table to a different output](#LoadaTabletoaDifferentOutput)
* [Load a CSV file with non-default options](#LoadaCSVFilewithNonDefaultOptions)
* [Load a subset of a table](#LoadaSubsetofaTable)
* [Unload a table](#UnloadaTable)
* [Promote a session table to a global scope](#PromoteaSessionTabletoGlobalScope)
* [Save a table and replace the original](#SaveaTableReplacingtheOriginal)
* [Save a table in the same format with a different name](#SaveaTableintheSameFormatwithaDifferentName)
* [Save a table in SASHDAT format](#SaveaTableinSASHDATFormat)
* [Save a table in CSV format](#SaveaTableinCSVFormat)
* [Save a table in CSV format with a different name](#SaveaTableinCSVFormatwithaDifferentName)
* [Save a table to a different caslib with a different table name](#SaveaTabletoaDifferentCaslibwithaDifferentTableName)
* [Delete a table](#DeleteaTable)
</details>

<details>
<summary>Sources</summary>

* [List sources](#ListSources)
* [List a single source](#ListaSingleSource)
* [Delete a source](#DeleteaSource)
</details>

<details>
<summary>Columns</summary>

* [List columns](#ListColumns)
* [List a single column](#ListaSingleColumn)
* [Get distinct counts for a table](#GetDistinctCountsforaTable)
* [Get summary statistics for a table](#GetSummaryStatisticsforaTable)
* [Get the distinct count for a column](#GettheDistinctCountforaColumn)
* [Get the distinct values for a column](#GettheDistinctValuesforaColumn)
* [Get the summary statistics for a column](#GettheSummaryStatisticsforaColumn)
* [Get the frequency for a column](#GettheFrequencyforaColumn)
</details>

<details>
<summary>Policies</summary>

* [Get policies](#GetPolicies)
* [Get the policy for a priority level](#GetthePolicyforaPriorityLevel)
* [Create the policy for a priority level](#CreatethePolicyforaPriorityLevel)
* [Get the policy for global caslibs](#GetthePolicyforGlobalCaslibs)
* [Create the policy for global caslibs](#CreatethePolicyforGlobalCaslibs)
* [Get the policy for priority assignments](#GetthePolicyforPriorityAssignments)
* [Create the policy for priority assignments](#CreatethePolicyforPriorityAssignments)
* [Delete a policy](#DeleteaPolicy)
</details>

<details>
<summary>Data Connectors</summary>

* [Get data connectors](#GetDataConnectors)
* [Get a single data connector](#GetaSingleDataConnector)
* [Get the definition of a single data connector](#GettheDefinitionofaSingleDataConnector)
</details>


##### <a name='GetServers'>Get Servers</a>
Here is an example of using a GET request to retrieve servers.

```
GET /casManagement/servers HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetaSingleServer'>Get a Single Server</a>
Here is an example of using a GET request to retrieve a single server.

```
GET /casManagement/servers/cas-shared-default HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server+json
Authorization: Bearer YOURTOKEN
```


##### <a name='DetermineIfaCASServerIsRunning'>Determine if a CAS Server is Running</a>
Here is an example of using a GET request to determine whether a CAS server is running.

```
GET /casManagement/servers/cas-shared-default/state HTTP/1.1
Host: apihost.example.com
Accept: text/plain
Authorization: Bearer YOURTOKEN
```


##### <a name='GetMetricsfromaCASServer'>Get Metrics from a CAS Server</a>
Here is an example of using a GET request to retrieve metrics from a CAS server.

```
GET /casManagement/servers/cas-shared-default/metrics HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.metrics+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetSessions'>Get Sessions</a>
Here is an example of using a GET request to retrieve sessions.

```
GET /casManagement/servers/cas-shared-default/sessions HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetaSingleSession'>Get a Single Session</a>
Here is an example of using a GET request to retrieve a single session.

```
GET /casManagement/servers/cas-shared-default/sessions/b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.session.summary+json
Authorization: Bearer YOURTOKEN
```


##### <a name='CreateaNewSession'>Create a New Session</a>
Here is an example of using a POST request to create a new session.

```
POST /casManagement/servers/cas-shared-default/sessions HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.session+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.session+json
```


##### <a name='CreateaNewSessionwithOptions'>Create a New Session with Options</a>
Here is an example of using a POST request to create a new session with options.

```
POST /casManagement/servers/cas-shared-default/sessions?sessionId=9ed3a21a-736a-864f-a0e7-8070a959947f HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.session+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.session+json
{
    "name": "My session name",
    "timeOut": 3600
}
```


##### <a name='CreateaNewSessioninKoreanLocale'>Create a New Session in a Korean Locale</a>
Here is an example of using a POST request to create a new session in a Korean locale.

```
POST /casManagement/servers/cas-shared-default/sessions?sessionId=9ed3a21a-736a-864f-a0e7-8070a959947f HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.session+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.session+json
Accept-Language: ko-kr
```


##### <a name='DetermineIfaSessionIsRunning'>Determine If a Session Is Running</a>
Here is an example of using a GET request to determine whether a session is running.

```
GET /casManagement/servers/cas-shared-default/sessions/b3a9d3f9-1095-d848-85d4-02b19fc4e5cf/state HTTP/1.1
Host: apihost.example.com
Accept: text/plain
Authorization: Bearer YOURTOKEN
```


##### <a name='EndaSession'>End a Session</a>
Here is an example of deleting a session.

```
DELETE /casManagement/servers/cas-shared-default/sessions/b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Authorization: Bearer YOURTOKEN
```


##### <a name='ListNodes'>List Nodes</a>
Here is an example of using a GET request to retrieve a list of nodes.

```
GET /casManagement/servers/cas-shared-default/nodes HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='ListaSingleNode'>List a Single Node</a>
Here is an example of using a GET request to retrieve a single node.

```
GET /casManagement/servers/cas-shared-default/nodes/somenodehost.example.com HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.node+json
Authorization: Bearer YOURTOKEN
```


##### <a name='AddaNode'>Add a Node</a>
Here is an example of using a POST request to add a node.

```
POST /casManagement/servers/cas-shared-default/nodes?superUserSessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.node+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.server.node+json
{
   "name": "newnode.example.com"
}
```


##### <a name='RemoveaNode'>Remove a Node</a>
Here is an example of deleting a node.

```
DELETE /casManagement/servers/cas-shared-default/nodes/nodetodelete.example.com?superUserSessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetCaslibs'>Get Caslibs</a>
Here is an example of using a GET request to retrieve Caslibs.

```
GET /casManagement/servers/cas-shared-default/caslibs HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetaSingleCaslib'>Get a Single Caslib</a>
Here is an example of using a GET request to retrieve a single Caslib.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
```


##### <a name='EditaGlobalCaslibDescriptionorPath'>Edit a Global Caslib Description or Path</a>
Here is an example of editing a global Caslib description or path.

```
PATCH /casManagement/servers/cas-shared-default/caslibs/TmpLib?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
    "version": 1,
    "description": "ANOTHER DESCRIPTION",
    "path": "/ANOTHERPATH2",
    "attributes":
    {
        "subDirs":true
    }
}
```


##### <a name='CreateaPathBasedCaslib'>Create a Path-Based Caslib</a>
Here is an example of using a POST request to create a path-based Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&createDirectory=false HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "MyCaslib",
  "type": "PATH",
  "description": "My data",
  "path": "/some/path/on/disk",
  "scope": "global",
  "transient": false,
}
```


##### <a name='CreateaDNFSCaslib'>Create a DNFS Caslib</a>
Here is an example of using a POST request to create a DFNS Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "DnfsLib",
  "description": "DNFS caslib",
  "type": "dnfs",
  "path": "/mapr4/my.example.com/user/USERID/",
  "scope": "session",
  "attributes": {
    "subDirs": true,
    "encryptionDomain": "My Encrypt Domain"
  }
}
```


##### <a name='CreateanHDFSCaslib'>Create an HDFS Caslib</a>
Here is an example of using a POST request to create an HDFS Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "HdfsLib",
  "description": "HDFS caslib",
  "type": "hdfs",
  "path": "/vapublic",
  "scope": "global",
  "attributes": {
    "encryptionDomain": "My Encrypt Domain"
  }
}
```


##### <a name='CreateaTeradataCaslib'>Create a Teradata Caslib</a>
Here is an example of using a POST request to create a Teradata Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "TeraLib",
  "description": "Teradata caslib",
  "type": "teradata",
  "scope": "session",
  "path": "",
  "attributes": {
       "username": "USER",
       "password": "PASS",
       "server": "SERVER"
  }
}
```


##### <a name='CreateanOracleCaslib'>Create an Oracle Caslib</a>
Here is an example of using a POST request to create an Oracle Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "OracleLib",
  "description": "Oracle caslib",
  "type": "oracle",
  "path": "//oraclehost.example.com:1521/EXADAT",
  "scope": "session",
  "attributes": {
       "username": "USER",
       "password": "PASS",
       "schema": "SCHEMA"
  }
}
```


##### <a name='CreateaGreenplumCaslib'>Create a Greenplum Caslib</a>
Here is an example of using a POST request to create a Greenplum Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessixonId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "GreenplumLib",
  "description": "Greenplum caslib",
  "type": "greenplum",
  "scope": "session",
  "attributes": {
       "username": "USER",
       "password": "PASS",
       "server": "SERVER",
       "database": "DATABASE",
       "schema": "MODEL"
  }
}
```


##### <a name='CreateaPostgreSQLcaslib'>Create a PostgreSQL caslib</a>
Here is an example of using a POST request to create a PostgresSQL Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "PostgresLib",
  "description": "PostgreSQL caslib",
  "type": "postgres",
  "path": "/some/path",
  "scope": "session",
  "attributes": {
       "username": "USER",
       "password": "PASS",
       "server": "SERVER",
       "database": "DATABASE",
       "schema": "SCHEMA"
  }
}

```


##### <a name='CreateaLASRCaslib'>Create a LASR Caslib</a>
Here is an example of using a POST request to create a LASR Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "LASRLib",
  "description": "LASR caslib",
  "type": "lasr",
  "path": "/some/path",
  "scope": "session",
  "attributes": {
       "username": "USER",
       "password": "PASS",
       "server": "SERVER",
       "port": 10050,
       "signer": "http://SIGNERHOST:PORT/SASLASRAuthorization",
       "metalib": "VAPUBLIC"
  }
}
```


##### <a name='CreateanAmazonS3Caslib'>Create an Amazon S3 Caslib</a>
Here is an example of using a POST request to create an Amazon S3 Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "S3Lib",
  "description": "S3 caslib",
  "type": "s3",
  "path": "/some/path",
  "scope": "session",
  "attributes": {
       "accessKeyId":"ACCESSKEYID",
       "secretAccessKey":"SECRETACCESSKEY",
       "bucket":"bucket.name",
       "region":"US_East",
       "objectPath":"",
       "useSSL":"true"
  }
}
```


##### <a name='CreateaYouTubeCaslib'>Create a YouTube Caslib</a>
Here is an example of using a POST request to create a YouTub Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sesxsionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "youtube",
  "description": "YouTube caslib",
  "path":"youtube",
  "type": "youtube",
  "scope": "global"
}
```


##### <a name='CreateaGoogleAnalyticsCaslib'>Create a Google Analytics Caslib</a>
Here is an example of using a POST request to create a Google Analytics Caslib.

```
POST /casManagement/servers/cas-shared-default/caslibs?sesxsionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "GoogleAnalyticsCaslib",
  "description": "Google analytics data",
  "path":"ga",
  "type": "ga",
  "scope": "global"
}
```


##### <a name='RemoveaCaslibDefinition'>Remove a Caslib Definition</a>
Here is an example of using a POST request to create a Caslib definition.

```
DELETE /casManagement/servers/cas-shared-default/caslibs/ora2?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Authorization: Bearer YOURTOKEN
```


##### <a name='Listupto50TablesinaCaslib'>List Up to 50 Tables in a Caslib</a>
Here is an example of using a GET request to list up to 50 tables in a Caslib.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables?sessixonId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&limit=50 HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='ListOnlytheLoadedTablesinacaslib'>List Only the Loaded Tables in a Caslib</a>
Here is an example of using a GET request to list only loaded tables in a Caslib.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables?sessixonId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&state=loaded HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='ListaSingleTable'>List a Single Table</a>
Here is an example of using a GET request to list a single table.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
```


##### <a name='ListaSingleTablewithAllDetailGroupsIncluded'>List a Single Table with All Detail Groups Included</a>
Here is an example of using a GET request to list a single table with all detail groups included.

*This call might be less performant, but gathers more detail.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&detailGroups=all HTTP/1.1
Host: apihost.example.com
Content-Type: application/json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
```


##### <a name='LoadaTable'>Load a Table</a>
Here is an example of using a PUT request to load a table.

This example is commonly referred to as a just-in-time or 'JIT' load because the call is often made to ensure that a table is either already loaded or to carry out a load of the table.
  
CAS Management automatically selects the source table or file to load using the following default source table matching algorithm:

* In the case of a source _table_, the first source table name, which differs
* In the case of a source _file_, the same case-insensitive match is made using the base name of the table (without the file extension).
* In the case of a source _file_, if multiple base names match with different
  extensions, the match is selected using the following order of precedence:
  sashdat, sas7bdat, csv

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessixonId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=loaded&scope=global&createRelationships=true HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
```


##### <a name='LoadaTablefromaSpecificSourceFile'>Load a Table from a Specific Source File</a>
Here is an example of using a PUT request to load a table from a specific source file.

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=loaded&scope=global HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
```


##### <a name='LoadaTabletoaDifferentOutput'>Load a Table to a Different Output</a>
Here is an example of using a PUT request to load a table to a different output.

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessionxId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=loaded HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.table.load.request+json
{

 "outputCaslibName":"CASTestTmp",
 "outputTableName":"MyOutTable",
 "label":"My table label",
 "replace": false,
 "scope":"global",
 "copies": 1

}
```


##### <a name='LoadaCSVFilewithNonDefaultOptions'>Load a CSV File with Non-Default Options</a>
Here is an example of using a PUT request to load a CSV file with non-default options.

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessionxId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=loaded HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.table.load.request+json
{
"label": "My Table Label",
"replace": false,
"scope": "global",
"parameters":
 {

 "importOptions":
  {
   "allowTruncation": true,
   "delimiter": ",",
   "encoding": "utf-8",
   "fileType": "csv",
   "getNames": true,
   "guessRows": 50.0,
   "nThreads": 0.0,
   "stripBlanks": false,
   "varChars": false
  }
},
"where": "NAME ? \"Mr.\""
}
```


##### <a name='LoadaSubsetofaTable'>Load a Subset of a Table</a>
Here is an example of using a PUT request to load a subset of a table.

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessionxId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=loaded HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.table.load.request+json
{
"label": "My Table Label",
"replace": false,
"scope": "global",
"where": "NAME ? \"Mr.\""
}
```


##### <a name='UnloadaTable'>Unload a Table</a>
Here is an example of using a PUT request to unload a table.

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=unloaded HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
```


##### <a name='PromoteaSessionTabletoGlobalScope'>Promote a Session Table to a Global Scope</a>
Here is an example of using a PUT request to promote a session table to a global scope.

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/scope?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=global HTTP/1.1
Host: apihost.example.com
Accept: text/plain
Authorization: Bearer YOURTOKEN
```


##### <a name='SaveaTableReplacingtheOriginal'>Save a Table and Replace the Original</a>
Here is an example of using a POST request to save a table and replace the original.

```
POST /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.table.save.request+json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
{
  "replace": true
}
```


##### <a name='SaveaTableintheSameFormatwithaDifferentName'>Save a Table in the Same Format with a Different Name</a>
Here is an example of using a POST request to save a table in the same format with a different name.

```
POST /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.table.save.request+json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
{
  "caslibName":"Public",
  "tableName" :"SAVED_AS_CONTACTS",
  "replace": true
}
```


##### <a name='SaveaTableinSASHDATFormat'>Save a Table in SASHDAT Format</a>
Here is an example of using a POST request to save a table in SASHDAT format.

```
POST /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.table.save.request+json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
{
  "format": "sashdat",
  "replace": true
}
```


##### <a name='SaveaTableinCSVFormat'>Save a Table in CSV Format</a>
Here is an example of using a POST request to save a table in CSV format.

```
POST /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.table.save.request+json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
{
  "format": "csv",
  "replace": true
}
```


##### <a name='SaveaTableinCSVFormatwithaDifferentName'>Save a Table in CSV Format with a Different Name</a>
Here is an example of using a POST request to save a table in CSV format with a different name.

```
POST /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.table.save.request+json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
{
  "caslibName":"Public",
  "tableName" :"SAVED_AS_CONTACTS",
  "format": "csv",
  "replace": true
}
```


##### <a name='SaveaTabletoaDifferentCaslibwithaDifferentTableName'>Save a Table to a Different Caslib with a Different Table Name</a>
Here is an example of using a POST request to save a table to a different Caslib with a different name.

```
POST /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.table.save.request+json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
{
  "caslibName":"TmpLib",
  "tableName" :"SAVED_CONTACTS",
  "format": "sashdat",
  "replace": true
}
```


##### <a name='DeleteaTable'>Delete a Table</a>
Here is an example of deleting a table.

```
DELETE /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&quiet=false&removeAcs=false HTTP/1.1
Host: apihost.example.com
Authorization: Bearer YOURTOKEN
```


##### <a name='ListSources'>List Sources</a>
Here is an example of using a GET request to list sources.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/sources?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='ListaSingleSource'>List a Single Source</a>
Here is an example of using a GET request to list a single source.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/sources?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='DeleteaSource'>Delete a Source</a>
Here is an example of deleting a source.

```
DELETE /casManagement/servers/cas-shared-default/caslibs/Public/sources/Contacts.sashdat?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.source.table+json
Authorization: Bearer YOURTOKEN
```


##### <a name='ListColumns'>List Columns</a>
Here is an example of using a GET request to list columns.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='ListaSingleColumn'>List a Single Column</a>
Here is an example of using a GET request to list a single column.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/COMPANY?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.column+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetDistinctCountsforaTable'>Get Distinct Counts for a Table</a>
Here is an example of using a GET request to retrieve distinct counts for a table.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/distinctCount?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetSummaryStatisticsforaTable'>Get Summary Statistics for a Table</a>
Here is an example of using a GET request to retrieve summary statistics for a table.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/summaryStatistics?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GettheDistinctCountforaColumn'>Get the Distinct Count for a Column</a>
Here is an example of using a GET request to retrieve the distinct count for a column.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/COMPANY/distinctCount?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.column.distinct.count+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GettheDistinctValuesforaColumn'>Get the Distinct Values for a Column</a>
Here is an example of using a GET request to retrieve the distance values for a column.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/COMPANY/distinctValues?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GettheSummaryStatisticsforaColumn'>Get the Summary Statistics for a Column</a>
Here is an example of using a GET request to retrieve the summary statistics for a column.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/ID/summaryStatistics?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.column.summary.statistics+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GettheFrequencyforaColumn'>Get the Frequency for a Column</a>
Here is an example of using a GET request to retrieve the frequency for a column.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/STATE/frequency?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.column.frequency+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetPolicies'>Get Policies</a>
Here is an example of using a GET request to retrieve policies.

```
GET /casManagement/servers/cas-shared-default/policies
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetthePolicyforaPriorityLevel'>Get the Policy for a Priority Level</a>
Here is an example of using a GET request to retrieve the policy for a priority level.

```
GET /casManagement/servers/cas-shared-default/policies/cas-shared-default-priority-1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy.summary+json
Authorization: Bearer YOURTOKEN
```


##### <a name='CreatethePolicyforaPriorityLevel'>Create the Policy for a Priority Level</a>
Here is an example of creating the policy for a priority level.

```
POST /casManagement/servers/cas-shared-default/policies HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.server.policy+json
Body:
{
          "version": 1,
          "name": "cas-shared-default-priority-1",
          "type": "priorityLevels",
          "attributes": {
                   "cpu": 50,
                   "localTables": "500 GB",
                   "globalCasuser": "500 GB",
                   "globalCasuserHdfs": "500 GB"
          }
}
```


##### <a name='GetthePolicyforGlobalCaslibs'>Get the Policy for Global Caslibs</a>
Here is an example of using a GET request to retrieve the policy for global Caslibs.

```
GET /casManagement/servers/cas-shared-default/policies/globalCaslibs
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy+json
Authorization: Bearer YOURTOKEN
```


##### <a name='CreatethePolicyforGlobalCaslibs'>Create the Policy for Global Caslibs</a>
Here is an example of creating the policy for global Caslibs.

```
POST /casManagement/servers/cas-shared-default/policies
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.server.policy+json
{
          "version": 1,
          "name": "globalCaslibs",
          "type": "globalCaslibs",
          "attributes": {
                   "_ALL_": "400 GB",
                   "Public": "200 GB",
                   "HPS": "100 GB"
          }
}
```


##### <a name='GetthePolicyforPriorityAssignments'>Get the Policy for Priority Assignments</a>
Here is an example of using a GET request to retrieve the policy for priority assignments.

```
GET /casManagement/servers/cas-shared-default/policies/priorityAssignments HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy+json
Authorization: Bearer YOURTOKEN
```


##### <a name='CreatethePolicyforPriorityAssignments'>Create the Policy for Priority Assignments</a>
Here is an example of creating the policy for priority assignments.

```
POST /casManagement/servers/cas-shared-default/policies HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.server.policy+json
{
          "version": 1,
          "name": "PriorityAssignments",
          "type": "PriorityAssignments",
          "attributes": {
                   "userId": 1
          }
}
```


##### <a name='DeleteaPolicy'>Delete a Policy</a>
Here is an example of deleting a policy.

```
DELETE /casManagement/servers/cas-shared-default/policies/cas-shared-default-priority-1 HTTP/1.1
Host: apihost.example.com
Authorization: Bearer YOURTOKEN
```


##### <a name='GetDataConnectors'>Get Data Connectors</a>
Here is an example of using a GET request to retrieve data connectors.

```
GET /casManagement/servers/cas-shared-default/dataConnectors
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GetaSingleDataConnector'>Get a Single Data Connector</a>
Here is an example of using a GET request to retrieve a single data connector.

```
GET /casManagement/servers/cas-jeff-default/dataConnectors/esp
Host: apihost.example.com
Accept: application/vnd.sas.data.engine+json
Authorization: Bearer YOURTOKEN
```


##### <a name='GettheDefinitionofaSingleDataConnector'>Get the Definition of a Single Data Connector</a>
Here is an example of using a GET request to retrieve the definition of a single data connector.

```
GET /casManagement/servers/cas-jeff-default/dataConnectors/esp/definition
Host: apihost.example.com
Accept: application/json
Authorization: Bearer YOURTOKEN
```



version 3, last updated 22 NOV, 2019
