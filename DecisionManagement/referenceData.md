# Reference Data API
Reference data defines key business values that are needed to be leveraged across many different processes within an organization. This is done by creating a central point for an organization to manage and reference the data. Reference data values are often used to group other data.

Here are some examples of reference data:

 * a list of country codes
 * a list of units suitable for measuring length
 * a list of service level agreements and what each level stands for
 * a mapping of companies to industry segments

Note: These examples show the use of reference data as providing standards, types and codes, taxonomy, and relationships. Reference data can change at different intervals but changes are generally controlled and in most cases do not happen frequently.

Reference data can be used in multiple ways. Reference data that provides criteria for a customer loyalty program can be used in expressions in business rules that when executed, will render a conclusion about something. Reference data that provides specifications of financial products can be used across layers of a financial enterprise to ensure the integrity of inter-operation with third parties.

Reference data appear in lookup tables. A lookup table provides a link from one value to another value. For example, a lookup table of product codes allows a product to be identified using a code.

Reference data can be defined by standard bodies or by an organization for standardizing its own information. For the latter case, there is a need for properly managing reference data as the data are often used in a wide range of applications within the organization.

The Reference Data API supports the life cycle of reference data from creation to CRUD operations to production publishing. This API provides an important aspect of reference data management by providing the history of data values.

Version 1.0 of the Reference Data API supports reference data in lookup table form.


#### Why Use this API?

* Users can create reference data.
* Users can manage their changes over time.
* Data can be labeled in support of an organization's workflow.
* Data can be published for use by a SAS application such as SAS Decision Manager in various execution environments such as the Cloud Analytic service.
* Migrate the reference data to other SAS deployments.
* Support the identification of the data values at any point in time.
* Delete the reference data and its associated artifacts.

## API Request Examples Grouped by Object Type

<details>
<summary>CRUD Reference Data Domain</summary>

