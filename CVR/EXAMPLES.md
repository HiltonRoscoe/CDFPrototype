# Cast Vote Record (CVR) Examples

<!-- TOC -->

- [Cast Vote Record (CVR) Examples](#cast-vote-record-cvr-examples)
    - [Assumptions](#assumptions)
    - [Anatomy of a CVR](#anatomy-of-a-cvr)
    - [Basic Example](#basic-example)
    - [SelectionPosition](#selectionposition)
        - [Position and Rank](#position-and-rank)
        - [Indications](#indications)
        - [Voter Made `Marks` (Paper Only)](#voter-made-marks-paper-only)
            - [Mark Metrics](#mark-metrics)
        - [Adjudication](#adjudication)
        - [Meaning of `IsAllocable`](#meaning-of-isallocable)
        - [Machine Generated Indications](#machine-generated-indications)
    - [Handling Overvotes](#handling-overvotes)
    - [Write-Ins](#write-ins)
        - [Basic Write-In](#basic-write-in)
            - [Explanation](#explanation)
        - [Write-In Counter](#write-in-counter)
        - [Adjudication of Write-Ins](#adjudication-of-write-ins)
    - [CVR Snapshots](#cvr-snapshots)
        - [Current CVR](#current-cvr)
    - [Secondary Information](#secondary-information)
        - [Ballot Images](#ballot-images)
            - [Storing a reference](#storing-a-reference)
            - [Storing Image Data](#storing-image-data)
    - [Voting Method Support](#voting-method-support)
        - [Rank Choice Voting](#rank-choice-voting)
        - [Cumulative Voting](#cumulative-voting)

<!-- /TOC -->

These examples show how to use the NIST CVR Common Data Format (1500-103 CDF) to represent various voting scenarios.

## Assumptions

- This document uses the ballot semantics model built by the Election Modeling Working Group.
- Readers of this document are expected to have a working understanding of XML.

## Anatomy of a CVR

> This section uses [Example 2](xml/example_2.xml)

The CVR specification permits a wide range of data to be stored in a CVR, ranging from minimal information about the selected contests and contest options to expanded information about all contests on the ballot as well as other items. This section explains the construction of a minimal 1500-103 instance, containing only the contests and candidates that were selected by the voter. It contains two CVRs, each indicating a selection for a candidate in a contest. Each CVR also references an image of the corresponding scanned ballot.

> A 1500-103 instance (in XML or JSON) may contain one or more `CVRs`, which in turn must contain one or more `CVRSnapshots`, each representing a CVR at specific point in time.

The file is divided roughly into two parts: the CVR elements at the beginning followed by other elements for defining the election and its contests, candidates, and contest selections so that the CVR elements can link to them as necessary. [Lines 205-244](https://github.com/HiltonRoscoe/CDFPrototype/blob/7ed877d24eb73510a22e87ffd987038f58c4035f/CVR/xml/example_2.xml#L205-L244) describe an election containing the contest, candidate, and contest selection definitions.

 The CVR elements link to these items by using identifiers defined in the contest, candidate, and contest selection's `ObjectId` attributes. For example, the contest definition [starting on line 228](https://github.com/HiltonRoscoe/CDFPrototype/blob/7ed877d24eb73510a22e87ffd987038f58c4035f/CVR/xml/example_2.xml#L228-L242) contains:

```xml
<Contest ObjectId="_C1" xsi:type="CandidateContest">
```

so that CVR elements can link to this contest definition by using the `ObjectId` `_C1`.  

> Note that the object identifiers are not the same as the codes that a jurisdiction may use to identify contests or candidates. The object identifiers are entirely unique to a CVR report; the exporting application must add them as it builds the report file. These identifiers are used only as a means for linking contest, contest selections, etc., together within the report file.

[Lines 3-204](https://github.com/HiltonRoscoe/CDFPrototype/blob/7ed877d24eb73510a22e87ffd987038f58c4035f/CVR/xml/example_2.xml#L3-L204) contain the CVR elements. Each `CVR` element includes at least one `CVRSnapshot`.

> Each `CVRSnapshot` represents a particular `Type`, such as the `original` captured from a scanner, or after it has been `interpreted` (i.e. business rules have been applied), or otherwise `modified`.

`CVRSnapshot` element includes one or more `CVRContest`, which links to the voted contest whose object identifier is `_C1`, thereby identifying that contest within the report file. It then includes `CVRContestSelection`, which links to a contest option that was selected by the voter.  Each `CVR` element also includes an optional sequence number (`SequenceNumber`); this isn’t required but could be helpful to auditors.

## Basic Example

> This section uses [Example 1](xml/example_1.xml)

Consider the following contest:

**For Treasurer of State**

- [x] Connie Pillich
- [ ] Josh Mandel

can be represented with the following XML fragment:

```xml
<cdf:CVRContest>
    <cdf:ContestId>_5TS</cdf:ContestId>
        <cdf:CVRContestSelection>
            <cdf:ContestSelectionId>_1ECP</cdf:ContestSelectionId>
            <cdf:Position>1</cdf:Position>
            <cdf:SelectionPosition>
                <cdf:HasIndication>yes</cdf:HasIndication>
                <cdf:IsAllocable>yes</cdf:IsAllocable>
                <cdf:NumberVotes>1</cdf:NumberVotes>
            </cdf:SelectionPosition>
            <cdf:TotalNumberVotes>1</cdf:TotalNumberVotes>
        </cdf:CVRContestSelection>
        <cdf:Position>1</cdf:Position>
        <cdf:TotalNumberVotes>1</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    ...
</cdf:CVRContest>
```

The `ContestSelectionId` value of `_1ECP` represents the reference to the selected *contest option*:

```xml
<cdf:Candidate ObjectId="_1ECP">
    ...
    <cdf:Name>Connie Pillich</cdf:Name>
    ...
</cdf:Candidate>
```

By dereferencing `_5TS`, we can see this does indeed represent a contest selection of **Connie Pillich** for **Treasurer of State**.

```xml
<cdf:Contest xsi:type="cdf:CandidateContest" ObjectId="_5TS">
    ...
    <cdf:Name>For Treasurer of State</cdf:Name>
    <cdf:VoteVariation>n-of-m</cdf:VoteVariation>
    <cdf:VotesAllowed>1</cdf:VotesAllowed>
</cdf:Contest>
```

> Note that an object identifier (`ObjectId`) is not the same as the codes that a jurisdiction may use to identify contests or candidates. An object identifier is entirely unique to a CVR report; the exporting application must add them as it builds the report file. These identifiers should only be used to link contests, contest selections, etc., together within the report file.

## SelectionPosition

`SelectionPosition` is used to state facts about an area on the ballot where a voter's selection in a particular contest can be indicated. This may include its position on the ballot, the number of votes represented by its selection, evidentiary information regarding the existence of a `Mark` and determinations, among others.

### Position and Rank

`SelectionPosition`, taken with `CVRContestSelection` identifies the location on the ballot where a selection can be made.

Consider the following contest:

**Member of County Council at Large**

|Contest Option|1st  |2nd  |3rd  |
|--------------|-----|-----|-----|
|Ilene Shapiro |`[x]`|`[ ]`|`[ ]`|
|Debbie Walsh  |`[ ]`|`[ ]`|`[x]`|
|Sandra Kurt   |`[ ]`|`[X]`|`[ ]`|

The selection of Sandra Kurt's contest option corresponds to the following XML fragment:

```xml
<cdf:CVRContestSelection>
    <cdf:ContestSelectionId>_1HSK</cdf:ContestSelectionId>
    <cdf:Position>3</cdf:Position>
    <cdf:SelectionPosition>
        <cdf:HasIndication>yes</cdf:HasIndication>
        <cdf:IsAllocable>yes</cdf:IsAllocable>
        <cdf:NumberVotes>1</cdf:NumberVotes>
        <cdf:Position>2</cdf:Position>
    </cdf:SelectionPosition>
    <cdf:TotalNumberVotes>1</cdf:TotalNumberVotes>
</cdf:CVRContestSelection>
```

Sandra Kurt (`_1HSK`) position on the ballot is third (row), and the indicated contest position is second (column). This is represented by setting `CVRContestSelection/Position` to `3` and `SelectionPosition/Position` to `2`.

### Indications

`SelectionPosition` can be used to convey the selections that are potentially allocable to a *contest option*. Selections are identified via *selection indications*. Indications can come from the following sources:

- A `Mark` made by the voter on a paper ballot
- A `Mark` made by a marking device onto a full face paper ballot
- An indication made by the voter using a DRE
- An indication made by machine as a result applying business rules
- An indication made by an adjudicator

> `HasIndication` should be determined based on facts about the indication/`Mark` *alone*. This means, for example, that `HasIndication` should be set to `yes`, even if its underlying selection is invalided due to contest rules.

### Voter Made `Marks` (Paper Only)

`SelectionPosition` has a subelement, `Mark`, which should be used whenever a mark is placed upon a *contest option position* of a full face paper ballot.

A `Mark` provides evidence that an indication may exist, however, it does not confirm it. This is the purpose of `HasIndication`. It can tell us if the mark met the threshold or logic of a `MarkMetricType` to be considered a selection indication for the *contest option* (machine interpretation), or if adjudication resulted in the capture of a selection (human interpretation).

| Mark type                        | HasIndication |
|----------------------------------|---------------|
| machine-readable mark            | yes           |
| marginally machine-readable mark | unknown       |
| machine unreadable mark          | no            |

Table: mapping of mark types to equivalent `HasIndication` values

Marks should be treated as indelible. They can be added, but never removed from a CVR instance. `Marks` are **not** shorthand for votes.

> Barcodes placed onto a piece of paper (as to represent selections) are not considered marks.

#### Mark Metrics

A `Mark` may be associated with one or more `MarkMetricValue`, which is a implementation dependent measure of a mark.

For example:

```xml
<cdf:Mark>
    <cdf:IsGenerated>true</cdf:IsGenerated>
    <cdf:MarkMetricValue>98</cdf:MarkMetricValue>
</cdf:Mark>
```

`IsGenerated` is optional, but should be included when the origin of the mark is known.

When a metric is used, its type (`MarkMetricType`) **must** be specified by the `ReportingDevice` playing the role of the `CVR`'s `CreatingDevice`.

```xml
<cdf:ReportingDevice ObjectId="rd">
    <cdf:MarkMetricType>AJAX</cdf:MarkMetricType>
</cdf:ReportingDevice>
```

The `MarkMetricType` used is expected to be the same for all marks originating from the same `CreatingDevice`.

From the above examples, we can see that the mark has a quality measurement of type AJAX (a fictional quality measurement) and quality score of 98 (0 is the worst, 100 is the best).

### Adjudication

> This section only applies to adjudication done electronically.

If a mark was present, but was not captured in the initial CVR, then it should be indicated as a `Mark` with the `Status` element set to `adjudicated`. `HasIndication` should be set to `yes`.

```xml
<cdf:SelectionPosition>
    <cdf:HasIndication>yes</cdf:HasIndication>
    <cdf:IsAllocable>yes</cdf:IsAllocable>
    <cdf:Mark>...</cdf:Mark>
    <cdf:NumberVotes>1</cdf:NumberVotes>
    <cdf:Status>adjudicated</cdf:Status>
</cdf:SelectionPosition>
```

> `Mark` should be used to capture marks that are *machine readable* only. This usually means marks that fall within the *contest selection position*. Marks that convey voter intent but fall outside the target area should be handled without the use of `Mark`.

Conversely, if a mark is determined to not to exist for a given contest option, then set `HasIndication` to `no`.

> `IsAllocable` will always be `no` (or omitted) when `HasIndication` is `no`.

```xml
<cdf:SelectionPosition>
    <cdf:HasIndication>no</cdf:HasIndication>
    <cdf:IsAllocable>no</cdf:IsAllocable>
    <cdf:HasIndication>yes</cdf:HasIndication>
    <cdf:NumberVotes>1</cdf:NumberVotes>
    <cdf:Status>adjudicated</cdf:Status>
</cdf:SelectionPosition>
```

### Meaning of `IsAllocable`

`IsAllocable` tells us whether the selection (and the associated number of votes) should be allocated to the contest option's accumulator (counter).

> Previous drafts of the spec used a complex set of statuses that the consumer was required to interpret. By using a single flag, we know if the mark counts, and the statuses can tell us why.

> The value of `IsAllocable` should singularly determine if `NumberVotes` will be allocated to a contest option's accumulator.

### Machine Generated Indications

If an indication was generated by machine, such as in the indirect selections of straight party voting, then use `SelectionPosition` directly.

```xml
<cdf:SelectionPosition>
    <cdf:HasIndication>yes</cdf:HasIndication>
    <cdf:IsAllocable>yes</cdf:IsAllocable>
    <cdf:NumberVotes>1</cdf:NumberVotes>
    <cdf:Status>generated-rules</cdf:Status>
</cdf:SelectionPosition>
```

## Handling Overvotes

> This section only applies to paper ballots.

Consider the following contest:

**For Treasurer of State**

- [x] Connie Pillich
- [x] Josh Mandel

Can be represented with the XML below:

```xml
<cdf:CVRContest>
    <cdf:ContestId>_5TS</cdf:ContestId>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1ECP</cdf:ContestSelectionId>
        <cdf:Position>1</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>no</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>0</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1EJM</cdf:ContestSelectionId>
        <cdf:Position>2</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>no</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>0</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:Overvotes>1</cdf:Overvotes>
    <cdf:Undervotes>0</cdf:Undervotes>
</cdf:CVRContest>
```

Note that the indications are still accounted for, even though the votes will not be allocated to the *contest option* accumulators for Connie Pillich nor John Mandel, but instead to the *overvote* accumulator.

> If the CVR producer wants a downstream processor to adjudicate the selection indications, it should set `IsAllocable` to `unknown`.

## Write-Ins

### Basic Write-In

Consider the following contest:

**Governor**

- [ ] Edward FitzGerald
- [ ] John Kasich
- [ ] Anita Rios
- [x] Write-In (John Smith)

can be represented with the following XML fragment:

```xml
<cdf:CVRContest>
    <cdf:ContestId>_1GO</cdf:ContestId>
    <cdf:CVRContestSelection>
        <cdf:Position>4</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:CVRWriteIn>
                <cdf:Text>John Smith</cdf:Text>
            </cdf:CVRWriteIn>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>unknown</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
        </cdf:SelectionPosition>
        <cdf:Status>needs-adjudication</cdf:Status>
    </cdf:CVRContestSelection>
</cdf:CVRContest>
```

#### Explanation

Note that this fragment is the `original` CVR from the `CreatingDevice`, and thus we do not yet know the validity of the write-in. Still we can say some things about it.

The text of the write-in is `John Smith`. This is represented using the `Text` element.

> `SelectionPosition` represents both the selection of the *write-in contest option* *and* the write-in itself. Thus it is not possible to say that the selection of the write-in option is valid, but the write-in name provided is not.

If John Smith was determined to be a valid write-in, then the following may occur:

- `IsAllocable` is set to `yes`
- `CVRContestSelection` is linked to the `ContestSelection` associated with the candidate.

> Some systems may not be capable of tabulating votes for the candidate underlying a write-in.

### Write-In Counter

If desired, the `CVRContest` may contain the number of `WriteIns`, i.e the number of write-in *contest options* selected. This includes options that were selected, but no candidate was specified (e.g. a filled oval with an empty line).

### Adjudication of Write-Ins

Adjudication can do two things

1. Determine if the name represents a valid write-in option, i.e. does the write-in text represent a valid write-in option?

2. Determine if the contest selection should be allocated. This is different from (1), as even if it is determined that the write-in text represents a valid write-in option, it may be overwritten by interpretation of voter intent.

## CVR Snapshots

A CVR can be used throughout various points in the election lifecycle:

- Capture of contest selections
- Interpretation of contest selections
- Adjudication of contest selections
- Other operations

If a downstream system needs to modify the CVR, such as to add a `CVRContestSelection` as the result of adjudication, a new CVRSnapshot should be created.

Consider the following XML fragment:

```xml
<cdf:CVRSnapshot ObjectId="css-02">
    <cdf:CVRContest>
        <cdf:ContestId>_6RC</cdf:ContestId>
        <cdf:CVRContestSelection>
            <cdf:ContestSelectionId>_1FMZ</cdf:ContestSelectionId>
            <cdf:Position>1</cdf:Position>
            <cdf:SelectionPosition>
                <cdf:HasIndication>unknown</cdf:HasIndication>
                <cdf:Mark>
                    <cdf:MarkMetricValue>76</cdf:MarkMetricValue>
                </cdf:Mark>
                <cdf:NumberVotes>1</cdf:NumberVotes>
            </cdf:SelectionPosition>
        </cdf:CVRContestSelection>
    </cdf:CVRContest>
    <cdf:Status>needs-adjudication</cdf:Status>
    <cdf:Type>original</cdf:Type>
</cdf:CVRSnapshot>
```

This represents a CVR having a single marked contest, in which the indication is `unknown` (e.g. the mark is marginal). The `Status` of the `CVRSnapshot` is `needs-adjudication` so as to flag a downstream system or process.

An adjudicator takes a look at the ballot, and determines that mark is a result of the voter resting their pen on the *contest option position*, and not voter intent to make a selection for `Mark Zetzer`. Thus, `HasIndication` is set to `no`, and a new `CVRSnapshot` is created recording this action:

```xml
...
<cdf:CVRSnapshot ObjectId="css-03">
    <cdf:Annotation>
        <cdf:AdjudicatorName>Mark Kennamond</cdf:AdjudicatorName>
        <cdf:Message>Resting Mark, Mark Zetzer</cdf:Message>
        <cdf:TimeStamp>2018-05-16T12:10:09</cdf:TimeStamp>
    </cdf:Annotation>
    <cdf:CVRContest>
        <cdf:ContestId>_6RC</cdf:ContestId>
        <cdf:CVRContestSelection>
            <cdf:ContestSelectionId>_1FMZ</cdf:ContestSelectionId>
            <cdf:Position>1</cdf:Position>
            <cdf:SelectionPosition>
                <cdf:HasIndication>no</cdf:HasIndication>
                <cdf:Mark>
                    <cdf:MarkMetricValue>76</cdf:MarkMetricValue>
                </cdf:Mark>
                <cdf:NumberVotes>1</cdf:NumberVotes>
            </cdf:SelectionPosition>
            <cdf:TotalNumberVotes>0</cdf:TotalNumberVotes>
        </cdf:CVRContestSelection>
    </cdf:CVRContest>
    <cdf:Type>interpreted</cdf:Type>
</cdf:CVRSnapshot>
```

Information about the adjudication is conveyed via the `Annotation` element. We can see the name of the adjudicator and the a description of the changes to the CVR. There can be as many `Annotation` elements as required to describe the changes made to the CVR.

> Each `CVRSnapshot` should represent a set of changes to a CVR during a phase of processing. It is not necessary to create a separate `CVRSnapshot` for every change.

### Current CVR

If a system is looking to tabulate a set of CVRs, it must know for each `CVR`, which `CVRSnapshot` is the currently tabulatable record. This is achieved through a `CurrentSnapshot` reference from `CVR` to the `CVRSnapshot` that should be used.

## Secondary Information

### Ballot Images

If a scanner is capable of capturing raster ballot images, then that data can be stored alongside the structured CVR.

Ballot images can either be referenced from the CVR as a URI, or stored within it, as `base64` encoded binary.

#### Storing a reference

```xml
<BallotImage>
    <Location>http://192.168.1.1/imageserver/ballot1056.jpeg</Location>
</BallotImage>
```

#### Storing Image Data

```xml
<BallotImage>
    <Image FileName="CVR1_Ballot.jpg" MimeType="image/jpeg">Q1ZSIEltYWdl</Image>
</BallotImage>
```

## Voting Method Support

The NIST CVR CDF supports all major voting methods currently in use in the United States.

### Rank Choice Voting

Consider the following contest:

**Member of County Council at Large**

|Contest Option|1st  |2nd  |3rd  |
|--------------|-----|-----|-----|
|Ilene Shapiro |`[ ]`|`[x]`|`[ ]`|
|Debbie Walsh  |`[x]`|`[ ]`|`[ ]`|
|Sandra Kurt   |`[ ]`|`[ ]`|`[x]`|

Table: Representation of a RCV contest

```xml
<cdf:CVRContest>
    <cdf:ContestId>_9CC</cdf:ContestId>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1HIS</cdf:ContestSelectionId>
        <cdf:Position>2</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
            <cdf:Rank>2</cdf:Rank>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>1</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1HDW</cdf:ContestSelectionId>
        <cdf:Position>3</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
            <cdf:Rank>1</cdf:Rank>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>1</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1HSK</cdf:ContestSelectionId>
        <cdf:Position>6</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
            <cdf:Rank>3</cdf:Rank>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>1</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:Undervotes>0</cdf:Undervotes>
</cdf:CVRContest>
```

Each candidate may be ranked using the `Rank` attribute. The rank may or may not be the same as the `Position`.

### Cumulative Voting

Consider the following contest:

**Member of County Council at Large**

|Contest Option|1st  |2nd  |3rd  |
|--------------|-----|-----|-----|
|Ilene Shapiro |`[ ]`|`[x]`|`[ ]`|
|Debbie Walsh  |`[x]`|`[ ]`|`[x]`|
|Sandra Kurt   |`[ ]`|`[ ]`|`[ ]`|

Table: Representation of a cumulative voting contest

If the ballot was hand marked, then the following CVR could be constructed:

```xml
<cdf:CVRContest>
    <cdf:ContestId>_9CC</cdf:ContestId>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1HIS</cdf:ContestSelectionId>
        <cdf:Position>2</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
            <cdf:Position>2</cdf:Position>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>1</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1HDW</cdf:ContestSelectionId>
        <cdf:Position>3</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
            <cdf:Position>1</cdf:Position>
        </cdf:SelectionPosition>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
            <cdf:Position>3</cdf:Position>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>2</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:Undervotes>1</cdf:Undervotes>
</cdf:CVRContest>
```

Because **Debbie Walsh** received two votes, she has two `SelectionIndications`.

If the same vote was cast on a ballot marking device, the CVR could be simplified somewhat:

```xml
<cdf:CVRContest>
    <cdf:ContestId>_9CC</cdf:ContestId>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1HIS</cdf:ContestSelectionId>
        <cdf:Position>2</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>1</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1HDW</cdf:ContestSelectionId>
        <cdf:Position>3</cdf:Position>
        <cdf:SelectionPosition>
            <cdf:HasIndication>yes</cdf:HasIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>2</cdf:NumberVotes>
        </cdf:SelectionPosition>
        <cdf:TotalNumberVotes>2</cdf:TotalNumberVotes>
    </cdf:CVRContestSelection>
    <cdf:Undervotes>0</cdf:Undervotes>
</cdf:CVRContest>
```

The representation of the indication for **Ilene Shapiro** is unchanged, but Debbie Walsh's votes have been consolidated into a single `SelectionIndication`, with a `NumberVotes` of `2`.
