---
title: "c:member"
---

{% comment %}  
**This page was generated by a tool.**  

Changes to this file may cause incorrect behavior and will be lost if the page is
regenerated.  
{% endcomment %}

<div class="ref-element-syntax language-xml highlighter-rouge"><pre class="highlight"><code><span class="nt">&lt;c:member</span>
  <b>name</b> = <i title="Identifier.">identifier</i>
  <span>as</span>? = <i title="Type name.">type_name</i>
  <span>value</span>? = <i title="Expression.">expression</i>
  <span>expression</span>? = <i title="Expression.">expression</i>
  <span>auto-initialize</span>? = <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i>
  <span>display</span>? = <span><span class="s" title="Indicates that this member should only be displayed in a viewing UI.">"view-only"</span> | <span class="s" title="Indicates that this member should only be displayed in an editing UI.">"edit-only"</span> | <span class="s" title="Indicates that this member should only be displayed in an editing UI as a hidden field.">"hidden"</span> | <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i></span>
  <span>display-name</span>? = <i>string</i>
  <span>description</span>? = <i>string</i>
  <span>short-name</span>? = <i>string</i>
  <span>edit-hint</span>? = <i>string</i>
  <span>order</span>? = <i>integer</i>
  <span>group</span>? = <i>string</i>
  <span>format</span>? = <i>string</i>
  <span>apply-format-in-edit-mode</span>? = <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i>
  <span>disable-output-escaping</span>? = <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i>
  <span>null-text</span>? = <i>string</i>
  <span>data-type</span>? = <span><span class="s">"CreditCard"</span> | <span class="s">"Currency"</span> | <span class="s">"Date"</span> | <span class="s">"DateTime"</span> | <span class="s">"Duration"</span> | <span class="s">"EmailAddress"</span> | <span class="s">"Html"</span> | <span class="s">"ImageUrl"</span> | <span class="s">"MultilineText"</span> | <span class="s">"Password"</span> | <span class="s">"PhoneNumber"</span> | <span class="s">"PostalCode"</span> | <span class="s">"Text"</span> | <span class="s">"Time"</span> | <span class="s">"Upload"</span> | <span class="s">"Url"</span></span>
  <span>template</span>? = <i>string</i>
  <span>required</span>? = <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i>
  <span>max-length</span>? = <i>integer</i>
  <span>min-length</span>? = <i>integer</i>
  <span>pattern</span>? = <i>string</i>
  <span>min</span>? = <i>string</i>
  <span>max</span>? = <i>string</i>
  <span>equal-to</span>? = <i title="Identifier.">identifier</i>
  <span>serialize</span>? = <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i>
  <span>allow-empty-string</span>? = <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i>
  <span>text-member</span>? = <i title="Identifier.">identifier</i>
  <span>required-message</span>? = <i>string</i>
  <span>min-length-message</span>? = <i>string</i>
  <span>max-length-message</span>? = <i>string</i>
  <span>pattern-message</span>? = <i>string</i>
  <span>range-message</span>? = <i>string</i>
  <span>equal-to-message</span>? = <i>string</i>
  <span>a:file-extensions</span>? = <i>file-extensions</i>
  <span>a:file-max-length</span>? = <i>integer</i>
  <span>a:bind</span>? = <i title="One of the values &#34;yes&#34;, &#34;no&#34;, &#34;true&#34;, &#34;false&#34;, &#34;1&#34; or &#34;0&#34;.">boolean</i>
  <span>a:file-extensions-message</span>? = <i>string</i>
  <span>a:file-max-length-message</span>? = <i>string</i> &gt;
  &lt;!-- Content: (<span><a href="meta.html">c:meta</a>*</span>, <span><span><a href="member.html">c:member</a>*</span></span>) --&gt;
<span class="nt">&lt;/c:member&gt;</span></code></pre></div>
<p>Defines a type member.</p>
<dl>
   <dt><b>Permitted parent elements</b></dt>
   <dd><a href="member.html"><code>c:member</code></a></dd>
   <dd><a href="type.html"><code>c:type</code></a></dd>
