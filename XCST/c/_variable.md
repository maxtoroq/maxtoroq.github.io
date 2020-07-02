## Scope of Variables

<span id="dt-global-variable"></span>A `c:variable` or [`c:param`](param.html) whose parent is [`c:module`](module.html), [`c:package`](package.html) or [`c:override`](override.html) is a **global variable**. <span id="dt-local-variable"></span>A variable that is not global is a **local variable**.

Global variables are visible to all other components in the containing package.

## Initialization of Variables

The value of a variable can be supplied by the `value` attribute or by its contents (child nodes).

Global variables are initialized lazily when the variable is referenced and evaluated for the first time. If not referenced, or if reassigned before evaluating for the first time, then its initialization expression or instructions are never executed. The order of global variables is not significant.

Local variables are initialized when the execution of the program reaches the variable declaration.

Both global and local variables can be left uninitialized by ommiting both the `value` attribute and contents. A value can then be assigned using the [`c:set`](set.html) instruction, or from C# code.

## Values and Types of Variables

The type of a variable can be specified by the `as` attribute, or inferred if possible. For global variables, type inference does not work when the value is supplied by the `value` attribute.

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
absent | present | present | Value is obtained by evaluating the sequence constructor, using the required sequence type specified by the `as` attribute.

## Type Inference from Content

When the `as` attribute is omitted, XCST tries to infer the type of the variable from the content. If not successful, the fallback type is [Object]`[]`.

content | type
------- | ----
Text node | [String]
Literal result element | [XElement]
[`c:array`](array.html) | [Object]
[`c:delegate`](delegate.html) | Xcst.XcstDelegate&lt;TItem> (see [Type of a Delegate](delegate.html#type-of-a-delegate) for more info)
[`c:document`](document.html) | [XDocument]
[`c:element`](element.html) | [XElement]
[`c:map`](map.html) | [Object]
[`c:object`](object.html) | Inferred by the expression
[`c:serialize`](serialize.html) | [String]
[`c:text`](text.html) | [String]
[`c:value-of`](value-of.html) | [String]

When using multiple elements of the same type, the inferred type is an array of that type.

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
[XElement]: {{ page.bcl_url }}system.xml.linq.xelement
