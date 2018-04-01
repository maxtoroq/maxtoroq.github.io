<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:local="http://localhost/"
   exclude-result-prefixes="#all"
   expand-text="yes">

   <xsl:output method="html" omit-xml-declaration="yes" byte-order-mark="no" indent="yes"/>

   <xsl:param name="archive-uri" select="resolve-uri('codeplex-archive/')" as="xs:anyURI"/>
   <xsl:param name="project-name" select="'mvccoderouting'" as="xs:string"/>
   <xsl:param name="repo-url" select="'https://github.com/maxtoroq/MvcCodeRouting'" as="xs:string"/>
   <xsl:variable name="new-line" select="'&#xA;'" as="xs:string"/>

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
         <table>
            <thead>
               <tr>
                  <th>Number</th>
                  <th>Title</th>
                  <th>Status</th>
                  <th>Last activity</th>
               </tr>
            </thead>
            <tbody>
               <xsl:for-each select="reverse($issues)">
                  <xsl:variable name="id" select="fn:*[@key = 'Id']/string()"/>
                  <xsl:variable name="issue" select="local:issue-doc($id)"/>
                  <tr>
                     <td>{$id}</td>
                     <td>
                        <a href="{$id}.html">{fn:*[@key = 'Title']}</a>
                     </td>
                     <td>{$issue/*/fn:*[@key = 'WorkItem']/fn:*[@key = 'Status']/fn:*[@key = 'Name']}</td>
                     <td>
                        <xsl:apply-templates select="$issue/*/fn:*[@key = 'WorkItem']/fn:*[@key = 'LastUpdatedDate']" mode="discussion-text"/>
                     </td>
                  </tr>
               </xsl:for-each>
            </tbody>
         </table>
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
            <xsl:text>Reported on </xsl:text>
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

   <xsl:template match="fn:string[ends-with(@key, 'Date')]/text()" mode="issue-text discussion-text">
      <time datetime="{.}" title="{.}">{format-dateTime(xs:dateTime(.), "[MNn] [D], [Y]", "en", (), ())}</time>
   </xsl:template>

   <xsl:template match="fn:string[@key = ('Description', 'Message')]" mode="issue">
      <div class="issue-message" markdown="1">
         <xsl:value-of disable-output-escaping="yes">
            <xsl:call-template name="process-message">
               <xsl:with-param name="message" select="replace(., '&#xD;', '')"/>
               <xsl:with-param name="markdown" select="true()"/>
               <xsl:with-param name="is-issue" select="true()"/>
            </xsl:call-template>
         </xsl:value-of>
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
            <xsl:text>Commented on </xsl:text>
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

   <xsl:template name="process-message">
      <xsl:param name="message" as="xs:anyAtomicType" required="yes"/>
      <xsl:param name="markdown" as="xs:boolean" required="yes"/>
      <xsl:param name="is-issue" as="xs:boolean" required="yes"/>

      <xsl:analyze-string select="$message" regex="(^|[\(&quot;'\s])(https?://{$project-name}\.codeplex\.com)?/workitem/([0-9]+)(#.+?)?($|[\)&quot;'\s])">
         <xsl:matching-substring>
            <xsl:variable name="url" as="text()">{if ($is-issue) then '' else '../issues/'}{regex-group(3)}.html{regex-group(4)}</xsl:variable>
            <xsl:choose>
               <xsl:when test="$markdown and not(normalize-space(regex-group(1)))">
                  <xsl:text>{regex-group(1)}[{$url}]({$url}){regex-group(5)}</xsl:text>
               </xsl:when>
               <xsl:otherwise>{regex-group(1)}{$url}{regex-group(5)}</xsl:otherwise>
            </xsl:choose>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:analyze-string select="." regex="(^|[\(&quot;'\s])(https?://{$project-name}\.codeplex\.com)?/discussions/([0-9]+)(#.+?)?($|[\)&quot;'\s])">
               <xsl:matching-substring>
                  <xsl:variable name="url" as="text()">{if ($is-issue) then '../discussions/' else ''}{regex-group(3)}.html{regex-group(4)}</xsl:variable>
                  <xsl:choose>
                     <xsl:when test="$markdown and not(normalize-space(regex-group(1)))">
                        <xsl:text>{regex-group(1)}[{$url}]({$url}){regex-group(5)}</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>{regex-group(1)}{$url}{regex-group(5)}</xsl:otherwise>
                  </xsl:choose>
               </xsl:matching-substring>
               <xsl:non-matching-substring>
                  <xsl:analyze-string select="." regex="(^|[\(&quot;'\s])(https?://{$project-name}\.codeplex\.com)?/SourceControl/latest#(.+?)($|[\)&quot;'\s])">
                     <xsl:matching-substring>
                        <xsl:variable name="url" as="text()">{$repo-url}/blob/master/{regex-group(3)}</xsl:variable>
                        <xsl:choose>
                           <xsl:when test="$markdown and not(normalize-space(regex-group(1)))">
                              <xsl:text>{regex-group(1)}&lt;{$url}&gt;{regex-group(4)}</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>{regex-group(1)}{$url}{regex-group(4)}</xsl:otherwise>
                        </xsl:choose>
                     </xsl:matching-substring>
                     <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="(^|[\(&quot;'\s])(https?://{$project-name}\.codeplex\.com)?/SourceControl/changeset/(.+?)($|[\)&quot;'\s])">
                           <xsl:matching-substring>
                              <xsl:variable name="url" as="text()">{$repo-url}/commit/{regex-group(3)}</xsl:variable>
                              <xsl:choose>
                                 <xsl:when test="$markdown and not(normalize-space(regex-group(1)))">
                                    <xsl:text>{regex-group(1)}[{regex-group(3)}]({$url}){regex-group(4)}</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>{regex-group(1)}{$url}{regex-group(4)}</xsl:otherwise>
                              </xsl:choose>
                           </xsl:matching-substring>
                           <xsl:non-matching-substring>
                              <xsl:analyze-string select="." regex="(^|[\(&quot;'\s])(https?://{$project-name}\.codeplex\.com)?/wikipage\?title=(.+?)(&amp;.+?)?($|[\)&quot;'\s])">
                                 <xsl:matching-substring>
                                    <xsl:variable name="page" select="replace(local:pct-decode-unreserved(regex-group(3)), '\+', ' ')"/>
                                    <xsl:variable name="url" as="text()">{$repo-url}/blob/master/docs/{replace($page, '\s', '-')}.md</xsl:variable>
                                    <xsl:choose>
                                       <xsl:when test="$markdown and not(normalize-space(regex-group(1)))">
                                          <xsl:text>{regex-group(1)}[{$page}]({$url}){regex-group(5)}</xsl:text>
                                       </xsl:when>
                                       <xsl:otherwise>{regex-group(1)}{$url}{regex-group(5)}</xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:matching-substring>
                                 <xsl:non-matching-substring>{.}</xsl:non-matching-substring>
                              </xsl:analyze-string>
                           </xsl:non-matching-substring>
                        </xsl:analyze-string>
                     </xsl:non-matching-substring>
                  </xsl:analyze-string>
               </xsl:non-matching-substring>
            </xsl:analyze-string>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>

   <!-- ## Discussions -->

   <xsl:template match="/fn:array" mode="discussions">
      <xsl:variable name="discussions" select="fn:map"/>
      <xsl:result-document href="{resolve-uri('../')}discussions/index.md" indent="yes">
         <xsl:text>---{$new-line}</xsl:text>
         <xsl:text>title: Discussions{$new-line}</xsl:text>
         <xsl:text>---{$new-line}</xsl:text>
         <table>
            <thead>
               <tr>
                  <th>Title</th>
                  <th>Replies</th>
                  <th>Last activity</th>
               </tr>
            </thead>
            <tbody>
               <xsl:for-each select="reverse($discussions)">
                  <xsl:variable name="id" select="fn:*[@key = 'Id']/string()"/>
                  <xsl:variable name="discussion" select="local:discussion-doc($id)"/>
                  <tr>
                     <td>
                        <a href="{$id}.html">{fn:*[@key = 'Title']}</a>
                     </td>
                     <td>{count($discussion/*/*) - 1}</td>
                     <td>
                        <xsl:apply-templates select="fn:*[@key = 'LatestDate']" mode="discussion-text"/>
                     </td>
                  </tr>
               </xsl:for-each>
            </tbody>
         </table>
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
            <xsl:text>Commented on </xsl:text>
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
         <xsl:value-of disable-output-escaping="yes">
            <xsl:call-template name="process-message">
               <xsl:with-param name="message" select="string()"/>
               <xsl:with-param name="markdown" select="false()"/>
               <xsl:with-param name="is-issue" select="false()"/>
            </xsl:call-template>
         </xsl:value-of>
      </div>
   </xsl:template>

   <xsl:function name="local:discussion-doc">
      <xsl:param name="id" as="xs:anyAtomicType"/>

      <xsl:sequence select="json-to-xml(unparsed-text(resolve-uri(concat('discussions/', $id, '.json'), $archive-uri)))"/>
   </xsl:function>

   <!-- ## Util -->

   <!-- http://www.biglist.com/lists/lists.mulberrytech.com/xsl-list/archives/200911/msg00300.html -->

   <xsl:function name="p:pct-decode-unreserved" as="xs:string?" xmlns:p="http://localhost/">
      <xsl:param name="in" as="xs:string"/>
      <xsl:sequence select="p:pct-decode-unreserved($in, ())"/>
   </xsl:function>

   <xsl:function name="p:pct-decode-unreserved" as="xs:string?" xmlns:p="http://localhost/">
      <xsl:param name="in" as="xs:string"/>
      <xsl:param name="seq" as="xs:string*"/>

      <xsl:variable name="unreserved" as="xs:integer+"
        select="(45, 46, 48 to 57, 65 to 90, 95, 97 to 122, 126)"/>

      <xsl:choose>
         <xsl:when test="not($in)">
            <xsl:sequence select="string-join($seq, '')"/>
         </xsl:when>
         <xsl:when test="starts-with($in, '%')">
            <xsl:choose>
               <xsl:when test="matches(substring($in, 2, 2), '^[0-9A-Fa-f][0-9A-Fa-f]$')">
                  <xsl:variable name="s" as="xs:string" select="substring($in, 2, 2)"/>
                  <xsl:variable name="d" as="xs:integer" select="p:hex-to-dec(upper-case($s))"/>
                  <!--<xsl:choose>-->
                  <!--<xsl:when test="$d = $unreserved">-->
                  <xsl:variable name="c" as="xs:string" select="codepoints-to-string($d)"/>
                  <xsl:sequence select="p:pct-decode-unreserved(substring($in, 4), ($seq, $c))"/>
                  <!--</xsl:when>
                     <xsl:otherwise>
                        <xsl:sequence select="p:pct-decode-unreserved(substring($in, 4), ($seq, '%', $s))"/>
                     </xsl:otherwise>
                  </xsl:choose>-->
               </xsl:when>
               <xsl:when test="contains(substring($in, 2), '%')">
                  <xsl:variable name="s" as="xs:string" select="substring-before(substring($in, 2), '%')"/>
                  <xsl:sequence select="p:pct-decode-unreserved(substring($in, 2 + string-length($s)), ($seq, '%', $s))"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:sequence select="string-join(($seq, $in), '')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="contains($in, '%')">
            <xsl:variable name="s" as="xs:string" select="substring-before($in, '%')"/>
            <xsl:sequence select="p:pct-decode-unreserved(substring($in, string-length($s)+1), ($seq, $s))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:sequence select="string-join(($seq, $in), '')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function name="p:hex-to-dec" as="xs:integer" xmlns:p="http://localhost/">
      <xsl:param name="hex" as="xs:string"/>

      <xsl:variable name="len" as="xs:integer" select="string-length($hex)"/>
      <xsl:choose>
         <xsl:when test="$len eq 0">
            <xsl:sequence select="0"/>
         </xsl:when>
         <xsl:when test="$len eq 1">
            <xsl:sequence select="
                 if ($hex eq '0')       then 0
            else if ($hex eq '1')       then 1
            else if ($hex eq '2')       then 2
            else if ($hex eq '3')       then 3
            else if ($hex eq '4')       then 4
            else if ($hex eq '5')       then 5
            else if ($hex eq '6')       then 6
            else if ($hex eq '7')       then 7
            else if ($hex eq '8')       then 8
            else if ($hex eq '9')       then 9
            else if ($hex = ('A', 'a')) then 10
            else if ($hex = ('B', 'b')) then 11
            else if ($hex = ('C', 'c')) then 12
            else if ($hex = ('D', 'd')) then 13
            else if ($hex = ('E', 'e')) then 14
            else if ($hex = ('F', 'f')) then 15
            else error(xs:QName('p:hex-to-dec'))
          "/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:sequence select="
          (16 * p:hex-to-dec(substring($hex, 1, $len - 1)))
          + p:hex-to-dec(substring($hex, $len))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

</xsl:stylesheet>
