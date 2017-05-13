## Type of a Delegate

The concrete type of a delegate is currently not part of the public API. However, you don't need to specify it thanks to type inference, e.g.:

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

To accept a delegate as a parameter you can use the [Delegate](https://msdn.microsoft.com/en-us/library/system.delegate) abstract type, e.g.:

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

## See Also

- [`c:evaluate-delegate`](evaluate-delegate.html)
