<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml file:///c:/temp/emlforrcv.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eml="urn:oasis:names:tc:evs:schema:eml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="eml xsi" xmlns:cdf="http://itl.nist.gov/ns/voting/1500-103/v1" xsi:schemaLocation="http://itl.nist.gov/ns/voting/1500-103/v1 https://raw.githubusercontent.com/usnistgov/CastVoteRecords/master/NIST_V0_cast_vote_records.xsd">
	<xsl:output method="xml"/>
	<xsl:key name="party-by-name" match="eml:AffiliationIdentifier" use="eml:RegisteredName"/>
	<!-- global mode templates, for reusable object generation -->
	<xsl:template match="eml:Candidate[eml:CandidateIdentifier]" mode="global">
		<cdf:Candidate>
			<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_', eml:CandidateIdentifier/@IdNumber)"/></xsl:attribute>
			<cdf:Code>
				<cdf:Type>local-level</cdf:Type>
				<cdf:Value>
					<xsl:value-of select="eml:CandidateIdentifier/@IdNumber"/>
				</cdf:Value>
			</cdf:Code>
			<cdf:Name>
				<xsl:value-of select="eml:CandidateFullName/eml:NameElement"/>
			</cdf:Name>
			<xsl:if test="eml:Affiliation/eml:AffiliationIdentifier/eml:RegisteredName != ''">
				<cdf:PartyId>
					<xsl:value-of select="concat('_', eml:Affiliation/eml:AffiliationIdentifier/eml:RegisteredName)"/>
				</cdf:PartyId>
			</xsl:if>
		</cdf:Candidate>
	</xsl:template>
	<!-- not real candidates, ignore -->
	<xsl:template match="eml:Candidate[eml:ProposalItem]" mode="global">
	</xsl:template>
	<xsl:template match="eml:Contest[eml:BallotChoices/eml:Candidate/eml:CandidateIdentifier or eml:WriteInCandidate]" mode="global">
		<cdf:Contest xsi:type="cdf:CandidateContest">
			<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_', eml:ContestIdentifier/@IdNumber)"/></xsl:attribute>
			<cdf:Code>
				<cdf:Type>local-level</cdf:Type>
				<cdf:Value>
					<xsl:value-of select="eml:ContestIdentifier/@IdNumber"/>
				</cdf:Value>
			</cdf:Code>
			<xsl:for-each select="eml:BallotChoices/eml:Candidate">
				<cdf:ContestSelection xsi:type="cdf:CandidateSelection">
					<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_CS', eml:CandidateIdentifier/@IdNumber)"/></xsl:attribute>
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
	<xsl:template match="eml:Contest[eml:BallotChoices/eml:Affiliation]" mode="global">
		<cdf:Contest xsi:type="cdf:PartyContest">
			<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_', eml:ContestIdentifier/@IdNumber)"/></xsl:attribute>
			<cdf:Code>
				<cdf:Type>local-level</cdf:Type>
				<cdf:Value>
					<xsl:value-of select="eml:ContestIdentifier/@IdNumber"/>
				</cdf:Value>
			</cdf:Code>
			<xsl:for-each select="eml:BallotChoices/eml:Affiliation">
				<cdf:ContestSelection xsi:type="cdf:PartySelection">
					<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_CS', eml:AffiliationIdentifier/eml:RegisteredName)"/></xsl:attribute>
					<cdf:PartyIds>
						<xsl:value-of select="concat('_', eml:AffiliationIdentifier/eml:RegisteredName)"/>
					</cdf:PartyIds>
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
		</cdf:Contest>
	</xsl:template>
	<xsl:template match="eml:Contest[eml:BallotChoices/eml:Candidate/eml:ProposalItem]" mode="global">
		<cdf:Contest xsi:type="cdf:BallotMeasureContest">
			<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_', eml:ContestIdentifier/@IdNumber)"/></xsl:attribute>
			<cdf:Code>
				<cdf:Type>local-level</cdf:Type>
				<cdf:Value>
					<xsl:value-of select="eml:ContestIdentifier/@IdNumber"/>
				</cdf:Value>
			</cdf:Code>
			<xsl:for-each select="eml:BallotChoices/eml:Candidate/eml:ProposalItem">
				<cdf:ContestSelection xsi:type="cdf:BallotMeasureSelection">
					<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_CS', @ReferendumOptionIdentifier)"/></xsl:attribute>
					<cdf:Selection>
						<xsl:value-of select="eml:SelectionText"/>
					</cdf:Selection>
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
		</cdf:Contest>
	</xsl:template>
	<!-- begin consumptive templates -->
	<xsl:template match="eml:EMLHeader"> </xsl:template>
	<xsl:template match="/eml:EML">
		<cdf:CastVoteRecordReport xsi:schemaLocation="NIST_V0_cast_vote_records.xsd file:///C:/Users/john/Documents/GitHub/CastVoteRecords/NIST_V0_cast_vote_records.xsd">
			<xsl:apply-templates/>
			<cdf:Election>
				<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_', eml:Ballots/eml:EventIdentifier/@IdNumber)"/></xsl:attribute>
				<xsl:apply-templates select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest/eml:BallotChoices/eml:Candidate" mode="global"> </xsl:apply-templates>
				<cdf:Code>
					<cdf:Type>local-level</cdf:Type>
					<cdf:Value>
						<xsl:value-of select="eml:Ballots/eml:Ballot/eml:Election/eml:ElectionIdentifier/@IdNumber"/>
					</cdf:Value>
				</cdf:Code>
				<xsl:apply-templates select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest" mode="global"> </xsl:apply-templates>
				<cdf:ElectionScopeId>gpu-precinct</cdf:ElectionScopeId>
				<cdf:Name>
					<xsl:value-of select="eml:Ballots/eml:Ballot/eml:Election/eml:ElectionIdentifier/eml:ElectionName"/>
				</cdf:Name>
			</cdf:Election>
			<!-- XSL 1.0 doesn't have date function -->
			<cdf:GeneratedDate>2018-07-15T00:00:00Z</cdf:GeneratedDate>
			<cdf:GpUnit ObjectId="gpu-precinct">
				<cdf:Code>
					<cdf:Type>local-level</cdf:Type>
					<cdf:Value>
						<xsl:value-of select="eml:Ballots/eml:Ballot/eml:ReportingUnitIdentifier/@IdNumber"/>
					</cdf:Value>
				</cdf:Code>
				<cdf:Type>precinct</cdf:Type>
			</cdf:GpUnit>
			<cdf:Notes>Example using the NIST CVR CDF</cdf:Notes>
			<xsl:for-each select="eml:Ballots/eml:Ballot/eml:Election/eml:Contest/eml:BallotChoices/eml:Candidate/eml:Affiliation/eml:AffiliationIdentifier[count(. | key('party-by-name', eml:RegisteredName)[1]) = 1]">
				<cdf:Party>
					<xsl:attribute name="ObjectId"><xsl:value-of select="concat('_', eml:RegisteredName)"/></xsl:attribute>
					<cdf:Name>
						<xsl:value-of select="eml:RegisteredName"/>
					</cdf:Name>
				</cdf:Party>
			</xsl:for-each>
			<cdf:ReportGeneratingDeviceIds>rd</cdf:ReportGeneratingDeviceIds>
			<cdf:ReportingDevice ObjectId="rd">
				<cdf:Application>Ballot Marker</cdf:Application>
				<cdf:Manufacturer>Hilton Roscoe LLC</cdf:Manufacturer>
			</cdf:ReportingDevice>
			<cdf:ReportType>originating-device-export</cdf:ReportType>
			<cdf:Version>1.0.0</cdf:Version>
		</cdf:CastVoteRecordReport>
	</xsl:template>
	<!-- generate a CVR for every eml:Ballot -->
	<xsl:template match="eml:Ballots/eml:Ballot">
		<cdf:CVR>
			<cdf:BallotStyleId>
				<xsl:value-of select="concat('_', eml:BallotIdentifier/@IdNumber)"/>
			</cdf:BallotStyleId>
			<cdf:CreatingDeviceId>rd</cdf:CreatingDeviceId>
			<!-- only one snapshot when coming from BMD -->
			<cdf:CurrentSnapshotId>
				<xsl:value-of select="generate-id(current())"/>
			</cdf:CurrentSnapshotId>
			<cdf:CVRSnapshot>
				<xsl:attribute name="ObjectId"><xsl:value-of select="generate-id(current())"/></xsl:attribute>
				<xsl:apply-templates select="eml:Election/eml:Contest"/>
				<cdf:Type>original</cdf:Type>
			</cdf:CVRSnapshot>
			<cdf:ElectionId>
				<xsl:value-of select="concat('_', ../eml:EventIdentifier/@IdNumber)"/>
			</cdf:ElectionId>
		</cdf:CVR>
	</xsl:template>
	<xsl:template match="eml:Contest">
		<cdf:CVRContest>
			<cdf:ContestId>
				<xsl:value-of select="concat('_', eml:ContestIdentifier/@IdNumber)"/>
			</cdf:ContestId>
			<!-- only catches overvotes for plurality voting -->
			<xsl:variable name="maxMinusIndication" select="eml:MaxVotes - count(eml:BallotChoices/*[self::eml:Candidate or self::eml:WriteInCandidate][eml:Selected != ''])"/>
			<xsl:variable name="TotalIndication" select="count(eml:BallotChoices/*[self::eml:Candidate or self::eml:WriteInCandidate][eml:Selected != ''])"/>
			<xsl:variable name="isOvervoted" select="eml:VotingMethod = 'FPP' and 0 > $maxMinusIndication"/>
			<xsl:apply-templates select="eml:BallotChoices/*[self::eml:Candidate or self::eml:WriteInCandidate]">
				<xsl:with-param name="isOvervoted" select="$isOvervoted"/>
			</xsl:apply-templates>
			<!-- only emit Overvotes / Undervotes for FPP contests -->
			<xsl:if test="eml:VotingMethod = 'FPP'">
				<cdf:Overvotes>
					<xsl:choose>
						<xsl:when test="$maxMinusIndication >= 0">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="eml:MaxVotes"/>
						</xsl:otherwise>
					</xsl:choose>
				</cdf:Overvotes>
			</xsl:if>
			<cdf:Undervotes>
				<xsl:choose>
					<xsl:when test="$maxMinusIndication >= 0">
						<xsl:value-of select="$maxMinusIndication"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</cdf:Undervotes>
		</cdf:CVRContest>
	</xsl:template>
	<xsl:template match="eml:Candidate|eml:WriteInCandidate">
		<xsl:param name="isOvervoted"/>
		<!-- only emit selection when an indication exists -->
		<xsl:if test="eml:Selected != '' and eml:Selected != 'false'">
			<cdf:CVRContestSelection>
				<!-- do not emit for writeins -->
				<xsl:if test="eml:CandidateIdentifier/@IdNumber|eml:ProposalItem/@ReferendumOptionIdentifier">
					<cdf:ContestSelectionId>
						<xsl:value-of select="concat('_CS', eml:CandidateIdentifier/@IdNumber|eml:ProposalItem/@ReferendumOptionIdentifier)"/>
					</cdf:ContestSelectionId>
				</xsl:if>
				<cdf:OptionPosition>
					<xsl:value-of select="position()"/>
				</cdf:OptionPosition>
				<cdf:SelectionPosition>
					<xsl:if test="name() = 'WriteInCandidate'">
						<cdf:CVRWriteIn>
							<cdf:Text>
								<xsl:value-of select="eml:Name"/>
							</cdf:Text>
						</cdf:CVRWriteIn>
					</xsl:if>
					<!-- always true for BMDs / DREs -->
					<cdf:HasIndication>
						<xsl:choose>
							<xsl:when test="eml:Selected != '' and eml:Selected != 'false'">yes</xsl:when>
							<xsl:otherwise>no</xsl:otherwise>
						</xsl:choose>
					</cdf:HasIndication>
					<cdf:IsAllocable>
						<xsl:choose>
							<xsl:when test="eml:Selected != '' and $isOvervoted = false() and eml:CandidateIdentifier/@IdNumber|eml:ProposalItem/@ReferendumOptionIdentifier">yes</xsl:when>
							<xsl:when test="eml:Selected != '' and $isOvervoted = false()">unknown</xsl:when>
							<xsl:otherwise>no</xsl:otherwise>
						</xsl:choose>
					</cdf:IsAllocable>
					<cdf:NumberVotes>1</cdf:NumberVotes>
					<xsl:if test="eml:Selected and eml:Selected != 'true' and eml:Selected != 'false'">
						<cdf:Rank>
							<xsl:value-of select="eml:Selected"/>
						</cdf:Rank>
					</xsl:if>
				</cdf:SelectionPosition>
				<cdf:TotalNumberVotes>
					<xsl:choose>
						<xsl:when test="eml:Selected != '' and $isOvervoted = false()">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</cdf:TotalNumberVotes>
			</cdf:CVRContestSelection>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
