# Score Execution API
The Score Execution API is used to validate a score object. First, a Score Definition is created using the score object, the input data, and the mappings. After the score execution has successfully completed, the score output table can be validated for the expected values. Currently, the validation is done manually. Further analysis can be done on the score output table by generating an analysis output table.

The Score Execution API can also generate the score output table by providing mapped code directly instead of generating mapped code from the Score Definition.

#### Why Use this API?
1. Users can validate score objects by generating and executing the code.
2. Score execution can be used as a consistent way to generate a score for the input data using different types of score objects such as Decisions.
3. Score execution can generate an analysis output table on the generated score output table.
4. Score Execution can easily choose where and how to execute to generate a score by choosing the correct job definition. The Score Execution API automatically chooses the Default Score Job Definition.
5. All score executions and analyses can be managed from a single location.

#### Sequence Diagram of How the Score is Generated with the Score Definition
![](images/sequence-score-with-score-definition.png?raw=true)

#### How is a Job Definition Selected?
Here is the order in which a job definition is selected.

1. An inline job definition is provided as part of the score execution request.
2. A persisted job definition ID is provided as part of the score execution request.
3. A job definition with the properties ''type==scoring'' and ''objecttype==< object type of the score object >''.
4. Default Score Job Definition.


#### How Job Definition Parameter Values are Assigned?
The score object returns the mappedCode, the outputTableName, and the outputLibraryName parameters.

1. The mappedCode parameter is assigned with the value of MappedCode.code.
2. The outputTableName parameter is assigned with the value of MappedCode.outputTableName.
3. The outputLibraryName parameter is assigned with the value of MappedCode.outputLibraryName.
4. The casServerName parameter is assigned a value of the input table's CAS server name for the inputData type CASTable. For the inputData type of Inline, the value is set to the first available CAS Server.
5. The inlineCode parameter is assigned a value of the input data code. This is valid only when InputData type is Inline.
6. If any parameter name matches the hints provided, then the value of the hint is assigned.
7. If any parameter name matches the property name of the score definition, then the property value is assigned.

#### Sequence Diagram of How the Score is Generated with Mapped Code
![](images/sequence-score-with-mapped-code.png?raw=true)

#### How is a Job Definition Selected?
Here is the order in which a job definition is selected.

1. An inline job definition is provided as part of the score execution request.
2. A persisted job definition ID is provided as part of the score execution request.
3. Default Score Job Definition. 


#### How Job Definition Parameter Values are Assigned?
The request contains the mappedCode, the outputTableName, and the outputLibraryName parameters.

1. The mappedCode parameter is assigned the value of the request's mappedCode.
2. The outputTableName parameter is assigned the value of the request's outputTableName.
3. The outputLibraryName parameter is assigned the value of the request's outputLibraryName.
4. If any parameter name matches the hints provided, then the value of the hint is assigned.

#### Sequence Diagram of How the Analysis is Generated
![](images/sequence-analysis.png?raw=true)

#### How is a Job Definition is Selected?
Here is the order in which a job definition is selected.

1. The inline job definition is provided as part of the score analysis request.
2. The persisted job definition ID is provided as part of the score analysis request.
3. The job definition with the properties "type==scoring" and "objecttype==< object type of the score object >" and "analysistype=< analysis type >".
4. Default Analysis Job Definition. 


#### How Job Definition Parameter Values are Assigned?
The score object returns the analysisCode, the outputTableName, and the outputLibraryName parameters.

1. The analysisCode parameter is assigned the value of AnalysisCode.code.
2. The outputTableName parameter is assigned the value of AnalysisCode.outputTableName.
3. The outputLibraryName parameter is assigned the value of AnalysisCode.outputLibraryName.
4. The casServerName parameter is assigned the value of the score output table's CAS server name.
5. If any parameter name matches the hints provided, then the value of the hint is assigned.
6. If any parameter name matches the property name of the score definition, then that property value is assigned.


## API Request Examples Grouped by Object Type

