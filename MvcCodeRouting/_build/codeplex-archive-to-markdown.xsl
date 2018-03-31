<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:local="http://localhost/"
   exclude-result-prefixes="#all"
   expand-text="yes">

   <xsl:output method="html" omit-xml-declaration="yes" byte-order-mark="no" indent="yes"/>

   <xsl:variable name="new-line" select="'&#xA;'" as="xs:string"/>
   <xsl:variable name="archive-uri" select="resolve-uri('codeplex-archive/')" as="xs:anyURI"/>

   <xsl:template name="main">
      <xsl:variable name="issues-doc" select="json-to-xml(unparsed-text(resolve-uri('issues/issues.json', $archive-uri)))"/>
      <xsl:apply-templates select="$issues-doc" mode="issues"/>
      <xsl:variable name="discussions-doc" select="json-to-xml(unparsed-text(resolve-uri('discussions/discussions.json', $archive-uri)))"/>
      <xsl:apply-templates select="$discussions-doc" mode="discussions"/>
   </xsl:template>

   <!-- ## Issues -->

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
               <xsl:apply-templates select="fn:*[@key = 'Status'], fn:*[@key = 'ReasonClosed'], fn:*[@key = 'AffectedComponent'], fn:*[@key = 'PlannedForRelease'], fn:*[@key = 'ClosedDate'], fn:*[@key = 'LastUpdatedDate'], ../fn:*[@key = 'FileAttachments']" mode="issue-footer-item"/>
            </dl>
         </div>
      </div>
      <xsl:apply-templates select="fn:array[@key = 'Comments']" mode="#current"/>
   </xsl:template>

   <xsl:template match="fn:string[@key = ('ReportedDate', 'PostedDate', 'ClosedDate', 'LastUpdatedDate')]/text()" mode="issue-text discussion-text">
      <time datetime="{.}" title="{.}">{format-dateTime(xs:dateTime(.), "[MNn] [D], [Y]", "en", (), ())}</time>
   </xsl:template>

   <xsl:template match="fn:string[@key = ('Description', 'Message')]" mode="issue">
      <div class="issue-message" markdown="1">
         <xsl:value-of select="replace(., '&#xD;', '')" disable-output-escaping="yes"/>
         <!-- new line is important to make sure closing tag outputs in a separate line -->
         <xsl:text>{$new-line}</xsl:text>
      </div>
   </xsl:template>

   <xsl:template match="fn:*[normalize-space()]" mode="issue-footer-item">
      <dt>{@key}</dt>
      <dd>
         <xsl:apply-templates mode="issue-text"/>
      </dd>
   </xsl:template>

   <xsl:template match="fn:*[@key = 'ReasonClosed']" mode="issue-footer-item" priority="10">
      <xsl:if test="fn:string[@key = 'Name'] ne 'Unassigned'">
         <xsl:next-match/>
      </xsl:if>
   </xsl:template>

   <xsl:template match="fn:*[@key = ('Status', 'AffectedComponent')][normalize-space()]" mode="issue-footer-item" priority="10">
      <dt>{@key}</dt>
      <dd>
         <xsl:apply-templates select="fn:string[@key = 'Name']" mode="issue-text"/>
      </dd>
   </xsl:template>

   <xsl:template match="fn:array[@key = 'FileAttachments'][fn:map]" mode="issue-footer-item" priority="10">
      <dt>{@key}</dt>
      <dd>
         <ul>
            <xsl:for-each select="fn:map">
               <li>
                  <a href="attachments/{/fn:*/fn:*[@key = 'WorkItem']/fn:*[@key = 'Id']}/{fn:*[@key = 'FileName']}">{fn:*[@key = 'FileName']}</a>
               </li>
            </xsl:for-each>
         </ul>
      </dd>
   </xsl:template>

   <xsl:template match="fn:array[@key = 'Comments']/fn:map" mode="issue">
      <xsl:variable name="id" select="'post' || fn:*[@key = 'Id']/string()"/>
      <div id="{$id}" class="issue-comment">
         <div class="issue-header">
            <b>??</b>
            <xsl:text> commented on </xsl:text>
            <xsl:apply-templates select="fn:string[@key = 'PostedDate']" mode="issue-text"/>
            <xsl:text> </xsl:text>
            <a href="#{$id}" class="post-link">link</a>
         </div>
         <xsl:apply-templates select="fn:string[@key = 'Message']" mode="#current"/>
      </div>
   </xsl:template>

   <xsl:function name="local:issue-doc">
      <xsl:param name="id" as="xs:anyAtomicType"/>

      <xsl:sequence select="json-to-xml(unparsed-text(resolve-uri(concat('issues/', $id, '/', $id, '.json'), $archive-uri)))"/>
   </xsl:function>

   <!-- ## Discussions -->

   <xsl:template match="/fn:array" mode="discussions">
      <xsl:variable name="discussions" select="fn:map"/>
      <xsl:result-document href="{resolve-uri('../')}discussions/index.md" indent="yes">
         <xsl:text>---{$new-line}</xsl:text>
         <xsl:text>title: Discussions{$new-line}</xsl:text>
         <xsl:text>---{$new-line}</xsl:text>
         <ul>
            <xsl:for-each select="reverse($discussions)">
               <li>
                  <a href="{fn:*[@key = 'Id']}.html">{fn:*[@key = 'Title']}</a>
               </li>
            </xsl:for-each>
         </ul>
      </xsl:result-document>
      <xsl:apply-templates select="$discussions" mode="#current"/>
   </xsl:template>

   <xsl:template match="fn:map" mode="discussions">
      <xsl:variable name="id" select="fn:*[@key = 'Id']/string()"/>
      <xsl:variable name="title" select="fn:*[@key = 'Title']/string()"/>
      <xsl:variable name="discussion" select="local:discussion-doc($id)"/>
      <xsl:result-document href="{resolve-uri('../')}discussions/{$id}.md">
         <xsl:text>---{$new-line}</xsl:text>
         <xsl:text>title: "{replace($title, '"', '\\"')}"{$new-line}</xsl:text>
         <xsl:text>---{$new-line}</xsl:text>
         <xsl:apply-templates select="$discussion" mode="discussion"/>
      </xsl:result-document>
   </xsl:template>

   <xsl:mode name="discussion" on-no-match="shallow-skip"/>
   <xsl:mode name="discussion-text" on-no-match="text-only-copy"/>

   <xsl:template match="/fn:array/fn:map" mode="discussion">
      <xsl:variable name="id" select="'post' || fn:*[@key = 'Id']/string()"/>
      <div id="{$id}">
         <xsl:attribute name="class" separator=" ">
            <xsl:sequence select="'discussion-comment'"/>
            <xsl:if test="position() eq 1">
               <xsl:sequence select="'op'"/>
            </xsl:if>
            <xsl:if test="fn:*[@key = 'MarkedAsAnswerDate'][normalize-space()]">
               <xsl:sequence select="'marked-as-answer'"/>
            </xsl:if>
         </xsl:attribute>
         <div class="discussion-header">
            <b>??</b>
            <xsl:text> commented on </xsl:text>
            <xsl:apply-templates select="fn:string[@key = 'PostedDate']" mode="discussion-text"/>
            <xsl:if test="position() gt 1">
               <xsl:text> </xsl:text>
               <a href="#{$id}" class="post-link">link</a>
            </xsl:if>
         </div>
         <xsl:apply-templates select="fn:string[@key = 'Html']" mode="#current"/>
      </div>
   </xsl:template>

   <xsl:template match="fn:string[@key = 'Html']" mode="discussion">
      <div class="discussion-message">
         <xsl:value-of select="." disable-output-escaping="yes"/>
      </div>
   </xsl:template>

   <xsl:function name="local:discussion-doc">
      <xsl:param name="id" as="xs:anyAtomicType"/>

      <xsl:sequence select="json-to-xml(unparsed-text(resolve-uri(concat('discussions/', $id, '.json'), $archive-uri)))"/>
   </xsl:function>

</xsl:stylesheet>
