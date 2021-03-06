## Remarks

`c:assert` is compiled into a [`Debug.Assert`]({{ page.bcl_url }}e63efys0) call.

<div class="note eg" markdown="1">

###### Example
```xml
<c:template name='paint'>
   <c:param name='colors' as='string[]'/>

   <c:assert test='colors?.Length > 0'>At least one color expected.</c:assert>
   ...
</c:template>
```

</div>

<div class="note" markdown="1">

###### Note: Differences with `xsl:assert`
Unlike `xsl:assert`, `c:assert` does not guarantee that an exception will be thrown. An assertion can fail silently without interrupting the evaluation of the containing sequence constructor.

</div>

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

## See Also

- [`c:message`](message.html)
