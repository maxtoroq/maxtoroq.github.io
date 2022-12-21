---
title: XCST
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
- Template rules and modes declarations
- Strongly typed sequence constructors
- Attribute and text value templates
- Temporary trees
- Maps and JSON serialization
- Dynamic loading
- Extension instructions

For more information see the [documentation][1].

<div style="text-align: center; margin-top: 2em">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>

[1]: {{ page.documentation_url }}
