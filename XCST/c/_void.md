## The `value` Attribute

The `c:void` instruction can be used to call methods that don't return values (`void` methods in C#), or when you don't want to output the return value. E.g.:

```xml
<c:void value='Redirect("/")'/>
```

The expression must be a valid C# statement.

## Content

When the `c:void` instruction has content, the content is evaluated but the output is discarded. This can be useful if you run a program only for its side-effects. E.g.:

```xml
<c:template name='c:initial-template'>
   <c:void>
      <c:call-template name='do-stuff'/>
   </c:void>
</c:template>
```

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

## See Also

- [`c:script`](script.html)
