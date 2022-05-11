---
title: Extension Instructions
---
An **extension instruction** is an element, within a sequence constructor, in a namespace designated as an extension namespace. To designate a namespace as an extension namespace use the `[c:]extension-element-prefixes` [standard attribute](standard-attributes.html), e.g.:

<figure class="code" data-highlight-lines="5" markdown="1">

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#'
   xmlns:c='http://maxtoroq.github.io/XCST'
   xmlns:a='http://maxtoroq.github.io/XCST/application'
   extension-element-prefixes='a'>
   ...
</c:module>
```

</figure>

If you forget to designate a namespace as an extension namespace then the elements will be treated as literal result elements.

It is a compilation error to designate a [reserved namespace](../c/#reserved-namespaces) as an extension namespace, except for extensions made available by this project.

## Fallback

If you are not sure a particular extension instruction will be available you can use the [`c:fallback`](../c/fallback.html) instruction as child of the extension instruction, e.g.:

```xml
<c:template name='c:initial-template' extension-element-prefixes='eg' xmlns:eg='http://example.com/ns/foo'>
   <eg:foo>
      <c:fallback>
         <c:message>eg:foo not available.</c:message>
         <c:call-template name='fallback-foo'/>
      </c:fallback>
   </eg:foo>
</c:template>
```
