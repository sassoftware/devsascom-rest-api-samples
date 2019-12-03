# Report Images API
The Report Images service delivers SVG images that represent either an
entire report or elements of a report. Clients that present a view of
the folder structure or thumbnails of a report are candidates for using
this service.

For example, you want to produce an image that is representative of an
entire report. You create a job which returns 'state==running'. Then you
poll (following the "self" link) until the job is completed. When
completed, the job returns a URI, which is then passed to the browser
for rendering.

By default a single image that represents the report is produced at the
requested size. This is equivalent to the option selectionType=report.
To create one image per section, specify selectionType=perSection.
## API Request Examples Grouped by Object Type
<details>
<summary>Root</summary>

* [Discover top level links for reportImages service (non-admin user)](#top-level-links)
</details>

<details>
<summary>Jobs</summary>

* [Create simple job, single image for the report](#create-simple-job)
* [Poll for job completion, 10 second timeout](#poll-for-job-completion)
* [Create job, one image per section](#create-job-per-section)
* [Create job, entire section, using request parameters](#create-job-entire-section)
* [Create job, entire section, all sections, render limit](#create-job-all-sections)
</details>

<details>
<summary>SVG Images</summary>

* [Getting an image](#getting-an-image)
</details>



### <a name='top-level-links'>Discover top level links for reportImages service (non-admin user)</a>

**Request**
```
 GET http://www.example.com/reportImages/
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
       "method": "POST",
       "rel": "createJob",
       "href": "/reportImages/jobs",
       "uri": "/reportImages/jobs",
       "type": "application/vnd.sas.report.images.job.request",
       "responseType": "application/vnd.sas.report.images.job"
     },
     {
       "method": "POST",
       "rel": "createJobWithParameters",
       "href": "/reportImages/jobs",
       "uri": "/reportImages/jobs",
       "responseType": "application/vnd.sas.report.images.job"
     }
   ]
 }
```


### <a name='create-simple-job'>Create simple job, single image for the report.</a>

**Request**
```
  POST http://www.example.com/reportImages/jobs
  Headers:
  * Accept = application/vnd.sas.report.images.job+json
  * Content-Type = application/vnd.sas.report.images.job.request+json
  Body:
  {
    "reportUri" : "/reports/reports/d32f...",
    "layoutType" : "normal",
    "selectionType" : "report",
    "size" : "400x300",
    "version" : 1
  }
```

**Response**
This assumes the job completes within the timeout.  (IDs have been shortened for readability.)
```
 Status: 201
 Headers:
 * Content-Type = application/vnd.sas.report.images.job+json
 * Location = /reportImages/jobs/f820...
 Body:
 {
   "id": "f820...",
   "version": 1,
   "links": [
     {
       "method": "GET",
       "rel": "self",
       "href": "/reportImages/jobs/f820...",
       "uri": "/reportImages/jobs/f820...",
       "type": "application/vnd.sas.report.images.job"
     },
     {
       "method": "GET",
       "rel": "state",
       "href": "/reportImages/jobs/f820.../state",
       "uri": "/reportImages/jobs/f820.../state",
       "type": "text/plain"
     },
     {
       "method": "POST",
       "rel": "renderAll",
       "href": "/reportImages/jobs?selectionType=report&size=400x300&reportUri=/reports/reports/d32f...&layoutType=normal",
       "uri": "/reportImages/jobs?selectionType=report&size=400x300&reportUri=/reports/reports/d32f...&layoutType=normal",
       "type": "application/vnd.sas.report.images.job"
     }
   ],
   "state": "completed",
   "duration": 0.114,
   "creationTimeStamp": "2017-07-17T17:20:42.647Z",
   "images": [
     {
       "sectionIndex": 0,
       "sectionName": "vi6",
       "sectionLabel": "Page 1",
       "elementName": "ve40",
       "visualType": "pie",
       "size": "400x300",
       "state": "completed",
       "links": [
         {
           "method": "GET",
           "rel": "image",
           "href": "/reportImages/images/K1380786238B1359240829.svg",
           "uri": "/reportImages/images/K1380786238B1359240829.svg",
          "type": "image/svg+xml"
         },
         {
           "method": "POST",
           "rel": "render",
           "href": "/reportImages/jobs?selectionType=visualElements&size=400x300&reportUri=/reports/reports/d32f...&layoutType=normal&visualElementNames=ve40",
           "uri": "/reportImages/jobs?selectionType=visualElements&size=400x300&reportUri=/reports/reports/d32f...&layoutType=normal&visualElementNames=ve40",
           "type": "application/vnd.sas.report.images.job"
         },
         {
           "method": "POST",
           "rel": "resize",
           "href": "/reportImages/jobs?selectionType=visualElements&reportUri=/reports/reports/d32f...&layoutType=normal&visualElementNames=ve40&size={size}",
           "uri": "/reportImages/jobs?selectionType=visualElements&reportUri=/reports/reports/d32f...&layoutType=normal&visualElementNames=ve40&size={size}",
           "type": "application/vnd.sas.report.images.job"
         }
       ]
     }
   ]
 }
```


**ALTERNATE response**
This assumes the job does NOT complete within the timeout.
```
 Status: 202
 Headers:
 * Content-Type = application/vnd.sas.report.images.job+json
 * Location = /reportImages/jobs/f196...
 Body:
{
  "id": "f196...",
  "version": 1,
  "links": [
    {"self"... },
    {"state"... },
    {"renderAll"... }
  ],
  "state": "running",
  "creationTimeStamp": "2017-07-17T17:24:23.779Z"
}
```

### <a name='poll-for-job-completion'>Poll for job completion, 10 second timeout</a>

**Request**
```
  GET http://www.example.com/reportImages/jobs/b593...?wait=10.0
  Headers:
  * Accept = application/vnd.sas.report.images.job+json
```

**Response**
(assuming complete by now, otherwise state = "running"...)
Key differences:

* state==completed

* each image (just 1 here) has link "image".

(Output is the same as the 201 status example above, except that status = 200.)


### <a name='create-job-per-section'>Create job</a>
One image per section at 200x300; delay up to 300 mSec before returning.

**Request**
```
  POST http://www.example.com/reportImages/jobs?wait=0.3
  Headers:
  * Accept = application/vnd.sas.report.images.job+json
  * Content-Type = application/vnd.sas.report.images.job.request+json
  Body:
  {
    "reportUri" : "/reports/reports/d32f...",
    "layoutType" : "thumbnail",
    "selectionType" : "perSection",
    "size" : "200x300",
    "version" : 1
  }
```

### <a name='create-job-entire-section'>Entire Section</a>
Render the 1st entire section, using request parameters.  Other sections could be specified using parameter `sectionIndex`.  Use form taking request parameters rather than a body.

**Request**
```
  POST http://www.example.com/reportImages/jobs?layoutType=entireSection&selectionType=report&size=800x1200&wait=30&reportUri=/reports/reports/d32f...&wait=20
  Headers:
  * Accept = application/vnd.sas.report.images.job+json
```

### <a name='create-job-all-sections'>First Section, metadata and links for other sections</a>
Similar to above, but request all sections with a render limit of 1. (This example uses the request body approach.) This request also uses the `refresh` option which bypasses all caches and forcibly generates a new image.

```
  POST http://www.example.com/reportImages/jobs
  Headers:
  * Accept = application/vnd.sas.report.images.job+json
  * Content-Type = application/vnd.sas.report.images.job.request+json
  Body:
  {
    "reportUri" : "/reports/reports/d32f...",
    "layoutType" : "entireSection",
    "selectionType" : "perSection",
    "size" : "800x1200",
    "renderLimit" : 1,
    "sectionIndex" : 0,
    "refresh" : true,
    "version" : 1
  }
```

### <a name='getting-an-image'>Getting an image</a>
**Request**

The URL below comes from the `image` link in the _completed_ example above.

(optionally send request header "If-None-Modified")
```
  GET http://www.example.com/reportImages/images/K738605462B1380786238.svg
  Headers:
  * Accept = image/svg+xml
```

**Response**
(note cache headers: "Cache-Control", "Expires" & "Pragma".)
```
Status: 200
 Headers:
 * Content-Type = image/svg+xml
 * ETag = "K131214052B1471096127"
 * Cache-Control = private, max-age=604800
 * Expires = Mon, 24 Apr 2017 16:30:16 GMT
 * Pragma =  (empty string)
 Body:
   "<svg xmlns=..." (the actual image)
```
version 1, last updated 18 Jan, 2019