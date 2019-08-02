# Decisions API
The Decisions API enables users to build and retrieve a decision flow by linking statistical models in combination with deterministic logic from business rules for the purpose of integrating them into an operational process. 

This API provides the following features:

* Offer integration to occur by adding treatments within the decision flow, which enables users to return a collection of best offers to callers. 
* Ability for users to build a sequential set of models accessed from Model Repository API, rule sets from the Business Rules API, treatment groups from the Treatment Definition API, and conditioning logic. 

The models, rules sets, treatment groups, and conditions are linked together via a common term list. After a decision flow is constructed, the Model Publish API can be used to publish the decision flows code to the SAS Micro Analytic Service for transactional web service execution, or to CAS destinations for batch processes.


Example processes that can be authored with the Decisions API would be loan approval, promotion offering, inventory purchasing, sales attribution, and many more.


Here is an example of a Credit Approval Decision for a small regional bank:

* Rule set - Validate State of Customer
* if stateIsValid = 'YES'
  * Model - Credit Scoring
  * Rule set - Credit Approval Rules
* else
  * Rule set - Auto Decline
  * Treatment group - Counter offers


#### Why Use this API?

This API enables users to build and retrieve decision making processes that can be published to transactional or batch targets.

## API Request Examples Grouped by Object Type

<details>
<summary>Decisions</summary>

