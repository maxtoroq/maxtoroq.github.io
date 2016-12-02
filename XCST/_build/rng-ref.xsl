<?xml version="1.0" encoding="utf-8"?>
<stylesheet version="2.0"
   xmlns="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:ann="http://relaxng.org/ns/compatibility/annotations/1.0"
   xmlns:ref="http://localhost/"
   exclude-result-prefixes="#all">

   <key name="define" match="rng:define" use="@name"/>

   <template match="text()" mode="#all"/>

   <function name="ref:name" as="xs:QName?">
      <param name="el" as="element()"/>

      <choose>
         <when test="$el/@name">
            <choose>
               <when test="contains($el/@name, ':')">
                  <variable name="ns" select="namespace-uri-for-prefix(substring-before($el/@name, ':'), $el)"/>
                  <variable name="local" select="substring-after($el/@name, ':')"/>
                  <variable name="lexical" select="string($el/@name)"/>
                  <sequence select="QName($ns, $lexical)"/>
               </when>
               <otherwise>
                  <variable name="ns" select="
                     if ($el[self::rng:attribute]) then ($el/@ns/string(), '')[1]
                     else ($el/ancestor-or-self::*/@ns/string())[1]"/>
                  <variable name="local" select="string($el/@name)"/>
                  <variable name="prefix" select="
                     if ($ns) then
                        (for $p in in-scope-prefixes($el)
                        return if (namespace-uri-for-prefix($p, $el) eq $ns) then $p else ())[1]
                     else
                        ()
                  "/>
                  <variable name="lexical" select="if ($prefix) then concat($prefix, ':', $local) else $local"/>
                  <sequence select="QName($ns, $lexical)"/>
               </otherwise>
            </choose>
         </when>
         <otherwise>

         </otherwise>
      </choose>
   </function>

   <function name="ref:element-page" as="xs:string">
      <param name="el" as="element(rng:element)"/>

      <sequence select="concat(local-name-from-QName(ref:name($el)), '.html')"/>
   </function>

   <function name="ref:attribs" as="element()*">
      <param name="el" as="element()"/>

      <apply-templates select="$el/*" mode="ref:attribs">
         <with-param name="optional" select="false()" tunnel="yes"/>
      </apply-templates>
   </function>

   <template match="rng:element" mode="ref:attribs"/>

   <template match="rng:optional" mode="ref:attribs">
      <apply-templates mode="#current">
         <with-param name="optional" select="true()" tunnel="yes"/>
      </apply-templates>
   </template>

   <template match="rng:zeroOrMore | rng:choice" mode="ref:attribs">
      <apply-templates mode="#current">
         <with-param name="optional" select="true()" tunnel="yes"/>
      </apply-templates>
   </template>

   <template match="rng:ref" mode="ref:attribs">
      <apply-templates select="key('define', @name)" mode="#current"/>
   </template>

   <template match="rng:ref[@name = ('standard-attributes', 'standard-attributes-except-version')]" mode="ref:attribs"/>

   <template match="rng:attribute" mode="ref:attribs">
      <param name="optional" as="xs:boolean" tunnel="yes"/>

      <ref:attribute name="{ref:name(.)}" required="{not($optional)}">
         <if test="ann:documentation">
            <attribute name="description" select="ann:documentation"/>
         </if>
         <ref:as>
            <apply-templates mode="ref:type-display">
               <with-param name="ref:ignore-choice-parens" select="true()" tunnel="yes"/>
            </apply-templates>
         </ref:as>
      </ref:attribute>
   </template>

   <template match="rng:attribute" mode="ref:type-display"/>

   <template match="rng:optional" mode="ref:type-display">
      <variable name="result" as="node()*">
         <apply-templates mode="#current"/>
      </variable>
      <if test="$result">
         <element name="span" namespace="">
            <sequence select="$result"/>
            <text>?</text>
         </element>
      </if>
   </template>

   <template match="rng:group" mode="ref:type-display">
      <variable name="result" as="node()*">
         <apply-templates select="rng:*" mode="#current"/>
      </variable>
      <if test="$result">
         <element name="span" namespace="">
            <if test="count($result) gt 1">(</if>
            <for-each select="$result">
               <if test="position() gt 1">, </if>
               <sequence select="."/>
            </for-each>
            <if test="count($result) gt 1">)</if>
         </element>
      </if>
   </template>

   <template match="rng:choice" mode="ref:type-display">
      <param name="ref:ignore-choice-parens" select="false()" as="xs:boolean" tunnel="yes"/>

      <variable name="result" as="node()*">
         <apply-templates select="rng:*" mode="#current"/>
      </variable>
      <if test="$result">
         <element name="span" namespace="">
            <if test="not($ref:ignore-choice-parens) and count($result) gt 1">(</if>
            <for-each select="$result">
               <if test="position() gt 1"> | </if>
               <sequence select="."/>
            </for-each>
            <if test="not($ref:ignore-choice-parens) and count($result) gt 1">)</if>
         </element>
      </if>
   </template>

   <template match="rng:choice[rng:*[2][self::rng:ref[@name = ('AVT', 'AVTExpr')]]]" mode="ref:type-display">
      <text>{ </text>
      <apply-templates select="rng:*[1]" mode="#current"/>
      <text> }</text>
   </template>

   <template match="rng:value" mode="ref:type-display">
      <element name="span" namespace="">
         <text>"</text>
         <value-of select="."/>
         <text>"</text>
      </element>
   </template>

   <template match="rng:data" mode="ref:type-display">
      <element name="i" namespace="">
         <value-of select="@type"/>
      </element>
   </template>

   <template match="rng:ref" mode="ref:type-display">
      <apply-templates select="key('define', @name)" mode="#current"/>
   </template>

   <template match="rng:define[rng:data and not(@name = 'OutputVersion')]" mode="ref:type-display" priority="1">
      <element name="i" namespace="">
         <value-of select="@name"/>
      </element>
   </template>

   <template match="rng:define[@name = ('AVT', 'AVTExpr')]" mode="ref:type-display" priority="2">
      <text>{ </text>
      <apply-templates mode="#current"/>
      <text> }</text>
   </template>

   <template match="rng:define[@name = ('sequence-constructor', 'Boolean', 'EQName')]" mode="ref:type-display" priority="2">
      <element name="i" namespace="">
         <value-of select="@name"/>
      </element>
   </template>

   <template match="rng:define[@name = ('QName-default', 'EQName-default')]" mode="ref:type-display" priority="2">
      <element name="i" namespace="">
         <value-of select="substring-before(@name, '-default')"/>
      </element>
   </template>

   <template match="rng:define[@name = 'instruction-element']" mode="ref:type-display" priority="2">
      <element name="i" namespace="">
         <value-of select="substring-before(@name, '-element')"/>
      </element>
   </template>

   <template match="rng:zeroOrMore" mode="ref:type-display">
      <variable name="result" as="node()*">
         <apply-templates mode="#current"/>
      </variable>
      <if test="$result">
         <element name="span" namespace="">
            <sequence select="$result"/>
            <text>*</text>
         </element>
      </if>
   </template>

   <template match="rng:oneOrMore" mode="ref:type-display">
      <variable name="result" as="node()*">
         <apply-templates mode="#current"/>
      </variable>
      <if test="$result">
         <element name="span" namespace="">
            <sequence select="$result"/>
            <text>+</text>
         </element>
      </if>
   </template>

   <template match="rng:element" mode="ref:type-display">
      <element name="a" namespace="">
         <attribute name="href" select="ref:element-page(.)"/>
         <value-of select="ref:name(.)"/>
      </element>
   </template>

   <template match="rng:element[empty(ref:name(.))]" mode="ref:type-display"/>

   <template match="rng:text" mode="ref:type-display">
      <element name="i" namespace="">text</element>
   </template>

   <function name="ref:parents" as="element()*">
      <param name="el" as="element(rng:element)"/>
      <param name="search" as="xs:boolean"/>

      <variable name="parent" select="$el/ancestor::rng:element[1]"/>

      <choose>
         <when test="$parent">
            <sequence select="$parent"/>
         </when>
         <otherwise>
            <variable name="def" select="$el/ancestor::rng:define[1]"/>
            <variable name="refs" select="root($el)//rng:ref[@name eq $def/@name]"/>
            <sequence select="$refs/(if (ancestor::rng:element) then ancestor::rng:element[1] else ref:referencing(., $search))"/>
         </otherwise>
      </choose>
   </function>

   <function name="ref:referencing" as="element()*">
      <param name="r" as="element(rng:ref)"/>
      <param name="search" as="xs:boolean"/>

      <variable name="el" select="$r/ancestor::rng:element[1]"/>

      <choose>
         <when test="$el">
            <sequence select="$el"/>
         </when>
         <otherwise>
            <variable name="def" select="$r/ancestor::rng:define[1]"/>
            <variable name="refs" select="root($r)//rng:ref[@name eq $def/@name]"/>
            <variable name="upstream" select="
               if (not($search) or $def/@name = ('sequence-constructor')) then ()
               else $refs/ref:referencing(., true())"/>
            <sequence select="
               if (not(empty($upstream))) then $upstream
               else $def"/>
         </otherwise>
      </choose>
   </function>

   <function name="ref:contents" as="node()*">
      <param name="el" as="element(rng:element)"/>

      <variable name="contents" as="node()*">
         <apply-templates select="$el/rng:*" mode="ref:type-display"/>
      </variable>

      <for-each select="$contents">
         <if test="position() gt 1">, </if>
         <sequence select="."/>
      </for-each>
   </function>

</stylesheet>
