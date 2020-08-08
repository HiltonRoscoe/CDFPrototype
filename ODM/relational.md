# Common Data Formats and Data Modeling

<!-- TOC -->

- [Common Data Formats and Data Modeling](#common-data-formats-and-data-modeling)
    - [Use cases](#use-cases)
    - [Mappings](#mappings)
        - [Directed associations](#directed-associations)
        - [Directed compositions](#directed-compositions)
        - [Attributes](#attributes)
            - [Primitives and Enumerations](#primitives-and-enumerations)
            - [Classes](#classes)
        - [Role Mapping](#role-mapping)
    - [Data Types](#data-types)
    - [DDL Support](#ddl-support)
        - [Oracle](#oracle)
        - [SQL Server](#sql-server)
    - [Additional Tasks](#additional-tasks)
        - [Data Type Length](#data-type-length)
        - [Subtype Engineering](#subtype-engineering)

<!-- /TOC -->

## Use cases

## Mappings

> Warning: This section is not for the faint of heart!

The Unified Modeling Language (UML) and the Entity-Relational (ER) model are quite different. The following sections describe how the UML Classes and associations were mapped to equivalent structures in the ER model.

UML and ER uses language somewhat differently. Multiplicity in UML refers to how many instances may or must be associated. In ER, two concepts are used, *cardinality* and *optionality*. Cardinality can be seen as representing the upper bound, i.e. `*` in the multiplicity `1..*`. Cardinality allows for descriptions of one (`1`) or many (`*`). A UML upper bound of `5`, would become a cardinality of `*`. To represent the lower bound, optionality can be set.

### Directed associations

Directed associations are mapped to relations. The source end plays no part in the mapping. The target end is mapped to `1` if its multiplicity is `0..1` or `1`, otherwise it is mapped to `*`. The mandatory for the source end is always optional, as the entity may be instantiated without the relationship (unlike directed compositions). The mandatory for the target is based on the lower cardinality > 0?

|End      |Cardinality|Optional  |
|---------|---------  |----------|
|Source   |*          |Yes       |
|Target   |`*` if upper multiplicity > 0 else `1` | Yes if lower multiplicity = 0 else No         |

### Directed compositions

Directed compositions behave like directed associations, except that their Source End is never optional. This is because the composition is stating a part/whole relationship.

|End      |Cardinality|Optional  |
|---------|---------  |----------|
|Source   |1          |No        |
|Target   |`*` if upper multiplicity > 0 else `1` | Yes if lower multiplicity = 0 else No         |

### Attributes

UML attributes are mapped to ER attributes, except when the upper multiplicity is greater than 1 or the attribute represent a non-primitive type (i.e. a class). In that case they are mapped to their own entity. This is done to preserve first normal form.

#### Primitives and Enumerations

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

## DDL Support

A DDL script has been provided for Oracle and SQL Server. You can also generate DB2 scripts from Oracle Data Modeler, but this has not been tested.

### Oracle

- Generates names using underscore notation (not done yet?)

### SQL Server

- Generates names using CamelCase notation

## Additional Tasks

### Data Type Length

While ER does not require the length of the data type to be specified, a practical reality of relational databases is that length needs to be specified. All string types are mapped to the maximum length allowed by the database. However, you will likely want to 

### Subtype Engineering

