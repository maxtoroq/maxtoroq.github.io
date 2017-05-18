---
title: Extension Instructions
---
In XCST there are basically three categories of elements: [XCST elements](elements-ref.html#xcst-elements), which represent program structure and instructions; *Literal result elements*, which represent the data that is the output of an XCST program; and *extension instructions*, which represent additional instructions made available by an XCST processor or by a third party.

An **extension instruction** is an element, within a sequence constructor, in a namespace designated as an extension namespace. To designate a namespace as an extension namespace use the `[c:]extension-element-prefixes` [standard attribute](standard-attributes.html), e.g.:

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#'
   xmlns:c='http://maxtoroq.github.io/XCST'
   xmlns:a='http://maxtoroq.github.io/XCST/application'
   extension-element-prefixes='a'>
   ...
</c:module>
```

If you forget to designate a namespace as an extension namespace then the elements will be treated as literal result elements.
