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

Not only the programs you write in XCST are extensible, but XCST itself is extensible with extension instructions. This projects supports a set of extension instructions for web application development based on ASP.NET MVC 5.

```xml
<a:model as='RegisterViewModel'>
   <form action='{Url.Action("RegisterInput", "Demo")}' method='post'>
      <a:anti-forgery-token/>
      <a:validation-summary/>
   
       Email:  <a:text-box for='Email' /><br />
       Password: <a:text-box for='Password' /><br />
       <button type="submit">Register</button>
   </form>
</a:model>
```

For more information see the [documentation][1].

<div style="text-align: center; margin-top: 2em">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>

[1]: {{ page.documentation_url }}
