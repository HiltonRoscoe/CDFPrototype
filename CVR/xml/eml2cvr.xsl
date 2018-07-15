<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eml="urn:oasis:names:tc:evs:schema:eml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="eml xsi">
	<xsl:output method="xml"/>
	<xsl:template match="/eml:EML">
		<CastVoteRecordReport xsi:schemaLocation="NIST_V0_cast_vote_records.xsd file:///C:/Users/john/Documents/GitHub/CastVoteRecords/NIST_V0_cast_vote_records.xsd" xmlns="NIST_V0_cast_vote_records.xsd">
			<xsl:apply-templates/>
			<Election>			
				<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_',eml:Ballots/eml:EventIdentifier/@IdNumber)"></xsl:value-of></xsl:attribute>
				<xsl:for-each select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest/eml:BallotChoices/eml:Candidate">
					<Candidate>
					<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_',eml:CandidateIdentifier/@IdNumber)"></xsl:value-of></xsl:attribute>
					<Name><xsl:value-of select="eml:CandidateFullName/eml:NameElement" /></Name>						
					</Candidate>
				</xsl:for-each>
				<xsl:for-each select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest">
					<Contest xsi:type="CandidateContest">
						<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_',eml:ContestIdentifier/@IdNumber)"></xsl:value-of></xsl:attribute>						
				<xsl:for-each select="eml:BallotChoices/eml:Candidate">						
						<ContestSelection xsi:type="CandidateSelection">
												<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_CS',eml:CandidateIdentifier/@IdNumber)"></xsl:value-of></xsl:attribute>						
							<CandidateIds><xsl:value-of select="concat('_',eml:CandidateIdentifier/@IdNumber)"></xsl:value-of></CandidateIds>					
						</ContestSelection>
				</xsl:for-each>
					<Name><xsl:value-of select="eml:ContestIdentifier/eml:ContestName"></xsl:value-of></Name>
					</Contest>
				</xsl:for-each>
			</Election>
			<GeneratedDate>2018-07-15T00:00:00Z</GeneratedDate>
			<ReportType>originating-device-export</ReportType>
			<Version>1.0</Version>
		</CastVoteRecordReport>
	</xsl:template>
	<xsl:template match="eml:EMLHeader">
	</xsl:template>
	<xsl:template match="eml:Ballots">
		<CVR>
			<BallotStatus>other</BallotStatus>
			<BallotStyleId>
				<xsl:value-of select="concat('_', eml:Ballot/eml:BallotIdentifier/@IdNumber)"/>
			</BallotStyleId>
			<xsl:apply-templates select="eml:Ballot/eml:Election/eml:Contest"/>
			<ElectionId>
				<xsl:value-of select="concat('_',eml:EventIdentifier/@IdNumber)"/>
			</ElectionId>
			<OtherBallotStatus>cast</OtherBallotStatus>
		</CVR>
	</xsl:template>
	<xsl:template match="eml:Contest">
		<ContestLink>
			<ContestId>
				<xsl:value-of select="concat('_', eml:ContestIdentifier/@IdNumber)"/>
			</ContestId>
			<xsl:apply-templates select="eml:BallotChoices/eml:Candidate"/>
		</ContestLink>
	</xsl:template>
	<xsl:template match="eml:Candidate">
		<ContestSelectionLink>
			<ContestSelectionId>
				<xsl:value-of select="concat('_', eml:CandidateIdentifier/@IdNumber)"/>
			</ContestSelectionId>			
			<Mark>
				<NumberVotes>
					<xsl:choose>
						<xsl:when test="eml:Selected = 'true'">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</NumberVotes>
			</Mark>			
			<Position>
				<xsl:value-of select="position()"/>
			</Position>
		</ContestSelectionLink>
	</xsl:template>
</xsl:stylesheet>
