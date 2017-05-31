## The `group-size` Attribute

Use the `group-size` attribute to create groups with the same number of items, except for the last group which may have less. E.g.:

```xml
<c:for-each-group name='row' in='addressBook' group-size='3'>
   <div class='row'>
      <c:for-each name='address' in='row'>
         <div class='col-sm-4'>
            <address>
               ...
            </address>
         </div>
      </c:for-each>
   </div>
</c:for-each-group>
```

## Error Conditions

It is a compilation error if none of the attributes `group-by` and `group-size` are present, or if both are present.

## See Also

- [`c:for-each`](for-each.html)
