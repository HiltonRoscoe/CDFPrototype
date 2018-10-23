## Anatomy of a CVR

This specification permits a wide range of data to be stored in a CVR, ranging from minimal information about the voted contests and contest selections to expanded information about all contests on the ballot as well as other items. This section shows a minimal 1500-103 instance, containing only the voted contests and candidates that were selected by the voter. It contains two CVRs, each indicating a selection for a candidate in the contest. Each CVR also references an image of the corresponding scanned ballot.

> A 1500-103 instance (i.e. XML or JSON) may contain one or more `CVRs`, which in turn must contain one or more `CVRSnapshots`, each representing a CVR at specific point in time.

The file is divided roughly into two parts: the CVR elements at the beginning followed by other elements for defining the contests, candidates, and contest selections so that the CVR elements can link to them as necessary. Lines (CORRECT LINE NUMBERS) contain the contest, candidate, and contest selection definitions.

https://github.com/HiltonRoscoe/CDFPrototype/blob/902f72bdc1399f9b6a8164ac85e75be0d14d4588/CVR/xml/example_2.xml#L188-L227

 The CVR elements link to these items by using identifiers defined in the contest, candidate, and contest selection's `ObjectId` attributes. For example, the contest definition starting on line (CORRECT) contains:

```xml
<Contest ObjectId="_C1" xsi:type="CandidateContest">
```
so that CVR elements can link to this contest definition by using the `ObjectId` `_C1`.  

> Note that the object identifiers are not the same as the external identifiers that a jurisdiction may use to identify contests or candidates. The object identifiers are entirely unique to a CVR report; the exporting application must add them as it builds the report file. These identifiers are used only as a means for linking contest, contest selections, etc., together within the report file.

Lines (CORRECT LINE NUMBERS) contain the CVR elements. Each `CVR` element includes at least one `CVRSnapshot`. If only a single `CVRSnapshot` is provided, it should represent the `original` CVR from the scanning device.
`CVRSnapshot` element may include one or more `CVRContests`, which links to the voted contest whose object identifier is `_C1`, thereby uniquely identifying that contest within the report file. It then includes `CVRContestSelection`, which links to a contest option that was selected by the voter.  Each `CVR` element also includes an optional sequence number; this isn’t required but could be helpful to auditors.

Lines (CORRECT LINE NUMBERS) contain a definition for the device that generated the CVRs. This indicates that a device located at a precinct whose serial number is "1038495" generated the collection of CVRs.

Lastly, (LINE NUMBERS) and (LINE NUMBERS) contain optional information about an image per ballot saved by the scanner. For example, the image of the ballot corresponding to the first CVR is filename “CVR1_Ballot.jpg” and the image type is JPEG. 

```xml
<CastVoteRecordReport>
  <CVR>
    <BallotImage>
      <Image FileName="CVR1_Ballot.jpg" MimeType="image/jpeg"></Image>
    </BallotImage>
    <CVRContest>
      <ContestId>_C1</ContestId>
      <CVRContestSelection>
        <ContestSelectionId>_C1CS1</ContestSelectionId>
      </CVRContestSelection>
    </CVRContest>
    <SequenceNumber>1</SequenceNumber>
  </CVR>
  <CVR>
    <BallotImage>
      <Image FileName="CVR2_Ballot.jpg" MimeType="image/jpeg"></Image>
    </BallotImage>
    <CVRContest>
      <ContestId>_C1</ContestId>
      <CVRContestSelection>
        <ContestSelectionId>_C1CS2</ContestSelectionId>
      </CVRContestSelection>
    </CVRContest>
    <SequenceNumber>2</SequenceNumber>
  </CVR>
  <Election ObjectId="_EL7">
    <Candidate ObjectId="_C1CN1">
      <Code><Type>local-level</Type><Value>_C1CN1</Value></Code>
    </Candidate>
    <Candidate ObjectId="_C1CN3">
      <Code><Type>local-level</Type><Value>_C1CN3</Value></Code>
    </Candidate>
    <Code><Type>local-level</Type><Value>EL7</Value></Code>
    <Contest ObjectId="_C1" xsi:type="CandidateContest">
      <Code><Type>local-level</Type><Value>C1</Value></Code>
      <ContestSelection ObjectId="_C1CS1" xsi:type="CandidateSelection">
        <CandidateIds>_C1CN1</CandidateIds>
      </ContestSelection>
      <ContestSelection ObjectId="_C1CS2" xsi:type="CandidateSelection">
        <CandidateIds>_C1CN3</CandidateIds>
      </ContestSelection>
    </Contest>
  </Election>
  <GeneratedDate>2018-05-15T17:32:52</GeneratedDate>
  <GpUnit ObjectId="_GP1" xsi:type="ReportingDevice">
    <Type>precinct</Type><SerialNumber>1038495</SerialNumber>
  </GpUnit>
  <ReportGeneratingDeviceIds>_GP1</ReportGeneratingDeviceIds>
  <Version>1.0</Version>
</CastVoteRecordReport
```