---
title: "c:call-template"
---

{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is
regenerated.  
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;c:call-template</span>
  <b>name</b> = <i title="An expanded qualified name. Unprefixed qualified names are in the null namespace.">eqname</i>
  <span>tunnel-params</span>? = <i title="Expression.">expression</i>(<a href="{{ page.bcl_url }}system.object" title="System.Object">Object</a> | <a href="{{ page.bcl_url }}s4ys34ea" title="System.Collections.Generic.IDictionary">IDictionary</a>&lt;<a href="{{ page.bcl_url }}system.string" title="System.String">String</a>, <a href="{{ page.bcl_url }}system.object" title="System.Object">Object</a>&gt;) &gt;
  &lt;!-- Content: <span><a href="with-param.html">c:with-param</a>*</span> --&gt;
<span class="nt">&lt;/c:call-template&gt;</span></code></pre></div>
<p>Invokes a template.</p>
<dl>
   <dt><b>Category</b></dt>
   <dd><i>instruction</i></dd>
   <dt><b>Permitted parent elements</b></dt>
   <dd>Any XCST element whose content model is <i>sequence-constructor</i></dd>
   <dd>Any literal result element</dd>
</dl>
<h2 id="attributes">Attributes</h2>
<div class="table-responsive">
   <table class="ref-attribs">
      <tr>
         <td><code>name</code></td>
         <td>The name of the template to invoke.</td>
      </tr>
      <tr>
         <td><code>tunnel-params</code></td>
         <td>An object with tunnel parameters.</td>
      </tr>
   </table>
</div>
<p><small>
      In addition to the attributes in the preceding table, there are a number of <a href="../docs/standard-attributes.html">standard attributes</a> that may appear on any XCST element.
      </small></p>

{% include_relative _call-template.md %}
