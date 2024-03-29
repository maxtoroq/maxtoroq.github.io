---
title: "c:next-match"
---

{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is
regenerated.  
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;c:next-match</span>
  <span>with-params</span>? = <i title="Expression.">expression</i>(<a href="{{ page.bcl_url }}system.object" title="System.Object">Object</a> | <a href="{{ page.bcl_url }}s4ys34ea" title="System.Collections.Generic.IDictionary">IDictionary</a>&lt;<a href="{{ page.bcl_url }}system.string" title="System.String">String</a>, <a href="{{ page.bcl_url }}system.object" title="System.Object">Object</a>&gt;)
  <span>tunnel-params</span>? = <i title="Expression.">expression</i>(<a href="{{ page.bcl_url }}system.object" title="System.Object">Object</a> | <a href="{{ page.bcl_url }}s4ys34ea" title="System.Collections.Generic.IDictionary">IDictionary</a>&lt;<a href="{{ page.bcl_url }}system.string" title="System.String">String</a>, <a href="{{ page.bcl_url }}system.object" title="System.Object">Object</a>&gt;) &gt;
  &lt;!-- Content: <span><a href="with-param.html">c:with-param</a>*</span> --&gt;
<span class="nt">&lt;/c:next-match&gt;</span></code></pre></div>
<p>Invokes the next template rule that matches the current input.</p>
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
         <td><code>tunnel-params</code></td>
         <td>An object with tunnel parameters.</td>
      </tr>
      <tr>
         <td><code>with-params</code></td>
         <td>An object with parameters.</td>
      </tr>
   </table>
</div>
<p><small>
      In addition to the attributes in the preceding table, there are a number of <a href="../docs/standard-attributes.html">standard attributes</a> that may appear on any XCST element.
      </small></p>

{% include_relative _next-match.md %}
