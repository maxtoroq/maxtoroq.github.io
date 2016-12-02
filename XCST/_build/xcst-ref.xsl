<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:ref="http://localhost/"
   exclude-result-prefixes="#all">

   <xsl:import href="rng-ref.xsl"/>

   <xsl:output method="html" indent="yes"/>

   <xsl:template name="main">
      <xsl:apply-templates select="doc('/foss/XCST/schemas/xcst.rng')"/>
      <xsl:apply-templates select="doc('/foss/XCST-a/schemas/xcst-app.rng')"/>
   </xsl:template>

   <xsl:template match="/rng:grammar">

      <xsl:variable name="elements" select=".//rng:element[string(ref:name(.))]"/>

      <xsl:for-each-group select="$elements" group-by="prefix-from-QName(ref:name(.))">
         <xsl:call-template name="index-page">
            <xsl:with-param name="prefix" select="current-grouping-key()"/>
            <xsl:with-param name="elements" select="current-group()"/>
         </xsl:call-template>
      </xsl:for-each-group>

      <xsl:for-each-group select="$elements" group-by="ref:name(.)">
         <xsl:call-template name="element-page">
            <xsl:with-param name="name" select="current-grouping-key()"/>
            <xsl:with-param name="elements" select="current-group()"/>
         </xsl:call-template>
      </xsl:for-each-group>
   </xsl:template>

   <xsl:template name="index-page">
      <xsl:param name="prefix" as="xs:string"/>
      <xsl:param name="elements" as="element(rng:element)+"/>

      <xsl:result-document href="{resolve-uri('../')}{$prefix}/index.html">
         <xsl:text>---</xsl:text>
         <xsl:text>&#xA;---&#xA;&#xA;</xsl:text>

         <ul>
            <xsl:for-each-group select="$elements" group-by="ref:name(.)">
               <xsl:sort select="string(ref:name(.))"/>

               <li>
                  <a href="{ref:element-page(.)}">
                     <xsl:value-of select="current-grouping-key()"/>
                  </a>
               </li>
            </xsl:for-each-group>
         </ul>
      </xsl:result-document>
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
      <xsl:variable name="parents" select="ref:parents(., true())"/>
      <xsl:variable name="category" select="
         ref:parents(., false())[self::rng:define and not(@name = ('module-content', 'select-common'))]
            /@name
            /(if (ends-with(., '-element')) then substring-before(., '-element') else string())"/>

      <xsl:variable name="contents" select="ref:contents(.)"/>

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
            <xsl:choose>
               <xsl:when test="$contents">
                  <xsl:text>></xsl:text>
                  <xsl:text>&#xA;  &lt;!-- Content: </xsl:text>
                  <xsl:copy-of select="$contents" copy-namespaces="no"/>
                  <xsl:text> -->&#xA;</xsl:text>
                  <xsl:text>&lt;/</xsl:text>
                  <xsl:value-of select="$name"/>
                  <xsl:text>></xsl:text>
               </xsl:when>
               <xsl:otherwise>/></xsl:otherwise>
            </xsl:choose>
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
   </xsl:template>

</xsl:stylesheet>
