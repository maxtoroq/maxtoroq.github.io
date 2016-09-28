---
title: XCST Introduction for the XSLT Developer
---

XCST is heavily inspired in XSLT. The main difference is that it uses C# as expression language, instead of XPath. XCST is therefore not meant as a replacement of XSLT, but as an alternative, or even a complement (e.g. produce XML with XCST and transform it with XSLT).

### Contents
- [Why XCST?](#why-xcst)
- [Modules](#modules)
- [QNames](#qnames)
- [Sequence constructors](#sequence-constructors)
- [Type definitions](#type-definitions)

Why XCST?
---------
While XSLT is a great tool, there are several reasons why it might not be a good choice.

### #1. Your data is not XML
Converting your objects to XML is possible, but it requires you to follow certain patterns imposed by serialization libraries, and you lose type safety.

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

In expression mode, if a sequence constructor has more than one children it's compiled into an array, e.g.:

```xml
<c:variable name='numbers'>
   <c:object value='1'/>
   <c:object value='2'/>
   <c:object value='3'/>
</c:variable>
```

...is compiled to:

```
var numbers = new[] { 1, 2, 3 };
```

<div class="note">
The <code>select</code> attribute present in many XSLT instructions like <code>xsl:attribute</code>, <code>xsl:value-of</code>, <code>xsl:sequence</code>, etc. is called <code>value</code> in XCST. The reason is that <em>select</em> doesn't make much sense when there's no such thing as a context item. Also, <code>c:object</code> serves the same purpose as <code>xsl:sequence</code>.
</div>

Templates
---------
Templates are always compiled in statement mode, and cannot return values. For instance, you cannot do this:

```xml
<xsl:template name="foo" as="xs:integer">
   <xsl:sequence select='1'/>
</xsl:template>
```

This makes templates in XCST more like templates in XSLT 1.0 than 2.0/3.0.

`c:next-template` and `c:next-function` are like `xsl:next-match`, but for named templates and functions.

Functions
---------
Functions are always compiled in statement mode, and **can** return values. An explicit `c:return` is therefore required:

```xml
<c:function name="foo" as="int">
   <c:return value='1'/>
</c:function>
```

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
