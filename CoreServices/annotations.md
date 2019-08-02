# Annotations API
The Annotations API manages annotations within the SAS environment. An annotation adds extra information to tables, columns, and other objects. This is information that extends beyond metadata. The service allows annotations to be managed independently from the services that manage the object.

Expected uses of this API include data preparation and data mining.

Each annotation can contain an array of members. Each member represents an object to which that annotation applies.  Each member has only one annotation.

If an object has more than one annotation, the object is represented as two unique members, each owned by a different annotation. For example, a column "SN" can have two annotations:  one named "Serial Number" and another named "Discrete". The Annotations API persists the "Serial Number" annotation with a member named "SN". The "Discrete" annotation has a unique member named "SN".


## API Request Examples


* [Discover top-level links for the annotations service](#top-level-links)
* [Create a new annotation](#create-annotation)
* [Add an associated object (member) to an annotation](#create-member)
* [Get annotations by associated resourceUris](#get-by-resourceuris)
* [Get members by associated annotation ids](#get-members-by-annotation-ids)

#### <a name='top-level-links'>Discover top-level links for the annotations service</a>

**Request**
```
  GET http://www.example.com/annotations/
  Headers:
  * Accept = application/vnd.sas.api+json
```

**Response**
```
  Status: 200
  Headers:
  * Content-Type = application/vnd.sas.api+json
  Body:
  {
      "version": 1,
      "links": [
          {
              "method": "GET",
              "rel": "annotations",
              "href": "/annotations/annotations",
              "uri": "/annotations/annotations",
              "type": "application/vnd.sas.collection"
          },
          {
              "method": "POST",
              "rel": "create",
              "href": "/annotations/annotations",
              "uri": "/annotations/annotations",
              "type": "application/vnd.sas.annotation",
              "responseType": "application/vnd.sas.annotation"
          }
      ]
  }
```


#### <a name='create-annotation'>Create a new annotation</a>

**Request**
```
  POST http://www.example.com/annotations/annotations/
  Headers:
  * Accept = application/vnd.sas.annotation+json
  * Content-Type = application/vnd.sas.annotation+json
  Body:
  {
    "name": "newAnnotationName",
    "domain": "newDomainLabel",
    "label": "newAnnotationLabel",
    "description": "newDescriptionLabel"
  }
```

**Response**
```
  Status: 201
  Headers:
  * Content-Type = application/vnd.sas.annotation+json
  * Location = /annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce
  Body:
  {
      "creationTimeStamp": "2018-03-26T19:50:09.935Z",
      "modifiedTimeStamp": "2018-03-26T19:50:09.935Z",
      "createdBy": "sasboot",
      "modifiedBy": "sasboot",
      "id": "2a902411-4f81-4819-9263-203cf0ff29ce",
      "name": "newAnnotationName",
      "domain": "newDomainLabel",
      "version": 1,
      "label": "newAnnotationLabel",
      "description": "newDescriptionLabel",
      "links": [
          {
              "method": "GET",
              "rel": "self",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
              "type": "application/vnd.sas.annotation"
          },
          {
              "method": "PUT",
              "rel": "update",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
              "type": "application/vnd.sas.annotation",
              "responseType": "application/vnd.sas.annotation"
          },
          {
              "method": "DELETE",
              "rel": "delete",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce"
          },
          {
              "method": "GET",
              "rel": "up",
              "href": "/annotations/annotations",
              "uri": "/annotations/annotations",
              "type": "application/vnd.sas.collection",
              "itemType": "application/vnd.sas.annotation"
          },
          {
              "method": "GET",
              "rel": "members",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members",
              "type": "application/vnd.sas.collection",
              "itemType": "application/vnd.sas.annotation.member"
          }
      ]
  }
```


#### <a name='create-member'>Add an associated object (member) to an annotation</a>

**Request**
The URL in this example contains the annotation ID from the annotation that was created in the previous example.
```
  POST http://www.example.com/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members
  Headers:
  * Accept = application/application/vnd.sas.annotation.member+json
  * Content-Type = application/application/vnd.sas.annotation.member+json
  Body:
  {
    "annotationId": "2a902411-4f81-4819-9263-203cf0ff29ce",
    "resourceType": "type",
    "resourceUri": "uri",
    "value": "objectValue"
  }
```

**Response**
```
  Status: 201
  Headers:
  * Content-Type = application/vnd.sas.annotation.member+json
  * Location = /annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/13aab93d-7699-4f17-8074-0953d1183020
  Body:
  {
      "creationTimeStamp": "2018-03-26T19:58:04.918Z",
      "modifiedTimeStamp": "2018-03-26T19:58:04.918Z",
      "createdBy": "sasboot",
      "modifiedBy": "sasboot",
      "version": 1,
      "id": "04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
      "annotationId": "2a902411-4f81-4819-9263-203cf0ff29ce",
      "resourceType": "type",
      "resourceUri": "uri",
      "value": "objectValue",
      "links": [
          {
              "method": "GET",
              "rel": "annotation",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
              "type": "application/vnd.sas.annotation"
          },
          {
              "method": "GET",
              "rel": "self",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
              "type": "application/vnd.sas.annotation.member"
          },
          {
              "method": "PUT",
              "rel": "update",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
              "type": "application/vnd.sas.annotation.member",
              "responseType": "application/vnd.sas.annotation.member"
          },
          {
              "method": "DELETE",
              "rel": "delete",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9"
          },
          {
              "method": "GET",
              "rel": "up",
              "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members",
              "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members",
              "type": "application/vnd.sas.annotation.member",
              "responseType": "application/vnd.sas.annotation.member"
          }
      ]
  }
```

#### <a name='get-by-resourceuris'>Get annotations by associated resourceUris</a>

**Request**
```
  POST http://www.example.com/annotations/annotations/
  Headers:
  * Accept = application/vnd.sas.collection+json
  * Content-Type = application/vnd.sas.selection+json
  Body:
  {
    "resources": [ "uri", "uri2" ]
  }
```

**Response**
```
  Status: 200
  Headers:
  * Content-Type = application/vnd.sas.collection+json
  Body:
  {
      "links": [
          {
              "method": "POST",
              "rel": "collection",
              "href": "/annotations/annotations",
              "uri": "/annotations/annotations",
              "type": "application/vnd.sas.selection",
              "responseType": "application/vnd.sas.collection"
          }
      ],
      "name": "annotations",
      "accept": "application/vnd.sas.annotation",
      "start": 0,
      "count": 2,
      "items": [
          {
              "creationTimeStamp": "2018-03-26T19:50:09.935Z",
              "modifiedTimeStamp": "2018-03-26T19:50:09.935Z",
              "createdBy": "sasboot",
              "modifiedBy": "sasboot",
              "id": "2a902411-4f81-4819-9263-203cf0ff29ce",
              "name": "newAnnotationName",
              "domain": "newDomainLabel",
              "version": 1,
              "label": "newAnnotationLabel",
              "description": "newDescriptionLabel",
              "links": [
                  {
                      "method": "GET",
                      "rel": "self",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
                      "type": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "PUT",
                      "rel": "update",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
                      "type": "application/vnd.sas.annotation",
                      "responseType": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "DELETE",
                      "rel": "delete",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce"
                  },
                  {
                      "method": "GET",
                      "rel": "up",
                      "href": "/annotations/annotations",
                      "uri": "/annotations/annotations",
                      "type": "application/vnd.sas.collection",
                      "itemType": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "GET",
                      "rel": "members",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members",
                      "type": "application/vnd.sas.collection",
                      "itemType": "application/vnd.sas.annotation.member"
                  }
              ]
          },
          {
              "creationTimeStamp": "2018-03-26T20:10:56.373Z",
              "modifiedTimeStamp": "2018-03-26T20:10:56.373Z",
              "createdBy": "sasboot",
              "modifiedBy": "sasboot",
              "id": "26e2df43-aeaf-475d-a64e-7baafb8a4eca",
              "name": "newAnnotationName2",
              "domain": "newDomainLabel",
              "version": 1,
              "label": "newAnnotationLabel",
              "description": "newDescriptionLabel",
              "links": [
                  {
                      "method": "GET",
                      "rel": "self",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "type": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "PUT",
                      "rel": "update",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "type": "application/vnd.sas.annotation",
                      "responseType": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "DELETE",
                      "rel": "delete",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca"
                  },
                  {
                      "method": "GET",
                      "rel": "up",
                      "href": "/annotations/annotations",
                      "uri": "/annotations/annotations",
                      "type": "application/vnd.sas.collection",
                      "itemType": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "GET",
                      "rel": "members",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members",
                      "type": "application/vnd.sas.collection",
                      "itemType": "application/vnd.sas.annotation.member"
                  }
              ]
          }
      ],
      "limit": 2147483647,
      "version": 2
  }
```

#### <a name='get-members-by-annotation-ids'>Get members by annotation IDs</a>

**Request**
```
  POST http://www.example.com/annotations/members/
  Headers:
  * Accept = application/vnd.sas.collection+json
  * Content-Type = application/vnd.sas.selection+json
  Body:
  {
    "resources": [ "26e2df43-aeaf-475d-a64e-7baafb8a4eca", "2a902411-4f81-4819-9263-203cf0ff29ce" ]
  }
```

**Response**
```
  Status: 200
  Headers:
  * Content-Type = application/vnd.sas.collection+json
  Body:
  {
      "links": [
          {
              "method": "POST",
              "rel": "collection",
              "href": "/annotations/members",
              "uri": "/annotations/members",
              "type": "application/vnd.sas.selection",
              "responseType": "application/vnd.sas.collection"
          }
      ],
      "name": "members",
      "accept": "application/vnd.sas.annotation.member",
      "start": 0,
      "count": 3,
      "items": [
          {
              "creationTimeStamp": "2018-03-26T19:58:04.918Z",
              "modifiedTimeStamp": "2018-03-26T19:58:04.918Z",
              "createdBy": "sasboot",
              "modifiedBy": "sasboot",
              "version": 1,
              "id": "04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
              "annotationId": "2a902411-4f81-4819-9263-203cf0ff29ce",
              "resourceType": "type",
              "resourceUri": "uri",
              "value": "objectValue",
              "links": [
                  {
                      "method": "GET",
                      "rel": "annotation",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce",
                      "type": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "GET",
                      "rel": "self",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
                      "type": "application/vnd.sas.annotation.member"
                  },
                  {
                      "method": "PUT",
                      "rel": "update",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
                      "type": "application/vnd.sas.annotation.member",
                      "responseType": "application/vnd.sas.annotation.member"
                  },
                  {
                      "method": "DELETE",
                      "rel": "delete",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members/04c2d36b-0f7a-4e1b-a546-a80ffbe35bf9"
                  },
                  {
                      "method": "GET",
                      "rel": "up",
                      "href": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members",
                      "uri": "/annotations/annotations/2a902411-4f81-4819-9263-203cf0ff29ce/members",
                      "type": "application/vnd.sas.annotation.member",
                      "responseType": "application/vnd.sas.annotation.member"
                  }
              ]
          },
          {
              "creationTimeStamp": "2018-03-26T20:11:17.132Z",
              "modifiedTimeStamp": "2018-03-26T20:11:17.132Z",
              "createdBy": "sasboot",
              "modifiedBy": "sasboot",
              "version": 1,
              "id": "a7f35cb5-c72d-4fae-a5f3-af74f26cdf42",
              "annotationId": "26e2df43-aeaf-475d-a64e-7baafb8a4eca",
              "resourceType": "type",
              "resourceUri": "uri2",
              "value": "objectValue",
              "links": [
                  {
                      "method": "GET",
                      "rel": "annotation",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "type": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "GET",
                      "rel": "self",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/a7f35cb5-c72d-4fae-a5f3-af74f26cdf42",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/a7f35cb5-c72d-4fae-a5f3-af74f26cdf42",
                      "type": "application/vnd.sas.annotation.member"
                  },
                  {
                      "method": "PUT",
                      "rel": "update",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/a7f35cb5-c72d-4fae-a5f3-af74f26cdf42",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/a7f35cb5-c72d-4fae-a5f3-af74f26cdf42",
                      "type": "application/vnd.sas.annotation.member",
                      "responseType": "application/vnd.sas.annotation.member"
                  },
                  {
                      "method": "DELETE",
                      "rel": "delete",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/a7f35cb5-c72d-4fae-a5f3-af74f26cdf42",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/a7f35cb5-c72d-4fae-a5f3-af74f26cdf42"
                  },
                  {
                      "method": "GET",
                      "rel": "up",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members",
                      "type": "application/vnd.sas.annotation.member",
                      "responseType": "application/vnd.sas.annotation.member"
                  }
              ]
          },
          {
              "creationTimeStamp": "2018-03-26T20:16:57.732Z",
              "modifiedTimeStamp": "2018-03-26T20:16:57.732Z",
              "createdBy": "sasboot",
              "modifiedBy": "sasboot",
              "version": 1,
              "id": "13aab93d-7699-4f17-8074-0953d1183020",
              "annotationId": "26e2df43-aeaf-475d-a64e-7baafb8a4eca",
              "resourceType": "type",
              "resourceUri": "uri3",
              "value": "objectValue",
              "links": [
                  {
                      "method": "GET",
                      "rel": "annotation",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca",
                      "type": "application/vnd.sas.annotation"
                  },
                  {
                      "method": "GET",
                      "rel": "self",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/13aab93d-7699-4f17-8074-0953d1183020",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/13aab93d-7699-4f17-8074-0953d1183020",
                      "type": "application/vnd.sas.annotation.member"
                  },
                  {
                      "method": "PUT",
                      "rel": "update",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/13aab93d-7699-4f17-8074-0953d1183020",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/13aab93d-7699-4f17-8074-0953d1183020",
                      "type": "application/vnd.sas.annotation.member",
                      "responseType": "application/vnd.sas.annotation.member"
                  },
                  {
                      "method": "DELETE",
                      "rel": "delete",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/13aab93d-7699-4f17-8074-0953d1183020",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members/13aab93d-7699-4f17-8074-0953d1183020"
                  },
                  {
                      "method": "GET",
                      "rel": "up",
                      "href": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members",
                      "uri": "/annotations/annotations/26e2df43-aeaf-475d-a64e-7baafb8a4eca/members",
                      "type": "application/vnd.sas.annotation.member",
                      "responseType": "application/vnd.sas.annotation.member"
                  }
              ]
          }
      ],
      "limit": 2147483647,
      "version": 2
  }
```

version 2, last updated 19 Dec, 2018