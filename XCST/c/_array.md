
## Remarks

`c:array` exists for special purposes. You can build an array from a sequence constructor simply using [`c:variable`](variable.html). `c:array` allows you to:

- Add an array to the result of the containing sequence constructor, avoiding flattening.
- Build or serialize a JSON array.

You can use [`c:object`](object.html) to add members to an array, or any other non-void instruction.

## Building Arrays

`c:array` supports two kinds of arrays. By default, it creates an array of object ([Object]`[]`) that can hold any kind of values. Or you can create [JArray] arrays for JSON programming.

<div class="note eg" markdown="1">

###### Example: Building a JArray

```xml
<c:variable name='array' as='JArray'>
   <c:array>
      <c:map>
         <c:map-entry key='"name"'>John</c:map-entry>
      </c:map>
   </c:array>
</c:variable>

<c:assert test='((JValue)((JObject)array[0])["name"]).Value == "John"'/>
```

</div>

## JSON Serialization

If `c:array` is used when constructing complex or simple content then it serializes directly to JSON. It is typically used toghether with [`c:map`](map.html).

<div class="note eg" markdown="1">

###### Example: JSON output
Use the `text` output method to serialize JSON.

```xml
<c:output method='text'/>

<c:template name='c:initial-template'>
   <c:array>
      <c:map>
         <c:map-entry key='"name"'>John</c:map-entry>
      </c:map>
   </c:array>
</c:template>

<!-- Outputs: [{"name":"John"}] -->
```

</div>

<div class="note eg" markdown="1">

###### Example: Building JSON for an attribute

```xml
<div>
   <c:attribute name='data-options'>
      <c:array>
         <c:map>
            <c:map-entry key='"name"'>John</c:map-entry>
         </c:map>
      </c:array>
   </c:attribute>
</div>

<!-- Outputs: <div data-options="[{&quot;name&quot;:&quot;John&quot;}]"/> -->
```

</div>

<div class="note eg" markdown="1">

###### Example: Building a JSON string

```xml
<c:variable name='json'>
   <c:value-of>
      <c:array>
         <c:map>
            <c:map-entry key='"name"'>John</c:map-entry>
         </c:map>
      </c:array>
   </c:value-of>
</c:variable>

<c:assert test='json is string'/>
<c:assert test='json == "[{\"name\":\"John\"}]"'/>
```

</div>

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object] or [JArray].

## See Also

- [`c:map`](map.html)

[Object]: {{ page.bcl_url }}system.object
[JArray]: https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_Linq_JArray.htm
