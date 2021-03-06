---
title: "c:switch"
---

{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is
regenerated.  
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;c:switch</span>
  <b>value</b> = <i title="Expression.">expression</i> &gt;
  &lt;!-- Content: (<span><a href="when.html">c:when</a>+</span>, <span><a href="otherwise.html">c:otherwise</a>?</span>) --&gt;
<span class="nt">&lt;/c:switch&gt;</span></code></pre></div>
<p>Chooses between multiple alternatives for a given value.</p>
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
         <td><code>value</code></td>
         <td>The value to match.</td>
      </tr>
   </table>
</div>
<p><small>
      In addition to the attributes in the preceding table, there are a number of <a href="../docs/standard-attributes.html">standard attributes</a> that may appear on any XCST element.
      </small></p>

{% include_relative _switch.md %}
