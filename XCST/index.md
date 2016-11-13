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

Why choose XCST over XSLT?
--------------------------
While XSLT is a great tool, there are several reasons why it might not be a good choice.

### #1. Your data is not XML

Converting your objects to XML is possible, but it requires you to follow certain patterns imposed by serialization libraries, and you lose type safety.

### #2. You want more than data

Calling C# functions from XSLT is possible, but it requires special configuration and sometimes translation between XDM types and .NET types.

### #3. XSLT is an overkill

For structured data, fill-in-the-blanks type of templating, XSLT is simply too powerful.

Depending on your scenario, there might be more reasons for choosing XCST over XSLT.

Why choose XCST over Razor?
---------------------------
Razor is a great tool for simple tasks, but it breaks down if you want more out of the code you are writing.

### #1. Improved modularity

Razor doesn't support anything beyond a simple layout/content setup. In XCST, you can statically link modules, use import precedence to override templates and functions, import and override pre-compiled modules (called packages), use tunnel parameters to pass data *in the background* without having to rely on global variables, etc. Everything you write in XCST is strongly-typed and super reusable and extensible, in both source and compiled form.

### #2. Markup is code

Razor treats markup as text that outputs unchanged. In XCST, elements, attributes and text is compiled to method calls. Serialization (the generation of text) occurs at runtime. This has several benefits:

- One source code, multiple outputs (XML, HTML, XML, text)
- White space control (indentation)
- Create an in-memory DOM
- Use an XML-aware tool like XPath or XSLT to unit-test or post-process your program

### #3. Extensible

Not only the programs you write in XCST are extensible, but XCST itself is extensible with extension instructions. This projects supports a [set of extension instructions for web application development based on ASP.NET MVC 5][2].

```xml
<form method='post' class='form-horizontal'>
   <a:anti-forgery-token/>
   <a:validation-summary/>
   <a:editor with-params='new { labelColumnClass = "col-md-3", fieldColumnClass = "col-md-9" }'/>
   <div class='form-group'>
      <div class='col-md-offset-3 col-md-9'>
         <button type='submit' class='btn btn-primary'>Send</button>
      </div>
   </div>
</form>
```

This is only the tip of the iceberg, see [XCST Introduction for the Razor Developer][3].

Modules and Packages
--------------------
While mainstream languages allow you to combine objects or functions to build programs, building new programs from existing ones is not as easy. Code reuse, both in compiled and source form, is hard to achieve, unless the existing program is carefully designed for it. For instance, to override a function the existing program must accept it as a parameter so a different function can be passed in to be used instead. In other words, dependencies must be parameterized, something known as dependency injection. XCST solves this problem: the same function can be defined in different modules, and the one closest to the principal module is used (a mechanism called import precedence).

Modules have two main disadvantages that packages solve. First, if you have many modules which import the same common module, and that need to be compiled independently, then you are wasting a lot of memory and compilation time by compiling the same common code over and over again. Each compiled module will have its own copy of the common code.

Second, the visibility of functions. In modules, functions are always visible to other modules. This makes it hard to hide code, and avoid name clashes (e.g. accidentally override a function).

Packages are implemented as classes, composed of all the partial classes that represent each module imported by the package. When a package uses another package, it's using another class, therefore solving the duplicate compilation and visibility issues.

For more information see the [documentation][1].

<div style="text-align: center; margin-top: 2em">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>

[1]: {{ page.documentation_url }}
[2]: /2016/04/aspnet-programming-with-xcst.html
[3]: docs/xcst-intro-for-razor-dev.html
