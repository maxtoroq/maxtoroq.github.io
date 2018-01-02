## Global and Local Variables

<span id="dt-global-variable"></span>A `c:variable` or [`c:param`](param.html) whose parent is [`c:module`](module.html), [`c:package`](package.html) or [`c:override`](override.html) is a **global variable**. <span id="dt-local-variable"></span>A `c:variable` that is not global is a **local variable**.

Global variables are visible to all other components in the containing package.

## Values and Types of Variables

The value of a variable can be supplied by the `value` attribute or by its contents (child nodes). Global variables are always initialized as these are backed by C# fields, which always have a default value. Local variables can be left uninitialized by ommiting both the `value` attribute and contents. A value can then be assigned using the [`c:set`](set.html) instruction, or from C# code.

The type of a variable can be specified by the `as` attribute, or inferred if possible. For global variables, type inference does not work when the value is supplied by the `value` attribute. This is a limitation of the C# language, which does not allow the use of `var` on fields.

The table below summarizes.

value attribute | as attribute | content | effect
------- | ------- | -------- | -------
present | absent | empty | Value is obtained by evaluating the `value` attribute. For local variables, the type is inferred from the expression. For global variables, the type is [Object].
present | present | empty | Value is obtained by evaluating the `value` attribute, casted to the type required by the `as` attribute.
present | absent | present | Compilation error
present | present | present | Compilation error
absent | absent | empty | Local variables are not initialized. Global variables are initialized with `null`. The type is [Object].
absent | present | empty | Local variables are not initialized. Global variables are initialized with `default(T)`, where `T` is the type required by the `as` attribute.
absent | absent | present | Value is obtained by evaluating the sequence constructor. The type is inferred from the content (see next section).
absent | present | present | Value is obtained by evaluating the sequence constructor, casted to the type required by the `as` attribute.

## Type Inference from Content

When the `as` attribute is omitted, XCST tries to infer the type of the variable from the content. If not successful, the fallback type is [Object]`[]`.

content | type
------- | ----
Text node | [String]
[`c:array`](array.html) | [Object]
[`c:delegate`](delegate.html) | Xcst.XcstDelegate&lt;TItem> (see [Type of a Delegate](delegate.html#type-of-a-delegate) for more info)
[`c:document`](document.html) | [XDocument]
[`c:map`](map.html) | [Object]
[`c:object`](object.html) | Inferred by the expression
[`c:serialize`](serialize.html) | [String]
[`c:text`](text.html) | [String]
[`c:value-of`](value-of.html) | [String]

<div class="note" markdown="1">

###### Note: Differences with `xsl:variable`
`c:variable` does not support qualified names. `c:variable` is mutable and can be left uninitialized. No implicit zero-length `string` or document node. Text nodes are compiled to `string`, which make `string` a first-class citizen in XCST. Parentless text nodes don't exist in XCST.

</div>

## Error Conditions

It is a compilation error if the `visibility` attribute is used on a local variable.

It is a compilation error if a global variable with `visibility='abstract'` has a default value.

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

[Object]: {{ page.bcl_url }}system.object
[String]: {{ page.bcl_url }}system.string
[XDocument]: {{ page.bcl_url }}system.xml.linq.xdocument
