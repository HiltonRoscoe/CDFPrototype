<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="file:///C:/Users/john/Documents/GitHub/CDFPrototype/CVR/xml/testdeck.xsd">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<CastVoteRecordReport>
			<xsl:apply-templates/>
			<Election ObjectId="elec-001">
				<Contest xsi:type="CandidateContest" ObjectId="contest-001">
					<ContestSelection ObjectId="sel-A"/>
					<ContestSelection ObjectId="sel-B"/>
					<ContestSelection ObjectId="sel-C"/>
					<ContestSelection ObjectId="sel-D"/>
				</Contest>
				<ElectionScopeId>gpu-001</ElectionScopeId>
			</Election>
			<GeneratedDate>2018-11-21T00:00:00</GeneratedDate>
			<GpUnit ObjectId="gpu-001">				
				<OtherType>election scope gpunit</OtherType>
				<Type>other</Type>
			</GpUnit>			
			<ReportGeneratingDeviceIds>rd-001</ReportGeneratingDeviceIds>
			<ReportingDevice ObjectId="rd-001"/>
			<Version>1.0.0</Version>
		</CastVoteRecordReport>
	</xsl:template>
	<xsl:template match="Ballot">
		<CVR>
			<BallotNumber>
				<xsl:value-of select="Name"/>
			</BallotNumber>			
			<CurrentSnapshotId>
				<xsl:value-of select="concat('ballot-', Name)"/>
			</CurrentSnapshotId>
			<CVRSnapshot>
				<xsl:attribute name="ObjectId"><xsl:value-of select="concat('ballot-', Name)"/></xsl:attribute>
				<xsl:apply-templates select="Contest"/>
				<Type>original</Type>
			</CVRSnapshot>
			<ElectionId>elec-001</ElectionId>
		</CVR>
	</xsl:template>
	<xsl:template match="Contest">
		<CVRContest>
			<ContestId>contest-001</ContestId>
			<xsl:if test="first != ''">
				<CVRContestSelection>
					<ContestSelectionId>
						<xsl:value-of select="concat('sel-', first)"/>
					</ContestSelectionId>
					<SelectionPosition>
						<HasIndication>yes</HasIndication>
						<IsAllocable>
							<xsl:choose>
								<xsl:when test="first/@status = 'active'">yes</xsl:when>
								<xsl:otherwise>no</xsl:otherwise>
							</xsl:choose>
						</IsAllocable>
						<NumberVotes>1</NumberVotes>
						<Rank>1</Rank>
					</SelectionPosition>
				</CVRContestSelection>
			</xsl:if>
			<xsl:if test="second != ''">
				<CVRContestSelection>
					<ContestSelectionId>
						<xsl:value-of select="concat('sel-', second)"/>
					</ContestSelectionId>
					<SelectionPosition>
						<HasIndication>yes</HasIndication>
						<IsAllocable>
							<xsl:choose>
								<xsl:when test="second/@status = 'active'">yes</xsl:when>
								<xsl:otherwise>no</xsl:otherwise>
							</xsl:choose>
						</IsAllocable>
						<NumberVotes>1</NumberVotes>
						<Rank>2</Rank>
					</SelectionPosition>
				</CVRContestSelection>
			</xsl:if>
			<xsl:if test="third != ''">
				<CVRContestSelection>
					<ContestSelectionId>
						<xsl:value-of select="concat('sel-', third)"/>
					</ContestSelectionId>
					<SelectionPosition>
						<HasIndication>yes</HasIndication>
						<IsAllocable>
							<xsl:choose>
								<xsl:when test="third/@status = 'active'">yes</xsl:when>
								<xsl:otherwise>no</xsl:otherwise>
							</xsl:choose>
						</IsAllocable>
						<NumberVotes>1</NumberVotes>
						<Rank>3</Rank>
					</SelectionPosition>
				</CVRContestSelection>
			</xsl:if>
			<xsl:if test="fourth != ''">
				<CVRContestSelection>
					<ContestSelectionId>
						<xsl:value-of select="concat('sel-', fourth)"/>
					</ContestSelectionId>
					<SelectionPosition>
						<HasIndication>yes</HasIndication>
						<IsAllocable>
							<xsl:choose>
								<xsl:when test="fourth/@status = 'active'">yes</xsl:when>
								<xsl:otherwise>no</xsl:otherwise>
							</xsl:choose>
						</IsAllocable>
						<NumberVotes>1</NumberVotes>
						<Rank>4</Rank>
					</SelectionPosition>
				</CVRContestSelection>
			</xsl:if>
		</CVRContest>
	</xsl:template>
</xsl:stylesheet>
