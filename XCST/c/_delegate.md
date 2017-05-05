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
   <c:evaluate-delegate delegate='pagerItem' with-params='new { page = currentPage - 1, text = "← Previous", @class = "page-prev" }'/>
   <c:evaluate-delegate delegate='pagerItem' with-params='new { page = 1 }'/>
   ...
</ul>
```

You can also accept a delegate as parameter:

```xml
<c:template name='pagination'>
   <c:param name='currentPage' as='int'/>
   <c:param name='pagerItem' as='dynamic'/>
   
   <ul class='pagination'>
      <c:evaluate-delegate delegate='pagerItem' with-params='new { page = currentPage - 1, text = "← Previous", @class = "page-prev" }'/>
      <c:evaluate-delegate delegate='pagerItem' with-params='new { page = 1 }'/>
      ...
   </ul>
</c:template>
```

The above example uses the `dynamic` keyword to avoid specifying the exact type of the delegate, which is currently not part of the public API and it's not recommended to use, as it might change in the future.

## See Also

- [`c:evaluate-delegate`](evaluate-delegate.html)
