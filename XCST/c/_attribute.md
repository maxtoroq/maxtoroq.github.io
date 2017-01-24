## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

## Examples

```xml
<input type='checkbox'>
   <c:if test='isChecked'>
      <c:attribute name='checked'>checked</c:attribute>
   </c:if>
</input>
```

## See Also

- [`c:element`](element.html)
- [`c:namespace`](namespace.html)
