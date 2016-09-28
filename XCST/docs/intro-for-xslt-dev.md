---
title: XCST Introduction for the XSLT Developer
---

XCST is heavily inspired in XSLT. The main difference is that it uses C# as expression language, instead of XPath. XCST is therefore not meant as a replacement of XSLT, but as an alternative, or even a complement (e.g. produce XML with XCST and transform it with XSLT).

This guide focuses on the differences between XCST and XSLT. Not every XSLT element has an XCST counterpart, for information about the available elements and attributes see the [schemas][1].

### Contents
- [Why XCST?](#why-xcst)
- [Modules](#modules)
- [QNames](#qnames)
- [Sequence constructors](#sequence-constructors)
- [Variables and parameters](#variables-and-parameters)
- [Temporary trees](#temporary-trees)
- [Templates](#templates)
- [Functions](#functions)
- [Type definitions](#type-definitions)
- [Serialization](#serialization)
- [Dynamic loading](#dynamic-loading)

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

In XCST, a module starts with `c:module`. In addition, the `language` attribute is required:

```xml
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>
   ...
</c:module>
```

While the implementation only supports C#, support for other languages, in this or other implementations, is possible.

You can import other modules with `c:import`, given that they also use the same `language`.

QNames
------
`c:template`, `c:output` and `c:attribute-set` use qualified names. `http://maxtoroq.github.io/XCST` and any namespace that starts with `http://maxtoroq.github.io/XCST/` are reserved.

Variable and function names are mapped directly to C# identifiers, therefore QNames is not an option.

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

...depending on the context. Using an instruction like `c:return` is not allowed in expression mode.

Also note another difference: in the first output, text nodes are compiled to `WriteString` calls, which also produce text nodes. In the second output, text nodes are compiled to `string`. In XCST, **string is a first class citizen**. For example, in XSLT it's not recommended to do this:

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

```csharp
var numbers = new[] { 1, 2, 3 };
```

<div class="note">
The <code>select</code> attribute present in many XSLT instructions like <code>xsl:attribute</code>, <code>xsl:value-of</code>, <code>xsl:sequence</code>, etc. is called <code>value</code> in XCST. The reason is that <em>select</em> doesn't make much sense when there's no such thing as a context item. Also, <code>c:object</code> serves the same purpose as <code>xsl:sequence</code>.
</div>

Variables and parameters
------------------------
Variables are mutable in XCST, as they are in C#.

The types and values for variables and parameters is summarized in the table below.

value attribute | as attribute | content | Effect
------- | ------- | -------- | -------
present | absent | empty | Value is obtained by evaluating the `value` attribute. The type inferred by the expression (e.g. `var` in statement mode).
present | present | empty | Value is obtained by evaluating the `value` attribute, adjusted to the type required by the `as` attribute.
present | absent | present | Compilation error
present | present | present | Compilation error
absent | absent | empty | Variables are not initialized. Template parameters are initialized with `null`. The type is `object`.
absent | present | empty | Variables are not initialized. Template parameters are initialized with the default value of the type (`default(T)` in C#).
absent | absent | present | Value is obtained by evaluating the sequence constructor. The type is inferred from the content (`string` for text nodes).
absent | present | present | Value is obtained by evaluating the sequence constructor, adjusted to the type required by the `as` attribute.

Two notable differences with XSLT: no implicit document nodes and no implicit zero-length strings.

Also, you can have variables that are not initialized, e.g.:

```xml
<c:variable name='i' as='int'/>
<c:if test='int.TryParse("1", out i)'>
   ...
</c:if>
```

Temporary trees
---------------
Temporary trees are currently not supported. Working with XML data is not a priority for XCST, since that's what XSLT is for. However, there might be use cases, so future support is to be considered.

Templates
---------
Template rules are currently not supported, only named templates.

Templates are always compiled in statement mode, and cannot return values. For instance, you cannot do this:

```xml
<xsl:template name="foo" as="xs:integer">
   <xsl:sequence select='1'/>
</xsl:template>
```

This makes templates in XCST more like templates in XSLT 1.0 than 2.0/3.0.

One thing you can do in XCST that XSLT doesn't support is calling the next template based on import precedence (something like `xsl:next-match` but for named templates), using `c:next-template`.

Functions
---------
Functions are always compiled in statement mode, and **can** return values. An explicit `c:return` is therefore required:

```xml
<c:function name="foo" as="int">
   <c:return value='1'/>
</c:function>
```

Functions parameters can have default values (not allowed in XSLT), although the kind of expressions allowed is quite limited (a C# limitation).

You can also call the next function based on import precedence, using `c:next-function`.

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

Serialization
-------------
XPath 3.1 has the `fn:serialize` function that allows you to create a string from XML content.

In XCST, you use the `c:serialize` instruction:

```xml
<c:variable name='fooString'>
   <c:serialize>
      <foo>foo</foo>
   </c:serialize>
</c:variable>
```

Dynamic loading
---------------
XPath 3.1 has the `fn:transform` function that allows you to dynamically load and execute an XSLT transformation.

In XCST, you use the `c:using-module` instruction:

```xml
<c:using-module value='new OtherPackage()'>
   <c:with-param name='foo'>foo</c:with-param>
   <c:call-template name='c:initial-template'>
      <c:with-param name='bar'>bar</c:with-param>
   </c:call-template>
</c:using-module>
```

The `value` attribute is used to provide an instance of a pre-compiled module/package. Loading a module using its URI is planned but currently not supported, as it requires a direct dependency on the C# compiler.

You can send the results to another file with `c:result-document`:

```xml
<c:result-document href='foo.html' method='html'>
   <c:using-module>
      ...  
   </c:using-module>
</c:result-document>
```

Or create a string with `c:serialize`:

```xml
<c:variable name='resultString'>
   <c:serialize method='html'>
      <c:using-module>
         ...  
      </c:using-module>
   </c:serialize>
</c:variable>
```

[1]: {{ page.repository_url }}/tree/master/schemas
