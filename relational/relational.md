# Common Data Formats and Data Modeling

<!-- TOC -->

- [Common Data Formats and Data Modeling](#common-data-formats-and-data-modeling)
    - [Use cases](#use-cases)
    - [Getting Started](#getting-started)
        - [DDL Support](#ddl-support)
            - [Oracle](#oracle)
            - [SQL Server](#sql-server)
        - [Additional Tasks](#additional-tasks)
            - [Data Type Length](#data-type-length)
            - [Subtype Engineering](#subtype-engineering)
    - [Technical Approach](#technical-approach)
    - [Mappings](#mappings)
        - [Multiplicities](#multiplicities)
        - [Directed associations](#directed-associations)
        - [Directed compositions](#directed-compositions)
        - [Attributes](#attributes)
            - [Primitives and Enumerations](#primitives-and-enumerations)
            - [Classes](#classes)
        - [Role Mapping](#role-mapping)
    - [Data Types](#data-types)

<!-- /TOC -->

## Use cases

The NIST Special Publication (SP) 1500 series common data formats were developed from a high level UML model ([more here](../mapping/mapping.md)). One advantage of this approach is that many implementation formats can be derived from it. NIST provides JSON and XML schemas, but other formats are possible.

Although NoSQL has picked up some traction, the vast majority of systems of record (e.g. Election Management System) continue to use the relational (SQL) model. In order to use the common data formats, a system must map not only the syntax of JSON or XML, but also the semantics, or meaning of the data. The difficulty of mapping can be eased somewhat if both the system of record and CDFs use the same conceptual definitions.

This prototype explores the use of the developed UML models to derive relational schemas.

## Getting Started

It is recommended to start with the pregenerated SQL DDL scripts. If the scripts do not serve your needs, you can edit the Entity-Relational (logical) or relational model directly using the freely available [Oracle Data Modeler](https://www.oracle.com/tools/downloads/sql-data-modeler-downloads.html) and generate new DDL.

The format specific files are located in `CVR/relational` and `ENR/v2/relational` directories of this repository, respectively.

### DDL Support

A DDL script has been provided for Oracle and SQL Server. You can also generate DB2 scripts from Oracle Data Modeler, but this has not been tested.

#### Oracle

- Generates names using underscore notation (not done yet?)

#### SQL Server

- Generates names using CamelCase notation

### Additional Tasks

#### Data Type Length

While ER does not require the length of the data type to be specified, a practical reality of relational databases is that length needs to be specified. All string types are mapped to the maximum length allowed by the database. However, you will likely want to adjust these to suit your needs. 

#### Subtype Engineering

The relational model has no concept of hierarchies. However, the concept can be simulated in a variety of ways, described below.

- Single Table, subtype hierarchies flattened into single table, type discriminate used to determine which attributes should be used.
- Table per child, Table includes all attributes of child and parent in single table
- Table per entity, maps 1-1 with UML model

The DDL provided as part of this repository uses the *table per entity* approach. However, if the ER model is adjusted to use a different method, and forward engineered to the relational model, the DDL can be regenerated.

## Technical Approach

The relational model was mechanically derived from the UML class diagram, using previously developed MDA tools. A script was constructed to translate the representations in UML to equivalent structures in Oracle's Entity-Relational model. The ER model was forward-engineered to the relational model, and finally DDL generated for each target database.

## Mappings

> Warning: This section assumes a fundamental knowledge of The Entity-Relational and UML Class Models.

The Unified Modeling Language (UML) and the Entity-Relational (ER) model are quite different. The following sections describe how the UML Classes and associations were mapped to equivalent structures in the ER model.

### Multiplicities

UML and ER uses language somewhat differently. Multiplicity in UML refers to how many instances of something may or must appear. In ER, two concepts are used, *cardinality* and *optionality*. Cardinality can be seen as representing the upper bound, i.e. `*` in the UML multiplicity `1..*`. Cardinality allows for descriptions of one (`1`) or many (`*`). A UML upper bound of `5`, would become a cardinality of `*`. To represent the lower bound, optionality can be set.

### Directed associations

Directed associations are mapped to relations. The source end (e.g. the end without an arrow) plays no part in the mapping. The target end is mapped to `1` if its multiplicity is `0..1` or `1`, otherwise it is mapped to `*`. The optionality for the source end is always optional, as the entity may be instantiated without the relationship (unlike directed compositions). The mandatory for the target is based on the lower cardinality > 0?

|End      |Cardinality|Optional  |
|---------|---------  |----------|
|Source   |*          |Yes       |
|Target   |`*` if upper multiplicity > 0 else `1` | Yes if lower multiplicity = 0 else No         |

### Directed compositions

Directed compositions behave like directed associations, except that their source end is never optional. This is because the composition is stating a part/whole relationship.

|End      |Cardinality|Optional  |
|---------|---------  |----------|
|Source   |1          |No        |
|Target   |`*` if upper multiplicity > 0 else `1` | Yes if lower multiplicity = 0 else No         |

### Attributes

UML attributes are mapped to ER attributes, except when the upper multiplicity is greater than 1 or the attribute represent a non-primitive type (i.e. a class). In that case they are mapped to their own entity. This is done to preserve First Normal Form (1NF).

#### Primitives and Enumerations
[ DOUBLE CHECK SECTION ]
UML attributes whose classifier is a class are given their own entity. This entity takes the name of the parent class. So if `CastVoteRecordReport` contains an attribute of type `ReportType`, the generated entity will be named `CastVoteRecordReportType`.

[should be identifying? They aren't now]

|End      |Cardinality|Optional  |
|---------|---------  |----------|
|Source   |1          |No        |
|Target   |`*` if upper multiplicity > 0 else `1` | Yes if lower multiplicity = 0 else No         |

#### Classes

UML attributes whose classifier is a class are given their own entity. This entity takes the name of the parent class. So if `GpUnit` contains an attribute of type `Code`, the generated class will be named `GpUnit_Code`

|End      |Cardinality|Optional  |
|---------|---------  |----------|
|Source   |*          |Yes        |
|Target   |`*` if upper multiplicity > 0 else `1` | Yes if lower multiplicity = 0 else No         |

### Role Mapping

Role mapping `fkRole` is handled as follows:

|Multiplicity  |FK owner         |FK Name   |
|---------     |-----------------|---------|
|0..1          |source           |         |
|0..*          |target           |         |
|Row3          |                 |         |

Must add handling for many to many manually

## Data Types

Data types in the UML model are mapped to equivalent types in the ER model. ER data types can be either `Logical` data types or `Domain` data types. Logical data types map directly to the physical type used by the database. Domain data types can be seen a subtypes of logical types, allowing them to be further constrained. For example, enumerations in the UML model are represented as domain types of the same name.
