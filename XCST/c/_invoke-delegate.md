
<div class="note eg" markdown="1">

###### Example: Creating and Using a Delegate
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
   <c:invoke-delegate delegate='pagerItem' with-params='new { page = currentPage - 1, text = "← Previous", @class = "page-prev" }'/>
   <c:invoke-delegate delegate='pagerItem' with-params='new { page = 1 }'/>
   ...
</ul>
```

</div>

<div class="note eg" markdown="1">

###### Example: Delegate Parameter

```xml
<c:import-namespace ns='Xcst'/>

<c:template name='pagination'>
   <c:param name='currentPage' as='int'/>
   <c:param name='pagerItem' as='XcstDelegate&lt;object>'/>
   
   <ul class='pagination'>
      <c:invoke-delegate delegate='pagerItem' with-params='new { page = currentPage - 1, text = "← Previous", @class = "page-prev" }'/>
      <c:invoke-delegate delegate='pagerItem' with-params='new { page = 1 }'/>
      ...
   </ul>
</c:template>
```

</div>

## See Also

- [`c:delegate`](delegate.html)
