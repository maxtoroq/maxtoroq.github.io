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
WriteStartElement("ul", ""); {
   foreach (var n in System.Linq.Enumerable.Range(1, 5)) {
      WriteStartElement("li", "");
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

Razor treats markup as text that outputs unchanged. In XCST, elements, attributes and text are compiled to method calls. Serialization (the generation of text) occurs at runtime. This has several benefits:

- One source code, multiple outputs (XML, HTML, XHTML, text)
- Whitespace control (indentation)
- Create an in-memory DOM
- Use an XML-aware tool like XPath or XSLT for unit-testing or post-processing your output

### #3. Extensible

Not only the programs you write in XCST are extensible, but XCST itself is extensible with extension instructions. This project supports a set of extension instructions for web application development based on ASP.NET MVC 5.

```xml
<a:model as='RegisterViewModel'>
   <form method='post'>
      <a:anti-forgery-token/>
      <a:validation-summary/>
   
       Email:  <a:text-box for='Email' /><br />
       Password: <a:text-box for='Password' /><br />
       <button type="submit">Register</button>
   </form>
</a:model>
```

Why choose XCST over C#?
------------------------

### #1. Modularity out-of-the-box

While mainstream languages like C# allow you to combine objects or functions to build programs, building new programs from existing ones is not as easy. Code reuse, both in compiled and source form, is hard to achieve, unless the existing program is carefully designed for it. For instance, to override a function the existing program must accept it as a parameter so a different function can be passed in to be used instead. In other words, dependencies must be parameterized, something known as dependency injection. Dependency injection also allows you to change the behavior of your program at run-time, even if all you want is to compile using a different function without having to modify the existing program.

Dependency injection is a burden on the programmer. You cannot just write your programs, you have to design them. One of the reasons code reuse is generally considered a bad goal is that it leads to complex solutions. Like splitting your program into several classes, each with its own well defined responsibility. Or using a whole set of esoteric functional programming techniques I don't even understand. Or having lots of configuration settings to customize the behavior of your program without having to modify or extend it. Whether it's reusing source code, compiled code, or even copy-and-paste, code reuse would be a lot easier if languages were designed for it. We favor composition over inheritance, while using languages designed for inheritance not composition. It's time for a new paradigm.

**In XCST, code is organized in modules, packages and scripts.** Forget about classes, encapsulation, naming, dependency injection, design patterns and everything that makes programming hard, and code reuse even harder.

### #2. Optimized for content

Whether it's generating web pages or sending XML to a remote API, using XCST means you don't need a two-language code -> template setup, or deal with `TextWriter` or similar APIs that make it hard to visualize what the output will finally look like.

For more information see the [documentation][1].

<div style="text-align: center; margin-top: 2em">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>

[1]: {{ page.documentation_url }}
