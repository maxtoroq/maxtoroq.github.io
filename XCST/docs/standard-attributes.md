---
title: "Standard Attributes"
---

{% comment %}
This page was generated by a tool.

Changes to this file may cause incorrect behavior and will be lost if
the page is regenerated.
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;c:example-element</span>
  <span>expand-text</span>? = <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">Boolean</i>
  <span>extension-element-prefixes</span>? = <span><span>(<i>NCName</i> | <span class="s">"#default"</span>)</span>*</span>
  <span>transform-text</span>? = <span><span class="s">"none"</span> | <span class="s">"normalize-space"</span> | <span class="s">"trim"</span></span>
  <span>version</span>? = <i>Decimal</i> /&gt;</code></pre></div>
<p>
   This page details the <b>standard attributes</b> that may appear on any XCST element. The above example defines a non-existent element
   <code>c:example-element</code>.
   
</p>
<p>
   These attributes may also appear on a literal result element, but in this case, to
   distinguish them from user-defined attributes, the names of the attributes are in
   the XCST namespace. They are thus typically written as <code>c:version</code>, <code>c:extension-element-prefixes</code>, <code>c:expand-text</code>, etc.
   
</p>
<p>Because these attributes may appear on any XCST element, they are not listed in the
   syntax summary of each individual element.
</p>
<h2>Attributes</h2>
<div class="table-responsive">
   <table class="ref-attribs">
      <tr>
         <td><code>[c:]expand-text</code></td>
         <td>Enables or disables text value templates for descendant text nodes.</td>
      </tr>
      <tr>
         <td><code>[c:]extension-element-prefixes</code></td>
         <td>Designates namespaces as extension namespaces.</td>
      </tr>
      <tr>
         <td><code>[c:]transform-text</code></td>
         <td>Enables or disables text normalization for descendant text nodes.</td>
      </tr>
      <tr>
         <td><code>[c:]version</code></td>
         <td>The XCST version for the current and descendant elements (usually "1.0").</td>
      </tr>
   </table>
</div>