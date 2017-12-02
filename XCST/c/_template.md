## Error Conditions

It is a compilation error if the `name` attribute uses a [reserved namespace](../docs/reserved-namespaces.html), except the name `c:initial-template`.

It is a compilation error if a `c:template` declaration has `visibility='abstract'` and the content of the element, excluding any `c:param` elements, is non-empty.

## See Also

- [`c:function`](function.html)
