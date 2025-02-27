---
title: "a:checkbox"
---

{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is
regenerated.  
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;a:checkbox</span>
  <span>for</span>? = <i title="Expression.">expression</i>
  <span>name</span>? = { <i>string</i> }
  <span>checked</span>? = { <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i> }
  <span>disabled</span>? = { <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i> }
  <span>autofocus</span>? = { <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i> }
  <span>id</span>? = { <i>string</i> }
  <span>class</span>? = { <i>string</i> } &gt;
  &lt;!-- Content: <i>sequence-constructor</i> --&gt;
<span class="nt">&lt;/a:checkbox&gt;</span></code></pre></div>
<p>Creates an &lt;input&gt; element of type 'checkbox'.</p>
<dl>
   <dt><b>Category</b></dt>
   <dd><i>extension-instruction</i></dd>
   <dt><b>Permitted parent elements</b></dt>
   <dd>Any XCST element whose content model is <i>sequence-constructor</i></dd>
   <dd>Any literal result element</dd>
</dl>
<h2 id="attributes">Attributes</h2>
<div class="table-responsive">
   <table class="ref-attribs">
      <tr>
         <td><code>autofocus</code></td>
         <td></td>
      </tr>
      <tr>
         <td><code>checked</code></td>
         <td></td>
      </tr>
      <tr>
         <td><code>class</code></td>
         <td></td>
      </tr>
      <tr>
         <td><code>disabled</code></td>
         <td></td>
      </tr>
      <tr>
         <td><code>for</code></td>
         <td></td>
      </tr>
      <tr>
         <td><code>id</code></td>
         <td></td>
      </tr>
      <tr>
         <td><code>name</code></td>
         <td></td>
      </tr>
   </table>
</div>

{% include_relative _checkbox.md %}