* [Create a Reference Data Domain](#CreateReferenceDataDomain)
* [Get a Reference Data Domain](#GetReferenceDataDomain)
* [Delete a Reference Data Domain](#DeleteReferenceDataDomain)
* [Get the Collection of Reference Data Domains](#GetCollectionReferenceDataDomains)
</details>

<details>
<summary>CRUD Reference Data Domain Content</summary>

* [Create a Reference Data Domain Content](#CreateReferenceDataDomainContent)
* [Update a Reference Data Domain Content](#UpdateReferenceDataDomainContent)
* [Get a Reference Data Domain Content](#GetReferenceDataDomainContent)
* [Delete a Reference Data Domain Content](#DeleteReferenceDataDomainContent)
* [Get a Reference Data Domain Content Collection](#GetReferenceDataDomainContentCollection)
* [Add or Replace Entries in a Reference Data Domain Content](#AddReplaceEntriesReferenceDataDomainContent)
* [Modify Reference Data Domain Content](#ModifyReferenceDataDomainContent)
</details>

<details>
<summary>Content Information Reference Data Domain</summary>

* [Get the Current Content Information of a Reference Data Domain](#GetCurrentContentInformationReferenceDataDomain)
* [Get All the Current Contents Information of a Reference Data Domain](#GetCurrentContentsInformationReferenceDataDomain)
* [Copy the Current Content of a Reference Data Domain](#CopyCurrentContentReferenceDataDomain)
* [Get All the Entries from the Latest Content of all Reference Data Domains](#GetEntriesLatestContentReferenceDataDomains)
* [Add Entries to a New Content of One or More Reference Data Domains](#AddEntriesNewContentReferenceDataDomains)
* [Get an Indexed Data Collection of Reference Data Domains](#GetIndexedDataCollectionReferenceDataDomains)
* [Get Indexed Data of Reference Data Domains](#GetIndexedDataReferenceDataDomains)
</details>

#### <a name='CreateReferenceDataDomain'>Create a Reference Data Domain</a>
Here is an example of creating a reference data domain.
```json
{
  "POST": "/referenceData/domains",
  "headers": {
    "Content-Type": "application/vnd.sas.data.reference.domain+json",
    "Accept": "application/vnd.sas.data.reference.domain+json"
  },
  "body": {
    "name": "serviceLevel",
    "description": "The service level designation.",
    "domainType": "lookup"
  }
}
```
<br>

#### <a name='GetReferenceDataDomain'>Get a Reference Data Domain</a>
Here is an example of getting a reference data domain.
```json
{
  "GET": "/referenceData/domains/{domainId}",
  "headers": {
    "Accept": "application/vnd.sas.data.reference.domain+json"
  }
}
```
<br>

#### <a name='DeleteReferenceDataDomain'>Delete a Reference Data Domain</a>
Here is an example of deleting a reference data domain.
```json
{
  "DELETE": "/referenceData/domains/{domainId}"
}
```
<br>

#### <a name='GetCollectionReferenceDataDomains'>Get the Collection of Reference Data Domains</a>
Here is an example of getting the collection of reference data domains.
```json
{
  "GET": "/referenceData/domains",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='CreateReferenceDataDomainContent'>Create a Reference Data Domain Content</a>
Here is an example of creating a reference data domain content.
```json
{
  "POST": "/referenceData/domains/{domainId}/contents",
  "headers": {
    "Content-Type": "application/vnd.sas.data.reference.domain.content+json",
    "Accept": "application/vnd.sas.data.reference.domain.content+json"
  },
  "body": {
    "label": "initiated",
    "majorVersion": 1,
    "minorVersion": 0,
    "status": "developing"
  }
}
```
<br>


#### <a name='UpdateReferenceDataDomainContent'>Update a Reference Data Domain Content</a>
Here are examples of updating a reference data domain content.

**Example 1:** Change the label.
```json
{
  "PUT": "/referenceData/domains/{domainId}/contents/{contentId}",
  "headers": {
    "If-Match": "{Etag value}",
    "Content-Type": "application/vnd.sas.data.reference.domain.content+json",
    "Accept": "application/vnd.sas.data.reference.domain.content+json"
  },
  "body": {
    "label": "update-needed"
  }
}
```
<br>

**Example 2:** Change the status to production.
```json
{
  "PUT": "/referenceData/domains/{domainId}/contents/{contentId}",
  "headers": {
    "If-Match": "{Etag value}",
    "Content-Type": "application/vnd.sas.data.reference.domain.content+json",
    "Accept": "application/vnd.sas.data.reference.domain.content+json"
  },
  "body": {
    "status": "production"
  }
}
```
<br>

#### <a name='GetReferenceDataDomainContent'>Get a Reference Data Domain Content</a>
Here is an example of getting a reference data domain content.
```json
{
  "GET": "/referenceData/domains/{domainId}/contents/{contentId}",
  "headers": {
    "Accept": "application/vnd.sas.data.reference.domain.content+json"
  }
}
```
<br>

#### <a name='DeleteReferenceDataDomainContent'>Delete a Reference Data Domain Content</a>
Here is an example of deleting a reference data domain content.
```json
{
  "DELETE": "/referenceData/domains/{domainId}/contents/{contentId}"
}
```
<br>

#### <a name='GetReferenceDataDomainContentCollection'>Get a Reference Data Domain Content Collection</a>
Here is an example of getting a reference data domain content collection.
```json
{
  "GET": "/referenceData/domains/{domainId}/contents",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='AddReplaceEntriesReferenceDataDomainContent'>Add or Replace Entries in a Reference Data Domain Content</a>
**Example 1:** After adding or replacing entries, the first page of entries is displayed.
```json
{
  "POST": "/referenceData/domains/{domainId}/contents/{contentId}/entries",
  "headers": {
    "Content-Type": "application/vnd.sas.collection+json",
    "Accept": "application/vnd.sas.collection+json"
  },
  "body": [
       { "key": "severe",
         "value": "1 hour"
       },
       { "key": "urgent",
         "value": "3 hours"
       }
  ]
}
```
<br>

**Example 2:** After adding or replacing entries, all entries are returned as text/csv.
```json
{
  "POST": "/referenceData/domains/{domainId}/contents/{contentId}/entries",
  "headers": {
    "Content-Type": "application/vnd.sas.collection+json",
    "Accept": "text/csv"
  },
  "body": [
       { "key": "severe",
         "value": "1 hour"
       },
       { "key": "urgent",
         "value": "3 hours"
       }
  ]
}
```
<br>

**Example 3:** Add or replace entries using a body of text/csv and all entries are returned as text/csv.
```json
{
  "POST": "/referenceData/domains/{domainId}/contents/{contentId}/entries",
  "headers": {
    "Content-Type": "text/csv;header=present",
    "Accept": "text/csv"
  },
  "body": "key,value\nsevere,1 hour\nurgent,3 hours"
}
```
<br>

#### <a name='ModifyReferenceDataDomainContent'>Modify Reference Data Domain Content</a>
Here is an example of replacing the value of an entry, deleting an entry, and adding an entry to a reference data domain.
```json
{
  "PATCH": "/referenceData/domains/{domainId}/contents/{contentId}/entries",
  "headers": {
    "If-Match": "{Etag value}",
    "Content-Type": "application/json",
    "Accept": "application/vnd.sas.collection+json"
  },
  "body": [
    { "op": "replace",
      "path": "/urgent/value",
      "value": "2 hours"
    },
    { "op": "delete",
      "path": "/severe",
    },
    { "op": "add",
      "path": "/catastrophic",
      "value": "1 hour"
    }
  ]
}
```
<br>

#### <a name='GetCurrentContentInformationReferenceDataDomain'>Get the Current Content Information of a Reference Data Domain</a>
Here is an example of getting the current content information of a reference data domain.
```json
{
  "GET": "/referenceData/domains/{domainId}/currentContents",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='GetCurrentContentsInformationReferenceDataDomain'>Get All the Current Contents Information of a Reference Data Domain</a>
Here is an example of getting all of the current contents information of a reference data domain.
```json
{
  "GET": "/referenceData/domains/{domainId}/currentContents?scope=all",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='CopyCurrentContentReferenceDataDomain'>Copy the Current Content of a Reference Data Domain</a>
Here is an example of copying the current content of a reference data domain to an execution environment.
```json
{
  "PATCH": "/referenceData/domains/{domainId}/currentContents",
  "headers": {
    "If-Match": "{Etag value}",
    "Content-Type": "application/json",
    "Accept": "application/vnd.sas.data.reference.domain.content.history+json"
  },
  "body": [
    { "op": "copy",
      "from": "/@current",
      "path": "/@current/environments/cas"
    }
  ]
}
```
<br>

#### <a name='GetEntriesLatestContentReferenceDataDomains'>Get All the Entries from the Latest Content of all Reference Data Domains</a>
Here is an example of getting all the entries from the latest content of all reference data domains.
```json
{
  "GET": "/referenceData/entries",
  "headers": {
    "Accept": "text/csv, application/json"
}
```
<br>

#### <a name='AddEntriesNewContentReferenceDataDomains'>Add Entries to a New Content of One or More Reference Data Domains</a>
Here is an example of adding entries to a new content of one or more reference data domains and then creating all the necessary reference data domains. Optional, put those domains in folders.
```json
{
  "POST": "/referenceData/entries",
  "headers": {
    "Content-Type": "text/csv;header=present",
    "Accept": "multipart/mixed, application/json"
  },
  "body": "lookup_nm,description,folder_path,name,value\nserviceLevel,The service level designation.,/Public/domains/work,severe,1 hour\nserviceLevel,The service level designation.,/Public/lookup_tables,urgent,3 hours\nescapingNecessary,A second domain demonstration escape of characters,/Public/domains/test,\"key with an embedded comma that must be quoted (,)\",\"value with an embedded double quote (\"\") that must be escaped\"\nescapingNecessary,A second domain demonstration escape of characters,/Public/dominas/test,normal key, but leading and trailing spaces are not trimmed away in the key or value \n
}
```
<br>

#### <a name='GetIndexedDataCollectionReferenceDataDomains'>Get an Indexed Data Collection of Reference Data Domains</a>
Here is an example of getting an indexed data collection of reference data domains.
```json
{
  "GET": "/referenceData/domains",
  "headers": {
    "Accept-Item": "application/vnd.sas.search.indexable.data+json"
  }
}
```
<br>

#### <a name='GetIndexedDataReferenceDataDomains'>Get Indexed Data of Reference Data Domains</a>
Here is an example of getting indexed data of reference data domains.
```json
{
  "GET": "/referenceData/domains/{domainId}",
  "headers": {
    "Accept": "application/vnd.sas.search.indexable.data+json"
  }
}

```
<br>

version 1, last updated 21 May, 2019


