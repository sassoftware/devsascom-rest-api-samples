# Report Transforms API

##### Purpose
This API helps applications create relatively simple  Business Intelligence Report Definition (BIRD) reports that they can display via Visual Analytics viewers. More specifically, this API provides simple alterations of BIRD reports for some of the most common application requirements. A typical transformation is to replace one or more data source(s) in an existing report with different data source(s).

The API is designed as a general "report transformation" protocol so it will be extensible to other purposes than the initial scenarios.

##### Resources
The `application/vnd.sas.report.transform` resource is a description of how a BIRD report is to be transformed or has been transformed. As the body of a request, the transform resource object can contain the BIRD report content as an input, or it can contain a reference to a report resource in the repository. Likewise, in a response the transform can contain the modified content of a report or a reference to a report resource that has been saved. The report content is the same format as for the media type `application/vnd.sas.report.content`, which is XML or JSON .

The transform also has attributes to describe what should be done, or what has been done, to produce the "transformed report".

A transform's specified actions are required to be quick and synchronous. Transform actions must not take so long that an asynchronous job creation would be necessary.

#### Data Source Change Use Case

Substitute one Cloud Analytic Services (or CAS) data source resource for another in a report, assuring that the substituted data source is compatible with how the original data source is used in the report.

This is one of the primary motivations for the service. It is typical for a standard report or reports to be created by a customer that should be periodically replicated for new or updated data sets. For example, each month a customer creates a new dataset with the most current data, and the customer wants to replicate the report while substituting in the new dataset; or perhaps the customer has similar datasets for each department in the company, and a report writer user wants to create a report once and then use an automated process to replicate it for each department.

#### Localization/Translation Use Case

Create copies of a report translated into multiple languages. Globalization services wants to create an automated process where translators create translations of a report in multiple languages. There are a multiple steps in this process.

* A report is created in an initial language, which is the creating author's locale. (Author need not be a translator.)
* A "translator's localization worksheet" is generated from the report. The worksheet contains all the strings in the report that can be shown the user in different languages.
* A human translator translates the strings in a copy of the worksheet into a new language.<code>++</code>
* The translated worksheet is submitted back to the report and saved in it. (The report is actually modified by inserting a Locale).<code>++</code>
* A copy of the report can be retrieved that substitutes the new languages strings into the body of the report.<code>++</code>

Additional languages can be provided by repeating the above steps marked with <code>++</code> for different locales.


#### Retheming Use Case

Create copies of a report with different themes. Customers will need this in promotion scenarios, such as dev/test/prod, where the new space uses different themes from the old space. This use case allows for automated theme changes instead of going through a user interface to change each report's theme.

## API Request Examples Grouped by Object Type

<details>
<summary>Conversion</summary>

