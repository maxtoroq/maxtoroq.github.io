
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
<a:editor for='amount' attributes='amountAttribs'/>
```

</div>

<div class="note eg" markdown="1">

###### Example: Building a JObject

```xml
<c:variable name='map' as='JObject'>
   <c:map>
      <c:map-entry key='"name"'>John</c:map-entry>
   </c:map>
</c:variable>

<c:assert test='((JValue)map["name"]).Value == "John"'/>
```

</div>

## JSON Serialization

If `c:map` is used when constructing complex or simple content then it serializes directly to JSON.

<div class="note eg" markdown="1">

###### Example: JSON output
Use the `text` output method to serialize JSON.

```xml
<c:output method='text'/>

<c:template name='c:initial-template'>
   <c:map>
      <c:map-entry key='"name"'>John</c:map-entry>
   </c:map>
</c:template>

<!-- Outputs: {"name":"John"} -->
```

</div>

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

<div class="note eg" markdown="1">

###### Example: Building a JSON string

```xml
<c:variable name='json'>
   <c:value-of>
      <c:map>
         <c:map-entry key='"name"'>John</c:map-entry>
      </c:map>
   </c:value-of>
</c:variable>

<c:assert test='json is string'/>
<c:assert test='json == "{\"name\":\"John\"}"'/>
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
