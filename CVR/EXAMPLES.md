# Cast Vote Record Examples

These example show how to use the NIST CVR CDF to represent various different voting scenarios.

## Basic Example

**For Treasurer of State**

- [x] Connie Pillich
- [ ] Josh Mandel

can be represented with the following xml fragment:

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

The `cdf:ContestSelectionId` value of `_1ECP` represents the reference to the selected contest option.

```xml
<cdf:Candidate ObjectId="_1ECP">
    ...
    <cdf:Name>Connie Pillich</cdf:Name>
    ...
</cdf:Candidate>
```

By doing the same for `_5TS`, we can see this does indeed represent a contest selection of **Connie Pillich** for **Treasurer of State**.

`CVRContestSelection` may appear to be superfluous, don't we already know the outcome for this contest? As we'll find this element will come in handy.

> For a contest selection that is not a write-in, `CVRContestSelection` is always required.

# Write-Ins

## Basic Write-In

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

The contest option position (e.g. an oval) was selected. This is represented by the emission of `cdf:SelectionIndication`. 

> Note that the `cdf:SelectionIndication` represents both the selection of the write-in contest option *and* the write-in itself. Thus it is not possible to say that the selection of the write-in is valid, but the write-in provided is not.

## Adjudication of Write-Ins

Ajudication can do two things

1. Determine if the name represents a valid contest selection. I.e. does the write-in text represent a valid write-in option?

2. Determine if the contest selection should be allocated. This is different from (1), as even if it is determined that the write-in text represents a valid write-in option, it may be overwritten by interperation of voter intent.