## Default Grouping

If attributes `group-by` and `group-size` are both omitted, the items themselves are used as grouping key. E.g.:

```xml
<c:for-each-group name='group' in='"hello".ToCharArray()' expand-text='yes'>
   <char count='{group.Count()}'>{group.Key}</char>
</c:for-each-group>
```

...produces:

```xml
<char count="1">h</char>
<char count="1">e</char>
<char count="2">l</char>
<char count="1">o</char>
```

## The `group-by` Attribute

Use the `group-by` attribute to specify a member of the item to use as grouping key.

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

It is a compilation error if both attributes `group-by` and `group-size` are present.

## See Also

- [`c:for-each`](for-each.html)
