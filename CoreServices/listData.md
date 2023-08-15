The List Data API enables the user to publish and query tabular data sets (lists) in a low-latency, key-value data store. The API includes the ability to create, read, update, and delete a list and control access through authorization rules.

SAS products that integrate the capabilities of the List Data API refer to the functionality as Advanced Lists. These tabular data sets, called lists, can have multiple keys and values that can be shared among other SAS applications and workflows.

**IMPORTANT:** In order to use the List Data API, you must provide, configure, and maintain your own Redis instance for the List Data service.

For information about configuring the List Data service for Redis, see [sas.listData.redis](https://go.documentation.sas.com/doc/en/sasadmincdc/default/calconfig/n0yoibr26a822en1j3jmqz71ni6g.htm#p15ctj2v34em8pn1nnuinvsc7z5z).

**See also:**

* [List Data API documentation](https://developer.sas.com/apis/rest/CoreServices/#list-data)


## API Request Examples

This use case shows how to use the List Data API endpoints to create and manage a list for employee information and it covers the following scenarios:

*  [Creating a new list definition for employee data](#creating)
*  [Retrieving all lists or a single list by listId](#retrieving)
*  [Updating the list's description and label](#updating)
*  [Importing data from a CSV file](#importing)
*  [Getting the status of an import job](#getting-import)
*  [Changing the list's state](#changing)
*  [Adding, updating, or deleting list contents](#adding)
*  [Submitting a job to purge a list's contents](#submitting)
*  [Getting the status of a purge job](#getting-purge)
*  [Delete the list definition](#deleting)

#### <a name="creating">Create a New List Definition for Employee Data</a>

This example shows how to send a POST request to the `/lists` endpoint.

In this example, you specify the following metadata for the new list:
- 'name' (must be unique across all list definitions)
- 'state' (must be 'active' or 'inactive')
- 'description' (optional)
- 'isImmutable' ('true' or 'false' to indicate whether the contents can be modified after you create the list. The default is 'false'.)
- 'label' (optional)

You initially create the list definition by specifying values for the minimally required properties. Your list definition looks like this:

``` JSON
{
  "name": "ACME Corp Employees",
  "state": "inactive",
}
```

Next, create a collection of column information objects that describe the list contents. At a minimum, you need the following properties for each column:
- 'name' (must match the column name in the CSV data)
- 'dataType' (must be either 'number' or 'string')
- 'position' (must begin with '1')

In addition, identify at least one column as a unique key. You can create a composite key by combining multiple columns. In this case, set 'isKey' to 'true' for each column that is part of the key and set the 'keyPosition' value to indicate the order in which the columns should be combined.
In this example, 'employeeId' is your key, so the 'ColumnInfo' object for 'employeeId' includes the 'isKey' and 'keyPosition' properties.

Here is a small sample of your data:
``` CSV
employeeId,firstName,lastName,email,phoneNumber,hireDate,jobId,salary,commissionPct,managerId,departmentId
100,Steven,King,SKING,515-123-4567,17-JUN-03,AD_PRES,24000,0,0,90
101,Neena,Kochhar,NKOCHHAR,515-123-4568,21-SEP-05,AD_VP,17000,0,100,90
102,Lex,De Haan,LDEHAAN,515-123-4569,13-JAN-01,AD_VP,17000,0,100,90
```
Your list definition looks like this after you have added the 'ColumnInfo' objects:

``` JSON
{
  "name": "ACME Corp Employees",
  "state": "inactive",
  "columns": [
    {
      "name": "employeeId",
      "dataType": "number",
      "position": 1,
      "isKey": true,
      "keyPosition": 1
    },
    {
      "name": "firstName",
      "dataType": "string",
      "position": 2
    },
    {
      "name": "lastName",
      "dataType": "string",
      "position": 3
    },
    {
      "name": "email",
      "dataType": "string",
      "position": 4
    },
    {
      "name": "phoneNumber",
      "dataType": "string",
      "position": 5
    },
    {
      "name": "hireDate",
      "dataType": "string",
      "position": 6
    },
    {
      "name": "jobId",
      "dataType": "string",
      "position": 7
    },
    {
      "name": "salary",
      "dataType": "number",
      "position": 8
    },
    {
      "name": "commissionPct",
      "dataType": "number",
      "position": 9
    },
    {
      "name": "managerId",
      "dataType": "number",
      "position": 10
    },
    {
      "name": "departmentId",
      "dataType": "number",
      "position": 11
    }
  ]
}
```

##### Python Example Code
Here is an example of how to send a POST request to the `/lists` endpoint in Python. The list definition that you created above has been saved to employeesListDefinition.json.

``` Python
import requests
import json
from requests.structures import CaseInsensitiveDict

# Set the headers. The actual authorization token is not shown here.
headers = CaseInsensitiveDict()
headers["Accept"] = "application/vnd.sas.listdata.list+json"
headers["Content-Type"] = "application/vnd.sas.listdata.list+json"
headers["Authorization"] = f"Bearer {sasdemo_token}"

# Get the list definition from the JSON file.
f = open("employeesListDefinition.json")
employeeList = json.dumps(json.load(f), indent=2)
f.close()

url = "https://myserver:443/listData/lists"
response = requests.post(url, headers=headers, data=employeeList)

# A "create" should return HTTP 201 (Created).
assert response.status_code == 201, f"\n{json.dumps(response.json(), indent=2)}"

# Save the 'listId' for later.
response_body = response.json()
createdListId = response_body['id']
```

##### Example JSON Response
Notice that the JSON response body that is returned contains more information than what you provided in the request body.

- Additional metadata:
    - 'id'- the unique ID created by the ListData service that is used when referring to the list in GET, PUT, or DELETE requests
    - 'version' - the version of the vnd.sas.listdata.list schema
    - 'creationTimeStamp' - the timestamp for when the list was created
    - 'createdBy' - the name of the user who created the list
    - 'modifiedTimeStamp' - the timestamp for when the list was most recently modified
    - 'modifiedBy' - the name of the user who last modified the list

- Properties not included in the request body that used their default values:
    - 'description'
    - 'isImmutable'
    - 'label'

- Links:
    - used for further interaction with the list that you created


``` JSON
{
  "id": "6c757bb0-29d5-4118-8ad7-04e5cfda3992",
  "version": 1,
  "creationTimeStamp": "2022-12-11T12:40:06.794857653Z",
  "modifiedTimeStamp": "2022-12-11T12:40:06.794857653Z",
  "createdBy": "sasdemo",
  "modifiedBy": "sasdemo",
  "name": "ACME Corp Employees",
  "description": "",
  "state": "inactive",
  "isImmutable": false,
  "label": "",
  "columns": [
    {
      "name": "employeeId",
      "dataType": "number",
      "position": 1,
      "isKey": true,
      "keyPosition": 1
    },
    {
      "name": "firstName",
      "dataType": "string",
      "position": 2,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "lastName",
      "dataType": "string",
      "position": 3,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "email",
      "dataType": "string",
      "position": 4,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "phoneNumber",
      "dataType": "string",
      "position": 5,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "hireDate",
      "dataType": "string",
      "position": 6,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "jobId",
      "dataType": "string",
      "position": 7,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "salary",
      "dataType": "number",
      "position": 8,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "commissionPct",
      "dataType": "number",
      "position": 9,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "managerId",
      "dataType": "number",
      "position": 10,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "departmentId",
      "dataType": "number",
      "position": 11,
      "isKey": false,
      "keyPosition": 0
    }
  ],
  "links": [
    {
      "method": "GET",
      "rel": "up",
      "href": "/listData/lists",
      "uri": "/listData/lists",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.listdata.list"
    },
    {
      "method": "GET",
      "rel": "self",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992",
      "type": "application/vnd.sas.listdata.list"
    },
    {
      "method": "PUT",
      "rel": "update",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992",
      "type": "application/vnd.sas.listdata.list",
      "responseType": "application/vnd.sas.listdata.list"
    },
    {
      "method": "GET",
      "rel": "state",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/state",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/state",
      "type": "text/plain"
    },
    {
      "method": "GET",
      "rel": "contents",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/contents",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/contents",
      "type": "application/vnd.sas.collection",
      "itemType": "application/json"
    },
    {
      "method": "GET",
      "rel": "contentsDataset",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/contents",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/contents",
      "type": "application/vnd.sas.listdata.dataset"
    },
    {
      "method": "PUT",
      "rel": "updateContents",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/contents",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/contents",
      "type": "application/vnd.sas.collection",
      "responseType": "application/vnd.sas.listdata.list",
      "itemType": "application/json"
    },
    {
      "method": "POST",
      "rel": "importContents",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/importJobs",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/importJobs",
      "type": "multipart/form-data",
      "responseType": "application/vnd.sas.listdata.importjob"
    },
    {
      "method": "POST",
      "rel": "purgeContents",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/purgeJobs",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/purgeJobs",
      "responseType": "application/vnd.sas.listdata.purgejob"
    },
    {
      "method": "DELETE",
      "rel": "delete",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992"
    },
    {
      "method": "GET",
      "rel": "alternate",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992",
      "type": "application/vnd.sas.summary"
    },
    {
      "method": "GET",
      "rel": "privilegedContents",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/privilegedContents",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/privilegedContents",
      "type": "application/vnd.sas.listdata.list"
    },
    {
      "method": "PUT",
      "rel": "privilegedEdit",
      "href": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/privilegedEdit",
      "uri": "/listData/lists/6c757bb0-29d5-4118-8ad7-04e5cfda3992/privilegedEdit",
      "type": "application/vnd.sas.listdata.list",
      "responseType": "application/vnd.sas.listdata.list"
    }
  ]
}

```

#### <a name="retrieving">Retrieve All Lists or a Single List by the List ID</a>
To see all lists, you can send a GET request to the `/lists` endpoint. A collection of list resources is returned that includes all lists that you are authorized to see. To see a single list, you can send a GET request to the `/lists/{listId}` endpoint.

Here is an example:
```
https://myserver:443/listData/lists
or
https://myserver:443/listData/lists/{listId}

```

##### Example JSON Response
https://myserver:443/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2

Note: Links have been removed for brevity.

``` JSON
{
  "createdBy": "sasdemo",
  "creationTimeStamp": "2022-12-12T16:39:42.818187Z",
  "description": "",
  "id": "b3c93e05-2f57-49a9-9780-df55ae0510f2",
  "isImmutable": false,
  "label": "",
  "modifiedBy": "sasdemo",
  "modifiedTimeStamp": "2022-12-12T17:49:29.562215Z",
  "name": "ACME Corp Employees",
  "state": "inactive",
  "version": 1,
  "columns": [
    {
      "name": "employeeId",
      "dataType": "number",
      "position": 1,
      "isKey": true,
      "keyPosition": 1
    },
    {
      "name": "firstName",
      "dataType": "string",
      "position": 2,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "lastName",
      "dataType": "string",
      "position": 3,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "email",
      "dataType": "string",
      "position": 4,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "phoneNumber",
      "dataType": "string",
      "position": 5,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "hireDate",
      "dataType": "string",
      "position": 6,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "jobId",
      "dataType": "string",
      "position": 7,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "salary",
      "dataType": "number",
      "position": 8,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "commissionPct",
      "dataType": "number",
      "position": 9,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "managerId",
      "dataType": "number",
      "position": 10,
      "isKey": false,
      "keyPosition": 0
    },
    {
      "name": "departmentId",
      "dataType": "number",
      "position": 11,
      "isKey": false,
      "keyPosition": 0
    }
  ]
}
```


#### <a name="updating">Update the List's Description and Label</a>
In this example, use a PUT request to update the properties of a list by sending a JSON object in the body of the request to the `/lists/{listId}` endpoint. 
_You cannot modify the following properties if the list definition has contents:_
- 'name'
- 'isImmutable'
- 'columns'
    - You cannot add or remove columns.
    - 'dataMask' is the only 'ColumnInfo' property that you can modify and you must use the `privilegedEdit` endpoint.

You *can* update these properties:
- 'description'
- 'label'
- 'state'
    - The value can be either 'active' or 'inactive'.
    - You can also use the `/lists/{listId}/state` endpoint.

When you update a list's properties, you need to send only the properties that you are changing in your request body. All other properties, except for the life cycle metadata ('createdBy' and 'modifiedBy'), do not change. In this example, you change the label and add a description to the existing list definition.

Notes:
- You are using a different user identity than what was used for the create request.
- You are using the 'listId' value ('createdListId') that was returned in the response from the create request. If you do not know the 'listId' value, you can send a GET to the `/listData/lists` endpoint to retrieve all lists. You can also filter by the list name, as shown in this example:

  ```
  https://myserver/listData/lists?filter=eq(name,'ACME Corp Employees')
  ```
- The HTTP response includes the entire list record, not just the values that were changed.

##### Example Python Code

``` Python
#!/usr/bin/python3
import argparse
import requests
import json
from requests.structures import CaseInsensitiveDict

parser = argparse.ArgumentParser()
parser.add_argument(
    "listId", help="The listId of the list to be deleted.")
args = parser.parse_args()

listId = args.listId

# Set the headers. The actual authorization token is not shown here.
headers = CaseInsensitiveDict()
headers["Accept"] = "application/vnd.sas.listdata.list+json"
headers["Content-Type"] = "application/vnd.sas.listdata.list+json"
headers["Authorization"] = f"Bearer {user1_token}"

url = f"https://myserver:443/listData/lists/{listId}"

# Update values for 'label' and 'description'.
employeeList = {
    "label": "Internal Use Only",
    "description": "Employee Information"
}

response = requests.put(url, headers=headers, data=json.dumps(employeeList))
response_body = response.json()
if response.status_code != 200:
    print("\nRESPONSE:\n", json.dumps(response_body, indent=2))
    exit(1)

# Show the response without links or columns.
del response_body['links']
del response_body['columns']
print(f"RESPONSE:\n{json.dumps(response_body, indent=2)}")

```

##### Example JSON Response

- The 'modifiedTimeStamp' and 'modifiedBy' values have been updated.
- The 'description' and 'label' values have been updated.
- The columns and links have been omitted for brevity.

``` JSON
{
  "id": "27f48794-25b8-473e-b7f4-15c836f6eca7",
  "version": 1,
  "creationTimeStamp": "2022-12-11T13:52:03.507741Z",
  "modifiedTimeStamp": "2022-12-11T15:10:26.528894209Z",
  "createdBy": "sasdemo",
  "modifiedBy": "sastest1",
  "name": "ACME Corp Employees",
  "description": "Employee Information",
  "state": "inactive",
  "isImmutable": false,
  "label": "Internal Use Only"
}

```

#### <a name="importing">Import Data from a CSV File</a>
Loading data from a CSV file for your list requires that you create an inport job by submitting a POST request to the `/lists/{listId}/ImportJobs` endpoint. The POST request must include the CSV file that contains the data and a parameter that specifies the delimiter that is used in the file, which is typically a comma.

This example shows how to send a POST request to the `/lists/{listId}/ImportJobs` endpoint by using Python. It accepts both the 'listId' value and the CSV file name as command-line parameters.
##### Example Python Code
``` Python
#!/usr/bin/python3
import argparse
import requests
import json
from requests.structures import CaseInsensitiveDict
from os.path import exists

# Get the list ID and CSV file from the command-line.
parser = argparse.ArgumentParser()
parser.add_argument(
    "listId", help="The listId of the list definition.")
parser.add_argument(
    "csvFile", help="The CSV file that contains the data.")

args = parser.parse_args()
listId = args.listId
csvFile = args.csvFile

# Check whether the CSV file exists.
if not exists(csvFile):
    raise SystemExit(f"CSV File {csvFile} does not exist.")

# Set headers. The actual authorization token is not shown here.
headers = CaseInsensitiveDict()
headers["Accept"] = "application/json"
headers["Authorization"] = f"Bearer {sasdemo_token}"

# Open the CSV file.
try:
    files = {
        'dataFile': (csvFile, open(csvFile, 'rb'), 'text/csv')
    }
except:
    raise SystemExit(f"Unable to open {csvFile}.")

# Set a comma as the delimeter.
data = {
    'delimeter': ','
}

# Send a POST to '/lists/{listId}/ImportJobs'.
url = f"https://myserver:443/listData/lists/{listId}/importJobs"
response = requests.post(url, headers=headers, files=files, data=data)

# Show the response.
response_body = response.json()
print(json.dumps(response_body, indent=2))
```

The job runs asynchronously, and the response returns immediately. If the import job is successfully accepted, HTTP Status 202 (Accepted) is returned with a JSON response that provides the following information about the import job:

- 'id' - the import job ID
- 'state' - the state of the job (running, completed, and so on)
- 'filename' - the name of the file that you submitted with the request
- 'listId' - the ID of the list resource definition that is associated with this job
- 'results' - initially empty


##### Example JSON Response

``` JSON
{
  "id": "c86bfb89-8f89-403f-a91f-907eead07559",
  "version": 1,
  "state": "running",
  "fileName": "employees.csv",
  "sha256Sum": "e8ef753212e4ca360a99f68ff9f6335c72faf5fc7a174920d9e940880690e3d4",
  "creationTimeStamp": "2022-12-12T17:06:31.693948Z",
  "createdBy": "sasdemo",
  "listId": "b3c93e05-2f57-49a9-9780-df55ae0510f2",
  "results": {},
  "totalErrors": 0,
  "errors": [],
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs/c86bfb89-8f89-403f-a91f-907eead07559",
      "uri": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs/c86bfb89-8f89-403f-a91f-907eead07559",
      "type": "application/vnd.sas.listdata.importjob"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs",
      "uri": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.listdata.importjob"
    }
  ]
}

```
#### <a name="getting-import">Get the Status of an Import Job</a>
After you submit the import job, you can retrieve the job's status by sending a GET request to the "self" link that is returned when you submitted the import job. Here is example output:

https://myserver:443/listData/lists/{listId}/importJobs/{importJobId}

Here is the link for your example based on the example output above:

https://myserver:443/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs/c86bfb89-8f89-403f-a91f-907eead07559

##### Example JSON Response
The following example response shows that the import job completed successfully without errors and loaded 50 records.

``` JSON
{
  "id":"c86bfb89-8f89-403f-a91f-907eead07559",
  "version":1,
  "state":"completed",
  "fileName":"employees.csv",
  "sha256Sum":"e8ef753212e4ca360a99f68ff9f6335c72faf5fc7a174920d9e940880690e3d4",
  "creationTimeStamp":"2022-12-12T17:06:31.693948Z",
  "completedTimeStamp":"2022-12-12T17:06:31.757776Z",
  "createdBy":"sasdemo",
  "listId":"b3c93e05-2f57-49a9-9780-df55ae0510f2",
  "results":{
    "recordCount":50
  },
  "totalErrors":0,
  "errors":[],
  "links":[
    {
      "method":"GET",
      "rel":"self",
      "href":"/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs/c86bfb89-8f89-403f-a91f-907eead07559",
      "uri":"/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs/c86bfb89-8f89-403f-a91f-907eead07559",
      "type":"application/vnd.sas.listdata.importjob"
    },
    {
      "method":"GET",
      "rel":"up",
      "href":"/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs",
      "uri":"/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/importJobs",
      "type":"application/vnd.sas.collection",
      "itemType":"application/vnd.sas.listdata.importjob"
    }
  ]
}

```


#### <a name="changing">Change the List's State</a>
You set the state for a list by sending a PUT request to the `/lists/{listId}/state` endpoint and specifying either 'active' or 'inactive' for the value parameter. Here is an example using the 'listId' value from the previous examples:

``` TEXT
PUT https://myserver:443/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/state?value="active"

or

PUT https://myserver:443/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/state?value="inactive"
```

The following example shows how to do this in Python. This program takes a 'listId' and uses either '-i' or '-a' as arguments to set the state to either "inactive" or "active", respectively.

##### Example Python Code
``` PYTHON
#!/usr/bin/python3
import argparse
import requests
import json
from requests.structures import CaseInsensitiveDict
from os.path import exists

# Get the 'listId' value by command-line.
parser = argparse.ArgumentParser()
parser.add_argument(
    "listId", help="The listId of the list to be retrieved.")
argGroup2 = parser.add_mutually_exclusive_group(required=True)
argGroup2.add_argument("-a", "--active", action="store_true",
                       help="Set state to active")
argGroup2.add_argument("-i", "--inactive",
                       action="store_true", help="Set state to inactive")

args = parser.parse_args()
listId = args.listId

# Set headers. The actual authorization token is not shown here.
headers = CaseInsensitiveDict()
headers["Authorization"] = f"Bearer {sasdemo_token}"

# Set the state based on the '-i' or '-a' argument being present.
if args.active:
    state = "active"
elif args.inactive:
    state = "inactive"

webservice = "http://myserver"
url = f"{webservice}/listData/lists/{listId}/state?value={state}"

response = requests.put(url, headers=headers)
if not response.ok:
    print(
        f"ERROR! Return Status: {response.reason} ({response.status_code})\n")
    try:
        jbody = response.json()
        print(json.dumps(jbody, indent=2))
    except:
        print(response.text)
    exit(1)

print(f"Return Status: {response.reason} ({response.status_code})\n")
print(json.dumps(response.json(), indent=2))

```
##### Example JSON Response
The list is returned in the body of the response. Links and columns are removed for brevity.

``` JSON
{
  "id": "b3c93e05-2f57-49a9-9780-df55ae0510f2",
  "version": 1,
  "creationTimeStamp": "2022-12-12T16:39:42.818187Z",
  "modifiedTimeStamp": "2022-12-12T20:18:39.487773Z",
  "createdBy": "sasdemo",
  "modifiedBy": "sasdemo",
  "name": "ACME Corp Employees",
  "description": "",
  "state": "inactive",
  "isImmutable": false,
  "label": ""
}

```

#### <a name="adding">Add, Update, or Delete Contents for a List</a>
Sending a PUT request to the `/lists/{listId}/contents` endpoint enables you to either ***modify*** existing records in a list's contents, ***add*** new records to a list's contents, or ***delete*** records from a list's contents. The ***op*** (short for operation) parameter is used to specify the behavior to either be an ***upsert*** or a ***delete***. The request response contains the list that was modified (the definition, not the contents). In addition, the 'modifiedTimeStamp' and 'modifiedBy' properties are updated to reflect that the list has been updated.


| Desired Effect    | OP Value | Column Values Required                   |
| :---------------- | -------- | :--------------------------------------- |
| Update records    | "upsert" | All key columns + columns to be modified |
| Add new records   | "upsert" | All columns                              |
| Delete records    | "delete" | All key columns                          |

##### Example Python for Updating List Contents
``` Python
#!/usr/bin/python3
import argparse
import requests
import json
from requests.structures import CaseInsensitiveDict
from os.path import exists

# Get the 'listId' and CSV file from the command-line.
parser = argparse.ArgumentParser()
parser.add_argument(
    "listId", help="The listId of the List definition.")

args = parser.parse_args()
listId = args.listId

# Set headers.
headers = CaseInsensitiveDict()
headers["Accept"] = "application/json"
headers["Content-Type"] = "application/vnd.sas.collection+json"

# The actual authorization token is not shown here.
headers["Authorization"] = f"Bearer {sasdemo_token}"

# Specify the op(eration). You are doing an upsert operation.
operation = "upsert"

# Updated Employee Data.
# - Updated salary for Alexander Hunold's staff.
# - New Employee Tyler Tatman.
employeeData = {
    "items": [
        {
            "employeeId": 104,
            "salary": 6501,
        },
        {
            "employeeId": 105,
            "salary": 5301,
        },
        {
            "employeeId": 106,
            "salary": 5301,
        },
        {
            "employeeId": 107,
            "salary": 4701,
        },
        {
            "employeeId": 207,
            "firstName": "Tyler",
            "lastName": "Tatman",
            "email": "TTATMAN",
            "phoneNumber": "850-467-0709",
            "hireDate": "5-FEB-15",
            "jobId": "PUBLICITY",
            "salary": 12000,
            "commissionPct": 0,
            "managerId": 101,
            "departmentId": 90
        }
    ]
}

# Send a PUT to '/lists/{listId}/contents'.
webservice = "https://myserver:443"
url = f"{webservice}/listData/lists/{listId}/contents?op={operation}"

try:
    response = requests.put(url, headers=headers,
                            json=employeeData, verify=False)
except requests.exceptions.ConnectionError as errc:
    raise SystemExit(
        f"Unable to connect to {webservice}. {type(errc)}")


# Show the response without links or columns.
response_body = response.json()
del response_body['links']
del response_body['columns']
print(json.dumps(response_body, indent=2))
```
##### Example JSON Response
The list is returned in the body of the response. Links and columns are removed for brevity.

``` JSON
{
  "id": "b3c93e05-2f57-49a9-9780-df55ae0510f2",
  "version": 1,
  "creationTimeStamp": "2022-12-12T16:39:42.818187Z",
  "modifiedTimeStamp": "2022-12-13T16:04:02.135119Z",
  "createdBy": "sasdemo",
  "modifiedBy": "sasdemo",
  "name": "ACME Corp Employees",
  "description": "",
  "state": "inactive",
  "isImmutable": false,
  "label": ""
}
```

#### <a name="submitting">Submit a Job to Purge a List's Contents</a>
Purging data from a list is a synchronous operation that is initiated by submitting a purge job. You submit the purge job by sending a PUT request to the `/lists/{listId}/purgeJobs` endpoint. There are no additional parameters required.

##### Example Python Code for Updating List Contents
``` Python
#!/usr/bin/python3

import json
import sys
import requests
import argparse

from requests.structures import CaseInsensitiveDict
from urllib3.exceptions import InsecureRequestWarning

parser = argparse.ArgumentParser()
parser.add_argument(
    "listId", help="The listId of the list to be purged.")
parser.add_argument("-v", "--verbose", action="store_true",
                    help="Enable verbose output")
args = parser.parse_args()

listId = args.listId
user = "sasdemo"

webservice = "https://myserver:443"
token = getToken(user)

headers = CaseInsensitiveDict()
headers["Accept"] = "application/json"
headers["Authorization"] = f"Bearer {token}"

url = f"{webservice}/listData/lists/{listId}/purgeJobs"
try:
    response = requests.post(url, headers=headers, verify=False)
except requests.exceptions.ConnectionError as errc:
    raise SystemExit(f"Unable to connect to {webservice}")

print(f"HTTP RESPONSE: {response.reason} ({response.status_code})")
if not response.ok:
    print("\n**ERROR** Unable to purge contents")
    try:
        jbody = response.json()
        print(json.dumps(jbody, indent=2))
    except:
        print(response.text)

try:
    jbody = response.json()
    print(json.dumps(jbody, indent=2))
except:
    print("Unable to render JSON")
    print(response.text)

```
##### Example JSON Response
Among other things, the response that is returned by the POST request contains the initial state of the purge job (running) and links that can be used to retrieve the current state of the purge job.

```JSON
{
  "id": "251f002a-c584-4ba5-8540-ff420805f9f6",
  "version": 1,
  "state": "running",
  "creationTimeStamp": "2022-12-13T17:53:41.813024353Z",
  "createdBy": "sasdemo",
  "listId": "b3c93e05-2f57-49a9-9780-df55ae0510f2",
  "results": {},
  "errors": [],
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs/251f002a-c584-4ba5-8540-ff420805f9f6",
      "uri": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs/251f002a-c584-4ba5-8540-ff420805f9f6",
      "type": "application/vnd.sas.listdata.purgejob"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs",
      "uri": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.listdata.purgejob"
    }
  ]
}
```
#### <a name="getting-purge">Getting the Status of a Purge Job</a>
Once the purge job completes, you can retrieve the job's status by sending a GET request to the "self" link that is returned when you submitted the purge job. Here is example output:

https://myserver:443/listData/lists/{listId}/purgeJobs/{purgeJobId}

Here is the link for your example based on the example output above:

http://myserver:443/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs/251f002a-c584-4ba5-8540-ff420805f9f6

##### Example JSON Response
Once completed, the response shows the state is completed and the timestamps and number of records are updated.
``` JSON
{
  "id": "251f002a-c584-4ba5-8540-ff420805f9f6",
  "version": 1,
  "state": "completed",
  "creationTimeStamp": "2022-12-13T17:53:41.813024Z",
  "completedTimeStamp": "2022-12-13T17:53:41.840122Z",
  "createdBy": "sasdemo",
  "listId": "b3c93e05-2f57-49a9-9780-df55ae0510f2",
  "results": {
    "recordCount": 51
  },
  "errors": [],
  "links": [
    {
      "method": "GET",
      "rel": "self",
      "href": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs/251f002a-c584-4ba5-8540-ff420805f9f6",
      "uri": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs/251f002a-c584-4ba5-8540-ff420805f9f6",
      "type": "application/vnd.sas.listdata.purgejob"
    },
    {
      "method": "GET",
      "rel": "up",
      "href": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs",
      "uri": "/listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2/purgeJobs",
      "type": "application/vnd.sas.collection",
      "itemType": "application/vnd.sas.listdata.purgejob"
    }
  ]
}
```

#### <a name="deleting">Delete the List Definition</a>
To delete a list, you submit a DELETE request to the `/lists/{listId}` endpoint. There are no additional parameters required; however, the list state must not be 'active'. Attempting to delete an active list results in a 409 HTTP Status (Conflict) and returns the following response body:

``` JSON
{
  "httpStatusCode": 409,
  "errorCode": 124775,
  "message": "The list is active.",
  "details": [
    "path: /listData/lists/b3c93e05-2f57-49a9-9780-df55ae0510f2",
    "correlator: c1d96cf0-dda5-4618-a15f-66f7ea11dd30"
  ]
}
```
If the delete request succeeds, HTTP 204 (No Content) is returned. Deleting a list that does not exist is not an error and also returns an HTTP 204 (No Content).

##### Example Python Code

``` Python
#!/usr/bin/python3
import argparse
import requests
import json
from requests.structures import CaseInsensitiveDict

# Get the 'listId' value from the command-line.
parser = argparse.ArgumentParser()
parser.add_argument(
    "listId", help="The listId of the List definition to be deleted.")

args = parser.parse_args()
listId = args.listId

# Set headers.
headers = CaseInsensitiveDict()

# The actual authorization token is not shown here.
headers["Authorization"] = f"Bearer {sasdemo_token}"

# Send a DELETE request to '/lists/{listId}'.
webservice = "https://myserver:443"
url = f"{webservice}/listData/lists/{listId}"

try:
    response = requests.delete(url, headers=headers, verify=False)
except requests.exceptions.ConnectionError as errc:
    raise SystemExit(f"Unable to connect to {webservice}. {type(errc)}")

assert response.status_code == 204, f"\n{json.dumps(response.json(), indent=2)}"
print(f"Return Status: {response.reason} ({response.status_code})\n")
```


version 2, last updated on 15 August, 2023
