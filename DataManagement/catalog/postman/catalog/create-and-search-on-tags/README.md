# Create and Search on Tags
## Overview
This collection leverages the Catalog API to create and search tags.
- In this use case, three instances are created and named Groceries, Rent and Going Out. Each represents a log of the different expenses a person might use to track spending.
- A tag is created named Expenses. The tag is applied to the instances.
- The tag is searched using the `/search` endpoint.
- Get the tag by `tag_name` and `tag_id`.
- Update the tag name.
- Remove an instance from a tag.
- Delete a tag.
- Use the `/deletions` endpoint to delete the instances.

**NOTE**: Making changes to the tag/instances outside of the requests in this collection or executing the requests in a different order might void some of the variables that are used in the requests. Some examples are: updating the tag instance's ID or name, changing the environment variables before some requests, or deleting any environment variables. If you do make any changes, update the environment variables accordingly to avoid any issues. You can also run the two delete requests to clean up the tags and instances.

### Variables
The Postman collection comes with variables that you must assign in the sasserver.env prior to running the collection:
- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `access_token`
<!---->
Create or assign values in your environment to the following:
- `tag_name` - the name of the tag to be created and applied to the instances. Set to "Expenses" by default. Can be edited to fit your use case.
<!---->
Other variables are assigned programmatically during the REST calls using code in the Postman Tests tab.

## Usage
1. Download the JSON collection and the sasserver.env. Import the files into Postman.
2. Select sasserver.env as the environment. Edit your environment variables to match those contained in the collection requests (sasserver, access_token) or by running `Delete Tag` as it resets the value back to "Expenses".
3. Authenticate to your server before testing the endpoints by running the first request: `0. Get token`.
- For the Postman collection only, the IDs for the created sample instances are saved in environment variables that follow the pattern: `sample_instance[0|1|2]_id`. If you wish to have a specific name (ex: `expense0_id`), be sure to make that change within the other requests as well. These changes are made in the Tests tab and the request body.
## Endpoints Used
- [/catalog/instances](https://developer.sas.com/rest-apis/catalog/createInstance) - Create instances
- [/catalog/tags](https://developer.sas.com/rest-apis/catalog#tags) - Create/Get/Update a tag
- [/catalog/search](https://developer.sas.com/rest-apis/catalog#search) - Search
- [/catalog/deletions](https://developer.sas.com/rest-apis/catalog#deletions) - Deletions
## Supported Versions
- Viya 4
- 2023.09
## Additional Resources
- Full documentation of the Catalog API can be found [here](http://swagger.na.sas.com/swagger-ui/?url=/apis/catalog/v1/openapi-all.json).
