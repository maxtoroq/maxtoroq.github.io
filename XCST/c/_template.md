
<div class="note eg" markdown="1">

###### Example: Matching object
```xml
<c:template match='Order o and { CountryCode: "US" }'>
   <!-- variable 'o' can be used here -->
</c:template>
```

</div>

<div class="note eg" markdown="1">

###### Example: Matching nodes
```xml
<c:template match='XElement el &amp;&amp; el.Name == "html"'>
   <!-- variable 'el' can be used here -->
</c:template>
```

</div>

<div class="note" markdown="1">

###### Note: Differences with `xsl:template`
`c:template` is either rule or named, not both.

</div>

## Error Conditions

It is a compilation error if both attributes `name` and `match` are present.

It is a compilation error if the `name` attribute uses a [reserved namespace](./#reserved-namespaces), except the name `c:initial-template`.

It is a compilation error if the `mode` attribute is present when the `name` attribute is used.

It is a compilation error if the `visibility` attribute is present when the `match` attribute is used.

It is a compilation error if a named template has `visibility='abstract'` and the content of the element, excluding any `c:param` elements, is non-empty.

## See Also

- [`c:function`](function.html)
