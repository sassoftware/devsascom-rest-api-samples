# Data Sources API

The Data Sources API works in concert with the Data Tables
and Row Sets APIs to navigate, reference, and retrieve data in the SAS
Viya ecosystem. The Data Sources API enables retrieval of data source metadata.
A *data source* represents a collection of data tables.
Examples of data sources are SAS libraries, CASLIBs, or a JDBC data schema.

Each data source is a RESTful resource with a URL that serves as the address of and unique ID of that data source.


## API Request Examples Grouped by Usage Type



<details>
<summary>General Usage</summary>

* [Retrieving providers](#RetrievingProviders)
* [Retrieving top-level data sources](#RetrievingTopLevelDataSources)
* [Retrieving child data sources](#RetrievingChildDataSources)
* [Retrieving tables](#RetrievingTables)
* [Session handling](#SessionHandling)
* [Query parameters](#QueryParameters)
* [Link relations](#LinkRelations)
</details>

<details>
<summary>Use Cases</summary>

* [Client provides a sessionId](#ClientProvidesSessionID)
* [Client does not specify a sessionId](#ClientDoesNotProvidesSessionID)
* [Client does not specify a sessionId and specifies preserveSession=true](#ClientSpecifiesPresserveSession)
</details> 

<details>
<summary>Data Source Definitions Usage</summary>

* [Retrieving source definitions](#RetrievingSourceDefinitions)
* [Creating a data source definition](#CreatingDataSourceDefinition)
</details>


##### <a name='RetrievingProviders'>Retrieving Providers</a>
Here is an example of performing a GET request using the URI `/dataSources/providers` to return a collection of all the
[application/vnd.sas.data.provider resources](#application-vnd.sas.data.provider) currently available.

Note: The data sources service is used to retrieve all available CAS servers and their respective caslibs.

```
#Response application/vnd.sas.collection+json
```

````
{
  "name": "providers",
  "accept": "application/vnd.sas.data.provider.summary application/vnd.sas.data.provider",
  "start": 0,
  "count": 1,
  "items": [
    {
      "id": "cas",
      "type": "dataSources",
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/dataSources/providers/cas",
          "uri": "/dataSources/providers/cas",
          "type": "application/vnd.sas.data.provider"
        },
        {
          "method": "GET",
          "rel": "alternate",
          "href": "/dataSources/providers/cas",
          "uri": "/dataSources/providers/cas",
          "type": "application/vnd.sas.data.provider.summary"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/dataSources/providers",
          "uri": "/dataSources/providers",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.provider.summary"
        },
        {
          "method": "GET",
          "rel": "dataSources",
          "href": "/dataSources/providers/cas/sources",
          "uri": "/dataSources/providers/cas/sources",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        }
      ],
      "version": 1
    }
  ],
  "limit": 10,
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/dataSources/providers",
      "uri": "/dataSources/providers",
      "type": "application/vnd.sas.collection"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/dataSources/providers?start=0&limit=10",
      "uri": "/dataSources/providers?start=0&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.provider.summary"
    }
  ],
  "version": 2
}
````


##### <a name='RetrievingTopLevelDataSources'>Retrieving Top-Level Data Sources</a>
Here is an example of following the `dataSources` link of the
[`application/vnd.sas.data.provider`](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.provider) with the ID `cas` to perform a GET request to the URL `/dataSources/providers/cas/sources.`

* These sources are the top or root level data sources. In the case of the CAS provider, the sources are CAS servers.

```
#Response application/vnd.sas.collection+json
```

````
{
  "name": "sources",
  "accept": "application/vnd.sas.data.source",
  "count": 1,
  "items": [
    {
      "id": "cas",
      "name": "cas",
      "type": "casServer",
      "providerId": "cas",
      "description": "controller",
      "hasTables": true,
      "attributes": {
        "port": 8850,
        "host": "rdcgrd001.unx.sas.com"
      },
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/dataSources/providers/cas/sources/cas",
          "uri": "/dataSources/providers/cas/sources/cas",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "status",
          "href": "/casManagement/servers/cas/status",
          "uri": "/casManagement/servers/cas/status",
          "responseType": "application/json"
        },
        {
          "method": "GET",
          "rel": "tables",
          "href": "/dataTables/dataSources/cas~fs~cas/tables",
          "uri": "/dataTables/dataSources/cas~fs~cas/tables",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.table"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/dataSources/providers/cas/sources",
          "uri": "/dataSources/providers/cas/sources",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "children",
          "href": "/dataSources/providers/cas/sources/cas/children",
          "uri": "/dataSources/providers/cas/sources/cas/children",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        }
      ]
    }
  ],
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/dataSources/providers/cas/sources",
      "uri": "/dataSources/providers/cas/sources",
      "type": "application/vnd.sas.collection"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/dataSources/providers/cas/sources?start=0&limit=10",
      "uri": "/dataSources/providers/cas/sources?start=0&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.source"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/dataSources/providers/cas",
      "uri": "/dataSources/providers/cas",
      "type": "application/vnd.sas.data.provider"
    }
  ],
  "version": 2
}
````


##### <a name='RetrievingChildDataSources'>Retrieving Child Data Sources</a>
Here is an example of using a `children` link to drill down the hierarchy when a data source has child data sources.

* In the case of CAS, this returns the respective CAS server's caslibs as [`application/vnd.sas.data.source resources`](https://developer.sas.com/apis/rest/DataManagement/#resource-reference-2).

```
#Response application/vnd.sas.collection+json
```

````
{
  "name": "sources",
  "accept": "application/vnd.sas.data.source",
  "items": [
    {
      "id": "CASTestTmp",
      "name": "CASTestTmp",
      "type": "caslib",
      "providerId": "cas",
      "description": "castest's test files",
      "hasTables": true,
      "attributes": {
        "active": false,
        "personal": false,
        "subDirs": true
      },
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
          "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/dataSources/providers/cas/sources/cas/children",
          "uri": "/dataSources/providers/cas/sources/cas/children",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "parent",
          "href": "/dataSources/providers/cas/sources/cas",
          "uri": "/dataSources/providers/cas/sources/cas",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "tables",
          "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
          "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.table"
        }
      ]
    },
    {
      "id": "CASUSER(etlguest)",
      "name": "CASUSER(etlguest)",
      "type": "caslib",
      "providerId": "cas",
      "description": "Personal File System Caslib",
      "hasTables": true,
      "attributes": {
        "active": false,
        "personal": true,
        "subDirs": true
      },
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/dataSources/providers/cas/sources/cas~fs~CASUSER(etlguest)",
          "uri": "/dataSources/providers/cas/sources/cas~fs~CASUSER(etlguest)",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/dataSources/providers/cas/sources/cas/children",
          "uri": "/dataSources/providers/cas/sources/cas/children",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "parent",
          "href": "/dataSources/providers/cas/sources/cas",
          "uri": "/dataSources/providers/cas/sources/cas",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "tables",
          "href": "/dataTables/dataSources/cas~fs~cas~fs~CASUSER(etlguest)/tables",
          "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASUSER(etlguest)/tables",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.table"
        }
      ]
    },
    {
      "id": "CASUSERHDFS(etlguest)",
      "name": "CASUSERHDFS(etlguest)",
      "type": "caslib",
      "providerId": "cas",
      "description": "Personal HDFS Caslib",
      "hasTables": true,
      "attributes": {
        "active": true,
        "personal": true,
        "subDirs": true
      },
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/dataSources/providers/cas/sources/cas~fs~CASUSERHDFS(etlguest)",
          "uri": "/dataSources/providers/cas/sources/cas~fs~CASUSERHDFS(etlguest)",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/dataSources/providers/cas/sources/cas/children",
          "uri": "/dataSources/providers/cas/sources/cas/children",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "parent",
          "href": "/dataSources/providers/cas/sources/cas",
          "uri": "/dataSources/providers/cas/sources/cas",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "tables",
          "href": "/dataTables/dataSources/cas~fs~cas~fs~CASUSERHDFS(etlguest)/tables",
          "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASUSERHDFS(etlguest)/tables",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.table"
        }
      ]
    },
    {
      "id": "EngTest",
      "name": "EngTest",
      "type": "caslib",
      "providerId": "cas",
      "description": "engtest's HDAT files",
      "hasTables": true,
      "attributes": {
        "active": false,
        "personal": false,
        "subDirs": true
      },
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/dataSources/providers/cas/sources/cas~fs~EngTest",
          "uri": "/dataSources/providers/cas/sources/cas~fs~EngTest",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/dataSources/providers/cas/sources/cas/children",
          "uri": "/dataSources/providers/cas/sources/cas/children",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "parent",
          "href": "/dataSources/providers/cas/sources/cas",
          "uri": "/dataSources/providers/cas/sources/cas",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "tables",
          "href": "/dataTables/dataSources/cas~fs~cas~fs~EngTest/tables",
          "uri": "/dataTables/dataSources/cas~fs~cas~fs~EngTest/tables",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.table"
        }
      ]
    },
    {
      "id": "Formats",
      "name": "Formats",
      "type": "caslib",
      "providerId": "cas",
      "description": "Format Caslib",
      "hasTables": true,
      "attributes": {
        "active": false,
        "personal": false,
        "subDirs": true
      },
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/dataSources/providers/cas/sources/cas~fs~Formats",
          "uri": "/dataSources/providers/cas/sources/cas~fs~Formats",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/dataSources/providers/cas/sources/cas/children",
          "uri": "/dataSources/providers/cas/sources/cas/children",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "parent",
          "href": "/dataSources/providers/cas/sources/cas",
          "uri": "/dataSources/providers/cas/sources/cas",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "tables",
          "href": "/dataTables/dataSources/cas~fs~cas~fs~Formats/tables",
          "uri": "/dataTables/dataSources/cas~fs~cas~fs~Formats/tables",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.table"
        }
      ]
    },
    {
      "id": "HPS",
      "name": "HPS",
      "type": "caslib",
      "providerId": "cas",
      "description": "HDAT files on /hps",
      "hasTables": true,
      "attributes": {
        "active": false,
        "personal": false,
        "subDirs": true
      },
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/dataSources/providers/cas/sources/cas~fs~HPS",
          "uri": "/dataSources/providers/cas/sources/cas~fs~HPS",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/dataSources/providers/cas/sources/cas/children",
          "uri": "/dataSources/providers/cas/sources/cas/children",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "parent",
          "href": "/dataSources/providers/cas/sources/cas",
          "uri": "/dataSources/providers/cas/sources/cas",
          "type": "application/vnd.sas.data.source"
        },
        {
          "method": "GET",
          "rel": "tables",
          "href": "/dataTables/dataSources/cas~fs~cas~fs~HPS/tables",
          "uri": "/dataTables/dataSources/cas~fs~cas~fs~HPS/tables",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.data.table"
        }
      ]
    }
  ],
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/dataSources/providers/cas/sources/cas/children",
      "uri": "/dataSources/providers/cas/sources/cas/children",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.source"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/dataSources/providers/cas/sources/cas/children?start=0&limit=10",
      "uri": "/dataSources/providers/cas/sources/cas/children?start=0&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.source"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/dataSources/providers/cas/sources/cas",
      "uri": "/dataSources/providers/cas/sources/cas",
      "type": "application/vnd.sas.data.source"
    }
  ],
  "version": 2
}
````


