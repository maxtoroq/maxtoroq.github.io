## Initialization of Parameters

For package parameters see [Initialization of Package Parameters](package.html#initialization-of-package-parameters).

Parameters that are not package parameters are initialized when the containing component or instruction is evaluated, as if the parameters were part of the following sequence constructor, even though formally they are not.

## Values and Types of Parameters

A parameter is basically a variable whose value can be supplied by the caller. See [Values and Types of Variables](variable.html#values-and-types-of-variables). However, parameters are always initialized, even when no value is supplied by the caller and no default value is specified, in which case the parameter is initialized with the default value of the parameter's type, e.g. `default(T)` in C#.

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

It is a compilation error if a required parameter specifies a default value.

It is a compilation error if a package or function parameter uses `tunnel='yes'`.

It is a run-time error if no value is supplied for a required package parameter, a required and tunnel [`c:template`](template.html) parameter, or a required [`c:delegate`](delegate.html) parameter.

## See Also

- [`c:variable`](variable.html)

