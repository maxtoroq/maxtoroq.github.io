---
title: XCST Elements Reference
---

### Namespace Bindings

- c = **http://maxtoroq.github.io/XCST**
- a = **http://maxtoroq.github.io/XCST/application**

## XCST Elements

{% include_relative ../c/_list.md %}

Schema: [Relax NG](https://github.com/maxtoroq/XCST/blob/master/schemas/xcst.rng) - [XSD](https://github.com/maxtoroq/XCST/blob/master/schemas/xcst.xsd)

## Application Extension Elements



Schema: [Relax NG](https://github.com/maxtoroq/XCST-a/blob/master/schemas/xcst-app.rng) - [XSD](https://github.com/maxtoroq/XCST-a/blob/master/schemas/xcst-app.xsd)


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
         