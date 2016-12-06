---
title: XCST Elements Reference
---

<h3>Namespace Bindings</h3>
<ul>
   <li>c = <b>http://maxtoroq.github.io/XCST</b></li>
   <li>a = <b>http://maxtoroq.github.io/XCST/application</b></li>
</ul>
<h2>XCST Elements</h2>
<ul>
   <li><a href="../c/assert.html">c:assert</a> &nbsp;<a href="../c/attribute.html">c:attribute</a> &nbsp;<a href="../c/attribute-set.html">c:attribute-set</a></li>
   <li><a href="../c/break.html">c:break</a></li>
   <li><a href="../c/call-template.html">c:call-template</a> &nbsp;<a href="../c/catch.html">c:catch</a> &nbsp;<a href="../c/choose.html">c:choose</a> &nbsp;<a href="../c/comment.html">c:comment</a> &nbsp;<a href="../c/continue.html">c:continue</a></li>
   <li><a href="../c/delegate.html">c:delegate</a></li>
   <li><a href="../c/element.html">c:element</a> &nbsp;<a href="../c/evaluate-delegate.html">c:evaluate-delegate</a></li>
   <li><a href="../c/fallback.html">c:fallback</a> &nbsp;<a href="../c/finally.html">c:finally</a> &nbsp;<a href="../c/for-each.html">c:for-each</a> &nbsp;<a href="../c/for-each-group.html">c:for-each-group</a> &nbsp;<a href="../c/function.html">c:function</a></li>
   <li><a href="../c/if.html">c:if</a> &nbsp;<a href="../c/import.html">c:import</a></li>
   <li><a href="../c/member.html">c:member</a> &nbsp;<a href="../c/message.html">c:message</a> &nbsp;<a href="../c/metadata.html">c:metadata</a> &nbsp;<a href="../c/module.html">c:module</a></li>
   <li><a href="../c/namespace.html">c:namespace</a> &nbsp;<a href="../c/next-function.html">c:next-function</a> &nbsp;<a href="../c/next-template.html">c:next-template</a></li>
   <li><a href="../c/object.html">c:object</a> &nbsp;<a href="../c/otherwise.html">c:otherwise</a> &nbsp;<a href="../c/output.html">c:output</a> &nbsp;<a href="../c/override.html">c:override</a></li>
   <li><a href="../c/package.html">c:package</a> &nbsp;<a href="../c/param.html">c:param</a> &nbsp;<a href="../c/processing-instruction.html">c:processing-instruction</a></li>
   <li><a href="../c/result-document.html">c:result-document</a> &nbsp;<a href="../c/return.html">c:return</a></li>
   <li><a href="../c/script.html">c:script</a> &nbsp;<a href="../c/serialize.html">c:serialize</a> &nbsp;<a href="../c/set.html">c:set</a> &nbsp;<a href="../c/sort.html">c:sort</a></li>
   <li><a href="../c/template.html">c:template</a> &nbsp;<a href="../c/text.html">c:text</a> &nbsp;<a href="../c/try.html">c:try</a> &nbsp;<a href="../c/type.html">c:type</a></li>
   <li><a href="../c/use-functions.html">c:use-functions</a> &nbsp;<a href="../c/use-package.html">c:use-package</a> &nbsp;<a href="../c/using.html">c:using</a> &nbsp;<a href="../c/using-module.html">c:using-module</a></li>
   <li><a href="../c/validation.html">c:validation</a> &nbsp;<a href="../c/value-of.html">c:value-of</a> &nbsp;<a href="../c/variable.html">c:variable</a> &nbsp;<a href="../c/void.html">c:void</a></li>
   <li><a href="../c/when.html">c:when</a> &nbsp;<a href="../c/while.html">c:while</a> &nbsp;<a href="../c/with-param.html">c:with-param</a></li>
</ul>
<h2>Application Extension Elements</h2>
<ul>
   <li><a href="../a/anti-forgery-token.html">a:anti-forgery-token</a></li>
   <li><a href="../a/check-box.html">a:check-box</a></li>
   <li><a href="../a/display.html">a:display</a> &nbsp;<a href="../a/display-name.html">a:display-name</a> &nbsp;<a href="../a/display-text.html">a:display-text</a> &nbsp;<a href="../a/drop-down-list.html">a:drop-down-list</a></li>
   <li><a href="../a/editor.html">a:editor</a></li>
   <li><a href="../a/hidden.html">a:hidden</a> &nbsp;<a href="../a/http-method-override.html">a:http-method-override</a></li>
   <li><a href="../a/label.html">a:label</a> &nbsp;<a href="../a/list-box.html">a:list-box</a></li>
   <li><a href="../a/member-template.html">a:member-template</a> &nbsp;<a href="../a/model.html">a:model</a></li>
   <li><a href="../a/option.html">a:option</a></li>
   <li><a href="../a/password.html">a:password</a></li>
   <li><a href="../a/radio-button.html">a:radio-button</a></li>
   <li><a href="../a/text-area.html">a:text-area</a> &nbsp;<a href="../a/text-box.html">a:text-box</a></li>
   <li><a href="../a/validation-message.html">a:validation-message</a> &nbsp;<a href="../a/validation-summary.html">a:validation-summary</a></li>
   <li><a href="../a/with-options.html">a:with-options</a></li>
</ul>

<div class="note" markdown="1">

Don't forget to register extension elements prefixes before you use them, using `[c:]extension-element-prefixes`, e.g.:

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#'
   xmlns:c='http://maxtoroq.github.io/XCST'
   xmlns:a='http://maxtoroq.github.io/XCST/application'
   extension-element-prefixes='a'>
   ...
</c:module>
```

</div>

         