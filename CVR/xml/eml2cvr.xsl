<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml file:///C:/temp/basic_data.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eml="urn:oasis:names:tc:evs:schema:eml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="eml xsi" xmlns:cdf="NIST_V0_cast_vote_records.xsd">
	<xsl:output method="xml"/>
	<!-- global mode templates, for reusable object generation -->
	<xsl:template match="eml:Candidate" mode="global">
		<cdf:Candidate>
			<xsl:attribute name="ObjectId">
				<xsl:value-of select="concat('_',eml:CandidateIdentifier/@IdNumber)"/>
			</xsl:attribute>
			<cdf:Name>
				<xsl:value-of select="eml:CandidateFullName/eml:NameElement"/>
			</cdf:Name>
		</cdf:Candidate>
	</xsl:template>
	<xsl:template match="eml:Contest" mode="global">
		<cdf:Contest xsi:type="cdf:CandidateContest">
			<xsl:attribute name="ObjectId">
				<xsl:value-of select="concat('_',eml:ContestIdentifier/@IdNumber)"/>
			</xsl:attribute>
			<xsl:for-each select="eml:BallotChoices/eml:Candidate">
				<cdf:ContestSelection xsi:type="cdf:CandidateSelection">
					<xsl:attribute name="ObjectId">
						<xsl:value-of select="concat('_CS',eml:CandidateIdentifier/@IdNumber)"/>
					</xsl:attribute>
					<cdf:CandidateIds>
						<xsl:value-of select="concat('_',eml:CandidateIdentifier/@IdNumber)"/>
					</cdf:CandidateIds>
				</cdf:ContestSelection>
			</xsl:for-each>
			<cdf:Name>
				<xsl:value-of select="eml:ContestIdentifier/eml:ContestName"/>
			</cdf:Name>
		</cdf:Contest>
	</xsl:template>
	<xsl:template match="eml:EMLHeader">
		<a>what dis</a>
	</xsl:template>
	<xsl:template match="/eml:EML">
		<cdf:CastVoteRecordReport xsi:schemaLocation="NIST_V0_cast_vote_records.xsd file:///C:/Users/john/Documents/GitHub/CastVoteRecords/NIST_V0_cast_vote_records.xsd">
			<xsl:apply-templates/>
			<cdf:Election>
				<xsl:attribute name="ObjectId">
					<xsl:value-of select="concat('_',eml:Ballots/eml:EventIdentifier/@IdNumber)"/>
				</xsl:attribute>
				<xsl:apply-templates select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest/eml:BallotChoices/eml:Candidate" mode="global">
				</xsl:apply-templates>
				<xsl:apply-templates select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest" mode="global">
				</xsl:apply-templates>
			</cdf:Election>
			<cdf:Notes>Example using the NIST CVR CDF</cdf:Notes>
			<cdf:GeneratedDate>2018-07-15T00:00:00Z</cdf:GeneratedDate>
			<cdf:ReportType>originating-device-export</cdf:ReportType>
			<cdf:Version>1.0</cdf:Version>
		</cdf:CastVoteRecordReport>
	</xsl:template>
	<xsl:template match="eml:Ballots">
		<cdf:CVR>
			<cdf:BallotStatus>other</cdf:BallotStatus>
			<cdf:BallotStyleId>
				<xsl:value-of select="concat('_', eml:Ballot/eml:BallotIdentifier/@IdNumber)"/>
			</cdf:BallotStyleId>
			<xsl:apply-templates select="eml:Ballot/eml:Election/eml:Contest"/>
			<cdf:ElectionId>
				<xsl:value-of select="concat('_',eml:EventIdentifier/@IdNumber)"/>
			</cdf:ElectionId>
			<cdf:OtherBallotStatus>cast</cdf:OtherBallotStatus>
		</cdf:CVR>
	</xsl:template>
	<xsl:template match="eml:Contest">
		<cdf:ContestLink>
			<cdf:ContestId>
				<xsl:value-of select="concat('_', eml:ContestIdentifier/@IdNumber)"/>
			</cdf:ContestId>
			<xsl:apply-templates select="eml:BallotChoices/*[self::eml:Candidate or self::eml:WriteInCandidate]"/>
			<cdf:Undervotes>
				<xsl:value-of select="eml:MaxVotes - count(eml:BallotChoices/*[self::eml:Candidate or self::eml:WriteInCandidate][eml:Selected=true()])"/>
			</cdf:Undervotes>
		</cdf:ContestLink>
	</xsl:template>
	<xsl:template match="eml:Candidate">
		<xsl:if test="eml:Selected = 'true'">
			<cdf:ContestSelectionLink>
				<cdf:ContestSelectionId>
					<xsl:value-of select="concat('_', eml:CandidateIdentifier/@IdNumber)"/>
				</cdf:ContestSelectionId>
				<cdf:Mark>
					<cdf:NumberVotes>
						<xsl:choose>
							<xsl:when test="eml:Selected = 'true'">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</cdf:NumberVotes>
				</cdf:Mark>
				<cdf:Position>
					<xsl:value-of select="position()"/>
				</cdf:Position>
			</cdf:ContestSelectionLink>
		</xsl:if>
	</xsl:template>
	<xsl:template match="eml:WriteInCandidate">
		<cdf:ContestSelectionLink xsi:type="cdf:WriteIn">
			<cdf:Mark>
				<cdf:NumberVotes>
					<xsl:choose>
						<xsl:when test="eml:Selected = 'true'">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</cdf:NumberVotes>
			</cdf:Mark>
			<cdf:Position>
				<xsl:value-of select="position()"/>
			</cdf:Position>
			<cdf:Text>
				<xsl:value-of select="eml:Name"/>
			</cdf:Text>
		</cdf:ContestSelectionLink>
	</xsl:template>
</xsl:stylesheet>
