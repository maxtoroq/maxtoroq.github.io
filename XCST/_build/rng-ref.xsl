<?xml version="1.0" encoding="utf-8"?>
<stylesheet version="2.0"
   xmlns="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:ann="http://relaxng.org/ns/compatibility/annotations/1.0"
   xmlns:docs="http://maxtoroq.github.io/XCST/docs"
   xmlns:ref="http://localhost/"
   exclude-result-prefixes="#all">

   <key name="ref:define" match="rng:define" use="@name"/>

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

      <apply-templates select="$el/rng:*" mode="ref:attribs">
         <with-param name="for" select="$el" tunnel="yes"/>
         <with-param name="optional" select="false()" tunnel="yes"/>
      </apply-templates>
   </function>

   <template match="rng:element" mode="ref:attribs"/>

   <template match="rng:optional | rng:zeroOrMore | rng:choice" mode="ref:attribs">
      <apply-templates select="rng:*" mode="#current">
         <with-param name="optional" select="true()" tunnel="yes"/>
      </apply-templates>
   </template>

   <template match="rng:ref" mode="ref:attribs">
      <apply-templates select="key('ref:define', @name)" mode="#current">
         <with-param name="attrib-group" select="@docs:attrib-group" tunnel="yes"/>
      </apply-templates>
   </template>

   <template match="rng:attribute" mode="ref:attribs">
      <param name="optional" as="xs:boolean" tunnel="yes"/>
      <param name="attrib-group" as="attribute()?" tunnel="yes"/>

      <ref:attribute name="{ref:name(.)}" required="{not($optional)}"
         group="{($attrib-group, ancestor-or-self::*/@docs:attrib-group)[1]}">
         <if test="ann:documentation">
            <attribute name="description" select="ann:documentation"/>
         </if>
         <ref:as>
            <apply-templates select="rng:*" mode="ref:type-display">
               <with-param name="ref:ignore-choice-parens" select="true()" tunnel="yes"/>
            </apply-templates>
         </ref:as>
      </ref:attribute>
   </template>

   <template match="rng:attribute" mode="ref:type-display"/>

   <template match="rng:element" mode="ref:type-display">
      <element name="a" namespace="">
         <attribute name="href" select="ref:element-page(.)"/>
         <value-of select="ref:name(.)"/>
      </element>
   </template>

   <template match="rng:element[empty(ref:name(.))]" mode="ref:type-display"/>

   <template match="rng:zeroOrMore | rng:oneOrMore | rng:optional" mode="ref:type-display">
      <variable name="result" as="node()*">
         <apply-templates select="rng:*" mode="#current">
            <with-param name="ref:ignore-choice-parens" select="false()" tunnel="yes"/>
         </apply-templates>
      </variable>
      <if test="$result">
         <element name="span" namespace="">
            <sequence select="$result"/>
            <if test="self::rng:zeroOrMore">*</if>
            <if test="self::rng:oneOrMore">+</if>
            <if test="self::rng:optional">?</if>
         </element>
      </if>
   </template>

   <template match="rng:group | rng:choice" mode="ref:type-display">
      <param name="ref:ignore-choice-parens" select="false()" as="xs:boolean" tunnel="yes"/>

      <variable name="pattern" select="."/>

      <variable name="result" as="node()*">
         <apply-templates select="rng:*" mode="#current"/>
      </variable>

      <variable name="use-parens" select="
         ($pattern[self::rng:group] or not($ref:ignore-choice-parens)) and count($result) gt 1"/>

      <if test="$result">
         <element name="span" namespace="">
            <if test="$use-parens">(</if>
            <for-each select="$result">
               <if test="position() gt 1">
                  <if test="$pattern[self::rng:choice]"> | </if>
                  <if test="$pattern[self::rng:group]">, </if>
               </if>
               <sequence select="."/>
            </for-each>
            <if test="$use-parens">)</if>
         </element>
      </if>
   </template>

   <template match="rng:value" mode="ref:type-display">
      <element name="span" namespace="">
         <attribute name="class" select="'s'"/>
         <variable name="doc" select="following-sibling::*[1][self::ann:documentation]"/>
         <if test="$doc">
            <attribute name="title" select="$doc"/>
         </if>
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

   <template match="rng:text" mode="ref:type-display">
      <element name="i" namespace="">text</element>
   </template>

   <template match="rng:ref" mode="ref:type-display">
      <apply-templates select="key('ref:define', @name)" mode="#current"/>
   </template>

   <template match="rng:define[rng:data]" mode="ref:type-display">
      <call-template name="ref:simple-type-display"/>
   </template>

   <template name="ref:simple-type-display">
      <param name="name" select="@name"/>

      <element name="i" namespace="">
         <if test="ann:documentation">
            <attribute name="title" select="ann:documentation"/>
         </if>
         <value-of select="$name"/>
      </element>
   </template>

   <function name="ref:parents" as="element()*">
      <param name="el" as="element()"/>
      <param name="search-max" as="xs:integer"/>

      <sequence select="ref:parents($el, $search-max, 0)"/>
   </function>

   <function name="ref:parents" as="element()*">
      <param name="el" as="element()"/>
      <param name="search-max" as="xs:integer"/>
      <param name="search-depth" as="xs:integer"/>

      <variable name="parent" select="$el/ancestor::rng:element[1]"/>

      <choose>
         <when test="$parent">
            <sequence select="$parent[not(empty(ref:name(.)))]"/>
         </when>
         <otherwise>
            <variable name="def" select="$el/ancestor::rng:define[1]"/>
            <variable name="refs" select="root($def)//rng:ref[@name eq $def/@name]"/>
            <variable name="search" select="$search-max eq -1 or $search-depth lt $search-max"/>
            <variable name="upstream" select="
               if (not($search) or $def/@name = ('sequence-constructor')) then ()
               else $refs/ref:parents(., $search-max, $search-depth + 1)"/>
            <sequence select="
               if ($upstream) then $upstream
               else $def[$search-depth gt 0]"/>
         </otherwise>
      </choose>
   </function>

   <function name="ref:contents" as="node()*">
      <param name="el" as="element(rng:element)"/>

      <variable name="contents" as="node()*">
         <apply-templates select="$el/rng:*" mode="ref:type-display"/>
      </variable>

      <variable name="use-parens" select="count($contents) gt 1"/>

      <if test="$use-parens">(</if>

      <for-each select="$contents">
         <if test="position() gt 1">, </if>
         <sequence select="."/>
      </for-each>

      <if test="$use-parens">)</if>
   </function>

</stylesheet>
