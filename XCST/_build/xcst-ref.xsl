<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:a="http://maxtoroq.github.io/XCST/application"
   xmlns:ref="http://localhost/"
   exclude-result-prefixes="#all">

   <xsl:import href="rng-ref.xsl"/>

   <xsl:output method="html" indent="yes"/>

   <xsl:template name="main">

      <xsl:variable name="grammar-c" select="doc('../../../XCST/schemas/xcst.rng')"/>
      <xsl:variable name="grammar-a" select="doc('../../../XCST-a/schemas/xcst-app.rng')"/>
      <xsl:variable name="elements-c" select="$grammar-c//rng:element[string(ref:name(.))]"/>
      <xsl:variable name="elements-a" select="$grammar-a//rng:element[string(ref:name(.))]"/>

      <xsl:call-template name="index-page">
         <xsl:with-param name="elements-c" select="$elements-c"/>
         <xsl:with-param name="elements-a" select="$elements-a"/>
      </xsl:call-template>

      <xsl:call-template name="output-elements">
         <xsl:with-param name="elements" select="$elements-c"/>
      </xsl:call-template>

      <xsl:call-template name="output-elements">
         <xsl:with-param name="elements" select="$elements-a"/>
      </xsl:call-template>
   </xsl:template>

   <xsl:template name="index-page">
      <xsl:param name="elements-c" as="element(rng:element)+"/>
      <xsl:param name="elements-a" as="element(rng:element)+"/>

      <xsl:result-document href="{resolve-uri('../')}docs/elements-ref.html">
         <xsl:text>---&#xA;</xsl:text>
         <xsl:text>title: XCST Elements Reference</xsl:text>
         <xsl:text>&#xA;---&#xA;&#xA;</xsl:text>

         <h2>XCST Elements</h2>
         <xsl:call-template name="elements-list">
            <xsl:with-param name="elements" select="$elements-c"/>
         </xsl:call-template>

         <h2>Application Extension Elements</h2>
         <xsl:call-template name="elements-list">
            <xsl:with-param name="elements" select="$elements-a"/>
         </xsl:call-template>
      </xsl:result-document>
   </xsl:template>

   <xsl:template name="elements-list">
      <xsl:param name="elements" as="element(rng:element)+"/>

      <ul>
         <xsl:for-each-group select="$elements" group-by="substring(local-name-from-QName(ref:name(.)), 1, 1)">
            <xsl:sort select="current-grouping-key()"/>

            <xsl:variable name="prefix" select="prefix-from-QName(ref:name(.))"/>

            <li>
               <xsl:for-each-group select="current-group()" group-by="ref:name(.)">
                  <xsl:sort select="string(current-grouping-key())"/>

                  <xsl:if test="position() gt 1">
                     <xsl:text> &#160;</xsl:text>
                  </xsl:if>
                  <a href="../{$prefix}/{ref:element-page(.)}">
                     <xsl:value-of select="current-grouping-key()"/>
                  </a>
               </xsl:for-each-group>
            </li>
         </xsl:for-each-group>
      </ul>
   </xsl:template>

   <xsl:template name="output-elements">
      <xsl:param name="elements" as="element(rng:element)+"/>

      <xsl:for-each-group select="$elements" group-by="ref:name(.)">
         <xsl:call-template name="element-page">
            <xsl:with-param name="name" select="current-grouping-key()"/>
            <xsl:with-param name="elements" select="current-group()"/>
         </xsl:call-template>
      </xsl:for-each-group>
   </xsl:template>

   <xsl:template name="element-page">
      <xsl:param name="name" as="xs:QName"/>
      <xsl:param name="elements" as="element(rng:element)+"/>

      <xsl:result-document href="{resolve-uri('../')}{prefix-from-QName($name)}/{ref:element-page($elements[1])}">
         <xsl:text>---&#xA;</xsl:text>
         <xsl:text>title: "</xsl:text>
         <xsl:value-of select="$name"/>
         <xsl:text>"&#xA;---&#xA;&#xA;</xsl:text>

         <xsl:apply-templates select="$elements" mode="doc"/>
      </xsl:result-document>
   </xsl:template>

   <xsl:template match="rng:element" mode="doc">

      <xsl:variable name="name" select="ref:name(.)"/>
      <xsl:variable name="attribs" select="ref:attribs(.)"/>
      <xsl:variable name="parents" select="ref:parents(., -1)[not(self::rng:element[ref:name(.) eq xs:QName('a:option')])]"/>
      <xsl:variable name="category" select="
         ref:parents(., 1)[self::rng:define and not(@name = ('module-content', 'select-common'))]
            /@name
            /(if (ends-with(., '-element')) then substring-before(., '-element') else string())"/>

      <xsl:variable name="contents" select="ref:contents(.)"/>

      <div class="language-xml highlighter-rouge">
         <pre class="highlight element-syntax">
            <code>
               <xsl:element name="span">
                  <xsl:attribute name="class" select="'nt'"/>
                  <xsl:text>&lt;</xsl:text>
                  <xsl:value-of select="$name"/>
               </xsl:element>
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
               <xsl:choose>
                  <xsl:when test="$contents">
                     <xsl:text>></xsl:text>
                     <xsl:text>&#xA;  &lt;!-- Content: </xsl:text>
                     <xsl:copy-of select="$contents" copy-namespaces="no"/>
                     <xsl:text> -->&#xA;</xsl:text>
                     <xsl:element name="span">
                        <xsl:attribute name="class" select="'nt'"/>
                        <xsl:text>&lt;/</xsl:text>
                        <xsl:value-of select="$name"/>
                        <xsl:text>></xsl:text>
                     </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>/></xsl:otherwise>
               </xsl:choose>
            </code>
         </pre>
      </div>

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
               <xsl:for-each-group select="$parents" group-by="if (self::rng:element) then string(ref:name(.)) else ''">
                  <xsl:sort select="boolean(self::rng:element)" order="descending"/>
                  <xsl:sort select="current-grouping-key()"/>

                  <dd>
                     <xsl:choose>
                        <xsl:when test="self::rng:element">
                           <a href="{ref:element-page(.)}">
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
               </xsl:for-each-group>
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
   </xsl:template>

   <xsl:template match="rng:ref[@name = ('standard-attributes', 'standard-attributes-except-version')]" mode="ref:attribs"/>

   <xsl:template match="rng:choice[rng:*[2][self::rng:ref[@name = ('AVT', 'AVTExpr')]]]" mode="ref:type-display">
      <xsl:text>{ </xsl:text>
      <xsl:apply-templates select="rng:*[1]" mode="#current"/>
      <xsl:text> }</xsl:text>
   </xsl:template>

   <xsl:template match="rng:define[@name = ('Version', 'OutputVersion')]" mode="ref:type-display">
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template match="rng:define[@name = ('AVT', 'AVTExpr')]" mode="ref:type-display">
      <xsl:text>{ </xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text> }</xsl:text>
   </xsl:template>

   <xsl:template match="rng:define[@name = ('sequence-constructor', 'Boolean', 'EQName')]" mode="ref:type-display">
      <xsl:call-template name="ref:simple-type-display"/>
   </xsl:template>

   <xsl:template match="rng:define[@name = ('QName-default', 'EQName-default')]" mode="ref:type-display">
      <xsl:call-template name="ref:simple-type-display">
         <xsl:with-param name="name" select="substring-before(@name, '-default')"/>
      </xsl:call-template>
   </xsl:template>

   <xsl:template match="rng:define[@name = 'instruction-element']" mode="ref:type-display">
      <xsl:call-template name="ref:simple-type-display">
         <xsl:with-param name="name" select="substring-before(@name, '-element')"/>
      </xsl:call-template>
   </xsl:template>

</xsl:stylesheet>
