# Cast Vote Record Examples

<!-- TOC -->

- [Cast Vote Record Examples](#cast-vote-record-examples)
    - [Assumptions](#assumptions)
    - [Basic Example](#basic-example)
    - [SelectionIndication](#selectionindication)
        - [Voter Made `Marks` (Paper Only)](#voter-made-marks-paper-only)
        - [Machine Generated Marks](#machine-generated-marks)
        - [Adjudication](#adjudication)
        - [Handling of Marks](#handling-of-marks)
        - [Meaning of `IsAllocable`](#meaning-of-isallocable)
    - [Handling Overvotes](#handling-overvotes)
    - [Write-Ins](#write-ins)
        - [Basic Write-In](#basic-write-in)
        - [Explanation](#explanation)
        - [Adjudication of Write-Ins](#adjudication-of-write-ins)

<!-- /TOC -->

These example show how to use the NIST CVR CDF to represent various different voting scenarios.

## Assumptions

- This document uses the ballot semantics model built by the Election Modeling Working Group.
- This document uses the `Nov14-EML-410.xml` for all examples.

## Basic Example

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
        <cdf:SelectionIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
        </cdf:SelectionIndication>
    </cdf:CVRContestSelection>
    <cdf:Undervotes>0</cdf:Undervotes>
</cdf:CVRContest>
```

The `cdf:ContestSelectionId` value of `_1ECP` represents the reference to the selected contest option:

```xml
<cdf:Candidate ObjectId="_1ECP">
    ...
    <cdf:Name>Connie Pillich</cdf:Name>
    ...
</cdf:Candidate>
```

By doing the same for `_5TS`, we can see this does indeed represent a contest selection of **Connie Pillich** for **Treasurer of State**.

`SelectionIndication` may appear to be superfluous, don't we already know the outcome for this contest? As we'll find this element will come in handy.

> For a contest selection that is not a write-in, `SelectionIndication` is always required.

## SelectionIndication

`SelectionIndication` is used to convey those selections that are potentially allocable to a contest option. Indications can come from the following sources:

- A `Mark` made by the voter on a paper ballot
- A `Mark` made by a marking device onto a full face paper ballot
- An indication made by machine as a result of business rules
- An indication made by an adjudicator

### Voter Made `Marks` (Paper Only)

`SelectionIndication` has a subtype, `Mark`, which should be used whenever a mark is placed onto a full face paper ballot.

```xml
<cdf:SelectionIndication xsi:type="Mark">
    <cdf:IsAllocable>yes</cdf:IsAllocable>
    <cdf:NumberVotes>1</cdf:NumberVotes>
</cdf:SelectionIndication>
```

### Machine Generated Marks

If an indication was generated by machine, such as in the case of straight party voting, then use `SelectionIndication` directly.

```xml
<cdf:SelectionIndication>
    <cdf:IsAllocable>yes</cdf:IsAllocable>
    <cdf:NumberVotes>1</cdf:NumberVotes>
    <cdf:Status>generated-rules</cdf:Status>
</cdf:SelectionIndication>
```

### Adjudication

> This section only applies to adjudication done electronically.

If a `Mark` was present, but was not captured in the initial CVR, then it would be indicated as a `Mark` with the `Status` element set to `adjudicated`.

```xml
<cdf:SelectionIndication xsi:type="Mark">
    <cdf:IsAllocable>yes</cdf:IsAllocable>
    <cdf:NumberVotes>1</cdf:NumberVotes>
    <cdf:Status>adjudicated</cdf:Status>
</cdf:SelectionIndication>
```

Conversely, if a `Mark` was determined to not be a selection for a given contest option, then set `IsAllocable` to `false`.

> `IsAllocable` should singularly determine if `NumberVotes` will be allocated a contest option's accumulator.

### Handling of Marks

Marks should be treated as indelible. They can be added, but never removed from a CVR instance.`Marks` are not shorthand for votes (see [Tabulation Logic](#tabulationlogic))

### Meaning of `IsAllocable`

As we mentioned above, marks are indelible, so we cannot just omit marks as shorthand for a mark not indicating a contest selection (i.e. after adjudication). This is where `IsAllocable` comes in. `IsAllocable` tells us whether the indication (and the associated number of votes) should be allocated to contest option accumulator (counter).

> Previous versions of the spec used a complex set of statuses that the consumer was required to interpret. By using a single flag, we know if the mark counts, and the statuses can tell us why.

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
    <cdf:CVRContestSelection xsi:type="Mark">
        <cdf:ContestSelectionId>_1ECP</cdf:ContestSelectionId>
        <cdf:Position>2</cdf:Position>
        <cdf:SelectionIndication>
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
        </cdf:SelectionIndication>
    </cdf:CVRContestSelection>
    <cdf:CVRContestSelection>
        <cdf:ContestSelectionId>_1EJM</cdf:ContestSelectionId>
        <cdf:Position>2</cdf:Position>
        <cdf:SelectionIndication xsi:type="Mark">
            <cdf:IsAllocable>yes</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
        </cdf:SelectionIndication>
    </cdf:CVRContestSelection>
    <cdf:Undervotes>0</cdf:Undervotes>
</cdf:CVRContest>
```

Note that the marks are still accounted for, even though the votes will not be allocated to the contest option accumulators for Connie Pillich or John Mandel, but instead to the overvote accumulator.

If the CVR producer wants a downstream processor to adjudicate the selection indications, it should set `IsAllocable` to `unknown`.

## Write-Ins

### Basic Write-In

**Governor**

- [ ] Edward FitzGerald
- [ ] John Kasich
- [ ] Anita Rios
- [x] Write-In (John Smith)

can be represented with the following xml fragment:

```xml
<cdf:CVRContest>
    <cdf:ContestId>_1GO</cdf:ContestId>
    <cdf:CVRContestSelection xsi:type="cdf:CVRWriteIn">
        <cdf:Position>4</cdf:Position>
        <cdf:SelectionIndication>
            <cdf:IsAllocable>unknown</cdf:IsAllocable>
            <cdf:NumberVotes>1</cdf:NumberVotes>
            <cdf:Type>needs-adjudication</cdf:Type>
        </cdf:SelectionIndication>
        <cdf:Text>John Smith</cdf:Text>
    </cdf:CVRContestSelection>
    <cdf:Undervotes>0</cdf:Undervotes>
</cdf:CVRContest>
```

### Explanation

Note that this fragment is from an originating device, such that we do not yet know the validity of the write-in. Still we can say some things about it.

The text of the write-in is `John Smith`. This is represented using the `cdf:Text` element.

(REMOVE?) The contest option position (e.g. an oval) was selected. This is represented by the emission of `cdf:SelectionIndication`. 

> Note that the `cdf:SelectionIndication` represents both the selection of the write-in contest option *and* the write-in itself. Thus it is not possible to say that the selection of the write-in is valid, but the write-in provided is not.

### Adjudication of Write-Ins

Ajudication can do two things

1. Determine if the name represents a valid contest selection. I.e. does the write-in text represent a valid write-in option?

2. Determine if the contest selection should be allocated. This is different from (1), as even if it is determined that the write-in text represents a valid write-in option, it may be overwritten by interperation of voter intent.