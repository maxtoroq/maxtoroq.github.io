## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

## Notes

`c:assert` is compiled into a [`Debug.Assert`](https://msdn.microsoft.com/en-us/library/e63efys0) call.

## Differences with `xsl:assert`

Unlike `xsl:assert`, `c:assert` does not guarantee that an exception will be thrown. An assertion can fail silently without interrupting the evaluation of the containing sequence constructor.

## Examples

```xml
<c:template name='paint'>
   <c:param name='colors' as='string[]'/>

   <c:assert test='colors?.Length > 0'>At least one color expected.</c:assert>
   ...
</c:template>
```

## See Also

- [`c:message`](message.html)
