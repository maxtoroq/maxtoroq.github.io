---
title: "c:import-namespace"
---

{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is
regenerated.  
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;c:import-namespace</span>
  <b>ns</b> = <i title="Namespace name.">namespace_name</i>
  <span>alias</span>? = <i title="Identifier.">identifier</i> /&gt;</code></pre></div>
<p>Imports a namespace.</p>
<dl>
   <dt><b>Permitted parent elements</b></dt>
   <dd><a href="module.html"><code>c:module</code></a></dd>
   <dd><a href="package.html"><code>c:package</code></a></dd>
</dl>
<h2 id="attributes">Attributes</h2>
<div class="table-responsive">
   <table class="ref-attribs">
      <tr>
         <td><code>alias</code></td>
         <td>An alias for the namespace.</td>
      </tr>
      <tr>
         <td><code>ns</code></td>
         <td>The namespace to import.</td>
      </tr>
   </table>
</div>
<p><small>
      In addition to the attributes in the preceding table, there are a number of <a href="../docs/standard-attributes.html">standard attributes</a> that may appear on any XCST element.
      </small></p>

{% include_relative _import-namespace.md %}
