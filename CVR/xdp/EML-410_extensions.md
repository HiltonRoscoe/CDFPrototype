# Extensions to EML 410

This document describes extensions to EML 410 to support the CVR prototype.

## Write-In Support

A Write-In contest option will emitted for each occurrence of `WriteInCandidate` under
`BallotChoices`.

```xml
<BallotChoices>
    ...
    <WriteInCandidate>
        <Name/>
    </WriteInCandidate>
</BallotChoices>
```

## Styling Support

If desired, certain content may override the default style sheet of the form. This "Rich Text" functionality is accomplished by emitting a `XHTML` fragment, with CSS instructions as required. The XHTML fragments comply with the XFA 3.3 "Rich Text Reference" and support all of the features described therein. Rich Text is permitted in the following locations (all under `Contest`):

- BallotChoices/Candidate/CandidateFullName/NameElement
- ContestIdentifier/ContestName
- Messages/Message

## Column / Page Breaking

Column and page breaking can be restricted such that parts or all of a contest must appear on a single column or page. These directives appear under a `Contest` or `MeasureText`, and are of the form:

```xml
<KeepIntact Target="{subform}">{scope}</KeepIntact>
```

Where `{subform}` is the target of the keep intact directive, and {scope} is one of the following:

|Option     |Description           |
|-----------|----------------------|
|none       |No directive          |
|contentArea|May not break a column|
|pageArea   |May not break a page  |
