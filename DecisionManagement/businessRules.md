# Business Rules API
The Business Rules API manages a repository of business rules that are organized within rule sets. These rule sets enable users to perform the following actions:

* create rules composed of conditions and actions
* organize them into logical sets
* create revisions of their rule sets
* generate code to be able to leverage the rules within operational processes such as transactional web services

In addition, rule sets can be included in decision flows, which can also be consumed by other operational processes.

An example of a rule set and its contained rules is a loan approval where multiple rules around various aspects of the customer need to be verified within one logical set of rules as shown below:

* age - if age < 18 then approved = false
* geographical requirements - if isCitizen = true then approved = false
* creditScore - if creditScore < 300 then approved = false

#### Revisions
This API enables you to not only do basic create, update, delete, and read capabilities with rule sets, but also allows users to create revisions of rule sets. Users also have the capability to delete locked revisions. However, the current unlocked version cannot be deleted.

 Revisions are versions of the rule set and contained rules that are associated with a major and minor number and can be locked. Once they are locked, you cannot unlock a revision for auditing purposes. The API controls the major and minor numbering of the revisions and locking. Users have control to request a major or minor revision to be created, and a new number is assigned for them based on the current revisions available.

 After a new version is created, any existing revision is locked to prevent multiple revisions being edited at once. The `ruleSetName` and `description` are not tracked within the revision but all other fields are tracked.

#### Why Use this API?
This API manages business rules and retrieves the code to be able to leverage the rules within an operational process.

## API Request Examples

