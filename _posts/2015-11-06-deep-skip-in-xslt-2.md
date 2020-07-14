---
title: Deep-skip in XSLT 2.0
date: 2015-11-06 17:22:00 -0300
tags: [xslt]
---

XSLT 3.0 introduces [mode declarations][1], which allows you to change the behavior of built-in templates rules. On this post I explain how you can achieve a deep-skip behavior in XSLT 2.0.

Use case: Extension elements
----------------------------
Suppose you have a language *s* (standard) that allows the inclusion of *x* (extension) elements:

```xml
<s:foo>
   <x:bar/>
</s:foo>
```

Detecting the use of an unknown standard element is easy, you simply declare a *catch-all* template and throw an error:

```xml
<xsl:template match="s:*" mode="s:instruction">
   <xsl:sequence select="error((), concat('Unknown element: ', local-name()))"/>
</xsl:template>
```

Detecting the use of an unknown extension element is a whole different story. If the language is truly extensible, then you cannot know all the elements available in the extension. Even though the extension developer could declare its own catch-all template and throw an error, you cannot rely on all extensions do the same. Since extensions are out of your control, the robust thing to do is handle unknown elements and throw the error yourself. But how can you detect if an extension element doesn't have a template rule? You can rely on the built-in template rule for elements, like this:

```xml
<xsl:template match="*" mode="s:extension">
   <xsl:param name="s:extension-recurse" select="false()"/>

   <xsl:if test="not($s:extension-recurse)">
      <xsl:apply-imports>
         <xsl:with-param name="s:extension-recurse" select="true()"/>
      </xsl:apply-imports>
   </xsl:if>
</xsl:template>
```

<div class="note" markdown="1">

This solution works when extension templates have lower <a href="http://www.w3.org/TR/xslt-30/#dt-import-precedence">import precedence</a>. Also, you can use <code>xsl:next-match</code> instead of <code>xsl:apply-imports</code>, although the effect should be the same.

</div>

The above is a catch-all template for extensions. The idea is that it matches before the extension's template (if there is one). When `$s:extension-recurse` is `false()`, we call `xsl:apply-imports` with `s:extension-recurse` set to `true()`. If the extension's template exists, everything is fine. If the extension's template does not exist, the built-in template rule for elements kicks in. The built-in template rule will call `xsl:apply-templates` to process the extension's child nodes in the same mode, **passing along any parameters it recieved**. This would translate into something like this:

```xml
<!-- Built-in template rule for elements in the s:extension mode -->
<xsl:template match="*" mode="s:extension">
   <xsl:param name="s:extension-recurse"/>

   <xsl:apply-templates mode="#current">
      <xsl:with-param name="s:extension-recurse" select="$s:extension-recurse"/>
   </xsl:apply-templates>
</xsl:template>
```

If the extension (which at this point we know to be unknown) has child elements, then our catch-all template is called, this time with `$s:extension-recurse` set to `true()`, which is a signal to ignore the element and thus achieving the deep-skip behavior. If processing an extension element results in an empty sequence, then we know it's an unknown element and can thrown an error. Without deep-skip, any child elements of the unknown extension element would be processed, which is clearly not the desired behavior.

Just in case extensions have text nodes, it's a good idea to ignore those too:

```xml
<xsl:template match="text()" mode="s:extension"/>
```

I hope this use case wasn't too complicated to illustrate deep-skip in XSLT 2.0, but it was an interesting one to me, and a clear example why it's a great new feature in XSLT 3.0.

[1]: http://www.w3.org/TR/xslt-30/#element-mode
