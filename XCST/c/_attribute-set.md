## Examples

The following attribute set:

```xml
<c:attribute-set name='delete-btn'>
   <c:attribute name='type'>submit</c:attribute>
   <c:attribute name='name'>X-HTTP-Method-Override</c:attribute>
   <c:attribute name='value'>DELETE</c:attribute>
   <c:attribute name='onclick'>return confirm("Are you sure?")</c:attribute>
   <c:attribute name='formnovalidate'>formnovalidate</c:attribute>
</c:attribute-set>
```

...can be used on a literal result element:

```xml
<button c:use-attribute-sets='delete-btn' class='btn btn-outline-danger cancel'>Delete</button>
```

...or on [`c:element`](element.html):

```xml
<c:element name='button' use-attribute-sets='delete-btn'>
   ...
</c:element>
```

## See Also

- [`c:attribute`](attribute.html)