</dl>
<h2 id="attributes">Attributes</h2>
<div class="table-responsive">
   <table class="ref-attribs">
      <tr>
         <th colspan="2">Definition</th>
      </tr>
      <tr>
         <td><code>as</code></td>
         <td>The type of the member.</td>
      </tr>
      <tr>
         <td><code>auto-initialize</code></td>
         <td>Auto-assign an initial value to this member.</td>
      </tr>
      <tr>
         <td><code>expression</code></td>
         <td>An expression for computed members.</td>
      </tr>
      <tr>
         <td><code>name</code></td>
         <td>The name of the member.</td>
      </tr>
      <tr>
         <td><code>value</code></td>
         <td>An initial value for this member.</td>
      </tr>
      <tr>
         <th colspan="2">Presentation</th>
      </tr>
      <tr>
         <td><code>apply-format-in-edit-mode</code></td>
         <td>Specifies if the display format should be used in an edit control for this member.</td>
      </tr>
      <tr>
         <td><code>data-type</code></td>
         <td>A more specific type. Using this attribute can be a way to provide default values
            to the 'format' and 'template' attributes, and for using a specific input type in
            HTML.
         </td>
      </tr>
      <tr>
         <td><code>description</code></td>
         <td>A description of this member suitable for UI.</td>
      </tr>
      <tr>
         <td><code>disable-output-escaping</code></td>
         <td>Specifies if this member should not be escaped when displaying in a UI (e.g. HTML
            content).
         </td>
      </tr>
      <tr>
         <td><code>display</code></td>
         <td>Specifies if this member should be displayed in a UI.</td>
      </tr>
      <tr>
         <td><code>display-name</code></td>
         <td>A name suitable for UI.</td>
      </tr>
      <tr>
         <td><code>edit-hint</code></td>
         <td>A hint to the user of what can be entered in a control for this member.</td>
      </tr>
      <tr>
         <td><code>format</code></td>
         <td>A formatting string that specifies the display format for the value of this member.</td>
      </tr>
      <tr>
         <td><code>group</code></td>
         <td>A name that is used to group members in a UI.</td>
      </tr>
      <tr>
         <td><code>null-text</code></td>
         <td>A text that is displayed for this member when the value is null.</td>
      </tr>
      <tr>
         <td><code>order</code></td>
         <td>A number that indicates the relative position of this member in a UI.</td>
      </tr>
      <tr>
         <td><code>short-name</code></td>
         <td>A shorter name suitable for UI where the display name would be too long to fit (e.g.
            a table column).
         </td>
      </tr>
      <tr>
         <td><code>template</code></td>
         <td>The name of a template to use when displaying this member in a UI.</td>
      </tr>
      <tr>
         <td><code>text-member</code></td>
         <td>The name of the member to use as the text representation for this type.</td>
      </tr>
      <tr>
         <th colspan="2">Validation</th>
      </tr>
      <tr>
         <td><code>allow-empty-string</code></td>
         <td>Specifies if an empty string is a valid value for this member.</td>
      </tr>
      <tr>
         <td><code>equal-to</code></td>
         <td>The name of another member that a valid value for this member should be equal to.</td>
      </tr>
      <tr>
         <td><code>equal-to-message</code></td>
         <td>An error message for the equal-to attribute.</td>
      </tr>
      <tr>
         <td><code>max</code></td>
         <td>A maximum valid value for this member.</td>
      </tr>
      <tr>
         <td><code>max-length</code></td>
         <td>A maximum valid length for this member.</td>
      </tr>
      <tr>
         <td><code>max-length-message</code></td>
         <td>An error message for the max-length attribute.</td>
      </tr>
      <tr>
         <td><code>min</code></td>
         <td>A minimum valid value for this member.</td>
      </tr>
      <tr>
         <td><code>min-length</code></td>
         <td>A minimum valid length for this member.</td>
      </tr>
      <tr>
         <td><code>min-length-message</code></td>
         <td>An error message for the min-length attribute.</td>
      </tr>
      <tr>
         <td><code>pattern</code></td>
         <td>A regular expression that a valid value for this member must conform to.</td>
      </tr>
      <tr>
         <td><code>pattern-message</code></td>
         <td>An error message for the pattern attribute.</td>
      </tr>
      <tr>
         <td><code>range-message</code></td>
         <td>An error message for the min and max attributes.</td>
      </tr>
      <tr>
         <td><code>required</code></td>
         <td>Specifies if this member is required.</td>
      </tr>
      <tr>
         <td><code>required-message</code></td>
         <td>An error message for the required attribute.</td>
      </tr>
      <tr>
         <td><code>a:file-extensions</code></td>
         <td>A comma-separated list of valid file extensions for this member.</td>
      </tr>
      <tr>
         <td><code>a:file-extensions-message</code></td>
         <td>An error message for the a:file-extensions attribute.</td>
      </tr>
      <tr>
         <td><code>a:file-max-length</code></td>
         <td>A maximum valid file length for this member.</td>
      </tr>
      <tr>
         <td><code>a:file-max-length-message</code></td>
         <td>An error message for the a:file-max-length attribute.</td>
      </tr>
      <tr>
         <th colspan="2">Serialization</th>
      </tr>
      <tr>
         <td><code>serialize</code></td>
         <td>Specifies if this member should be considered when serializing an instance of the
            type.
         </td>
      </tr>
      <tr>
         <th colspan="2">Model Binding</th>
      </tr>
      <tr>
         <td><code>a:bind</code></td>
         <td>Specifies if this member should be included or excluded from model binding.</td>
      </tr>
   </table>
</div>
<p><small>
      In addition to the attributes in the preceding table, there are a number of <a href="../docs/standard-attributes.html">standard attributes</a> that may appear on any XCST element.
      </small></p>

{% include_relative _member.md %}