<details>
<summary>Create a Score Execution</summary>

* [Create using a persisted score definition](#CreatePersistedScoreDefinition)
* [Create using an inline score definition](#CreateInlineScoreDefinition)
* [Create using the override score definition](#CreateOverrideScoreDefinition)
* [Create using the inline mapped code](#CreateInlineMappedCode)
* [Create using the mapped code URI](#CreateMappedCodeURI)
* [Create using the persisted job definition](#CreatePersistedJobDefinition)
* [Create using the inline job definition](#CreateInlineJobDefinition)
</details>

<details>
<summary>Get a Score Execution</summary>

* [Get score executions using a score definition](#GetScoreExecutionScoreDefinition)
* [Get score executions using a job definition](#GetScoreExecutionJobDefinition)
* [Get score executions using the default job definition](#GetScoreExectionDefaultJobDefinition)
</details>

<details>
<summary>Creating a Score Analysis</summary>

* [Create using the persisted job definition](#CreatePersistedJobDefinition)
* [Create using the inline job definition](#CreateInlineJobDefinition)
* [Create a score analysis of a particular analysis type](#CreateScoreAnalysisType)
</details>

### Creating a Score Execution

Here are some examples of creating a score execution:

#### Example 1: <a name='CreatePersistedScoreDefinition'>Create using a persisted score definition</a>
```json
{
  "POST": "/executions",
  "headers": {
    "Accept": "application/vnd.sas.score.execution.request+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  },
  "body": {
    "name": "My Score Request",
    "scoreDefinitionId": "57cf439f-5904-4cc7-add6-140feec55b5a",
    "hints": {
      "outputLibraryName": "PUBLIC"
    }
  }
}
```

#### Example 2: <a name='CreateInlineScoreDefinition'>Create using an inline score definition</a>

NOTE: The Score Execution API creates a new score definition using the inline score definition.

```json
{
  "name": "My Score Request",
  "scoreDefinition": {
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

#### Example 3: <a name='CreateOverrideScoreDefinition'>Create using the override score definition</a>

NOTE: A new score definition is created by merging the details of the persisted score definition and the override score definition. details.
<br/> 
NOTE: You can override any combinations of objectDescriptor, inputData, and mappings.

```json
{
  "POST": "/executions",
  "headers": {
    "Accept": "application/vnd.sas.score.execution.request+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  },
  "body": {
    "scoreDefinitionId": "57cf439f-5904-4cc7-add6-140feec55b5a",
    "overrideScoreDefinition": {
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
}
```

#### Example 4: <a name='CreateInlineMappedCode'>Create using the inline mapped code</a>
```json
{
  "POST": "/executions",
  "headers": {
    "Accept": "application/vnd.sas.score.execution.request+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  },
  "body": {
    "type": "mappedCode",
    "name": "My Score Request",
    "mappedCode": "package BRM_51_RuleSet_0 /overwrite=yes; method execute(in_out varchar \"Make\", in_out double \"Maximum_Mileage\", in_out varchar \"Model\", in_out double \"Odometer\", in_out double \"RejectCar\"); \"RejectCar\" = 0 ; if (Odometer > Maximum_MileageMaximum_Mileage) then do; \"RejectCar\" = 1 ; end; end; endpackage;\nthread brm_rules_execution_thread / overwrite = yes; dcl package BRM_51_ruleset_0 ruleset;\ndcl double \"RejectCar\";\nkeep \"Make\" \"Model\" \"Odometer\" \"RejectCar\";\nmethod run(); set \"HPS\".\"BADCAR_DEMO\" ( keep=(\"make\" \"vehyear\" \"model\" \"vehodo\" ) rename=(\"make\"=\"Make\" \"vehyear\"=\"Maximum_Mileage\" \"model\"=\"Model\" \"vehodo\"=\"Odometer\" ));\nruleset.execute(\"Make\", \"Maximum_Mileage\", \"Model\", \"Odometer\", \"RejectCar\"); output; end; endthread;\ndata \"PUBLIC\".\"BADCAR_DEMO_SCORE_OUTPUT\" (overwrite=yes); dcl thread brm_rules_execution_thread _t; method run(); set from _t; output; end; enddata;",
    "outputTable": {
      "tableName": "BADCAR_DEMO_SCORE_OUTPUT",
      "libraryName": "PUBLIC",
      "serverName": "edmcas"
    }
  }
}
```

NOTE: For clarity, the example above is shown as yaml below.

```
POST: "/executions"
headers:
  Accept: application/vnd.sas.score.execution.request+json
  Accept-Item: application/vnd.sas.score.execution+json
body:
  type: mappedCode
  name: My Score Request
  mappedCode: 
        package BRM_51_RuleSet_0 /overwrite=yes;
          method execute(in_out varchar "Make", in_out double "Maximum_Mileage", in_out varchar "Model",
                    in_out double "Odometer",
                      in_out double "RejectCar");
            "RejectCar" = 0 ;
            if (Odometer > Maximum_MileageMaximum_Mileage) then do;
              "RejectCar" = 1 ;
            end;
          end;
        endpackage;
          
        thread brm_rules_execution_thread / overwrite = yes;
          dcl package BRM_51_ruleset_0 ruleset; 
          
          dcl double "RejectCar";
          
          keep "Make" "Model" "Odometer" "RejectCar";
          
          method run();
            set "HPS"."BADCAR_DEMO" (
            keep=("make" "vehyear" "model" "vehodo" )
            rename=("make"="Make" "vehyear"="Maximum_Mileage" "model"="Model" "vehodo"="Odometer" ));
          
            ruleset.execute("Make", "Maximum_Mileage", "Model", "Odometer", "RejectCar"); 
            output;
          end;
        endthread;
          
        data "PUBLIC"."BADCAR_DEMO_SCORE_OUTPUT" (overwrite=yes);
          dcl thread brm_rules_execution_thread _t;
          method run();
            set from _t;
            output;
          end;
        enddata;
  outputTable:
    tableName: BADCAR_DEMO_SCORE_OUTPUT
    libraryName: PUBLIC
    serverName: edmcas
```

#### Example 5: <a name='CreateMappedCodeURI'>Create using the mapped code URI</a>

NOTE: mappedCodeUri can be any URI that returns the mapped code.

```json
{
  "POST": "/executions",
  "headers": {
    "Accept": "application/vnd.sas.score.execution.request+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  },
  "body": {
    "type": "mappedCode",
    "name": "My Score Request",
    "mappedCodeUri": "/files/files/fd363744-0364-11e7-93ae-92361f002671/content",
    "outputTable": {
      "tableName": "BADCAR_DEMO_SCORE_OUTPUT",
      "libraryName": "PUBLIC",
      "serverName": "edmcas"
    }
  }
}
```

#### Example 6: <a name='CreatePersistedJobDefinition'>Create using the persisted job definition</a>

NOTE: If no jobDefinitionId is provided, then the [`Default Score Job Definition`](#default-score-jobdefinition) is used.

```json
{
  "POST": "/executions",
  "headers": {
    "Accept": "application/vnd.sas.score.execution.request+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  },
  "body": {
    "name": "My Score Request",
    "scoreDefinitionId": "57cf439f-5904-4cc7-add6-140feec55b5a",
    "jobDefinitionId": "c5a74cfe-0365-11e7-93ae-92361f002671"
  }
}
```

#### Example 7: <a name='CreateInlineJobDefinition'>Create using the inline job definition</a>

NOTE: If a value for `jobDefinitionId` is not provided, then the Default Score Job Definition is used.
<br/>
NOTE: A new job definition is created using the inline job definition content.

```json
{
  "POST": "/executions",
  "headers": {
    "Accept": "application/vnd.sas.score.execution.request+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  },
  "body": {
    "name": "My Score Request",
    "scoreDefinitionId": "57cf439f-5904-4cc7-add6-140feec55b5a",
    "jobDefinition": {
      "name": "My Score Job Definition",
      "type": "REST",
      "parameters": [
        {
          "required": true,
          "type": "CHARACTER",
          "name": "casServerName"
        },
        {
          "required": true,
          "type": "CHARACTER",
          "name": "outputLibraryName"
        },
        {
          "required": true,
          "type": "CHARACTER",
          "name": "outputTableName"
        },
        {
          "required": true,
          "type": "CHARACTER",
          "name": "mappedCode"
        },
        {
          "required": false,
          "type": "CHARACTER",
          "name": "preprocessingCode"
        },
        {
          "required": false,
          "type": "CHARACTER",
          "name": "inlineCode"
        },
        {
          "required": false,
          "type": "CHARACTER",
          "name": "fmtLibNames"
        }
      ],
      "code": [
        {
          "name": "Creating CAS session",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions",
          "headers": {
            "Authorization": "{authtoken}",
            "Accept": "application/json"
          },
          "bind": {
            "jsonPath": {
              "casSessionId": "$.session"
            }
          }
        },
        {
          "name": "Loading session prop action set",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/loadActionSet",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "actionSet": "sessionProp"
          },
          "bind": {
            "jsonPath": {
              "result_log1": "$.log"
            }
          }
        },
        {
          "name": "Setting format library searchable in session",
          "if": "fmtLibNames != null && fmtLibNames.length() != 0",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/setFmtSearch",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "fmtLibNames": "{fmtLibNames}"
          },
          "bind": {
            "jsonPath": {
              "result_log2": "$.log"
            }
          }
        },
        {
          "name": "Loading ds2 action set",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/loadActionSet",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "actionSet": "ds2"
          },
          "bind": {
            "jsonPath": {
              "result_log3": "$.log"
            }
          }
        },
        {
          "name": "Running ds2 inline code",
          "if": "inlineCode != null && inlineCode.length() != 0",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/runDS2",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "program": "{inlineCode}"
          },
          "bind": {
            "jsonPath": {
              "result_log4": "$.log"
            }
          }
        },
        {
          "name": "Running pre-processing code",
          "if": "preprocessingCode != null && preprocessingCode.length() != 0",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/runDS2",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "program": "{preprocessingCode}"
          },
          "bind": {
            "jsonPath": {
              "result_log5": "$.log"
            }
          }
        },
        {
          "name": "Running ds2 mapped code",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/runDS2",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "program": "{mappedCode}"
          },
          "bind": {
            "jsonPath": {
              "result_log6": "$.log"
            }
          }
        },
        {
          "name": "Loading table action set",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/loadActionSet",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "actionSet": "table"
          },
          "bind": {
            "jsonPath": {
              "result_log7": "$.log"
            }
          }
        },
        {
          "name": "Promoting table",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/promote",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "caslib": "{outputLibraryName}",
            "name": "{outputTableName}",
            "targetLib": "{outputLibraryName}"
          },
          "bind": {
            "jsonPath": {
              "result_log8": "$.log"
            }
          }
        },
        {
          "name": "Deleting session",
          "DELETE": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}",
          "headers": {
            "Authorization": "{authtoken}"
          }
        }
      ]
    }
  }
}
```

### Getting Score Executions
Here are some examples of getting score executions:

#### Example 1: <a name='GetScoreExecutionScoreDefinition'>Get score executions using a score definition</a>
```json
{
  "GET": "/executions?filter=eq(scoreExecutionRequest.scoreDefinitionId,'<Score Definition id>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  }
}
```

#### Example 2: <a name='GetScoreExecutionJobDefinition'>Get score executions using a job definition</a>
```json
{
  "GET": "/definitions?filter=eq(scoreExecutionRequest.jobDefinitionId,'<Job Definition Id>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  }
}
```

#### Example 3: <a name='GetScoreExectionDefaultJobDefinition'>Get score executions using the default job definition</a>
```json
{
  "GET": "/definitions?filter=isNull(scoreExecutionRequest.jobDefinitionId)')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  }
}
```

### Creating a Score Analysis
Here are some examples of creating a score analysis:

#### Example 1: <a name='CreatePersistedJobDefinition'>Create using the persisted job definition</a>

NOTE: If no jobDefinitionId is provided, then the above default job definition is used.

```json
{
  "POST": "/executions/{executionId}/analyses",
  "headers": {
    "Accept": "application/vnd.sas.score.analysis.request+json",
    "Accept-Item": "application/vnd.sas.score.analysis+json"
  },
  "body": {
    "name": "My Score Analysis Request",
    "analysisType": "<analysisType>",
    "jobDefinitionId": "c5a74cfe-0365-11e7-93ae-92361f002671"
  }
}
```

#### Example 2: <a name='CreateInlineJobDefinition'>Create using the inline job definition</a>

NOTE: If no jobDefinitionId is provided, then the Default Analysis Job Definition is used.

```json
{
  "POST": "/executions/{executionId}/analyses",
  "headers": {
    "Accept": "application/vnd.sas.score.analysis.request+json",
    "Accept-Item": "application/vnd.sas.score.analysis+json"
  },
  "body": {
    "name": "My Score Analysis Request",
    "analysisType": "<analysisType>",
    "jobDefinition": {
      "name": "Default Score Analysis Job Definition",
      "type": "REST",
      "parameters": [
        {
          "required": true,
          "type": "CHARACTER",
          "name": "casServerName"
        },
        {
          "required": true,
          "type": "CHARACTER"
        },
        {
          "required": true,
          "type": "CHARACTER",
          "name": "outputTableName"
        },
        {
          "required": true,
          "type": "CHARACTER",
          "name": "analysisCode"
        }
      ],
      "code": [
        {
          "name": "Creating CAS session",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions",
          "headers": {
            "Authorization": "{authtoken}",
            "Accept": "application/json"
          },
          "bind": {
            "jsonPath": {
              "casSessionId": "$.session"
            }
          }
        },
        {
          "name": "Loading session prop action set",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/loadActionSet",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "actionSet": "sessionProp"
          },
          "bind": {
            "jsonPath": {
              "result_log1": "$.log"
            }
          }
        },
        {
          "name": "Loading ds2 action set",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/loadActionSet",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "actionSet": "ds2"
          },
          "bind": {
            "jsonPath": {
              "result_log2": "$.log"
            }
          }
        },
        {
          "name": "Running ds2 mapped code",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/runDS2",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "program": "{analysisCode}"
          },
          "bind": {
            "jsonPath": {
              "result_log3": "$.log"
            }
          }
        },
        {
          "name": "Loading table action set",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/loadActionSet",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "actionSet": "table"
          },
          "bind": {
            "jsonPath": {
              "result_log4": "$.log"
            }
          }
        },
        {
          "name": "Promoting table",
          "POST": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}/actions/promote",
          "headers": {
            "Authorization": "{authtoken}",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          "body": {
            "caslib": "{outputLibraryName}",
            "name": "{outputTableName}",
            "targetLib": "{outputLibraryName}"
          },
          "bind": {
            "jsonPath": {
              "result_log5": "$.log"
            }
          }
        },
        {
          "name": "Deleting session",
          "DELETE": "/casProxy/servers/{casServerName}/cas/sessions/{casSessionId}",
          "headers": {
            "Authorization": "{authtoken}"
          }
        }
      ]
    }
  }
}
```

### Getting a Score Analysis
#### <a name='CreateScoreAnalysisType'>Create a score analysis of a particular analysis type</a>
```json
{
  "GET": "/executions/{executionId}/analyses?filter=eq(scoreAnalysisRequest.analysisType,'<analysisType>')",
  "headers": {
    "Accept": "application/vnd.sas.collection+json",
    "Accept-Item": "application/vnd.sas.score.execution+json"
  }
}
```

version 2, last updated 19 Dec, 2018