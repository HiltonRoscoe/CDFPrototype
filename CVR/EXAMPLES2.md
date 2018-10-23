## Anatomy of a CVR

This specification permits a wide range of data to be stored in a CVR, ranging from minimal information about the voted contests and contest selections to expanded information about all contests on the ballot as well as other items. This section explains the construction of a minimal 1500-103 instance, containing only the voted contests and candidates that were selected by the voter. It contains two CVRs, each indicating a selection for a candidate in the contest. Each CVR also references an image of the corresponding scanned ballot.

> A 1500-103 instance (i.e. XML or JSON) may contain one or more `CVRs`, which in turn must contain one or more `CVRSnapshots`, each representing a CVR at specific point in time.

The file is divided roughly into two parts: the CVR elements at the beginning followed by other elements for defining the contests, candidates, and contest selections so that the CVR elements can link to them as necessary. [Lines 188-227](https://github.com/HiltonRoscoe/CDFPrototype/blob/902f72bdc1399f9b6a8164ac85e75be0d14d4588/CVR/xml/example_2.xml#L188-L227) contain the contest, candidate, and contest selection definitions.

 The CVR elements link to these items by using identifiers defined in the contest, candidate, and contest selection's `ObjectId` attributes. For example, the contest definition [starting on line 211](https://github.com/HiltonRoscoe/CDFPrototype/blob/902f72bdc1399f9b6a8164ac85e75be0d14d4588/CVR/xml/example_2.xml#L211-L225) contains:

```xml
<Contest ObjectId="_C1" xsi:type="CandidateContest">
```
so that CVR elements can link to this contest definition by using the `ObjectId` `_C1`.  

> Note that the object identifiers are not the same as the external identifiers that a jurisdiction may use to identify contests or candidates. The object identifiers are entirely unique to a CVR report; the exporting application must add them as it builds the report file. These identifiers are used only as a means for linking contest, contest selections, etc., together within the report file.

[Lines 3-44](https://github.com/HiltonRoscoe/CDFPrototype/blob/902f72bdc1399f9b6a8164ac85e75be0d14d4588/CVR/xml/example_2.xml#L3-L44) contain the CVR elements. Each `CVR` element includes at least one `CVRSnapshot`.

> Each `CVRSnapshot` represents a CVR at a particular point in time, such as the `original` originally scanned, after it has been `interpreted` (i.e. business rules have been applied), or otherwise `modified`.

`CVRSnapshot` element includes one or more `CVRContest`, which links to the voted contest whose object identifier is `_C1`, thereby uniquely identifying that contest within the report file. It then includes `CVRContestSelection`, which links to a contest option that was selected by the voter.  Each `CVR` element also includes an optional sequence number; this isn’t required but could be helpful to auditors.

[Lines 233-235](https://github.com/HiltonRoscoe/CDFPrototype/blob/902f72bdc1399f9b6a8164ac85e75be0d14d4588/CVR/xml/example_2.xml#L233-L235) contain a definition for the device that generated the CVRs. This indicates that a device located at a precinct whose serial number is "1038495" generated the collection of CVRs.

Lastly, [Lines 4-6](https://github.com/HiltonRoscoe/CDFPrototype/blob/902f72bdc1399f9b6a8164ac85e75be0d14d4588/CVR/xml/example_2.xml#L4-L6) and [Lines 25-27](https://github.com/HiltonRoscoe/CDFPrototype/blob/902f72bdc1399f9b6a8164ac85e75be0d14d4588/CVR/xml/example_2.xml#L25-L27) contain optional information about an image per ballot saved by the scanner. For example, the image of the ballot corresponding to the first CVR is filename “CVR1_Ballot.jpg” and the image type is JPEG.