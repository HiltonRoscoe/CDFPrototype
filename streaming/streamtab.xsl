<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cdf="http://itl.nist.gov/ns/voting/1500-103/v1"
    xmlns:enr="http://itl.nist.gov/ns/voting/1500-100/v2" xmlns:saxon="http://saxon.sf.net/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" exclude-result-prefixes="xs"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.0">
    <xsl:output media-type="xml" indent="yes"/>
    <xsl:mode streamable="yes" use-accumulators="#all"/>
    <xsl:mode name="report" streamable="no"/>
    <!-- capturing accumulators, for storing reusable data -->
    <xsl:accumulator name="Election" initial-value="''" streamable="yes">
        <xsl:accumulator-rule match="cdf:Election" select="." saxon:capture="yes" phase="end"/>
    </xsl:accumulator>    
    <xsl:accumulator name="GpUnit" initial-value="''" streamable="yes">
        <xsl:accumulator-rule match="cdf:GpUnit" select="($value, .)" saxon:capture="yes"
            phase="end"/>
    </xsl:accumulator>    
    <xsl:accumulator name="Party" initial-value="''" streamable="yes">
        <xsl:accumulator-rule match="cdf:Party" select="($value, .)" saxon:capture="yes" phase="end"
        />
    </xsl:accumulator>
    <!-- holds votes, one for each contestselection in election -->
    <xsl:accumulator name="votes" streamable="yes" initial-value="map {}"
        as="map(xs:untypedAtomic, xs:anyAtomicType?)">
        <!-- sets initial value, + on null doesn't work! -->
        <xsl:accumulator-rule match="cdf:ContestSelection" select="map:put($value, @ObjectId, 0)"/>
        <!-- assumes there is only one SelectionPosition!!! -->
        <xsl:accumulator-rule match="cdf:CVRContestSelection" saxon:capture="yes" phase="end"
            select="map:put($value, cdf:ContestSelectionId, map:get($value, cdf:ContestSelectionId) + cdf:SelectionPosition/cdf:NumberVotes)"
        />
    </xsl:accumulator>
    <!--<xsl:import-schema namespace="http://itl.nist.gov/ns/voting/1500-103/v1"
        schema-location="NIST_V0_cast_vote_records.xsd"/>
    -->
    <xsl:template match="/">
        <!-- cannot access accumulator from non streamable context?? -->
        <xsl:variable name="votes" select="accumulator-after('votes')"/>
        <enr:ElectionReport>
            <enr:Election>
                <xsl:apply-templates select="accumulator-after('Election')" mode="report">
                    <xsl:with-param tunnel="yes" name="votes" select="$votes" />
                </xsl:apply-templates>
                <!--                <xsl:copy-of select="accumulator-after('Election')" />-->
            </enr:Election>
            <enr:Format>precinct-level</enr:Format>
            <enr:GeneratedDate>2020-09-04T00:00:00Z</enr:GeneratedDate>
            <xsl:apply-templates select="accumulator-after('GpUnit')"/>
            <enr:Issuer>n-of-m tabulator</enr:Issuer>
            <enr:IssuerAbbreviation>n-of-m</enr:IssuerAbbreviation>
            <xsl:apply-templates select="accumulator-after('Party')"/>
            <enr:SequenceStart>1</enr:SequenceStart>
            <enr:SequenceEnd>1</enr:SequenceEnd>
            <enr:Status>unofficial-partial</enr:Status>
            <enr:VendorApplicationId>Hilton Roscoe LLC</enr:VendorApplicationId>
        </enr:ElectionReport>
    </xsl:template>
    <xsl:template match="cdf:Election" mode="report">
        <xsl:apply-templates select="cdf:Candidate | cdf:Contest" mode="report"/>
        <enr:ElectionScopeId>gpu-precinct</enr:ElectionScopeId>
        <enr:Name>
            <enr:Text Language="en-us">Mine</enr:Text>
        </enr:Name>
        <enr:StartDate>2020-09-04</enr:StartDate>
        <enr:EndDate>2020-09-04</enr:EndDate>
        <enr:Type>general</enr:Type>
    </xsl:template>
    <xsl:template match="cdf:Candidate" mode="report">
        <enr:Candidate ObjectId="{@ObjectId}">
            <enr:BallotName>
                <enr:Text Language="en-us">
                    <xsl:value-of select="cdf:Name"/>
                </enr:Text>
                <!-- TODO COPY CODE? -->
            </enr:BallotName>
        </enr:Candidate>
    </xsl:template>
    <xsl:template match="cdf:GpUnit">
        <enr:GpUnit ObjectId="{@ObjectId}" xsi:type="enr:ReportingDevice"/>
    </xsl:template>
    <xsl:template match="cdf:Party">
        <enr:Party ObjectId="{@ObjectId}">
            <enr:Name>
                <enr:Text Language="en-us">
                    <xsl:value-of select="cdf:Name"/>
                </enr:Text>
            </enr:Name>
        </enr:Party>
    </xsl:template>
    <xsl:template match="cdf:Contest" mode="report">
        <!-- not in CVR! -->
        <enr:Contest ObjectId="{@ObjectId}" xsi:type="{replace(@xsi:type,'cdf','enr')}">
            <xsl:apply-templates select="cdf:ContestSelection" mode="report"/>
            <enr:ElectionDistrictId>gpu-precinct</enr:ElectionDistrictId>
            <enr:Name>
                <xsl:value-of select="cdf:Name"/>
            </enr:Name>
            <xsl:where-populated>
                <enr:VotesAllowed>
                    <xsl:value-of select="cdf:VotesAllowed"/>
                </enr:VotesAllowed>
            </xsl:where-populated>
        </enr:Contest>
    </xsl:template>
    <xsl:template match="cdf:ContestSelection" mode="report">
        <xsl:param name="votes" tunnel="yes"/>
        <enr:ContestSelection ObjectId="{@ObjectId}" xsi:type="{replace(@xsi:type,'cdf','enr')}">
            <enr:VoteCounts>
                <enr:GpUnitId>gpu-precinct</enr:GpUnitId>
                <enr:Type>total</enr:Type>
                <enr:Count><xsl:value-of select="map:get($votes, @ObjectId)"/></enr:Count>
            </enr:VoteCounts>
            <xsl:apply-templates select="cdf:CandidateIds" mode="change-ns"/>
            <xsl:if test="cdf:Selection">
                <enr:Selection>
                    <enr:Text Language="en-us">
                        <xsl:value-of select="cdf:Selection"/>
                    </enr:Text>
                </enr:Selection>
            </xsl:if>         
        </enr:ContestSelection>
    </xsl:template>
    <xsl:template match="cdf:CVR" mode="nostream"> </xsl:template>
    <xsl:template match="cdf:Code" mode="report"/>
    <!-- utility template that converts cvr namespace to enr namespace -->
    <xsl:template match="cdf:*" mode="change-ns">
        <xsl:element name="enr:{local-name()}">
            <xsl:apply-templates select="@* | node()" mode="change-ns"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@*" mode="change-ns">
        <xsl:attribute name="{local-name()}" select="."/>
    </xsl:template>
</xsl:stylesheet>
