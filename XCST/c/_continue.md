<div class="note" markdown="1">

###### Note: Differences with `xsl:next-iteration`
Unlike `xsl:next-iteration`, `c:continue` is not required to appear in a tail position.

</div>

## Error Conditions

It is a compilation error if the `c:continue` element is not descendant of [`c:for-each`](for-each.html), [`c:for-each-group`](for-each-group.html) or [`c:while`](while.html).

## See Also

- [`c:break`](break.html)
- [`c:for-each`](for-each.html)
- [`c:while`](while.html)
