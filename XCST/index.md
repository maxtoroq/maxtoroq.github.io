---
title: XCST
article_toc: false
sticky_header: true
---

**XCST (eXtensible C-Sharp Templates)** is a language optimized for the production of XML and other formats. It's a more general-purpose version of XSLT.

XCST compiles to C# or Visual Basic. The XCST compiler transforms XCST instructions to statements, using the expressions contained in the instructions. Here's an example of an XCST module:

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>

   <c:import-namespace ns='System.Linq'/>

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

### Notable XSLT features implemented in XCST

- Packages and modules
- Named templates, functions, attribute sets and output definitions
- Template rules and shallow copy modes (XML only)
- Strongly typed sequence constructors
- Attribute and text value templates
- Temporary trees
- Maps and JSON serialization
- Dynamic loading
- Extension instructions

Why choose XCST over XSLT
-------------------------
While XSLT is a great tool, there are several reasons why it might not be a good choice.

### Your data is not XML

Converting your objects to XML is possible, but it requires you to follow certain patterns imposed by serialization libraries, and you lose type safety.

### You want more than data

Calling C# functions from XSLT is possible, but it requires special configuration and sometimes translation between XDM types and .NET types.

### XSLT is an overkill

For structured data, fill-in-the-blanks type of templating, XSLT is simply too powerful.

Depending on your scenario, there might be more reasons for choosing XCST over XSLT.

Why choose XCST over "X" template engine
----------------------------------------

### Improved modularity

Most template engines don't support anything beyond a simple layout/content setup. In XCST, you can statically link modules, use import precedence to override templates and functions, import and override pre-compiled modules (called packages), use tunnel parameters to pass data *in the background* without having to rely on global variables, etc. Everything you write in XCST is strongly-typed and super reusable and extensible, in both source and compiled form.

### Markup is code

In XCST, elements, attributes and text are compiled to method calls. Serialization (the generation of text) occurs at run-time. This has several benefits:

- One source code, multiple outputs (XML, HTML, text and JSON)
- Whitespace control (indentation)
- Create an in-memory DOM
- Use an XML-aware tool like XPath or XSLT for unit-testing or post-processing your output

### Extensible

Not only the programs you write in XCST are extensible, but XCST itself is extensible with extension instructions. This project supports a set of extension instructions for web application development based on ASP.NET MVC.

```xml
<a:form method='post' model-type='RegisterViewModel' antiforgery='yes'>
   <a:validation-summary/>

    Email:  <a:editor for='Email'/><br/>
    Password: <a:editor for='Password'/><br/>
    <button type="submit">Register</button>
</a:form>
```

Why choose XCST over C# and Visual Basic
----------------------------------------

### Modularity out-of-the-box

While mainstream languages like C# allow you to combine objects or functions to build programs, building new programs from existing ones is not as easy. Code reuse, both in compiled and source form, is hard to achieve, unless the existing program is carefully designed for it. For instance, to override a function the existing program must accept it as a parameter so a different function can be passed in to be used instead. In other words, dependencies must be parameterized, something known as dependency injection. Dependency injection also allows you to change the behavior of your program at run-time, even if all you want is to compile using a different function without having to modify the existing program.

Dependency injection is a burden on the programmer. You cannot just write your programs, you have to design them. One of the reasons code reuse is generally considered a bad goal is that it leads to complex solutions. Like splitting your program into several classes, each with its own well defined responsibility. Or using a whole set of esoteric functional programming techniques I don't even understand. Or having lots of configuration settings to customize the behavior of your program without having to modify or extend it. Whether it's reusing source code, compiled code, or even copy-and-paste, code reuse would be a lot easier if languages were designed for it. We favor composition over inheritance, while using languages designed for inheritance not composition. It's time for a new paradigm.

**In XCST, code is organized in modules and packages.** Forget about classes, encapsulation, inheritance, naming, dependency injection, design patterns and everything that makes programming hard, and code reuse even harder.

### Optimized for content

Whether it's generating web pages or sending XML to a remote API, using XCST means you don't need a two-language *code + template* setup, or deal with `TextWriter` or similar APIs that make it hard to visualize what the output will finally look like.

For more information see the [documentation][1].

<div style="text-align: center; margin-top: 2em">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>

[1]: {{ page.documentation_url }}
