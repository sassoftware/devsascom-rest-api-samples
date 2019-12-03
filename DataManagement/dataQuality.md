# Data Quality API
The Data Quality API enables clients to reference information contained in a Quality Knowledge Base (QKB), such as:

* locales
* functions
* definitions
* tokens

Clients use the API to determine which operations are available for a given QKB. Other facilities, such as the DATA Step 1 CAS action, then perform  transformations. Examples of SAS applications that use the Data Quality API include SAS Visual Data Builder and SAS Data Preparation.

#### Session Management
For operations within an execution context, endpoints accept an optional query parameter named 'sessionId'. Providing a session ID to these endpoints can improve performance dramatically.
If a session ID is not provided, the Data Quality API attempts to create a session. When processing is complete, the API attempts to destroy the session.
If a session ID is provided, the client is responsible for destroying the session after the completion of processing. Links provided by the Data Quality API propagate the session ID, with the exception of the self link.

#### Collection Behavior
Methods in the Data Quality API that operate on a collection support the following features:

* Pagination - The default page limit is set to 10 for all collections. This limit can be modified by specifying the ?limit query parameter when applicable.
* Filtering - Filtering of all collection resources is supported.
Filter support consists of {and, or, not, in, isNull, eq,ne,lt,le,gt,ge,endsWith,startsWith,contains}. String operations such as endsWith and contains use the string representation of the underlying field; all other operations use the native data type. Null values fail for every filter except for isNull. Use the ?filter query parameter to express filter criteria.
Basic selection is not supported.
* Sorting- Sorting of all collection resources is supported on a single field. All endpoints default to a name:ascending:tertiary criteria.


#### Collection URIs


The following URIs return collections:

|Collection|
|---|
|/qkbs|
|/environments|
|/environments/{environmentName}/contexts/|
|/environments/{environmentName}/contexts/{contextName}/qkbs|
|/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales|
|/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions|
|/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions/{functionName}/definitions|
|/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions/{functionName}/definitions/{definitionName}/tokens|


### Data Quality Examples


