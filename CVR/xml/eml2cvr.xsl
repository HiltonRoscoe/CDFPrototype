<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml file:///C:/Users/john/Documents/GitHub/RemoteBallotMarking/xml/Nov14-EML-410.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:eml="urn:oasis:names:tc:evs:schema:eml"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="eml xsi"
	xmlns:cdf="NIST_V0_cast_vote_records.xsd">
	<xsl:output method="xml"/>
	<xsl:key name="party-by-name" match="eml:AffiliationIdentifier" use="eml:RegisteredName"/>
	<!-- global mode templates, for reusable object generation -->

	<xsl:template match="eml:Candidate" mode="global">
		<cdf:Candidate>
			<xsl:attribute name="ObjectId">
				<xsl:value-of select="concat('_', eml:CandidateIdentifier/@IdNumber)"/>
			</xsl:attribute>
			<cdf:Code>
				<cdf:Type>local-level</cdf:Type>
				<cdf:Value>
					<xsl:value-of select="eml:CandidateIdentifier/@IdNumber"/>
				</cdf:Value>
			</cdf:Code>
			<cdf:Name>
				<xsl:value-of select="eml:CandidateFullName/eml:NameElement"/>
			</cdf:Name>
			<xsl:if test="eml:Affiliation/eml:AffiliationIdentifier/eml:RegisteredName">
				<cdf:PartyId>
					<xsl:value-of
						select="concat('_', eml:Affiliation/eml:AffiliationIdentifier/eml:RegisteredName)"/>
				</cdf:PartyId>
			</xsl:if>
		</cdf:Candidate>
	</xsl:template>
	<xsl:template match="eml:Contest" mode="global">
		<cdf:Contest xsi:type="cdf:CandidateContest">
			<xsl:attribute name="ObjectId">
				<xsl:value-of select="concat('_', eml:ContestIdentifier/@IdNumber)"/>
			</xsl:attribute>
			<cdf:Code>
				<cdf:Type>local-level</cdf:Type>
				<cdf:Value>
					<xsl:value-of select="eml:CandidateIdentifier/@IdNumber"/>
				</cdf:Value>
			</cdf:Code>
			<xsl:for-each select="eml:BallotChoices/eml:Candidate">
				<cdf:ContestSelection xsi:type="cdf:CandidateSelection">
					<xsl:attribute name="ObjectId">
						<xsl:value-of select="concat('_CS', eml:CandidateIdentifier/@IdNumber)"/>
					</xsl:attribute>
					<cdf:CandidateIds>
						<xsl:value-of select="concat('_', eml:CandidateIdentifier/@IdNumber)"/>
					</cdf:CandidateIds>
				</cdf:ContestSelection>
			</xsl:for-each>
			<cdf:Name>
				<xsl:value-of select="eml:ContestIdentifier/eml:ContestName"/>
			</cdf:Name>
			<cdf:VoteVariation>
				<xsl:choose>
					<xsl:when test="eml:VotingMethod = 'FPP'">n-of-m</xsl:when>
					<xsl:when test="eml:VotingMethod = 'IRV'">rcv</xsl:when>
					<xsl:when test="eml:VotingMethod = 'cumulative'">cumulative</xsl:when>
					<xsl:when test="eml:VotingMethod = 'approval'">approval</xsl:when>
				</xsl:choose>
			</cdf:VoteVariation>
			<cdf:VotesAllowed>
				<xsl:value-of select="eml:MaxVotes"/>
			</cdf:VotesAllowed>
		</cdf:Contest>
	</xsl:template>
	<xsl:template match="eml:EMLHeader"> </xsl:template>
	<xsl:template match="/eml:EML">
		<cdf:CastVoteRecordReport
			xsi:schemaLocation="NIST_V0_cast_vote_records.xsd file:///C:/Users/john/Documents/GitHub/CastVoteRecords/NIST_V0_cast_vote_records.xsd">
			<xsl:apply-templates/>
			<cdf:Election>
				<xsl:attribute name="ObjectId">
					<xsl:value-of select="concat('_', eml:Ballots/eml:EventIdentifier/@IdNumber)"/>
				</xsl:attribute>
				<xsl:apply-templates
					select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest/eml:BallotChoices/eml:Candidate"
					mode="global"> </xsl:apply-templates>
				<cdf:Code>
					<cdf:Type>local-level</cdf:Type>
					<cdf:Value>
						<xsl:value-of
							select="eml:Ballots/eml:Ballot/eml:Election/eml:ElectionIdentifier/@IdNumber"
						/>
					</cdf:Value>
				</cdf:Code>
				<xsl:apply-templates select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest"
					mode="global"> </xsl:apply-templates>
				<cdf:ElectionScopeId>gpu-precinct</cdf:ElectionScopeId>
				<cdf:Name>
					<xsl:value-of
						select="eml:Ballots/eml:Ballot/eml:Election/eml:ElectionIdentifier/eml:ElectionName"
					/>
				</cdf:Name>
			</cdf:Election>
			<!-- XSL 1.0 doesn't have date function -->
			<cdf:GeneratedDate>2018-07-15T00:00:00Z</cdf:GeneratedDate>
			<cdf:GpUnit ObjectId="rd" xsi:type="cdf:ReportingDevice">
				<cdf:OtherType>reporting-device</cdf:OtherType>
				<cdf:Type>other</cdf:Type>
				<cdf:Application>Ballot Marker</cdf:Application>
				<cdf:Manufacturer>Hilton Roscoe LLC</cdf:Manufacturer>
			</cdf:GpUnit>
			<cdf:GpUnit ObjectId="gpu-precinct">
				<cdf:Code>
					<cdf:Type>local-level</cdf:Type>
					<cdf:Value>
						<xsl:value-of
							select="eml:Ballots/eml:Ballot/eml:ReportingUnitIdentifier/@IdNumber"/>
					</cdf:Value>
				</cdf:Code>
				<cdf:Type>precinct</cdf:Type>
			</cdf:GpUnit>
			<cdf:Notes>Example using the NIST CVR CDF</cdf:Notes>
			<xsl:for-each
				select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest/eml:BallotChoices/eml:Candidate/eml:Affiliation/eml:AffiliationIdentifier[count(. | key('party-by-name', eml:RegisteredName)[1]) = 1]">
				<cdf:Party>
					<xsl:attribute name="ObjectId">
						<xsl:value-of select="concat('_', eml:RegisteredName)"/>
					</xsl:attribute>
					<cdf:Name>
						<xsl:value-of select="eml:RegisteredName"/>
					</cdf:Name>
				</cdf:Party>
			</xsl:for-each>
			<cdf:ReportGeneratingDeviceIds>rd</cdf:ReportGeneratingDeviceIds>
			<cdf:ReportType>originating-device-export</cdf:ReportType>
			<cdf:Version>1.0</cdf:Version>
		</cdf:CastVoteRecordReport>
	</xsl:template>
	<xsl:template match="eml:Ballots">
		<cdf:CVRHistory>
			<cdf:CVR>
				<cdf:BallotStyleId>
					<xsl:value-of select="concat('_', eml:Ballot/eml:BallotIdentifier/@IdNumber)"/>
				</cdf:BallotStyleId>
				<xsl:apply-templates select="eml:Ballot/eml:Election/eml:Contest"/>
				<cdf:ElectionId>
					<xsl:value-of select="concat('_', eml:EventIdentifier/@IdNumber)"/>
				</cdf:ElectionId>
				<cdf:IsCurrent>true</cdf:IsCurrent>
				<cdf:OriginatingDevice>rd</cdf:OriginatingDevice>
				<cdf:OtherBallotStatus>cast</cdf:OtherBallotStatus>
				<cdf:Status>other</cdf:Status>
				<cdf:Type>original</cdf:Type>
			</cdf:CVR>
		</cdf:CVRHistory>
	</xsl:template>
	<xsl:template match="eml:Contest">
		<cdf:CVRContest>
			<cdf:ContestId>
				<xsl:value-of select="concat('_', eml:ContestIdentifier/@IdNumber)"/>
			</cdf:ContestId>
			<xsl:apply-templates
				select="eml:BallotChoices/*[self::eml:Candidate or self::eml:WriteInCandidate]"/>
			<cdf:Undervotes>
				<xsl:value-of
					select="eml:MaxVotes - count(eml:BallotChoices/*[self::eml:Candidate or self::eml:WriteInCandidate][eml:Selected])"
				/>
			</cdf:Undervotes>
		</cdf:CVRContest>
	</xsl:template>
	<xsl:template match="eml:Candidate">
		<xsl:if test="eml:Selected">
			<cdf:CVRContestSelection>
				<cdf:ContestSelectionId>
					<xsl:value-of select="concat('_', eml:CandidateIdentifier/@IdNumber)"/>
				</cdf:ContestSelectionId>
				<cdf:Position>
					<xsl:value-of select="position()"/>
				</cdf:Position>
				<cdf:SelectionIndication>
					<cdf:IsAllocable>
						<xsl:choose>
							<xsl:when test="eml:Selected">yes</xsl:when>
							<xsl:otherwise>no</xsl:otherwise>
						</xsl:choose>
					</cdf:IsAllocable>
					<cdf:NumberVotes>1</cdf:NumberVotes>
					<xsl:if test="eml:Selected and eml:Selected != 'true'">
						<cdf:Rank>
							<xsl:value-of select="eml:Selected"/>
						</cdf:Rank>
					</xsl:if>
				</cdf:SelectionIndication>
			</cdf:CVRContestSelection>
		</xsl:if>
	</xsl:template>
	<xsl:template match="eml:WriteInCandidate">
		<xsl:if test="eml:Selected">
			<cdf:CVRContestSelection xsi:type="cdf:CVRWriteIn">
				<cdf:Position>
					<xsl:value-of select="position()"/>
				</cdf:Position>
				<cdf:SelectionIndication>
					<cdf:IsAllocable>
						<xsl:choose>
							<xsl:when test="eml:Selected">yes</xsl:when>
							<xsl:otherwise>no</xsl:otherwise>
						</xsl:choose>
					</cdf:IsAllocable>
					<cdf:NumberVotes>
						<xsl:choose>
							<xsl:when test="eml:Selected">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</cdf:NumberVotes>
					<xsl:if test="eml:Selected and eml:Selected != 'true'">
						<cdf:Rank>
							<xsl:value-of select="eml:Selected"/>
						</cdf:Rank>
					</xsl:if>
				</cdf:SelectionIndication>
				<cdf:IsAllocable>unknown</cdf:IsAllocable>
				<cdf:Text>
					<xsl:value-of select="eml:Name"/>
				</cdf:Text>
			</cdf:CVRContestSelection>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
