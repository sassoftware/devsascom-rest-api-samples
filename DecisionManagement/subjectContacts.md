# Subject Contacts API
You can use the Subject Contacts API to record a subject's response to a contact that consists of marketing offers. This information can be useful when making decisions about future marketing offers.

The Subject Contacts API can be used in the following workflow:

* Part of a suite of APIs that support real-time marketing decisions. Consultants, marketers, and application developers can use this API to craft applications that react to customers' interaction with the marketers' channels, such as websites, customer help lines, and advertisements (cellular, internet or broadcasts).
* When a customer, also known as a subject, is in a channel of a marketer, the marketer wants to contact the customer to make offers that are likely to lead to a sale. Depending on the channel, the contact might be a text message or a pitch by a customer agent.
* This API provides records of customer contact and responses to previous offers, also known as treatments. These records allow a merchant's marketing application to fine tune its treatments to a potential subject by using them in predictive models and business rules.
* This API supports recording of subject contacts and responses.

You can also use the Subject Contacts API to record text that is produced when executing a decision.

## API Request Examples Grouped by Object Type
<details>
<summary>API Resource links</summary>

* [Get top-level links for the Subject Contacts API](#top-level-links)
</details>

<details>
<summary>Contacts</summary>

* [Synchronously record subject contact with direct presentation](#synchronous-record-contact-direct-presentation)
* [Synchronously record subject contact without direct presentation](#synchronous-record-contact-no-direct-presentation)
* [Asynchronously record subject contact without direct presentation](#asynchronous-record-contact-no-direct-presentation)
* [Get a contact record by the resource ID](#get-record-by-id)
* [Get a contact record by the response tracking code](#get-record-by-reponse-tracking-code)
* [Patch a contact record to record presentation](#patch-record-presentation)
* [Update a contact record to record presentation](#update-record-presentation)
* [Patch a contact record to record response to a treatment](#patch-record-treatment)
* [Record multiple subject contacts using CSV text](#record-multiple-contacts-csv)
* [Get the most recent contact records of a subject](#get-five-most-recent-contacts)
* [Get the contact history of a subject between two timestamps](#get-contacts-between-timestamps)
* [Find the number of contacts for a subject within a period of time](#has-contacts-last-ten-days)
* [Get the last contact history of an offer regardless of treatment version](#find-treatment-by-id)
* [Get the records of a subject for responses made on the web](#get-subject-web-responses)
* [Find the number of contacts made using the call center agent in a time domain for a treatment](#query-capacity-reached)
</details>

<details>
<summary>Aggregations</summary>

* [Aggregate the treatments of a subject from a set timestamp to the timestamp when the request is serviced](#aggregate-subject-treatments)
</details>

<details>
<summary>Traces</summary>

* [Append a trace](#append-a-trace)
* [List traces](#list-traces-default-limit)
* [Find traces that match filter conditions](#find-traces-with-filter)
* [Update an existing trace](#update-traces)
* [Delete traces that match filter conditions](#delete-traces-with-filter)
* [Process a trace](#process-a-trace)
</details>

<details>
<summary>See Also</summary>

* [Subject Contacts API documentation](https://developer.sas.com/apis/rest/DecisionManagement/#subject-contacts)
* [Decision Management REST API Examples](https://documentation.sas.com/?cdcId=edmcdc&cdcVersion=default&docsetId=edmresttut&docsetTarget=titlepage.htm)
</details>
<br>

#### <a name='top-level-links'>Get Top-Level Links for the Subject Contacts API</a>

Here is an example of retrieving a list of the top-level links for the Subject Contacts API.

**Request**
```
 GET http://www.example.com/subjectContacts/
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
      "rel": "contacts",
      "href": "/subjectContacts/contacts",
      "uri": "/subjectContacts/contacts",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.subject.contact"
    },
    {
      "method": "POST",
      "rel": "createContact",
      "href": "/subjectContacts/contacts",
      "uri": "/subjectContacts/contacts",
      "type": "application/vnd.sas.decision.subject.contact",
      "responseType": "application/vnd.sas.decision.subject.contact"
    },
    {
      "method": "GET",
      "rel": "subjectTreatments",
      "href": "/aggregations",
      "uri": "/aggregations",
      "type": "application/vnd.sas.decision.subject.contact.aggregation.treatment",
    },
  ]
}
```

#### <a name='synchronous-record-contact-direct-presentation'>Synchronously Record Subject Contact with Direct Presentation</a>

Here is an example of creating a contact record. The contact contains three treatments that are presented to a subject for consideration. The presentation can be done using a web page that is customized for this subject. 

**Request**
```
  POST   http://www.example.com/subjectContacts/contacts
  Headers:
  * Content-Type = application/vnd.sas.decision.subject.contact+json
  * Accept = application/vnd.sas.decision.subject.contact+json
  Body:
  {
    "objectUri": "/decisions/flows/5c5bc46a-cea0-4102-a88c-71cf1506e2c5",
    "objectRevisionId": "afb62877-64cb-4ae6-bf0c-4e2783a38d3a",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "00010",
    "pathTraversed": "/9e4e324b-de68-4035-b511-84cd558d5408/2541ab6e-3e7d-4ba0-8f04-7fc13a8e9794/509c4d2d-dc2c-4cb3-a094-5628e1ec879d",
    "responseTrackingCode": "GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b",
    "receiverId": "Francis.Albert.Bacon.19195313421",
    "receiverRole": "customer",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83",
        "treatmentRevisionId": "7aa86c12-55cf-4e99-8060-5b516314dc44",
        "treatmentGroupId": "bc912f15-96a0-4991-ba2a-9f12491cefc0",
        "treatmentGroupRevisionId": "9d2fccaa-428a-4604-a242-4f259ab8a553",
        "objectNodeId": "6bf8f1b3-9910-40ad-8146-6affd4f49a1f", 
        "presented": true,
        "presentedTimeStamp": "2018-05-13T15:02:40.719Z"
      },
      {
        "treatmentId": "826c9635-809a-44cf-a982-63e374846087",
        "treatmentRevisionId": "d14e393d-c21c-4654-8095-376909edace5",
        "treatmentGroupId": "1ba80181-7996-4ed5-8d58-66be8d2204e3",
        "treatmentGroupRevisionId": "f38725dc-cb53-4f09-b69c-661a7d675dac",
        "objectNodeId": "cf328b78-81b3-465e-b86b-2eb71876a66a",
        "presented": true,
        "presentedTimeStamp": "2018-05-13T15:02:40.719Z"
      },
      {
        "treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81",
        "treatmentRevisionId": "f14c3aa2-98a4-4a42-8b29-c99ad3cc02a8",
        "treatmentGroupId": "1ba80181-7996-4ed5-8d58-66be8d2204e3",
        "treatmentGroupRevisionId": "f38725dc-cb53-4f09-b69c-661a7d675dac",
        "objectNodeId": "f7d361a9-d488-47f6-a579-e4cf28fb7324",
        "presented": true,
        "presentedTimeStamp": "2018-05-13T15:02:40.719Z"
      }
    ],
    "excludeFromContactRule": false,
    "channel": "web"
  }
```

**Response**
```
 Status: 201
 Headers:
 * Content-Type = application/vnd.sas.decision.subject.contact+json
 * ETag = "jhx3s6si"
 * Location = /subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7
 Body:
    {
      "creationTimeStamp": "2018-05-13T15:02:40.719Z",
      "modifiedTimeStamp": "2018-05-13T15:02:40.719Z",
      "createdBy": "joeMarket",
      "modifiedBy": "joeMarket",
      "id": "5195ceb6-228e-439d-b3df-307197f1e7a7", 
      "subjectId": "Francis.Albert.Bacon.19195313421",
      "subjectLevel": "household",
      "objectUri": "/decisions/flows/5c5bc46a-cea0-4102-a88c-71cf1506e2c5",
      "objectRevisionId": "afb62877-64cb-4ae6-bf0c-4e2783a38d3a",
      "objectType": "decision",
      "objectVariables": [
        {
          "id": "a4722451-fb6f-4c9a-8bb8-4cf1eaba73c0",
          "name": "ov1",
          "value": "A",
          "dataType": "string"
        },
        {
          "id": "395aebd9-1646-4d84-9c05-d8e80efe72b7",
          "name": "ov2",
          "value": "B",
          "dataType": "string"
        }
      ],
      "treatmentsForConsideration": [
        {
          "id": "f025ee1f-a60a-4bb5-8236-0c697562653e",
          "treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83",
          "treatmentRevisionId": "7aa86c12-55cf-4e99-8060-5b516314dc44",
          "treatmentGroupId": "bc912f15-96a0-4991-ba2a-9f12491cefc0",
          "treatmentGroupRevisionId": "9d2fccaa-428a-4604-a242-4f259ab8a553",
          "objectNodeId": "6bf8f1b3-9910-40ad-8146-6affd4f49a1f",
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7"
        },
        {
          "id": "383bebdf-9378-4ed9-a2f3-127f53acfd22",
          "treatmentId": "826c9635-809a-44cf-a982-63e374846087",
          "treatmentRevisionId": "d14e393d-c21c-4654-8095-376909edace5",
          "treatmentGroupId": "1ba80181-7996-4ed5-8d58-66be8d2204e3",
          "treatmentGroupRevisionId": "f38725dc-cb53-4f09-b69c-661a7d675dac",
          "objectNodeId": "cf328b78-81b3-465e-b86b-2eb71876a66a",
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7" 
        },
        {
          "id": "23c1ebb8-7df8-4555-92d7-226ad88ad734",
          "treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81",
          "treatmentRevisionId": "f14c3aa2-98a4-4a42-8b29-c99ad3cc02a8",
          "treatmentGroupId": "1ba80181-7996-4ed5-8d58-66be8d2204e3",
          "treatmentGroupRevisionId": "f38725dc-cb53-4f09-b69c-661a7d675dac",
          "objectNodeId": "f7d361a9-d488-47f6-a579-e4cf28fb7324",
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7"
        }
      ],
      "ruleFired": "00010",
      "pathTraversed": "/9e4e324b-de68-4035-b511-84cd558d5408/2541ab6e-3e7d-4ba0-8f04-7fc13a8e9794/509c4d2d-dc2c-4cb3-a094-5628e1ec879d",
      "responseTrackingCode": "GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b",
      "receiverId": "Francis.Albert.Bacon.19195313421",
      "receiverRole": "customer",
      "channel": "web",
      "excludeFromContactRule": false,
      "conclusionResponseValue": "",
      "conclusionResponseType": "crt_x",
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PUT",
          "rel": "update",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "POST",
          "rel": "create",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PATCH",
          "rel": "patch",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.decision.subject.contact"
        }
      ]
    }

```

<br>

#### <a name='synchronous-record-contact-no-direct-presentation'>Synchronously Record Subject Contact without Direct Presentation</a>

Here is an example of a contact that is received by an agent instead of by a subject.

**Request**
```
  POST    http://www.example.com/subjectContacts/contacts  
  Headers:
  * Content-Type = application/vnd.sas.decision.subject.contact+json
  * Accept = application/vnd.sas.decision.subject.contact+json
  Body:
  {
    "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
    "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "111101",
    "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "receiverId": "CallCenter.71.310",
    "receiverRole": "agent",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
        "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
        "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
        "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
        "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
        "presented": false
      }
    ],
    "excludeFromContactRule": false,
    "channel": "phone"
  }
```

**Response**
```
 Status: 201
 Headers:
 * Content-Type = application/vnd.sas.decision.subject.contact+json
 * ETag = "jhx3s7xa"
 * Location = /subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657
 Body:
  {
    "creationTimeStamp": "2018-05-13T18:01:01.203Z",
    "modifiedTimeStamp": "2018-05-13T18:01:01.203Z",
    "createdBy": "joeMarket",
    "modifiedBy": "joeMarket",
    "id": "39657793-736b-462f-8d37-31c04b680657",
    "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
    "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "111101",
    "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "receiverId": "CallCenter.71.310",
    "receiverRole": "agent",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "id": "7b34d631-2f16-4d7a-ac55-3cbe9a661a6c",
        "subjectContactId": "39657793-736b-462f-8d37-31c04b680657",
        "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
        "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
        "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
        "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
        "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
        "presented": false
      }
    ],
    "channel": "phone",
    "excludeFromContactRule": false,
    "version": 1,
    "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PUT",
          "rel": "update",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "POST",
          "rel": "create",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PATCH",
          "rel": "patch",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.decision.subject.contact"
        }
    ]
  }
```

<br>

#### <a name='asynchronous-record-contact-no-direct-presentation'>Asynchronously Record Subject Contact without Direct Presentation</a>

Here is an example of creating a contact record asynchronously. The request parameter is set to "asynchronous=true". In the response, the input request is sent back with the ID field assigned a value. The response's location header provides the record's URL for retrieving it. The response cannot provide an ETag header because the record has not been saved yet.

**Request**
```
  POST    http://www.example.com/subjectContacts/contacts?asynchronous=true
  Headers:
  * Content-Type = application/vnd.sas.decision.subject.contact+json
  * Accept = application/vnd.sas.decision.subject.contact+json
  Body:
  {
    "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
    "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "111101",
    "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "receiverId": "CallCenter.71.310",
    "receiverRole": "agent",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
        "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
        "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
        "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
        "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
        "presented": false
      }
    ],
    "excludeFromContactRule": false,
    "channel": "phone"
  }
```

**Response**
```
 Status: 202
 Headers:
 * Content-Type = application/vnd.sas.decision.subject.contact+json
 * Location = /subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657
 Body:
  {
    "id": "39657793-736b-462f-8d37-31c04b680657"
    "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
    "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "111101",
    "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "receiverId": "CallCenter.71.310",
    "receiverRole": "agent",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
        "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
        "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
        "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
        "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
        "presented": false
      }
    ],
    "excludeFromContactRule": false,
    "channel": "phone"
  }
```
<br>

#### <a name='get-record-by-id'>Get a Contact Record by the Resource ID</a>

Here is an example of retrieving a subject contact record using its resource ID.

**Request**
```
 GET     http://www.example.com/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657
 Headers:
 * Accept = application/vnd.sas.decision.subject.contact+json
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.decision.subject.contact+json
 * ETag = "jhx3s7xa"
 * Location = /subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657
 Body:
  {
    "creationTimeStamp": "2018-05-13T18:01:01.203Z",
    "modifiedTimeStamp": "2018-05-13T18:01:01.203Z",
    "createdBy": "joeMarket",
    "modifiedBy": "joeMarket",
    "id": "39657793-736b-462f-8d37-31c04b680657",
    "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
    "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "111101",
    "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "receiverId": "CallCenter.71.310",
    "receiverRole": "agent",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "id": "7b34d631-2f16-4d7a-ac55-3cbe9a661a6c",
        "subjectContactId": "39657793-736b-462f-8d37-31c04b680657",
        "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
        "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
        "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
        "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
        "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
        "presented": false
      }
    ],
    "excludeFromContactRule": false,
    "channel": "phone",
    "version": 1,
    "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PUT",
          "rel": "update",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "POST",
          "rel": "create",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PATCH",
          "rel": "patch",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.decision.subject.contact"
        }
    ]
  }
```

<br>

#### <a name='get-record-by-reponse-tracking-code'>Get a Contact Record by the Response Tracking Code</a>

Here is an example of retrieving a subject contact record using a response tracking code. The record is returned in a collection that contains only one item.

**Request**
```
 GET     http://www.example.com/subjectContacts/contacts?filter=eq(responseTrackingCode,'BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054')
 Headers:
 * Accept = application/vnd.sas.collection+json
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.collection+json
 Body:
 {
  "name": "contacts",
  "accept": "application/vnd.sas.decision.subject.contact",
  "count": 1,
  "start": 0,
  "limit": 10,
  "items":[
    {
      "creationTimeStamp": "2018-05-13T18:01:01.203Z",
      "modifiedTimeStamp": "2018-05-13T18:01:01.203Z",
      "createdBy": "joeMarket",
      "modifiedBy": "joeMarket",
      "id": "39657793-736b-462f-8d37-31c04b680657",
      "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
      "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
      "objectType": "decision",
      "objectVariables": [
         {"name": "ov1", "value": "A", "dataType": "string"},
         {"name": "ov2", "value": "B", "dataType": "string"}
      ],
      "subjectId": "Francis.Albert.Bacon.19195313421",
      "subjectLevel": "household",
      "ruleFired": "111101",
      "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
      "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
      "receiverId": "CallCenter.71.310",
      "receiverRole": "agent",
      "conclusionResponseValue": "",
      "conclusionResponseType": "crt_x",
      "treatmentsForConsideration": [
        {
          "id": "7b34d631-2f16-4d7a-ac55-3cbe9a661a6c",
          "subjectContactId": "39657793-736b-462f-8d37-31c04b680657",
          "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
          "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
          "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
          "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
          "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
          "presented": false
        }
      ],
      "excludeFromContactRule": false,
      "channel": "phone",
      "version": 1,
      "links": [
          {
            "method": "GET",
            "rel": "self",
            "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "type": "application/vnd.sas.decision.subject.contact"
          },
          {
            "method": "PUT",
            "rel": "update",
            "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "type": "application/vnd.sas.decision.subject.contact",
            "responseType": "application/vnd.sas.decision.subject.contact"
          },
          {
            "method": "POST",
            "rel": "create",
            "href": "/subjectContacts/contacts",
            "uri": "/subjectContacts/contacts",
            "type": "application/vnd.sas.decision.subject.contact",
            "responseType": "application/vnd.sas.decision.subject.contact"
          },
          {
            "method": "PATCH",
            "rel": "patch",
            "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "type": "application/vnd.sas.decision.subject.contact",
            "responseType": "application/vnd.sas.decision.subject.contact"
          },
          {
            "method": "DELETE",
            "rel": "delete",
            "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657"
          },
          {
            "method": "GET",
            "rel": "up",
            "href": "/subjectContacts/contacts",
            "uri": "/subjectContacts/contacts",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.decision.subject.contact"
          }
      ]
    }
  ],
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/subjectContacts/contacts",
      "uri": "/subjectContacts/contacts",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.subject.contact"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/subjectContacts/contacts?filter=eq(responseTrackingCode,'BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054')&sortBy=creationTimeStamp:ascending&start=0",
      "uri": "/subjectContacts/contacts?filter=eq(responseTrackingCode,'BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054')&sortBy=creationTimeStamp:ascending&start=0",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.subject.contact"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/subjectContacts/",
      "uri": "/subjectContacts/",
      "type": "application/vnd.sas.api"
    },
    {
      "method": "POST",
      "rel": "create",
      "href": "/subjectContacts/contacts",
      "uri": "/subjectContacts/contacts",
      "type": "application/vnd.sas.decision.subject.contact",
      "responseType": "application/vnd.sas.decision.subject.contact"
    }
  ],
  "version": 2
 }

```

<br>

#### <a name='patch-record-presentation'>Patch a Contact Record to Record Presentation</a>

Here is an example that shows a recording presentation using the `responseTrackingCode` field. This is the most common use case when creating a contact object that is also asynchronous. 
The request body is a partial representation of the object.  Only the fields that are changing together with the fields that identify the treatment are sent.

**Request**
```
  PATCH http://www.example.com/subjectContacts/contacts/@deriveFromContent
  Headers:
  * If-Match = "jhx3s7xa"
  * Content-Type = application/vnd.sas.decision.subject.contact+json
  * Accept = application/vnd.sas.decision.subject.contact+json
  Body:
  {
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "treatmentsForConsideration": [
      {  
        "id": "7b34d631-2f16-4d7a-ac55-3cbe9a661a6c",
        "presented": true,
        "presentedTimeStamp": "2018-05-14T18:47:40.719Z"
      }
    ]
  }
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.decision.subject.contact+json
 * ETag = "jjy1e5rg"
 * Location = /subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657
 Body:
  {
    "creationTimeStamp": "2018-05-13T18:01:01.203Z",
    "modifiedTimeStamp": "2018-05-14T20:33:19.408",
    "createdBy": "joeMarket",
    "modifiedBy": "joeMarket",
    "id": "39657793-736b-462f-8d37-31c04b680657",
    "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
    "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "111101",
    "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "receiverId": "CallCenter.71.310",
    "receiverRole": "agent",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "id": "7b34d631-2f16-4d7a-ac55-3cbe9a661a6c",
        "subjectContactId": "39657793-736b-462f-8d37-31c04b680657",
        "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
        "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
        "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
        "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
        "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
        "presented": true,
        "presentedTimeStamp": "2018-05-14T18:47:40.719Z"
      }
    ],
    "excludeFromContactRule": false,
    "channel": "phone",
    "version": 1,
    "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PUT",
          "rel": "update",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "POST",
          "rel": "create",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PATCH",
          "rel": "patch",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.decision.subject.contact"
        }
    ]
  }
```

<br>

#### <a name='update-record-presentation'>Update a Contact Record to Record Presentation</a>

Here is an example that shows the recording a presentation using the object ID. The entire object representation must be sent, including fields that are not updated. 
This is the alternative to the previous [patch example](#patch-record-presentation).

**Request**
```
  PUT http://www.example.com/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657
  Headers:
  * If-Match = "jhx3s7xa"
  * Content-Type = application/vnd.sas.decision.subject.contact+json
  * Accept = application/vnd.sas.decision.subject.contact+json
  Body:
  {
    "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
    "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "111101",
    "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "receiverId": "CallCenter.71.310",
    "receiverRole": "agent",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "id": "7b34d631-2f16-4d7a-ac55-3cbe9a661a6c",
        "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
        "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
        "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
        "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
        "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
        "presented": true,
        "presentedTimeStamp": "2018-05-14T18:47:40.719Z"
      }
    ],
    "excludeFromContactRule": false,
    "channel": "phone"
  }
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.decision.subject.contact+json
 * ETag = "jjy1e5rg"
 * Location = /subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657
 Body:
  {
    "creationTimeStamp": "2018-05-13T18:01:01.203Z",
    "modifiedTimeStamp": "2018-05-14T20:33:19.408",
    "createdBy": "joeMarket",
    "modifiedBy": "joeMarket",
    "id": "39657793-736b-462f-8d37-31c04b680657",
    "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
    "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
    "objectType": "decision",
    "objectVariables": [
       {"name": "ov1", "value": "A", "dataType": "string"},
       {"name": "ov2", "value": "B", "dataType": "string"}
    ],
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "ruleFired": "111101",
    "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
    "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
    "receiverId": "CallCenter.71.310",
    "receiverRole": "agent",
    "conclusionResponseValue": "",
    "conclusionResponseType": "crt_x",
    "treatmentsForConsideration": [
      {
        "id": "7b34d631-2f16-4d7a-ac55-3cbe9a661a6c",
        "subjectContactId": "39657793-736b-462f-8d37-31c04b680657",
        "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
        "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
        "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
        "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
        "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
        "presented": true,
        "presentedTimeStamp": "2018-05-14T18:47:40.719Z"
      }
    ],
    "excludeFromContactRule": false,
    "channel": "phone",
    "version": 1,
    "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PUT",
          "rel": "update",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "POST",
          "rel": "create",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PATCH",
          "rel": "patch",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
          "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.decision.subject.contact"
        }
    ]
  }
```

<br>

#### <a name='patch-record-treatment'>Patch a Contact Record to Record Response to a Treatment</a>

Here is an example that uses the responseTrackingCode parameter. The request body is a partial representation of the object. It must have an identifier of the record, which in this case is the resourceTrackingCode field. 
Only the fields that are being changing are sent within the request.


**Request**
```
  PATCH http://www.example.com/subjectContacts/contacts/@deriveFromContent
  Headers:
  * ETag = "jia6h5vc"
  * Content-Type = application/vnd.sas.decision.subject.contact+json
  * Accept = application/vnd.sas.decision.subject.contact+json
  Body:
  {
    "responseTrackingCode": "GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b",
    "treatmentsForConsideration": [
      {
        "id": "383bebdf-9378-4ed9-a2f3-127f53acfd22",
        "responseValue": "accepted",
        "responseType": "rt_1",
        "respondedTimeStamp": "2018-05-13T18:11:10.687Z",
        "responseChannel": "web"
      }
    ]
  }
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.decision.subject.contact+json
 * ETag = "jkc1s4rg"
 * Location = /subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7
 Body:
    {
      "creationTimeStamp": "2018-05-13T15:02:40.719Z",
      "modifiedTimeStamp": "2018-05-13T18:32:40.719Z",
      "createdBy": "joeMarket",
      "modifiedBy": "joeMarket",
      "id": "5195ceb6-228e-439d-b3df-307197f1e7a7", 
      "subjectId": "Francis.Albert.Bacon.19195313421",
      "subjectLevel": "household",
      "objectUri": "/decisions/flows/5c5bc46a-cea0-4102-a88c-71cf1506e2c5",
      "objectRevisionId": "afb62877-64cb-4ae6-bf0c-4e2783a38d3a",
      "objectType": "decision",
      "objectVariables": [
        {
          "id": "a4722451-fb6f-4c9a-8bb8-4cf1eaba73c0",
          "name": "ov1",
          "value": "A",
          "dataType": "string"
        },
        {
          "id": "395aebd9-1646-4d84-9c05-d8e80efe72b7",
          "name": "ov2",
          "value": "B",
          "dataType": "string"
        }
      ],
      "treatmentsForConsideration": [
        {
          "id": "f025ee1f-a60a-4bb5-8236-0c697562653e",
          "treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83",
          "treatmentRevisionId": "7aa86c12-55cf-4e99-8060-5b516314dc44",
          "treatmentGroupId": "bc912f15-96a0-4991-ba2a-9f12491cefc0",
          "treatmentGroupRevisionId": "9d2fccaa-428a-4604-a242-4f259ab8a553",
          "objectNodeId": "6bf8f1b3-9910-40ad-8146-6affd4f49a1f"
          ],
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7"
        },
        {
          "id": "383bebdf-9378-4ed9-a2f3-127f53acfd22",
          "treatmentId": "826c9635-809a-44cf-a982-63e374846087",
          "treatmentRevisionId": "d14e393d-c21c-4654-8095-376909edace5",
          "treatmentGroupId": "1ba80181-7996-4ed5-8d58-66be8d2204e3",
          "treatmentGroupRevisionId": "f38725dc-cb53-4f09-b69c-661a7d675dac",
          "objectNodeId": "cf328b78-81b3-465e-b86b-2eb71876a66a",
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "responseValue": "accepted",
          "responseType": "rt_1",
          "respondedTimeStamp": "2018-05-13T18:11:10.687Z",
          "responseChannel": "web",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7" 
        },
        {
          "id": "23c1ebb8-7df8-4555-92d7-226ad88ad734",
          "treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81",
          "treatmentRevisionId": "f14c3aa2-98a4-4a42-8b29-c99ad3cc02a8",
          "treatmentGroupId": "1ba80181-7996-4ed5-8d58-66be8d2204e3",
          "treatmentGroupRevisionId": "f38725dc-cb53-4f09-b69c-661a7d675dac",
          "objectNodeId": "f7d361a9-d488-47f6-a579-e4cf28fb7324",
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7"
        }
      ],
      "ruleFired": "00010",
      "pathTraversed": "/9e4e324b-de68-4035-b511-84cd558d5408/2541ab6e-3e7d-4ba0-8f04-7fc13a8e9794/509c4d2d-dc2c-4cb3-a094-5628e1ec879d",
      "responseTrackingCode": "GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b",
      "receiverId": "Francis.Albert.Bacon.19195313421",
      "receiverRole": "customer",
      "excludeFromContactRule": false,
      "channel": "web",
      "conclusionResponseValue": "",
      "conclusionResponseType": "crt_x",
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PUT",
          "rel": "update",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "POST",
          "rel": "create",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PATCH",
          "rel": "patch",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.decision.subject.contact"
        }
      ]
    }
```


<br>

#### <a name='record-multiple-contacts-csv'>Record Multiple Subject Contacts Using CSV Text</a>

Here is an example of creating contact records using CSV records. The first row is the header row and lists the order of the columns. The second through the fourth rows creates the first contact. 
An error is deliberately introduced in the CSV content for this contact for illustration purposes. The fifth row creates the second contact.

**Request**
```
  POST http://www.example.com/subjectContacts/contacts
  Headers:
  * Content-Type = text/csv
  * Accept = multipart/mixed, application/json
  * If-Unmodified-Since = "Sun, 13 May 2018 19:00:00 GMT"
  Body:
creationTimeStamp,responseTrackingCode,subjectId,subjectLevel,excludeFromContactRule,conclusionResponseValue,conclusionResponseType,objectUri,objectRevisionId,objectType,objectVariables,receiverId,receiverRole,channel,ruleFired,pathTraversed,treatmentId,treatmentRevisionId,treatmentGroupId,treatmentGroupRevisionId,objectNodeId,presented,presentedTimeStamp,respondedTimeStamp,responseValue,responseType,responseChannel
2018-05-13T15:02:40.719Z,GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b,Francis.Albert.Bacon.19195313421,household,false,,crt_x,/decisions/flows/5c5bc46a-cea0-4102-a88c-71cf1506e2c5,afb62877-64cb-4ae6-bf0c-4e2783a38d3a,decision,ov1~~~A;ov2~~~B,Francis.Albert.Bacon.19195313421,customer,web,00010,/9e4e324b-de68-4035-b511-84cd558d5408/2541ab6e-3e7d-4ba0-8f04-7fc13a8e9794/509c4d2d-dc2c-4cb3-a094-5628e1ec879d,4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83,7aa86c12-55cf-4e99-8060-5b516314dc44,bc912f15-96a0-4991-ba2a-9f12491cefc0,9d2fccaa-428a-4604-a242-4f259ab8a553,6bf8f1b3-9910-40ad-8146-6affd4f49a1f,true,2018-05-13T15:02:40.719Z,,,,
2018-05-13T15:02:40.719Z,GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b,Francis.Albert.Bacon.19195313421,household,false,,crt_x,/decisions/flows/5c5bc46a-cea0-4102-a88c-71cf1506e2c5,afb62877-64cb-4ae6-bf0c-4e2783a38d3a,decision,ov1~~~A;ov2~~~B,Francis.Albert.Bacon.19195313421,customer,web,00010,/9e4e324b-de68-4035-b511-84cd558d5408/2541ab6e-3e7d-4ba0-8f04-7fc13a8e9794/509c4d2d-dc2c-4cb3-a094-5628e1ec879d,826c9635-809a-44cf-a982-63e374846087,d14e393d-c21c-4654-8095-376909edace5,1ba80181-7996-4ed5-8d58-66be8d2204e3,f38725dc-cb53-4f09-b69c-661a7d675dac,cf328b78-81b3-465e-b86b-2eb71876a66a,true,2018-05-13T15:02:40.719Z,,,,
2018-05-13T15:02:40.719Z,GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b,Francis.Albert.Bacon.19195313421,household,false,,crt_x,/decisions/flows/5c5bc46a-cea0-4102-a88c-71cf1506e2c5,afb62877-64cb-4ae6-bf0c-4e2783a38d3a,decision,ov1~~~A;ov2~~~B,Francis.Albert.Bacon.19195313421,customer,web,00010,/9e4e324b-de68-4035-b511-84cd558d5408/2541ab6e-3e7d-4ba0-8f04-7fc13a8e9794/509c4d2d-dc2c-4cb3-a094-5628e1ec879d,2826de5a-d0d6-4bd1-8a80-08c12ba2ad81,f14c3aa2-98a4-4a42-8b29-c99ad3cc02a8,1ba80181-7996-4ed5-8d58-66be8d2204e3,1ae1f326-fe2b-4a72-9f1d-f7a52f0ba073,f7d361a9-d488-47f6-a579-e4cf28fb7324,true,2018-05-13T15:02:40.719Z,,,,
2018-05-13T22:32:30.712Z,VIP.9ea6417c-25d5-4dd7-9377-69881d6563ef,Betty.Monroe.Galloway.18174362195,individual,false,,crt_x,/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145,e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80,decision,ov1~~~A~~~string;ov2~~~B~~~string,CallCenter.71.310,agent,phone,111101,/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa,,29ed1a67-e3be-412c-ae2f-567edd38e086,efb511c1-ad37-4a3d-8a8f-e259d8dc2812,82d4e377-16ab-4165-a923-c38c45cd3a01,2c72fe78-09df-44ff-9039-23f1272390b9,3670f308-fe1a-46b0-96de-b97a09db0be5,false,,,,,
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = multipart/mixed; boundary=_001_002_003_004_005_006_007_008_009_010_011_012_;charset=utf-8
 Body:

--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset="utf-8"
Content-ID: Accepted-CSV

4,8815ef75-e45e-4a78-a277-ba8af53c303c,2018-05-13T22:32:30.712Z,VIP.9ea6417c-25d5-4dd7-9377-69881d6563ef,Betty.Monroe.Galloway.18174362195,individual,false,,crt_x,/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145,e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80,decision,ov1~~~A~~~string;ov2~~~B~~~string,CallCenter.71.310,agent,phone,111101,/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa,,29ed1a67-e3be-412c-ae2f-567edd38e086,efb511c1-ad37-4a3d-8a8f-e259d8dc2812,82d4e377-16ab-4165-a923-c38c45cd3a01,2c72fe78-09df-44ff-9039-23f1272390b9,3670f308-fe1a-46b0-96de-b97a09db0be5,false,,,,,

--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset="utf-8"
Content-ID: Rejected-CSV

1,2018-05-13T15:02:40.719Z,GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b,Francis.Albert.Bacon.19195313421,household,false,,crt_x,/decisions/flows/5c5bc46a-cea0-4102-a88c-71cf1506e2c5,afb62877-64cb-4ae6-bf0c-4e2783a38d3a,decision,ov1~~~A;ov2~~~B,Francis.Albert.Bacon.19195313421,customer,web,00010,/9e4e324b-de68-4035-b511-84cd558d5408/2541ab6e-3e7d-4ba0-8f04-7fc13a8e9794/509c4d2d-dc2c-4cb3-a094-5628e1ec879d,4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83,7aa86c12-55cf-4e99-8060-5b516314dc44,bc912f15-96a0-4991-ba2a-9f12491cefc0,9d2fccaa-428a-4604-a242-4f259ab8a553,6bf8f1b3-9910-40ad-8146-6affd4f49a1f,true,2018-05-13T15:02:40.719Z,,,,,The value for the objectVariables column is not proper. It must be zero or more groups of name~~~value~~~dataType tuple using semicolon as the delimiter.

--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset="utf-8"
Content-ID: Global-Issue

--_001_002_003_004_005_006_007_008_009_010_011_012_--
```


<br>

#### <a name='get-five-most-recent-contacts'>Get the Most Recent Contact Records of a Subject</a>

Here is an example of retrieving the most recent contact records of a subject.

**Request**
```
  GET http://www.example.com/subjectContacts/contacts?limit=5&filter=and(eq(subjectId,'Francis.Albert.Bacon.19195313421'),eq(subjectLevel,'household'))
  Headers:
  * Accept = application/vnd.sas.collection+json
  * Accept-Item = application/vnd.sas.decision.subject.contact+json
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.collection+json
 Body:
 {
  "name": "contacts",
  "accept": "application/vnd.sas.decision.subject.contact",
  "count": 2,
  "start": 0,
  "limit": 5,
  "items": [
    {
      "creationTimeStamp": "2018-05-13T15:02:40.719Z",
      "modifiedTimeStamp": "2018-05-13T18:32:40.719Z",
      "createdBy": "joeMarket",
      "modifiedBy": "joeMarket",
      "id": "5195ceb6-228e-439d-b3df-307197f1e7a7", 
      "subjectId": "Francis.Albert.Bacon.19195313421",
      "subjectLevel": "household",
      "objectUri": "/decisions/flows/5c5bc46a-cea0-4102-a88c-71cf1506e2c5",
      "objectRevisionId": "afb62877-64cb-4ae6-bf0c-4e2783a38d3a",
      "objectType": "decision",
      "objectVariables": [
        {
          "id": "a4722451-fb6f-4c9a-8bb8-4cf1eaba73c0",
          "name": "ov1",
          "value": "A",
          "dataType": "string"
        },
        {
          "id": "395aebd9-1646-4d84-9c05-d8e80efe72b7",
          "name": "ov2",
          "value": "B",
          "dataType": "string"
        }
      ],
      "treatmentsForConsideration": [
        {
          "id": "f025ee1f-a60a-4bb5-8236-0c697562653e",
          "treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83",
          "treatmentRevisionId": "7aa86c12-55cf-4e99-8060-5b516314dc44",
          "treatmentGroupId": "bc912f15-96a0-4991-ba2a-9f12491cefc0",
          "treatmentGroupRevisionId": "9d2fccaa-428a-4604-a242-4f259ab8a553",
          "objectNodeId": "6bf8f1b3-9910-40ad-8146-6affd4f49a1f",
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7"
        },
        {
          "id": "383bebdf-9378-4ed9-a2f3-127f53acfd22",
          "treatmentId": "826c9635-809a-44cf-a982-63e374846087",
          "treatmentRevisionId": "d14e393d-c21c-4654-8095-376909edace5",
          "treatmentGroupId": "1ba80181-7996-4ed5-8d58-66be8d2204e3",
          "treatmentGroupRevisionId": "f38725dc-cb53-4f09-b69c-661a7d675dac",
          "objectNodeId": "cf328b78-81b3-465e-b86b-2eb71876a66a",
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "responseValue": "accepted",
          "responseType": "rt_1",
          "respondedTimeStamp": "2018-05-13T18:11:10.687Z",
          "responseChannel": "web",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7" 
        },
        {
          "id": "23c1ebb8-7df8-4555-92d7-226ad88ad734",
          "treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81",
          "treatmentRevisionId": "f14c3aa2-98a4-4a42-8b29-c99ad3cc02a8",
          "treatmentGroupId": "1ba80181-7996-4ed5-8d58-66be8d2204e3",
          "treatmentGroupRevisionId": "f38725dc-cb53-4f09-b69c-661a7d675dac",
          "objectNodeId": "f7d361a9-d488-47f6-a579-e4cf28fb7324",
          "presented": true,
          "presentedTimeStamp": "2018-05-13T15:02:40.719Z",
          "subjectContactId": "5195ceb6-228e-439d-b3df-307197f1e7a7"
        }
      ],
      "ruleFired": "00010",
      "pathTraversed": "/9e4e324b-de68-4035-b511-84cd558d5408/2541ab6e-3e7d-4ba0-8f04-7fc13a8e9794/509c4d2d-dc2c-4cb3-a094-5628e1ec879d",
      "responseTrackingCode": "GreatCustomer.07f16e7a-db89-400a-91d9-8b6868f07b7b",
      "receiverId": "Francis.Albert.Bacon.19195313421",
      "receiverRole": "customer",
      "excludeFromContactRule": false,
      "channel": "web",
      "conclusionResponseValue": "",
      "conclusionResponseType": "crt_x",
      "version": 1,
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PUT",
          "rel": "update",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "POST",
          "rel": "create",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "PATCH",
          "rel": "patch",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "type": "application/vnd.sas.decision.subject.contact",
          "responseType": "application/vnd.sas.decision.subject.contact"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7",
          "uri": "/subjectContacts/contacts/5195ceb6-228e-439d-b3df-307197f1e7a7"
        },
        {
          "method": "GET",
          "rel": "up",
          "href": "/subjectContacts/contacts",
          "uri": "/subjectContacts/contacts",
          "type": "application/vnd.sas.collection",
          "itemType": "application/vnd.sas.decision.subject.contact"
        }
      ]
    },
    {
      "creationTimeStamp": "2018-05-13T18:01:01.203Z",
      "modifiedTimeStamp": "2018-05-13T18:01:01.203Z",
      "createdBy": "joeMarket",
      "modifiedBy": "joeMarket",
      "id": "39657793-736b-462f-8d37-31c04b680657",
      "objectUri": "/decisions/flows/525b199b-9073-4359-a521-ff1bc8a59145",
      "objectRevisionId": "e4728fe2-35ce-4ac6-84e0-fd0cad3f0e80",
      "objectType": "decision",
      "objectVariables": [
         {"name": "ov1", "value": "A", "dataType": "string"},
         {"name": "ov2", "value": "B", "dataType": "string"}
      ],
      "subjectId": "Francis.Albert.Bacon.19195313421",
      "subjectLevel": "household",
      "ruleFired": "111101",
      "pathTraversed": "/ddc3f087-e313-4f63-8404-45a51257df0b/5cb79bb7-1ba2-4c1d-a17c-5d0894ebc046/1111ee7e-7135-4397-bb1d-2aa0a680b9aa",
      "responseTrackingCode": "BigSaver.08c3f2f6-2d1f-45ed-9cd4-511fa7b40054",
      "receiverId": "CallCenter.71.310",
      "receiverRole": "agent",
      "conclusionResponseValue": "",
      "conclusionResponseType": "crt_x",
      "treatmentsForConsideration": [
        {
          "id": "7b34d631-2f16-4d7a-ac55-3cbe9a661a6c",
          "subjectContactId": "39657793-736b-462f-8d37-31c04b680657",
          "treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086",
          "treatmentRevisionId": "efb511c1-ad37-4a3d-8a8f-e259d8dc2812",
          "treatmentGroupId": "82d4e377-16ab-4165-a923-c38c45cd3a01",
          "treatmentGroupRevisionId": "2c72fe78-09df-44ff-9039-23f1272390b9",
          "objectNodeId": "3670f308-fe1a-46b0-96de-b97a09db0be5", 
          "presented": false
        }
      ],
      "excludeFromContactRule": false,
      "channel": "phone",
      "version": 1,
      "links": [
          {
            "method": "GET",
            "rel": "self",
            "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "type": "application/vnd.sas.decision.subject.contact"
          },
          {
            "method": "PUT",
            "rel": "update",
            "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "type": "application/vnd.sas.decision.subject.contact",
            "responseType": "application/vnd.sas.decision.subject.contact"
          },
          {
            "method": "POST",
            "rel": "create",
            "href": "/subjectContacts/contacts",
            "uri": "/subjectContacts/contacts",
            "type": "application/vnd.sas.decision.subject.contact",
            "responseType": "application/vnd.sas.decision.subject.contact"
          },
          {
            "method": "PATCH",
            "rel": "patch",
            "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "type": "application/vnd.sas.decision.subject.contact",
            "responseType": "application/vnd.sas.decision.subject.contact"
          },
          {
            "method": "DELETE",
            "rel": "delete",
            "href": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657",
            "uri": "/subjectContacts/contacts/39657793-736b-462f-8d37-31c04b680657"
          },
          {
            "method": "GET",
            "rel": "up",
            "href": "/subjectContacts/contacts",
            "uri": "/subjectContacts/contacts",
            "type": "application/vnd.sas.collection",
            "itemType": "application/vnd.sas.decision.subject.contact"
          }
      ]
    }
  ],
  "links": [
    {
      "method": "GET",
      "rel": "collection",
      "href": "/subjectContacts/contacts",
      "uri": "/subjectContacts/contacts",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.subject.contact"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/subjectContacts/contacts?limit=5&filter=and(eq(subjectId,'Francis.Albert.Bacon.19195313421'),eq(subjectLevel,'household'))&sortBy=creationTimeStamp:ascending&start=0",
      "uri": "/subjectContacts/contacts?limit=5&filter=and(eq(subjectId,'Francis.Albert.Bacon.19195313421'),eq(subjectLevel,'household'))&sortBy=creationTimeStamp:ascending&start=0",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.subject.contact"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/subjectContacts/",
      "uri": "/subjectContacts/",
      "type": "application/vnd.sas.api"
    },
    {
      "method": "POST",
      "rel": "create",
      "href": "/subjectContacts/contacts",
      "uri": "/subjectContacts/contacts",
      "type": "application/vnd.sas.decision.subject.contact",
      "responseType": "application/vnd.sas.decision.subject.contact"
    }
  ],
  "version": 2
 }
```


<br>

#### <a name='get-contacts-between-timestamps'>Get the Contact History of a Subject between Two Timestamps</a>

Here is an example of retrieving the contact history of a subject between two timestamps. 

**Note:** The response structure is similar to the response for the [Get the Most Recent Contact Records of a Subject example](#get-five-most-recent-contacts). Therefore, it is omitted.
 
**Request**
```
  GET http://www.example.com/subjectContacts/contacts?filter=and(and(eq(subjectId,'Francis.Albert.Bacon.19195313421'),eq(subjectLevel,'household')),and(gt(creationTimeStamp,'2018-06-13T00:00:00Z'),lt(creationTimeStamp,'2018-12-13T00:00:00Z')))
  Headers:
  * Accept = application/vnd.sas.collection+json
  * Accept-Item = application/vnd.sas.decision.subject.contact+json
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.collection+json

The response body is omitted here because it has contents similar to the response for the "Get the most recent 5 contact records of a subject" example.
```
<br>

#### <a name='has-contacts-last-ten-days'>Find the Number of Contacts for a Subject within a Period of Time</a>

Here is an example of finding the number of contacts for a subject within a specific period of time.

If today is 2018-06-13T00:00:00Z, 10 days ago would be 2018-06-03T00:00:00Z. If there is one item returned, then the subject has been contacted within the last 10 days. 

**Note:** The response structure is similar to the response for the [Get the Most Recent Contact Records of a Subject example](#get-five-most-recent-contacts) . Therefore, it is omitted.

**Request**
```
  GET http://www.example.com/subjectContacts/contacts?limit=1&filter=and(and(eq(subjectId,'Francis.Albert.Bacon.19195313421'),eq(subjectLevel,'household')),gt(creationTimeStamp,'2018-06-02T23:59:59.999Z'))
  Headers:
  * Accept = application/vnd.sas.collection+json
  * Accept-Item = application/vnd.sas.summary+json
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.collection+json

The response body is omitted here because it has contents similar to the response for the "Get the most recent 5 contact records of a subject" example.
```


<br>

#### <a name='find-treatment-by-id'>Get the Last Contact History of an Offer Regardless of Treatment Version</a>

Here is an example of retrieving the last contact history of an offer regardless of the Treatment version.

**Note:** The response structure is similar to the response for the [Get the Most Recent Contact Records of a Subject ](#get-five-most-recent-contacts). Therefore, it is omitted.

**Request**
```
  GET http://www.example.com/subjectContacts/contacts?limit=1&filter=eq(treatmentsForConsideration.treatmentId,'29ed1a67-e3be-412c-ae2f-567edd38e086')
  Headers:
  * Accept = application/vnd.sas.collection+json
  * Accept-Item = application/vnd.sas.summary+json
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.collection+json

The response body is omitted here because it has contents similar to the response for the "Get the most recent 5 contact records of a subject" example.
```

<br>

#### <a name='get-subject-web-responses'>Get the Records of a Subject for Responses Made On the Web</a>

**Note:** The response structure is similar to the response for the [Get the Most Recent Contact Records of a Subject ](#get-five-most-recent-contacts). Therefore, it is omitted.

**Request**
```
  GET http://www.example.com/subjectContacts/contacts?filter=and(and(eq(subjectId,'Francis.Albert.Bacon.19195313421'),eq(subjectLevel,'household')),eq(treatmentsForConsideration.responseChannel,'web'))
  Headers:
  * Accept = application/vnd.sas.collection+json
  * Accept-Item = application/vnd.sas.summary+json
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.collection+json

The response body is omitted here because it has contents similar to the response for the "Get the most recent 5 contact records of a subject" example.
```


<br>

#### <a name='query-capacity-reached'>Find the Number of Contacts Made Using the Call Center Agent in a Time Domain for a Treatment</a>

Here is an example of finding the number of contacts that were made using the Call Center Agent in a time domain for a treatment.

If currently it is 2018-06-13T12:00:00Z, 2 hours ago would be 2018-06-13T10:00:00Z. This example can be used in rules dealing with capacity to determine whether there are sufficient resources to make an offer to an additional subject. 

**Request**
```
  GET http://www.example.com/subjectContacts/contacts?limit=50&filter=and(eq(treatmentsForConsideration.responseChannel,'agent'),and(eq(treatmentsForConsideration.treatmentId,'6b66c3ed-0b59-4406-8fe2-2dd2311464f6'),ge(creationTimeStamp,'2018-06-13T10:00:00Z')))
  Headers:
  * Accept = application/vnd.sas.collection+json
  * Accept-Item = application/vnd.sas.summary+json
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.collection+json

The response body is omitted here because it has contents similar to the response for the "Get the most recent 5 contact records of a subject" example.
```

<br>

#### <a name='aggregate-subject-treatments'>Aggregate the Treatments of a Subject from a Set Timestamp to the Timestamp When the Request Is Serviced</a>

The contact channels used in this example are web and phone. All the response channels found in the time period are aggregated.

**Request**
```
  POST http://www.example.com/subjectContacts/aggregations
  Headers:
  * Content-Type = application/vnd.sas.decision.subject.contact.aggregation.specification+json
  * Accept = application/vnd.sas.decision.subject.contact.aggregation.treatment+json
  Body:
  {
    "subjectId": "Francis.Albert.Bacon.19195313421",
    "subjectLevel": "household",
    "timeAggregationUnits" : [
      "hour"
    ],
    "beginAggregationTimeStamp" : "2018-05-13T14:47:40.719Z",
    "contactChannels": [
      "web",
      "phone"
    ]
  }
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = application/vnd.sas.decision.subject.contact.aggregation.treatment+json
 Body:
  {
      "subjectId": "Francis.Albert.Bacon.19195313421", 
      "subjectLevel": "household", 
      "beginTimeStamp": "2018-05-13T14:47:40.719Z", 
      "endTimeStamp": "2018-05-13T18:47:40.719Z",
      "contactChannelAggregation": [
          {
              "name": "web", 
              "channelType": "contact", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z", 
              "beginTimeStamp": "2018-05-13T14:47:40.719Z"
          }, 
          {
              "name": "phone", 
              "channelType": "contact", 
              "contactedTreatments": [
                  {"treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83", "count": 1},
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1},
                  {"treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81", "count": 1},
                  {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
              ], 
              "presentedTreatments": [
                  {"treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83", "count": 1},
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1},
                  {"treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81", "count": 1}
              ], 
              "periods": [
                  {
                      "periodUnit": "hour", 
                      "periodLength": 1, 
                      "contactedTreatments": [
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "timeStampType": "contacted", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T18:00:00.000Z"
                  }, 
                  {
                      "periodUnit": "hour", 
                      "periodLength": 2, 
                      "contactedTreatments": [
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "timeStampType": "contacted", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T17:00:00.000Z"
                  }, 
                  {
                      "periodUnit": "hour", 
                      "periodLength": 3, 
                      "contactedTreatments": [
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "timeStampType": "contacted", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T16:00:00.000Z"
                  }, 
                  {
                      "periodUnit": "hour", 
                      "periodLength": 4, 
                      "contactedTreatments": [
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "timeStampType": "contacted", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T15:00:00.000Z"
                  }, 
                  {
                      "periodUnit": "hour", 
                      "periodLength": 5, 
                      "contactedTreatments": [
                          {"treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83", "count": 1},
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1},
                          {"treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81", "count": 1},
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "presentedTreatments": [
                          {"treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83", "count": 1},
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1},
                          {"treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81", "count": 1}
                      ], 
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "timeStampType": "contacted", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T14:47:40.719Z"
                  }
              ], 
              "endTimeStamp": "2018-05-13T18:47:40.719Z", 
              "beginTimeStamp": "2018-05-13T14:47:40.719Z"
          }
      ], 
      "responseChannelAggregation": [
          {
              "name": "phone", 
              "channelType": "response", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z", 
              "beginTimeStamp": "2018-05-13T14:47:40.719Z"
          },
          {
              "name": "web", 
              "channelType": "response", 
              "respondedTreatments": [
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
              ], 
              "periods": [
                  {
                      "periodUnit": "hour", 
                      "periodLength": 1, 
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "timeStampType": "responded", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T18:00:00.000Z"
                  }, 
                  {
                      "periodUnit": "hour", 
                      "periodLength": 2, 
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "timeStampType": "responded", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T17:00:00.000Z"
                  }, 
                  {
                      "periodUnit": "hour", 
                      "periodLength": 3, 
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "timeStampType": "responded", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T16:00:00.000Z"
                  }, 
                  {
                      "periodUnit": "hour", 
                      "periodLength": 4, 
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "timeStampType": "responded", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T15:00:00.000Z"
                  }, 
                  {
                      "periodUnit": "hour", 
                      "periodLength": 5, 
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "timeStampType": "responded", 
                      "endTimeStamp": "2018-05-13T18:47:40.719Z", 
                      "beginTimeStamp": "2018-05-13T14:47:40.719Z"
                  }
              ], 
              "endTimeStamp": "2018-05-13T18:47:40.719Z", 
              "beginTimeStamp": "2018-05-13T14:47:40.719Z"
          } 
      ], 
      "contactedTimeStampAggregation": [
          {
              "periodUnit": "hour", 
              "periodLength": 1,
              "contactedTreatments": [
                  {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
              ], 
              "channels": [
                  {
                      "channelType": "contact", 
                      "contactedTreatments": [
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "name": "phone"
                  }
              ], 
              "timeStampType": "contacted", 
              "beginTimeStamp": "2018-05-13T18:00:00.000Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }, 
          {
              "periodUnit": "hour", 
              "periodLength": 2
              "contactedTreatments": [
                  {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
              ], 
              "channels": [
                  {
                      "channelType": "contact", 
                      "contactedTreatments": [
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "name": "phone"
                  }
              ], 
              "timeStampType": "contacted", 
              "beginTimeStamp": "2018-05-13T17:00:00.000Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }, 
          {
              "periodUnit": "hour", 
              "periodLength": 3,
              "contactedTreatments": [
                  {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
              ], 
              "channels": [
                  {
                      "channelType": "contact", 
                      "contactedTreatments": [
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "name": "phone"
                  }
              ], 
              "timeStampType": "contacted", 
              "beginTimeStamp": "2018-05-13T16:00:00.000Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }, 
          {
              "periodUnit": "hour", 
              "periodLength": 4,
              "contactedTreatments": [
                  {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
              ], 
              "channels": [
                  {
                      "channelType": "contact", 
                      "contactedTreatments": [
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "name": "phone"
                  }
              ], 
              "timeStampType": "contacted", 
              "beginTimeStamp": "2018-05-13T15:00:00.000Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }, 
          {
              "periodUnit": "hour", 
              "periodLength": 5,
              "contactedTreatments": [
                  {"treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83", "count": 1},
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1},
                  {"treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81", "count": 1},
                  {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
              ], 
              "presentedTreatments": [
                  {"treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83", "count": 1},
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1},
                  {"treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81", "count": 1}
              ], 
              "channels": [
                  {
                      "name": "phone"
                      "channelType": "contact", 
                      "contactedTreatments": [
                          {"treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83", "count": 1},
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1},
                          {"treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81", "count": 1},
                          {"treatmentId": "29ed1a67-e3be-412c-ae2f-567edd38e086", "count": 1}
                      ], 
                      "presentedTreatments": [
                          {"treatmentId": "4f3f14cf-69ed-4d59-9ea2-ecfb525cfa83", "count": 1},
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1},
                          {"treatmentId": "2826de5a-d0d6-4bd1-8a80-08c12ba2ad81", "count": 1}
                      ], 
                  }
              ], 
              "timeStampType": "contacted", 
              "beginTimeStamp": "2018-05-13T14:47:40.719Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }
      ], 
      "respondedTimeStampAggregation": [
          {
              "periodUnit": "hour", 
              "periodLength": 1,
              "respondedTreatments": [
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
              ], 
              "channels": [
                  {
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "channelType": "response", 
                      "name": "web"
                  }
              ], 
              "timeStampType": "responded", 
              "beginTimeStamp": "2018-05-13T18:00:00.000Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }, 
          {
              "periodUnit": "hour", 
              "periodLength": 2,
              "respondedTreatments": [
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
              ], 
              "channels": [
                  {
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "channelType": "response", 
                      "name": "web"
                  }
              ], 
              "timeStampType": "responded", 
              "beginTimeStamp": "2018-05-13T17:00:00.000Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }, 
          {
              "periodUnit": "hour", 
              "periodLength": 3,
              "respondedTreatments": [
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
              ], 
              "channels": [
                  {
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "channelType": "response", 
                      "name": "web"
                  }
              ], 
              "timeStampType": "responded", 
              "beginTimeStamp": "2018-05-13T16:00:00.000Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }, 
          {
              "periodUnit": "hour", 
              "periodLength": 4,
              "respondedTreatments": [
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
              ], 
              "channels": [
                  {
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "channelType": "response", 
                      "name": "web"
                  }
              ], 
              "timeStampType": "responded", 
              "beginTimeStamp": "2018-05-13T15:00:00.000Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }, 
          {
              "periodUnit": "hour", 
              "periodLength": 5,
              "respondedTreatments": [
                  {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
              ], 
              "channels": [
                  {
                      "respondedTreatments": [
                          {"treatmentId": "826c9635-809a-44cf-a982-63e374846087", "count": 1}
                      ], 
                      "channelType": "response", 
                      "name": "web"
                  }
              ], 
              "timeStampType": "responded", 
              "beginTimeStamp": "2018-05-13T14:47:40.719Z", 
              "endTimeStamp": "2018-05-13T18:47:40.719Z"
          }
      ]
  }

```

<br>

#### <a name='append-a-trace'>Append a Trace</a>

Here is an example of appending text to the Traces collection that is produced by executing a decision.

The columns are separated by the tab character. Since there is no value in the `processornote` field, there are two tab characters (invisible) between the `objecturi` and text columns on the data line.
The only restriction on the text column is that it must not contain the tab character. Other than that, it can be used to store any text.

**Request**
```
  POST http://www.example.com/subjectContacts/traces?scope=step
  Headers:
  * Content-Type = text/tab-separated-values
  * Accept = multipart/mixed, application/json
  Body:
traceid	seqno	action	tracetimestamp	objecturi	processornote	text	
954931B7-2425-CB45-90D2-756189E18F72	1	append	2020-08-10T16:44:12Z	/decisions/flows/835b0890-bca3-42f1-8a50-9dcce2c4a377/revisions/6f5c045a-94a6-4f9b-9adc-cc1dde33558		VVCT#STARTING_NODE_TRACE#954931B7-2425-CB45-90D2-756189E18F72
VVCT#954931B7-2425-CB45-90D2-756189E18F72#/decisions/flows/835b0890-bca3-42f1-8a50-9dcce2c4a377/revisions/6f5c045a-94a6-4f9b-9adc-cc1dde33558#Start
VVCT#954931B7-2425-CB45-90D2-756189E18F72#a=1
VVCT#954931B7-2425-CB45-90D2-756189E18F72#b=c
VVCT#954931B7-2425-CB45-90D2-756189E18F72#c=b
VVCT#954931B7-2425-CB45-90D2-756189E18F72#temp_dg_out=
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = multipart/mixed`
 Body:

--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset="utf-8"
Content-ID: Accepted-TSV

954931B7-2425-CB45-90D2-756189E18F72,A record with the trace ID "954931B7-2425-CB45-90D2-756189E18F72" and order "1" is added.

--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset=utf-8
Content-ID: Rejected-TSV


--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset=utf-8
Content-ID: Global-Issue


--_001_002_003_004_005_006_007_008_009_010_011_012_--

```
<br>

#### <a name='list-traces-default-limit'>List Traces</a>

Here is an example of retrieving a list of traces that are produced by executing decisions.

**Request**
```
  GET http://www.example.com/subjectContacts/traces?scope=step
  Headers:
  * Accept = application/vnd.sas.collection+json
  Body:
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
      "method": "GET",
      "rel": "collection",
      "href": "/subjectContacts/traces",
      "uri": "/subjectContacts/traces",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.trace"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/subjectContacts/traces?filter=eq(sequenceNumber,1)&sortBy=traceTimeStamp:ascending,sequenceNumber:ascending:secondary&start=0&limit=10",
      "uri": "/subjectContacts/traces?filter=eq(sequenceNumber,1)&sortBy=traceTimeStamp:ascending,sequenceNumber:ascending:secondary&start=0&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.trace"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/subjectContacts/",
      "uri": "/subjectContacts/",
      "type": "application/vnd.sas.api"
    },
    {
      "method": "GET",
      "rel": "next",
      "href": "/subjectContacts/traces?filter=eq(sequenceNumber,1)&sortBy=traceTimeStamp:ascending,sequenceNumber:ascending:secondary&start=10&limit=10",
      "uri": "/subjectContacts/traces?filter=eq(sequenceNumber,1)&sortBy=traceTimeStamp:ascending,sequenceNumber:ascending:secondary&start=10&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.trace"
    },
    {
      "method": "GET",
      "rel": "last",
      "href": "/subjectContacts/traces?filter=eq(sequenceNumber,1)&sortBy=traceTimeStamp:ascending,sequenceNumber:ascending:secondary&start=210&limit=10",
      "uri": "/subjectContacts/traces?filter=eq(sequenceNumber,1)&sortBy=traceTimeStamp:ascending,sequenceNumber:ascending:secondary&start=210&limit=10",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.decision.trace"
    },
    {
      "method": "POST",
      "rel": "create",
      "href": "/subjectContacts/traces",
      "uri": "/subjectContacts/traces",
      "type": "text/tab-separated-values",
      "responseType": "multipart/mixed"
    }
  ],
  "name": "items",
  "start": 0,
  "count": 219,
  "items": [
    {
      "traceId": "3d4120b3-1fe7-4fce-b333-0ae1b93aa03c",
      "traceTimeStamp": "2020-08-07T18:02:23Z",
      "processorNote": "",
      "objectUri": "/decisions/flows/835b0890-bca3-42f1-8a50-9dcce2c4a377/revisions/6f5c045a-94a6-4f9b-9adc-cc1dde33558",
      "links": [
        {
          "method": "GET",
          "rel": "self",
          "href": "/subjectContacts/traces?filter=eq(traceId,'3d4120b3-1fe7-4fce-b333-0ae1b93aa03c')",
          "uri": "/subjectContacts/traces?filter=eq(traceId,'3d4120b3-1fe7-4fce-b333-0ae1b93aa03c')",
          "type": "application/vnd.sas.decision.trace"
        },
        {
          "method": "GET",
          "rel": "completeWithTraceText",
          "href": "/subjectContacts/traces?filter=eq(traceId,'3d4120b3-1fe7-4fce-b333-0ae1b93aa03c')",
          "uri": "/subjectContacts/traces?filter=eq(traceId,'3d4120b3-1fe7-4fce-b333-0ae1b93aa03c')",
          "type": "text/tab-separated-values"
        },
        {
          "method": "POST",
          "rel": "update",
          "href": "/subjectContacts/traces",
          "uri": "/subjectContacts/traces",
          "type": "text/tab-separated-values",
          "responseType": "multipart/mixed"
        },
        {
          "method": "DELETE",
          "rel": "delete",
          "href": "/subjectContacts/traces?filter=eq(traceId,'3d4120b3-1fe7-4fce-b333-0ae1b93aa03c')",
          "uri": "/subjectContacts/traces?filter=eq(traceId,'3d4120b3-1fe7-4fce-b333-0ae1b93aa03c')"
        }
      ]
    },
    ...
  ]
}
```


<br>


#### <a name='find-traces-with-filter'>Find Traces That Match Filter Conditions</a>

Here is an example of finding text that is produced by executing decisions.

* The columns are separated by the tab character.
* The text column contains multiple newline characters.

**Request**
```
  GET http://www.example.com/subjectContacts/traces?filter=and(ge(traceTimeStamp,'2020-08-07T12:00:00Z'),lt(traceTimeStamp,'2020-08-07T12:00:00Z'))&scope=step
  Headers:
  * Accept = text/tab-separated-values
  Body:
```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = text/tab-separated-values` 
 Body:
traceid	seqno	tracetimestamp	objecturi	processornote	text	
3d4120b3-1fe7-4fce-b333-0ae1b93aa03c	1	2020-08-07T18:02:23Z	/decisions/flows/835b0890-bca3-42f1-8a50-9dcce2c4a377/revisions/6f5c045a-94a6-4f9b-9adc-cc1dde33558		VVCT#STARTING_NODE_TRACE#3d4120b3-1fe7-4fce-b333-0ae1b93aa03c
VVCT#3d4120b3-1fe7-4fce-b333-0ae1b93aa03c#/decisions/flows/835b0890-bca3-42f1-8a50-9dcce2c4a377/revisions/6f5c045a-94a6-4f9b-9adc-cc1dde33558#Start
VVCT#3d4120b3-1fe7-4fce-b333-0ae1b93aa03c#a=6
VVCT#3d4120b3-1fe7-4fce-b333-0ae1b93aa03c#b=Bond Park
VVCT#3d4120b3-1fe7-4fce-b333-0ae1b93aa03c#c=Centennial Campus
VVCT#3d4120b3-1fe7-4fce-b333-0ae1b93aa03c#temp_dg_out=[{ "metadata": [ { "id_ip": "string" }, { "id_profile": "string" }, { "cd_tp_channel": "decimal" }, { "cd_tp_slot": "decimal" }, { "id_lead": "decimal" }, { "id_offer": "decimal" }, { "id_communication": "decimal" }, { "id_campaign": "decimal" }, { "cd_tp_target": "decimal" }, { "cd_tp_decision": "decimal" }, { "param_1_text": "string" }, { "param_2_text": "string" }, { "param_3_text": "string" }, { "param_4_text": "string" }, { "param_5_text": "string" } ] }, { "data": [ [ "perf_test", "perf_test", 1899, 1899, 1899, 1899, 1899, 1899, 1899, 1899, "perf_test", "perf_test", "perf_test", "perf_test", "perf_test" ] ] }]
VVCT#ENDING_NODE_TRACE#3d4120b3-1fe7-4fce-b333-0ae1b93aa03c
b1c164de-397c-47ad-8029-2a52bc255f83	1	append	2020-08-07T18:02:23Z	/decisions/flows/835b0890-bca3-42f1-8a50-9dcce2c4a377/revisions/6f5c045a-94a6-4f9b-9adc-cc1dde33558		VVCT#STARTING_NODE_TRACE#b1c164de-397c-47ad-8029-2a52bc255f83
VVCT#b1c164de-397c-47ad-8029-2a52bc255f83#/decisions/flows/835b0890-bca3-42f1-8a50-9dcce2c4a377/revisions/6f5c045a-94a6-4f9b-9adc-cc1dde33558#Start
VVCT#b1c164de-397c-47ad-8029-2a52bc255f83#a=8
VVCT#b1c164de-397c-47ad-8029-2a52bc255f83#b=biometric
VVCT#b1c164de-397c-47ad-8029-2a52bc255f83#c=cryptological
VVCT#b1c164de-397c-47ad-8029-2a52bc255f83#temp_dg_out=[ { "metadata": [ { "id_ip": "string" }, { "id_profile": "string" }, { "cd_tp_channel": "decimal" }, { "cd_tp_slot": "decimal" }, { "id_lead": "decimal" }, { "id_offer": "decimal" }, { "id_communication": "decimal" }, { "id_campaign": "decimal" }, { "cd_tp_target": "decimal" }, { "cd_tp_decision": "decimal" }, { "param_1_text": "string" }, { "param_2_text": "string" }, { "param_3_text": "string" }, { "param_4_text": "string" }, { "param_5_text": "string" } ] }, { "data": [ [ "perf_test", "perf_test", 1899, 1899, 1899, 1899, 1899, 1899, 1899, 1899, "perf_test", "perf_test", "perf_test", "perf_test", "perf_test" ], [ "perf_test", "perf_test", 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900, "perf_test", "perf_test", "perf_test", "perf_test", "perf_test" ], [ "perf_test", "perf_test", 1901, 1901, 1901, 1901, 1901, 1901, 1901, 1901, "perf_test", "perf_test", "perf_test", "perf_test", "perf_test" ] ] } ]
VVCT#ENDING_NODE_TRACE#b1c164de-397c-47ad-8029-2a52bc255f83
```


<br>


#### <a name='update-traces'>Update an Existing Trace</a>

Here is an example of updating the `processorNote` field. 

* The columns are separated by the tab character.
* The `traceid` must be the first column.
* On the data lines, there are five tab characters after the `traceId` column.
* Each line is terminated by a newline character.

**Request**
```
  POST http://www.example.com/subjectContacts/traces?scope=step
  Headers:
  * Content-Type = text/tab-separated-values
  * Accept = multipart/mixed, application/json
  Body:
traceid	text	objecturi	seqno	tracetimestamp	action	processorNote
3d4120b3-1fe7-4fce-b333-0ae1b93aa03c					update	report:
- proccessedTimeStamp:2020-08-26T16:19:03Z
  reportUri: /files/files/5844fc3a-cbd2-41b7-b624-a2cf4aef46ba
b1c164de-397c-47ad-8029-2a52bc255f83					update	report:
- processedTimeStamp: 2020-08-26T16:23:54Z
  reportUri: /files/files/e735d239-7cf2-42dc-bc93-d5906fec25d9

```

**Response**
```
 Status: 200
 Headers:
 * Content-Type = multipart/mixed`
 Body:

--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset="utf-8"
Content-ID: Accepted-TSV

3d4120b3-1fe7-4fce-b333-0ae1b93aa03c,The record with the trace ID "3d4120b3-1fe7-4fce-b333-0ae1b93aa03c" is updated.
b1c164de-397c-47ad-8029-2a52bc255f83,The record with the trace ID "b1c164de-397c-47ad-8029-2a52bc255f83" is updated.

--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset=utf-8
Content-ID: Rejected-TSV


--_001_002_003_004_005_006_007_008_009_010_011_012_
Content-Type: text/csv; charset=utf-8
Content-ID: Global-Issue


--_001_002_003_004_005_006_007_008_009_010_011_012_--

```


<br>

#### <a name='delete-traces-with-filter'>Delete Traces That Match Filter Conditions</a>

Here is an example of deleting all text where the `processorNote` field has a value. By using the scope parameter with the "all" value, both decision step boundary traces and variable assignment variable traces are deleted in the same operation.

**Request**
```
  DELETE http://www.example.com/subjectContacts/traces?filter=not(isNull(processorNote))&scope=all
  Headers:
  Body:
```

**Response**
```
 Status: 204
 Headers:
 Body:
```

<br>


#### <a name='process-a-trace'>Process a Trace</a>

Here is an example of processing a raw trace and storing the report as a Files service object.
The `reportUri` and `processedTimeStamp` content is stored in the `processorNote` column of the raw trace record.

**Request**
```
  POST http://www.example.com/subjectContacts/traces/6d707a51-62b3-40a4-4973-b2d9f12d20fe/process?scope=step
  Headers:
  Body:
```

**Response**
```
 Status: 201
 Headers:
   Content-Type: application/vnd.sas.decisions.trace.report+json
 Body:
 {
  "version": 1,
  "traceId":"6d707a51-62b3-40a4-4973-b2d9f12d20fe",
  "traceTimeStamp":"2020-09-08T14:29:30.000Z",
  "processedTimeStamp":"2020-09-08T14:35:27.000Z",
  "reportUri":"/files/files/b8bc8dd8-6747-4194-8b64-6f574f0f1f42",
  "objectUri":"/decisions/flows/501fa196-6d6e-4515-ac8f-3840ba576b56/revisions/37f0e7af-d27d-453c-b3a0-546f29c26a94",
  "links":[
     {
       "method":"POST",
       "rel":"self",
       "href":"/subjectContacts/traces/6d707a51-62b3-40a4-4973-b2d9f12d20fe/process?scope=step",
       "uri":"/subjectContacts/traces/6d707a51-62b3-40a4-4973-b2d9f12d20fe/process?scope=step",
       "type":"application/vnd.sas.decision.trace.report"
     },
     {
       "method":"GET",
       "rel":"reportContent",
       "href":"/files/files/b8bc8dd8-6747-4194-8b64-6f574f0f1f42/content",
       "uri":"/files/files/b8bc8dd8-6747-4194-8b64-6f574f0f1f42/content"
     },
     {
       "method":"GET",
       "rel":"rawContent",
       "href":"/subjectContacts/traces?filter=eq(traceId,'6d707a51-62b3-40a4-4973-b2d9f12d20fe')&scope=step",
       "uri":"/subjectContacts/traces?filter=eq(traceId,'6d707a51-62b3-40a4-4973-b2d9f12d20fe')&scope=step",
       "type":"text/tab-separated-values"
     }
  ]
 }
```

<br>

version 4, last updated 19 March, 2021