* [Data Quality Root](#example-get-root)
* [Retrieving Supported Environments](#example-get-environments)
* [Retrieving Contexts](#example-get-contexts)
* [Retrieving a QKB](#example-get-qkbs)
* [Retrieving Locales](#example-get-locales)
* [Retrieving Functions](#example-get-functions)
* [Retrieving Definitions](#example-get-definitions)
* [Retrieving Tokens](#example-get-tokens)
* [Using a Client Session](#using-client-session)

The examples below show the general usage of Data Quality endpoints.

#### <a name='example-get-root'>Getting Data Quality Root</a>

GET request on root URI /dataQuality returns the root API links.

**Request**
```
  GET http://www.example.com/dataQuality/
  Headers:
  * Accept: application/vnd.sas.api+json  
```

**Response**
````
Headers:
 * Content-Type: application/vnd.sas.api+json
Body:
{
    "version": 1,
    "links": [
        {
            "method": "GET",
            "rel": "environments",
            "href": "/dataQuality/environments",
            "uri": "/dataQuality/environments",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.data.quality.environment"
        },
        {
            "method": "GET",
            "rel": "qkbs",
            "href": "/dataQuality/qkbs",
            "uri": "/dataQuality/qkbs",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.data.quality.qkb"
        }
    ]
}
````

#### <a name='example-get-environments'>Retrieving Supported Environments</a>

Performing a GET request using URI /dataQuality/environments returns a collection of all [`application/vnd.sas.data.quality.environment`](#application-vnd.sas.data.quality.environment) resources currently available.

**Request**
```
  GET http://www.example.com/dataQuality/environments
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.environment+json
```

**Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
    "name": "environments",
    "accept": "application/vnd.sas.data.quality.environment",
    "items": [
        {
            "version": 1,
            "name": "CAS",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/CAS",
                    "uri": "/dataQuality/environments/CAS",
                    "type": "application/vnd.sas.data.quality.environment"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments",
                    "uri": "/dataQuality/environments",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.environment"
                },
                {
                    "method": "GET",
                    "rel": "contexts",
                    "href": "/dataQuality/environments/CAS/contexts",
                    "uri": "/dataQuality/environments/CAS/contexts",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.context"
                }
            ]
        },
        {
            "version": 1,
            "name": "compute",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/compute",
                    "uri": "/dataQuality/environments/compute",
                    "type": "application/vnd.sas.data.quality.environment"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments",
                    "uri": "/dataQuality/environments",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.environment"
                },
                {
                    "method": "GET",
                    "rel": "contexts",
                    "href": "/dataQuality/environments/compute/contexts",
                    "uri": "/dataQuality/environments/compute/contexts",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.context"
                }
            ]
        }
    ],
    "links": [
            {
                "method": "GET",
                "rel": "collection",
                "href": "/dataQuality/environments",
                "uri": "/dataQuality/environments",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.environment"
            },
            {
                "method": "GET",
                "rel": "self",
                "href": "/dataQuality/environments?start=0&limit=2&sortBy=name",
                "uri": "/dataQuality/environments?start=0&limit=2&sortBy=name",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.environment"
            },
            {
                "method": "GET",
                "rel": "up",
                "href": "/dataQuality/",
                "uri": "/dataQuality/",
                "type": "application/vnd.sas.api"
            }
        ],
    "version": 2
}
````

#### <a name='example-get-contexts'>Retrieving Contexts</a>

The list of available contexts for a particular environment can be retrieved using GET request against contexts URI.
Contexts URI for CAS environments: /dataQuality/environments/CAS/contexts
Contexts URI for compute environments: /dataQuality/environments/compute/contexts

**CAS Request**
```
  GET http://www.example.com/dataQuality/environments/CAS/contexts
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.context+json
```

**CAS Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
    "name": "contexts",
    "accept": "application/vnd.sas.data.quality.context",
    "items": [
        {
            "version": 1,
            "name": "cas",
            "type": "CAS",
            "description": "controller",
            "host": "rdcgrd001.unx.sas.com",
            "state": "running",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/CAS/contexts/cas",
                    "uri": "/dataQuality/environments/CAS/contexts/cas",
                    "type": "application/vnd.sas.data.quality.context"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/CAS/contexts",
                    "uri": "/dataQuality/environments/CAS/contexts",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.context"
                },
                {
                    "method": "GET",
                    "rel": "qkbs",
                    "href": "/dataQuality/environments/CAS/contexts/cas/qkbs",
                    "uri": "/dataQuality/environments/CAS/contexts/cas/qkbs",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.qkb"
                }
            ]
        }
    ],
    "links": [
            {
                "method": "GET",
                "rel": "collection",
                "href": "/dataQuality/environments/CAS/contexts",
                "uri": "/dataQuality/environments/CAS/contexts",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.context"
            },
            {
                "method": "GET",
                "rel": "self",
                "href": "/dataQuality/environments/CAS/contexts?start=0&limit=10&sortBy=name",
                "uri": "/dataQuality/environments/CAS/contexts?start=0&limit=10&sortBy=name",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.context"
            },
            {
                "method": "GET",
                "rel": "up",
                "href": "/dataQuality/environments/CAS/",
                "uri": "/dataQuality/environments/CAS/",
                "type": "application/vnd.sas.collection"
            }
        ],
    "version": 2
}
````

**Compute Request**
```
  GET http://www.example.com/dataQuality/environments/compute/contexts
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.context+json
```

**Compute Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
    "name": "contexts",
    "accept": "application/vnd.sas.data.quality.context",
    "items": [                  
        {
            "version": 1,
            "name": "62f8b825-bdf1-4cb5-a1ad-7355941e3046",
            "type": "compute",
            "description": "SAS Data Explorer compute context : Compute context to be used by my SAS Data Explorer",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046",
                    "uri": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046",
                    "type": "application/vnd.sas.data.quality.context"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/compute/contexts",
                    "uri": "/dataQuality/environments/compute/contexts",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.context"
                },
                {
                    "method": "GET",
                    "rel": "qkbs",
                    "href": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs",
                    "uri": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.qkb"
                }
            ]
        }
    ],
    "links": [
            {
                "method": "GET",
                "rel": "collection",
                "href": "/dataQuality/environments/compute/contexts",
                "uri": "/dataQuality/environments/compute/contexts",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.context"
            },
            {
                "method": "GET",
                "rel": "self",
                "href": "/dataQuality/environments/compute/contexts?start=0&limit=10&sortBy=name",
                "uri": "/dataQuality/environments/compute/contexts?start=0&limit=10&sortBy=name",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.context"
            },
            {
                "method": "GET",
                "rel": "up",
                "href": "/dataQuality/environments/compute/",
                "uri": "/dataQuality/environments/compute/",
                "type": "application/vnd.sas.collection"
            }
        ],
    "version": 2
}
````

