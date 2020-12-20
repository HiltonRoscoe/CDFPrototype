# XSLT Processor Requirements

Many of the developed prototypes use [XSL Transformations (XSLT)](https://www.w3.org/TR/xslt-30/) as their foundation. However, not all XSLT processors are created equal. Some may only support a particular version of XSLT, or may not support Schema-awareness (SA). The following table lists each product and the XSLT features required.

| Product             | XSLT1 | XSLT2 | XSLT3 |
|---------------------|-------|-------|-------|
| CVR Prototype       | x     |       |       |
| JSON-to-XML         |       |       | x     |
| XML-to-JSON         |       |       | SA    |
| Streaming CVR       |       |       | x*    |
| Schematron Rulesets |       | SA    |       |

[*] Requires a processor with the [streaming feature](https://www.w3.org/TR/xslt-30/#streaming-feature), if streaming is desired

Efforts have been made to use new features only when necessary, to ensure compatibility with as many processors as possible.

| Available Processors | XSLT2 | XSLT3 | License     |
|----------------------|-------|-------|-------------|
| Saxon-PE             |       | x     | Open Source |
| Saxon-EE             |       | SA    | Commercial  |
| AltovaXML            | SA    |       | Gratis      |
