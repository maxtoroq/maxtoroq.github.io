
## Error Conditions

 It is a compilation error if the `value` attribute of the `c:assert` element is present when the content of the element is non-empty.

## Notes

`c:assert` is compiled into a [`Debug.Assert`](https://msdn.microsoft.com/en-us/library/e63efys0) call.

## Examples

```xml
<c:template name='paint'>
   <c:param name='colors' as='string[]'/>

   <c:assert test='colors?.Length > 0'>At least one color expected.</c:assert>
   ...
</c:template>
```