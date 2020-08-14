# Converting between physical formats
<!-- TOC -->

- [Converting between physical formats](#converting-between-physical-formats)
    - [Running the Tools](#running-the-tools)
        - [XML-to-JSON](#xml-to-json)
        - [JSON-to-XML](#json-to-xml)
    - [Technical Details](#technical-details)
        - [XML-to-JSON Transform](#xml-to-json-transform)
        - [JSON-to-XML Transform](#json-to-xml-transform)

<!-- /TOC -->

The first Common Data Format released by NIST, Election Results Reporting (1500-100) supported XML exclusively. Since its release, interest in JavaScript Object Notation (JSON) versions of the Common Data Formats has grown. All new Common Data Formats going forward will include a representation in JSON Schema and XML Schema (XSD). This solves one problem, i.e. supporting popular data formats, but introduces another: while the JSON and XML versions of the CDFs represent the same data points, they do not share the same syntax.

Some implementers may only produce data in XML, and others may only consume in JSON, or vice versa, leading to interoperability failures. In order for interoperability to be maintained vendors must support consuming, if not producing, data in both serializations of the common data formats.

The developed tooling, described here, allows a vendor to convert between XML and JSON without writing their own translation layers. They have been validated against NIST 1500-100 v2 (ERR) and NIST 1500-102 (CVR).

## Running the Tools

The tools are eXtensible Stylesheet Language Transformations (XSLT). Because they use features of XSLT 3.0 [[W3C-xslt-3]](http://www.w3.org/TR/xslt-30/), an XSLT 3.0 processor is required. Additionally, the XML-to-JSON conversion uses features that require a schema-aware processor. The stylesheets have been tested with the following processors:

- [Altova XMLSpy 2018 sp1](https://www.altova.com/xmlspy-xml-editor)
- Saxon-EE 9.8.0.12 (via [OxygenXML](https://www.oxygenxml.com/download.html))

The XSLT file to use depends on your use-case:

|File               |Description                                         |
|-------------------|----------------------------------------------------|
|cvr_v1_xml2json.xsl|Converts Cast Vote Records XML to JSON              |
|cvr_v1_json2xml.xsl|Converts Cast Vote Records JSON to XML              |
|err_v2_xml2json.xsl|Converts Election Results Reporting (v2) XML to JSON|
|err_v2_json2xml.xsl|Converts Election Results Reporting (v2) JSON to XML|

> The XSLT files are available in this repository under [CVR/xsl](https://github.com/HiltonRoscoe/CDFPrototype/blob/master/CVR/xsl), and [ENR/v2/xsl](https://github.com/HiltonRoscoe/CDFPrototype/blob/master/ENR/v2/xsl)

The general approach is as follows:

1. Open the XML tool
2. Open the XSL transformation file
3. Assign the input file (i.e. the CDF instance) as the transformation input
4. Run the XSL transformation
5. (optional) Validate the transformation result against the XML or JSON schema

See the sections below for notes specific to the transformation you are preforming.

### XML-to-JSON

The XML-to-JSON conversion tool requires the use of a schema-aware validator. When using Altova XMLSpy, no additional configuration is required. However, when using Oxygen, you must be sure to set the transformer to Saxon-EE and set schema validation (`-val`) to *lax* or better.

### JSON-to-XML

Because XSLT works by matching XML tags, it cannot take JSON as input directly. This means that we must wrap the JSON we want to transform in an XML tag, as seen below.

```xml
<root xmlns="http://www.w3.org/2005/xpath-functions">
{
    ...
}
</root>
```

## Technical Details

The approach described here takes advantage of new features available in eXtensible Stylesheet Language Transformations version 3.0 [[W3C-xslt-3]](http://www.w3.org/TR/xslt-30/). `XSLT3` has introduced support for JSON, including the capabilities to convert between JSON and XML.

Because the syntax of XML and JSON aren't equivalent, and JSON has some structures that XML doesn't (namely `maps`), an [XML vocabulary](https://www.w3.org/TR/xslt-30/#schema-for-json) was developed to describe JSON.

### XML-to-JSON Transform

The approach for XML-to-JSON conversion is to use a schema-aware XSL transformation that takes a CDF instance as an input. This XSLT has a separate template for each `complexType` in the schema, which generates tags in the [XML vocabulary](https://www.w3.org/TR/xslt-30/#schema-for-json) to produce the required JSON output. The `xml-to-json` function is called to convert the data from the intersticial format to its canonical JSON representation.

This code is largely unexceptional, except in a couple cases. For `complexTypes` that have a `base` type, the base type's template must be called explicitly. Additionally, care is taken to ensure that the `@type` key is set to the derived type, not its parent, which is achieved thru the use of the `set_type` parameter in the XSLT templates.

There are a couple other nuances to consider. One is that repeating UML attributes are represented in XML as repeating tags. In JSON, keys cannot repeat. Instead, a key is created with an array containing 0 or more values. Also, associations with an upper cardinality > 1 are represented in XML as `xs:IDREFS`. `xs:IDREFS` are space delimited lists. In JSON, they are represented as an array.

> Read the [Mapping Common Data Formats](https://github.com/HiltonRoscoe/CDFPrototype/blob/master/mapping.md) guide for more details on this.

### JSON-to-XML Transform

Converting JSON-to-XML is a fair bit more difficult than the converse. This is because of design decisions made by the developers of the CDFs, for example, that XML tags must appear in a particular order (`xsd:sequence`), while JSON keys are unordered. The second is that XML has two structures where data can be placed, in `attributes` or `elements`. The JSON to XML conversion is simpler in one area. The data type for a given `object` (`map`) is unambiguous through the use of the `@type` key. Because JSON does not use XML Schema, the JSON to XML conversion XSLT is not schema-aware and does not require a schema-aware processor.
