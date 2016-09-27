---
title: XCST Introduction for the XSLT Developer
---

XCST is heavily inspired in XSLT. The main difference is that it uses C# as expression language, instead of XPath. XCST is therefore not meant as a replacement of XSLT, but as an alternative, or even a complement (e.g. produce XML with XCST and transfor it with XSLT).

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

Not structured, not immutable
-----------------------------
XCST does not change what *kind* of language C# is. You can do things you can't do in XSLT, like exit early from a template (using `c:return`) or changing the value of a variable (using `c:set`).

No template rules
-----------------
At least not for now. Only named templates.

No qualified names for variables and functions
----------------------------------------------
Variable and function names are mapped directly to C# identifiers, therefore qualified names is not an option. You can still use qualified names for templates, output and attribute set definitions.

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
