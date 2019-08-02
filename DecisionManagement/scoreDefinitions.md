# Score Definitions API
Score definitions are used by the Score Execution API to generate mapped code, which is then used to generate the score for the input data.

A score definition contains the following details:

1. Input data that needs to be scored.
2. Details about the score object whose logic is used to produce a score.
3. Mappings between the input data columns and the variables of the mapped code of the score object.

#### Why Use this API?
* Users can test the score objects by generating and executing the code.
* Users can use the definition in the score execution to score the input data.
* Can be used in a consistent way for generating a score for the input data using different types of score objects like Decisions and Models.
* Can be used in a consistent way for generating mapped code using different types of score objects such as decisions and models.

## API Request Examples Grouped by Object Type

<details>
<summary>Create a Score Definition</summary>

* [Specifying the type of inputData as CASTable](#SpecifyingInputDataTypeCASTable)
* [Specifying the type of inputData as Inline](#SpecifyingInputDataInline)
</details>

<details>
<summary>Update a Score Definitions</summary>

* [Replacing all parts of the score definition with new data](#ReplacingScoreDefinitionNewData)
</details>

<details>
<summary>Searching a Score Definition</summary>

* [Search by name](#SearchByName)
* [Search by the score object URI](#SearchByURI)
* [Search by the score object type](#SearchByType)
</details>

<details>
<summary>Getting the Mapped Code for Score Objects</summary>

* [Get the mapped code for score objects](#GetMappedcodeScoreObjects)
</details>

<details>
<summary>Delete a Score Definition</summary>

* [Delete a score definition](#DeleteScoreDefinition)
</details>


### Creating a Score Definition
Here are some examples of creating a score definition.
</br>

#### Example 1: <a name='SpecifyingInputDataTypeCASTable'>Specifying the type of inputData as CASTable</a>
```json
{
  "POST": "/definitions",
  "headers": {
    "Content-Type": "application/vnd.sas.score.definition+json",
    "Accept": "application/vnd.sas.score.definition+json"
  },
  "body": {
    "name": "My Score Definition",
    "objectDescriptor": {
      "uri": "/businessRules/ruleSets/0d25d749-24e0-4e5d-a773-ea7a1eb0fdc5"
    },
    "inputData": {
      "type": "CASTable",
      "serverName": "edmcas",
      "tableName": "BADCAR_DEMO",
      "libraryName": "HPS"
    },
    "mappings": [
      {
        "variableName": "Make",
        "mappingType": "datasource",
        "mappingValue": "make"
      },
      {
        "variableName": "Model",
        "mappingType": "datasource",
        "mappingValue": "model"
      },
      {
        "variableName": "Odometer",
        "mappingType": "datasource",
        "mappingValue": "vehodo"
      },
      {
        "variableName": "Maximum_Mileage",
        "mappingType": "static",
        "mappingValue": 100000
      }
    ]
  }
}
```

#### Example 2: <a name='SpecifyingInputDataInline'>Specifying the type of inputData as Inline</a>
```json
{
  "POST": "/definitions",
  "headers": {
    "Content-Type": "application/vnd.sas.score.definition+json",
    "Accept": "application/vnd.sas.score.definition+json"
  },
  "body": {
    "name": "My Inline Score Definition",
    "objectDescriptor": {
      "uri": "/decisions/flows/17ee66ee-63d6-11e6-8b77-86f30ca893d3"
    },
    "inputData": {
      "type": "Inline",
      "code": "data BADCAR_DEMO; dcl varchar(100) make; dcl varchar(100) model; dcl double vehodo;\nmethod init(); \"make\" = 'HYUNDAI'; \"model\" = 'ELANTRA'; \"vehodo\" = 108811; output;\n\"make\" = 'FORD'; \"model\" = 'FOCUS'; \"vehodo\" = 98038; output; end; enddata;",
      "outputTableName": "CARS"
    },
    "mappings": [
      {
        "variableName": "Make",
        "mappingType": "datasource",
        "mappingValue": "make"
      },
      {
        "variableName": "Model",
        "mappingType": "datasource",
        "mappingValue": "model"
      },
      {
        "variableName": "Odometer",
        "mappingType": "datasource",
        "mappingValue": "vehodo"
      },
      {
        "variableName": "Maximum_Mileage",
        "mappingType": "static",
        "mappingValue": 100000
      }
    ]
  }
}
```

NOTE: For clarity, the example above is shown as yaml below.

```yaml
POST: "/definitions"
headers:
  Content-Type: application/vnd.sas.score.definition+json
  Accept: application/vnd.sas.score.definition+json
body:
  name: My Inline Score Definition
  objectDescriptor:
    uri: "/decisions/flows/17ee66ee-63d6-11e6-8b77-86f30ca893d3"
  inputData:
    type: Inline
    code: 
          data BADCAR_DEMO; 
            dcl varchar(100) make;
            dcl varchar(100) model;
            dcl double vehodo;

            method init();
              "make" = 'HYUNDAI'; 
              "model" = 'ELANTRA'; 
              "vehodo" = 108811; 
              output; 
    
              "make" = 'FORD'; 
              "model" = 'FOCUS'; 
              "vehodo" = 98038; 
              output; 
           end; 
         enddata;
    outputTableName: CARS
  mappings:
  - variableName: Make
    mappingType: datasource
    mappingValue: make
  - variableName: Model
    mappingType: datasource
    mappingValue: model
  - variableName: Odometer
    mappingType: datasource
    mappingValue: vehodo
  - variableName: Maximum_Mileage
    mappingType: static
    mappingValue: 100000
```

### Updating a Score Definition
#### <a name='ReplacingScoreDefinitionNewData'>Replacing all parts of the score definition with new data</a>

```json
{
  "PUT": "/definitions/{definitionId}",
  "headers": {
    "Content-Type": "application/vnd.sas.score.definition+json",
    "Accept": "application/vnd.sas.score.definition+json",
    "If-Match": "<ETag value that you captured before using either GET or HEAD>"
  },
  "body": {
    "name": "My Score Definition",
    "objectDescriptor": {
      "uri": "/businessRules/ruleSets/0d25d749-24e0-4e5d-a773-ea7a1eb0fdc5"
    },
    "inputData": {
      "type": "CASTable",
      "serverName": "edmcas",
      "tableName": "BADCAR_DEMO",
      "libraryName": "HPS"
    },
    "mappings": [
      {
        "variableName": "Make",
        "mappingType": "datasource",
        "mappingValue": "make"
      },
      {
        "variableName": "Model",
        "mappingType": "datasource",
        "mappingValue": "model"
      },
      {
        "variableName": "Odometer",
        "mappingType": "datasource",
        "mappingValue": "vehodo"
      },
      {
        "variableName": "Maximum_Mileage",
        "mappingType": "static",
        "mappingValue": 50000
      }
    ]
  }
}
```

### Searching a Score Definition
Here are some examples of searching a score definition.
<br/>
#### Example 1: <a name='SearchByName'>Search by name.
```json
{
  "GET": "/definitions?filter=eq(name,'<name to match>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.score.definition+json"
  }
}
```
#### Example 2: <a name='SearchByURI'>Search by the score object URI.
```json
{
  "GET": "/definitions?filter=eq(objectDescriptor.uri,'<uri of the Score Object>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.score.definition+json"
  }
}
```

#### Example 3: <a name='SearchByType'>Search by the score object type.
```json
{
  "GET": "/definitions?filter=eq(objectDescriptor.type,'<type of the Score Object>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.score.definition+json"
  }
}
```

### Getting the Mapped Code for Score Objects
#### <a name='GetMappedcodeScoreObjects'>Get the mapped code for score objects.
```json
{
  "POST": "/definitions/{definitionId}/mappedCode",
  "headers": {
    "Content-Type": "application/vnd.sas.score.code.generation.request+json",
    "Accept": "application/vnd.sas.score.mapped.code+json"
  },
  "body": {
    "hints": {
      "outputLibraryName": "PUBLIC"
    }
  }
}
```

### Deleting a Score Definition
#### <a name='DeleteScoreDefinition'>Delete a score definition.
```json
{
  "DELETE": "/definitions/{definitionId}"
}
```

version 2, last updated 19 Dec, 2018