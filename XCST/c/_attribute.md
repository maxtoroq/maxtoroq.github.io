## Error Conditions

 It is a compilation error if the `value` attribute of the `c:attribute` element is present when the content of the element is non-empty.

 ## Examples

 ```xml
<input>
   <c:if test='disable'>
      <c:attribute name='disabled'>disabled</c:attribute>
   </c:if>
</input>
 ```

 ## See Also

 - [`c:element`](element.html)
 - [`c:namespace`](namespace.html)