#### <a name='example-get-qkbs'>Retrieving a QKB</a>

The list of available QKBs for a particular context can be retrieved using GET request against QKBs URI.
QKBs URI for CAS environments: /dataQuality/environments/CAS/contexts/{casContext}/qkbs
QKBs URI for compute environments: /dataQuality/environments/compute/contexts/{computeContext}/qkbs

**CAS Request**
```
  GET http://www.example.com/dataQuality/environments/CAS/contexts/casqkb/qkbs
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.qkb+json
```

**CAS Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
    "name": "qkbs",
    "accept": "application/vnd.sas.data.quality.qkb",
    "items": [
        {
            "version": 1,
            "name": "QKB_CI29ALL",
            "product": "CI",
            "productVersion": "v29",
            "isDefault": true,
            "creationTimeStamp": "2019-04-15T11:37:59.000Z",
            "context": "casqkb",
            "environment": "CAS",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL",
                    "type": "application/vnd.sas.data.quality.qkb"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.qkb"
                },
                {
                    "method": "GET",
                    "rel": "locales",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.locale"
                }
            ]
        },
     "links": [
             {
                 "method": "GET",
                 "rel": "collection",
                 "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs",
                 "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs",
                 "type": "application/vnd.sas.collection",
                 "itemType": "application/vnd.sas.data.quality.qkb"
             },
             {
                 "method": "GET",
                 "rel": "self",
                 "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs?start=0&limit=10&sortBy=name",
                 "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs?start=0&limit=10&sortBy=name",
                 "type": "application/vnd.sas.collection",
                 "itemType": "application/vnd.sas.data.quality.qkb"
             },
             {
                 "method": "GET",
                 "rel": "up",
                 "href": "/dataQuality/environments/CAS/contexts/casqkb/",
                 "uri": "/dataQuality/environments/CAS/contexts/casqkb/",
                 "type": "application/vnd.sas.data.quality.context"
             }
         ],   
    "version": 2
}
````

**Compute Request**
```
  GET http://www.example.com/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.qkb+json
```

**Compute Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{
    "name": "qkbs",
    "accept": "application/vnd.sas.data.quality.qkb",
    "items": [
        {
            "version": 1,
            "name": "31",
            "productVersion": "v31",
            "isDefault": true,
            "context": "62f8b825-bdf1-4cb5-a1ad-7355941e3046",
            "environment": "compute",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs/31",
                    "uri": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs/31",
                    "type": "application/vnd.sas.data.quality.qkb"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs",
                    "uri": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.qkb"
                },
                {
                    "method": "GET",
                    "rel": "locales",
                    "href": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs/31/locales",
                    "uri": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs/31/locales",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.locale"
                }
            ]
        }
    ],
    "links": [
            {
                "method": "GET",
                "rel": "collection",
                "href": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs",
                "uri": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.qkb"
            },
            {
                "method": "GET",
                "rel": "self",
                "href": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs?start=0&limit=10&sortBy=name",
                "uri": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/qkbs?start=0&limit=10&sortBy=name",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.qkb"
            },
            {
                "method": "GET",
                "rel": "up",
                "href": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/",
                "uri": "/dataQuality/environments/compute/contexts/62f8b825-bdf1-4cb5-a1ad-7355941e3046/",
                "type": "application/vnd.sas.data.quality.context"
            }
        ],
    "version": 2
}
````

