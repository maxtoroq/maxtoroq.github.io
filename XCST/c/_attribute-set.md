
<div class="note eg" markdown="1">

###### Example: Using an Attribute Set
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
<button c:use-attribute-sets='delete-btn'>Delete</button>
```

...or on [`c:element`](element.html):

```xml
<c:element name='button' use-attribute-sets='delete-btn'>Delete</c:element>
```

</div>

<div class="note" markdown="1">

###### Note: Differences with `xsl:attribute-set`
Unlike `xsl:attribute-set`, `c:attribute-set` does not allow multiple declarations with the same name in the same module. Also, `c:attribute-set` declarations with higher import precedence hide declarations with lower import precedence, which means hidden declarations are never evaluated.

</div>

## Error Conditions

It is a compilation error if the `name` attribute uses a [reserved namespace](../docs/reserved-namespaces.html).

It is a compilation error if an `c:attribute-set` declaration has `visibility='abstract'` and the content of the element is non-empty.

It is a compilation error if another `c:attribute-set` declaration with the same name exists in the containing module.

It is a compilation error if the `use-attribute-sets` attribute specifies a name that does not match the name of any `c:attribute-set` declaration in the containing package.

## See Also

- [`c:attribute`](attribute.html)
