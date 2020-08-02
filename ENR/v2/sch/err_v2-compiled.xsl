<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:oxy="http://www.oxygenxml.com/schematron/validation"
                xmlns:cdf="NIST_V2_election_results_reporting.xsd"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                version="2.0"
                xml:base="file:/C:/Users/john/Documents/GitHub/CDFPrototype/ENR/v2/sch/err_v2.sch_xslt_cascade"><!--Implementers: please note that overriding process-prolog or process-root is 
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
   <xsl:output xmlns:iso="http://purl.oclc.org/dsdl/schematron" method="xml"/>

   <!--XSD TYPES FOR XSLT2-->
   <xsl:import-schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                      xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                      namespace="NIST_V2_election_results_reporting.xsd"
                      schema-location="https://raw.githubusercontent.com/usnistgov/ElectionResultsReporting/829995caa5e174038eb89aefd098d449acbdbd99/NIST_V2_election_results_reporting.xsd"/>

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
      <xsl:variable name="sameUri">
         <xsl:value-of select="saxon:system-id() = parent::node()/saxon:system-id()"
                       use-when="function-available('saxon:system-id')"/>
         <xsl:value-of select="oxy:system-id(.) = oxy:system-id(parent::node())"
                       use-when="not(function-available('saxon:system-id')) and function-available('oxy:system-id')"/>
         <xsl:value-of select="true()"
                       use-when="not(function-available('saxon:system-id')) and not(function-available('oxy:system-id'))"/>
      </xsl:variable>
      <xsl:if test="$sameUri = 'true'">
         <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      </xsl:if>
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
      <xsl:if test="$sameUri = 'true'">
         <xsl:variable name="preceding"
                       select="count(preceding-sibling::*[local-name()=local-name(current())       and namespace-uri() = namespace-uri(current())])"/>
         <xsl:text>[</xsl:text>
         <xsl:value-of select="1+ $preceding"/>
         <xsl:text>]</xsl:text>
      </xsl:if>
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

   <xsl:template match="text()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>text()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::text())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="comment()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>comment()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::comment())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>processing-instruction()</xsl:text>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::processing-instruction())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
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
      <xsl:apply-templates select="/" mode="M3"/>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="element(*, cdf:BallotStyle)" priority="1023" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:GpUnitIds)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>GpUnitIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:GpUnitIds"/>
               <xsl:text>) must point to an element of type GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:PartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Candidate)" priority="1022" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'CandidateIds' and .. instance of element(*, cdf:CandidateSelection)) or (local-name() = 'CandidateId' and .. instance of element(*, cdf:RetentionContest))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Candidate (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from CandidateSelection, RetentionContest</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PersonId)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PersonId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:PersonId"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyId)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:PartyId"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:CandidateContest)" priority="1021" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OfficeIds)[not(. instance of element(*, cdf:Office))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OfficeIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:OfficeIds"/>
               <xsl:text>) must point to an element of type Office</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PrimaryPartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PrimaryPartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:PrimaryPartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:CandidateSelection)"
                 priority="1020"
                 mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:EndorsementPartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>EndorsementPartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:EndorsementPartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:CandidateIds)[not(. instance of element(*, cdf:Candidate))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>CandidateIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:CandidateIds"/>
               <xsl:text>) must point to an element of type Candidate</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Coalition)" priority="1019" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ContestIds)[not(. instance of element(*, cdf:Contest))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ContestIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:ContestIds"/>
               <xsl:text>) must point to an element of type Contest</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:PartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Contest)" priority="1018" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'ContestIds' and .. instance of element(*, cdf:Coalition)) or (local-name() = 'Id' and .. instance of element(*, cdf:ReportingUnit)) or (local-name() = 'ContestId' and .. instance of element(*, cdf:OrderedContest))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Contest (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from Coalition, ReportingUnit, OrderedContest</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:ContestSelection)" priority="1017" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'OrderedContestSelectionIds' and .. instance of element(*, cdf:OrderedContest)) or (local-name() = 'Id' and .. instance of element(*, cdf:VoteCounts))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ContestSelection (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from OrderedContest, VoteCounts</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Counts)" priority="1016" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:GpUnitId)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>GpUnitId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:GpUnitId"/>
               <xsl:text>) must point to an element of type GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Election)" priority="1015" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ElectionScopeId)[not(. instance of element(*, cdf:ReportingUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ElectionScopeId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:ElectionScopeId"/>
               <xsl:text>) must point to an element of type ReportingUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:ElectionAdministration)"
                 priority="1014"
                 mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ElectionOfficialPersonIds)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ElectionOfficialPersonIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:ElectionOfficialPersonIds"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:GpUnit)" priority="1013" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'GpUnitIds' and .. instance of element(*, cdf:BallotStyle)) or (local-name() = 'GpUnitId' and .. instance of element(*, cdf:OtherCounts)) or (local-name() = 'GpUnitId' and .. instance of element(*, cdf:Counts)) or (local-name() = 'ComposingGpUnitIds' and .. instance of element(*, cdf:GpUnit))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>GpUnit (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from BallotStyle, OtherCounts, Counts, GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ComposingGpUnitIds)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ComposingGpUnitIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:ComposingGpUnitIds"/>
               <xsl:text>) must point to an element of type GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Header)" priority="1012" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'HeaderId' and .. instance of element(*, cdf:OrderedHeader))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Header (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from OrderedHeader</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Office)" priority="1011" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'OfficeId' and .. instance of element(*, cdf:RetentionContest)) or (local-name() = 'OfficeIds' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'OfficeIds' and .. instance of element(*, cdf:OfficeGroup))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Office (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from RetentionContest, CandidateContest, OfficeGroup</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ElectionDistrictId)[not(. instance of element(*, cdf:ReportingUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ElectionDistrictId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:ElectionDistrictId"/>
               <xsl:text>) must point to an element of type ReportingUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OfficeHolderPersonIds)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OfficeHolderPersonIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:OfficeHolderPersonIds"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:OfficeGroup)" priority="1010" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OfficeIds)[not(. instance of element(*, cdf:Office))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OfficeIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:OfficeIds"/>
               <xsl:text>) must point to an element of type Office</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:OrderedContest)" priority="1009" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OrderedContestSelectionIds)[not(. instance of element(*, cdf:ContestSelection))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OrderedContestSelectionIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:OrderedContestSelectionIds"/>
               <xsl:text>) must point to an element of type ContestSelection</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ContestId)[not(. instance of element(*, cdf:Contest))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ContestId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:ContestId"/>
               <xsl:text>) must point to an element of type Contest</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:OrderedHeader)" priority="1008" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:HeaderId)[not(. instance of element(*, cdf:Header))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>HeaderId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:HeaderId"/>
               <xsl:text>) must point to an element of type Header</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:OtherCounts)" priority="1007" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:GpUnitId)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>GpUnitId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:GpUnitId"/>
               <xsl:text>) must point to an element of type GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Party)" priority="1006" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'EndorsementPartyIds' and .. instance of element(*, cdf:CandidateSelection)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:PartySelection)) or (local-name() = 'PrimaryPartyIds' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:BallotStyle)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:Coalition)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Candidate)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Person)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:PartyRegistration))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Party (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from CandidateSelection, PartySelection, CandidateContest, BallotStyle, Coalition, Candidate, Person, PartyRegistration</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:LeaderPersonIds)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>LeaderPersonIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:LeaderPersonIds"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:PartyRegistration)" priority="1005" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyId)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:PartyId"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:PartySelection)" priority="1004" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:PartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:Person)" priority="1003" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'PersonId' and .. instance of element(*, cdf:Candidate)) or (local-name() = 'LeaderPersonIds' and .. instance of element(*, cdf:Party)) or (local-name() = 'ElectionOfficialPersonIds' and .. instance of element(*, cdf:ElectionAdministration)) or (local-name() = 'AuthorityIds' and .. instance of element(*, cdf:ReportingUnit)) or (local-name() = 'OfficeHolderPersonIds' and .. instance of element(*, cdf:Office))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Person (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from Candidate, Party, ElectionAdministration, ReportingUnit, Office</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PartyId)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:PartyId"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:ReportingUnit)" priority="1002" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionDistrictId' and .. instance of element(*, cdf:Office)) or (local-name() = 'ElectionScopeId' and .. instance of element(*, cdf:Election))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ReportingUnit (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from Office, Election</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:AuthorityIds)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>AuthorityIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:AuthorityIds"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:Id)[not(. instance of element(*, cdf:Contest))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Id (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:Id"/>
               <xsl:text>) must point to an element of type Contest</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:RetentionContest)" priority="1001" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OfficeId)[not(. instance of element(*, cdf:Office))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OfficeId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:OfficeId"/>
               <xsl:text>) must point to an element of type Office</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:CandidateId)[not(. instance of element(*, cdf:Candidate))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>CandidateId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:CandidateId"/>
               <xsl:text>) must point to an element of type Candidate</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, cdf:VoteCounts)" priority="1000" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:Id)[not(. instance of element(*, cdf:ContestSelection))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Id (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="cdf:Id"/>
               <xsl:text>) must point to an element of type ContestSelection</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M3"/>
   <xsl:template match="@*|node()" priority="-2" mode="M3">
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>
</xsl:stylesheet>
