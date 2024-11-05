# Search and Find Assets

## Overview

This collection leverages the Catalog API to support search capabilities.

- Using search with facets to find data sets with a free text query.

- Using suggestions to retrieve suggested values for searchers on a given facet.

- Specifying an index to limit the type of resources returned by the request.

- Find data sets that have been updated from a specified time period.

- Find resources based on the provided indices and keyword.

## Prerequisites

#### Variables to assign:
- sasserver - the SAS Viya server URL
- username
- password

### Python Version and Packages
- python 3.10+
- requests, json, datetime

## Usage
1. Download the Python program or the Jupyter Notebook file.
2. Edit your variables to match your environment.
3. Proceed to run the program or Notebook commands

## Endpoints Used

- [/catalog/search](https://developer.sas.com/rest-apis/catalog/getSearchResults) - Get Search Results
- [/catalog/search/facets](https://developer.sas.com/rest-apis/catalog/getSearchFacets) - Get Search Facets
- [/catalog/search/suggestions](https://developer.sas.com/rest-apis/catalog/getSearchSuggestions) - Retrieve suggested values for searches on a given field

## Supported Versions

- Viya 4
- 2023.10

## Additional Resources
