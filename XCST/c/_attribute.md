
<div class="note eg" markdown="1">

###### Example
```xml
<input type='checkbox'>
   <c:if test='isChecked'>
      <c:attribute name='checked'>checked</c:attribute>
   </c:if>
</input>
```

</div>

<div class="note" markdown="1">

###### Note: Differences with `xsl:attribute`
The default separator for sequence constructors of `c:attribute` is a single space (consistent with all other simple content instructions), while `xsl:attribute` uses an empty string.

</div>

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object], [XAttribute] or [XmlAttribute].

## See Also

- [`c:element`](element.html)
- [`c:namespace`](namespace.html)

[Object]: {{ page.bcl_url }}system.object
[XAttribute]: {{ page.bcl_url }}system.xml.linq.xattribute
[XmlAttribute]: {{ page.bcl_url }}system.xml.xmlattribute
