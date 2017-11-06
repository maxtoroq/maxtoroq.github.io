
## Building Expando Objects

`c:map` supports two kinds of expando objects. By default, it creates an object whose properties can hold any kind of value. Or you can create [JObject][Newtonsoft.Json.Linq.JObject] objects for JSON programming.

<div class="note eg" markdown="1">

###### Example: Building an object to hold HTML attributes 

```xml
<c:variable name='amountAttribs'>
  <c:map>
    <c:map-entry key='"class"'>refresh</c:map-entry>
    <c:if test='readOnly'>
      <c:map-entry key='"readonly"'>readonly</c:map-entry>
    </c:if>
  </c:map>
</c:variable>
<a:editor for='amount' html-attributes='amountAttribs'/>
```

</div>

## JSON Serialization

If `c:map` is used when constructing complex or simple content then it serializes directly to JSON.

<div class="note eg" markdown="1">

###### Example: Building JSON for an attribute

```xml
<div>
   <c:attribute name='data-options'>
      <c:map>
         <c:map-entry key='"name"'>John</c:map-entry>
      </c:map>
   </c:attribute>
</div>
<!-- Outputs: <div data-options="{&quot;name&quot;:&quot;John&quot;}"/> -->
```

</div>

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object][System.Object] or [JObject][Newtonsoft.Json.Linq.JObject].

It is a run-time error if the result of evaluating the sequence constructor includes values other than those returned by [`c:map-entry`](map-entry.html).

## See Also

- [`c:map-entry`](map-entry.html)
- [`c:array`](array.html)

[System.Object]: {{ page.bcl_url }}system.object
[Newtonsoft.Json.Linq.JObject]: https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_Linq_JObject.htm
