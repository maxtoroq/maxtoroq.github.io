
## Building Expando Objects

`c:map` supports two kinds of expando objects. By default, it creates an object whose properties can hold any kind of value. Or you can create [JObject][Newtonsoft.Json.Linq.JObject] objects for JSON programming.

## JSON Serialization

If `c:map` is used when constructing complex or simple content then it serializes directly to JSON.

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object][System.Object] or [JObject][Newtonsoft.Json.Linq.JObject].

It is a run-time error if the result of evaluating the sequence constructor includes values other than those returned by [`c:map-entry`](map-entry.html).

## See Also

- [`c:map-entry`](map-entry.html)
- [`c:array`](array.html)

[System.Object]: {{ page.bcl_url }}system.object
[Newtonsoft.Json.Linq.JObject]: https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_Linq_JObject.htm
