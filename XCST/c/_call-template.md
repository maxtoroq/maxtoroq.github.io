## Tunnel Parameters

<span id="dt-tunnel-parameter"></span>A **tunnel parameter** is a parameter that is automatically and recursively passed on to further [`c:template`](template.html) and [`c:delegate`](delegate.html) calls, without requiring each template to be aware of it. It is passed *in the background* so to speak.

A tunnel parameter is created by a [`c:with-param`](with-param.html) element with `tunnel='yes'`, or by using the `tunnel-params` attribute on [`c:apply-template`](apply-template.html), `c:call-template`, [`c:invoke-delegate`](invoke-delegate.html), [`c:next-match`](next-match.html) and [`c:next-template`](next-template.html). If the same parameter is specified using both [`c:with-param`](with-param.html) and the `tunnel-params` attribute, the `tunnel-params` parameter takes precedence.

<div class="note eg" markdown="1">

###### Example: Using Tunnel Parameters
On the following example, the `c:initial-template` template calls the `layout` template, which in turn calls the `content` template that recieves the `product`  tunnel parameter sent by `c:initial-template`, which `layout` is unaware of. 

```xml
<c:template name='c:initial-template'>
   <c:variable name='product' value='FindProduct()'/>
   <c:call-template name='layout'>
      <c:with-param name='product' value='product' tunnel='yes'/>
   </c:call-template>
</c:template>

<c:template name='layout'>
   <html>
      <body>
         <c:call-template name='content'/>
      </body>
   </html>
</c:template>

<c:template name='content' expand-text='yes'>
   <c:param name='product' as='Product' tunnel='yes'/>
   
   Product Name: {product.Name}
</c:template>
```

</div>

## Error Conditions

It is a compilation error if the `name` attribute does not match the name of any template visible in the containing package.

It is a compilation error if the `c:call-template` element does not define a non-tunnel [`c:with-param`](with-param.html) for a required, non-tunnel, template parameter.

It is a compilation error is the value specified in [`c:with-param`](with-param.html) for a non-tunnel parameter is not implicitly castable to the parameter's type.

It is a compilation error if the `c:call-template` element defines a non-tunnel [`c:with-param`](with-param.html) for a parameter that does not exist in the target template.

## See Also

- [`c:template`](template.html)
