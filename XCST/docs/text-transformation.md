---
title: Text Transformation
---

The `[c:]transform-text` [standard attribute](standard-attributes.html) can be used to normalize text nodes in an XCST module. This can be useful when whitespace is used on text only for readability, or when text is included from an external file. This attribute affects descendant text nodes, and can be specified on any element to override an attribute specified in an ancestor element.

Normalization is performed at compile-time, unless the text node is a text value template, in which case normalization is performed at run-time **after** the value template is evaluated. 

Normalization affects text nodes children of elements whose content model is sequence constructor (including literal result elements), it does not affect other text nodes, e.g. text in a [`c:script`](../c/script.html) element.

## None

Normalization can be disabled using `[c:]transform-text='none'`, which is the default.

## Normalize Space

When `[c:]transform-text='normalize-space'` is used on an element, descendant text nodes are modified by removing leading and trailing whitespace, and sequences of internal whitespace are reduced to a single space character.

<div class="note eg" markdown="1">

###### Example: CSS Minification
The following example uses `normalize-space` normalization for minification purposes, which has the desired effect as long as the text does not contain significant whitespace.

```xml
<style c:transform-text='normalize-space'>
   <![CDATA[
   
   a {
      text-decoration: none;
   }
   ]]>
</style>

<!-- Outputs:
<style>a { text-decoration: none; }</style>
-->
```

</div>

## Trim

When `[c:]transform-text='trim'` is used on an element, descendant text nodes are modified by removing leading and trailing whitespace.

<div class="note eg" markdown="1">

###### Example: Removing Indentation Before and After an Included Text Node
The following example uses `trim` normalization on an included text node, to avoid outputting the leading and trailing whitespace of the code indentation.

```xml
<script c:transform-text='trim'>
   <xi:include href='js/global.min.js' parse='text'/>
</script>
```
</div>