* [Converting Reports](#ExampleConvertingReports)
</details>

<details>
<summary>Evaluation</summary>

* [Getting a Semantic Evaluation of a Report](#EvaluatedReports)
</details>

<details>
<summary>Translation</summary>

* [Extracting a Language Worksheet from a Report](#ExampleLocalizing1)
* [Adding a Language Worksheet to a Report](#ExampleLocalizing2)
* [Translating a Report](#ExampleLocalizing3)
</details>

<details>
<summary>Data Change</summary>

* [Changing Data Source in Report](#ExampleChangeDataSource)
</details>


### <a name='ExampleConvertingReports'>Converted Reports: Change a Report From XML to JSON format</a>

**Request:**

```text
POST /reportTransforms/convertedReports/?validate=true HTTP/1.1
Content-Type: application/vnd.sas.report.content+xml
Accept: application/vnd.sas.report.transform+json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsImtpZCI6ImxlZ2FjeS10b2tlbi1rZXkiLCJ0eXAiOiJKV1QifQ...
....Abbreviated Body follows that is just the BIRD Report XML...
```
```xml
<SASReport label="Test Transform CARS Report 1" 
           createdVersion="4.0.1.20160330_scaleType" 
           dateCreated="2016-04-21T18:22:31Z" 
           dateModified="2016-04-21T18:22:31Z"
           createdApplication="SAS Visual Analytics 8.2" 
           nextUniqueNameIndex="1479">
    <DataDefinitions>
        <ParentDataDefinition childQueryRelationship="independent" dataSource="ds10" name="dd24">
            <!-- SNIP -->
        </ParentDataDefinition>
    </DataDefinitions>
    <DataSources>
        <DataSource label="CARS" type="relational" name="ds10">
            <CasResource server="BIRD-English" library="HPS" table="CARS" locale="en_US"/>
            <!-- SNIP -->
        </DataSource>
    </DataSources>
    <VisualElements>
        <Table resultDefinitions="dd26" name="ve22" data="dd24" label="List Table 1">
            <!-- SNIP -->
        </Table>
    </VisualElements>
    <View>
        <Section name="vi6" label="Page 1">
            <!-- SNIP -->
        </Section>
    </View>
    <MediaSchemes>
        <!-- SNIP -->
    </MediaSchemes>
    <MediaTargets>
        <!-- SNIP -->
    </MediaTargets>
    <History>
        <!-- SNIP -->
    </History>
</SASReport>

```

**Response:** 

The response transform provides information about the requested schema
validation, links for other actions, and the report itself in the value
of the transform's `reportContent` attribute. Because the internals of
the BIRD report are in JSON format are not the point, the following code has
been edited for brevity.

```json
{
    "id": "d672d8ce-20ec-4ea0-9280-75b3e1febe76",
    "creationTimeStamp": "2017-09-01T14:29:36.716Z",
    "createdBy": "userid",
    "modifiedTimeStamp": "2017-09-01T14:29:36.716Z",
    "modifiedBy": "userid",
    "schemaValidationStatus": "schemaValid",
    "messages": [
        {
            "code": 0,
            "text": "Report is syntactically valid against schema: 4.0.4"
        }
    ],
    "evaluation": [],
    "errorMessages": [],
    "dataSources": [],
    "links": [
        {
            "method": "POST",
            "rel": "createDataMappedReport",
            "type": "application/vnd.sas.report.transform",
            "responseType": "application/vnd.sas.report.transform",
            "title": "Change Data Source",
            "href": "/reportTransforms/dataMappedReports/"
        },
        {
            "method": "POST",
            "rel": "extractTranslationWorksheet",
            "type": "application/vnd.sas.report.transform",
            "responseType": "text/plain",
            "title": "Extract a localization worksheet from the report",
            "href": "/reportTransforms/translationWorksheets/{translationLocale}"
        },
        {
            "method": "PUT",
            "rel": "updateTranslationWorksheet",
            "type": "text/plain",
            "title": "Update the localization in the report",
            "href": "/reportTransforms/translationWorksheets/{reportId}/{translationLocale}"
        },
        {
            "method": "POST",
            "rel": "createTranslatedReport",
            "type": "application/vnd.sas.report.transform",
            "responseType": "application/vnd.sas.report.transform",
            "title": "Translate Report",
            "href": "/reportTransforms/translatedReports/{translationLocale}"
        },
        {
            "method": "POST",
            "rel": "createConvertedReport",
            "type": "application/vnd.sas.report.transform",
            "responseType": "application/vnd.sas.report.transform",
            "title": "Convert to XML or JSON",
            "href": "/reportTransforms/convertedReports"
        },
        {
            "method": "POST",
            "rel": "createEvaluatedReport",
            "type": "application/vnd.sas.report.transform",
            "responseType": "application/vnd.sas.report.transform",
            "title": "Semantically Evaluate",
            "href": "/reportTransforms/evaluatedReports/"
        }
    ],
    "reportContent": {
        "@element": "SASReport",
        "xmlns": "http://www.sas.com/sasreportmodel/bird-4.0.3.20170816_graphType",
        "label": "Test Transform CARS Report 1",
        "dateCreated": "2016-04-21T18:22:31Z",
        "createdApplicationName": "SAS Visual Analytics 8.1",
        "dateModified": "2016-04-21T18:22:31Z",
        "createdVersion": "4.0.1.20160330_scaleType",
        "nextUniqueNameIndex": 1479,
        "results": [],
        "dataDefinitions": [
        ],
        "dataSources": [          
        ],
        "visualElements": [
        ],
        "view": {
        }
    }
}
```

### <a name='EvaluatedReports'>Evaluated Reports: Getting a Semantic Evaluation of a Report</a>

This example uses the service to semantically evaluate a report
in the repository. It specifies the report using the query parameter
`useSavedReport` and the report's resource URI in the body of the
request transform object.

**Request**

```text
POST /reportTransforms/evaluatedReports/?validate=true&useSavedReport=true HTTP/1.1
Host: example.sas.com:8080
Content-Type: application/vnd.sas.report.transform+json
Accept: application/vnd.sas.report.transform+json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsImtpZCI6ImxlZ2FjeS10...
Accept-Language: de-DE
{
  "inputReportUri":"/reports/reports/ec3165a1-07a0-4950-a8cb-2f6405ea53f5",
  "resultReportName":null,
  "resultParentFolderUri":null,
  "messages": [],
  "evaluation": [],
  "links": [],
  "dataSources": [],
  "reportContent": null
}

```
**Response:**

The report was validated against the schema that was declared in the report.  It was then evaluated by a series of rules that check relationships and dependencies in the report that the schema cannot catch. The warnings or errors will appear in the list `evaluation` attribute. This report has a dangling reference in a CSS style. There is nothing the client can do about this particular case, but it could be useful information for debugging problems with reports, perhaps in situations where the client needs to communicate diagnostic information to SAS Technical Support.

The semantic evaluation messages are at one of the following levels: `info`, `warning` or `error`.  Generally, `info` and `warning` messages indicate issues that should not prevent viewing or editing the report. Evaluation errors indicate values or structures that may cause problems visible to the user. Note that the text of the evaluation messages and whether or not evaluation codes are provided in the messages is indirectly provided by the Report Transforms Service. The text and codes in the messages are generated directly by the BIRD model library code.

The `evaluation` messages are essentially a sequential text log generated by the BIRD model as it traverses the internals of the BIRD `SASReport` element.

```json
{
    "id": "dc28ec92-928c-493a-8b74-e94cc391e898",
    "creationTimeStamp": "2017-09-01T15:32:28.987Z",
    "createdBy": "username",
    "modifiedTimeStamp": "2017-09-01T15:32:29.048Z",
    "modifiedBy": "username",
    "schemaValidationStatus": "schemaValid",
    "messages": [
        {
            "code": 0,
            "text": "Report is syntactically valid against schema: 4.0.3.20170816_graphType"
        },
        {
            "code": 0,
            "text": "Evaluation of report was requested and attempted."
        }
    ],
    "evaluation": [
        "Evaluation report generation starting.",
        "(Warning) MediaScheme ms1: One of the CSS styles refers to a missing element: cd227",
        "End of semantic evaluation report."
    ],
    "errorMessages": [],
    "dataSources": [],
    "inputReportUri": "/reports/reports/ec3165a1-07a0-4950-a8cb-2f6405ea53f5",
    "links": [
        {
            "method": "POST",
            "rel": "createDataMappedReport",
            "type": "application/vnd.sas.report.transform",
            "responseType": "application/vnd.sas.report.transform",
            "title": "Change Data Source",
            "href": "/reportTransforms/dataMappedReports/"
        },
        {
            "method": "POST",
            "rel": "extractTranslationWorksheet",
            "type": "application/vnd.sas.report.transform",
            "responseType": "text/plain",
            "title": "Extract a localization worksheet from the report",
            "href": "/reportTransforms/translationWorksheets/{translationLocale}"
        },
        {
            "method": "PUT",
            "rel": "updateTranslationWorksheet",
            "type": "text/plain",
            "title": "Update the localization in the report",
            "href": "/reportTransforms/translationWorksheets/{reportId}/{translationLocale}"
        },
        {
            "method": "POST",
            "rel": "createTranslatedReport",
            "type": "application/vnd.sas.report.transform",
            "responseType": "application/vnd.sas.report.transform",
            "title": "Translate Report",
            "href": "/reportTransforms/translatedReports/{translationLocale}"
        },
        {
            "method": "POST",
            "rel": "createConvertedReport",
            "type": "application/vnd.sas.report.transform",
            "responseType": "application/vnd.sas.report.transform",
            "title": "Convert to XML or JSON",
            "href": "/reportTransforms/convertedReports"
        },
        {
            "method": "POST",
            "rel": "createEvaluatedReport",
            "type": "application/vnd.sas.report.transform",
            "responseType": "application/vnd.sas.report.transform",
            "title": "Semantically Evaluate",
            "href": "/reportTransforms/evaluatedReports/"
        }
    ],
    "reportContent": {
        "@element": "SASReport",
        "xmlns": "http://www.sas.com/sasreportmodel/bird-4.0.3.20170816_graphType",
        "label": "Alert Req Freq Renamed One",
        "dateCreated": "2017-08-24T13:20:39Z",
        "createdApplicationName": "SAS Visual Analytics 8.2",
        "dateModified": "2017-08-24T13:53:22Z",
        "lastModifiedApplicationName": "SAS Visual Analytics 8.2",
        "createdVersion": "4.0.3.20170816_graphType",
        "createdLocale": "en",
        "nextUniqueNameIndex": 93,
        "results": [],
        "dataDefinitions": [  ".....snipped....." ],
        "dataSources": [  ".....snipped....." ],
        "visualElements": [  ".....snipped....." ],
        "promptDefinitions": [],
        "view": {
            "@element": "View",
            "sections": [  ".....snipped....." ]
        },
        "actions": [],
        "interactions": [],
        "conditions": {
            "@element": "Conditions",
            "conditionList": [  ".....snipped....." ], 
            "rangeList": []
        },
        "mediaSchemes": [  ".....snipped....." ],
        "mediaTargets": [  ".....snipped....." ],
        "properties": [  ".....snipped....." ],
        "reportParts": [],
        "groupings": [],
        "customSorts": [],
        "dataSourceMappings": [],
        "exportProperties": []
    }
}
```

### <a name='ExampleLocalizing1'>Localizing a Report: (1) extracting the language worksheet</a>

**Request**

```text
GET /reportTransforms/translationWorksheets/ec3165a1-07a0-4950-a8cb-2f6405ea53f5/fr-FR HTTP/1.1
Host: example.sas.com:7980
Accept: text/plain;charset=UTF-8
Authorization: Bearer eyJhbGciOiJIUzI1NiIsI...snip...
Cache-Control: no-cache
```
**Response:**

The first line of the worksheet is always the locale. It should match the requested language code, but if the report has not been previously translated, it may be the original or "author" locale. The subsequent lines are generated by the service, and each line defines a translatable string that may be visible in any rendering of the report. How the translated strings are applied depends somewhat on the renderer: editor, print, or viewer. The form of the lines:

```text
identifier =  translatable string 
```

The identifier to the left of "=" should not be modified. The translatable string to the right is changed by the translator, as needed, and the worksheet is PUT back to the report to keep it for future translation of the report in that language.  Before sending the worksheet back to the report, the locale on the first line should be changed to match the target language.

```text
fr-FR
vi6.Section.label = Page 1 Bars Chart Shows Trend Clearly
vi78.Section.label = Page 2 Scatter
ve38.Graph.label = Auto Chart 1
ve47.Graph.label = Auto Chart 2
bi11.DataItem_AIRPORT4_NETWORK_centr_degree_out.label = centr_degree_out
bi15.DataItem_AIRPORT4_NETWORK_DestCityLat.label = Dest City Latitude
bi16.DataItem_AIRPORT4_NETWORK_DestCityLng.label = Dest City Longitude
bi18.DataItem_AIRPORT4_NETWORK_DestCityName.label = Dest City Name
bi19.DataItem_AIRPORT4_NETWORK_DestState.label = Destination State
bi24.DataItem_AIRPORT4_NETWORK_Origin.label = Origin Code
bi28.DataItem_AIRPORT4_NETWORK_OriginCityLng.label = OriginCity Latitude
bi29.DataItem_AIRPORT4_NETWORK_OriginCityMarketID.label = Origin City MarketID
bi31.DataItem_AIRPORT4_NETWORK_OriginState.label = Origin State Code
bi33.DataItem_AIRPORT4_NETWORK_OriginStateName.label = Origin State Name
bi35.SourcePredefinedDataItem_AIRPORT4_NETWORK.label = Frequency
```



### <a name='ExampleLocalizing2'>Localizing a Report: (2) Adding a Localization Language Worksheet to a Report</a>

After the translator is done, the localization worksheet is put into the report.  Schema validation is suppressed.

**Request:**

```text
PUT /reportTransforms/translationWorksheets/ec3165a1-07a0-4950-a8cb-2f6405ea53f5/de/?validate=false HTTP/1.1
Host: example.com:7980
Content-Type: text/plain
If-Match: "j6qszoqh"
Authorization: Bearer eyJhbGciOiJIUzI1NiIsImtpZCI6Imx...

de
vi6.Section.label = Seite 1 Balkendiagramm zeigt deutlich die Richtung
vi78.Section.label = Seite 2 Punktdarstellung
ve38.Graph.label = Auto Grafik 1
ve47.Graph.label = Auto Grafik 2
bi11.DataItem_AIRPORT4_NETWORK_centr_degree_out.label = Grad der Zentralität
bi15.DataItem_AIRPORT4_NETWORK_DestCityLat.label = Dest Stadt Latitude
bi16.DataItem_AIRPORT4_NETWORK_DestCityLng.label = Dest Stadt Longitude
bi18.DataItem_AIRPORT4_NETWORK_DestCityName.label = Dest Stadt Name
bi19.DataItem_AIRPORT4_NETWORK_DestState.label = Destination State
bi24.DataItem_AIRPORT4_NETWORK_Origin.label = Abfahrt Code
bi28.DataItem_AIRPORT4_NETWORK_OriginCityLng.label = Abfahrt Stadt Latitude
bi29.DataItem_AIRPORT4_NETWORK_OriginCityMarketID.label = Abfahrt Stadt Markt ID
bi31.DataItem_AIRPORT4_NETWORK_OriginState.label = Abfahrt State Code
bi33.DataItem_AIRPORT4_NETWORK_OriginStateName.label = Abfahrt State Name
bi35.SourcePredefinedDataItem_AIRPORT4_NETWORK.label = Frequenz
```
**Response:**
```200 OK```


### <a name='ExampleLocalizing3'>Localizing a Report: (3) Translating a report to a different language.</a>

After adding the localization worksheet to the report for the given locale, the report can be requested with all strings substituted into the body of the report from the worksheet.  To get the AIRPORT4_NETWORK report in German the following request is made.

**Request:**

```text
GET /reportTransforms/translatedReports/ec3165a1-07a0-4950-a8cb-2f6405ea53f5/fr/?validate=true HTTP/1.1
Host: example.sas.com:7980
Accept: application/vnd.sas.report.transform+json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsImtpZCI6ImxlZ2FjeS10b2tlb
```

**Response:**

The report is returned as the value of `reportContent` in the transform.  Its internal strings have been translated to German.

```json
{
    "id": "5afe5326-64d7-4110-9fe9-a47507cf1ce2",
    "creationTimeStamp": "2017-09-01T17:41:18.856Z",
    "modifiedTimeStamp": "2017-09-01T17:41:18.856Z",
    "messages": [],
    "evaluation": [],
    "errorMessages": [],
    "dataSources": [],
    "links": [
        {
            "method": "GET",
            "rel": "getReport",
            "href": "/reports/reports/ec3165a1-07a0-4950-a8cb-2f6405ea53f5",
            "uri": "/reports/reports/ec3165a1-07a0-4950-a8cb-2f6405ea53f5",
            "type": "application/vnd.sas.report"
        },
        "....snip...."
    ],
    "reportContent" : {
       "....snipped-out....report-content-with-translated-labels....."
    }   
}
```

### <a name ='ExampleChangeDataSource'>Changing Data Sources in a Report</a>

**Request**

```
POST /reportTransforms/dataMappedReports/ec3165a1-07a0-4950-a8cb-2f6405ea53f5/?validate=true&useSavedReport=true&saveResult=false&failOnDataSourceError=false HTTP/1.1
Host: example.sas.com:7980
Content-Type: application/vnd.sas.report.transform+json
Accept: application/vnd.sas.report.transform+json
Authorization: Bearer eyJhbGciOiJIUzI1NiIsImtpZCI6ImxlZ2FjeS10b2tlbi1rZ.....
```
Body:
```json
{
  "inputReportUri": "/reports/reports/2808508e-c3e4-4309-9d79-071001493cc0",
  "dataSources": [
    {
      "namePattern": "serverLibraryTable",
      "purpose": "replacement",
      "server": "cas-qstgrd-default",
      "library": "HPS",
      "table": "I18N.MAILORDERDEMO_JA",
      "replacementLabel": "Japanese Version of Mail Order",
      "port": "8080",
      "dataItemReplacements": [
        {
          "originalName": "bi14",
          "originalColumn": "catalogue",
          "replacementColumn": "CATALOG"
        }
      ]
    },
    {
      "namePattern": "uniqueName",
      "purpose": "original",
      "uniqueName": "ds10"
    }
  ],
  "xmlReport": null,
  "jsonReport": null
}

```
**Response**:
```json
{
    "id": "5afe5326-64d7-4110-9fe9-a47507cf1ce2",
    "creationTimeStamp": "2017-09-01T17:41:18.856Z",
    "modifiedTimeStamp": "2017-09-01T17:41:18.856Z",
    "messages": [],
    "evaluation": [],
    "errorMessages": [],
    "dataSources": [],
    "links": [
        {
            "method": "GET",
            "rel": "getReport",
            "href": "/reports/reports/ec3165a1-07a0-4950-a8cb-2f6405ea53f5",
            "uri": "/reports/reports/ec3165a1-07a0-4950-a8cb-2f6405ea53f5",
            "type": "application/vnd.sas.report"
        },
        "....snip...."
    ],
    "reportContent" : {
       "snip" : "snipped-report-content"
    }   
}
```

Properly remapping a data source in a report to another data source is not a trivial rewriting of `server`, `table`, and `library` names on the BIRD DataSource element. The difficulty depends on the original and replacement data sources. If the replacement is a newer version of the same data table that has the same-named data items, it can be remapped by changing the CasResource table name. If columns have been added, omitted, or renamed on the replacement data source, it is more complicated, and requires some interaction with the user.  When the user is involved, the process can be iterative, and the user can make decisions about what columns match and how to resolve errors.

These are the typical stages of processing when the user participates:

1. Application sends request with `failOnError = true`
1. Application checks for `errorMessages` in the response transform.
1. If no `errorMessages` were returned, we are done. The response's report contains all changes.
1. Otherwise, the application asks the user to resolve problems by selecting replacements for the existing data items that did not match the new data source.  The application then creates mappings (`dataItemReplacements`) for those data columns.
1. The application sends a request again, with the data item mappings and the query parameter `failOnError = false`. This forces all changes to be made and all mappings to be applied.
1. With `failOnError = false`, errors could still occur and be returned, but the caller gets them in the `messages` of the response transform (not `errorMessages`).

For more information on the messages and errorMessages see the section [on Error Codes](Visualization/error-codes.md).

version 2, last updated 19 Dec, 2018
