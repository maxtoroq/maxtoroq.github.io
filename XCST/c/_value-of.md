<div class="note" markdown="1">

###### Note: Differences with `xsl:value-of`
The default separator for sequence constructors of `c:value-of` is a single space (consistent with all other simple content instructions), while `xsl:value-of` uses an empty string.

</div>

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

## See Also

- [`c:text`](text.html)
