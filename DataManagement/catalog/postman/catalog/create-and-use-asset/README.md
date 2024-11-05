# Create and Use Asset

## Overview

This collection leverages the Catalog API to create and use an asset.

Before creating an asset, a schema must first be defined. Afterwards, assets can be created according to this defined schema.

In the Catalog API, a schema for an asset is defined using a type definition. For this use case, we create a type definition for a new asset type named *publicDataSet*.

With the schema defined, assets and relationships can be created using the endpoints of instances. In the Catalog API, an instance of an asset type is known as an entity. The scenario shows both how to create a single asset and how to use an archive to create or update assets and relationships. The relationship in this scenario is adding a contact to an asset.

The assets are queried using both a view and a filter on the instances endpoint.

## Prerequisites

### Variables

The Postman collection comes with variables that you must assign either at the collection or the environment level. Assign values to the following variables prior to running the collection:

- `sasserver` - the location of the SAS Viya server; for example: https://myserver.sas.com
- `access_token`
- `username`
Other variables are assigned programmatically during the REST calls using code in the Postman Tests tab.

## Usage

1. Download the JSON collection and the sasserver.env. Then import the files into Postman.
2. Select sasserver.env as the environment and edit your environment variables to match those contained in the collection requests (sasserver, access_token, and username).
3. Be sure to authenticate to your server before testing the endpoints.

## Endpoints Used

- [/catalog/definitions](https://developer.sas.com/rest-apis/catalog/createTypeDefinition) - Create Type Definition
- [/catalog/instances](https://developer.sas.com/rest-apis/catalog/createInstance) - Create an Instance
- [/catalog/instances](https://developer.sas.com/rest-apis/catalog/getInstances) - Get a list of Instances using a filter
- [/catalog/instances](https://developer.sas.com/rest-apis/catalog/createOrUpdateInstanceArchive) - Create or update objects from an archive
- [/catalog/instances](https://developer.sas.com/rest-apis/catalog/queryArchive) - Get an archive of objects based on a view
- [/catalog/instances](https://developer.sas.com/rest-apis/catalog/deleteInstance) - Delete an Instance by its Instance ID
- [/catalog/definitions](https://developer.sas.com/rest-apis/catalog/deleteTypeDefinition) - Delete a Type Definition by its ID

## Supported Versions

- Viya 4
- 2023.10

## Additional Resources
