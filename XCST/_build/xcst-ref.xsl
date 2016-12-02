<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:ann="http://relaxng.org/ns/compatibility/annotations/1.0"
   xmlns:ref="http://localhost/"
   exclude-result-prefixes="#all">

   <xsl:output method="html" indent="yes"/>

   <xsl:key name="define" match="rng:define" use="@name"/>

   <xsl:template match="text()" mode="#all"/>

   <xsl:template name="main">
      <xsl:variable name="schema" select="doc('/foss/XCST/schemas/xcst.rng')"/>

      <html>
         <body>
            <xsl:apply-templates select="$schema" mode="toc"/>
            <xsl:apply-templates select="$schema//rng:element[string(ref:name(.))]" mode="doc">
               <xsl:sort select="string(ref:name(.))"/>
            </xsl:apply-templates>
         </body>
      </html>
   </xsl:template>

   <xsl:template match="rng:grammar" mode="toc">
      <ul>
         <xsl:for-each select=".//rng:element[string(ref:name(.))]">
            <xsl:sort select="string(ref:name(.))"/>

            <xsl:variable name="name" select="ref:name(.)"/>
            <li>
               <a href="#{generate-id()}">
                  <xsl:value-of select="$name"/>
               </a>
            </li>
         </xsl:for-each>
      </ul>
   </xsl:template>

   <xsl:template match="rng:element" mode="doc">

      <xsl:variable name="name" select="ref:name(.)"/>
      <xsl:variable name="attribs" select="ref:attribs(.)"/>
      <xsl:variable name="parents" select="ref:parents(., true())"/>
      <xsl:variable name="category" select="
         ref:parents(., false())[self::rng:define and not(@name = 'module-content')]
            /@name
            /(if (ends-with(., '-element')) then substring-before(., '-element') else string())"/>

      <section id="{generate-id()}">
         <h2>
            <xsl:value-of select="$name"/>
         </h2>

         <pre>
            <code>
               
               <xsl:text>&lt;</xsl:text>
               <xsl:value-of select="$name"/>
               <xsl:for-each select="$attribs">
                  <xsl:text>&#xA;  </xsl:text>
                  <xsl:variable name="required" select="xs:boolean(@required)"/>
                  <xsl:element name="{(if ($required) then 'b' else 'span')}">
                     <xsl:value-of select="@name"/>
                  </xsl:element>
                  <xsl:if test="not($required)">?</xsl:if>
                  <xsl:text> = </xsl:text>
                  <xsl:copy-of select="ref:as/node()" copy-namespaces="no"/>
               </xsl:for-each>
               <xsl:if test="$attribs">
                  <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:text>&gt;</xsl:text>
               <xsl:text>&#xA;</xsl:text>
               <xsl:text>&lt;/</xsl:text>
               <xsl:value-of select="$name"/>
               <xsl:text>&gt;</xsl:text>
            </code>
         </pre>

         <dl>
            <xsl:if test="not(empty($category))">
               <dt>
                  <b>Category</b>
               </dt>
               <xsl:for-each select="$category">
                  <dd>
                     <i>
                        <xsl:value-of select="."/>
                     </i>
                  </dd>
               </xsl:for-each>
            </xsl:if>
            <dt>
               <b>Permitted parent elements</b>
            </dt>
            <xsl:choose>
               <xsl:when test="empty($parents)">
                  <dd>None</dd>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each select="$parents">
                     <xsl:sort select="self::rng:element" order="descending"/>
                     <xsl:sort select="if (self::rng:element) then string(ref:name(.)) else ()"/>

                     <dd>
                        <xsl:choose>
                           <xsl:when test="self::rng:element">
                              <a href="#{generate-id(.)}">
                                 <xsl:value-of select="ref:name(.)"/>
                              </a>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:text>Any XCST element whose content model is </xsl:text>
                              <i>
                                 <xsl:value-of select="@name"/>
                              </i>
                           </xsl:otherwise>
                        </xsl:choose>
                     </dd>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </dl>

         <xsl:if test="$attribs[@description]">
            <h3>Attributes</h3>
            <dl>
               <xsl:for-each select="$attribs[@description]">
                  <xsl:sort select="@name"/>

                  <dt>
                     <code>
                        <xsl:value-of select="@name"/>
                     </code>
                  </dt>
                  <dd>
                     <xsl:value-of select="@description"/>
                  </dd>
               </xsl:for-each>
            </dl>
         </xsl:if>
      </section>
   </xsl:template>

   <xsl:function name="ref:name" as="xs:QName?">
      <xsl:param name="el" as="element()"/>

      <xsl:choose>
         <xsl:when test="$el/@name">
            <xsl:choose>
               <xsl:when test="contains($el/@name, ':')">
                  <xsl:variable name="ns" select="namespace-uri-for-prefix(substring-before($el/@name, ':'), $el)"/>
                  <xsl:variable name="local" select="substring-after($el/@name, ':')"/>
                  <xsl:variable name="lexical" select="string($el/@name)"/>
                  <xsl:sequence select="QName($ns, $lexical)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="ns" select="
                     if ($el[self::rng:attribute]) then ($el/@ns/string(), '')[1]
                     else ($el/ancestor-or-self::*/@ns/string())[1]"/>
                  <xsl:variable name="local" select="string($el/@name)"/>
                  <xsl:variable name="prefix" select="
                     if ($ns) then
                        (for $p in in-scope-prefixes($el)
                        return if (namespace-uri-for-prefix($p, $el) eq $ns) then $p else ())[1]
                     else
                        ()
                  "/>
                  <xsl:variable name="lexical" select="if ($prefix) then concat($prefix, ':', $local) else $local"/>
                  <xsl:sequence select="QName($ns, $lexical)"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
      </xsl:choose>
   </xsl:function>

   <xsl:function name="ref:attribs" as="element()*">
      <xsl:param name="el" as="element()"/>

      <xsl:apply-templates select="$el/*" mode="ref:attribs">
         <xsl:with-param name="optional" select="false()" tunnel="yes"/>
      </xsl:apply-templates>
   </xsl:function>

   <xsl:template match="rng:element" mode="ref:attribs"/>

   <xsl:template match="rng:optional" mode="ref:attribs">
      <xsl:apply-templates mode="#current">
         <xsl:with-param name="optional" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template match="rng:zeroOrMore | rng:choice" mode="ref:attribs">
      <xsl:apply-templates mode="#current">
         <xsl:with-param name="optional" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template match="rng:ref" mode="ref:attribs">
      <xsl:apply-templates select="key('define', @name)" mode="#current"/>
   </xsl:template>

   <xsl:template match="rng:ref[@name = ('standard-attributes', 'standard-attributes-except-version')]" mode="ref:attribs"/>

   <xsl:template match="rng:attribute" mode="ref:attribs">
      <xsl:param name="optional" as="xs:boolean" tunnel="yes"/>

      <ref:attribute name="{ref:name(.)}" required="{not($optional)}">
         <xsl:if test="ann:documentation">
            <xsl:attribute name="description" select="ann:documentation"/>
         </xsl:if>
         <ref:as>
            <xsl:apply-templates mode="ref:type-display"/>
         </ref:as>
      </ref:attribute>
   </xsl:template>

   <xsl:template match="rng:choice" mode="ref:type-display">
      <xsl:for-each select="rng:*">
         <xsl:if test="position() gt 1"> | </xsl:if>
         <xsl:apply-templates select="." mode="#current"/>
      </xsl:for-each>
   </xsl:template>

   <xsl:template match="rng:choice[rng:*[2][self::rng:ref[@name = ('AVT', 'AVTExpr')]]]" mode="ref:type-display">
      <xsl:text>{ </xsl:text>
      <xsl:apply-templates select="rng:*[1]" mode="#current"/>
      <xsl:text> }</xsl:text>
   </xsl:template>

   <xsl:template match="rng:value" mode="ref:type-display">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>"</xsl:text>
   </xsl:template>

   <xsl:template match="rng:data" mode="ref:type-display">
      <i>
         <xsl:value-of select="@type"/>
      </i>
   </xsl:template>

   <xsl:template match="rng:ref" mode="ref:type-display">
      <xsl:apply-templates select="key('define', @name)" mode="#current"/>
   </xsl:template>

   <xsl:template match="rng:ref[@name = ('AVT', 'AVTExpr')]" mode="ref:type-display">
      <xsl:text>{ </xsl:text>
      <xsl:next-match/>
      <xsl:text> }</xsl:text>
   </xsl:template>

   <xsl:template match="rng:define[@name = ('Boolean', 'EQName') or (rng:data and not(@name = ('AVT', 'AVTExpr', 'OutputVersion')))]" mode="ref:type-display" priority="1">
      <i>
         <xsl:value-of select="@name"/>
      </i>
   </xsl:template>

   <xsl:template match="rng:define[@name = ('QName-default', 'EQName-default')]" mode="ref:type-display" priority="2">
      <i>
         <xsl:value-of select="substring-before(@name, '-default')"/>
      </i>
   </xsl:template>

   <xsl:template match="rng:list/rng:zeroOrMore" mode="ref:type-display">
      <xsl:apply-templates mode="#current"/>
      <xsl:text>*</xsl:text>
   </xsl:template>

   <xsl:template match="rng:list/rng:oneOrMore" mode="ref:type-display">
      <xsl:apply-templates mode="#current"/>
      <xsl:text>+</xsl:text>
   </xsl:template>

   <!--<xsl:function name="ref:category" as="xs:string?">
      <xsl:param name="el" as="element(rng:element)"/>

      <xsl:if test="$el/parent::rng:define">
         <xsl:variable name="refs" select="root($el)//rng:ref[@name eq $el/../@name]"/>
      </xsl:if>
   </xsl:function>-->

   <xsl:function name="ref:parents" as="element()*">
      <xsl:param name="el" as="element(rng:element)"/>
      <xsl:param name="search" as="xs:boolean"/>

      <xsl:choose>
         <xsl:when test="$el/parent::rng:define">
            <xsl:variable name="refs" select="root($el)//rng:ref[@name eq $el/../@name]"/>
            <xsl:sequence select="$refs/(if (ancestor::rng:element) then ancestor::rng:element[1] else ref:referencing(., $search))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:sequence select="$el/ancestor::rng:element[1]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function name="ref:referencing" as="element()*">
      <xsl:param name="r" as="element(rng:ref)"/>
      <xsl:param name="search" as="xs:boolean"/>

      <xsl:variable name="el" select="$r/ancestor::rng:element[1]"/>
      <xsl:choose>
         <xsl:when test="$el">
            <xsl:sequence select="$el"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="def" select="$r/ancestor::rng:define[1]"/>
            <xsl:variable name="refs" select="root($r)//rng:ref[@name eq $def/@name]"/>
            <xsl:variable name="upstream" select="
               if (not($search) or $def/@name = 'sequence-constructor') then ()
               else $refs/ref:referencing(., true())"/>
            <xsl:sequence select="
               if (not(empty($upstream))) then $upstream
               else $def"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

</xsl:stylesheet>
