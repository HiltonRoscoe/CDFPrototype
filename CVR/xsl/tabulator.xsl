<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cdf="http://itl.nist.gov/ns/voting/1500-103/v1"
    xmlns:enr="http://itl.nist.gov/ns/voting/1500-100/v2" xmlns:saxon="http://saxon.sf.net/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.0" exclude-result-prefixes="xs"
    expand-text="yes">
    <xsl:output media-type="xml" indent="yes"/>
    <xsl:mode streamable="yes" use-accumulators="#all"/>
    <!-- mode for generating ENR 1500-100 output -->
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
    <!-- holds votes, one for each ContestSelection in election -->
    <xsl:accumulator name="votes" streamable="yes" initial-value="map {}"
        as="map(xs:untypedAtomic, xs:anyAtomicType?)">
        <!-- sets initial value, + operator on null doesn't work! -->
        <xsl:accumulator-rule match="cdf:ContestSelection" select="map:put($value, @ObjectId, 0)"/>
        <!-- assumes there is only one SelectionPosition, which should be true for n-of-m contests -->
        <xsl:accumulator-rule match="cdf:CVRContestSelection" saxon:capture="yes" phase="end"
            select="
                if (cdf:SelectionPosition/cdf:IsAllocable = 'yes') then
                    map:put($value, cdf:ContestSelectionId, map:get($value, cdf:ContestSelectionId) + cdf:SelectionPosition/cdf:NumberVotes)
                else
                    $value"
        />  
    </xsl:accumulator>
    <xsl:template match="/">
        <!-- cannot access accumulator from non streamable context?? -->
        <xsl:variable name="votes" select="accumulator-after('votes')"/>
        <!-- check for non N-of-M contests, we can't tabulate them -->
        <xsl:if
            test="accumulator-after('Election')/cdf:Contest[@xsi:type = 'cdf:CandidateContest']/cdf:VoteVariation != 'n-of-m'">
            <xsl:message terminate="yes">Cannot tabulate CVR with non-N-of-M races</xsl:message>
        </xsl:if>
        <!-- begin writeout of ERR 1500-100 instance -->
        <enr:ElectionReport>
            <enr:Election>
                <xsl:apply-templates select="accumulator-after('Election')" mode="report">
                    <xsl:with-param tunnel="yes" name="votes" select="$votes"/>
                </xsl:apply-templates>
            </enr:Election>
            <enr:Format>precinct-level</enr:Format>
            <enr:GeneratedDate>2020-09-04T00:00:00Z</enr:GeneratedDate>
            <xsl:apply-templates select="accumulator-after('GpUnit')"/>
            <enr:Issuer>Hilton Roscoe LLC</enr:Issuer>
            <enr:IssuerAbbreviation>HR LLC</enr:IssuerAbbreviation>
            <xsl:apply-templates select="accumulator-after('Party')"/>
            <enr:SequenceStart>1</enr:SequenceStart>
            <enr:SequenceEnd>1</enr:SequenceEnd>
            <enr:Status>unofficial-partial</enr:Status>
            <enr:VendorApplicationId>XSLT N-of-M Tabulator</enr:VendorApplicationId>
        </enr:ElectionReport>
    </xsl:template>
    <xsl:template match="cdf:Election" mode="report">
        <xsl:apply-templates select="cdf:Candidate | cdf:Contest" mode="#current"/>
        <enr:ElectionScopeId>{cdf:ElectionScopeId}</enr:ElectionScopeId>
        <enr:Name>
            <enr:Text Language="en-us">
                <xsl:choose>
                    <xsl:when test="cdf:Name">{cdf:Name}</xsl:when>
                    <xsl:otherwise>Unnamed Election</xsl:otherwise>
                </xsl:choose>
            </enr:Text>
        </enr:Name>
        <!-- Not in CVR, so can't put good value here -->
        <enr:StartDate>2020-09-04</enr:StartDate>
        <enr:EndDate>2020-09-04</enr:EndDate>
        <enr:Type>general</enr:Type>
    </xsl:template>
    <xsl:template match="cdf:Candidate" mode="report">
        <enr:Candidate ObjectId="{@ObjectId}">
            <enr:BallotName>
                <enr:Text Language="en-us">{cdf:Name}</enr:Text>
            </enr:BallotName>
        </enr:Candidate>
    </xsl:template>
    <xsl:template match="cdf:GpUnit">
        <enr:GpUnit ObjectId="{@ObjectId}" xsi:type="enr:ReportingDevice"/>
    </xsl:template>
    <xsl:template match="cdf:Party">
        <enr:Party ObjectId="{@ObjectId}">
            <enr:Name>
                <enr:Text Language="en-us">{cdf:Name}</enr:Text>
            </enr:Name>
        </enr:Party>
    </xsl:template>
    <xsl:template match="cdf:Contest" mode="report">
        <enr:Contest ObjectId="{@ObjectId}" xsi:type="{replace(@xsi:type,'cdf','enr')}">
            <xsl:apply-templates select="cdf:ContestSelection" mode="#current"/>
            <!-- not in CVR, so can't put good value here -->
            <enr:ElectionDistrictId>gpu-precinct</enr:ElectionDistrictId>
            <enr:Name>{cdf:Name}</enr:Name>
            <xsl:where-populated>
                <enr:VotesAllowed>{cdf:VotesAllowed}</enr:VotesAllowed>
            </xsl:where-populated>
        </enr:Contest>
    </xsl:template>
    <xsl:template match="cdf:ContestSelection" mode="report">
        <xsl:param name="votes" tunnel="yes"/>
        <enr:ContestSelection ObjectId="{@ObjectId}" xsi:type="{replace(@xsi:type,'cdf','enr')}">
            <enr:VoteCounts>
                <enr:GpUnitId>gpu-precinct</enr:GpUnitId>
                <enr:Type>total</enr:Type>
                <enr:Count>{map:get($votes, @ObjectId)}</enr:Count>
            </enr:VoteCounts>
            <xsl:apply-templates select="cdf:CandidateIds" mode="change-ns"/>
            <xsl:if test="cdf:Selection">
                <enr:Selection>
                    <enr:Text Language="en-us">{cdf:Selection}</enr:Text>
                </enr:Selection>
            </xsl:if>
        </enr:ContestSelection>
    </xsl:template>
    <!-- suppresses emit of Code -->
    <xsl:template match="cdf:Code" mode="report"/>
    <!-- utility template that converts cdf namespace to enr namespace -->
    <xsl:template match="cdf:*" mode="change-ns">
        <xsl:element name="enr:{local-name()}">
            <xsl:apply-templates select="@* | node()" mode="change-ns"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@*" mode="change-ns">
        <xsl:attribute name="{local-name()}" select="."/>
    </xsl:template>
</xsl:stylesheet>
