<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:local="http://localhost/"
   exclude-result-prefixes="#all"
   expand-text="yes">

   <xsl:output method="html" omit-xml-declaration="yes" byte-order-mark="no" indent="no"/>

   <xsl:variable name="new-line" select="'&#xA;'" as="xs:string"/>
   <xsl:variable name="archive-uri" select="resolve-uri('codeplex-archive/')" as="xs:anyURI"/>

   <xsl:template name="main">
      <xsl:variable name="issues-doc" select="json-to-xml(unparsed-text(resolve-uri('issues/issues.json', $archive-uri)))"/>
      <xsl:apply-templates select="$issues-doc" mode="issues"/>
   </xsl:template>

   <xsl:template match="/fn:array" mode="issues">
      <xsl:variable name="issues" select="fn:map"/>
      <xsl:result-document href="{resolve-uri('../')}issues/index.md" indent="yes">
         <xsl:text>---{$new-line}</xsl:text>
         <xsl:text>title: Issues{$new-line}</xsl:text>
         <xsl:text>---{$new-line}</xsl:text>
         <ul>
            <xsl:for-each select="reverse($issues)">
               <li>
                  <a href="{fn:*[@key = 'Id']}.html">#{fn:*[@key = 'Id']} {fn:*[@key = 'Title']}</a>
               </li>
            </xsl:for-each>
         </ul>
      </xsl:result-document>
      <xsl:apply-templates select="$issues" mode="#current"/>
   </xsl:template>

   <xsl:template match="fn:map" mode="issues">
      <xsl:variable name="id" select="fn:*[@key = 'Id']/string()"/>
      <xsl:variable name="title" select="fn:*[@key = 'Title']/string()"/>
      <xsl:variable name="issue" select="local:issue-doc($id)"/>
      <xsl:result-document href="{resolve-uri('../')}issues/{$id}.md">
         <xsl:text>---{$new-line}</xsl:text>
         <xsl:text>title: "{replace($title, '"', '\\"')} #{$id}"{$new-line}</xsl:text>
         <xsl:text>---{$new-line}</xsl:text>
         <xsl:apply-templates select="$issue" mode="issue"/>
      </xsl:result-document>
   </xsl:template>

   <xsl:mode name="issue" on-no-match="shallow-skip"/>
   <xsl:mode name="issue-text" on-no-match="text-only-copy"/>

   <xsl:template match="fn:map[@key = 'WorkItem']" mode="issue">
      <div class="issue-report">
         <div class="issue-header">
            <b>??</b>
            <xsl:text> reported on </xsl:text>
            <xsl:apply-templates select="fn:string[@key = 'ReportedDate']" mode="issue-text"/>
         </div>
         <xsl:apply-templates select="fn:string[@key = 'Description']" mode="#current"/>
         <div class="issue-footer">
            <dl>
               <xsl:apply-templates select="fn:*[@key = ('AffectedComponent', 'ClosedDate', 'LastUpdatedDate', 'PlannedForRelease', 'Status', 'ReasonClosed')]" mode="issue-footer-item"/>
            </dl>
         </div>
      </div>
      <xsl:apply-templates select="fn:array[@key = 'Comments']" mode="#current"/>
   </xsl:template>

   <xsl:template match="fn:string[@key = ('ReportedDate', 'PostedDate', 'ClosedDate', 'LastUpdatedDate')]/text()" mode="issue-text">
      <time datetime="{.}" title="{.}">{format-dateTime(xs:dateTime(.), "[MNn] [D], [Y]", "en", (), ())}</time>
   </xsl:template>

   <xsl:template match="fn:string[@key = ('Description', 'Message')]" mode="issue">
      <div class="issue-message" markdown="1">
         <xsl:text>{$new-line}{$new-line}</xsl:text>
         <xsl:value-of select="replace(., '&#xD;', '')" disable-output-escaping="yes"/>
         <xsl:text>{$new-line}{$new-line}</xsl:text>
      </div>
   </xsl:template>

   <xsl:template match="fn:*" mode="issue-footer-item">
      <dt>{@key}</dt>
      <dd>
         <xsl:apply-templates mode="issue-text"/>
      </dd>
   </xsl:template>

   <xsl:template match="fn:*[@key = ('Status', 'AffectedComponent')]" mode="issue-footer-item">
      <dt>{@key}</dt>
      <dd>
         <xsl:apply-templates select="fn:string[@key = 'Name']" mode="issue-text"/>
      </dd>
   </xsl:template>

   <xsl:template match="fn:array[@key = 'Comments']/fn:map" mode="issue">
      <div id="comment-{fn:*[@key = 'Id']}" class="issue-comment">
         <div class="issue-header">
            <b>??</b>
            <xsl:text> commented on </xsl:text>
            <xsl:apply-templates select="fn:string[@key = 'PostedDate']" mode="issue-text"/>
         </div>
         <xsl:apply-templates select="fn:string[@key = 'Message']" mode="#current"/>
      </div>
   </xsl:template>

   <xsl:function name="local:issue-doc">
      <xsl:param name="id" as="xs:anyAtomicType"/>

      <xsl:sequence select="json-to-xml(unparsed-text(resolve-uri(concat('issues/', $id, '/', $id, '.json'), $archive-uri)))"/>
   </xsl:function>

</xsl:stylesheet>
