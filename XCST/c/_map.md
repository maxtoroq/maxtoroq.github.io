
## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object]({{ page.bcl_url }}system.object) or [JObject](https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_Linq_JObject.htm).

It is a run-time error if the result of evaluating the sequence constructor includes values other than those returned by [`c:map-entry`](map-entry.html).

## See Also

- [`c:map-entry`](map-entry.html)
- [`c:array`](array.html)
