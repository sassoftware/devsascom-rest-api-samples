# CAS Management API
The CAS Management API provides the ability to manage and perform actions on
common resources as they relate to Cloud Analytic Services (CAS).

CAS Management provides the ability to manage servers, nodes, sessions, libraries, and tables in CAS,
as well as source tables available to load to CAS.

## HEAD Support
Note that HEAD is supported for every GET request documented in the API.
Simply change the HTTP verb from GET to HEAD, leaving other parameters the same.

## API Request Examples Grouped by Object Type
<details>
<summary>Servers</summary>

* [Get Servers](#GetServers)
* [Get Single Server](#GetSingleServer)
* [Determine if CAS server is running](#RunningServer)
* [Get metrics from CAS server](#GetMetrics)
</details> 

<details>
<summary>Sessions</summary>

* [Get sessions](#GetSessions)
* [Get single session](#GetSingleSession)
* [Create session](#CreateSession)
* [Create a new session with options](#CreateSessionWithOptions)
* [Create a new session in Korean local](#CreateSessionKoreanLocal)
* [Determine if session is running](#SessionRunning)
* [EndSession](#EndSession)
</details>

<details>
<summary>Nodes</summary>

* [List nodes](#ListNodes)
* [List single node](#ListSingleNode)
* [Add node](#AddNode)
* [Remove node](#RemoveNode)
</details>

<details>
<summary>Caslibs</summary>

* [Get caslibs](#GetCaslibs)
* [Get single caslib](#GetSingleCaslib)
* [Edit global caslib description and/or/ path](#EditGlobalCaslib)
* [Create PATH caslib](#CreatePATHcaslib)
* [Create DNFS caslib](#CreateDNFS caslib)
* [Create HDFS caslib](#CreateHDFScaslib)
* [Create Teradata caslib](#CreateTeradataCaslib)
* [Create Oracle caslib](#CreateOracleCaslib)
* [Create Greenplum caslib](#CreateGreenplumCaslib)
* [Create Postgres caslib](#CretePostgresCaslib)
* [Create LASR caslib](#CreateLASRCaslib)
* [Create Amazon S3 caslib](#CreateAmazonS3Caslib)
* [Create YouTube caslib](#CreateYouTubeCaslib)
* [Create Google Analytics caslib](#CreateGoogleAnalyticsCaslib)
* [Remove a caslib definition](#RemoveCaslibDefinition)
</details>

<details>
<summary>Tables</summary>

* [List up to 50 tables in a caslib](#List50Tables)
* [List only loaded tables in a caslib](#ListLoadedTables)
* [List single table](#ListSingleTable)
* [List single table with all detail groups included](#ListSingleTableDetailGroups)
* [Load a table](#LoadATable)
* [Load a table from a specific source file](#LoadTableSoureFile)
* [Load a table to a different output](#LoadTableDiffOutput)
* [Load a csv file with non-default options](#LoadCSVFile)
* [Load a subset of a table](#LoadTableSubset)
* [Unload a table](#UnloadTable)
* [Promote session table to global scope](#PromoteSessionTable)
* [Save a table, replacing original](#SaveTableReplace)
* [Save table as a different name, same format](#SaveTableDiffName)
* [Save table in sashdat format](#SaveTableSASHDAT)
* [Save table in csv format (export to csv)](#SaveTableExportCSV)
* [Save table as CSV with different name](#SaveTableCSVDiffName)
* [Save table to a different caslib with a different table name](#SaveTableDiffCaslibDiffName)
* [Delete table](#DeleteTable)
</details>

<details>
<summary>Sources</summary>

* [List sources](#ListSources)
* [List single source](#ListSingleSource)
* [Delete source](#DeleteSource)
</details> 

<details>
<summary>Columns</summary>

* [List columns](#ListColumns)
* [List single column](#ListSingleColumn)
* [Get table distinct counts](#GetTableDistinctCounts)
* [Get table summary statistics](#GetTableSummaryStats)
* [Get column distinct count](#GetColumnDistinctCount)
* [Get column distinct values](#GetColumnDistinctValues)
* [Get column summary statistics](#GetColumnSummaryStats)
* [Get column frequency](#GetColumnFreq)
</details>

<details>
<summary>Policies</summary>

* [Get Policies](#GetPolicies)
* [Get the Policy for a Priority Level](#GetPolicyPriorityLevel)
* [Create the Policy for a Priority Level](#CreatePolicyPriorityLevel)
* [Get the Policy for Global Caslibs](#GetPolicyGlobalCaslibs)
* [Create the Policy for Global Caslibs](#CreatePolicyGlobalCaslibs)
* [Get the Policy for Priority Assignments](#GetPolicyPriorityAssignments)
* [Create the Policy for Priority Assignments](#CreatePolicyPriorityAssignments)
* [Delete a Policy](#DeletePolicy)
</details>

#### Servers

##### <a name='GetServers'>Get Servers</a>

```
GET /casManagement/servers HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetSingleServer'>Get a Single Server</a>

```
GET /casManagement/servers/cas-shared-default HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server+json
Authorization: Bearer YOURTOKEN
```

##### <a name='RunningServer'>Determine Whether a CAS Server Is Running</a>

```
GET /casManagement/servers/cas-shared-default/state HTTP/1.1
Host: apihost.example.com
Accept: text/plain
Authorization: Bearer YOURTOKEN
```

##### <a name='GetMetrics'>Get Metrics from a CAS Server</a>

```
GET /casManagement/servers/cas-shared-default/metrics HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.metrics+json
Authorization: Bearer YOURTOKEN
```

#### Sessions

##### <a name='GetSessions'>Get Sessions</a>

```
GET /casManagement/servers/cas-shared-default/sessions HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetSingleSession'>Get a Single Session</a>

```
GET /casManagement/servers/cas-shared-default/sessions/b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.session.summary+json
Authorization: Bearer YOURTOKEN
```

##### <a name='CreateSession'>Create a New Session</a>

```
POST /casManagement/servers/cas-shared-default/sessions HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.session+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.session+json
```

##### <a name='CreateSessionWithOptions'>Create a New Session with Options</a>

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

##### <a name=CreateSessionKoreanLocal''>Create a New Session in Korean Locale</a>

```
POST /casManagement/servers/cas-shared-default/sessions?sessionId=9ed3a21a-736a-864f-a0e7-8070a959947f HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.session+json
Authorization: Bearer YOURTOKEN
Content-Type: application/vnd.sas.cas.session+json
Accept-Language: ko-kr
```

##### <a name='SessionRunning'>Determine Whether a Session Is Running</a>

```
GET /casManagement/servers/cas-shared-default/sessions/b3a9d3f9-1095-d848-85d4-02b19fc4e5cf/state HTTP/1.1
Host: apihost.example.com
Accept: text/plain
Authorization: Bearer YOURTOKEN
```

##### <a name='EndSession'>End a Session</a>

```
DELETE /casManagement/servers/cas-shared-default/sessions/b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Authorization: Bearer YOURTOKEN
```

#### Nodes

##### <a name='ListNodes'>List Nodes</a>

```
GET /casManagement/servers/cas-shared-default/nodes HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='ListSingleNode'>List single node</a>

```
GET /casManagement/servers/cas-shared-default/nodes/somenodehost.example.com HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.node+json
Authorization: Bearer YOURTOKEN
```

##### <a name='AddNode'>Add a node</a>

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

##### <a name='RemoveNode'>Remove a node</a>

```
DELETE /casManagement/servers/cas-shared-default/nodes/nodetodelete.example.com?superUserSessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/json
Authorization: Bearer YOURTOKEN
```

#### Caslibs

##### <a name=''>Get Caslib</a>

```
GET /casManagement/servers/cas-shared-default/caslibs HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetSingleCaslib'>Get a Single Caslib</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
```

##### <a name='EditGlobalCaslib'>Edit a Global Caslib Description or Path</a>

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

##### <a name='CreatePATHcaslib'>Create a Path-Based Caslib</a>

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

##### <a name='CreateDNFScaslib'>Create a DNFS Caslib</a>
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

##### <a name='CreateHDFScaslib'>Create an HDFS Caslib</a>
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

##### <a name='CreateTeradataCaslib'>Create a Teradata Caslib</a>
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

##### <a name='CreateOracleCaslib'>Create an Oracle Caslib</a>
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

##### <a name='CreateGreenplumCaslib'>Create a Greenplum Caslib</a>
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

##### <a name='CretePostgresCaslib'>Create a Postgres Caslib</a>
```
POST /casManagement/servers/cas-shared-default/caslibs?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/vnd.sas.cas.caslib+json
Accept: application/vnd.sas.cas.caslib+json
Authorization: Bearer YOURTOKEN
{
  "version": 1,
  "name": "PostgresLib",
  "description": "Postgres caslib",
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

##### <a name='CreateLASRCaslib'>Create a LASR Caslib</a>
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

##### <a name='CreateAmazonS3Caslib'>Create an Amazon S3 Caslib</a>
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

##### <a name='CreateYouTubeCaslib'>Create a YouTube Caslib</a>
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

##### <a name='Create Google Analytics caslib'>Create a Google Analytics Caslib</a>
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

##### <a name='RemoveCaslibDefinition'>Remove a Caslib Definition</a>

```
DELETE /casManagement/servers/cas-shared-default/caslibs/ora2?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Authorization: Bearer YOURTOKEN
```

#### Tables
Note that tables represented here do not represent exclusively a CAS tables or CAS source file/table.
 Tables in this context are a combined representation of a CAS table name and
 the source with which it is associated (whether the CAS table has been loaded or not).

##### <a name='List50Tables'>List up to 50 Tables in a Caslib</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables?sessixonId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&limit=50 HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```


##### <a name='ListLoadedTables'>List Only the Loaded Tables in a caslib</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables?sessixonId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&state=loaded HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='ListSingleTable'>List a Single Table</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Content-Type: application/json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
```

##### <a name='ListSingleTableDetailGroups'>List a Single Table with All Detail Groups Included</a>
This call may be less performant, but will gather more detail.

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&detailGroups=all HTTP/1.1
Host: apihost.example.com
Content-Type: application/json
Accept: application/vnd.sas.cas.table+json
Authorization: Bearer YOURTOKEN
```

##### <a name='LoadATable'>Load a Table</a>
This example is commonly referred to as a just-in-time or 'JIT' load because
the call is often made to ensure that a table is either already loaded or to
carry out a load of the table.

CAS Management will automatically select the source table or file to load using the
following default source table matching algorithm:

* In the case of a source *table*, the first source table name which differes only
  by case will by matched and loaded
* In the case of a source *file*, the same case-insensitive match will be made, but
  using the base name of the table (without the file extension).
* In the case of a source *file*, if multiple base names match with different extensions,
  the match is selected using the following order of precedence:
   sashdat, sas7bdat, csv

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessixonId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=loaded&scope=global&createRelationships=true HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
```

##### <a name='LoadTableSoureFile'>Load a Table from a Specific Source File</a>

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=loaded&scope=global HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
```

##### <a name='LoadTableDiffOutput'>Load a Table to a Different Output</a>

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

##### <a name='LoadCSVFile'>Load a CSV File with Non-Default Options</a>

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

##### <a name='LoadTableSubset'>Load a Subset of a Table</a>

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

##### <a name='UnloadTable'>Unload a Table</a>

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/state?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=unloaded HTTP/1.1
Host: apihost.example.com
Accept: application/json;text/plain
Authorization: Bearer YOURTOKEN
```

##### <a name='PromoteSessionTable'>Promote a Session Table to Global Scope</a>

```
PUT /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/scope?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&value=global HTTP/1.1
Host: apihost.example.com
Accept: text/plain
Authorization: Bearer YOURTOKEN
```

##### <a name='SaveTableReplace'>Save a Table, Replacing the Original</a>

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

##### <a name='SaveTableDiffName'>Save a Table in the Same Format with a Different Name</a>

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

##### <a name='SaveTableSASHDAT'>Save a Table in sashdat Format</a>

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

##### <a name='SaveTableExportCSV'>Save a Table in CSV Format</a>

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

##### <a name='SaveTableCSVDiffName'>Save table as CSV with different name</a>

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

##### <a name='SaveTableDiffCaslibDiffName'>Save a Table to a Different Caslib with a Different Table Name</a>

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

##### <a name='DeleteTable'>Delete a Table</a>

```
DELETE /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf&quiet=false&removeAcs=false HTTP/1.1
Host: apihost.example.com
Authorization: Bearer YOURTOKEN
```

#### Sources

##### <a name=''>List Sources</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/sources?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name=''>List a Single Source</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/sources?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name=''>Delete a Source</a>

```
DELETE /casManagement/servers/cas-shared-default/caslibs/Public/sources/Contacts.sashdat?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.source.table+json
Authorization: Bearer YOURTOKEN
```

#### Columns

##### <a name='ListColumns'>List Columns</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='ListSingleColumn'><a name=''>List a Single Column</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/COMPANY?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.column+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetColumnDistinctCount'>Get Distinct Counts for a Table</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/distinctCount?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetTableSummaryStats'>Get Table Summary Statistics for a Table</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/summaryStatistics?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetColumnDistinctCount'>Get the Distinct Count for a Column</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/COMPANY/distinctCount?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.column.distinct.count+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetColumnDistinctValues'>Get the Distinct Values for a Column</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/COMPANY/distinctValues?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetColumnSummaryStats'>Get the Summary Statistics for a Column</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/ID/summaryStatistics?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.column.summary.statistics+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetColumnFreq'>Get the Frequency for a Column</a>

```
GET /casManagement/servers/cas-shared-default/caslibs/Public/tables/CONTACTS/columns/STATE/frequency?sessionId=b3a9d3f9-1095-d848-85d4-02b19fc4e5cf HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.column.frequency+json
Authorization: Bearer YOURTOKEN
```

#### Policies

##### <a name='GetPolicies'>Get Policies</a>

```
GET /casManagement/servers/cas-shared-default/policies
Host: apihost.example.com
Accept: application/vnd.sas.collection+json
Authorization: Bearer YOURTOKEN
```

##### <a name='GetPolicyPriorityLevel'>Get the Policy for a Priority Level</a>

```
GET /casManagement/servers/cas-shared-default/policies/cas-shared-default-priority-1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy.summary+json
Authorization: Bearer YOURTOKEN
```

##### <a name='CreatePolicyPriorityLevel'>Create the Policy for a Priority Level</a>

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

##### <a name='GetPolicyGlobalCaslibs'>Get the Policy for Global Caslibs</a>

```
GET /casManagement/servers/cas-shared-default/policies/globalCaslibs
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy+json
Authorization: Bearer YOURTOKEN
```

##### <a name='CreatePolicyGlobalCaslibs'>Create the Policy for Global Caslibs</a>

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

##### <a name='GetPolicyPriorityAssignments'>Get the Policy for Priority Assignments</a>

```
GET /casManagement/servers/cas-shared-default/policies/priorityAssignments HTTP/1.1
Host: apihost.example.com
Accept: application/vnd.sas.cas.server.policy+json
Authorization: Bearer YOURTOKEN
```

##### <a name='CreatePolicyPriorityAssignments'>Create the Policy for Priority Assignments</a>

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

##### <a name='DeletePolicy'>Delete a Policy</a>

```
DELETE /casManagement/servers/cas-shared-default/policies/cas-shared-default-priority-1 HTTP/1.1
Host: apihost.example.com
Authorization: Bearer YOURTOKEN
```

version 3, last updated 19 Dec, 2018
