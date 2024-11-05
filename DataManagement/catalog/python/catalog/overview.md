
#### Context

This API is used to define and manage [metadata](#Metadata).

##### Background and Overview

This API provides the basic interface to discover, find, and elaborate on metadata within the environment. Metadata in the context of this API refers to descriptive information about any currently defined asset.

##### Use Cases
- retrieve metadata for assets
- define metadata for information consumed, used, or related to assets
- integrate metadata with third-party systems
- find metadata for assets
- build and manage 'bots' which populate the catalog with table metadata

#### Concepts
As part of managing metadata, catalog first requires information about the kind of metadata that will be introduced. Consumers describe the information they wish to manage by providing one or more *type definitions*. Metadata content is added using the Catalog API as *instances* that specify a type definition. The type definition is used to validate and interpret the data in the instance.

These concepts are described in more detail below.

##### Type Definitions
Type definitions define the kind of entities and relationships (along with any attributes) that are allowed for an asset. Type definitions are analogous to the concept of a *class* in an object oriented system; or that of a *DDL* in a relational model.

Type definition names must be unique.

There are four kinds of type definitions:

###### Attribute Type Definitions
Attribute Type Definitions describe properties for the remaining kinds of type definitions. For example, an Entity Type Definition that describes an individual may reference attribute type definitions for contact information such as a phone number or mailing address.

####### Enumerations
Attribute definitions can describe a list of allowed values by specifying `ENUM` as the attributeKind field of the Attribute Type Definition. Enumerations have a list of `elementDefinitions` that describe the allowed values.

####### Attribute Definitions
Attribute type definitions are referenced in type definitions as the `type` field in their `attributes` list; these model elements are known as `attribute definitions`.

A `typeCriteria` object can be included within an attribute definition. This inclusion enables the expression of constraints on the content that are allowed within the attribute's value at run time.
- minLength: the shortest acceptable value; only valid for string types
- maxLength: the longest acceptable value; only valid for string types
- minimum: the smallest acceptable value; only valid for numeric types
- maximum: the largest acceptable value; only valid for numeric types
- minItems: the smallest number of items allowed in the collection; only valid for collections
- maxItems: the largest number of items allowed in the collection; only valid for collections
- required: indicates that the attribute value must be specified

For attribute definitions of type `collection`, the type criteria must include an `items` element that contains a list of attribute definitions that constitute the elements in the collection. Note that specifying additional collection valued attributes in this 'items' list is not supported; the model does not support collections of collections within a single attribute.

###### Entity Type Definitions
Entity Type Definitions describe the nouns in the system. Some examples are data sets or reports.

Entity type definitions can have a *base type* that simplifies modeling by incorporating properties from the base type into the set of properties of the entity type definition. This acts like inheritance of fields in an object-oriented system.

###### Classification Type Definitions
Classification Type Definitions describe a kind of annotation that can be related to Instances. For instance, a Security classification can be attached to a dataset to describe the sensitivity of the dataset.

Like Entity type definitions, classification type definitions can have a base type that incorporates properties from the base type into the set of properties of the classification type definition.

####### Classification Hierarchies
Classification instances support arrangement in a hierarchy. This structure is useful, for example, when instances represent part of a taxonomy. It is important to remember, however, that this hierarchy is unrelated to the derivation hierarchy. Instances in a hierarchy of a classification need not adhere to the same hierarchy used to model the classification instances.

###### Relationship Type Definitions
Relationship Type Definitions describe the kinds of connections that can occur between *entity* and *classification* instances.

Relationship type definitions describe directed relationships between entity and classification instances of specific types. Entities and classifications can appear on either endpoint of a relationship type definition in any combination (e.g., entity to entity, entity to classification, classification to classification, and classification to entity). For instance, relationship type definitions may describe:
- a hierarchical file system with a relationship between parent and child folder entities
- a taxonomy built from classification instances
- a security classification between a dataset entity and a 'Sensitive' classification instance

Both entity and classification type definitions support the concept of a base type. Base types specified in the relationship type definition allow any type derived from that base to participate in the relationship.

##### Instances
Instances are used to capture the metadata of objects in the system. If we extend our object-oriented analogy from type definitions, classes are to type definitions as objects are to instances. For example, a dataSet type definition describes the properties and relationships for any dataset, but a dataset instance captures metadata for a specific dataset.

There are three kinds of instances:

###### Entities
Entities are records of specific objects that capture the metadata of that object. For instance, a dataset instance may specify a name of 'BASEBALL.sashdat' with row and column counts derived from a table in a particular library within the Viya system.

####### Uniqueness Constraints
Unlike type definitions, entity instance names do not have to be unique.

Entities have a `resourceId` field that is used to refer to the URI for the original object. If the type definition metaCategory is set to `PRIMARY`, the resourceId fields must be unique among instances of that type.

###### Classifications
Classifications serve as annotations that are typically referenced many times. While entities tend to refer to specific resources, classifications are used to add additional dimensions to the information captured by an entity. For instance, many datasets may be associated with a 'Sensitive' security classification.

####### Uniqueness Constraints
Classification instances can be arranged within a hierarchy by specifying a `parentID`. Names must be unique across classification instances with the same parent. If no parent is specified, names must be unique across all the classification instances without a parent.

###### Relationships
Relationships serve to identify connections between entities and classifications. For instance, our BASEBALL.sashdat table entity may have a relationship to the SASHELP library entity. The type of the relationship conveys the semantics of the connection (along with any attributes attached to the relationship).

##### Search
One of the primary use cases for the catalog service is discovering assets that are available for use. The catalog supports the traditional filter semantics that are common across SAS APIs; but these tend to require very precise knowledge about the assets of interest.

To fully support the discovery use case, the Catalog API also supports information retrieval techniques in the form of a search engine that allows retrieval of information using a query syntax that returns results based on relevance to one or more search criteria.

To enable search for different kinds of SAS assets, a *search index definition* for some assets has been added to the Catalog API. The index definition describes which entity and relationship definitions should be included in the search index, along with the properties to index.

When updates to the catalog are made (such as creating new instances, updating existing instances, or deleting instances), indices that reference the type of the instance (or instances) being manipulated are automatically updated.

##### Tags
Tags provide a way to attach user-provided labels to entities.

When tags are incorporated into search index definitions, users can use tags like a virtual bookmark and rapidly recall or share entities that have been tagged.

##### Views
When entities, classifications and relationships are combined, the result is a directed graph that captures the structure of information within the Catalog API. It is frequently useful to be able to query the graph in a way that returns the elements of the graph all once, rather than iteratively asking the Catalog API for more information. Selecting a set of related instances is performed thru a *View*, which conceptually serves as a saved query.

Views are expressed using a Graph query syntax:
- () describes an entity
- -[]-, -[]->, <-[]- describes relationships
- <> describes a classification.

Each of these can be given a named projection, that allows matching objects to be referenced later in the query.

Information is retrieved by matching graphs against the pattern described by the query and returning the parts that are interesting. For example, matching everything in the catalog uses the query

    match (x) return x

Property constraints can further reduce the set of results. For example, to return an entity with a specific ID use:

    match(x {id:7462f4c3-f225-42cf-bc3d-0fdfcf09b190})
    return x

Each of the elements can be further constrained with type information. For example, to return all of the `dataSet` instances use:

    match(x:dataSet) return x

or to return the dataSet and its dataFields use:

    match(x:dataSet)-[]->(y:dataField) return x,y

Type constraints can specify lists of types:

    (y:sasColumn|casColumn)<br> // either one
    (x)-[r:eq(role, "Associated)]->(y)<br> // Only association rels
    (x)-[r:in(role,"Associated","Composition")]->(y) // either role

Match clauses can reference projections that have been previously defined. For instance, to get a dataset, its columns, and the semantic classifications attached to the columns:

    match (t:dataSet {id:"..."})-[r:dataSetDataFields]-(c:dataField)
    match (c)-[sc:semanticClassifications]-><sc>
    return t,r,c,scr,sc

Relationships can include a path length expression:

    -[r*..2]-> // Up to two relationships away
    -[r*2..4]-> // between 2 and 4 relationships away

where the lower and upper bounds are expressed in the range following the asterisk. This approach is useful when views have to traverse multiple relationships.

##### Support for history
Entity instances can be configured to maintain old revisions according to a policy that is configured on either the entity or the entity's type definition. Before any changes are applied to the instance, a copy of the current state is written to the catalog service.

Entity instances and type definitions allow you to specify:
- a policy that controls how history records are retained
- a parameter that governs the policy
- a view that describes what content is maintained as part of the history

For instance, a policy of `depth` and a parameter of `10` means that at most 10 different revisions will be maintained within the catalog service. The view is used to determine which entities, relationships, and classifications are to be included within the history record.

The policy `none` indicates that no history is to be kept.

If no history configuration is set for an instance, the behavior is determined by the type definition. This also allows the configuration to be set on a base type of the type definition, which is then inherited by types derived from the base type.

##### Agents
Agents are used to introduce content into the catalog.

The Catalog API enables constructing, running, and monitoring agents. Agents write their results back to the catalog service using the same concepts and interfaces that are documented here.