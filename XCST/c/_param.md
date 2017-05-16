## Package Parameters

A `c:param` whose parent is [`c:module`](module.html), [`c:package`](package.html) or [`c:override`](override.html) is a **package parameter**.

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

It is a compilation error if a required parameter specifies a default value.

It is a run-time error if no value is supplied for a required package parameter, a required and tunnel [`c:template`](template.html) parameter, or a required [`c:delegate`](delegate.html) parameter.

## See Also

- [`c:variable`](variable.html)
