
<div class="note" markdown="1">

###### Note: Differences with `xsl:map-entry`
While `xsl:map-entry` can be used to create a singleton map, `c:map-entry` cannot be used as a standalone instruction, it requires `c:map`.

</div>

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

It is a compilation or run-time error if the `c:map-entry` instruction is used in a context other than evaluating the contained sequence constructor of a [`c:map`](map.html) instruction.

## See Also

- [`c:map`](map.html)
