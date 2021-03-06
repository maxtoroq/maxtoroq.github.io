## Error Conditions

It is a compilation error if the `c:next-template` element is not descendant of [`c:template`](template.html).

It is a compilation error if there's no other template in the containing package with the same name as the containing template and with lower import precedence.

It is a compilation error if the `c:next-template` element does not define a non-tunnel [`c:with-param`](with-param.html) for a required, non-tunnel, template parameter.

It is a compilation error is the value specified in [`c:with-param`](with-param.html) for a non-tunnel parameter is not implicitly castable to the parameter's type.

It is a compilation error if the `c:next-template` element defines a non-tunnel [`c:with-param`](with-param.html) for a parameter that does not exist in the target template.

## See Also

- [`c:call-template`](call-template.html)
- [`c:template`](template.html)
