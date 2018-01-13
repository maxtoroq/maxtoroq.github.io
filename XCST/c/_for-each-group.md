## Grouping By Key

If attributes `group-by` and `group-size` are both omitted, the items themselves are used as **grouping key**.

<div class="note eg" markdown="1">

###### Example: Default Grouping

```xml
<c:for-each-group name='group' in='"hello".ToCharArray()' expand-text='yes'>
   <char count='{group.Count()}'>{group.Key}</char>
</c:for-each-group>

<!-- Outputs:

<char count="1">h</char>
<char count="1">e</char>
<char count="2">l</char>
<char count="1">o</char>
-->
```

</div>

Use the `group-by` attribute to specify a lambda expression that computes the grouping key.

<div class="note eg" markdown="1">

###### Example: Specifying A Grouping Key

```xml
<c:for-each-group name='group' in='books' group-by='b => b.author' expand-text='yes'>
   <h2>{group.Key}</h2>
   <ul>
      <c:for-each name='book' in='group'>
         <li>...</li>
      </c:for-each>
   </ul>
</c:for-each-group>
```

</div>

When grouping by key, the **group variable** (declared by the `name` attribute) has the compile type [IGrouping]&lt;TKey, TSource>, where `TKey` is the type of the grouping key and `TSource` the type of the item.

## Processing Items In Chunks Of A Fixed Size

Use the `group-size` attribute to create groups with the same number of items, except for the last group which may have less.

<div class="note eg" markdown="1">

###### Example: Using `group-size`
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

</div>

When using the `group-size` attribute, the group variable has the compile type [IList]&lt;TSource>, where `TSource` is the type of the item.

## Error Conditions

It is a compilation error if both attributes `group-by` and `group-size` are present.

## See Also

- [`c:for-each`](for-each.html)

[IGrouping]: {{ page.bcl_url }}bb344977
[IList]: {{ page.bcl_url }}5y536ey6