##### <a name='RetrievingTables'>Retrieving Tables</a>
Here is an example of using a GET request on the [`application/vnd.sas.data.source`](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.source) to return a resource.

* From a caslib data source, the `tables` link is provided to give the user the ability to list all of the available tables for that caslib. 
* You can use the link to retrieve a collection of [`application/vnd.sas.data.table`](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.table) 
resources from the [Data Tables API](https://developer.sas.com/apis/rest/DataManagement/#data-tables).

````
 {
      "method": "GET",
      "rel": "tables",
      "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
      "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.data.table"
 }
 ````


##### <a name='SessionHandling'>Session Handling</a>
Certain Data Sources service providers support session-based data retrieval. To determine whether this is supported by any particular
provider, query `/dataTables/providers/{providerId}` to retrieve the [`application/vnd.sas.data.provider`](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.provider)
media type. Then check the `usesSessions` member.


###### <a name='QueryParameters'>Query Parameters</a>
If sessions are supported by the provider, the following query parameters are supported for calls to `/dataSources/providers/{providerId}/sources/{sourceId}` 
and `/dataSources/providers/{providerId}/sources/{sourceId}/children`:

| Name               | Type      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
|--------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `?sessionId`       | `string`  | The unique identifier of the session used to access the data service provider's backing service. When this is not specified, the data service provider creates a temporary session and then destroys it after the request is complete. If this is specified, the sessionId query parameter is added to the respective URIs for all returned links, except the `self` link.  Also, they contain an additional `session` link to the [application/vnd.sas.data.session](http://localhost/reference/schema/application/vnd.sas.data.session/v1/dataSession.json) resource that corresponds to the provided sessionId. |
| `?preserveSession` | `Boolean` | This has effect only when the `?sessionId` query parameter is not specified. If this is set to true, no `?sessionId` is provided and the session created by the data service provider is not destroyed. The sessionId query parameter is added to the respective URIs for all returned links, except the `self` link. Also, they contain an additional `session` link to the application/vnd.sas.data.session resource that corresponds to the provided `?sessionId`. If set to false or not specified, the session is destroyed after the request is complete. Defaults to false.                                                                          |


###### <a name='LinkRelations'>Link Relations</a>
       
**Session Link**

The `session` link is added anytime the `sessionId` is provided by the user or the `preserveSession` query parameter is set to true. 
This `session` link uses the [application/vnd.sas.data.session](https://developer.sas.com/apis/rest/DataManagement/#application-vnd.sas.data.session) media type.
The `href` is `/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}`.
This is provided so that the client can obtain further links to destroy the session if they want to do so.

**sessionScoped Link**

The `sessionScoped` link is added anytime the `sessionId` is provided by the user or the `preserveSession` query parameter is set to true. 
This link gives the user access to a session-scoped version of the `self` link. Users must understand that they are working with a session that is temporary by its nature.
The `self`link is the resource identifier that the user persists. The `sessionScoped` link can be used for immediate access and work being done with the resource by the client.


###### <a name='ClientProvidesSessionID'>Client Provides a sessionId</a>
Here is an example of a user passing a known session identifier as the query parameter `sessionId`. 

* This session identifier is used when establishing a connection to the data service provider's backing service (such as CAS).
* If the `sessionId` does not exist, a 404 is returned. 
* The service returns a `session` link that points to the appropriate session in the path `/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}`, where `sourceId` corresponds to the level of the data hierarchy that the session is associated with (such as the first-level CAS server for CAS).
* The `sessionId` is appended as a query parameter to all links except the `self` link, and the `sessionScoped` link is appended to the respective resource.

```
# HTTP GET request to get a table passing their session identifier as the query parameter sessionId
GET /dataSources/providers/cas/sources/casServer~fs~CASTestTmp?sessionId=ce98bfa5-29af-c543-8954-1e645282727c
#Response application/vnd.sas.data.source+json
```

#Response application/vnd.sas.data.source+json

 ````
 {
   "id": "CASTestTmp",
   "name": "CASTestTmp",
   "type": "caslib",
   "providerId": "cas",
   "description": "castest's test files",
   "hasTables": true,
   "attributes": {
     "active": false,
     "personal": false,
     "subDirs": true
   },
   "version": 1,
   "links": [
     {
       "method": "GET",
       "rel": "self",
       "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
       "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
       "type": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "sessionScoped",
       "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp?sessionId=ce98bfa5-29af-c543-8954-1e645282727c",
       "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp?sessionId=ce98bfa5-29af-c543-8954-1e645282727c",
       "type": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "session",
       "href": "/dataSources/providers/cas/sources/cas/sessions/ce98bfa5-29af-c543-8954-1e645282727c",
       "uri": "/dataSources/providers/cas/sources/cas/sessions/ce98bfa5-29af-c543-8954-1e645282727c",
       "type": "application/vnd.sas.data.session"
     },
     {
       "method": "GET",
       "rel": "up",
       "href": "/dataSources/providers/cas/sources/cas/children?sessionId=ce98bfa5-29af-c543-8954-1e645282727c",
       "uri": "/dataSources/providers/cas/sources/cas/children?sessionId=ce98bfa5-29af-c543-8954-1e645282727c",
       "type": "application/vnd.sas.collection",
       "itemType": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "parent",
       "href": "/dataSources/providers/cas/sources/cas?sessionId=ce98bfa5-29af-c543-8954-1e645282727c",
       "uri": "/dataSources/providers/cas/sources/cas?sessionId=ce98bfa5-29af-c543-8954-1e645282727c",
       "type": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "tables",
       "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables?sessionId=ce98bfa5-29af-c543-8954-1e645282727c",
       "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables?sessionId=ce98bfa5-29af-c543-8954-1e645282727c",
       "type": "application/vnd.sas.collection",
       "itemType": "application/vnd.sas.data.table"
     }
   ]
 }
 ````


###### <a name='ClientDoesNotProvidesSessionID'>Client Does Not Specify a sessionId</a>
Here is an example of the data provider service creating a temporary session to request the data from the backing service and then destroy that session upon completion of the request. 
This occurs when a user does not provide a session identifier to a data source that uses sessions.

```
# HTTP GET request to get a table that does not specify a sessionId
GET /dataSources/providers/cas/sources/casServer~fs~CASTestTmp
#Response application/vnd.sas.data.source+json
```

#Response application/vnd.sas.data.source+json

 ````
 {
   "id": "CASTestTmp",
   "name": "CASTestTmp",
   "type": "caslib",
   "providerId": "cas",
   "description": "castest's test files",
   "hasTables": true,
   "attributes": {
     "active": false,
     "personal": false,
     "subDirs": true
   },
   "version": 1,
   "links": [
     {
       "method": "GET",
       "rel": "self",
       "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
       "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
       "type": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "up",
       "href": "/dataSources/providers/cas/sources/cas/children",
       "uri": "/dataSources/providers/cas/sources/cas/children",
       "type": "application/vnd.sas.collection",
       "itemType": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "parent",
       "href": "/dataSources/providers/cas/sources/cas",
       "uri": "/dataSources/providers/cas/sources/cas",
       "type": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "tables",
       "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
       "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables",
       "type": "application/vnd.sas.collection",
       "itemType": "application/vnd.sas.data.table"
     }
   ]
 }
 ````


###### <a name='ClientSpecifiesPresserveSession'>Client Does Not Specify a sessionId and Specifies preserveSession=true</a>
Here is an example of the sessionId being placed on the returned links when the user sets the `preserveSession` query parameter to true, so the temporary session is preserved (not destroyed).

* In the example, 756b212c-56b1-8848-ad52-f86fcb06301f is the session identifier for a temporary session that is preserved.
* The service returns a `session` link that points to the appropriate session in the path `/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}`, where `sourceId` corresponds to the level of the data hierarchy that the session is associated with (such as the first-level CAS server for CAS).
* The `sessionId` is appended as a query parameter to all links except the `self` link, and the `sessionScoped` link is appended to the respective resource.

Note: The data provider service creates a temporary session to request the data from the backing service and then destroys that session upon completion of the request. This occurs when a user does not provide a session identifier to a data source that uses sessions. 

```
# HTTP GET request to get a table with preserveSession set to true
GET /dataSources/providers/cas/sources/casServer~fs~CASTestTmp?preserveSession=true
#Response application/vnd.sas.data.source+json
```

````
 {
   "id": "CASTestTmp",
   "name": "CASTestTmp",
   "type": "caslib",
   "providerId": "cas",
   "description": "castest's test files",
   "hasTables": true,
   "attributes": {
     "active": false,
     "personal": false,
     "subDirs": true
   },
   "version": 1,
   "links": [
     {
       "method": "GET",
       "rel": "self",
       "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
       "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp",
       "type": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "sessionScoped",
       "href": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp?sessionId=756b212c-56b1-8848-ad52-f86fcb06301f",
       "uri": "/dataSources/providers/cas/sources/cas~fs~CASTestTmp?sessionId=756b212c-56b1-8848-ad52-f86fcb06301f",
       "type": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "session",
       "href": "/dataSources/providers/cas/sources/cas/sessions/756b212c-56b1-8848-ad52-f86fcb06301f",
       "uri": "/dataSources/providers/cas/sources/cas/sessions/756b212c-56b1-8848-ad52-f86fcb06301f",
       "type": "application/vnd.sas.data.session"
     },
     {
       "method": "GET",
       "rel": "up",
       "href": "/dataSources/providers/cas/sources/cas/children?sessionId=756b212c-56b1-8848-ad52-f86fcb06301f",
       "uri": "/dataSources/providers/cas/sources/cas/children?sessionId=756b212c-56b1-8848-ad52-f86fcb06301f",
       "type": "application/vnd.sas.collection",
       "itemType": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "parent",
       "href": "/dataSources/providers/cas/sources/cas?sessionId=756b212c-56b1-8848-ad52-f86fcb06301f",
       "uri": "/dataSources/providers/cas/sources/cas?sessionId=756b212c-56b1-8848-ad52-f86fcb06301f",
       "type": "application/vnd.sas.data.source"
     },
     {
       "method": "GET",
       "rel": "tables",
       "href": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables?sessionId=756b212c-56b1-8848-ad52-f86fcb06301f",
       "uri": "/dataTables/dataSources/cas~fs~cas~fs~CASTestTmp/tables?sessionId=756b212c-56b1-8848-ad52-f86fcb06301f",
       "type": "application/vnd.sas.collection",
       "itemType": "application/vnd.sas.data.table"
     }
   ]
 }
 ````


##### <a name='RetrievingSourceDefinitions'>Retrieving Source Definitions</a>
Here is an example of following the `sourceDefinitions` link from the provider to get a collection of data source definitions.
* In the example, the sourceDefinitions link is from the application/vnd.sas.data.provider.

Note: Data source definitions were added in version 2 of this API to allow users to store metadata about a data source that might not be discoverable, but would still need to be referenced. 
For example, you might need to store metadata for connecting to a libref from your SAS code to use the Compute provider. 
In the examples below, we use the Compute provider.

````
  {
       "method": "GET",
       "rel": "sourceDefinitions",
       "href": "/dataSources/providers/Compute/sourceDefinitions",
       "uri": "/dataSources/providers/Compute/sourceDefinitions",
       "type": "application/vnd.sas.collection",
       "itemType": "application/vnd.sas.data.source.definition"
  }
````


##### <a name='CreatingDataSourceDefinition'>Creating a Data Source Definition</a>
Here is an example of using the `createSourceDefinition` link to create a source definition.

* In the example, the sourceDefinitions link is from the application/vnd.sas.data.provider.

````
  {
       "method": "POST",
       "rel": "createSourceDefinition",
       "href": "/dataSources/providers/Compute/sourceDefinitions",
       "uri": "/dataSources/providers/Compute/sourceDefinitions",
       "type": "application/vnd.sas.data.source.definition"
  }
 ````



version 3, last updated 13 OCT, 2020


