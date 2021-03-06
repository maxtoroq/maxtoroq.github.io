---
title: "c:package"
---

{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is
regenerated.  
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;c:package</span>
  <span>name</span>? = <i title="Type name.">type_name</i>
  <span>visibility</span>? = <span><span class="s">"internal"</span> | <span class="s">"public"</span></span>
  <b>version</b> = <i>decimal</i>
  <b>language</b> = <i>language</i>
  <span>default-mode</span>? = <i title="An expanded qualified name. Unprefixed qualified names are in the null namespace.">eqname</i> &gt;
  &lt;!-- Content: (<span><a href="import-namespace.html">c:import-namespace</a>*</span>, <span><span><i>declaration</i></span>*</span>) --&gt;
<span class="nt">&lt;/c:package&gt;</span></code></pre></div>
<p>Represents an XCST package.</p>
<dl>
   <dt><b>Permitted parent elements</b></dt>
   <dd>None</dd>
</dl>
<h2 id="attributes">Attributes</h2>
<div class="table-responsive">
   <table class="ref-attribs">
      <tr>
         <td><code>default-mode</code></td>
         <td>The default mode of template rules for the current module.</td>
      </tr>
      <tr>
         <td><code>language</code></td>
         <td>The expression language for this module (usually "C#" or "VisualBasic").</td>
      </tr>
      <tr>
         <td><code>name</code></td>
         <td>The fully-qualified class name for the current package.</td>
      </tr>
      <tr>
         <td><code>version</code></td>
         <td>The XCST version for the current and descendant elements (usually "1.0").</td>
      </tr>
      <tr>
         <td><code>visibility</code></td>
         <td>Specifies how the current package can be used from other assemblies.</td>
      </tr>
   </table>
</div>
<p><small>
      In addition to the attributes in the preceding table, there are a number of <a href="../docs/standard-attributes.html">standard attributes</a> that may appear on any XCST element.
      </small></p>

{% include_relative _package.md %}
