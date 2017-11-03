<div class="note eg" markdown="1">

###### Example
```xml
<c:element name='{(url != null ? "a" : "span")}'>
   ...
</c:element>
```

</div>

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object], [XElement] or [XmlElement].

## See Also

- [`c:attribute`](attribute.html)
- [`c:attribute-set`](attribute-set.html)

[Object]: {{ page.bcl_url }}system.object
[XElement]: {{ page.bcl_url }}system.xml.linq.xelement
[XmlElement]: {{ page.bcl_url }}system.xml.xmlelement
