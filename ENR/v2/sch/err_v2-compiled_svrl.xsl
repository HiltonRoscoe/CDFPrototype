<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:cdf="NIST_V2_election_results_reporting.xsd"
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
         <svrl:ns-prefix-in-attribute-values uri="NIST_V2_election_results_reporting.xsd" prefix="cdf"/>
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
   <xsl:template match="element(*, cdf:BallotStyle)" priority="1023" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:BallotStyle)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:GpUnitIds)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:GpUnitIds)[not(. instance of element(*, cdf:GpUnit))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>GpUnitIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:GpUnitIds"/>) must point to an element of type
                GpUnit</svrl:text>
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
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Candidate)" priority="1022" mode="M3">
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
         <xsl:when test="not(id(cdf:PersonId)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:PersonId)[not(. instance of element(*, cdf:Person))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>PersonId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:PersonId"/>) must point to an element of type
                Person</svrl:text>
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
   <xsl:template match="element(*, cdf:CandidateContest)" priority="1021" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:CandidateContest)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OfficeIds)[not(. instance of element(*, cdf:Office))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:OfficeIds)[not(. instance of element(*, cdf:Office))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>OfficeIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:OfficeIds"/>) must point to an element of type
                Office</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:PrimaryPartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:PrimaryPartyIds)[not(. instance of element(*, cdf:Party))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>PrimaryPartyIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:PrimaryPartyIds"/>) must point to an
                element of type Party</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:CandidateSelection)"
                 priority="1020"
                 mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:CandidateSelection)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:EndorsementPartyIds)[not(. instance of element(*, cdf:Party))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:EndorsementPartyIds)[not(. instance of element(*, cdf:Party))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>EndorsementPartyIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:EndorsementPartyIds"/>) must point
                to an element of type Party</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
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
   <xsl:template match="element(*, cdf:Coalition)" priority="1019" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Coalition)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ContestIds)[not(. instance of element(*, cdf:Contest))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ContestIds)[not(. instance of element(*, cdf:Contest))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ContestIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ContestIds"/>) must point to an element of
                type Contest</svrl:text>
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
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Contest)" priority="1018" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Contest)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'ContestIds' and .. instance of element(*, cdf:Coalition)) or (local-name() = 'Id' and .. instance of element(*, cdf:ReportingUnit)) or (local-name() = 'ContestId' and .. instance of element(*, cdf:OrderedContest))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'ContestIds' and .. instance of element(*, cdf:Coalition)) or (local-name() = 'Id' and .. instance of element(*, cdf:ReportingUnit)) or (local-name() = 'ContestId' and .. instance of element(*, cdf:OrderedContest))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Contest (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                Coalition, ReportingUnit, OrderedContest</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:ContestSelection)" priority="1017" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:ContestSelection)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'OrderedContestSelectionIds' and .. instance of element(*, cdf:OrderedContest)) or (local-name() = 'Id' and .. instance of element(*, cdf:VoteCounts))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'OrderedContestSelectionIds' and .. instance of element(*, cdf:OrderedContest)) or (local-name() = 'Id' and .. instance of element(*, cdf:VoteCounts))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ContestSelection (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant
                from OrderedContest, VoteCounts</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Counts)" priority="1016" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Counts)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:GpUnitId)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:GpUnitId)[not(. instance of element(*, cdf:GpUnit))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>GpUnitId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:GpUnitId"/>) must point to an element of type
                GpUnit</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Election)" priority="1015" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Election)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ElectionScopeId)[not(. instance of element(*, cdf:ReportingUnit))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ElectionScopeId)[not(. instance of element(*, cdf:ReportingUnit))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ElectionScopeId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ElectionScopeId"/>) must point to an
                element of type ReportingUnit</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:ElectionAdministration)"
                 priority="1014"
                 mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:ElectionAdministration)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ElectionOfficialPersonIds)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ElectionOfficialPersonIds)[not(. instance of element(*, cdf:Person))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ElectionOfficialPersonIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ElectionOfficialPersonIds"/>)
                must point to an element of type Person</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:GpUnit)" priority="1013" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:GpUnit)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'GpUnitIds' and .. instance of element(*, cdf:BallotStyle)) or (local-name() = 'GpUnitId' and .. instance of element(*, cdf:OtherCounts)) or (local-name() = 'GpUnitId' and .. instance of element(*, cdf:Counts)) or (local-name() = 'ComposingGpUnitIds' and .. instance of element(*, cdf:GpUnit))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'GpUnitIds' and .. instance of element(*, cdf:BallotStyle)) or (local-name() = 'GpUnitId' and .. instance of element(*, cdf:OtherCounts)) or (local-name() = 'GpUnitId' and .. instance of element(*, cdf:Counts)) or (local-name() = 'ComposingGpUnitIds' and .. instance of element(*, cdf:GpUnit))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>GpUnit (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                BallotStyle, OtherCounts, Counts, GpUnit</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ComposingGpUnitIds)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ComposingGpUnitIds)[not(. instance of element(*, cdf:GpUnit))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ComposingGpUnitIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ComposingGpUnitIds"/>) must point to
                an element of type GpUnit</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Header)" priority="1012" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Header)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'HeaderId' and .. instance of element(*, cdf:OrderedHeader))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'HeaderId' and .. instance of element(*, cdf:OrderedHeader))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Header (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                OrderedHeader</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Office)" priority="1011" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Office)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'OfficeId' and .. instance of element(*, cdf:RetentionContest)) or (local-name() = 'OfficeIds' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'OfficeIds' and .. instance of element(*, cdf:OfficeGroup))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'OfficeId' and .. instance of element(*, cdf:RetentionContest)) or (local-name() = 'OfficeIds' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'OfficeIds' and .. instance of element(*, cdf:OfficeGroup))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Office (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                RetentionContest, CandidateContest, OfficeGroup</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:ElectionDistrictId)[not(. instance of element(*, cdf:ReportingUnit))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:ElectionDistrictId)[not(. instance of element(*, cdf:ReportingUnit))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ElectionDistrictId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:ElectionDistrictId"/>) must point to
                an element of type ReportingUnit</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OfficeHolderPersonIds)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:OfficeHolderPersonIds)[not(. instance of element(*, cdf:Person))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>OfficeHolderPersonIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:OfficeHolderPersonIds"/>) must
                point to an element of type Person</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:OfficeGroup)" priority="1010" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:OfficeGroup)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OfficeIds)[not(. instance of element(*, cdf:Office))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:OfficeIds)[not(. instance of element(*, cdf:Office))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>OfficeIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:OfficeIds"/>) must point to an element of type
                Office</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:OrderedContest)" priority="1009" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:OrderedContest)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OrderedContestSelectionIds)[not(. instance of element(*, cdf:ContestSelection))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:OrderedContestSelectionIds)[not(. instance of element(*, cdf:ContestSelection))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>OrderedContestSelectionIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:OrderedContestSelectionIds"/>) must point to an element of type ContestSelection</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
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
   <xsl:template match="element(*, cdf:OrderedHeader)" priority="1008" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:OrderedHeader)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:HeaderId)[not(. instance of element(*, cdf:Header))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:HeaderId)[not(. instance of element(*, cdf:Header))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>HeaderId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:HeaderId"/>) must point to an element of type
                Header</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:OtherCounts)" priority="1007" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:OtherCounts)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:GpUnitId)[not(. instance of element(*, cdf:GpUnit))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:GpUnitId)[not(. instance of element(*, cdf:GpUnit))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>GpUnitId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:GpUnitId"/>) must point to an element of type
                GpUnit</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:Party)" priority="1006" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="element(*, cdf:Party)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'EndorsementPartyIds' and .. instance of element(*, cdf:CandidateSelection)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:PartySelection)) or (local-name() = 'PrimaryPartyIds' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:BallotStyle)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:Coalition)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Candidate)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Person)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:PartyRegistration))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'EndorsementPartyIds' and .. instance of element(*, cdf:CandidateSelection)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:PartySelection)) or (local-name() = 'PrimaryPartyIds' and .. instance of element(*, cdf:CandidateContest)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:BallotStyle)) or (local-name() = 'PartyIds' and .. instance of element(*, cdf:Coalition)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Candidate)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:Person)) or (local-name() = 'PartyId' and .. instance of element(*, cdf:PartyRegistration))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Party (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                CandidateSelection, PartySelection, CandidateContest, BallotStyle, Coalition,
                Candidate, Person, PartyRegistration</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:LeaderPersonIds)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:LeaderPersonIds)[not(. instance of element(*, cdf:Person))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>LeaderPersonIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:LeaderPersonIds"/>) must point to an
                element of type Person</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:PartyRegistration)" priority="1005" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:PartyRegistration)"/>
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
   <xsl:template match="element(*, cdf:PartySelection)" priority="1004" mode="M3">
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
   <xsl:template match="element(*, cdf:Person)" priority="1003" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:Person)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'PersonId' and .. instance of element(*, cdf:Candidate)) or (local-name() = 'LeaderPersonIds' and .. instance of element(*, cdf:Party)) or (local-name() = 'ElectionOfficialPersonIds' and .. instance of element(*, cdf:ElectionAdministration)) or (local-name() = 'AuthorityIds' and .. instance of element(*, cdf:ReportingUnit)) or (local-name() = 'OfficeHolderPersonIds' and .. instance of element(*, cdf:Office))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'PersonId' and .. instance of element(*, cdf:Candidate)) or (local-name() = 'LeaderPersonIds' and .. instance of element(*, cdf:Party)) or (local-name() = 'ElectionOfficialPersonIds' and .. instance of element(*, cdf:ElectionAdministration)) or (local-name() = 'AuthorityIds' and .. instance of element(*, cdf:ReportingUnit)) or (local-name() = 'OfficeHolderPersonIds' and .. instance of element(*, cdf:Office))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Person (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant from
                Candidate, Party, ElectionAdministration, ReportingUnit, Office</svrl:text>
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
   <xsl:template match="element(*, cdf:ReportingUnit)" priority="1002" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:ReportingUnit)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionDistrictId' and .. instance of element(*, cdf:Office)) or (local-name() = 'ElectionScopeId' and .. instance of element(*, cdf:Election))]) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(idref(current()/@ObjectId)[(local-name() = 'ElectionDistrictId' and .. instance of element(*, cdf:Office)) or (local-name() = 'ElectionScopeId' and .. instance of element(*, cdf:Election))]) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>ReportingUnit (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="current()/@ObjectId"/>) must have refereant
                from Office, Election</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:AuthorityIds)[not(. instance of element(*, cdf:Person))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:AuthorityIds)[not(. instance of element(*, cdf:Person))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>AuthorityIds (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:AuthorityIds"/>) must point to an element
                of type Person</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:Id)[not(. instance of element(*, cdf:Contest))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:Id)[not(. instance of element(*, cdf:Contest))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Id
                    (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:Id"/>) must point to an element of type
                Contest</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="element(*, cdf:RetentionContest)" priority="1001" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:RetentionContest)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:OfficeId)[not(. instance of element(*, cdf:Office))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:OfficeId)[not(. instance of element(*, cdf:Office))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>OfficeId (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:OfficeId"/>) must point to an element of type
                Office</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
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
   <!--RULE -->
   <xsl:template match="element(*, cdf:VoteCounts)" priority="1000" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="element(*, cdf:VoteCounts)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(id(cdf:Id)[not(. instance of element(*, cdf:ContestSelection))])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(id(cdf:Id)[not(. instance of element(*, cdf:ContestSelection))])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Id (<xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                                select="cdf:Id"/>) must point to an element of type
                ContestSelection</svrl:text>
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
