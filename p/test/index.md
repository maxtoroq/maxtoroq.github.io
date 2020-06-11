---
title: "
dfd
"
---
{{ page.url }}

{% comment %}
    This is a block comment in Liquid
{% endcomment %}
<div>
**dsfds**
</div>

```csharp
{% raw %}
    @Html.Editor("Another.Boolean",
        new { htmlAttributes = new Dictionary<string, object> {{ "foo", "bar" }, }})
{% endraw %}
```

```csharp
namespace Foo {
   {% raw %}<mark>{% endraw %}class Bar { {% raw %}</mark>{% endraw %}
   }
}
```

{% assign arr1 = "a,b" | split: ',' %}
{% assign arr2 = "a,b" | split: ',' %}
{% assign arr3 = "b,a" | split: ',' %}
{% if arr1 == arr2 %}arr1 == arr2{% endif %}
{% if arr2 == arr1 %}arr2 == arr1{% endif %}
{% if arr2 == arr3 %}arr2 == arr3{% endif %}

{{ page.url | slice: -1 }}
{% assign yes = 1 == 1 %}
{{ yes }}
{% if yes %}yes{% endif %}


<div markdown="1">

**dsfds**

</div>

{% include_relative _incl.md %}
