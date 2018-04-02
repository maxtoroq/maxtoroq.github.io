<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:ann="http://relaxng.org/ns/compatibility/annotations/1.0"
   xmlns:c="http://maxtoroq.github.io/XCST"
   xmlns:a="http://maxtoroq.github.io/XCST/application"
   xmlns:docs="http://maxtoroq.github.io/XCST/docs"
   xmlns:ref="http://localhost/"
   exclude-result-prefixes="#all">

   <xsl:import href="rng-ref.xsl"/>

   <xsl:output method="html" indent="yes"/>

   <xsl:variable name="grammar-c" select="doc('../../../XCST/schemas/xcst.rng')"/>
   <xsl:variable name="grammar-a" select="doc('../../../XCST-a/schemas/xcst-app.rng')"/>

   <xsl:template name="main">

      <xsl:variable name="elements-c" select="$grammar-c//rng:element[string(ref:name(.))]"/>
      <xsl:variable name="elements-a" select="$grammar-a//rng:element[string(ref:name(.))]"/>

      <xsl:call-template name="output-elements">
         <xsl:with-param name="elements" select="$elements-c"/>
         <xsl:with-param name="index-title" select="'XCST Elements'" tunnel="yes"/>
      </xsl:call-template>

      <xsl:call-template name="output-elements">
         <xsl:with-param name="elements" select="$elements-a"/>
         <xsl:with-param name="index-title" select="'Application Extension Elements'" tunnel="yes"/>
      </xsl:call-template>

      <xsl:call-template name="standard-attributes-page">
         <xsl:with-param name="std-attribs-def" select="$grammar-c//rng:define[@name = 'standard-attributes']"/>
      </xsl:call-template>
   </xsl:template>

   <xsl:template name="output-elements">
      <xsl:param name="elements" as="element(rng:element)+"/>

      <xsl:variable name="prefix" select="prefix-from-QName(ref:name($elements[1]))"/>

      <xsl:for-each-group select="$elements" group-by="ref:name(.)">
         <xsl:call-template name="element-page">
            <xsl:with-param name="name" select="current-grouping-key()"/>
            <xsl:with-param name="elements" select="current-group()"/>
            <xsl:with-param name="all-elements" select="$elements" tunnel="yes"/>
         </xsl:call-template>
      </xsl:for-each-group>

      <xsl:call-template name="elements-index">
         <xsl:with-param name="all-elements" select="$elements" tunnel="yes"/>
      </xsl:call-template>
   </xsl:template>

   <xsl:template name="elements-index">
      <xsl:param name="all-elements" as="element(rng:element)+" tunnel="yes"/>
      <xsl:param name="index-title" as="xs:string" tunnel="yes"/>

      <xsl:variable name="prefix" select="prefix-from-QName(ref:name($all-elements[1]))"/>
      <xsl:variable name="pre-file" select="string-join(('_index', 'pre', 'md'), '.')"/>
      <xsl:variable name="pre-path" select="string-join(('..', $prefix, $pre-file), '/')"/>
      <xsl:variable name="post-file" select="string-join(('_index', 'md'), '.')"/>
      <xsl:variable name="post-path" select="string-join(('..', $prefix, $post-file), '/')"/>

      <xsl:result-document href="{resolve-uri('../')}{$prefix}/index.md">
         <xsl:text>---&#xA;</xsl:text>
         <xsl:text>title: "</xsl:text>
         <xsl:value-of select="$index-title"/>
         <xsl:text>"&#xA;</xsl:text>
         <xsl:text>element_ref: no&#xA;</xsl:text>
         <xsl:text>---&#xA;</xsl:text>
         <xsl:call-template name="generated-warning"/>
         <xsl:call-template name="nav-browser"/>
         <xsl:if test="unparsed-text-available($pre-path)">
            <xsl:text>&#xA;&#xA;{% include_relative </xsl:text>
            <xsl:value-of select="$pre-file"/>
            <xsl:text> %}&#xA;</xsl:text>
         </xsl:if>
         <ul class="ref-element-list">
            <xsl:for-each-group select="$all-elements" group-by="substring(local-name-from-QName(ref:name(.)), 1, 1)">
               <xsl:sort select="current-grouping-key()"/>

               <li>
                  <xsl:for-each-group select="current-group()" group-by="ref:name(.)">
                     <xsl:sort select="string(current-grouping-key())"/>

                     <xsl:if test="position() gt 1">
                        <xsl:text> &#160;</xsl:text>
                     </xsl:if>
                     <a href="{ref:element-page(.)}">
                        <code>
                           <xsl:value-of select="current-grouping-key()"/>
                        </code>
                     </a>
                  </xsl:for-each-group>
               </li>
            </xsl:for-each-group>
         </ul>
         <xsl:if test="unparsed-text-available($post-path)">
            <xsl:text>&#xA;&#xA;{% include_relative </xsl:text>
            <xsl:value-of select="$post-file"/>
            <xsl:text> %}&#xA;</xsl:text>
         </xsl:if>
      </xsl:result-document>
   </xsl:template>

   <xsl:template name="element-page">
      <xsl:param name="name" as="xs:QName"/>
      <xsl:param name="elements" as="element(rng:element)+"/>

      <xsl:variable name="prefix" select="prefix-from-QName($name)"/>

      <xsl:result-document href="{resolve-uri('../')}{$prefix}/{substring-before(ref:element-page($elements[1]), '.')}.md">
         <xsl:text>---&#xA;</xsl:text>
         <xsl:text>title: "</xsl:text>
         <xsl:value-of select="$name"/>
         <xsl:text>"&#xA;---&#xA;</xsl:text>
         <xsl:call-template name="generated-warning"/>
         <xsl:call-template name="nav-browser">
            <xsl:with-param name="name" select="$name"/>
         </xsl:call-template>
         <xsl:apply-templates select="$elements" mode="doc"/>
      </xsl:result-document>
   </xsl:template>

   <xsl:template name="nav-browser">
      <xsl:param name="name" as="xs:QName?"/>
      <xsl:param name="all-elements" as="element(rng:element)+" tunnel="yes"/>
      <xsl:param name="index-title" as="xs:string" tunnel="yes"/>

      <nav role="navigation" class="browser">
         <div>
            <h3>
               <xsl:value-of select="$index-title"/>
            </h3>
            <ul>
               <xsl:for-each select="$all-elements">
                  <xsl:sort select="local-name-from-QName(ref:name(.))"/>

                  <xsl:variable name="n" select="ref:name(.)"/>

                  <li>
                     <a href="{ref:element-page(.)}">
                        <xsl:if test="$name eq $n">
                           <xsl:attribute name="class" select="'active'"/>
                        </xsl:if>
                        <xsl:value-of select="$n"/>
                     </a>
                  </li>
               </xsl:for-each>
            </ul>
         </div>
      </nav>
   </xsl:template>

   <xsl:template name="standard-attributes-page">
      <xsl:param name="std-attribs-def" as="element(rng:define)"/>

      <xsl:variable name="element" as="element()">
         <rng:element name="c:example-element">
            <xsl:namespace name="c" select="namespace-uri-from-QName(xs:QName('c:foo'))"/>
         </rng:element>
      </xsl:variable>

      <xsl:result-document href="{resolve-uri('../')}docs/standard-attributes.md">
         <xsl:text>---&#xA;</xsl:text>
         <xsl:text>title: "Standard Attributes"&#xA;---&#xA;</xsl:text>
         <xsl:call-template name="generated-warning"/>
         <xsl:apply-templates select="$element" mode="doc">
            <xsl:with-param name="attribs" select="ref:attribs($std-attribs-def)"/>
            <xsl:with-param name="parents" select="()"/>
            <xsl:with-param name="categories" select="()"/>
            <xsl:with-param name="contents" select="()"/>
         </xsl:apply-templates>
      </xsl:result-document>
   </xsl:template>

   <xsl:template name="generated-warning">
      <xsl:text><![CDATA[
{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is regenerated.  
{% endcomment %}
]]>
</xsl:text>
   </xsl:template>

   <xsl:template match="rng:element" mode="doc">
      <xsl:param name="name" select="ref:name(.)"/>
      <xsl:param name="attribs" select="ref:attribs(.), ref:extension-attributes($name)"/>
      <xsl:param name="parents" select="ref:parents(., -1)[not(self::rng:element[ref:name(.) eq xs:QName('a:option')])]"/>
      <xsl:param name="categories" select="
         ref:parents(., 1)[self::rng:define and @docs:display-type/xs:boolean(.)]/@name/string()"/>
      <xsl:param name="contents" select="ref:contents(.)"/>

      <xsl:variable name="heading" select="concat('h', last() + 1)"/>
      <xsl:variable name="example" select="$name eq xs:QName('c:example-element')"/>
      <xsl:variable name="prefix" select="prefix-from-QName($name)"/>
      <xsl:variable name="pre-file" select="string-join((concat('_', local-name-from-QName($name)), (if (position() gt 1) then string(position()) else ()), 'pre', 'md'), '.')"/>
      <xsl:variable name="pre-path" select="string-join(('..', $prefix, $pre-file), '/')"/>

      <xsl:variable name="post-file" select="if ($example) then '_standard-attributes.md' else string-join((concat('_', local-name-from-QName($name)), (if (position() gt 1) then string(position()) else ()), 'md'), '.')"/>
      <xsl:variable name="post-path" select="if ($example) then concat('../docs/', $post-file) else string-join(('..', $prefix, $post-file), '/')"/>

      <xsl:if test="unparsed-text-available($pre-path)">
         <xsl:text>{% include_relative </xsl:text>
         <xsl:value-of select="$pre-file"/>
         <xsl:text> %}&#xA;&#xA;</xsl:text>
      </xsl:if>

      <div class="ref-element-syntax language-xml highlighter-rouge">
         <pre class="highlight">
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

      <xsl:if test="not($example)">
         <xsl:if test="ann:documentation">
            <p>
               <xsl:value-of select="ann:documentation"/>
            </p>
         </xsl:if>
         <dl>
            <xsl:if test="not(empty($categories))">
               <dt>
                  <b>Category</b>
               </dt>
               <xsl:for-each select="$categories">
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
                                 <code>
                                    <xsl:value-of select="ref:name(.)"/>
                                 </code>
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

                     <xsl:if test="self::rng:define[@name = 'sequence-constructor']">
                        <dd>Any literal result element</dd>
                     </xsl:if>
                  </xsl:for-each-group>
               </xsl:otherwise>
            </xsl:choose>
         </dl>
      </xsl:if>

      <xsl:if test="$attribs">
         <xsl:element name="{$heading}">
            <xsl:attribute name="id" select="'attributes'"/>
            <xsl:text>Attributes</xsl:text>
         </xsl:element>
         <div class="table-responsive">
            <table class="ref-attribs">
               <xsl:variable name="groups" select="distinct-values($attribs/@group)"/>
               <xsl:variable name="display-groups" select="count($groups[.]) gt 1"/>
               <xsl:for-each-group select="$attribs" group-by="@group">
                  <xsl:if test="$display-groups">
                     <tr>
                        <th colspan="2">
                           <xsl:value-of select="(current-grouping-key()[.], 'Other')[1]"/>
                        </th>
                     </tr>
                  </xsl:if>
                  <xsl:for-each select="current-group()">
                     <xsl:sort select="contains(@name, ':')"/>
                     <xsl:sort select="@name"/>

                     <tr>
                        <td>
                           <code>
                              <xsl:if test="$example">[c:]</xsl:if>
                              <xsl:value-of select="@name"/>
                           </code>
                        </td>
                        <td>
                           <xsl:value-of select="@description"/>
                        </td>
                     </tr>
                  </xsl:for-each>
               </xsl:for-each-group>
            </table>
         </div>
         <xsl:if test="not($example) and namespace-uri-from-QName($name) eq namespace-uri-from-QName(xs:QName('c:foo'))">
            <p>
               <small>
                  In addition to the attributes in the preceding table, there are a number of <a href="../docs/standard-attributes.html">standard attributes</a> that may appear on any XCST element.
               </small>
            </p>
         </xsl:if>
      </xsl:if>

      <xsl:if test="not(unparsed-text-available($post-path))">
         <xsl:result-document href="{resolve-uri('.')}/{$post-path}" method="text"/>
      </xsl:if>

      <xsl:text>&#xA;&#xA;{% include_relative </xsl:text>
      <xsl:value-of select="$post-file"/>
      <xsl:text> %}&#xA;</xsl:text>
   </xsl:template>

   <xsl:template match="rng:ref[@name = ('standard-attributes', 'standard-attributes-except-version')]" mode="ref:attribs">
      <xsl:param name="for" as="element()" tunnel="yes"/>

      <xsl:if test="$for[self::rng:define[@name = 'standard-attributes']]">
         <xsl:next-match/>
      </xsl:if>
   </xsl:template>

   <xsl:template match="rng:ref[@name = 'extension-attributes']" mode="ref:attribs"/>

   <xsl:template match="rng:choice[rng:*[2][self::rng:ref[@name = ('avt', 'avt-expr')]]]" mode="ref:type-display">
      <xsl:text>{ </xsl:text>
      <xsl:apply-templates select="rng:*[1]" mode="#current"/>
      <xsl:text> }</xsl:text>
   </xsl:template>

   <xsl:template match="rng:define[@name = ('avt', 'avt-expr')]" mode="ref:type-display">
      <xsl:text>{ </xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text> }</xsl:text>
   </xsl:template>

   <xsl:template match="rng:define[@docs:display-type/xs:boolean(.)]" mode="ref:type-display">
      <xsl:call-template name="ref:simple-type-display">
         <xsl:with-param name="name" select="(@docs:display-name, @name)[1]"/>
      </xsl:call-template>
   </xsl:template>

   <xsl:template match="rng:define[@name = 'member']/rng:element[@name = 'member']/rng:optional[rng:choice[rng:attribute[@name = 'as']]]" mode="ref:type-display">
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template match="rng:define[@name = 'member']/rng:element[@name = 'member']/rng:optional/rng:choice[rng:attribute[@name = 'as']]/rng:oneOrMore[rng:ref[@name = 'member']]" mode="ref:type-display">
      <span>
         <xsl:apply-templates mode="#current"/>
         <xsl:text>*</xsl:text>
      </span>
   </xsl:template>

   <xsl:template match="rng:ref[@name = 'expression'][docs:expression-type]" mode="ref:type-display">
      <xsl:variable name="choice" select="count(docs:expression-type) gt 1"/>
      <xsl:text>@</xsl:text>
      <xsl:if test="$choice">(</xsl:if>
      <xsl:for-each select="docs:expression-type">
         <xsl:if test="position() gt 1"> | </xsl:if>
         <xsl:apply-templates select="." mode="#current"/>
      </xsl:for-each>
      <xsl:if test="$choice">)</xsl:if>
   </xsl:template>

   <xsl:template match="docs:expression-type | docs:type-param" mode="ref:type-display">
      <xsl:variable name="fx-type" select="starts-with(@name, 'System.') and not(starts-with(@name, 'System.Web.Mvc.'))"/>
      <xsl:element name="{if ($fx-type) then 'a' else 'span'}">
         <xsl:if test="$fx-type">
            <xsl:attribute name="href" select="concat('{{ page.bcl_url }}', (@topic, lower-case(@name))[1])"/>
         </xsl:if>
         <xsl:attribute name="title" select="@name"/>
         <xsl:value-of select="tokenize(@name, '\.')[last()]"/>
      </xsl:element>
      <xsl:if test="docs:type-param">
         <xsl:text>&lt;</xsl:text>
         <xsl:for-each select="docs:type-param">
            <xsl:if test="position() gt 1">, </xsl:if>
            <xsl:apply-templates select="." mode="#current"/>
         </xsl:for-each>
         <xsl:text>></xsl:text>
      </xsl:if>
   </xsl:template>

   <xsl:function name="ref:extension-attributes" as="element()*">
      <xsl:param name="name" as="xs:QName"/>

      <xsl:if test="namespace-uri-from-QName($name) eq namespace-uri-from-QName(xs:QName('c:foo'))">
         <xsl:apply-templates select="$grammar-a//rng:define[@docs:extends/(for $n in tokenize(., ' ') return resolve-QName($n, ..)) = $name]" mode="ref:attribs"/>
      </xsl:if>
   </xsl:function>

</xsl:stylesheet>
