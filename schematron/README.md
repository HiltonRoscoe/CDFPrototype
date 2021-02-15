# Schematron Rulesets

This document contains instructions to run the schematron rulesets for the Cast Voter Records and Election Results Reporting specifications.

<!-- TOC -->

- [Schematron Rulesets](#schematron-rulesets)
    - [How to run (AltovaXML)](#how-to-run-altovaxml)
        - [Expected Output](#expected-output)
            - [Message Version](#message-version)
            - [SVRL Version](#svrl-version)
    - [How to Run (Oxygen XML)](#how-to-run-oxygen-xml)
    - [Other Notes](#other-notes)

<!-- /TOC -->

There are multiple ways to run the Schematron rulesets. The compiled Schematron rulesets can be run with any schema-aware `XSLT2` processor. Additionally the schematron rulesets can be run directly in a tool like `Oxygen`. The Schematron files are located in `CVR/sch` and `ENR/v2/sch` directories of this repository, respectively.

## How to run (AltovaXML)

AltovaXML is a freely availible, command line based tool. AltovaXML can run a schematron ruleset that has been compiled into an `xslt`, e.g. `err_v2-compiled.xsl`. Precompiled rulesets have been provided as part of this repository. AltovaXML is available on Windows only.

There are two versions of the compiled schematron files for each CDF. The difference is in how the validation results are provided. Those ending with `_message` generate messages to the standard output (e.g. screen). Those ending with `_svrl` generate results as XML using the SVRL format.

> It is recommended to use the SVRL versions of the compiled schematron files. The SVRL versions provide not only the error messages, but contextual details around where the error occurred.

- [Download](http://cdn.sw.altova.com/v2013r2/en/AltovaXMLCmu2013.exe) and install AltovaXML.

> AltovaXML must be in your path or fully qualified. The default installation path for x64 based computers is `C:\Program Files (x86)\Altova\AltovaXML2013`

- (Optional) Change the `xslt` file to point to the fully qualified path of the NIST 1500-xxx schema. AltovaXML does not understand relative file system paths.

```xml
<xsl:import-schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                    namespace="http://itl.nist.gov/ns/voting/1500-100/v2"
                    schema-location="file:///{path}"/>
```

> The compiled schematron files reference the `xsd`s found on the NIST GitHub repository. Therefore, this step is optional, however, if the url of the files change or network connectivity is restricted, the transforms will not run correctly.

- Ensure `xsi:schemaLocation` is specified in the instance file. Failure to do so may cause false negatives.

- Run the command having the form of:

```cmd
{AltovaXML} /xslt2 {compiled.xsl} /in {input_file.xml} [/out {output_file.xml}]
```

Where `{AltovaXML}` is the path to the `AltovaXML.exe` executable, `{compiled.xsl}` is the path to the compiled schematron ruleset, and `{input_file.xml}` is the path to the XML instance to validate. If you are using the SVRL version, set the `/out` flag and `{output_file.xml}` to the path you'd like for the validation report.

```cmd
PS C:\Program Files (x86)\Altova\AltovaXML2013> .\AltovaXML.exe /xslt2 C:\GitHub\CDFPrototype
\ENR\v2\sch\err_v2-compiled.xsl /in C:\GitHub\CDFPrototype\ENR\v2\sch\validation_target.xml
```

### Expected Output

> [!IMPORTANT]
> Make sure the file has been validated against the XML Schema prior to running the schematron rules. Failure to do so may result in false negatives.

#### Message Version

If the instance file contains no errors, the command will produce no output.

If the file contains errors, messages such as the one below will appear.

```message
XSL message: PartyId (_PE2399537F-B641-E811-8104-0050568C2FC0) must point to an element of type Party
```

Each error is prefixed with `XSL message` and contains the `ObjectId` context indicating where the error occurred.

#### SVRL Version

Output will be directed to the file specified as {output_file.xml}, using the SVRL standard.

## How to Run (Oxygen XML)

The commercial XML editor [Oxygen](https://www.oxygenxml.com/download.html) can validate using schematron rulesets directly. Make sure schema-aware validation is enabled and Saxon-EE is used for validation.

![Schema aware option](./images/schema-aware.png)

The below video shows how to validate a XML instance using the `sch` ruleset.

![Video instructions](./images/oxygen-sch.gif)

> These instructions were tested on Windows 10.0.17134.648 (x64) using Oxygen 21.0

## Other Notes

*Message* XSLT versions of Schematron files were generated using the default transformer provided by Oxygen. SVRL versions were generated using the [ISO Schematron Skeleton](https://github.com/Schematron/schematron).