* [Get API Resource Links](#top-level-api)
* [Create a Decision](#CreateDecision)
* [Create a Decision with Treatments](#CreateDecisionTreatments)
* [Update a Decision](#UpdateDecision)
* [Get a Decision](#GetDecision)
* [Get a Decision Summary](#GetDecisionSummary)
* [Delete a Decision](#DeleteDecision)
* [Get a Collection of Decisions](#GetCollectionDecisions)
* [Get the Generated Code for the Current Editable Version of a Decision](#GetGeneratedCodeCurrentEditableVersionDecision)
* [Create a Decision Version](#CreateDecisionVersion)
* [Get a Specific Version of a Decision](#GetSpecificVersionDecision)
* [Get All Versions for a Decision](#GetAllVersionsDecision)
* [Get the Last Modified Date and Time for a Decision Version](#GettheLastModifiedDateTimeDecisionVersion)
* [Get the Generated Code for a Specific Version of a Decision](#GetGeneratedCodeSpecificVersionDecision)
</details>

<details>
<summary>Code Files</summary>

* [Create a Code File](#CreateCodeFile)
* [Get a Code File](#GetCodeFile)
* [Get a Code File Summary](#GetCodeFileSummary)
* [Delete a Code File](#DeleteCodeFile)
* [Get the Collection of Code Files](#GetCollectionCodeFiles)
</details>

#### <a name='top-level-api'>Get API Resource Links</a>
```json
{
  "GET": "/decisions",
  "headers":{
		"Accept":"application/vnd.sas.api+json"
  }
}
```

`Response:`
```json
{
   "links": [
       {
          "method":"GET",
          "rel":"decisions",
          "href":"/decisions/flows",
          "uri":"/decisions/flows",
          "type":"application/vnd.sas.collection",
          "itemType":"application/vnd.sas.summary"
       },
       {
          "method":"POST",
          "rel":"createDecision",
          "href":"/decisions/flows",
          "uri":"/decisions/flows",
          "type":"application/vnd.sas.decision",
          "responseType":"application/vnd.sas.decision"
       },
       {
          "method":"GET",
          "rel":"codeFiles",
          "href":"/decisions/codeFiles",
          "uri":"/decisions/codeFiles",
          "type":"application/vnd.sas.collection",
          "itemType":"application/vnd.sas.summary"
       },
       {
          "method":"POST",
          "rel":"createCodeFile",
          "href":"/decisions/codeFiles",
          "uri":"/decisions/codeFiles",
          "type":"application/vnd.sas.decision.code.file",
          "responseType":"application/vnd.sas.decision.code.file"
       }
   ],
   "version":2
}
```

<br>


#### <a name='CreateDecision'>Create a Decision</a>
```json
{
	"POST": "/decisions/flows/",
	"headers":{
		"Accept":"application/vnd.sas.decision+json",
		"Content-Type":"application/vnd.sas.decision+json"
	},
	"body":{
	   "name": "CreditOffer",
	   "signature": [
	      {
	         "name": "CustIncome",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "EM_PROBABILITY",
	         "direction": "output",
	         "dataType": "decimal"
	      },
	      {
	         "name": "EM_SEGMENT",
	         "direction": "input",
	         "dataType": "decimal"
	      },
	      {
	         "name": "YOJ",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "DELINQ",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "origin",
	         "direction": "input",
	         "dataType": "string",
	         "defaultValue" : "WEB"
	      },
	      {
	         "name": "CreditAmount",
	         "direction": "output",
	         "dataType": "integer"
	      },
	      {
	         "name": "customerId",
	         "direction": "output",
	         "dataType": "string"
	      },
	      {
	         "name": "hasBadTransactionFlag",
	         "direction": "output",
	         "dataType": "integer"
	      },
	      {
	         "name": "transactions",
	         "direction": "input",
	         "dataType": "dataGrid",
	         "dataGridExtension": [
                 {
                     "name": "type",
                     "dataType": "string",
                     "length": 100
                 },
                 {
                     "name": "amount",
                     "dataType": "decimal"
                 },
                 {
                     "name": "isBad",
                     "dataType": "integer"
                 }
             ]
	      }
	   ],
	   "subjectId": {
		   "name":"customerId"	   
		},
	   "subjectLevel": "customer",		   
	   "flow": {
	      "steps": [
	         {
	             "type": "application/vnd.sas.decision.step.ruleset",
	             "ruleset": {
	                 "name": "Transaction Check",
	                 "id": "e73870fa-1d40-44d1-99b9-2157a084adcc",
	                 "versionId": "55555555-f66c-4090-89ed-331c3743eaf2"
	              },
	              "mappingDataGridName": "transactions",
	              "mappings": [
	                  {
	                      "stepTermName": "YOJ",
	                      "direction": "input",
	                      "targetDecisionTermName": "YOJ"
	                  },
	                  {
                          "targetDataGridTermName": "type",
                          "direction": "input",
                          "stepTermName": "transType"
                      },
                      {
                          "targetDataGridTermName": "amount",
                          "direction": "input",
                          "stepTermName": "amount"
                      },
                      {
                          "targetDataGridTermName": "isBad",
                          "direction": "output",
                          "stepTermName": "badTransaction"
                      }
	              ]
	         },
	         {
	             "type": "application/vnd.sas.decision.step.ruleset",
	             "ruleset": {
	                 "name": "Aggregate Transaction Flag",
	                 "id": "e73870fa-5631-44d1-99b9-2157a084adcc",
	                 "versionId": "123456-f66c-4090-89ed-331c3743eaf2"
	              },
	              "mappings": [
	                  {
	                      "stepTermName": "flaggedTransactions",
	                      "direction": "input",
	                      "targetDecisionTermName": "transactions"
	                  },
	                  {
	                      "stepTermName": "hasBadTransactionFlag",
	                      "direction": "input",
	                      "targetDecisionTermName": "hasBadTransactionFlag"
	                  }
	              ]
	         }, 
	         {
	            "type": "application/vnd.sas.decision.step.model",
	            "model": {
	               "name": "CreditScore",
	               "id": "dfeda8cc-2d5a-4e86-bfcd-17add2b08b87"
	            },
	            "mappings": [
	               {
	                  "stepTermName": "CustIncome",
	                  "direction": "input",
	                  "targetDecisionTermName": "CustIncome"
	               },
	               {
	                  "stepTermName": "EM_PROBABILITY",
	                  "direction": "output",
	                  "targetDecisionTermName": "EM_PROBABILITY"
	               },
	               {
	                  "stepTermName": "EM_SEGMENT",
	                  "direction": "output",
	                  "targetDecisionTermName": "EM_SEGMENT"
	               }
	            ]            
	         },
             {
                "type": "application/vnd.sas.decision.step.custom.object",
                "customObject": {
                   "uri": "/files/files/6135a87e-f568-11e7-8c3f-9a214cf093ae",
                   "name": "ExtendedCreditScoreFromFile",
                   "type" : "decisionDs2CodeFile"
                },
                "mappings": [
                   {
                      "stepTermName": "CustIncome",
                      "direction": "input",
                      "targetDecisionTermName": "CustIncome"
                   },
                   {
                      "stepTermName": "EM_PROBABILITY",
                      "direction": "output",
                      "targetDecisionTermName": "EM_PROBABILITY"
                   },
                   {
                      "stepTermName": "EM_SEGMENT",
                      "direction": "output",
                      "targetDecisionTermName": "EM_SEGMENT"
                   }
                ]
             },
             {
                "type": "application/vnd.sas.decision.step.record.contact",
                "recordContact": {
                   "name": "Record Contact 1",
                   "ruleFiredTracking" : true,
                   "pathTracking" : false,
                   "channelTerm" : "origin",
                   "auditTerms" : [
                       {"name":"EM_PROBABILITY"},
                       {"name":"CustIncome"}
                   ]
                }
             },
	         {
	            "type": "application/vnd.sas.decision.step.condition",
	            "condition": {
	               "lhsTerm": {
	                  "name": "EM_PROBABILITY"
	               },
	               "rhsConstant": ".8",
	               "operator": ">"
	            },
	            "onTrue": {
	               "steps": [
	                  {
	                     "type": "application/vnd.sas.decision.step.ruleset",
	                     "ruleset": {
	                        "name": "OfferCredit",
	                        "id": "d71140fa-1d40-44d1-99b9-2157a084adcc",
	                        "versionId": "3483ed58-f66c-4090-89ed-331c3743eaf2"
	                     },
	                     "mappings": [
	                        {
	                           "stepTermName": "YOJ",
	                           "direction": "inOut",
	                           "targetDecisionTermName": "YOJ"
	                        },
	                        {
	                           "stepTermName": "DELINQ",
	                           "direction": "inOut",
	                           "targetDecisionTermName": "DELINQ"
	                        },
	                        {
	                           "stepTermName": "CreditAmount",
	                           "direction": "output",
	                           "targetDecisionTermName": "CreditAmount"
	                        }
	                     ]
	                  }
	               ]
	            },
	            "onFalse": {
	               "steps": [
	                  {
	                     "type": "application/vnd.sas.decision.step.ruleset",
	                     "ruleset": {
	                        "name": "DenyCredit",
	                        "id": "686c1a62-0a71-486d-afca-f011c231abfc",
	                        "versionId": "fca7da09-b3fb-4261-8c28-6f8918bab7ba"
	                     },
	                     "mappings": [
	                        {
	                           "stepTermName": "CreditAmount",
	                           "direction": "output",
	                           "targetDecisionTermName": "CreditAmount"
	                        }
	                     ]
	                  }
	               ]
	            }
	         }
	      ]
	   }
	}
}
```

`Partial response headers and body:`
```json
{
      "headers" : {
            "Location": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7",
            "Last-Modified": "Wed, 11 Apr 2018 01:39:02 GMT",
            "Content-Type": "application/vnd.sas.decision+json"
      },
      "body" : {
           "name": "CreditOffer", 
	   "id": "43f73aff-2040-4152-9923-9dbb37e73ba7",
           "modifiedTimeStamp": "2018-04-11T01:39:02.912Z", 
           "creationTimeStamp": "2018-04-11T01:39:02.912Z", 
           "createdBy": "userdoe", 
           "modifiedBy": "userdoe", 
           "majorRevision": 1,
           "minorRevision": 0,
           "links": [
              {
                  "rel": "self", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7",
                  "type": "application/vnd.sas.decision"
              }, 
              {
                  "rel": "revisions", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/revisions", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/revisions", 
                  "type": "application/vnd.sas.collection", 
                  "itemType": "application/vnd.sas.decision"
              }, 
              {
                  "rel": "currentRevision", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7",
                  "type": "application/vnd.sas.decision"
              }, 
              {
                  "rel": "code", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/code", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/code",
                  "type": "text/vnd.sas.source.ds2"
              }, 
              {
                  "rel": "mappedCode", 
                  "method": "POST",
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/mappedCode", 
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/mappedCode", 
                  "type": "application/vnd.sas.score.code.generation.request", 
                  "responseType": "application/vnd.sas.score.mapped.code"
              }, 
              {
                  "rel": "externalArtifacts", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/externalArtifacts", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/externalArtifacts", 
                  "type": "application/vnd.sas.collection", 
                  "itemType": "application/vnd.sas.decision.external.artifact"
              }, 
              {
                  "rel": "delete", 
                  "method": "DELETE",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7"
              }, 
              {
                  "rel": "update", 
                  "method": "PUT",
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "type": "application/vnd.sas.decision", 
                  "responseType": "application/vnd.sas.decision"
              }
           ], 
           "version": 2 
        }
}

```
<br>

#### <a name='CreateDecisionTreatments'>Create a Decision with Treatments</a>
```json
{
	"POST": "/decisions/flows/",
	"headers":{
		"Accept":"application/vnd.sas.decision+json",
		"Content-Type":"application/vnd.sas.decision+json"
	},
	"body":{
	   "name": "Loan offers with Treatments",
	   "signature": [
	      {
	         "name": "CustIncome",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "YOJ",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "DELINQ",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "origin",
	         "direction": "input",
	         "dataType": "string",
	         "defaultValue" : "WEB"
	      },
	      {
	         "name": "customerId",
	         "direction": "output",
	         "dataType": "string"
	      },
	      {
	         "name": "specialScenarioIndicator",
	         "direction": "output",
	         "dataType": "integer"
	      },
	      {
	         "name": "loanOffers",
	         "direction": "output",
	         "dataType": "dataGrid",
	         "dataGridExtension": [
                 {
                     "name": "loanType",
                     "dataType": "string",
                     "length": 100
                 },
                 {
                     "name": "amount",
                     "dataType": "decimal"
                 },
                 {
                     "name": "lengthOfLoan",
                     "dataType": "integer"
                 }
             ]
	      }
	   ],
	   "subjectId": {
		   "name":"customerId"
	   },
	   "subjectLevel": "customer",
	   "flow": {
	         "steps": [
	         {
	             "type": "application/vnd.sas.decision.step.ruleset",
	             "ruleset": {
	                 "name": "Examine Special Scenarios",
	                 "id": "f73870fa-5631-44d1-99b9-2157a084adcc",
	                 "versionId": "fe14fe-f66c-4090-89ed-331c3743eaf2"
	              },
	              "mappings": [
	                  {
                         "stepTermName": "CustIncome",
                         "direction": "input",
                         "targetDecisionTermName": "CustIncome"
                     },
                     {
                         "stepTermName": "YOJ",
                         "direction": "input",
                         "targetDecisionTermName": "YOJ"
                     },
                     {
                         "stepTermName": "DELINQ",
                         "direction": "input",
                         "targetDecisionTermName": "DELINQ"
                     },
	                  {
	                      "stepTermName": "specialScenarioIndicator",
	                      "direction": "output",
	                      "targetDecisionTermName": "specialScenarioIndicator"
	                  }
	              ]
	         },
	         {
                "type": "application/vnd.sas.decision.step.custom.object",
                "customObject": {
                    "uri": "/treatmentDefinitions/definitionGroups/acc6cbd5-e5bd-48ab-9c36-7e616c8147cd",
                    "name": "Combined Treatments_Final",
                    "type": "treatmentGroup"
                },
                "mappingDataGridName": "loanOffers",
                "mappings": [
                   {
                      "stepTermName": "CustIncome",
                      "direction": "input",
                      "targetDecisionTermName": "CustIncome"
                   },
                   {
                      "stepTermName": "YearsOnJob",
                      "direction": "input",
                      "targetDecisionTermName": "YOJ"
                   },
                   {
                      "stepTermName": "specialScenarioIndicator",
                      "direction": "input",
                      "targetDecisionTermName": "specialScenarioIndicator"
                   },
                   {
                      "stepTermName": "lengthOfLoan",
                      "direction": "output",
                      "targetDataGridTermName": "lengthOfLoan"
                   },
                   {
                      "stepTermName": "amount",
                      "direction": "output",
                      "targetDataGridTermName": "amount"
                   },
                   {
                      "stepTermName": "loanType",
                      "direction": "output",
                      "targetDataGridTermName": "loanType"
                   }
                ]
             },
             {
                "type": "application/vnd.sas.decision.step.record.contact",
                "recordContact": {
                   "name": "Record contact for Loan Offers",
                   "ruleFiredTracking" : true,
                   "pathTracking" : false,
                   "channelTerm" : "origin",
                   "treatmentDatagridTerm" : "loanOffers",
                   "auditTerms" : [
                       {"name":"CustIncome"}
                   ]
                }
             }
	      ]
	   }
	}
}
```

`Partial response headers and body:`
```json
{
      "headers" : {
            "Location": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7",
            "Last-Modified": "Wed, 11 Apr 2018 01:39:02 GMT",
            "Content-Type": "application/vnd.sas.decision+json"
      },
      "body" : {
           "name": "Loan offers with Treatments", 
	       "id": "43f73aff-2040-4152-9923-9dbb37e73ba7",
           "modifiedTimeStamp": "2018-04-11T01:39:02.912Z", 
           "creationTimeStamp": "2018-04-11T01:39:02.912Z", 
           "createdBy": "userdoe", 
           "modifiedBy": "userdoe", 
           "majorRevision": 1,
           "minorRevision": 0,
           "links": [
              {
                  "rel": "self", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7",
                  "type": "application/vnd.sas.decision"
              }, 
              {
                  "rel": "revisions", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/revisions", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/revisions", 
                  "type": "application/vnd.sas.collection", 
                  "itemType": "application/vnd.sas.decision"
              }, 
              {
                  "rel": "currentRevision", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7",
                  "type": "application/vnd.sas.decision"
              }, 
              {
                  "rel": "code", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/code", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/code",
                  "type": "text/vnd.sas.source.ds2"
              }, 
              {
                  "rel": "mappedCode", 
                  "method": "POST",
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/mappedCode", 
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/mappedCode", 
                  "type": "application/vnd.sas.score.code.generation.request", 
                  "responseType": "application/vnd.sas.score.mapped.code"
              }, 
              {
                  "rel": "externalArtifacts", 
                  "method": "GET",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/externalArtifacts", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7/externalArtifacts", 
                  "type": "application/vnd.sas.collection", 
                  "itemType": "application/vnd.sas.decision.external.artifact"
              }, 
              {
                  "rel": "delete", 
                  "method": "DELETE",
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7"
              }, 
              {
                  "rel": "update", 
                  "method": "PUT",
                  "uri": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "href": "/decisions/flows/43f73aff-2040-4152-9923-9dbb37e73ba7", 
                  "type": "application/vnd.sas.decision", 
                  "responseType": "application/vnd.sas.decision"
              }
           ], 
           "version": 2 
        }
}

```
<br>

#### <a name='UpdateDecision'>Update a Decision</a>
```json
{
	"PUT": "/dedisions/flows/",
	"headers":{
		"Accept":"application/vnd.sas.decision+json",
		"Content-Type":"application/vnd.sas.decision+json",
		"If-Unmodified-Since" : "Wed, 11 Apr 2018 01:39:02 GMT"
	},
	"body":{
	   "name": "CreditOffer",
	   "id": "43f73aff-2040-4152-9923-9dbb37e73ba7",
	   "signature": [
	      {
	         "name": "CustIncome",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "EM_PROBABILITY",
	         "direction": "output",
	         "dataType": "decimal"
	      },
	      {
	         "name": "EM_SEGMENT",
	         "direction": "input",
	         "dataType": "decimal"
	      },
	      {
	         "name": "YOJ",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "DELINQ",
	         "direction": "inOut",
	         "dataType": "decimal"
	      },
	      {
	         "name": "origin",
	         "direction": "input",
	         "dataType": "string",
	         "defaultValue" : "WEB"
	      },
	      {
	         "name": "CreditAmount",
	         "direction": "output",
	         "dataType": "integer"
	      },
	      {
	         "id" : "e4875e13-6df7-4e40-bc4e-ae977f5469e3",
	         "name": "customerId",
	         "direction": "output",
	         "dataType": "string",
	         "defaultValue" : "-"
	      },
	      {
	         "name": "hasBadTransactionFlag",
	         "direction": "output",
	         "dataType": "integer"
	      },
	      {
	         "name": "transactions",
	         "direction": "input",
	         "dataType": "dataGrid",
	         "dataGridExtension": [
                 {
                     "name": "type",
                     "dataType": "string",
                     "length": 100
                 },
                 {
                     "name": "amount",
                     "dataType": "decimal"
                 },
                 {
                     "name": "isBad",
                     "dataType": "integer"
                 }
             ]
	      }
	   ],
	   "subjectId": {
	      "id" : "e4875e13-6df7-4e40-bc4e-ae977f5469e3",
		   "name":"customerId"
	   },
	   "subjectLevel": "household",		   
	   "flow": {
		    "id": "dc271752-275f-4a15-aef7-442434f1097d",
	        "steps": [
		         {
		            "type": "application/vnd.sas.decision.step.model",
	                "id": "e1a6f9bc-c7fe-4e4e-a38a-ac3397db5fef",
		            "model": {
		               "name": "CreditScore",
		               "id": "dfeda8cc-2d5a-4e86-bfcd-17add2b08b87"
		            },
		            "mappings": [
		               {
		                  "stepTermName": "CustIncome",
		                  "direction": "input",
		                  "targetDecisionTermName": "CustIncome",
		                  "id": "023c2373-6b2f-4c33-a6ed-6cb37ec29169"
		               },
		               {
		                  "stepTermName": "EM_PROBABILITY",
		                  "direction": "output",
		                  "targetDecisionTermName": "EM_PROBABILITY",
		                  "id": "0d7251a6-7ff3-47c4-8322-386f321e8362"
		               },
		               {
		                  "stepTermName": "EM_SEGMENT",
		                  "direction": "output",
		                  "targetDecisionTermName": "EM_SEGMENT",
		                  "id": "f2e89bd1-0985-4c47-a6d8-f09136418e36"
		               }
		            ]            
		         },
                 {
                    "type": "application/vnd.sas.decision.step.custom.object",
                    "id": "78da5dbc-f568-11e7-8c3f-9a214cf093ae",
                    "customObject": {
                        "uri": "/files/files/6135a87e-f568-11e7-8c3f-9a214cf093ae",
                        "name": "ExtendedCreditScoreFromFile",
                        "type" : "decisionDs2CodeFile"
                    },
                    "mappings": [
                       {
                          "stepTermName": "CustIncome",
                          "direction": "input",
                          "targetDecisionTermName": "CustIncome",
                          "id": "99ec1306-f568-11e7-8c3f-9a214cf093ae"
                       },
                       {
                          "stepTermName": "EM_PROBABILITY",
                          "direction": "output",
                          "targetDecisionTermName": "EM_PROBABILITY",
                          "id": "9ee1e3e0-f568-11e7-8c3f-9a214cf093ae"
                       },
                       {
                          "stepTermName": "EM_SEGMENT",
                          "direction": "output",
                          "targetDecisionTermName": "EM_SEGMENT",
                          "id": "a21a9dea-f568-11e7-8c3f-9a214cf093ae"
                       }
                    ]            
                 },
                 {
                    "type": "application/vnd.sas.decision.step.record.contact",
                    "id": "97da9dbc-9568-11e7-8c3f-9b214cf093ae",
                    "recordContact": {
                        "name": "Record Contact 1",
                        "ruleFiredTracking" : false,
                        "channelTerm" : "origin",
                        "pathTracking" : false,
                        "auditTerms" : [
                           {"name":"EM_PROBABILITY"},
                           {"name":"CustIncome"},
                           {"name":"EM_SEGMENT"}
                        ]
                   }
                },
		         {
		            "type": "application/vnd.sas.decision.step.condition",
		            "id": "5a246276-9576-4ffc-917c-f4ad48d0910b",
		            "condition": {
		               "lhsTerm": {
		                  "name": "EM_PROBABILITY"
		               },
		               "rhsConstant": ".8",
		               "operator": ">"
		            },
		            "onTrue": {
		               "id": "0da51b99-e17e-4bcc-8ba5-5debb3698a3f",
		               "steps": [
		                  {
		                     "type": "application/vnd.sas.decision.step.ruleset",
		                     "id": "c8d051f9-b09c-4d73-9e01-4e60ce8fcb77",
		                     "ruleset": {
		                        "name": "OfferCredit",
		                        "id": "d71140fa-1d40-44d1-99b9-2157a084adcc",
		                        "versionId": "3483ed58-f66c-4090-89ed-331c3743eaf2"
		                     },
		                     "mappings": [
		                        {
		                           "stepTermName": "YOJ",
		                           "direction": "inOut",
		                           "targetDecisionTermName": "YOJ",
		                           "id": "0c9b5ea1-96cf-41cb-94fe-f44cde8e1d9a"
		                        },
		                        {
		                           "stepTermName": "DELINQ",
		                           "direction": "inOut",
		                           "targetDecisionTermName": "DELINQ",
		                           "id": "7f0ac7d3-33f1-45b7-8526-d63a05aeb5e6"
		                        },
		                        {
		                           "stepTermName": "CreditAmount",
		                           "direction": "output",
		                           "targetDecisionTermName": "CreditAmount",
		                           "id": "23590aee-9bfc-49da-bcba-13f21820cf04"
		                        }
		                     ]
		                  }
		               ]
		            },
		            "onFalse": {
		               "id": "495d3376-6023-4a78-94ee-9d7f70a612a2",
		               "steps": [
		                  {
		                     "type": "application/vnd.sas.decision.step.ruleset",
                             "id": "b1dd6a2f-c9f6-45b6-883e-56eb720abc6f",
		                     "ruleset": {
		                        "name": "DenyCredit",
		                        "id": "686c1a62-0a71-486d-afca-f011c231abfc",
		                        "versionId": "fca7da09-b3fb-4261-8c28-6f8918bab7ba"
		                     },
		                     "mappings": [
		                        {
		                           "stepTermName": "CreditAmount",
		                           "direction": "output",
		                           "targetDecisionTermName": "CreditAmount",
		                           "id": "5c43811f-de22-47a7-b2c5-97351dffdd26"
		                        }
		                     ]
		                  }
		               ]
		            }
		         }
		      ]
	   }
	}
}
```
<br>

#### <a name='GetDecision'>Get a Decision</a>
```json
{
  "GET": "/decisions/flows/{decisionId}",
  "headers":{
		"Accept":"application/vnd.sas.decision+json"
}
}
```
<br>

#### <a name='GetDecisionSummary'>Get a Decision Summary</a>
```json
{
  "GET": "/decisions/flows/{decisionId}",
  "headers":{
		"Accept":"application/vnd.sas.summary+json"
	}
}
```
<br>

#### <a name='DeleteDecision'>Delete a Decision</a>
```json
{
  "DELETE": "/decisions/flows/{decisionId}"
}
```
<br>

#### <a name='GetCollectionDecisions'>Get a Collection of Decisions</a>
```json
{
  "GET": "/decisions/flows",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='GetGeneratedCodeCurrentEditableVersionDecision'>Get the Generated Code for the Current Editable Version of a Decision</a>
```json
{
	"GET":"/decisions/flows/{decisionId}/code",
	"headers": {
	    "Accept": "text/vnd.sas.source.ds2"
	}
}
```
<br>

#### <a name='CreateDecisionVersion'>Create a Decision Version</a>
```json
{
	"POST":"/decisions/flows/{decisionId}",
	"headers":{
		"Accept":"application/vnd.sas.decision+json",
		"Content-Type":"application/vnd.sas.decision+json"
	},
	"body":{
		"name":"Credit_Offer_Decision",
		"description":"This decision is for determining whether to offer credit to an applicant.",
		"signature":[
		   {
		      "direction":"inOut",
		      "name":"Cylinders",
		      "dataType":"decimal"
		   },
		   {
		      "direction":"inOut",
		      "name":"EngineSize",
		      "dataType":"decimal"
	       },
		   {
		      "direction":"output",
		      "name":"Type",
		      "dataType":"string"
		   },
		   {
		      "direction":"output",
		      "name":"vin",
		      "dataType":"string"
		   }		   
		],
		"subjectId": {
		      "name":"vin"
		},
		"subjectLevel": "household",	 				
		"flow":{		   
		   "steps":[
		      {
		         "ruleset":{
		            "id":"0d75574d-36da-4043-b1ed-8e40e4b2a732",
		            "name":"Rule_set_1",
		            "versionId":"9fcabcfd-590f-4efd-9bf5-0568543ad84a",
		            "versionName":"1.0"
		         },
		         "mappings":[
		            {    
		               "targetDecisionTermName":"EngineSize",
		               "direction":"inOut",
		               "stepTermName":"EngineSize"
		            },
		            {
		               "targetDecisionTermName":"Cylinders",
		               "direction":"inOut",
		               "stepTermName":"Cylinders"
		            },
		            {
		               "targetDecisionTermName":"Type",
		               "direction":"output",
		               "stepTermName":"Type"
		            }
		         ]
		      }
		   ]
		}
	  }
	}
```
<br>


#### <a name='GetSpecificVersionDecision'>Get a Specific Version of a Decision</a>
```json
{
  "GET": "/decisions/flows/{decisionId}/revisions/{revisionId}",
  "headers":{
		"Accept":"application/vnd.sas.decision+json"
	}
}
```

#### <a name='GetAllVersionsDecision'>Get All Versions for a Decision</a>
```json
{
  "GET": "/decisions/flows/{decisionId}/revisions",
  "headers":{
		"Accept":"application/vnd.sas.collection+json"
	}
}
```
<br>

#### <a name='GettheLastModifiedDateTimeDecisionVersion'>Get the Last Modified Date and Time for a Decision Version</a>
```json
{
  "HEAD": "/decisions/flows/{decisionId}/revisions/{revisionId}"  
}
```
<br>

#### <a name='GetGeneratedCodeSpecificVersionDecision'>Get the Generated Code for a Specific Version of a Decision</a>
```json
{
	"GET":"/decisions/flows/{decisionId}/revisions/{revisionId}/code",
	"headers": {
	    "Accept": "text/vnd.sas.source.ds2"
	}
}
```
<br>


#### <a name='CreateCodeFile'>Create a Code File</a>
```json
{
    "POST": "/decisions/codeFiles",
    "headers":{
        "Accept":"application/vnd.sas.decision.code.file+json",
        "Content-Type":"application/vnd.sas.decisioncode.file+json"
    },
    "body":{
       "type": "decisionDS2PackageFile",
       "fileUri": "/files/files/0c7281d8-063d-49dd-be6b-392e9c9e930c"
    }
}
```
<br>


#### <a name='GetCodeFile'>Get a Code File</a>
```json
{
  "GET": "/decisions/codeFiles/{codeFileId}",
  "headers":{
        "Accept":"application/vnd.sas.decision.code.file+json"
  }
}
```
<br>

#### <a name='GetCodeFileSummary'>Get a Code File Summary</a>
```json
{
  "GET": "/decisions/codeFiles/{codeFileId}",
  "headers":{
        "Accept":"application/vnd.sas.summary+json"
    }
}
```
<br>

#### <a name='DeleteCodeFile'>Delete a Code File</a>
```json
{
  "DELETE": "/decisions/codeFiles/{codeFileId}"
}
```
<br>

#### <a name='GetCollectionCodeFiles'>Get the Collection of Code Files</a>
```json
{
  "GET": "/decisions/codeFiles",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

version 4, last updated 09 Jul, 2019