## Scope of Parameters

<span id="dt-package-parameter"></span>A `c:param` whose parent is [`c:module`](module.html), [`c:package`](package.html) or [`c:override`](override.html) is a **package parameter**. A package parameter is also a [global variable](variable.html#dt-global-variable). A parameter that is not a package parameter is also a [local variable](variable.html#dt-local-variable).

Package parameters are visible to all other components in the containing package. Package parameters have an implicit `public` visibility, which also makes them visible to components in using packages.

## Initialization of Parameters

Package parameters that are not required follow the same rules as global variables. See [Initialization of Variables](variable.html#initialization-of-variables).

Package parameters that use `required='yes'` are initialized before the invocation of the initial component (usually the `c:initial-template` template).

Parameters that are not package parameters are initialized when the containing component or instruction is evaluated, as if the parameters where part of the following sequence constructor, even though formally they are not.

## Values and Types of Parameters

A parameter is basically a variable whose value can be supplied by the caller. See [Values and Types of Variables](variable.html#values-and-types-of-variables). However, parameters are always initialized, even when no value is supplied by the caller and no default value is specified, in which case the parameter is initialized with the default value of the parameter's type, e.g. `default(T)` in C#.

## Function Parameters

[`c:function`](function.html) parameters have several limitations, due to the fact that they compile to method parameters in C#. Type inference does not work when the value is supplied by the `value` attribute (defaults to [Object][System.Object]). Default values are limited to [constant expressions]({{ page.csharp_spec_url}}expressions.md#constant-expressions). The order of parameters is significant. Cannot have a parameter without a default value after one with a default value.

Function parameters must omit the `tunnel` attribute, or have its value set to `false`.

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

It is a compilation error if a required parameter specifies a default value.

It is a compilation error if a package parameter uses `tunnel='yes'`.

It is a run-time error if no value is supplied for a required package parameter, a required and tunnel [`c:template`](template.html) parameter, or a required [`c:delegate`](delegate.html) parameter.

## See Also

- [`c:variable`](variable.html)

[System.Object]: {{ page.bcl_url }}system.object
