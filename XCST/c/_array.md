
## Building Arrays

`c:array` supports two kinds of arrays. By default, it creates an array of object ([Object][System.Object]´[]´) that can hold any kind of values. Or you can create [JArray][Newtonsoft.Json.Linq.JArray] arrays for JSON programming.

## JSON Serialization

If `c:array` is used when constructing complex or simple content then it serializes directly to JSON.

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object][System.Object] or [JArray][Newtonsoft.Json.Linq.JArray].

## See Also

- [`c:map`](map.html)

[System.Object]: {{ page.bcl_url }}system.object
[Newtonsoft.Json.Linq.JArray]: https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_Linq_JArray.htm
