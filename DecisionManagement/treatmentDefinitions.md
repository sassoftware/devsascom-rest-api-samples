# Treatment Definitions API
The Treatment Definitions API provides the ability to define treatment definitions and treatment definition groups. A treatment represents a response that is returned based on the result of a decision. For example, an offer determined by a decision to entice a subject to buy a product.
The treatment contains name-value pairs that provide external system cues on how to act based on the result of the decision.
The name-value pairs can also be used for information-only purposes for managing the treatments and to provide business context.
The action determined by the treatment could be interaction with a customer, configuration of a process, or information that can be displayed to a user.

Treatment definition groups can be added to decisions. When decisions with treatment groups are executed, they produce treatments using the code generated from the treatment definition group.

## API Request Examples Grouped by Object Type

<details>
<summary>Treatment Definition CRUD</summary>

* [Creating a treatment definition](#CreatingTreatmentDefinition)
* [Updating a treatment definition](#UpdatingTreatmentDefinition)
* [Searching a treatment definition](#SearchingTreatmentDefinition)
* [Deleting a treatment definition](#DeletingTreatmentDefinition)
</details>

<details>
<summary>Treatment Definition Revisions</summary>

* [Lock the current revision and create a new revision of a Treatment Definition](#example-treatment-definition-lock)
* [Searching a treatment definition revision](#SearchingTreatmentDefinitionRevision)
* [Getting details of list of treatment definition revisions with selection](#GettingDetailsTreatmentDefinitionRevisionsWithselection)
</details>

<details>
<summary>Treatment Definition Group CRUD</summary>

* [Creating a treatment definition group](#CreatingTreatmentDefinitionGroup)
* [Updating a treatment definition group](#UpdatingTreatmentDefinitionGroup)
* [Searching a treatment definition group](#SearchingTreatmentDefinitionGroup)
* [Deleting a treatment definition group](#DeletingTreatmentDefinitionGroup)
</details>

<details>
<summary>Treatment Definition Group Revisions</summary>

* [Lock the current revision and create a new revision of a Treatment Definition Group](#example-treatment-definition-group-lock)
* [Searching a treatment definition group revision](#SearchingTreatmentDefinitionGroupRevision)
* [Getting details of list of treatment definition group revisions with selection](#GettingDetailsTreatmentDefinitionGroupRevisionsWithSelection)
* [Activate a treatment definition group revision](#example-treatment-definition-group-activate)
</details>

<details>
<summary>See Also</summary>

* [Treatment Definitions API documentation](https://developer.sas.com/apis/rest/DecisionManagement/#treatment-defintions)
* [Decision Management REST API Examples](https://documentation.sas.com/?cdcId=edmcdc&cdcVersion=5.4&docsetId=edmresttut&docsetTarget=titlepage.htm&locale=en)
</details>

### <a name='CreatingTreatmentDefinition'>Creating a Treatment Definition</a>
Here is an example of creating a treatment definition.
</br>

```json
{
  "POST": "/definitions",
  "headers": {
    "Content-Type": "application/vnd.sas.treatment.definition+json",
    "Accept": "application/vnd.sas.treatment.definition+json"
  },
  "body": {
    "name": "My Treatment Definition",
    "eligibility": {
      "ruleSetUri": "/businessRules/ruleSets/a57918bd-22b0-4640-884c-ad650e21c9ea",
      "startDate": "2018-09-17 13:37:01.750",
      "endDate": "2019-09-17 13:37:01.750"
    },
    "attributes": [
      {
        "name": "Discount",
        "valueConstraints": {
          "dataType": "number",
          "format": "decimal"
        },
        "defaultValue": 30
      },
      {
        "name": "Product",
        "valueConstraints": {
          "dataType": "string",
          "enum": [
            "iPhone",
            "Samsung"
          ]
        },
        "defaultValue": "iPhone"
      },
      {
        "name": "Offertext",
        "valueConstraints": {
          "dataType": "string"
        },
        "defaultValue": "Get a new IPhone now and get 30% off iPad"
      },
      {
        "name": "Budget",
        "valueConstraints": {
          "dataType": "number",
          "format": "decimal",
          "readOnly": true
        },
        "defaultValue": 500
      },
      {
        "name": "Goal",
        "valueConstraints": {
          "dataType": "string",
          "format": "date"
        },
        "defaultValue": "2018-07-13"
      },
      {
        "name": "TimesClicked",
        "valueConstraints": {
          "dataType": "number",
          "format": "integer"
        }
      }
    ]
  }
}
```

### Creating Different Types of Attributes
| Type                 | dataType | format   | multiple | range | example value |
|----------------------|----------|----------|----------|-------|---------|
| boolean              | boolean  |          | false    | false | true    |
| decimal              | number   | decimal  | false    | false | 12.345  |
| integer              | number   | integer  | false    | false | 55      |
| string               | string   |          | false    | false | "abcdef" |
| date                 | string   | date     | false    | false | "2018-07-13" |
| datetime             | string   | datetime | false    | false | "2018-07-13 11:11:11.111" |
| url                  | string   | url      | false    | false | "http://www.sas.com" |
| boolean array        | boolean  |          | true     | false | [true, false, true] |
| decimal array        | number   | decimal  | true     | false | [11.11, 12.12, 13.13 ] |
| integer array        | number   | integer  | true     | false | [5, 7, 9] |
| string array         | string   |          | true     | false | ["ab", "cd", "ef"] |
| date array           | string   | date     | true     | false | ["2018-07-13", "2020-07-13"] |
| datetime array       | string   | datetime | true     | false | ["2018-07-13 11:11:11.111", "2020-07-13 11:11:11.111"] |
| url array            | string   | url      | true     | false | ["http://www.sas.com", "http://www.google.com"] |
| decimal range        | number   | decimal  | false    | true  | {"from": 12.50, "to": 65.55} |
| integer range        | number   | integer  | false    | true  | {"from": 12, "to": 65} |
| date range           | string   | date     | false    | true  | {"from": "2018-07-13", "to": "2020-07-13"} |
| datetime range       | string   | datetime | false    | true  | {"from": "2018-07-13 11:11:111", "to": "2020-07-13 11:11:111"} |
| decimal range array  | number   | decimal  | true     | true  | [{"from": 12.50, "to": 65.55}, {"from": 75.50, "to": 95.55}] |
| integer range array  | number   | integer  | true     | true  | [{"from": 12, "to": 65}, {"from": 75, "to": 95}] |
| date range array     | string   | date     | true     | true  | [{"from": "2018-07-13", "to": "2020-07-13"}, {"from": "2022-07-13", "to": "2024-07-13"}] |
| datetime array range | string   | datetime | true     | true  | [{"from": "2018-07-13 11:11:111", "to": "2020-07-13 11:11:111"}, {"from": "2022-07-13 11:11:111", "to": "2024-07-13 11:11:111"}]|


### <a name='UpdatingTreatmentDefinition'>Updating a Treatment Definition</a>
Here is an example of replacing all parts of the treatment with new content.

```json
{
  "PUT": "/definitions/{definitionId}",
  "headers": {
    "Content-Type": "application/vnd.sas.treatment.definition+json",
    "Accept": "application/vnd.sas.treatment.definition+json",
    "If-Match": "<ETag value that you captured before using either GET or HEAD>"
  },
  "body": {
    "name": "My Treatment Definition",
    "eligibility": {
      "ruleSetUri": "/businessRules/ruleSets/a57918bd-22b0-4640-884c-ad650e21c9ea",
      "startDate": "2018-09-17 13:37:01.750",
      "endDate": "2019-09-17 13:37:01.750"
    },
    "attributes": [
      {
        "attributeId": "93810877-8d22-4105-9753-8be68975d119",
        "name": "Discount",
        "valueConstraints": {
          "dataType": "number",
          "format": "decimal"
        },
        "defaultValue": 30
      },
      {
        "attributeId": "d2c97b53-3c9e-4d85-a3e8-c89ba85a5812",
        "name": "ProductName",
        "valueConstraints": {
          "dataType": "string",
          "enum": [
            "iPhone",
            "Samsung"
          ]
        },
        "defaultValue": "iPhone"
      },
      {
        "attributeId": "c105c394-f4c1-498b-9186-fbdf18e179d1",
        "name": "Offertext",
        "valueConstraints": {
          "dataType": "string"
        },
        "defaultValue": "Get a new IPhone now and get 30% off iPad"
      },
      {
        "attributeId": "19ed4584-dc0f-4126-87b5-6369976dc69e",
        "name": "Offertext",
        "valueConstraints": {
          "dataType": "number",
          "format": "decimal",
          "readOnly": true
        },
        "defaultValue": 500
      },
      {
        "attributeId": "9834f203-d52c-4fb2-bba2-33a1101afdac",
        "name": "Goal",
        "valueConstraints": {
          "dataType": "string",
          "format": "date"
        },
        "defaultValue": "2018-07-13"
      },
      {
        "attributeId": "22cc8ec4-4d81-4060-a437-430e9aa55cb6",
        "name": "ClickCount",
        "valueConstraints": {
          "dataType": "number",
          "format": "integer"
        }
      }
    ]
  }
}
```

### <a name='SearchingTreatmentDefinition'>Searching a Treatment Definition</a>
Here are some examples of searching a treatment definition.
<br/>
 Example 1: Search by name.
 
```json
{
  "GET": "/definitions?filter=eq(name,'<name to match>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.treatment.definition+json"
  }
}
```

 Example 2: Search by attribute name.
 
```json
{
  "GET": "/definitions?filter=eq(attributes.name,'<name to match>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.treatment.definition+json"
  }
}
```

### <a name='example-treatment-definition-lock'> Lock the Current Revision and Create a New Revision of a Treatment Definition</a>

Here is an example of locking current revision and creating a new revision with the provide content.

```json
{
  "POST": "/definitions/{definitionId}/revisions?revisionType=major",
  "headers": {
    "Content-Type": "application/vnd.sas.treatment.definition+json",
    "Accept": "application/vnd.sas.treatment.definition+json"
  },
  "body": {
    "name": "My Treatment Definition",
    "eligibility": {
      "ruleSetUri": "/businessRules/ruleSets/a57918bd-22b0-4640-884c-ad650e21c9ea",
      "startDate": "2018-09-17 13:37:01.750",
      "endDate": "2019-09-17 13:37:01.750"
    },
    "attributes": [
      {
        "name": "Discount",
        "valueConstraints": {
          "dataType": "number",
          "format": "decimal"
        },
        "defaultValue": 30
      },
      {
        "name": "Product",
        "valueConstraints": {
          "dataType": "string",
          "enum": [
            "iPhone",
            "Samsung"
          ]
        },
        "defaultValue": "iPhone"
      },
      {
        "name": "Offertext",
        "valueConstraints": {
          "dataType": "string"
        },
        "defaultValue": "Get a new IPhone now and get 30% off iPad"
      },
      {
        "name": "Budget",
        "valueConstraints": {
          "dataType": "number",
          "format": "decimal",
          "readOnly": true
        },
        "defaultValue": 500
      },
      {
        "name": "Goal",
        "valueConstraints": {
          "dataType": "string",
          "format": "date"
        },
        "defaultValue": "2018-07-13"
      },
      {
        "name": "TimesClicked",
        "valueConstraints": {
          "dataType": "number",
          "format": "integer"
        }
      }
    ]
  }
}
```

### <a name='SearchingTreatmentDefinitionRevision'>Searching a Treatment Definition Revision</a>
Here is an example of searching a treatment definition revision.
<br/>
 Example: Search by attribute name.
 
```json
{
  "GET": "/definitions/{definitionId}/revisions?filter=eq(attributes.name,'<name to match>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.treatment.definition+json"
  }
}
```

### <a name='GettingDetailsTreatmentDefinitionRevisionsWithselection'>Getting Details of List of Treatment Definition Revisions with Selection</a>

```json
{
  "POST": "/definitionRevisions",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.treatment.definition+json"
  },
  "body": {
    "type": "id",
    "resources" : [
      "1593d98f-f126-41ce-9df7-abd316cd2926", 
      "8a59b913-eba2-4e69-9b1a-91560495fa5d",
      "ee8a1b50-2c09-4dcf-a4da-e2a2a8965a7"
    ]
  }
}
```

### <a name='DeletingTreatmentDefinition'>Deleting a Treatment Definition</a>
Here is an example of deleting a treatment definition.

```json
{
  "DELETE": "/definitions/{definitionId}"
}
```

### <a name='CreatingTreatmentDefinitionGroup'>Creating a Treatment Definition Group</a>
Here is an example of creating a treatment definition group.
</br>

```json
{
  "POST": "/definitionGroups",
  "headers": {
    "Content-Type": "application/vnd.sas.treatment.definition.group+json",
    "Accept": "application/vnd.sas.treatment.definition.group+json"
  },
  "body": {
    "name": "My Treatment Definition Group",
    "members": [
      {
        "definitionId": "60095dcd-b2ca-4705-8cf6-aa693fce1692"
      },
      {
        "definitionId": "60095dcd-b2ca-4705-8cf6-aa693fce1692",
        "definitionRevisionId": "f813702e-dff8-443e-a7af-727ab027fb7e",
        "attributeValueMappings": [
          {
            "attributeId": "fdb1e22e-5358-4311-a914-eec901c2da5f",
            "mappingType": "variable",
            "value": "Discount"
          },
          {
            "attributeId": "7c17cbaf-dd3d-4288-b6a9-54ae7c7c91c6",
            "mappingType": "constant",
            "value": "Samsung"
          },
          {
            "attributeId": "a0a3b4d4-fc28-4194-84dd-fe2dc3286009",
            "mappingType": "variable",
            "value": "Clicked"
          }
        ],
        "attributeNameAliases": [
          {
            "attributeId": "fdb1e22e-5358-4311-a914-eec901c2da5f",
            "aliasName": "Discount ID"
          }
        ]
      }
    ]
  } 
}
```

### <a name='UpdatingTreatmentDefinitionGroup'>Updating a Treatment Definition Group</a>
Here is an example of replacing all parts of the treatment definition group with new data.

```json
{
  "PUT": "/definitionGroups/{groupId}",
  "headers": {
    "Content-Type": "application/vnd.sas.treatment.definition.group+json",
    "Accept": "application/vnd.sas.treatment.definition.group+json",
    "If-Match": "<ETag value that you captured before using either GET or HEAD>"
  },
  "body": {
    "name": "My Treatment Definition Group",
    "members": [
      {
        "definitionId": "60095dcd-b2ca-4705-8cf6-aa693fce1692"
      },
      {
        "definitionId": "60095dcd-b2ca-4705-8cf6-aa693fce1692",
        "definitionRevisionId": "f813702e-dff8-443e-a7af-727ab027fb7e",
        "attributeValueMappings": [
          {
            "attributeId": "fdb1e22e-5358-4311-a914-eec901c2da5f",
            "mappingType": "variable",
            "value": "Discount"
          },
          {
            "attributeId": "7c17cbaf-dd3d-4288-b6a9-54ae7c7c91c6",
            "mappingType": "constant",
            "value": "Samsung"
          },
          {
            "attributeId": "a0a3b4d4-fc28-4194-84dd-fe2dc3286009",
            "mappingType": "variable",
            "value": "Clicked"
          }
        ],
        "attributeNameAliases": [
          {
            "attributeId": "fdb1e22e-5358-4311-a914-eec901c2da5f",
            "aliasName": "Discount ID"
          }
        ]
      }
    ]
  } 
}
```

### <a name='SearchingTreatmentDefinitionGroup'>Searching a Treatment Definition Group</a>
Here are some examples of searching a treatment definition group.
<br/>
 Example 1: Search by name.
 
```json
{
  "GET": "/definitionGroups?filter=eq(name,'<name to match>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.treatment.definition.group+json"
  }
}
```

 Example 2: Search by treatment definition name.
 
```json
{
  "GET": "/definitionGroups?filter=eq(members.definitionName,'<name to match>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.treatment.definition.group+json"
  }
}
```

### <a name='example-treatment-definition-group-lock'>Lock the Current Revision and Create a New Revision of a Treatment Definition Group</a>


Here is an example of locking current revision and creating a new revision with the provide content.

```json
{
  "POST": "/definitionGroups",
  "headers": {
    "Content-Type": "application/vnd.sas.treatment.definition.group+json",
    "Accept": "application/vnd.sas.treatment.definition.group+json"
  },
  "body": {
    "name": "My Treatment Definition Group",
    "members": [
      {
        "definitionId": "60095dcd-b2ca-4705-8cf6-aa693fce1692"
      },
      {
        "definitionId": "60095dcd-b2ca-4705-8cf6-aa693fce1692",
        "definitionRevisionId": "f813702e-dff8-443e-a7af-727ab027fb7e",
        "attributeValueMappings": [
          {
            "attributeId": "fdb1e22e-5358-4311-a914-eec901c2da5f",
            "mappingType": "variable",
            "value": "Discount"
          },
          {
            "attributeId": "7c17cbaf-dd3d-4288-b6a9-54ae7c7c91c6",
            "mappingType": "constant",
            "value": "Samsung"
          },
          {
            "attributeId": "a0a3b4d4-fc28-4194-84dd-fe2dc3286009",
            "mappingType": "variable",
            "value": "Clicked"
          }
        ],
        "attributeNameAliases": [
          {
            "attributeId": "fdb1e22e-5358-4311-a914-eec901c2da5f",
            "aliasName": "Discount ID"
          }
        ]
      }
    ]
  } 
}
```

### <a name='SearchingTreatmentDefinitionGroupRevision'>Searching a Treatment Definition Group Revision</a>
Here is an example of searching a treatment definition group.
<br/>
 Example: Search by treatment definition name.
 
```json
{
  "GET": "/definitionGroups/{groupId}/revisions?filter=eq(members.definitionName,'<name to match>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.treatment.definition.group+json"
  }
}
```

### <a name='GettingDetailsTreatmentDefinitionGroupRevisionsWithSelection'>Getting Details of List of Treatment Definition Group Revisions with selection</a>


```json
{
  "POST": "/definitionGroupRevisions",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.treatment.definition.group+json"
  },
  "body": {
    "type": "id",
    "resources" : [
      "1593d98f-f126-41ce-9df7-abd316cd2926", 
      "8a59b913-eba2-4e69-9b1a-91560495fa5d",
      "ee8a1b50-2c09-4dcf-a4da-e2a2a8965a7"
    ]
  }
}
```

### <a name='example-treatment-definition-group-activate'>Activate a Treatment Definition Group Revision</a>
Here is an example of activating a treatment definition group revision.
n
Here is an example of activating a treatment definition group revision.

```json
{
  "PUT": "/definitionGroups/{groupId}/active",
  "headers": {
    "Accept": "application/vnd.sas.treatment.definition.group+json",
    "Content-Type": "text/plain",
    "If-Match": "<ETag value that you captured before using either GET or HEAD on /definitionGroups/{groupId}>"
  },
  "body": "<Treatment Definition Group Revision UUID to activate>"
}
```

### <a name='DeletingTreatmentDefinitionGroup'>Deleting a Treatment Definition Group</a>
Here is an example of deleting a treatment definition group.

```json
{
  "DELETE": "/definitionGroups/{groupId}"
}
```


version 1, last updated 25 Nov, 2019