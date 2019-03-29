<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">    
    <sch:ns uri="NIST_V2_election_results_reporting.xsd" prefix="err"/>    
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>    
    <!-- Schema validators can quickly find missing references, but what about redundant ones?
        -->
    <xsl:import-schema namespace="NIST_V2_election_results_reporting.xsd" schema-location="NIST_V2_election_results_reporting.xsd" />
    <sch:pattern>
        <sch:rule context="element(*, err:BallotStyle)">
            <sch:assert test="not(id(err:GpUnitIds)[not(. instance of element(*, err:GpUnit))])">GpUnitIds (<xsl:value-of select="err:GpUnitIds" />) must point to an element of type GpUnit</sch:assert>
            <sch:assert test="not(id(err:PartyIds)[not(. instance of element(*, err:Party))])">PartyIds (<xsl:value-of select="err:PartyIds" />) must point to an element of type Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Candidate)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'CandidateIds' and .. instance of element(*, err:CandidateSelection)) or (name() = 'CandidateId' and .. instance of element(*, err:RetentionContest))]) > 0">Candidate (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'CandidateIds' and .. instance of element(*, err:CandidateSelection), name() = 'CandidateId' and .. instance of element(*, err:RetentionContest)]</sch:assert>
            <sch:assert test="not(id(err:PartyId)[not(. instance of element(*, err:Party))])">PartyId (<xsl:value-of select="err:PartyId" />) must point to an element of type Party</sch:assert>
            <sch:assert test="not(id(err:PersonId)[not(. instance of element(*, err:Person))])">PersonId (<xsl:value-of select="err:PersonId" />) must point to an element of type Person</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:CandidateContest)">
            <sch:assert test="not(id(err:OfficeIds)[not(. instance of element(*, err:Office))])">OfficeIds (<xsl:value-of select="err:OfficeIds" />) must point to an element of type Office</sch:assert>
            <sch:assert test="not(id(err:PrimaryPartyIds)[not(. instance of element(*, err:Party))])">PrimaryPartyIds (<xsl:value-of select="err:PrimaryPartyIds" />) must point to an element of type Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:CandidateSelection)">
            <sch:assert test="not(id(err:CandidateIds)[not(. instance of element(*, err:Candidate))])">CandidateIds (<xsl:value-of select="err:CandidateIds" />) must point to an element of type Candidate</sch:assert>
            <sch:assert test="not(id(err:EndorsementPartyIds)[not(. instance of element(*, err:Party))])">EndorsementPartyIds (<xsl:value-of select="err:EndorsementPartyIds" />) must point to an element of type Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Coalition)">
            <sch:assert test="not(id(err:PartyIds)[not(. instance of element(*, err:Party))])">PartyIds (<xsl:value-of select="err:PartyIds" />) must point to an element of type Party</sch:assert>
            <sch:assert test="not(id(err:ContestIds)[not(. instance of element(*, err:Contest))])">ContestIds (<xsl:value-of select="err:ContestIds" />) must point to an element of type Contest</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Contest)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'ContestId' and .. instance of element(*, err:OrderedContest)) or (name() = 'ContestIds' and .. instance of element(*, err:Coalition)) or (name() = 'Id' and .. instance of element(*, err:ReportingUnit))]) > 0">Contest (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'ContestId' and .. instance of element(*, err:OrderedContest), name() = 'ContestIds' and .. instance of element(*, err:Coalition), name() = 'Id' and .. instance of element(*, err:ReportingUnit)]</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:ContestSelection)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'OrderedContestSelectionIds' and .. instance of element(*, err:OrderedContest)) or (name() = 'Id' and .. instance of element(*, err:VoteCounts))]) > 0">ContestSelection (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'OrderedContestSelectionIds' and .. instance of element(*, err:OrderedContest), name() = 'Id' and .. instance of element(*, err:VoteCounts)]</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Counts)">
            <sch:assert test="not(id(err:GpUnitId)[not(. instance of element(*, err:GpUnit))])">GpUnitId (<xsl:value-of select="err:GpUnitId" />) must point to an element of type GpUnit</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Election)">
            <sch:assert test="not(id(err:ElectionScopeId)[not(. instance of element(*, err:ReportingUnit))])">ElectionScopeId (<xsl:value-of select="err:ElectionScopeId" />) must point to an element of type ReportingUnit</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:ElectionAdministration)">
            <sch:assert test="not(id(err:ElectionOfficialPersonIds)[not(. instance of element(*, err:Person))])">ElectionOfficialPersonIds (<xsl:value-of select="err:ElectionOfficialPersonIds" />) must point to an element of type Person</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:GpUnit)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'ComposingGpUnitIds' and .. instance of element(*, err:GpUnit)) or (name() = 'GpUnitId' and .. instance of element(*, err:OtherCounts)) or (name() = 'GpUnitIds' and .. instance of element(*, err:BallotStyle)) or (name() = 'GpUnitId' and .. instance of element(*, err:Counts))]) > 0">GpUnit (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'ComposingGpUnitIds' and .. instance of element(*, err:GpUnit), name() = 'GpUnitId' and .. instance of element(*, err:OtherCounts), name() = 'GpUnitIds' and .. instance of element(*, err:BallotStyle), name() = 'GpUnitId' and .. instance of element(*, err:Counts)]</sch:assert>
            <sch:assert test="not(id(err:ComposingGpUnitIds)[not(. instance of element(*, err:GpUnit))])">ComposingGpUnitIds (<xsl:value-of select="err:ComposingGpUnitIds" />) must point to an element of type GpUnit</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Header)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'HeaderId' and .. instance of element(*, err:OrderedHeader))]) > 0">Header (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'HeaderId' and .. instance of element(*, err:OrderedHeader)]</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Office)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'OfficeIds' and .. instance of element(*, err:CandidateContest)) or (name() = 'OfficeId' and .. instance of element(*, err:RetentionContest)) or (name() = 'OfficeIds' and .. instance of element(*, err:OfficeGroup))]) > 0">Office (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'OfficeIds' and .. instance of element(*, err:CandidateContest), name() = 'OfficeId' and .. instance of element(*, err:RetentionContest), name() = 'OfficeIds' and .. instance of element(*, err:OfficeGroup)]</sch:assert>
            <sch:assert test="not(id(err:OfficeHolderPersonIds)[not(. instance of element(*, err:Person))])">OfficeHolderPersonIds (<xsl:value-of select="err:OfficeHolderPersonIds" />) must point to an element of type Person</sch:assert>
            <sch:assert test="not(id(err:ElectionDistrictId)[not(. instance of element(*, err:ReportingUnit))])">ElectionDistrictId (<xsl:value-of select="err:ElectionDistrictId" />) must point to an element of type ReportingUnit</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:OfficeGroup)">
            <sch:assert test="not(id(err:OfficeIds)[not(. instance of element(*, err:Office))])">OfficeIds (<xsl:value-of select="err:OfficeIds" />) must point to an element of type Office</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:OrderedContest)">
            <sch:assert test="not(id(err:OrderedContestSelectionIds)[not(. instance of element(*, err:ContestSelection))])">OrderedContestSelectionIds (<xsl:value-of select="err:OrderedContestSelectionIds" />) must point to an element of type ContestSelection</sch:assert>
            <sch:assert test="not(id(err:ContestId)[not(. instance of element(*, err:Contest))])">ContestId (<xsl:value-of select="err:ContestId" />) must point to an element of type Contest</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:OrderedHeader)">
            <sch:assert test="not(id(err:HeaderId)[not(. instance of element(*, err:Header))])">HeaderId (<xsl:value-of select="err:HeaderId" />) must point to an element of type Header</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:OtherCounts)">
            <sch:assert test="not(id(err:GpUnitId)[not(. instance of element(*, err:GpUnit))])">GpUnitId (<xsl:value-of select="err:GpUnitId" />) must point to an element of type GpUnit</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Party)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'PartyIds' and .. instance of element(*, err:Coalition)) or (name() = 'EndorsementPartyIds' and .. instance of element(*, err:CandidateSelection)) or (name() = 'PartyId' and .. instance of element(*, err:Candidate)) or (name() = 'PartyId' and .. instance of element(*, err:Person)) or (name() = 'PrimaryPartyIds' and .. instance of element(*, err:CandidateContest)) or (name() = 'PartyIds' and .. instance of element(*, err:BallotStyle)) or (name() = 'PartyIds' and .. instance of element(*, err:PartySelection)) or (name() = 'PartyId' and .. instance of element(*, err:PartyRegistration))]) > 0">Party (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'PartyIds' and .. instance of element(*, err:Coalition), name() = 'EndorsementPartyIds' and .. instance of element(*, err:CandidateSelection), name() = 'PartyId' and .. instance of element(*, err:Candidate), name() = 'PartyId' and .. instance of element(*, err:Person), name() = 'PrimaryPartyIds' and .. instance of element(*, err:CandidateContest), name() = 'PartyIds' and .. instance of element(*, err:BallotStyle), name() = 'PartyIds' and .. instance of element(*, err:PartySelection), name() = 'PartyId' and .. instance of element(*, err:PartyRegistration)]</sch:assert>
            <sch:assert test="not(id(err:LeaderPersonIds)[not(. instance of element(*, err:Person))])">LeaderPersonIds (<xsl:value-of select="err:LeaderPersonIds" />) must point to an element of type Person</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:PartyRegistration)">
            <sch:assert test="not(id(err:PartyId)[not(. instance of element(*, err:Party))])">PartyId (<xsl:value-of select="err:PartyId" />) must point to an element of type Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:PartySelection)">
            <sch:assert test="not(id(err:PartyIds)[not(. instance of element(*, err:Party))])">PartyIds (<xsl:value-of select="err:PartyIds" />) must point to an element of type Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:Person)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'ElectionOfficialPersonIds' and .. instance of element(*, err:ElectionAdministration)) or (name() = 'OfficeHolderPersonIds' and .. instance of element(*, err:Office)) or (name() = 'LeaderPersonIds' and .. instance of element(*, err:Party)) or (name() = 'AuthorityIds' and .. instance of element(*, err:ReportingUnit)) or (name() = 'PersonId' and .. instance of element(*, err:Candidate))]) > 0">Person (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'ElectionOfficialPersonIds' and .. instance of element(*, err:ElectionAdministration), name() = 'OfficeHolderPersonIds' and .. instance of element(*, err:Office), name() = 'LeaderPersonIds' and .. instance of element(*, err:Party), name() = 'AuthorityIds' and .. instance of element(*, err:ReportingUnit), name() = 'PersonId' and .. instance of element(*, err:Candidate)]</sch:assert>
            <sch:assert test="not(id(err:PartyId)[not(. instance of element(*, err:Party))])">PartyId (<xsl:value-of select="err:PartyId" />) must point to an element of type Party</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:ReportingUnit)">
            <sch:assert test="count(idref(current()/@ObjectId)[(name() = 'ElectionDistrictId' and .. instance of element(*, err:Office)) or (name() = 'ElectionScopeId' and .. instance of element(*, err:Election))]) > 0">ReportingUnit (<xsl:value-of select="current()/@ObjectId" />) must have refereant from [name() = 'ElectionDistrictId' and .. instance of element(*, err:Office), name() = 'ElectionScopeId' and .. instance of element(*, err:Election)]</sch:assert>
            <sch:assert test="not(id(err:AuthorityIds)[not(. instance of element(*, err:Person))])">AuthorityIds (<xsl:value-of select="err:AuthorityIds" />) must point to an element of type Person</sch:assert>
            <sch:assert test="not(id(err:Id)[not(. instance of element(*, err:Contest))])">Id (<xsl:value-of select="err:Id" />) must point to an element of type Contest</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:RetentionContest)">
            <sch:assert test="not(id(err:OfficeId)[not(. instance of element(*, err:Office))])">OfficeId (<xsl:value-of select="err:OfficeId" />) must point to an element of type Office</sch:assert>
            <sch:assert test="not(id(err:CandidateId)[not(. instance of element(*, err:Candidate))])">CandidateId (<xsl:value-of select="err:CandidateId" />) must point to an element of type Candidate</sch:assert>
        </sch:rule>
        <sch:rule context="element(*, err:VoteCounts)">
            <sch:assert test="not(id(err:Id)[not(. instance of element(*, err:ContestSelection))])">Id (<xsl:value-of select="err:Id" />) must point to an element of type ContestSelection</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>