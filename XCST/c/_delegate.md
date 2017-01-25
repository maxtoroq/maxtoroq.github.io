## Examples

```xml
<c:variable name='pagerItem'>
   <c:delegate>
      <c:param name='page' as='int' required='yes'/>
      <c:param name='text' as='string'/>
      <c:param name='@class' as='string'/>
      
      <li>
         ...
      </li>
   </c:delegate>
</c:variable>

<ul class='pagination'>
   <c:evaluate-delegate value='pagerItem' with-params='new { page = currentPage - 1, text = "← Previous", @class = "page-prev" }'/>
   <c:evaluate-delegate value='pagerItem' with-params='new { page = 1 }'/>
   ...
</ul>
```

## See Also

- [`c:evaluate-delegate`](evaluate-delegate.html)
