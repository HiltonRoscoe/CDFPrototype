<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:cdf="http://itl.nist.gov/ns/voting/1500-103/v1"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->
   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <!--XSD TYPES FOR XSLT2-->
   <xsl:import-schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                      xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                      namespace="http://itl.nist.gov/ns/voting/1500-103/v1"
                      schema-location="https://raw.githubusercontent.com/usnistgov/CastVoteRecords/master/NIST_V0_cast_vote_records.xsd"/>
   <!--KEYS AND FUNCTIONS-->
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://itl.nist.gov/ns/voting/1500-103/v1" prefix="cdf"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M3"/>
      </svrl:schematron-output>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="element(*, cdf:Candidate)" priority="1015" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Candidate)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'CandidateIds' and .. instance of element(*, cdf:CandidateSelection)) or (local-name() = 'CandidateId' and .. instance of element(*, cdf:RetentionContest))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'CandidateIds' and .. instance of element(*, cdf:CandidateSelection)) or (local-name() = 'CandidateId' and .. instance of element(*, cdf:RetentionContest))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Candidate (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                CandidateSelection, RetentionContest</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyId)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:PartyId)[not(. instance of element(*, cdf:Party))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>PartyId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:PartyId"/>) must point to an element of type
                Party</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:CandidateContest)" priority="1014" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:CandidateContest)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PrimaryPartyId)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:PrimaryPartyId)[not(. instance of element(*, cdf:Party))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>PrimaryPartyId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:PrimaryPartyId"/>) must point to an
                element of type Party</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:CandidateSelection)"
                 priority="1013"
                 mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:CandidateSelection)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:CandidateIds)[not(. instance of element(*, cdf:Candidate))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:CandidateIds)[not(. instance of element(*, cdf:Candidate))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>CandidateIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:CandidateIds"/>) must point to an element
                of type Candidate</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:CastVoteRecordReport)"
                 priority="1012"
                 mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:CastVoteRecordReport)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ReportGeneratingDeviceIds)[not(. instance of element(*, cdf:ReportingDevice))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ReportGeneratingDeviceIds)[not(. instance of element(*, cdf:ReportingDevice))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ReportGeneratingDeviceIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ReportGeneratingDeviceIds"/>)
                must point to an element of type ReportingDevice</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Contest)" priority="1011" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Contest)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'ContestId' and .. instance of element(*, cdf:CVRContest))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'ContestId' and .. instance of element(*, cdf:CVRContest))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Contest (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                CVRContest</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:ContestSelection)" priority="1010" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:ContestSelection)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'ContestSelectionId' and .. instance of element(*, cdf:CVRContestSelection))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'ContestSelectionId' and .. instance of element(*, cdf:CVRContestSelection))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ContestSelection (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant
                from CVRContestSelection</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:CVR)" priority="1009" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="element(*, cdf:CVR)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:CreatingDeviceId)[not(. instance of element(*, cdf:ReportingDevice))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:CreatingDeviceId)[not(. instance of element(*, cdf:ReportingDevice))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>CreatingDeviceId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:CreatingDeviceId"/>) must point to an
                element of type ReportingDevice</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ElectionId)[not(. instance of element(*, cdf:Election))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ElectionId)[not(. instance of element(*, cdf:Election))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ElectionId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ElectionId"/>) must point to an element of
                type Election</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:CurrentSnapshotId)[not(. instance of element(*, cdf:CVRSnapshot))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:CurrentSnapshotId)[not(. instance of element(*, cdf:CVRSnapshot))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>CurrentSnapshotId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:CurrentSnapshotId"/>) must point to an
                element of type CVRSnapshot</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>PartyIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:PartyIds"/>) must point to an element of type
                Party</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:BallotStyleUnitId)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:BallotStyleUnitId)[not(. instance of element(*, cdf:GpUnit))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>BallotStyleUnitId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:BallotStyleUnitId"/>) must point to an
                element of type GpUnit</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:CVRContest)" priority="1008" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:CVRContest)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ContestId)[not(. instance of element(*, cdf:Contest))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ContestId)[not(. instance of element(*, cdf:Contest))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ContestId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ContestId"/>) must point to an element of type
                Contest</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:CVRContestSelection)"
                 priority="1007"
                 mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:CVRContestSelection)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ContestSelectionId)[not(. instance of element(*, cdf:ContestSelection))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ContestSelectionId)[not(. instance of element(*, cdf:ContestSelection))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ContestSelectionId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ContestSelectionId"/>) must point to
                an element of type ContestSelection</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:CVRSnapshot)" priority="1006" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:CVRSnapshot)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'CurrentSnapshotId' and .. instance of element(*, cdf:CVR))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'CurrentSnapshotId' and .. instance of element(*, cdf:CVR))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>CVRSnapshot (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                CVR</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Election)" priority="1005" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Election)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionId' and .. instance of element(*, cdf:CVR))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionId' and .. instance of element(*, cdf:CVR))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Election (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                CVR</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ElectionScopeId)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ElectionScopeId)[not(. instance of element(*, cdf:GpUnit))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ElectionScopeId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ElectionScopeId"/>) must point to an
                element of type GpUnit</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:GpUnit)" priority="1004" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:GpUnit)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionScopeId' and .. instance of element(*, cdf:Election)) or (local-name() = 'BallotStyleUnitId' and .. instance of element(*, cdf:CVR))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionScopeId' and .. instance of element(*, cdf:Election)) or (local-name() = 'BallotStyleUnitId' and .. instance of element(*, cdf:CVR))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>GpUnit (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                Election, CVR</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ReportingDeviceIds)[not(. instance of element(*, cdf:ReportingDevice))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ReportingDeviceIds)[not(. instance of element(*, cdf:ReportingDevice))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ReportingDeviceIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ReportingDeviceIds"/>) must point to
                an element of type ReportingDevice</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Party)" priority="1003" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="element(*, cdf:Party)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'PartyIds' and .. instance of element(*, cdf:PartySelection)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:CVR)) or (local-name() = 'PrimaryPartyId' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Candidate))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'PartyIds' and .. instance of element(*, cdf:PartySelection)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:CVR)) or (local-name() = 'PrimaryPartyId' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Candidate))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Party (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                PartySelection, CVR, CandidateContest, Candidate</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:PartySelection)" priority="1002" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:PartySelection)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>PartyIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:PartyIds"/>) must point to an element of type
                Party</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:ReportingDevice)" priority="1001" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:ReportingDevice)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'CreatingDeviceId' and .. instance of element(*, cdf:CVR)) or (local-name() = 'ReportingDeviceIds' and .. instance of element(*, cdf:GpUnit)) or (local-name() = 'ReportGeneratingDeviceIds' and .. instance of element(*, cdf:CastVoteRecordReport))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'CreatingDeviceId' and .. instance of element(*, cdf:CVR)) or (local-name() = 'ReportingDeviceIds' and .. instance of element(*, cdf:GpUnit)) or (local-name() = 'ReportGeneratingDeviceIds' and .. instance of element(*, cdf:CastVoteRecordReport))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ReportingDevice (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant
                from CVR, GpUnit, CastVoteRecordReport</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:RetentionContest)" priority="1000" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:RetentionContest)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:CandidateId)[not(. instance of element(*, cdf:Candidate))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:CandidateId)[not(. instance of element(*, cdf:Candidate))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>CandidateId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:CandidateId"/>) must point to an element of
                type Candidate</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M3"/>
   <xsl:template match="@*|node()" priority="-2" mode="M3">
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
</xsl:stylesheet>
