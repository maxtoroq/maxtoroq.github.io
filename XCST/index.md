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

Modules and Packages
--------------------
While mainstream languages allow you to combine objects or functions to build programs, building new programs from existing ones is not as easy. Code reuse, both in compiled and source form, is hard to achieve, unless the existing program is carefully designed for it. For instance, to override a function the existing program must accept it as a parameter so a different function can be passed in to be used instead. In other words, dependencies must be parameterized, something known as dependency injection. XCST solves this problem: the same function can be defined in different modules, and the one closest to the principal module is used (a mechanism called import precedence).

Modules have two main disadvantages that packages solve. First, if you have many modules which import the same common module, and that need to be compiled independently, then you are wasting a lot of memory and compilation time by compiling the same common code over and over again. Each compiled module will have its own copy of the common code. The C# analogy are partial classes, which is how modules are implemented in XCST.

Second, the visibility of functions. In modules, functions are always visible to other modules. This makes it hard to hide code, and avoid name clashes (e.g. accidentally override a function). The same problem with partial classes.

Packages are implemented as classes, composed of all the partial classes that represent each module imported by the package. When a package uses another package, it's using another class, therefore solving the duplicate compilation and visibility issues.

Notable differences with XSLT
-----------------------------

### No template rules

At least not for now. Only named templates.

### No qualified names for variables and functions

Variable and function names are mapped directly to C# identifiers, therefore qualified names is not an option. You can still use qualified names for templates, output and attribute set definitions.

### Not structured, not immutable

XCST does not change what *kind* of language C# is. You can do things you can't do in XSLT, like exit early from a template (using `c:return`) or changing the value of a variable (using `c:set`).

Original features
-----------------

### Call the next template or function

`c:next-template` and `c:next-function` are like `xsl:next-match`, but for named templates and functions.

### Type definitions

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

The XCST implementation supports a set of extension instructions for web application development based on ASP.NET MVC 5. See [ASP.NET programming with XCST]({% post_url 2016-04-06-aspnet-programming-with-xcst %}).

Installing
----------

<table border="1" cellpadding="4">
<thead>
<tr>
<th>Package</th>
<th>Description</th>
<th>Target Framework</th>
</tr>
</thead>
<tbody>
<tr>
<td><a href="https://www.nuget.org/packages/Xcst">Xcst</a></td>
<td>Runtime API</td>
<td>.NET 4.5</td>
</tr>
<tr>
<td><a href="https://www.nuget.org/packages/Xcst.Compiler">Xcst.Compiler</a></td>
<td>Compiler API</td>
<td>.NET 4.5</td>
</tr>
<tr>
<td><a href="https://www.nuget.org/packages/Xcst.Web">Xcst.Web</a></td>
<td>XCST pages</td>
<td>.NET 4.5</td>
</tr>
<tr>
<td><a href="https://www.nuget.org/packages/Xcst.Web.Mvc">Xcst.Web.Mvc</a></td>
<td>XCST pages/views and application extension</td>
<td>.NET 4.5</td>
</tr>
</tbody>
</table>

<div style="text-align: center; margin-top: 2em">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>
