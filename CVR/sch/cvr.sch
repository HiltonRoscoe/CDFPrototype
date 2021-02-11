<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Generated via
MagicDraw Template for Schematron (SchematronMD)
-->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns uri="http://itl.nist.gov/ns/voting/1500-103/v1" prefix="cdf"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <xsl:import-schema namespace="http://itl.nist.gov/ns/voting/1500-103/v1"
        schema-location="https://raw.githubusercontent.com/usnistgov/CastVoteRecords/master/NIST_V0_cast_vote_records.xsd"/>
    <sch:pattern>
        <sch:rule context="element(*, cdf:Candidate)">
            <sch:assert
                test="count(idref(current()/@ObjectId)[(local-name() = 'CandidateIds' and .. instance of element(*, cdf:CandidateSelection)) or (local-name() = 'CandidateId' and .. instance of element(*, cdf:RetentionContest))]) > 0"
                >Candidate (<xsl:value-of select="current()/@ObjectId"/>) must have refereant from
                CandidateSelection, RetentionContest</sch:assert>
            <sch:assert test="not(id(cdf:PartyId)[not(. instance of element(*, cdf:Party))])"
                >PartyId (<xsl:value-of select="cdf:PartyId"/>) must point to an element of type
                Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:CandidateContest)">
            <sch:assert test="not(id(cdf:PrimaryPartyId)[not(. instance of element(*, cdf:Party))])"
                >PrimaryPartyId (<xsl:value-of select="cdf:PrimaryPartyId"/>) must point to an
                element of type Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:CandidateSelection)">
            <sch:assert
                test="not(id(cdf:CandidateIds)[not(. instance of element(*, cdf:Candidate))])"
                >CandidateIds (<xsl:value-of select="cdf:CandidateIds"/>) must point to an element
                of type Candidate</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:CastVoteRecordReport)">
            <sch:assert
                test="not(id(cdf:ReportGeneratingDeviceIds)[not(. instance of element(*, cdf:ReportingDevice))])"
                >ReportGeneratingDeviceIds (<xsl:value-of select="cdf:ReportGeneratingDeviceIds"/>)
                must point to an element of type ReportingDevice</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:Contest)">
            <sch:assert
                test="count(idref(current()/@ObjectId)[(local-name() = 'ContestId' and .. instance of element(*, cdf:CVRContest))]) > 0"
                >Contest (<xsl:value-of select="current()/@ObjectId"/>) must have refereant from
                CVRContest</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:ContestSelection)">
            <sch:assert
                test="count(idref(current()/@ObjectId)[(local-name() = 'ContestSelectionId' and .. instance of element(*, cdf:CVRContestSelection))]) > 0"
                >ContestSelection (<xsl:value-of select="current()/@ObjectId"/>) must have refereant
                from CVRContestSelection</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:CVR)">
            <sch:assert
                test="not(id(cdf:CreatingDeviceId)[not(. instance of element(*, cdf:ReportingDevice))])"
                >CreatingDeviceId (<xsl:value-of select="cdf:CreatingDeviceId"/>) must point to an
                element of type ReportingDevice</sch:assert>
            <sch:assert test="not(id(cdf:ElectionId)[not(. instance of element(*, cdf:Election))])"
                >ElectionId (<xsl:value-of select="cdf:ElectionId"/>) must point to an element of
                type Election</sch:assert>
            <sch:assert
                test="not(id(cdf:CurrentSnapshotId)[not(. instance of element(*, cdf:CVRSnapshot))])"
                >CurrentSnapshotId (<xsl:value-of select="cdf:CurrentSnapshotId"/>) must point to an
                element of type CVRSnapshot</sch:assert>
            <sch:assert test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])"
                >PartyIds (<xsl:value-of select="cdf:PartyIds"/>) must point to an element of type
                Party</sch:assert>
            <sch:assert
                test="not(id(cdf:BallotStyleUnitId)[not(. instance of element(*, cdf:GpUnit))])"
                >BallotStyleUnitId (<xsl:value-of select="cdf:BallotStyleUnitId"/>) must point to an
                element of type GpUnit</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:CVRContest)">
            <sch:assert test="not(id(cdf:ContestId)[not(. instance of element(*, cdf:Contest))])"
                >ContestId (<xsl:value-of select="cdf:ContestId"/>) must point to an element of type
                Contest</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:CVRContestSelection)">
            <sch:assert
                test="not(id(cdf:ContestSelectionId)[not(. instance of element(*, cdf:ContestSelection))])"
                >ContestSelectionId (<xsl:value-of select="cdf:ContestSelectionId"/>) must point to
                an element of type ContestSelection</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:CVRSnapshot)">
            <sch:assert
                test="count(idref(current()/@ObjectId)[(local-name() = 'CurrentSnapshotId' and .. instance of element(*, cdf:CVR))]) > 0"
                >CVRSnapshot (<xsl:value-of select="current()/@ObjectId"/>) must have refereant from
                CVR</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:Election)">
            <sch:assert
                test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionId' and .. instance of element(*, cdf:CVR))]) > 0"
                >Election (<xsl:value-of select="current()/@ObjectId"/>) must have refereant from
                CVR</sch:assert>
            <sch:assert
                test="not(id(cdf:ElectionScopeId)[not(. instance of element(*, cdf:GpUnit))])"
                >ElectionScopeId (<xsl:value-of select="cdf:ElectionScopeId"/>) must point to an
                element of type GpUnit</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:GpUnit)">
            <sch:assert
                test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionScopeId' and .. instance of element(*, cdf:Election)) or (local-name() = 'BallotStyleUnitId' and .. instance of element(*, cdf:CVR))]) > 0"
                >GpUnit (<xsl:value-of select="current()/@ObjectId"/>) must have refereant from
                Election, CVR</sch:assert>
            <sch:assert
                test="not(id(cdf:ReportingDeviceIds)[not(. instance of element(*, cdf:ReportingDevice))])"
                >ReportingDeviceIds (<xsl:value-of select="cdf:ReportingDeviceIds"/>) must point to
                an element of type ReportingDevice</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:Party)">
            <sch:assert
                test="count(idref(current()/@ObjectId)[(local-name() = 'PartyIds' and .. instance of element(*, cdf:PartySelection)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:CVR)) or (local-name() = 'PrimaryPartyId' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Candidate))]) > 0"
                >Party (<xsl:value-of select="current()/@ObjectId"/>) must have refereant from
                PartySelection, CVR, CandidateContest, Candidate</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:PartySelection)">
            <sch:assert test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])"
                >PartyIds (<xsl:value-of select="cdf:PartyIds"/>) must point to an element of type
                Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:ReportingDevice)">
            <sch:assert
                test="count(idref(current()/@ObjectId)[(local-name() = 'CreatingDeviceId' and .. instance of element(*, cdf:CVR)) or (local-name() = 'ReportingDeviceIds' and .. instance of element(*, cdf:GpUnit)) or (local-name() = 'ReportGeneratingDeviceIds' and .. instance of element(*, cdf:CastVoteRecordReport))]) > 0"
                >ReportingDevice (<xsl:value-of select="current()/@ObjectId"/>) must have refereant
                from CVR, GpUnit, CastVoteRecordReport</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, cdf:RetentionContest)">
            <sch:assert
                test="not(id(cdf:CandidateId)[not(. instance of element(*, cdf:Candidate))])"
                >CandidateId (<xsl:value-of select="cdf:CandidateId"/>) must point to an element of
                type Candidate</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
