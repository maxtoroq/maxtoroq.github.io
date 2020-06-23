<?xml version="1.0" encoding="utf-8"?>
<stylesheet version="2.0"
   xmlns="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="#all">

   <param name="indent-chars" select="'  '" as="xs:string"/>
   <param name="initial-indent" select="0" as="xs:integer"/>

   <output method="text"/>

   <template match="/*/topic">
      <!-- Ignore root topic, added on static toc -->
      <apply-templates>
         <with-param name="indent" select="$initial-indent + 1" tunnel="yes"/>
      </apply-templates>
   </template>

   <template match="text()"/>

   <template match="topic">
      <param name="indent" as="xs:integer" tunnel="yes"/>

      <variable name="topic-kind" select="substring-before(@id, ':')"/>
      <variable name="url-parts" select="tokenize(replace(replace(@file, '/README\.md$', '/'), '.md$', '.html'), '/')"/>
      <variable name="url" select="string-join($url-parts[
         if ($topic-kind eq 'N') then true()
         else if ($topic-kind eq 'T') then position() gt 1
         else position() eq last()], '/')"/>

      <call-template name="new-line-indented">
         <with-param name="indent" select="$indent - 1" tunnel="yes"/>
      </call-template>
      <text>- title: </text>
      <value-of select="@title"/>
      <call-template name="new-line-indented"/>
      <text>url: </text>
      <value-of select="$url"/>
      <if test="topic and not($topic-kind eq 'T')">
         <call-template name="new-line-indented"/>
         <text>toc:</text>
         <apply-templates select="topic">
            <with-param name="indent" select="$indent + 2" tunnel="yes"/>
         </apply-templates>
         <call-template name="new-line-indented"/>
      </if>
   </template>

   <template name="new-line-indented">
      <param name="indent" as="xs:integer" tunnel="yes"/>

      <text>&#xD;&#xA;</text>
      <value-of select="for $p in (1 to $indent) return $indent-chars" separator=""/>
   </template>

</stylesheet>
