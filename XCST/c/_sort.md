
## Remarks

When used within [`c:for-each`](for-each.html), `c:sort` defines the order used to process items. When used within [`c:for-each-group`](for-each-group.html), `c:sort` defines the order used to process groups, and does not affect the order of items within each group.

Both [`c:for-each`](for-each.html) and [`c:for-each-group`](for-each-group.html) require a `name` attribute used to specify the name of a variable that represents the item (or group) currently being processed, to be used in the contained sequence constructor. The same name is used for a contextual variable available in the expression of the `value` attribute of the `c:sort` element.

<div class="note eg" markdown="1">

###### Example: Using `c:sort` in `c:for-each`
```xml
<c:for-each name='address' in='addressBook'>
  <c:sort value='address.last_used' order='descending'/>

  <address>
     ...
  </address>
</c:for-each>
```

</div>
