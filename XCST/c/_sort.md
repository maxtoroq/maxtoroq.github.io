
## Remarks

When used within [`c:for-each`](for-each.html), `c:sort` defines the order used to process items. When used within [`c:for-each-group`](for-each-group.html), `c:sort` defines the order used to process groups, and does not affect the order of items within each group.

<div class="note eg" markdown="1">

###### Example: Using `c:sort` in `c:for-each`
```xml
<c:for-each name='address' in='addressBook'>
  <c:sort by='a => a.last_used' order='descending'/>

  <address>
     ...
  </address>
</c:for-each>
```

</div>
