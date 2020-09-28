<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cdf="http://itl.nist.gov/ns/voting/1500-103/v1" exclude-result-prefixes="xs math"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="numToGenerate" select="10" as="xs:integer"/>
    <!-- THIS TAKES A SINGLE CVR INSTANCE AND GENERATES SELECTIONS BASED ON THE CONTESTS IN THE ELECTION SECTION -->
    <xsl:template match="/">
		<xsl:apply-templates />
    </xsl:template>
    <xsl:template match="cdf:CastVoteRecordReport">
        <cdf:CastVoteRecordReport xmlns:xsi="http://www.w3.org/2001/XMLScheama-instance"
            xmlns:cdf="http://itl.nist.gov/ns/voting/1500-103/v1">
            <xsl:variable name="ctx" select="current()"/>
            <xsl:copy-of select="cdf:Election"/>
            <xsl:copy-of select="cdf:GeneratedDate"/>
            <xsl:copy-of select="cdf:GpUnit"/>
            <xsl:copy-of select="cdf:Party"/>
            <xsl:copy-of select="cdf:ReportGeneratingDeviceIds"/>
            <xsl:copy-of select="cdf:ReportingDevice"/>
            <xsl:copy-of select="cdf:ReportType"/>
            <xsl:copy-of select="cdf:Version"/>
            <xsl:for-each select="10 to $numToGenerate">
                <xsl:variable name="numCVR" select="current()"/>
                <cdf:CVR>
                    <cdf:BallotStyleId>_01-0052-01</cdf:BallotStyleId>
                    <cdf:CreatingDeviceId>rd</cdf:CreatingDeviceId>
                    <cdf:CurrentSnapshotId>cvr-<xsl:value-of select="current()"
                        /></cdf:CurrentSnapshotId>
                    <cdf:CVRSnapshot ObjectId="cvr-{.}">
                        <xsl:for-each
                            select="$ctx/cdf:Election/cdf:Contest">
                            <!-- Generate a CVRContest for most (skips every 4th), 
                                what gets skipped with vary based on CVR num -->
                            <xsl:if test="$numCVR mod (position()+2) != 0">
                                <cdf:CVRContest>
                                    <cdf:ContestId>
                                        <xsl:value-of select="@ObjectId"/>
                                    </cdf:ContestId>
                                    <xsl:variable name="numSelections"
                                        select="count(cdf:ContestSelection)"/>
                                    <xsl:for-each select="cdf:ContestSelection">
                                        <!-- only generate one selection per Contest, will vary based on the formula -->
                                        <xsl:if test="($numCVR + position()) mod $numSelections = 0">
                                            <cdf:CVRContestSelection>
                                                <cdf:ContestSelectionId>
                                                  <xsl:value-of select="@ObjectId"/>
                                                </cdf:ContestSelectionId>
                                                <cdf:SelectionPosition>
                                                  <cdf:HasIndication>yes</cdf:HasIndication>
                                                  <cdf:IsAllocable>yes</cdf:IsAllocable>
                                                  <cdf:NumberVotes>1</cdf:NumberVotes>
                                                </cdf:SelectionPosition>
                                            </cdf:CVRContestSelection>
                                        </xsl:if>
                                    </xsl:for-each>
                                </cdf:CVRContest>
                            </xsl:if>
                        </xsl:for-each>
                        <cdf:Type>original</cdf:Type>
                    </cdf:CVRSnapshot>
                    <cdf:ElectionId>_AK2014General</cdf:ElectionId>
                </cdf:CVR>
            </xsl:for-each>
        </cdf:CastVoteRecordReport>
    </xsl:template>
</xsl:stylesheet>
