# Authorization API
The Authorization API encapsulates all activities that affect access to system functions and resources.

Here is a summary of the functional scope of this API:

* This API enables authorized users to define access by creating and managing authorization rules and shares.
* This API enables any principal that has the Secure permission for a particular object to create and manage
authorization rules that directly target that object.
* This API enables any principal that has the Secure permission for a particular object to share that object.
If re-sharing is enabled, each share recipient can extend the access that they receive to other users and groups.
* This API enforces authorization rules by making authorization decisions. Each decision is evaluated for a
specific authorization context. The decision process is transparent to end users.
* This API explains its authorization decisions by listing all of the rules and shares that contribute to each decision.
* This API does not manage access to CAS data (caslibs and tables) or CAS actions.

For background information, see <a href="http://documentation.sas.com/?docsetId=calauthzgen&docsetTarget=n1xnhxt4tj57wzn1kdridi7u2g27.htm&docsetVersion=3.4&locale=en" target="new">
General Authorization: Concepts</a>.


## API Request Examples Grouped by Object Type

<details>
<summary>Rules</summary>

* [Create an Authorization Rule](#CreateAuthorizationRule)
* [Get Authorization Rule by ID](#GetAuthorizationRuleID)
* [Update an Existing Authorization Rule](#UpdateExistingAuthorizationRule)
* [Paginate Through Rules](#PaginateThroughRules)
* [Patch the Rules Collection Using a 'test' Condition](#PatchRulesCollectionUsingTestCondition)
* [Migrating Existing Rules With a PATCH Request](#MigratingExistingRulesPATCHRequest)
* [Create and Monitor a Rule Job](#CreateMonitorRuleJob)
</details>

<details>
<summary>Shares</summary>

* [Share a Resource](#ShareResource)
* [Unshare a Resource](#UnshareResource)
 </details>

<details>
<summary>Decisions</summary>

* [Create an Authorization Decision](#CreateAuthorizationDecision)
* [Create a Bulk Authorization Decision](#CreateBulkAuthorizationDecision)
</details>

### <a name='CreateAuthorizationRule'>Create an Authorization Rule</a>

```
POST /authorization/rules
    Content-Type: application/vnd.sas.authorization.rule+json
```

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

### <a name='GetAuthorizationRuleID'>Get Authorization Rule by ID</a>
Individual authorization rules can be fetched by their ID.
This done by performing a GET request to /authorization/rules/{id}

```
GET /authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac
    Accept: application/vnd.sas.authorization.rule+json
```

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

### <a name='UpdateExistingAuthorizationRule'>Update an Existing Authorization Rule</a>
Individual authorization rules can be updating by their ID.
This done by performing a PUT request to /authorization/rules/{id}

```
PUT /authorization/rules/3288b305-981f-4b8d-b440-0911eabc3fac
    Content-Type: application/vnd.sas.authorization.rule+json
```

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

### <a name='PaginateThroughRules'>Paginate Through Rules</a>

```
GET /authorization/rules?start=0&limit=20
    Accept: application/vnd.sas.collection+json
```

### <a name='PatchRulesCollectionUsingTestCondition'>Patch the Rules Collection Using a 'test' Condition</a>
In the following example, the defined rule sets the permissions to Read, Update, Delete, and Secure and the objectUri to '/identities/*'
if and only if the existing rule has type=grant, permissions=[read,update], objectUri=/identities/**, and principalType=authenticated-users.
If any of these values do not match, the patch is not applied.

```
PATCH /authorization/rules
    Content-Type: application/json-patch+json
    Accept: application/vnd.sas.collection+json
```

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

### <a name='MigratingExistingRulesPATCHRequest'>Migrating Existing Rules With a PATCH Request</a>
Using a combination of the defined JSON patch operations, you can migrate existing rules. This starts with a `copy` operation to copy the
existing rule and any changes that might have been applied to it. Then an `add` or `replace` operation to update the target rule. Finally, a
`remove` operation must delete either the original rule or the new rule.

To target a rule that does not have a known ID, use the simple token substitution system that this API provides. In a single patch, each new
rule that is CREATED by an `add` or `copy` operation is added to a zero-indexed, ordered list. (Note that an `add` operation can be either
a create or an update, depending on whether a rule with the given ID already exists. A rule that is updated is not added to the
list of created rules.) Because you know the order in which rules are created within a patch, you can reference any such rule by
its index. Use the token @CREATED#@ (where '#' is the index of the rule that you are targeting). See below for an example that assumes a rule
already exists with ID = "sourceId" and modifies the rule before removing the source rule.

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

### <a name='CreateMonitorRuleJob'>Create and Monitor a Rule Job</a>
This example shows how to create a rule job that will create two rules and modify an existing rule. It then shows how
to check the current state of the job.

CREATE JOB
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

RESPONSE
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

CHECK STATUS
```
GET /authorization/rules/jobs/cc2cb37c-24e6-4398-b7c8-4b6603bc4608/state
```

RESPONSE
```json
"pending"
```

### <a name='ShareResource'>Share a Resource</a>
This example shows how to create a share that enables another user to read a file that they do not already have access to.

CREATE SHARE
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

RESPONSE
```json
{
    "type": "read",
    "sharedWith": "testUser",
    "sharedWithType": "user",
    "sharedBy": "currentUser",
    "resourceUri": "/files/files/4288b305-981f-4b8d-b440-0911eabe3faf",
    "name": "test file",
    "version": 2,
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

### <a name='UnshareResource'>Unshare a Resource</a>
This example shows how to unshare a resource by deleting the corresponding share.

DELETE SHARE
```
DELETE /authorization/shares/3288b305-981f-4b8d-b440-0911eabc3fac
```

### <a name='CreateAuthorizationDecision'>Create an Authorization Decision</a>
This example shows how to create an authorization decision by providing an authorization context containing relevant authorizable information.

CREATE DECISION
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

RESPONSE
```json
true
```

### <a name='CreateBulkAuthorizationDecision'>Create a Bulk Authorization Decision</a>
This example shows how to create a bulk authorization decision by providing an authorization context containing relevant authorizable information
as well as a map of permissions to arrays of links.

CREATE BULK DECISION
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

RESPONSE
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