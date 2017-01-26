## Error Conditions

It is a compilation error if the template specified in the `name` attribute does not exist in the current module, an importing module, an imported module and a used package.

It is a compilation error if the `c:call-template` element does not define a non-tunnel [`c:with-param`](with-param.html) for a required, non-tunnel, template parameter.

It is a compilation error if the `c:call-template` element defines a non-tunnel [`c:with-param`](with-param.html) for a parameter that does not exist in the target template.

It is a run-time error if no value is available, at the moment of invocation, for a required, tunnel parameter defined in the target template.

## Examples

```xml
<c:call-template name='layout'>
   <c:with-param name='product' value='product' tunnel='yes'/>
</c:call-template>
```

## See Also

- [`c:template`](template.html)
