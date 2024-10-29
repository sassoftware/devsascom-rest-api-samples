# Row Set API
The Row Sets API is used for retrieving row data that is contained in the SAS Viya ecosystem.

#### Context

The Row Sets API works in concert with the Data Sources and Data Tables APIs to navigate, reference, and retrieve data in the SAS Viya environment. The Row Set API enables retrieval of rectangular row data for data tables.

In the example below, a CAS table, titled AIRLINES, has the following columns: AIRLINE ID, NAME, ALIAS, IATA, ICAO, CALLSIGN, COUNTRY and ACTIVE.
For more information about navigating to a table, see the [Data Tables API](https://developer.sas.com/rest-apis/dataTables "Data Tables API") documentation.

### Differences Between Row Sets and Rows

Included in the `application/vnd.sas.data.table` resource are `rows` and `rowSet` links, which the user can follow to request either
`application/vnd.sas.collection` of `application/vnd.sas.data.row` or an `application/vnd.sas.data.row.set` resource respectively.
Use the `rows` link to get the full row of data for the table, regardless of the number of columns. Use the `rowSet` link to get rows of data for only certain columns or a range of columns.


## API Request Examples Grouped by Object Type

In the example below, a CAS table, titled CARS, has the following columns:
Make, Model, Type, MSRP, MPG_City, MPG_Highway etc. For more information about navigating to a table, see the
[Data Tables API](https://developer.sas.com/rest-apis/dataTables "Data Tables API")
documentation.

<details>
<summary>Rows</summary>

- [Retrieving Rows](#RetrievingRows)
</details>

<details>
<summary>Row Set</summary>

- [Retrieving a row set](#RetrievingRowSet)
- [Applying a WHERE clause](#WhereClause)
- [Paginating vertically and horizontally](#Pagination)
- [Session handling](#SessionHandling)
- [Query parameters](#QueryParameters)
- [Link relations](#LinkRelations)
</details>

<details>
<summary>Use Cases</summary>

- [Client provides sessionId](#ClientProvidessessionId)
- [Client does not specify sessionId](#ClientNoSessioinId)
- [Client Does not specify sessionId and specifies preserveSession=true](#ClientNoSessionIdPreserveSession)
</details>

#### <a name='RetrievingRows'>Retrieving Rows</a>

The entry point into this service to retrieve row data should be from the
[rows link](https://developer.sas.com/rest-apis/rowSets#rows)
of the media type
[`application/vnd.sas.data.table`](https://developer.sas.com/rest-apis/dataTables/getTables)
from the
[Data Tables](https://developer.sas.com/rest-apis/dataTables/getTables "Data Tables API")
API. For example, performing a GET request on the
[`application/vnd.sas.data.table`](https://developer.sas.com/rest-apis/dataTables "Data Tables API")
resource below:

GET /dataTables/dataSources/cas~fs~cas-shared-default~fs~MYCASLIB/CARS

**Rows Link from the application/vnd.sas.data.table**

```json
{
  "method": "GET",
  "rel": "rows",
  "href": "/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~CARS/rows",
  "uri": "/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~CARS/rows",
  "type": "application/vnd.sas.collection",
  "itemType": "application/vnd.sas.data.row"
 }
```

`Request:`

```json
{
  "GET": "/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~CARS/rows",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.data.row+json"
  }
}
```

`Response:`

```json
{
  "headers": {
    "Content-Type": "application/vnd.sas.collection+json"
  },
  "body": {
    "name": "rows",
    "accept": "application/vnd.sas.data.row",
    "start": 0,
    "limit": 10,
    "items": [
      { "version": 1, "cells": ["Acura", "MDX", "SUV", "$46,945", "17", "23"] },
      { "version": 1, "cells": ["BMW", "X3 3.0i", "SUV", "$47,000", "16", "24"] },
      { "version": 1, "cells": ["Cadillac", "CTS VVT 4dr", "Sedan", "$32,835", "18", "25"] },
      { "version": 1, "cells": ["Dodge", "Neon SE 4dr", "Sedan", "$18,670", "29", "36"] },
      { "version": 1, "cells": ["Ford", "Focus", "Sedan", "$17,270", "26", "33"] },
      { "version": 1, "cells": ["Honda", "Civic Hybrid", "Sedan", "$22,140", "36", "51"] },
      { "version": 1, "cells": ["Honda", "CRV", "SUV", "$37,200", "28", "35"] },
      { "version": 1, "cells": ["Toyota", "Rav4 Hybrid", "SUV", "$36,945", "36", "42"] },
      { "version": 1, "cells": ["Toyota", "Prius", "Hybrid", "$26,500", "45", "57"] },
      { "version": 1, "cells": ["Toyota", "Highlander", "SUV", "$41,450", "18", "24"] }
    ],
    "links": [
      {
        "method": "GET",
        "rel": "collection",
        "href": "/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~COUNTRY/rows",
        "uri": "/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~COUNTRY/rows",
        "type": "application/vnd.sas.collection",
        "itemType": "application/vnd.sas.data.row"
      },
      {
        "method": "GET",
        "rel": "self",
        "href": "/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~COUNTRY/rows?start=0&limit=10",
        "uri": "/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~COUNTRY/rows?start=0&limit=10",
        "type": "application/vnd.sas.collection",
        "itemType": "application/vnd.sas.data.row"
      },
      {
        "method": "GET",
        "rel": "up",
        "href": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~MYCASLIB/tables/COUNTRY",
        "uri": "/dataTables/dataSources/cas~fs~cas-shared-default~fs~MYCASLIB/tables/COUNTRY",
        "type": "application/vnd.sas.data.table"
      }
    ]
  }
}
```


Performing a GET request using the URI
`/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~CARS/rows` returns an
[`application/vnd.sas.collection`](https://developer.sas.com/rest-apis/rowSets/docs/getting-started/usage-notes#collections "application/vnd.sas.collection")
resource containing
[`application/vnd.sas.data.row`](https://developer.sas.com/rest-apis/rowSets/createRowsForTableWithQuery "Row Sets API")
resources. See
[Pagination, sorting and filtering](https://developer.sas.com/rest-apis/rowSets/docs/getting-started/usage-notes#pagination)
for how to paginate the rows of this collection.

#### <a name='WhereClause'>Applying a WHERE Clause</a>

A user can apply a WHERE clause to the
`/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~CARS/rows` collection by
doing one of the following:

- POST `/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~CARS/rows` with
  header Accept: text/plain and a request body of COUNTRY='Canada'
- GET
  `/rowSets/tables/cas~fs~cas-shared-default~fs~MYCASLIB~fs~CARS/rows?where=Make='Acura'`

#### <a name='Pagination'>Paginating Vertically and Horizontally</a>

The [`application/vnd.sas.data.row.set`] (#application-vnd.sas.data.row "Row
Sets API") can paginate over wide data tables either vertically or horizontally.
The API standard pagination, with its respective set of standard links of
`next`, `prev`, `first` and `last`, paginate vertically.

#### <a name='SessionHandling'>Session Handling</a>

Certain Row Sets service providers support session-based data retrieval.Certain
Row Sets service providers support session-based data retrieval. To determine
whether this is supported by any particular provider, you can query
`/rowSets/providers/{providerId}` to retrieve the media type
`application/vnd.sas.data.provider`](https://developer.sas.com/rest-apis/dataSources/getProvider)
and check if the `usesSessions` member.

#### <a name='QueryParameters'>Query Parameters</a>

If sessions are supported by the provider, the following query parameters are
supported for calls to `/rowSets/tables/{tableId}/rows`:

| Name               | Type      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ------------------ | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `?sessionId`       | `string`  | The unique identifier of the session used to access the data service provider's backing service. When this is not specified, the data service provider creates a temporary session, and then destroys it after the request is complete. If this is specified, all returned links, except the "self" link, have the sessionId query parameter added to their respective URIs. Also, an additional session link is added to the application/vnd.sas.data.session resource that corresponds to the provided sessionId.                                                          |
| `?preserveSession` | `boolean` | This has effect only when the `?sessionId` query parameter is not specified. If this is set to true, no `?sessionId` is provided, the session created by the data service provider is not destroyed. All returned links, except the "self" link, have the `?sessionId`query parameter added to their respective URIs. Also, an additional session link is added to the application/vnd.sas.data.session resource that corresponds to the provided `?sessionId`. If set to false or not specified, the session is destroyed after the request is complete. Defaults to false. |

#### Link Relations

##### session link

The `session` link is added anytime the `sessionId` is provided by the user or
the `preserveSession` query parameter is set to true. This `session` link should
be the
[`application/vnd.sas.data.session`](https://developer.sas.com/rest-apis/dataSources#sessions "Data Sources API")
[media type](https://developer.sas.com/rest-apis/dataSources "Media type"),
and the href should be
`/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}`.
This is provided so that the client can obtain further links to destroy the
session if they want to destroy the session.

##### sessionScoped link

The `sessionScoped` link is added anytime the `sessionId` is provided by the
user or the `preserveSession` query parameter is set to true. This link gives
the user access to a session-scoped version of the `self` link, and ensures they
understand that they are working with a temporary session. The `self` link must
be the resource identifier that the user persists. The `sessionScoped` link can
be used for immediate access and for work being done with the resource by the
client.

#### <a name='ClientProvidessessionId'>Use Case: Client Provides sessionId</a>

In the case of the user already knowing their session identifier, they can pass
it as the query parameter `sessionId`. This session identifier is used when
establishing a connection to the data service provider's backing service (e.g.
CAS). If the sessionId does not exist, a 404 error is returned. Also, a session
link should be provided that points to the appropriate session in the path
`/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}`
where `sourceId` corresponds to the level of the data hierarchy that the session
is associated with (e.g. for CAS it would be the first-level cas server). The
`sessionId` should be appended as a query parameter to all links except the
`self` link, and the `sessionScoped` link to the respective resource should be
added.

#### <a name='ClientNoSessionIdPreserveSession'>Use Case: Client Does not specify sessionId and specifies preserveSession=true</a>

If the user does not provide the session identifier, it is the responsibility of
the data provider service to create a temporary session to request the data from
the backing service, and then delete that session upon completion of the
request. However, if the user sets the `preserveSession` query parameter to true
then that temporary session should be preserved and placed on the returned
links.

In the example below, the session identifier
b51875c6-0561-45e1-bad3-ea7c2053d65f is the temporal session that is preserved.
Also, a session link should be provided that points to the appropriate session
in the path
`/dataSources/providers/{providerId}/sources/{sourceId}/sessions/{sessionId}`
where `sourceId` corresponds to the level of the data hierarchy that the session
is associated with (e.g. for CAS it would be the first level cas server). The
`sessionId` should be appended as a query parameter to all links except the
`self` link, and the `sessionScoped` link to the respective resource should be
added.

version 1, last updated 29 October, 2024