* [Create a rule set](#create-rule-set)
* [Get a rule set](#get-rule-set)
* [Delete a rule set](#delete-rule-set)
* [Get the collection of rule sets](#get-collection-rule-sets)
* [Add a rule to a rule set](#add-rule-to-rule-set)
* [Add a rule referencing a lookup in a condition to a rule set](#add-rule-ref-lookup-condition-rule-set)
* [Add a rule to a rule set that references a common rule set](#add-rule-ref-common-rule-set)
* [Update the ordering of rules within a rule set](#update-ordering-rules-rule-set)
* [Delete a rule from a rule set](#delete-rule-from-rule-set)
* [Create a minor revision of the rule set](#create-revision-rule-set)
* [Get the direct dependent objects of a rule set](#get-rule-set-direct-dependent-objects)
* [Convert a rule action](#convert-rule-action)
* [Convert a rule condition](#convert-rule-condition)

#### <a name='create-rule-set'>Create a Rule Set</a>

Here is an example of how to create a rule set.

```json 
{
  "POST": "/businessRules/ruleSets",
  "headers": {
    "Content-Type": "application/vnd.sas.business.rule.set+json",
    "Accept": "application/vnd.sas.business.rule.set+json"
  },
  "body": {
  "name": "Cost Categorization",
  "ruleSetType": "assignment",
  "description": "Determine cost categorization for vehicle",
  "testCustomContextUri": "/decisions/codeFiles/bf73b438-d426-49b8-9b75-7565b9a2073e/revisions/1b162c7e-f9c2-47d8-9321-141413fee25b",
  "signature": [
    {
      "name": "vehicleCost",
      "dataType": "decimal",
      "direction": "input"
    },
    {
      "name": "model",
      "dataType": "string",
      "direction": "input",
      "length": 100,
      "defaultValue": "FORD"
    },
    {
      "name": "accidents",
      "dataType": "dataGrid",
      "direction": "input",
      "dataGridExtension": [
          {
              "name": "accidentType",
              "dataType": "string",
              "length": 100
          },
          {
              "name": "repairCost",
              "dataType": "decimal"
          }
     ]
    },
    {
      "name": "isHighCost",
      "dataType": "boolean",
      "direction": "output"
    },
    {
      "name": "hasDocumentedPricing",
      "dataType": "boolean",
      "direction": "output"
    }
  ]
  }
}
```
<br>

#### <a name='get-rule-set'>Get a Rule Set</a>

Here is an example of how to get a rule set.

```json 
{
  "GET": "/businessRules/ruleSets/{ruleSetId}",
  "headers": {
    "Accept": "application/vnd.sas.business.rule.set+json"
  }
}
```
<br>

#### <a name='delete-rule-set'>Delete a Rule Set</a>

Here is an example of how to delete a rule set.

```json 
{
  "DELETE": "/businessRules/ruleSets/{ruleSetId}"
}
```
<br>

#### <a name='get-collection-rule-sets'>Get the Collection of Rule Sets</a>

Here is an example of how to get the collection of rule sets.

```json 
{
  "GET": "/businessRules/ruleSets",
  "headers": {
    "Accept": "application/vnd.sas.collection+json"
  }
}
```
<br>

#### <a name='add-rule-to-rule-set'>Add a Rule to a Rule Set</a>

Here is an example of how to add a rule to a rule set.

```json
{
  "POST": "/businessRules/ruleSets/{ruleSetId}/rules",
  "headers": {
    "Content-Type": "application/vnd.sas.business.set+json",
    "Accept": "application/vnd.sas.business.set+json"
  },
  "body": {
  "name": "Vehicle Categorization",
  "description": "Look at vehicle cost to determine category",
  "ruleFiredTrackingEnabled": true,
  "conditional": "if",
  "conditions": [
    {
      "term": {
        "name": "vehicleCost"
      },
      "expression": "> 15000",
      "type": "decisionTable"
    }
  ],
  "actions": [
    {
      "term": {
        "name": "isHighCost"
      },
      "expression": " true ",
      "type": "assignment"
    }
  ]
}
}
```
<br>

#### <a name='add-rule-ref-lookup-condition-rule-set'>Add a Rule Referencing a Lookup in a Condition to a Rule Set</a>

Here is an example of how to add a rule referencing a lookup in a condition to a rule set.

```json
{
  "POST": "/businessRules/ruleSets/{ruleSetId}/rules",
  "headers": {
    "Content-Type": "application/vnd.sas.business.set+json",
    "Accept": "application/vnd.sas.business.set+json"
  },
  "body": {
  "name": "Vehicle Categorization",
  "description": "Look at vehicle cost to determine category",
  "ruleFiredTrackingEnabled": true,
  "conditional": "if",
  "conditions": [
    {
      "term": {
        "name": "model"
      },
      "lookup": {
        "id": "50ef4e9d-2127-4560-8ab2-7ef11a7fb1af"
      },
      "type": "lookup"
    }
  ],
  "actions": [
    {
      "term": {
        "name": "hasDocumentedPricing"
      },
      "expression": "true",
      "type": "assignment"
    }
  ]
}
}
```
<br>

#### <a name='add-rule-ref-common-rule-set'>Add a Rule to a Rule Set That References a Common Rule Set</a>

Here is an example of how to add a rule to a rule set that references a common rule set.

```json
{
  "name": "Reference Rule",
  "description": "sample reference rule",
  "ruleFiredTrackingEnabled": false,
  "conditional": "ref",
  "mappings":[
    {
      "rulesetTermName":"fop",
      "mappedRulesetTermName":"foo",
      "direction":"inOut"
    },
    {
      "rulesetTermName":"bam",
      "mappedRulesetTermName":"bar",
      "direction":"inOut"
    }

  ],
  "common_rule_set_id":"b02a362e-0745-4994-a708-90947b581791",
  "common_rule_set_version_id":"3ac25217-6bba-472b-9de2-542e4e7fcd5b",
  "status": "valid"
}
```
<br>


#### <a name='update-ordering-rules-rule-set'>Update the Ordering of Rules within a Rule Set</a>

Here is an example of how to update the ordering of rules within a rule set.

```json 
{
  "PUT": "/businessRules/ruleSets/{ruleSetId}/order",
  "headers": {
    "Content-Type": "application/vnd.sas.selection+json",
    "Accept": "application/vnd.sas.selection+json",
    "If-Unmodified-Since" : "Mon, 07 Aug 2017 12:57:52 GMT"
  },
  "body": {
  "type": "id",
  "template": "/businessRules/ruleSets/6c91ee3c-110e-4599-8224-45e29f34ad55/rules/{id}",
  "resources": [
    "6b2b4721-c0ca-4d66-ab4d-d0732fc5266a",
    "a0e9bdc9-659e-4419-852c-083d270e2ea8",
    "e51ca7ed-2232-482d-9b8d-1432f87f5f12",
    "83a16244-3be2-415b-a8f1-4b261cd7cf27"
  ]
}

}
```
<br>

#### <a name='delete-rule-from-rule-set'>Delete a Rule from a Rule Set</a>

Here is an example of how to delete a rule from a rule set.

```json
{
  "DELETE": "/businessRules/ruleSets/{ruleSetId}/rules/{ruleId}"
}
```
<br>

#### <a name='create-revision-rule-set'>Create a Minor Revision of the Rule Set</a>

Here is an example of how to create a minor revision of the rule set.

```json 
{
  "POST": "/businessRules/ruleSets/{ruleSetId}/revisions?revisionType=minor",
  "headers": {
    "Content-Type": "application/vnd.sas.business.rule.set+json",
    "Accept": "application/vnd.sas.business.rule.set+json"
  },
  "body": {
  "name": "Cost Categorization",
  "description": "Determine cost categorization for vehicle",
  "signature": [
    {
      "name": "vehicleCost",
      "dataType": "decimal",
      "direction": "input"
    },
    {
      "name": "isHighCost",
      "dataType": "boolean",
      "direction": "output"
    }
  ]
  }
}
```
<br>

#### <a name='get-rule-set-direct-dependent-objects'>Get the Direct Dependent Objects of a Rule Set</a>

Here is an example of retrieving the direct dependent objects of a rule set. The dependent objects include one lookup, two revision comments and 
one test custom context.

```json
{
  "GET": "/businessRules/ruleSets/b7f5c6c4-60ef-43ee-af2b-84d470279286/dependencies",
  "headers": {
    "Accept": "application/vnd.sas.transfer.dependencies+json"
  }
}
```

`Response:`
```json
{
   "uri": "/businessRules/ruleSets/b7f5c6c4-60ef-43ee-af2b-84d470279286",
   "name": "Assign Value",
   "dependentUris" : [
      "/referenceData/domains/22b0ed51-9a5b-447f-bdc3-8ecac64c9463",
      "/comments/comments/7c701ee9-ea45-469c-ab7c-f02c2f66aef9",
      "/comments/comments/92c8b316-75c8-40eb-968b-84c2757f2570",
      "/decisions/codeFiles/a23b84eb-251f-4103-abe6-3fd5446af90e"
   ],
   "version":2
}
```
<br>

#### <a name='convert-rule-action'>Convert a Rule Action</a>

Here is an example of how to convert a rule action to a different target type.

```json 
{
  "POST": "/businessRules/ruleSets/{ruleSetId}/actionConversion",
  "headers": {
    "Content-Type": "application/vnd.sas.business.rule.action.conversion+json",
    "Accept": "application/vnd.sas.business.rule.action+json"
  },
  "body": {
    "source": {
      "term": {
        "creationTimeStamp": "2017-06-14T17:12:20.148Z",
        "modifiedTimeStamp": "2017-06-14T17:12:48.933Z",
        "createdBy": "sasdemo",
        "modifiedBy": "sasdemo",
        "id": "6bd1bd30-f260-42bc-532c-fb834ef2dffa",
        "name": "approved",
        "dataType": "decimal",
        "direction": "output"
      },
      "expression": "0",
      "status": "valid",
      "id": "1c762292-6203-405a-8e1d-45aa899314b2",
      "type": "assignment"
    },
    "targetType": "complex"
  }
}
```
<br>

#### <a name='convert-rule-condition'>Convert a Rule Condition</a>

Here is an example of how to convert a rule condition to a different target type.

```json 
{
  "POST": "/businessRules/ruleSets/{ruleSetId}/conditionConversion",
  "headers": {
    "Content-Type": "application/vnd.sas.business.rule.condition.conversion+json",
    "Accept": "application/vnd.sas.business.rule.condition+json"
  },
  "body": {
    "source": {  
      "term": {
        "creationTimeStamp": "2017-06-14T17:12:20.117Z",
        "modifiedTimeStamp": "2017-06-14T17:12:48.914Z",
        "createdBy": "sasdemo", 
        "modifiedBy": "sasdemo",
        "id": "94591e7b-7b7d-4efa-9c60-b2c3a00d7739", 
        "name": "age", 
        "dataType": "decimal",
        "direction": "input"
      },
      "expression": "< 18",
      "status": "valid",
      "id": "0b9a512e-5134-4bd3-93ab-63fedde9d98a",
      "type": "decisionTable"
    },
    "targetType": "complex"
  }
}
```

last updated on 29 October, 2024
