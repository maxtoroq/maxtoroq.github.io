## Global and Local Variables

A `c:variable` or [`c:param`](param.html) whose parent is [`c:module`](module.html), [`c:package`](package.html) or [`c:override`](override.html) is a **global variable**. A `c:variable` that is not global is a **local variable**.

Global variables are visible to all other components in the containing package.

## Values and Types of Variables

The value of a variable can be supplied by the `value` attribute or by its contents (child nodes). Global variables are always initialized as these are backed by C# fields, which always have a default value. Local variables can be left uninitialized by ommiting both the `value` attribute and contents. A value can then be assigned using the [`c:set`](set.html) instruction, or from C# code.

The type of a variable can be specified by the `as` attribute, or inferred if possible. For global variables, type inference does not work when the value is supplied by the `value` attribute. This is a limitation of the C# language, which does not allow the use of `var` on fields.

The table below summarizes.

value attribute | as attribute | content | effect
------- | ------- | -------- | -------
present | absent | empty | Value is obtained by evaluating the `value` attribute. For local variables, the type is inferred from the expression. For global variables, the type is `object`.
present | present | empty | Value is obtained by evaluating the `value` attribute, casted to the type required by the `as` attribute.
present | absent | present | Compilation error
present | present | present | Compilation error
absent | absent | empty | Local variables are not initialized. Global variables are initialized with `null`. The type is `object`.
absent | present | empty | Local variables are not initialized. Global variables are initialized with `default(T)`, where `T` is the type required by the `as` attribute.
absent | absent | present | Value is obtained by evaluating the sequence constructor. The type is inferred from the content (see next section).
absent | present | present | Value is obtained by evaluating the sequence constructor, casted to the type required by the `as` attribute.

## Type Inference from Content

When the `as` attribute is omitted, XCST tries to infer the type of the variable from the content. If not successful, the fallback type is `object[]`.

content | type
------- | ----
Text node | `string`
[`c:delegate`](delegate.html) | `System.Delegate` (see [`c:delegate`](delegate.html) for more info)
[`c:next-function`](next-function.html) | The type of the next function
[`c:object`](object.html) | Inferred by the expression
[`c:serialize`](serialize.html) | `string`
[`c:text`](text.html) | `string`
[`c:value-of`](value-of.html) | `string`

<div class="note eg" markdown="1">

###### Example: Temporary Trees
Temporary trees are currently not supported, but planned for the future. However, there's a workaround using [`c:result-document`](result-document.html)'s `output` attribute.

```xml
<c:variable name='doc' value='new XmlDocument()'/>

<c:using name='output' value='doc.CreateNavigator().AppendChild()'>
   <c:result-document output='output'>
      <foo bar='123'>baz</foo>
   </c:result-document>
</c:using>

<c:assert test='doc.DocumentElement.LocalName == "foo"'/>
<c:assert test='doc.DocumentElement.GetAttribute("bar") == "123"'/>
<c:assert test='doc.DocumentElement.InnerText == "baz"'/>
```

</div>

<div class="note" markdown="1">

###### Note: Differences with `xsl:variable`
`c:variable` does not support qualified names. `c:variable` is mutable and can be left uninitialized. No implicit zero-length `string` or document node. Text nodes are compiled to `string`, which make `string` a first-class citizen in XCST. Parentless text nodes don't exist in XCST.

</div>

## Error Conditions

It is a compilation error if the `visibility` attribute is used on a local variable.

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.
