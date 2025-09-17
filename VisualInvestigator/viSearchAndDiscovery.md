# Search and Discovery

The Search and Discovery API provides access to the Search and Discovery component of Visual Investigator in order to perform real-time search operations over JSON-formatted data and visualize the results in various meaningful ways. 
This differs from the SAS VIYA Search service, which provides free text and faceted search capabilities but not geospatial or graph search, or the ability to visualize the results in multiple ways.


## API Request Examples

* [Use case one: Search person objects](#Use-Case-One)
* [Use case two: Expand person vertex](#Use-Case-Two)
* [Use case three: Get detailed vertex information](#Use-Case-Three)
* [Use case four: Import configuration](#Use-Case-Four)
* [Use case five: Re-index all person objects](#Use-Case-Five)
* [Use case six: Define Events for Time and Geospatial Searching](#Use-Case-Six)
* [Use case seven: Calculate Network Centrality](#Use-Case-Seven)

#### <a name='Use-Case-One'>Use Case One</a>: Search Person Objects

A user wants to search for all person objects with the name John Smith and aged between 20 and 30.

POST to /searches:

```json {
  // The query parameter specifies the search query.
  "query": 
  {
    // The type parameter specifies the type of query. "text" is a free text query.
    "type": "text",
    // The language parameter specifies the free text query language used. Currently only "lucene" is supported.
    "language": "lucene",
    // The text parameter specifies the free text query.
    "text": "forename:john AND surname:smith"
  },
  // The optional types parameter specifies which object types to include in the search.
  "types": ["person"],
  // The optional filter parameter allows a filter to be applied in order to limit which objects are included in the results.
  // (This is separate from the query so that aggregations can be applied to the query results prior to filtering.)
  "filter":
  {
    // This range filter includes objects only if their age field contains a value between 20 and 30 (inclusive of 20 and 30).
    "type": "range",
    "field": "age",
    "gte": 20,
    "lte": 30
  },
  // The visualizations parameter specifies which visualizations to include in the response.
  // In this case, hits and summary are included.
  // The keys allow each visualization to be identified in the response.
  "visualizations":
  {
    // The first visualization. Any string can be used as the key as long as it is unique.
    "1":
    {
      // The Hits visualization returns a breakdown of the number of hits per object type.
      "type": "hits"
    }, 
    // The second visualization.
    "2":
    {
      // The Summary visualization returns a summary for each object found by the search.
      "type": "summary",
      // The start parameter specifies the first hit to include in this page of the results.
      "start": 1,
      // The limit parameter specifies the number of hits to include in this page of the results.
      "limit": 10
    }
  }
}
```

Response:

```json
{
  // The requested visualizations.
  "visualizations":
  {
    // The Hits visualization.
    "1":
    {
      "type": "hits",
      "hitCount": 15,
      "hitsPerType": [{"type": "person", "hitCount": 15}]
    },
    // The Summary visualization.
    "2":
    {
      "type":"summary",
      // The start and limit parameters from the request.
      "start": 1,
      "limit": 10,
      // hitCount specifies the total number of objects found in the search.
      "hitCount": 15,
      "results":
      [
        {
          "id":"ju0RrSsRQRqdSnrKO75AFQ", 
          // type is the object type.
          "type":"person",
          // typeLabel is the localized name for the object type.
          "typeLabel":"Person",
          // The summary label for the object.
          "label": "Smith, John",
          // The number of attachments on the object.
          "attachmentsCount": 4,
          // fields contains the list of summary fields (as defined by the /admin/config endpoints).
          "fields": [
            {"name": "age", "type": "integer", "value": 25},
            {"name": "city", "type": "text", "value": "Glasgow"}
          ],
          // highlighting lists text fragments that matched terms in the free text query.
          "highlighting": {
            "forename": ["...<em>John<\em>..."],
            "surname": ["...<em>Smith<\em>..."]
          }
        },
        ...
      ]
    }
  }
}
```

#### <a name='Use-Case-Two'>Use Case Two</a>: Expand Person Vertex

A user wishes to traverse the relationships for a person vertex in the Network visualization in order to find related people, reports and addresses.

POST to /traversals:

```json
{
    // The vertexTypes parameter specifies which object types to include in the resultant graph.
    "vertexTypes":
    [
        "report", "address", "person"
    ],
    // The query parameter specifies the search query for the initial set of vertices. In this case, the person vertex.
    "query":
    {
        "type": "object",
        "objectIds":
        [
            {"type": "person", "id": "9g8ds"}
        ]
    },
    // The user wants to see vertices up to two levels away from the initial person vertex.
    "depth": 2,
    // The extendedFormat parameter specifies whether to include additional information such as vertex degree and adjacent counts in the response.
    "extendedFormat": true,
    // The edgeFilter parameter allows a filter to be specified that limits which relationships are included in the resultant graph.
    "edgeFilter":
    {
        "type" : "terms",
        "field" : "description",
        "terms" :
        [
          // Specific relationship descriptions for person.
          "seen with", "friends with", "travelled with",
          // Specific relationship descriptions for report.
          "mentioned in",
          // Specific relationship descriptions for address.
          "owns", "rents", "lets"
        ]
    },
    // The vertexFilter parameter allows a filter to be specified that limits which objects are included in the graph.
    // In this case, person, address, and report objects are to be included for persons aged between 20 and 40 (inclusively).
    "vertexFilter":
    {
        "type": "or",
        "filters":
        {
            {"type": "type", "types": ["address", "report"]},
            {"type": "and", "filters":
                [
                    {"type": "type", "types": ["person"]},
                    {"type": "range", "field" : "age", "gte" : 20, "lte" : 40}
                ]
            }
        }
    }
}
```

Response:

```json
{
    "counts":
    {
        // edges specifies the total number of edges (relationships) in the graph.
        "edges": 5,
        // vertices specifies the total number of vertices (objects) in the graph.
        "vertices": 6
    },
    // vertices lists the objects in the graph.
    "vertices":
    [
        {"id": "9g8ds", "type": "person", ...},
        {"id": "420e9", "type": "address", ...},
        {"id": "lj34i", "type": "report", ...},
        {"id": "29u4l", "type": "person", ...},
        {"id": "9f48k", "type": "address", ...},
        {"id": "ie47a", "type": "report", ...}
    ],
    // edges lists the relationships in the graph.
    "edges":
    [
        {"id": "1", "description": "owns", "endpoints": [{"id": "9g8ds", "type": "person"}, {"id": "420e9", "type": "address"}], "style":{"color": "#ffffff","width": 1,"dashType": "dashed"}},
        {"id": "2", "description": "mentioned in", "endpoints": [{"id": "lj34i", "type": "report"}, {"id": "420e9", "type": "address"}], "style":{"color": "#ffffff","width": 1,"dashType": "dashed"}},
        {"id": "3", "description": "friends with", "endpoints": [{"id": "9g8ds", "type": "person"}, {"id": "29u4l", "type": "person"}], "style":{"color": "#ffffff","width": 1,"dashType": "dashed"}},
        {"id": "4", "description": "rents", "endpoints": [{"id": "29u4l", "type": "person"}, {"id": "9f48k", "type": "address"}], "style":{"color": "#ffffff","width": 1,"dashType": "dashed"}},
        {"id": "5", "description": "mentioned in", "endpoints": [{"id": "ie47a", "type": "report"}, {"id": "29u41", "type": "person"}], "style":{"color": "#ffffff","width": 1,"dashType": "dashed"}}
    ]
}
```

#### <a name='Use-Case-Three'>Use Case Three</a>: Get Detailed Vertex Information

A user wants to retrieve detailed information about a single report object in the Network visualization. This information includes the label, adjacent count, and degree count as well as a breakdown of adjacent by object type and degree by relationship type.

GET on /vertices/report/337:

```json
{
    // The identifier of the vertex.
    "id": "337",
    // The object type of the vertex.
    "type": "report",
    // The display name for the object type.
    "typeLabel": "Report",
    // The list of compound values if the vertex is a resolved entity.
    "compoundValues": [],
    // The summary label for the vertex.
    "label": "Report 337",
    // The number of attachments on the vertex.
    "attachmentsCount": 10,
    // The number of adjacent vertices.
    "adjacent": 4,
    // The number of edges entering and leaving the vertex.
    // (The degree count will be greater than the adjacent count when there are multiple edges between this and another vertex.)
    "degree": 5,
    // The adjacent count by object type.
    "adjacentByType": 
    {
        "person": 1,
        "report": 3
    },
    // The degree count by relationship type.
    "degreeByType": 
    {
        "MENTIONS": 2,
        "RELATED TO": 3
    },
    // The summary fields.
    "fields":
    [
        {"name": "reportedAt", "type": "date", "value": "2012-01-05"}
    ],
    // The datetime from which the report is valid.
    "validFrom": "2001-08-16T05:00Z",
    // The datetime to which the report is valid.
    "validTo": "2014-10-25T17:00Z",
    // The style of the object.
    "style":
    {
        "iconName": "reportIcon1",
        "markerColor": "#ffffff",
        "backgroundColor": "#ffffff",
        "shape": "square",
        "scale": 1,
        "additionalLabel": "Information Report",
        "indicatorIcons":
        [
            {"name": "High Priority", "position": "N"},
            {"name": "Verified", "position": "S"}
        ]
    }
}
```

#### <a name='Use-Case-Four'>Use Case Four</a>: Import Configuration

A user wants to import a configuration into a new system.

POST to /admin/config:

```json
{
    "types":
    {
        // The configuration for the person entity.
        "person":
        {
            "displayName": "Person",
            // The category of the type.
            "category": "entity",
            // The field definitions.
            "fields":
            {
                "forename": {"type": "text", "options": {"features":["search", "sort"]}},
                "age": {"type": "long"},
                "gender": {"type": "text", "options": {"features":["search", "facet", "sort"]}},
                "surname": {"type": "text", "options": {"features":["search", "sort"]}},
                "eventdate": {"displayName": "event date", "type": "date", "options": {"format": "strict_date_optional_time||epoch_millis"}},
                "favColor": {"displayName": "favourite colour", "type": "text", "options": {"features":["search", "facet"]}},
                "city": {"type": "text", "options": {"features":["search", "facet", "sort"]}}
            },
            "config":
            {
                // The configuration for the Summary visualization.
                "summary":
                {
                    "fields": ["age", "gender", "eventdate", "favColor", "city"]
                },
                // The configuration for the Table visualization.
                "table":
                {
                    "fields": ["forename", "surname", "age", "gender", "city"]
                },
                // The configuration for the Network visualization.
                "graph":
                {
                    "fields": ["gender"]
                },
                // The configuration for the Facets visualization.
                "facets":
                [
                    {"type": "terms", "field": "gender"},
                    {"type": "terms", "field": "city", "displayLimit": 2},
                    {"type": "terms", "field": "favColor"},
                    {
                        "type": "range",
                        "field": "age",
                        "filter": {"displayFormat": "number", "allowExact": true, "allowRange": true},
                        "ranges":
                        [
                            {"description": "<=20", "lte": 20.0},
                            {"description": "(20, 25)", "gt": 20.0, "lt": 25.0},
                            {"description": "[25, 30)", "gte": 25.0, "lt": 30.0},
                            {"description": "[30, 35)", "gte": 30.0, "lt": 35.0},
                            {"description": "[35, 40]", "gte" : 35.0, "lte" : 40.0},
                            {"description": ">40", "gt" : 40.0}
                        ]
                    },
                    {
                        "type": "dateRange",
                        "field": "eventdate",
                        "accuracy": "millisecond",
                        "filter": {"displayFormat": "mm/dd/yyyy", "allowExact": true, "allowRange": true}
                    }
                ],
                // The configuration for the label.
                "label":
                {
                    "template": "{0} {1}",
                    "values": ["forename", "surname"]
                }
            }
        },
        // The configuration for the report entity.
        "report":
        {
            "displayName": "Report",
            "category": "entity",
            "fields":
            {
                "text": {"type": "text", "options": {"features":["search", "sort"]}},
                "subject": {"type" : "text", "options": {"features":["search", "facet", "sort"]}}
            },
            "config":
            {
                "summary":
                {
                    "fields": ["text"],
                    "highlighting":
                    {
                        "text": {"highlighter": "plain", "fragmentSize": 100},
                        "subject": {"highlighter": "plain", "fragments": 1, "fragmentSize": 50}
                    }
                },
                "table": {"fields": ["subject", "text"]},
                "graph": {"fields": ["subject"]},
                "facets": [{"type": "terms", "field": "subject"}],
                "label": {"template": "{0}", "values": ["subject"]}
            }
        }
    }
}
```

#### <a name='Use-Case-Five'>Use Case Five</a>: Re-index All Person Objects From the Source Database in the Background

A user wants to delete all person objects in order to re-index them from the source database while not interrupting ongoing searches, which requires three separate calls:

1. POST to /admin/indices/person?searchable=false (without a request body) to create a new unsearchable index for person objects.

2. POST directly to the underlying search engine to index the person objects into the newly created index. Refer to the [OpenSearch Bulk API](https://opensearch.org/docs/2.16/api-reference/document-apis/bulk/) for details.

3. POST on /admin/operations with the following request body to make the new person index searchable and delete all older person indices.

```json
{
    "operation": "makeIndexSearchable",
    "parameters":
    {
        "type": "person"
    }
}
```

While the above calls demonstrate how to re-index the data, the DataHub component is responsible for this and the [API](https://developer.sas.com/rest-apis/svi-datahub) should be used in practice.

#### <a name='Use-Case-Six'>Use Case Six</a>: Define Events for Time and Geospatial Searching

A user wants to view account objects on the Map and Time Line visualizations.

To achieve this the user defines events in the account object type that capture the account opened date and account holder addresses:

```json
{
    "category": "entity",
    "fields":
    {
        "account_holder_forename": {"type": "text"},
        "account_holder_surname": {"type": "text"},
        "opendate": {"type": "date"},
        "account_holder_address":
        {
            "type": "object",
            "innerFields":
            {
                "city": {"type": "text"},
                "state": {"type": "text"},
                "lon": {"type": "double"},
                "lat": {"type": "double"}
            }
        },
        "account_holder_prev_addresses":
        {
            "type": "object",
            "innerFields":
            {
                "city": {"type": "text"},
                "state": {"type": "text"},
                "date_from": {"type": "date"},
                "date_to": {"type": "date"},
                "location": {"type": "geoShape"}
            }
        }
    },
    "config":
    {
        "events":
        [
            {
                "fields":
                {
                    "category": "Account Opened",
                    "pointTimestamp": "{opendate}",
                    "description": "opened by {account_holder_forename} {account_holder_surname}"
                }
            },
            {
                "root": "account_holder_address",
                "fields":
                {
                    "category": "Primary Address",
                    "description": "lives in {city}, {state}",
                    "longitude": "lon",
                    "latitude": "lat"
                }
            },
            {
                "root": "account_holder_prev_addresses",
                "fields":
                {
                    "category": "Previous Address",
                    "intervalStartTimestamp": "{date_from}",
                    "intervalEndTimestamp": "{date_to}",
                    "description": "lived in {city}, {state}",
                    "geoJson": "location"
                },
                "requiredFields": ["state"]
            }
        ]
    }
}
```

Here is an example of an account object prior to the events being extracted:

```json
{
    "account_holder_forename": "John",
    "account_holder_surname": "Smith",
    "opendate": "1999-12-31",
    "account_holder_address":
    {
        "city": "Glasgow",
        "state": "UK",
        "lon": -11.111,
        "lat": 22.222
    },
    "account_holder_prev_addresses":
    [
        {
            "city": "New York",
            "state": "NY",
            "date_from": "2001-10-31",
            "date_to": "2005-01-01",
            "location": {
                "type": "point",
                "coordinates": [-33.333, 44.444]
            }
        },
        {
            "city": "Raleigh",
            "date_from": "1995-07-04",
            "date_to": "2001-10-31",
            "location": {
                "type": "point",
                "coordinates": [-55.555, 66.666]
            }
        },
        {
            "city": "Los Angeles",
            "state": "CA",
            "date_from": "1987-10-31",
            "date_to": "1995-07-04",
            "location": {
                "type": "point",
                "coordinates": [-77.777, 88.888]
            }
        }
    ]
}
```

The first declared event category, "Account Opened", shows how to reference fields in the incoming object using the {} syntax. Note that the pointTimestamp field references an ISO formatted date field in the incoming object. Also note how the description field combines literal text with multiple {} references.

The second declared event category, "Primary Address", uses the root declaration to point to a single sub-field such that a single event is extracted from the inner fields of "account_holder_address".

The third declared event category, "Previous Address", uses the root declaration to point to an array of sub-fields such that an event is extracted for each sub-field in "account_holder_prev_addresses". This example also uses the require_fields declaration so that events are extracted only if the "state" field is present (not null) in the object. Because the second item in the array (with "city":"Raleigh") does not contain the "state" field, no event is created for this item. This does not represent an error; it is meant as a conditional way to create events. Processing continues on to the next item in the array (with "city":"Los Angeles") where it does successfully extract another event.

Here is the account object with the extracted events (one "Account Opened" event, one "Primary Address" event, and two "Previous Address" events):

```json
{
    "account_holder_forename": "John",
    "account_holder_surname": "Smith",
    "opendate": "1999-12-31",
    "account_holder_address":
    {
        "city": "Glasgow",
        "state": "UK",
        "lon": -11.111,
        "lat": 22.222
    },
    "account_holder_prev_addresses":
    [
        {
            "city": "New York",
            "state": "NY",
            "date_from": "2001-10-31",
            "date_to": "2005-01-01",
            "location": {
                "type": "point",
                "coordinates": [-33.333, 44.444]
            }
        },
        {
            "city": "Raleigh",
            "date_from": "1995-07-04",
            "date_to": "2001-10-31",
            "location": {
                "type": "point",
                "coordinates": [-55.555, 66.666]
            }
        },
        {
            "city": "Los Angeles",
            "state": "CA",
            "date_from": "1987-10-31",
            "date_to": "1995-07-04",
            "location": {
                "type": "point",
                "coordinates": [-77.777, 88.888]
            }
        }
    ],
    "_events": // SAND stores events in this system field
    [
        {
            "category": "Account Opened",
            "description": "opened by John Smith",
            "pointTimestamp": "1999-12-31"
        },
        {
            "category": "Primary Address",
            "description": "lives in Glasgow, UK",
            "location":
            {
                "shape":
                {
                    "type": "Point",
                    "coordinates": [-11.111, 22.222]
                },
                "points": [-11.111, 22.222]
            }
        },
        {
            "category": "Previous Address",
            "location":
            {
                "shape":
                {
                    "type": "Point",
                    "coordinates": [-33.333, 44.444]
                },
                "points": [-33.333, 44.444]
            },
            "description":"lived in New York, NY",
            "intervalEndTimestamp":"2005-01-01",
            "intervalStartTimestamp":"2001-10-31"
        },
        {
            "category": "Previous Address",
            "location":
            {
                "shape":
                {
                    "type": "Point",
                    "coordinates": [-77.777, 88.888]
                },
                "points": [-77.777, 88.888]
            },
            "description":"lived in Los Angeles, CA",
            "intervalEndTimestamp":"1995-07-04",
            "intervalStartTimestamp":"1987-10-31"
        }
    ]
}
```

Note the event location field stores both the GeoJSON and longitude and latitude values as they are both needed for search purposes.

#### <a name='Use-Case-Seven'>Use Case Seven</a>: Calculate Network Centrality

A user wants to see the centrality metrics for the objects on a network.

POST to /centrality:

```json
{
    "edges": [
        {"id": "policyToClaim#1", "source": "policy#1", "target": "claim#1" },
        {"id": "policyToClaim#2", "source": "policy#1", "target": "claim#2" }
    ]
}
```

Response:

```json
{
    "name": "items",
    "accept": "application/vnd.sas.network.analytics.centrality.metrics",
    "items":
    [
        {
            "id": "policy#1",
            "degree": 2,
            "eigen": 1,
            "close": 1,
            "between": 1,
            "influence1": 0.6666666666666666,
            "influence2": 0.6666666666666666
        },
        {
            "id": "claim#1",
            "degree": 1,
            "eigen": 0.7071067811865479,
            "close": 0.6666666666666666,
            "between": 0,
            "influence1": 0.3333333333333333,
            "influence2": 0.6666666666666666
        },
        {
            "id": "claim#2",
            "degree": 1,
            "eigen": 0.7071067811865479,
            "close": 0.6666666666666666,
            "between": 0,
            "influence1": 0.3333333333333333,
            "influence2": 0.6666666666666666
        }
    ]
}
```
