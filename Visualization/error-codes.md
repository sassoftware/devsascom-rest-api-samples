#### Levels of Severity

**Fatal Errors**

For errors from which there is no recovery, or for errors that are caused
by unexpected system problems, the API uses the standard error response
type to propagate error messages and codes to the client:
`application/vnd.sas.error`.

The same response occurs when the request parameters or body
cannot be processed by Spring prior to the service code being called.
Fatal errors return immediately to the client with a 400 or 500 level
`application/vnd.sas.error` response.

**Severe Errors**

Not all error codes are returned as `application/vnd.sas.error`. Many
are caught and recorded, but do not immediately halt the transformation.
This permits a response of type `application/vnd.sas.report.transform`
and getting information about the problem.

A typical case is when there are mismatches between variables in
original and replacement data sources. Each mismatch by itself prevents
the overall transform from being completed, but processing must continue
because the application wants to know about all the errors in the
response. In this case, the error code is returned with a localized
message in the transform's "`errorMessages`" list, which lets the
application interpret the error codes.

Severe errors do prevent the transformation from completing. For
example, if columns cannot be matched when creating `dataMappedReports`,
the response transform's BIRD report will not be altered, or, if the
result was supposed to be saved to a new BIRD report, nothing will be
persisted.

Schema validation errors and warnings do not necessarily stop processing
of the transform. If the process can continue, it will; but generally,
if the client requires processing a report that is not schema-valid, it
should override the query parameter "`validate=false`" to cause the
process to skip validation entirely.



**Problems**

Questionable values or situations in the report are recorded in the
response transform's `messages` list. If the transform action is to
create semantic evaluation, this is where to look for individual
problems. These messages have an error code value of zero.

#### Error Code Table

Errors are grouped by functional area. Some of the errors are shared
by endpoints that use common platform services.

| HTTP Status Code       |Error Code | Resource(s)        |Description                                                           |Severity                  |
|----------------|-----------|--------------------|----------------------------------------------------------------------|--------------------------|
| 200(+msgs)     | 27505     | dataMappedReports  | Data: Cannot change the data source as specified.                    | Severe: Result returned, but left unchanged.|
| 200(+msgs)     | 27506     | dataMappedReports  | Data: Cannot obtain data service executor                            | Severe                   |
| 200(+msgs)     | 27507     | dataMappedReports  | Data: Cannot obtain data service executor                           | Severe                    |
| 200(+msgs)     | 27508     | dataMappedReports  | Data: Failure in getting metadata about replacement table.          | Severe: Usually means the replacement table doesn't exist. |
| 200(+msgs)     | 27510     | dataMappedReports  | Data: No replacement data source was specified.                     | Fatal: No attempt was made  to change anything. |
| 200(+msgs)     | 27511     | dataMappedReports  | Data: One or more source columns could not be matched to a replacement. | Severe               |
| 200(+msgs)     | 27512     | dataMappedReports  | Data: Original and replacement column names do not match.           | Severe                   |
| 200(+msgs)     | 27513     | dataMappedReports  | Data: Original column usage conflicts with replacement column usage attribute.| Severe         |
| 200(+msgs)     | 27515     | dataMappedReports  | Data: Transform data change parameters are inconsistent.            | Severe                    |
| 200(+msgs)     | 27532     | dataMappedReports, translationworksheets  | Report repository: Invalid folder URI for writing result report.    | Severe: Changes to transform  may have happened but report content was not saved. |
| 200(+msgs)     | 27533     | dataMappedReports, translationworksheets|  Report repository: Invalid report URI         | Severe: Changes to transform may have happened, but report content persistence failed |
| 200(+msgs)     | 27540     | ALL                | Schema: Report failed schema validation                             | Severe. Validation completed. See the messages. |
| 200(+msgs)     | 27541     | ALL                | Schema: XML Schema processing failed or schema not found            | Severe. Validation was skipped, but other processing continued.                 |
| 200(+msgs)     | 27541     | translatedReports | The requested localization not present in report                     | Severe                    |
| 200(+msgs)     | 27560     | translationWorksheets | Worksheet: empty or otherwise invalid worksheet content           | Severe                   |
| 400           | 27509     | dataMappedReports  | Data: Invalid combination of original and replacement data sources. | Fatal                      |
| 400           | 27514     | dataMappedReports  | Data: The replacement data source specified was not found.          | Fatal                      |
| 400           | 27534     | convertedReports   | Report: converting between XML and JSON formats failed.              | Fatal                    |
| 400           | 27535     | ALL                | Report: Input BIRD report content is invalid.                        | Fatal                    |
| 400           | 27537     | dataMappedReports, translationworksheets, translatedReports  | Report content is not present in transform.                       | Fatal                     |
| 400           | 27570     | rethemedReports    | The specified report theme does not exist.                           | Fatal                     |
| 409,412,428   | 27561     | translationWorksheets | Worksheet: Update failed because report has changed or precondition omitted or precondition incorrect              | Fatal                     |
| 500, 403      | 27530     | dataMappedReports, translationworksheets  |  Report repository: content read failed.                            | Fatal                     |
| 500, 403      | 27531     | dataMappedReports, translationworksheets, translatedReports|  Report repository: content write failed.                            | Fatal                     |
| 500           | 27536     | ALL                | Report: JSON content serialization or deserialization failed.        | Fatal                    |
| 500           | 27550     | translatedReports  | Translation failure with unknown cause.                              | Fatal                    |