# Search and Find Assets

## Overview

This collection leverages the Catalog API to support search capabilities.

- Using search with facets to find data sets with a free text query.

- Using suggestions to retrieve suggested values for searchers on a given facet.

- Specifying an index to limit the type of resources returned by the request.

- Find data sets that have been updated from a specified time period.

- Find resources based on the provided indices and keyword.

## Prerequisites

### Variables

The Postman collection comes with variables that must be assigned either at the collection or the environment level. Assign values to the following variables prior to running the collection:

- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `access_token`
Other variables are assigned programmatically during the REST calls using code in the Postman Tests tab.

## Usage

1. Download the JSON collection and the sasserver.env. Then import the files into Postman.
2. Select sasserver.env as the environment and edit your environment variables to match those contained in the collection requests (sasserver and access_token).
3. Be sure to authenticate to your server before testing the endpoints.

## Endpoints Used

- [/catalog/search](https://developer.sas.com/rest-apis/catalog/getSearchResults) - Get Search Results
- [/catalog/search/facets](https://developer.sas.com/rest-apis/catalog/getSearchFacets) - Get Search Facets
- [/catalog/search/suggestions](https://developer.sas.com/rest-apis/catalog/getSearchSuggestions) - Retrieve suggested values for searches on a given field

## Supported Versions

- Viya 4
- 2023.10

## Additional Resources
