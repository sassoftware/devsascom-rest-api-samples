# Create and Search on Tags
## Overview
This python notebook leverages the Catalog API to create and search tags.
- In this use case, three instances are created and named Groceries, Rent and Going Out. Each represents a log of the different expenses a person might use to track spending.
- A tag is created named Expenses. The tag is applied to the instances.
- The tag is searched using the `/search` endpoint.
- Get the tag by `tag_name` and `tag_id`.
- Update the tag name.
- Remove an instance from a tag.
- Delete a tag.
- Use the `/deletions` endpoint to delete the instances.

#### Variables to assign:
- sasserver - the SAS Viya server URL
- username
- password
### Python Version and Packages used
- python 3.10+
- requests, json
## Usage
1. Download the Python program or the Jupyter Notebook file.
2. Edit your variables to match your environment.
3. Proceed to run the program or Notebook commands.
## Endpoints Used
- [/catalog/instances](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/instances) - Create instances
- [/catalog/tags](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/tags) - Create/Get/Update a tag
- [/catalog/search](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/search) - Search
- [/catalog/deletions](https://sas-devportal-prod.azurewebsites.net/restApis/internal/catalog-v1/deletions) - Deletions

## Supported Versions

- Viya 4
- 2023.10

## Additional Resources
