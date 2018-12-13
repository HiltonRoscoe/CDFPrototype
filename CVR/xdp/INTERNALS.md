# CVR Prototype Internals

This document describes the internals of the CVR prototype.

<!-- TOC -->

- [CVR Prototype Internals](#cvr-prototype-internals)
    - [Basics](#basics)
    - [Components](#components)
    - [Operation](#operation)
    - [Customizing Layout](#customizing-layout)
        - [Customizing Contests](#customizing-contests)
        - [Customizing Contest Options](#customizing-contest-options)

<!-- /TOC -->

## Basics

This prototype is based on XML Forms Architecture, providing a Interactive Sample Ballot interface with the following capabilities:

- Dynamic ballot rendering based on an EML 410 data source
- Digital signature support
- Offline ballot marking
- Screen reader support
- Overvote protection
- Conversion from EML 410 to NIST CVR CDF
- Control of contest column and page breaks

Support for the following contest options:

- Candidate Option
- Ballot Measure Option
- Write-In Option

Support for the following contest types:

- Candidate Contest
- Ballot Measure Contest

## Components

The prototype is made up of three major components

- The ballot template
- EML 410 instance data
- XSL Transformation from EML to CVR CDF

Each of these components are stored separately on the project repository. However, when packaged as a PDF, all components are combined together to produce a standalone file.

## Operation

When the PDF is loaded, the following occurs:

1. The Template DOM is loaded.
2. The XML Data DOM (i.e. input data) is loaded.
3. Data binding occurs between the template DOM and XML Data DOM, generating the Form DOM.

- When the user marks the ballot, the Form DOM is updated.
- When the user exports data, the XML Data DOM (EML) is updated, and transforms the EML to CVR via XSL.

## Customizing Layout

The default stylesheet included with the ballot template can be overridden, with exceptions. See the [EML 410 Extensions document](./EML-410_extensions.md#styling-support)

### Customizing Contests

Contests are given a default template consisting of:

1. Vote for not more than `{MaxVotes}`
2. Undervote helper, indicating how many remaining selections the voter has.

This template can be overwritten with custom instructions, whenever there is a `HowToVote` element under `Contest`.

```xml
<HowToVote>
    <Message>(To vote for Governor and Lieutenant Governor, darken the oval at the left of the joint candidates of your choice)
    </Message>
</HowToVote>
```

> All ballot measures with `MeasureText` are expected to custom `HowToVote` instructions.

### Customizing Contest Options

- Candidates with `Affiliation/AffiliationIdentifier/RegisteredName` will always appear with their affiliation under their name.