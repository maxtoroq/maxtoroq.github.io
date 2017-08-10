<div class="note" markdown="1">

###### Note: Differences with `xsl:break`
Unlike `xsl:break`, `c:break` is not required to appear in a tail position.

</div>

## Error Conditions

It is a compilation error if the `c:break` element is not descendant of [`c:for-each`](for-each.html), [`c:for-each-group`](for-each-group.html) or [`c:while`](while.html).

## See Also

- [`c:continue`](continue.html)
- [`c:for-each`](for-each.html)
- [`c:while`](while.html)
