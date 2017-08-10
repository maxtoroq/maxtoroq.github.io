
<div class="note eg" markdown="1">

###### Example
```xml
<input type='checkbox'>
   <c:if test='isChecked'>
      <c:attribute name='checked'>checked</c:attribute>
   </c:if>
</input>
```

</div>

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

## See Also

- [`c:element`](element.html)
- [`c:namespace`](namespace.html)
