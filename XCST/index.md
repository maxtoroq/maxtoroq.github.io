---
title: XCST
---

**XCST (eXtensible C-Sharp Templates)** is a language for transforming objects into XML documents. It is based on a subset of XSLT (no `apply-templates`) but using C# as expression language and data model, instead of XPath.

XCST compiles to C#. The XCST compiler transforms XCST instructions to C# statements, using the expressions contained in the instructions. Here's an example:

```xml
<ul>
   <c:for-each name='n' in='System.Linq.Enumerable.Range(1, 5)' expand-text='yes'>
      <li>{n}</li>
   </c:for-each>
</ul>
```

...which compiles to:

```csharp
WriteStartElement("ul", @""); {
   foreach (var n in System.Linq.Enumerable.Range(1, 5)) {
      WriteStartElement("li", @"");
      WriteString($@"{n}");
      WriteEndElement();
   }
}
WriteEndElement();
```

<div class="note">
Note how interpolated strings is an essential feature to support attribute and text value templates.
</div>

The generated code is compatible with `System.Xml.XmlWriter`'s API.

Here's a more complete example of an XCST module:

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>

   <c:use-functions in='System.Linq'/>

   <c:output method='html' indent='yes'/>

   <c:template name='c:initial-template' expand-text='yes'>
      <ul>
         <c:for-each name='n' in='Enumerable.Range(1, 5)'>
            <li>{n}</li>
         </c:for-each>
      </ul>
   </c:template>

</c:module>
```

Notable differences with XSLT
-----------------------------

### No template rules

At least not for now. Only named templates.

### No qualified names for variables and functions

Variable and function names are mapped directly to C# identifiers, therefore qualified names are not an option. You can still use qualified names for templates, output and attribute set definitions.

### Not structured, not immutable

XCST does not change what *kind* of language C# is. You can do things you can't do in XSLT, like exit early from a template (using `c:return`) or changing the value of a variable (using `c:set`). Likewise, `c:next-iteration` and `c:break` are not required to be in a tail position.

Original features
-----------------

### Call the next template or function

`c:next-template` and `c:next-function` are like `xsl:next-match`, but for named templates and functions.

### Type definitions

Instead of XSD schemas, you can define C# types using the `c:type` declaration. `c:type` is for data only, not behavior. There are several attributes available that map to presentation and validation attributes in C#. Also, if you omit the `as` attribute in `c:member` you can define child members for a russian doll style of type definition.

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

### Inline C&#35;

Use the `c:script` instruction for inline C#.

```xml
<c:script>
<![CDATA[
// This is C#
]]>
</c:script>
```

### Application extension

The XCST implementation supports a set of extension instructions for web application development based on ASP.NET MVC 5. See the [contact form](https://github.com/maxtoroq/XCST/blob/master/samples/aspnet/contact.xcst) sample.

<div style="text-align: center">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>
