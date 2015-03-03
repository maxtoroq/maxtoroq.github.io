---
title: Razor vs. XSLT
date: 2013-07-07 20:25:00 -0400
tags: [asp.net mvc, asp.net web pages, razor, xslt]
---

Razor and XSLT are both excellent tools. The following table compares their strengths and weaknesses, you decide which capabilities are most important for your particular scenario. Feedback is welcome, and I intend to update this table as both languages evolve.

<table border="1">
   <thead>
      <tr>
         <th>Capability</th>
         <th>Razor</th>
         <th>XSLT</th>
      </tr>
   </thead>
   <tbody>
      <tr>
         <td>Process XML (or normalized HTML)</td>
         <td style="background-color: lightyellow;">Requires external component like DOM or LINQ to XML, 
            or conversion to objects</td>
         <td style="background-color: lightgreen;">XPath</td>
      </tr>
      <tr>
         <td>Process objects</td>
         <td style="background-color: lightgreen;">C# or VB</td>
         <td style="background-color: lightyellow;">Requires conversion to in-memory representation (e.g. DOM), data 
            only, no functions</td>
      </tr>
      <tr>
         <td>Modularity</td>
         <td style="background-color: lightyellow;">File-based. In App_Code, directories map to namespaces, files to 
            classes and helpers to methods.</td>
         <td style="background-color: lightgreen;">URI-based (XmlResolver extensibility), stylesheets, templates (modes), 
            namespaces (QNames)</td>
      </tr>
      <tr>
         <td>Inheritance</td>
         <td style="background-color: lightyellow;">Layouts, start pages (_PageStart, _ViewStart)</td>
         <td style="background-color: lightgreen;"><code>xsl:import</code></td>
      </tr>
      <tr>
         <td>Template overriding</td>
         <td style="background-color: lightyellow;">Abstract sections</td>
         <td style="background-color: lightgreen;">Template precedence, <code>xsl:next-match</code> in v2, <code>xsl:apply-imports</code> in v1</td>
      </tr>
      <tr>
         <td>Dynamic invoke</td>
         <td style="background-color: lightgreen;"><code>RenderPage</code>/<code>RenderPartial</code></td>
         <td style="background-color: lightyellow;">Must import module (some processors have extensions)</td>
      </tr>
      <tr>
         <td>Processing styles</td>
         <td style="background-color: lightyellow;">Pull. ASP.NET MVC has some push support with <code>Html.EditorFor</code> and <code>Html.DisplayFor</code>.</td>
         <td style="background-color: lightgreen;">Push and pull</td>
      </tr>
      <tr>
         <td>Post-process output (multi-step, chaining)</td>
         <td style="background-color: lightsalmon;">Not supported</td>
         <td style="background-color: lightgreen;">v2 or <code>exsl:node-set</code> in v1</td>
      </tr>
      <tr>
         <td rowspan="2">Type system</td>
         <td rowspan="2" style="background-color: lightgreen;">.NET, static and dynamic</td>
         <td style="background-color: lightyellow;">v1 has
            5 data types: String, number, boolean, node-set and result tree fragment. </td>
      </tr>
      <tr>
         <td style="background-color: lightyellow;">v2 has sequences and 20+ atomic types. Complex types and PSVI 
            requires schema-awareness (XML Schema).</td>
      </tr>
      <tr>
         <td>Function library</td>
         <td style="background-color: lightgreen;">Everything .NET</td>
         <td style="background-color: lightyellow;">Limited but extensible</td>
      </tr>
      <tr>
         <td>Delegated templates</td>
         <td style="background-color: lightgreen;">e.g. <code>Func&lt;dynamic, object&gt; b = @&lt;strong&gt;@item&lt;/strong&gt;;</code></td>
         <td style="background-color: lightyellow;"><a href="http://fxsl.sourceforge.net/articles/FuncProg/0.html">Template reference technique</a></td>
      </tr>
      <tr>
         <td>Serialization</td>
         <td style="background-color: lightyellow;">HTML (default encoding). <a href="https://github.com/Antaris/RazorEngine">RazorEngine</a> library provides encoding 
            extensibility.</td>
         <td style="background-color: lightgreen;">XML, HTML, XHTML and text. Indentation and whitespace control. 
            XmlWriter extensibility.</td>
      </tr>
      <tr>
         <td>Framework integration</td>
         <td style="background-color: lightgreen;">ASP.NET MVC: Display and editor templates, data annotations 
            attribute-based validation, URL generation.</td>
         <td style="background-color: lightsalmon;">Not available</td>
      </tr>
      <tr>
         <td>Portability</td>
         <td style="background-color: lightyellow;">.NET and Mono</td>
         <td style="background-color: lightgreen;">Available in many frameworks, languages, operating systems and 
            browsers</td>
      </tr>
   </tbody>
</table>

### XSLT tools for .NET/Visual Studio

- [XSLT 2.0 Schema][1] (for intellisense)
- [XSLT View Engine][2] (XslCompiledTransform)
- [Saxon XSLT 2.0 and XQuery 1.0 View Engines][3]
- [SgmlReader][4]

### Further Reading

- [Why Use XSLT in Server Side Web Frameworks For Output Generation?][5]
- [Using Razor and XSLT in the same project][6]

[1]: http://www.w3.org/2007/11/schema-for-xslt20.xsd
[2]: http://nuget.org/packages/XsltViewEngine
[3]: http://nuget.org/packages/SaxonViewEngine
[4]: http://nuget.org/packages/SgmlReader
[5]: http://www.onenaught.com/posts/8/xslt-in-server-side-web-frameworks
[6]: {{ site.url }}/2014/02/using-razor-and-xslt-in-same-project.html