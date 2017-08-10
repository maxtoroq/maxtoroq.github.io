<div class="note eg" markdown="1">

###### Example
```xml
<ol class='carousel-indicators'>
   <c:for-each name='i' in='Enumerable.Range(0, slides.Length)'>
      <li data-target='#carousel' data-slide-to='{i}'>
         <c:if test='i == 0'>
            <c:attribute name='class'>active</c:attribute>
         </c:if>
      </li>
   </c:for-each>
</ol>
```

</div>

## See Also

- [`c:for-each-group`](for-each-group.html)
- [`c:while`](while.html)
