---
title: XCST
---

**XCST (eXtensible C-Sharp Templates)** is a language for transforming objects into XML documents. It is based on a subset of XSLT (no `apply-templates`) but using C# as expression language and data model, instead of XPath.

XCST programs are organized in modules. A module is an XML file with declarations (templates, functions, variables, etc.) that can import other modules. Modules are extensible; an importing module can override declarations of an imported module.

XCST itself is also extensible, using extension instructions, which are elements in a namespace designated as an extension namespace (using the standard `[c:]extension-element-prefixes` attribute).

XCST compiles to C#. The XCST compiler transforms XCST instructions to C# statements, using the expressions contained in the instructions. Here's an example:

```xml
<ul>
   <c:for-each name="n" in="System.Linq.Enumerable.Range(1, 5)" expand-text="yes">
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

> Note how interpolated strings is an essential feature to support attribute and text value templates.

The generated code is compatible with `System.Xml.XmlWriter`'s API.

Here's a more complete example of an XCST module:

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>

   <c:use-functions in='System.Linq'/>

   <c:output method='html' indent='yes'/>

   <c:template name='c:initial-template' expand-text='yes'>
      <ul>
         <c:for-each name="n" in="Enumerable.Range(1, 5)">
            <li>{n}</li>
         </c:for-each>
      </ul>
   </c:template>

</c:module>
```

<div style="text-align: center">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>