#### <a name='example-get-locales'>Retrieving Locales</a>

The list of available locales for a particular QKB can be retrieved using GET request against locales URI.
Locales URI for CAS environments: /dataQuality/environments/CAS/contexts/{casContext}/qkbs/{qkb}/locales
Locales URI for compute environments: /dataQuality/environments/compute/contexts/{computeContext}/qkbs/{qkb}/locales

**CAS Request**
```
  GET http://www.example.com/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.locale+json
```

**CAS Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{    
    "name": "locales",
    "accept": "application/vnd.sas.data.quality.locale",
    "items": [
        {
            "version": 1,
            "name": "ENUSA",
            "description": "English (United States)",
            "isDefault": true,
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA",
                    "type": "application/vnd.sas.data.quality.locale"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.locale"
                },
                {
                    "method": "GET",
                    "rel": "functions",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.function"
                }
            ]
        }
    ],
    "links": [
            {
                "method": "GET",
                "rel": "collection",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.locale"
            },
            {
                "method": "GET",
                "rel": "self",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales?filter=eq(name,%20'ENUSA')&start=0&limit=10&sortBy=name",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales?filter=eq(name,%20'ENUSA')&start=0&limit=10&sortBy=name",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.locale"
            },
            {
                "method": "GET",
                "rel": "up",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/",
                "type": "application/vnd.sas.data.quality.qkb"
            }
        ],
    "version": 2
}
````

#### <a name='example-get-functions'>Retrieving Functions</a>

The list of available functions for a particular locale can be retrieved using GET request against functions URI /dataQuality/environments/{environment}/contexts/{casContext}/qkbs/{qkb}/locales/{locale}/functions

**CAS Request**
```
  GET http://www.example.com/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.function+json
```

**CAS Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{    
    "name": "functions",
    "accept": "application/vnd.sas.data.quality.function",
    "items": [
        {
            "version": 1,
            "name": "Case",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Case",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Case",
                    "type": "application/vnd.sas.data.quality.function"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.function"
                },
                {
                    "method": "GET",
                    "rel": "definitions",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Case/definitions",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Case/definitions",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.definition"
                }
            ]
        },  
        "links": [
                {
                    "method": "GET",
                    "rel": "collection",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.function"
                },
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions?start=0&limit=10&sortBy=name",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions?start=0&limit=10&sortBy=name",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.function"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/",
                    "type": "application/vnd.sas.data.quality.locale"
                }
            ],                     
    "version": 2
}
````

#### <a name='example-get-definitions'>Retrieving Definitions</a>

The list of available definitions for a particular function can be retrieved using GET request against definitions URI /dataQuality/environments/{environment}/contexts/{casContext}/qkbs/{qkb}/locales/{locale}/functions/{function}/definitions

**CAS Request**
```
  GET http://www.example.com/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.definition+json
```

**CAS Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{    
    "name": "definitions",
    "accept": "application/vnd.sas.data.quality.definition",
    "items": [
        {
            "version": 1,
            "name": "Account Number",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Account_Number",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Account_Number",
                    "type": "application/vnd.sas.data.quality.definition"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.definition"
                },
                {
                    "method": "GET",
                    "rel": "tokens",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Account_Number/tokens",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Account_Number/tokens",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.token"
                }
            ]
        }        
    ],
    "links": [
            {
                "method": "GET",
                "rel": "collection",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.definition"
            },
            {
                "method": "GET",
                "rel": "next",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions?sortBy=name&start=10&limit=10",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions?sortBy=name&start=10&limit=10",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.definition"
            },
            {
                "method": "GET",
                "rel": "last",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions?sortBy=name&start=20&limit=10",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions?sortBy=name&start=20&limit=10",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.definition"
            },
            {
                "method": "GET",
                "rel": "self",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions?start=0&limit=10&sortBy=name",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions?start=0&limit=10&sortBy=name",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.definition"
            },
            {
                "method": "GET",
                "rel": "up",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/",
                "type": "application/vnd.sas.data.quality.function"
            }
        ],
    "version": 2
}
````

