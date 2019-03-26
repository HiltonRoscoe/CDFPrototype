# RCV Test Deck Generation

This document describes the conversion of tabular test decks into NIST CVR CDF XML Instances.

## Prerequisites

This approach requires:

- Microsoft Excel (2010+)
- An XSLT engine (Altova, Saxon, etc.)
- domain_conversion (for XML->JSON)

## Instructions

- Open tabular RCV in Excel
- Create XML Map based on `testdeck.xsd`
- Map each column
- Export spreadsheet as `XML Data`
- Run `testdeck.xsl` against `XML Data` file
- (Optional) run `domain_conversion` to generate JSON instance