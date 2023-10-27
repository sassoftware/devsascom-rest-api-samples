# Create and Use Asset

## Overview

This notebook leverages the Catalog API to create and use an asset.

Before creating an asset, a schema must first be defined. Afterwards, assets can be created according to this defined schema.

In the Catalog API, a schema for an asset is defined using a type definition. For this use case, we create a type definition for a new asset type named *publicDataSet*.

With the schema defined, assets and relationships can be created using instances endpoints. In the Catalog AP, an instance of an asset type is known as an entity. The scenario shows both how to create a single asset and how to use an archive to create or update assets and relationships. The relationship in this scenario is adding a contact to an asset.

The assets are queried using both a view and a filter on the instances endpoint.

## Prerequisites

#### Variables to assign

- sasserver - the SAS Viya server URL
- username
- password

### Packages and Python Version
- python 3
- requests, json,  format_date_time, datetime, mktime

## Usage
1. Download the Python program or the Jupyter Notebook file.
2. Edit your variables to match your environment.
3. Proceed to run the program or Notebook commands.

## Endpoints Used

- [/catalog/definitions](https://developer.sas.com/apis/rest/DataManagement/#create-a-type-definition) - Create Type Definition
- [/catalog/instances](https://developer.sas.com/apis/rest/DataManagement/#create-an-instance) - Create an Instance
- [/catalog/instances](https://developer.sas.com/apis/rest/DataManagement/#get-a-list-of-instances) - Get a list of Instances using a filter
- [/catalog/instances](https://developer.sas.com/apis/rest/DataManagement/#create-or-update-objects-from-an-archive) - Create or update objects from an archive
- [/catalog/instances](https://developer.sas.com/apis/rest/DataManagement/#get-an-archive-of-objects-based-on-a-view) - Get an archive of objects based on a view
- [/catalog/instances](https://developer.sas.com/apis/rest/DataManagement/#delete-an-instance-by-its-instance-id) - Delete an Instance by its Instance ID
- [/catalog/definitions](https://developer.sas.com/apis/rest/DataManagement/#delete-a-type-definition-by-its-id) - Delete a Type Definition by its ID

## Supported Versions

- Viya 4
- 2023.10

## Additional Resources