#### <a name='example-get-tokens'>Retrieving Tokens</a>

The list of available tokens for a particular definition can be retrieved using GET request against tokens URI /dataQuality/environments/{environment}/contexts/{casContext}/qkbs/{qkb}/locales/{locale}/functions/{function}/definitions/{definition}/tokens

**CAS Request**
```
  GET http://www.example.com/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens
  Headers:
  * Accept: application/vnd.sas.collection+json
  * Accept-Item: application/vnd.sas.data.quality.token+json
```

**CAS Response**
````
Headers:
 * Content-Type: application/vnd.sas.collection+json
Body:
{    
    "name": "tokens",
    "accept": "application/vnd.sas.data.quality.token",
    "items": [
        {
            "version": 1,
            "name": "Building/Site",
            "links": [
                {
                    "method": "GET",
                    "rel": "self",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens/Building_Site",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens/Building_Site",
                    "type": "application/vnd.sas.data.quality.token"
                },
                {
                    "method": "GET",
                    "rel": "up",
                    "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens",
                    "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens",
                    "type": "application/vnd.sas.collection",
                    "itemType": "application/vnd.sas.data.quality.token"
                }
            ]
        }
    ],
    "links": [
            {
                "method": "GET",
                "rel": "collection",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.token"
            },
            {
                "method": "GET",
                "rel": "self",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens?start=0&limit=10&sortBy=name",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/tokens?start=0&limit=10&sortBy=name",
                "type": "application/vnd.sas.collection",
                "itemType": "application/vnd.sas.data.quality.token"
            },
            {
                "method": "GET",
                "rel": "up",
                "href": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/",
                "uri": "/dataQuality/environments/CAS/contexts/casqkb/qkbs/QKB_CI29ALL/locales/ENUSA/functions/Match/definitions/Address/",
                "type": "application/vnd.sas.data.quality.definition"
            }
        ],
    "version": 2
}
````

#### <a name='using-client-session'>Using a Client Session</a>

In the example below, passing a sessionId to be used for calls to execution environment is demonstrated.

Endpoints under /dataQuality/environments/{environmentName}/contexts/{contextName} support an optional sessionId parameter, which enables user to provide their own session to the Data Quality API. Providing a session can significantly improve performance. Management of the session in such cases is a client responsibility; the Data Quality API will not destroy the session after using it. The user must provide the sessionId that corresponds to the environmentName (CAS or compute) that the endpoint is executing against.

##### Query Parameters

The following query parameters are supported for calls to `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs`, `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}`, `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales`, `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}`, `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions`, `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions/{functionName}`, `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions/{functionName}/definitions`, `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions/{functionName}/definitions/{definitionName}`, `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions/{functionName}/definitions/{definitionName}/tokens`,  and `/dataQuality/environments/{environmentName}/contexts/{contextName}/qkbs/{qkbName}/locales/{localeName}/functions/{functionName}/definitions/{definitionName}/tokens/{tokenName}`:

| Name               | Type      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|--------------------|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `?sessionId`       | `string`  | The unique identifier of the session that is used to access the data service provider's backing service. When this string is not specified, the data service provider creates a temporary session. After the request is complete, the temporary session is terminated. If this string is specified, all returned links, except the `self` link, contain the sessionId query parameter in their respective URIs. Also, they contain an additional session link to the application/vnd.sas.data.session resource that corresponds to the provided sessionId.                                                                  |


version 2, last updated 26 Nov, 2019