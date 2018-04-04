
## Remarks

`c:array` exists for special purposes. The preferred way of building an array from a sequence constructor is simply using [`c:variable`](variable.html). `c:array` allows you to:

- Nest arrays, avoiding flattening.
- Build or serialize a JSON array.

You can use [`c:object`](object.html) to add members to an array, or any other non-void instruction.

## Building Arrays

`c:array` supports two kinds of arrays. By default, it creates an array of object ([Object][System.Object]`[]`) that can hold any kind of values. Or you can create [JArray][Newtonsoft.Json.Linq.JArray] arrays for JSON programming.

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

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object][System.Object] or [JArray][Newtonsoft.Json.Linq.JArray].

## See Also

- [`c:map`](map.html)

[System.Object]: {{ page.bcl_url }}system.object
[Newtonsoft.Json.Linq.JArray]: https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_Linq_JArray.htm
