<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:oxy="http://www.oxygenxml.com/schematron/validation"
                xmlns:err="NIST_V2_election_results_reporting.xsd"
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
                      schema-location="file:///C:/Users/john/Documents/GitHub/ElectionResultsReporting/NIST_V2_election_results_reporting.xsd"/>

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
   <xsl:template match="element(*, err:BallotStyle)" priority="1023" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:GpUnitIds)[not(. instance of element(*, err:GpUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>GpUnitIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:GpUnitIds"/>
               <xsl:text>) must point to an element of type GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:PartyIds)[not(. instance of element(*, err:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:PartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Candidate)" priority="1022" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'CandidateIds' and .. instance of element(*, err:CandidateSelection)) or (name() = 'CandidateId' and .. instance of element(*, err:RetentionContest))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Candidate (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'CandidateIds' and .. instance of element(*, err:CandidateSelection), name() = 'CandidateId' and .. instance of element(*, err:RetentionContest)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:PartyId)[not(. instance of element(*, err:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:PartyId"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:PersonId)[not(. instance of element(*, err:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PersonId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:PersonId"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:CandidateContest)" priority="1021" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:OfficeIds)[not(. instance of element(*, err:Office))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OfficeIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:OfficeIds"/>
               <xsl:text>) must point to an element of type Office</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:PrimaryPartyIds)[not(. instance of element(*, err:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PrimaryPartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:PrimaryPartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:CandidateSelection)"
                 priority="1020"
                 mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:CandidateIds)[not(. instance of element(*, err:Candidate))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>CandidateIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:CandidateIds"/>
               <xsl:text>) must point to an element of type Candidate</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:EndorsementPartyIds)[not(. instance of element(*, err:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>EndorsementPartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:EndorsementPartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Coalition)" priority="1019" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:PartyIds)[not(. instance of element(*, err:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:PartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:ContestIds)[not(. instance of element(*, err:Contest))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ContestIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:ContestIds"/>
               <xsl:text>) must point to an element of type Contest</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Contest)" priority="1018" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'ContestId' and .. instance of element(*, err:OrderedContest)) or (name() = 'ContestIds' and .. instance of element(*, err:Coalition)) or (name() = 'Id' and .. instance of element(*, err:ReportingUnit))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Contest (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'ContestId' and .. instance of element(*, err:OrderedContest), name() = 'ContestIds' and .. instance of element(*, err:Coalition), name() = 'Id' and .. instance of element(*, err:ReportingUnit)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:ContestSelection)" priority="1017" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'OrderedContestSelectionIds' and .. instance of element(*, err:OrderedContest)) or (name() = 'Id' and .. instance of element(*, err:VoteCounts))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ContestSelection (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'OrderedContestSelectionIds' and .. instance of element(*, err:OrderedContest), name() = 'Id' and .. instance of element(*, err:VoteCounts)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Counts)" priority="1016" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:GpUnitId)[not(. instance of element(*, err:GpUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>GpUnitId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:GpUnitId"/>
               <xsl:text>) must point to an element of type GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Election)" priority="1015" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:ElectionScopeId)[not(. instance of element(*, err:ReportingUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ElectionScopeId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:ElectionScopeId"/>
               <xsl:text>) must point to an element of type ReportingUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:ElectionAdministration)"
                 priority="1014"
                 mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:ElectionOfficialPersonIds)[not(. instance of element(*, err:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ElectionOfficialPersonIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:ElectionOfficialPersonIds"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:GpUnit)" priority="1013" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'ComposingGpUnitIds' and .. instance of element(*, err:GpUnit)) or (name() = 'GpUnitId' and .. instance of element(*, err:OtherCounts)) or (name() = 'GpUnitIds' and .. instance of element(*, err:BallotStyle)) or (name() = 'GpUnitId' and .. instance of element(*, err:Counts))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>GpUnit (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'ComposingGpUnitIds' and .. instance of element(*, err:GpUnit), name() = 'GpUnitId' and .. instance of element(*, err:OtherCounts), name() = 'GpUnitIds' and .. instance of element(*, err:BallotStyle), name() = 'GpUnitId' and .. instance of element(*, err:Counts)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:ComposingGpUnitIds)[not(. instance of element(*, err:GpUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ComposingGpUnitIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:ComposingGpUnitIds"/>
               <xsl:text>) must point to an element of type GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Header)" priority="1012" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'HeaderId' and .. instance of element(*, err:OrderedHeader))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Header (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'HeaderId' and .. instance of element(*, err:OrderedHeader)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Office)" priority="1011" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'OfficeIds' and .. instance of element(*, err:CandidateContest)) or (name() = 'OfficeId' and .. instance of element(*, err:RetentionContest)) or (name() = 'OfficeIds' and .. instance of element(*, err:OfficeGroup))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Office (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'OfficeIds' and .. instance of element(*, err:CandidateContest), name() = 'OfficeId' and .. instance of element(*, err:RetentionContest), name() = 'OfficeIds' and .. instance of element(*, err:OfficeGroup)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:OfficeHolderPersonIds)[not(. instance of element(*, err:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OfficeHolderPersonIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:OfficeHolderPersonIds"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:ElectionDistrictId)[not(. instance of element(*, err:ReportingUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ElectionDistrictId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:ElectionDistrictId"/>
               <xsl:text>) must point to an element of type ReportingUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:OfficeGroup)" priority="1010" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:OfficeIds)[not(. instance of element(*, err:Office))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OfficeIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:OfficeIds"/>
               <xsl:text>) must point to an element of type Office</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:OrderedContest)" priority="1009" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:OrderedContestSelectionIds)[not(. instance of element(*, err:ContestSelection))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OrderedContestSelectionIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:OrderedContestSelectionIds"/>
               <xsl:text>) must point to an element of type ContestSelection</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:ContestId)[not(. instance of element(*, err:Contest))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ContestId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:ContestId"/>
               <xsl:text>) must point to an element of type Contest</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:OrderedHeader)" priority="1008" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:HeaderId)[not(. instance of element(*, err:Header))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>HeaderId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:HeaderId"/>
               <xsl:text>) must point to an element of type Header</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:OtherCounts)" priority="1007" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:GpUnitId)[not(. instance of element(*, err:GpUnit))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>GpUnitId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:GpUnitId"/>
               <xsl:text>) must point to an element of type GpUnit</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Party)" priority="1006" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'PartyIds' and .. instance of element(*, err:Coalition)) or (name() = 'EndorsementPartyIds' and .. instance of element(*, err:CandidateSelection)) or (name() = 'PartyId' and .. instance of element(*, err:Candidate)) or (name() = 'PartyId' and .. instance of element(*, err:Person)) or (name() = 'PrimaryPartyIds' and .. instance of element(*, err:CandidateContest)) or (name() = 'PartyIds' and .. instance of element(*, err:BallotStyle)) or (name() = 'PartyIds' and .. instance of element(*, err:PartySelection)) or (name() = 'PartyId' and .. instance of element(*, err:PartyRegistration))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Party (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'PartyIds' and .. instance of element(*, err:Coalition), name() = 'EndorsementPartyIds' and .. instance of element(*, err:CandidateSelection), name() = 'PartyId' and .. instance of element(*, err:Candidate), name() = 'PartyId' and .. instance of element(*, err:Person), name() = 'PrimaryPartyIds' and .. instance of element(*, err:CandidateContest), name() = 'PartyIds' and .. instance of element(*, err:BallotStyle), name() = 'PartyIds' and .. instance of element(*, err:PartySelection), name() = 'PartyId' and .. instance of element(*, err:PartyRegistration)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:LeaderPersonIds)[not(. instance of element(*, err:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>LeaderPersonIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:LeaderPersonIds"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:PartyRegistration)" priority="1005" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:PartyId)[not(. instance of element(*, err:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:PartyId"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:PartySelection)" priority="1004" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:PartyIds)[not(. instance of element(*, err:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:PartyIds"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:Person)" priority="1003" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'ElectionOfficialPersonIds' and .. instance of element(*, err:ElectionAdministration)) or (name() = 'OfficeHolderPersonIds' and .. instance of element(*, err:Office)) or (name() = 'LeaderPersonIds' and .. instance of element(*, err:Party)) or (name() = 'AuthorityIds' and .. instance of element(*, err:ReportingUnit)) or (name() = 'PersonId' and .. instance of element(*, err:Candidate))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Person (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'ElectionOfficialPersonIds' and .. instance of element(*, err:ElectionAdministration), name() = 'OfficeHolderPersonIds' and .. instance of element(*, err:Office), name() = 'LeaderPersonIds' and .. instance of element(*, err:Party), name() = 'AuthorityIds' and .. instance of element(*, err:ReportingUnit), name() = 'PersonId' and .. instance of element(*, err:Candidate)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:PartyId)[not(. instance of element(*, err:Party))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>PartyId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:PartyId"/>
               <xsl:text>) must point to an element of type Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:ReportingUnit)" priority="1002" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(name() = 'ElectionDistrictId' and .. instance of element(*, err:Office)) or (name() = 'ElectionScopeId' and .. instance of element(*, err:Election))]) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>ReportingUnit (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="current()/@ObjectId"/>
               <xsl:text>) must have refereant from [name() = 'ElectionDistrictId' and .. instance of element(*, err:Office), name() = 'ElectionScopeId' and .. instance of element(*, err:Election)]</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:AuthorityIds)[not(. instance of element(*, err:Person))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>AuthorityIds (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:AuthorityIds"/>
               <xsl:text>) must point to an element of type Person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:Id)[not(. instance of element(*, err:Contest))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Id (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:Id"/>
               <xsl:text>) must point to an element of type Contest</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:RetentionContest)" priority="1001" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:OfficeId)[not(. instance of element(*, err:Office))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>OfficeId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:OfficeId"/>
               <xsl:text>) must point to an element of type Office</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:CandidateId)[not(. instance of element(*, err:Candidate))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>CandidateId (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:CandidateId"/>
               <xsl:text>) must point to an element of type Candidate</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="M3"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="element(*, err:VoteCounts)" priority="1000" mode="M3">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(err:Id)[not(. instance of element(*, err:ContestSelection))])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Id (</xsl:text>
               <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                             select="err:Id"/>
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
