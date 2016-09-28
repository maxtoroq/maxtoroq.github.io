---
title: XCST Introduction for the XSLT Developer
---

XCST is heavily inspired in XSLT. The main difference is that it uses C# as expression language, instead of XPath. XCST is therefore not meant as a replacement of XSLT, but as an alternative, or even a complement (e.g. produce XML with XCST and transform it with XSLT).

### Contents
- [Why XCST?](#why-xcst)
- [Modules](#modules)
- [Sequence constructors](#sequence-constructors)
- [QNames](#qnames)

Why XCST?
---------
While XSLT is a great tool, there are several reasons why it might not be a good choice.

### #1. Your data is not XML
Converting your objects to XML is possible, but it requires you to follow certain patterns imposed by serialization libraries.

### #2. You want more than data
Calling C# functions from XSLT is possible, but it requires special configuration and sometimes translation between XDM types and .NET types.

### #3. XSLT is an overkill
For structured data, fill-in-the-blanks type of templating, XSLT is simply too powerful.

Depending on your scenario, there might be more reasons for choosing XCST over XSLT.

Modules
-------
In XSLT, a module starts with `xsl:stylesheet` or `xsl:transform`.

In XCST, a module starts with `c:module`.

QNames
------
Variable and function names are mapped directly to C# identifiers, therefore qualified names is not an option. You can still use qualified names for templates, output and attribute set definitions.

Sequence constructors
---------------------
XCST is not a strictly structured language like XSLT. You can exit early from a template (using `c:return`), or from a loop (using `c:break` or `c:continue`). Sequence constructors are compiled in two modes: statement or expression. For instance, the following code:

```xml
<c:choose>
   <c:when test='foo'>foo</c:when>
   <c:otherwise>bar</c:otherwise>
</c:choose>
```

...can be compiled to:

```csharp
if (foo) {
   WriteString("foo");
} else {
   WriteString("bar");
}
```

...or:

```csharp
(foo) ? "foo" : "bar"
```

Using an instruction like `c:return` is not allowed in expression mode.

Also note another difference: in the first output, text nodes are compiled to `WriteString` calls, which also produce text nodes. In the second output, text nodes are compiled to `string`. XCST makes strings a first class citizen. For example, in XSLT it's not recommended to do this:

```xml
<xsl:attribute name="foo">foo</xsl:attribute>
```

...because you are creating a text node that has to be atomized. Instead, you should do this:

```xml
<xsl:attribute name="foo" select="'foo'"/>
```

In XCST, you can use a text node where a string is expected or desired:

```xml
<c:attribute name='foo'>foo</c:attribute>
<c:variable name='bar'>bar</c:variable>
<c:assert test='bar.GetType() == typeof(string)'/>
```

Call the next template or function
----------------------------------
`c:next-template` and `c:next-function` are like `xsl:next-match`, but for named templates and functions.

Type definitions
----------------
Instead of XSD schemas, you can define C# types using the `c:type` declaration. `c:type` is for data only, not behavior. There are several attributes available that map to presentation and validation attributes in .NET. Also, if you omit the `as` attribute in `c:member` you can define child members for a russian doll style of type definition.

```xml
<c:type name='Order'>
   <c:member name='Name' as='string' required='yes'/>
   <c:member name='Email' as='string' required='yes' display-name='E-mail'/>
   <c:member name='Telephone' as='string' required='yes'/>
   <c:member name='ShippingAddress' required='yes'>
      <c:member name='Line1' as='string' required='yes'/>
      <c:member name='Line2' as='string' required='yes'/>
      <c:member name='City' as='string' required='yes'/>
      <c:member name='Region' as='string' required='yes'/>
      <c:member name='Country' as='string' required='yes' min-length='2' max-length='2'/>
   </c:member>
</c:type>
```

Inline C&#35;
-------------
Use the `c:script` instruction for inline C#.

```xml
<c:script>
<![CDATA[
// This is C#
]]>
</c:script>
```
