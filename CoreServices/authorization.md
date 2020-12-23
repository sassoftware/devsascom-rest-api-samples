# Authorization API

The Authorization API encapsulates all activities that affect access to system functions and resources.

Here is a summary of the functional scope of this API:

* This API enables authorized users to specify access by creating and managing authorization rules and shares.
* This API enables any principal that has the Secure permission for a particular object to create and manage
authorization rules that directly target that object.
* This API enables any principal that has the Secure permission for a particular object to share that object.
If re-sharing is enabled, each share recipient can extend the access that they receive to other users and groups.
* This API enforces authorization rules by making authorization decisions. Each decision is evaluated for a
specific authorization context. The decision process is transparent to end users.
* This API explains its authorization decisions by listing all of the rules and shares that contribute to each decision.
* This API does not manage access to CAS data (caslibs and tables) or CAS actions.

For background information, see <a href="http://documentation.sas.com/?docsetId=calauthzgen&docsetTarget=n1xnhxt4tj57wzn1kdridi7u2g27.htm&docsetVersion=3.5&locale=en" target="new">
General Authorization: Concepts</a>.



## API Request Examples Grouped by Object Type

<details>
<summary>Rules</summary>

* [Create an authorization rule](#CreateAuthorizationRule)
* [Get an authorization rule by ID](#GetAuthorizationRule)
* [Update an existing authorization rule](#UpdateAuthorizationRule)
* [Get a paginated collection of rules](#PagianteRules)
* [Patch a collection of rules using a test condition](#PatchRulesCondition)
* [Migrate existing rules with a patch request ](#MigrateRulesPatch)
* [Create and monitor a rule job](#CreateMonitorRuleJob)
</details>


<details>
<summary>Shares</summary>

* [Share a resource](#ShareResource)
* [Stop sharing a resource](#StopShareResource)

</details>


<details>
<summary>Decisions</summary>

* [Create an authorization decision](#CreateAuthorizationDecision)
* [Create a bulk authorization decision](#CreateBulkAuthorizationDecision)

</details>


#### <a name='CreateAuthorizationRule'>Create an Authorization Rule</a>
Here is an example of creating an authorization rule.

```
POST /authorization/rules
    Content-Type: application/vnd.sas.authorization.rule+json
```
Here is an example of the response:
```json
{
    "type": "grant",
    "permissions": [
        "read"
    ],
    "principalType": "authenticatedUsers",
    "objectUri": "/preferences/",
    "description": "Allow access to a service root.",
    "matchParams": false,
    "enabled": true
}
```

#### <a name='GetAuthorizationRule'>Get an Authorization Rule by ID</a> 
Here is an example of using a known ID to obtain individual authorization rules.
This is done by performing a GET request to /authorization/rules/{id}.

```
GET /authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac
    Accept: application/vnd.sas.authorization.rule+json
```
Here is an example of the response:
```json
{
    "type": "grant",
    "permissions": [
        "read"
    ],
    "principalType": "authenticatedUsers",
    "objectUri": "/preferences/",
    "description": "Allow access to a service root.",
    "matchParams": false,
    "version": 5,
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "type": "application/vnd.sas.authorization.rule"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "type": "application/vnd.sas.authorization.rule",
            "responseType": "application/vnd.sas.authorization.rule"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac"
        }
    ],
    "id": "3288b305-981f-4b8d-b440-0911eabc3fac",
    "modifiedTimestamp": "2016-08-27T04:09:42.150Z",
    "createdTimestamp": "2016-08-27T04:09:42.150Z",
    "createdBy": "sas.preferences",
    "modifiedBy": "sas.preferences",
    "enabled": true
}
```

#### <a name='UpdateAuthorizationRule'>Update an Existing Authorization Rule</a> 
Here is an example of using a known ID to update individual authorization rules.
This is done by performing a PUT request to /authorization/rules/{id}.

```
PUT /authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac
    Content-Type: application/vnd.sas.authorization.rule+json
```
Here is an example of the response:
```json
{
    "type": "prohibit",
    "permissions": [
        "read"
    ],
    "principalType": "authenticatedUsers",
    "objectUri": "/preferences/",
    "description": "Allow access to a service root.",
    "matchParams": false,
    "version": 5,
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "type": "application/vnd.sas.authorization.rule"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "type": "application/vnd.sas.authorization.rule",
            "responseType": "application/vnd.sas.authorization.rule"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac"
        }
    ],
    "id": "3288b305-981f-4b8d-b440-0911eabc3fac",
    "modifiedTimestamp": "2016-08-27T04:09:42.150Z",
    "createdTimestamp": "2016-08-27T04:09:42.150Z",
    "createdBy": "sas.preferences",
    "modifiedBy": "sas.preferences",
    "enabled": true
}
```

#### <a name='PaginateRules'>Get a Paginated Collection of Rules</a>
Here is an example of paging through a collection of rules.

```
GET /authorization/rules?start=0&limit=20
    Accept: application/vnd.sas.collection+json
```

#### <a name='PatchRulesCondition'>Patch a Collection of Rules Using a Condition</a>
Here is an example of using a condition to specify permissions and the objectUri for a specified rule.

The key data in this example are the following:

* The condition is named "test".
* The condition indicates the existing rule must have type=grant, permissions=[read,update], objectUri=/identities/**, and principalType=authenticated-users.

If all of these values match, the patch is applied and the following is specified:

* The permissions are specified to Read, Update, Delete, and Secure.
* The objectUri is specified to '/identities/*'.

If any of these values do not match, the patch is not applied.


```
PATCH /authorization/rules
    Content-Type: application/json-patch+json
    Accept: application/vnd.sas.collection+json
```
Here is an example of the response:
```json
[
  [
  {
    "op":"test",
    "path":"/authorization/rules/e7ae0810-a47d-11e7-abc4-cec278b6b50a",
    "value": {
               "type": "grant",
               "permissions": ["read", "update"],
               "objectUri": "/identities/**",
               "principalType": "authenticated-users"
             }
  },
  {
    "op":"add",
    "path":"/authorization/rules/e7ae0810-a47d-11e7-abc4-cec278b6b50a",
    "value": {
               "permissions": ["read", "update, delete, secure"],
               "objectUri": "/identities/*"
             }
  }
  ]
]
```

#### <a name='MigrateRulesPatch'>Migrate Existing Rules with a PATCH Request</a>
Here is an example of using a combination of specified JSON patch operations to migrate existing rules.

* The `copy` operation copies the existing rule and any changes that might have been applied to it.
* The `add` or `replace` operation updates the target rule.
* The `remove` operation must delete either the original rule or the new rule.

To target a rule that does not have a known ID, use the simple token substitution system that this API provides. In a single patch, each new
rule that is created by an `add` or `copy` operation is added to a zero-indexed, ordered list.

Note: An `add` operation can be either a create or an update, depending on whether a rule with the given ID already exists. A rule that is updated is not added to the
list of created rules.

If you know the order in which rules are created within a patch, you can reference any such rule by
its index. Use the token @CREATED#@, where '#' is the index of the rule that you are targeting. 

The below example assumes that a rule already exists with ID = "sourceId" and modifies the rule before removing the source rule.

```json
[
  [
  {
    "op":"copy",
    "from":"/authorization/rules/sourceId",
    "path":"/authorization/rules/"
  },
  {
    "op":"replace",
    "path":"/authorization/rules/@CREATED0@",
    "value": {
               "type": "grant",
               "permissions": ["read", "update"],
               "objectUri": "/identities/**",
               "principalType": "authenticated-users",
               "reason": "Authenticated Users can read identities, groups, users, members, memberships."
             }
  },
  {
    "op":"remove",
    "path":"/authorization/rules/sourceId"
  }
  ]
]
```

#### <a name='CreateMonitorRuleJob'>Create and Monitor a Rule Job</a> 
Here is an example of creating a rule job that will create two rules and modify an existing rule. The example also shows how
to check the current state of the job.

To create a job:
```
POST /authorization/rules/jobs
    Content-Type: application/vnd.sas.authorization.rule.job+json
    Accept: application/vnd.sas.authorization.rule.job+json"
```

```json
{
  "status": "notStarted",
  "version": 2,
  "state": "pending",
  "actions": [
    {
      "rule": {
        "type": "grant",
        "permissions": [
          "add",
          "create",
          "delete",
          "read",
          "remove",
          "secure",
          "update"
        ],
        "principal": "testprincipal",
        "principalType": "user",
        "objectUri": "\/test\/**",
        "mediaType": "application\/vnd.sas.test",
        "reason": "Because I'm testing",
        "matchParams": false,
        "version": 9,
        "enabled": true
      },
      "type": "create",
      "status": "notStarted",
      "state": "pending",
      "priority": 1
    },
    {
      "rule": {
        "type": "grant",
        "permissions": [
          "read"
        ],
        "principal": "testprincipal",
        "principalType": "authenticatedUsers",
        "objectUri": "\/test\/**",
        "mediaType": "application\/vnd.sas.test",
        "reason": "Because I'm testing",
        "matchParams": false,
        "version": 9,
        "enabled": true
      },
      "type": "create",
      "status": "notStarted",
      "state": "pending",
      "priority": 1
    },
    {
      "rule": {
        "type": "prohibit",
        "permissions": [
          "add",
          "create",
          "delete",
          "read",
          "remove",
          "secure",
          "update"
        ],
        "principal": "testprincipal",
        "principalType": "user",
        "objectUri": "\/foo\/bar",
        "mediaType": "application\/vnd.sas.test",
        "reason": "Because I'm testing",
        "matchParams": false,
        "version": 9,
        "id": "0ee67d20-7b22-4d0f-af3e-fe29ef5b72ed",
        "enabled": true
      },
      "type": "update",
      "status": "notStarted",
      "state": "pending",
      "priority": 1
    }
  ]
}
```
Here is an example of the response:
```json
{
  "id": "cc2cb37c-24e6-4398-b7c8-4b6603bc4608",
  "createdBy": "user",
  "status": "notStarted",
  "version": 2,
  "state": "pending",
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "\/authorization\/rules\/jobs\/cc2cb37c-24e6-4398-b7c8-4b6603bc4608",
      "uri": "\/authorization\/rules\/jobs\/cc2cb37c-24e6-4398-b7c8-4b6603bc4608",
      "type": "application\/vnd.sas.authorization.rule.job"
    },
    {
      "method": "GET",
      "rel": "ruleJobState",
      "href": "\/authorization\/rules\/jobs\/cc2cb37c-24e6-4398-b7c8-4b6603bc4608\/state",
      "uri": "\/authorization\/rules\/jobs\/cc2cb37c-24e6-4398-b7c8-4b6603bc4608\/state",
      "type": "text\/plain"
    }
  ],
  "actions": [
    {
      "id": "29e69b13-7a0f-4939-a7e9-b4400f71f7d8",
      "rule": null,
      "type": "create",
      "status": "notStarted",
      "state": "pending",
      "priority": 1
    },
    {
      "id": "80379599-5ca6-4c80-8487-4d7e4fe62e7b",
      "rule": null,
      "type": "create",
      "status": "notStarted",
      "state": "pending",
      "priority": 1
    },
    {
      "id": "e479a954-4832-4e8c-a18e-b10ab3bf2950",
      "rule": null,
      "type": "update",
      "status": "notStarted",
      "state": "pending",
      "priority": 1
    }
  ]
}
```

To check the status:
```
GET /authorization/rules/jobs/cc2cb37c-24e6-4398-b7c8-4b6603bc4608/state
```
Here is an example of the response:
```json
"pending"
```

#### <a name='ShareResource'>Share a Resource</a>
Here is an example of creating a share that enables another user to read a file that they do not already have access to.

```
POST /authorization/shares
    Content-Type: application/vnd.sas.authorization.share+json
    Accept: application/vnd.sas.authorization.share+json"
```

```json
{
    "type": "read",
    "sharedWith": "testUser",
    "sharedWithType": "user",
    "resourceUri": "/files/files/4288b305-981f-4b8d-b440-0911eabe3faf",
    "name": "test file"
}
```
Here is an example of the response:
```json
{
    "type": "read",
    "sharedWith": "testUser",
    "sharedWithType": "user",
    "sharedBy": "currentUser",
    "resourceUri": "/files/files/4288b305-981f-4b8d-b440-0911eabe3faf",
    "name": "test file",
    "enabled": true,
    "version": 3,
    "links": [
        {
            "method": "GET",
            "rel": "self",
            "href": "/authorization/shares/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/shares/3288b305-981f-4b8d-b440-0911eabc3fac",
            "type": "application/vnd.sas.authorization.share"
        },
        {
            "method": "PUT",
            "rel": "update",
            "href": "/authorization/shares/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/shares/3288b305-981f-4b8d-b440-0911eabc3fac",
            "type": "application/vnd.sas.authorization.share",
            "responseType": "application/vnd.sas.authorization.share"
        },
        {
            "method": "DELETE",
            "rel": "delete",
            "href": "/authorization/shares/3288b305-981f-4b8d-b440-0911eabc3fac",
            "uri": "/authorization/shares/3288b305-981f-4b8d-b440-0911eabc3fac"
        }
    ],
    "id": "3288b305-981f-4b8d-b440-0911eabc3fac",
    "modifiedTimestamp": "2016-08-27T04:09:42.150Z",
    "createdTimestamp": "2016-08-27T04:09:42.150Z",
    "createdBy": "currentUser",
    "modifiedBy": "currentUser"
}
```

#### <a name='StopShareResource'>Stop Sharing a Resource</a>
Here is an example of deleting a corresponding share to stop sharing a resource with another user.

```
DELETE /authorization/shares/3288b305-981f-4b8d-b440-0911eabc3fac
```

#### <a name='CreateAuthorizationDecision'>Create an Authorization Decision</a>
Here is an example of using relevant authorization context to create an authorization decision.

```
POST /authorization/decision
Content-Type: application/vnd.sas.authorization.context+json
Accept-Type: application/vnd.sas.authorization.decision+json
```

```json
{
  "request": {
    "uri": "/test/123"
  },
  "principals": [
    {
      "version": 1,
      "name": "testuser",
      "type": "user"
    }
  ],
  "permission": "read",
  "parameters": {},
  "properties": {},
  "links": {},
  "bulkLinks": {},
  "matchParams": false,
  "eachNamed": {},
  "returnObjectName": null
}
```
Here is an example of the response:
```json
true
```

#### <a name='CreateBulkAuthorizationDecision'>Create a Bulk Authorization Decision</a>
Here is an example of using relevant authorization context, as well as a map of permissions to an array of links, to create a bulk authorization decision.

```
POST /authorization/decisions
Content-Type: application/vnd.sas.authorization.bulk.context+json
Accept-Type: application/vnd.sas.authorization.authorized.links+json
```

```json
{
  "request": {},
  "principals": [
    {
      "version": 1,
      "name": "testprincipal",
      "type": "user"
    }
  ],
  "permission": null,
  "parameters": {},
  "properties": {},
  "links": {},
  "bulkLinks": {
    "read": [
      {
        "method": "GET",
        "rel": "fakeRel",
        "href": "/test/123",
        "uri": "/test/123"
      },
      {
        "method": "GET",
        "rel": "fakeRel",
        "href": "/something",
        "uri": "/something"
      },
      {
        "method": "GET",
        "rel": "fakeRel",
        "href": "/test123/123456",
        "uri": "/test123/123456"
      },
      {
        "method": "GET",
        "rel": "fakeRel",
        "href": "/xyz/abc/something",
        "uri": "/xyz/abc/something"
      }
    ]
  },
  "matchParams": false,
  "eachNamed": {},
  "returnObjectName": null
}
```
Here is an example of the response:
```json
{
  "version": 1,
  "grantedLinks": [
    {
      "method": "GET",
      "rel": "fakeRel",
      "href": "/something",
      "uri": "/something"
    },
    {
      "method": "GET",
      "rel": "fakeRel",
      "href": "/test123/123456",
      "uri": "/test123/123456"
    },
    {
      "method": "GET",
      "rel": "fakeRel",
      "href": "/test/123",
      "uri": "/test/123"
    },
    {
      "method": "GET",
      "rel": "fakeRel",
      "href": "/xyz/abc/something",
      "uri": "/xyz/abc/something"
    }
  ],
  "prohibitedLinks": []
}
```

version 5, last updated on 22 NOV, 2019