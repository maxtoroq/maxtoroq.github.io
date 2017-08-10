<div class="note eg" markdown="1">

###### Example
```xml
<c:call-template name='layout'>
   <c:with-param name='product' value='product' tunnel='yes'/>
</c:call-template>
```

</div>

## Error Conditions

It is a compilation error if the `name` attribute does not match the name of any template visible in the containing package.

It is a compilation error if the `c:call-template` element does not define a non-tunnel [`c:with-param`](with-param.html) for a required, non-tunnel, template parameter.

It is a compilation error is the value specified in [`c:with-param`](with-param.html) for a non-tunnel parameter is not implicitly castable to the parameter's type.

It is a compilation error if the `c:call-template` element defines a non-tunnel [`c:with-param`](with-param.html) for a parameter that does not exist in the target template.

## See Also

- [`c:template`](template.html)
