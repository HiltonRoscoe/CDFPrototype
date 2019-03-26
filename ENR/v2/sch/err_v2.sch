<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:ns uri="NIST_V2_election_results_reporting.xsd" prefix="err"/>    
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <!-- Schema validators can quickly find missing references, but what about redundant ones?
        -->
    <sch:pattern>        
        <sch:rule context="err:ElectionReport/err:GpUnit[err:Type = 'split-precinct']">
            <sch:assert test="count(idref(current()/@ObjectId)[../err:Type = 'polling-place']) = 1"
                >Each split-precinct must belong to a single polling place</sch:assert>
            <sch:assert test="count(idref(current()/@ObjectId)[../err:Type = 'combined-precinct']) = 1"
                >Each split-precinct must belong to a single combined precinct</sch:assert>
        </sch:rule>
        <!-- GPUnit usage rules -->
        <sch:rule context="err:ElectionReport/err:GpUnit[string(@xsi:type) = 'ReportingUnit']">
            <sch:assert test="count(idref(current()/@ObjectId)[../name() = 'Contest']) > 0"
                >Each GpUnit district must be referenced by a contest</sch:assert>
        </sch:rule>        
        <sch:rule context="err:ElectionReport/err:Office">
            <sch:assert test="count(idref(current()/@ObjectId)[../name() = 'Contest']) > 0"
                >Each office must be associated with a contest</sch:assert> 
            </sch:rule>
        <sch:rule context="err:ElectionReport/err:Election/err:Candidate">
            <sch:assert test="count(idref(current()/@ObjectId)[../name() = 'ContestSelection']) > 0"
                >Each candidate must be associated with a candidate selection</sch:assert> 
        </sch:rule>
        <!-- these can be referenced by many different types, I'm not going to enforce the type
            of the referrant -->
        <sch:rule context="err:ElectionReport/err:Party">
            <sch:assert test="count(idref(current()/@ObjectId)) > 0"
                >Each Party must be used within the file!</sch:assert> 
        </sch:rule>
        <sch:rule context="err:ElectionReport/err:Person">
            <sch:assert test="count(idref(current()/@ObjectId)) > 0"
                >Each Person must be used within the file!</sch:assert> 
        </sch:rule>
    </sch:pattern>    
</sch:schema>
