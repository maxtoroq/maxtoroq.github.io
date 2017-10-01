---
title: "c:map-entry"
---

{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is
regenerated.  
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;c:map-entry</span>
  <b>key</b> = <i title="Expression.">expression</i>
  <span>value</span>? = <i title="Expression.">expression</i> &gt;
  &lt;!-- Content: <span><i>sequence-constructor</i></span> --&gt;
<span class="nt">&lt;/c:map-entry&gt;</span></code></pre></div>
<p>Creates a map entry.</p>
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
         <td><code>key</code></td>
         <td>The key of the entry.</td>
      </tr>
      <tr>
         <td><code>value</code></td>
         <td>The value of the entry.</td>
      </tr>
   </table>
</div>
<p><small>
      In addition to the attributes in the preceding table, there are a number of <a href="../docs/standard-attributes.html">standard attributes</a> that may appear on any XCST element.
      </small></p>

{% include_relative _map-entry.md %}