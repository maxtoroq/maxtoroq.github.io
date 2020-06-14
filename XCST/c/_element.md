<div class="note eg" markdown="1">

###### Example
```xml
<c:element name='{(url != null ? "a" : "span")}'>
   ...
</c:element>
```

</div>

<div class="note eg" markdown="1">

###### Example: Creating an XElement
```xml
<c:variable name='foo'>
   <c:element name='foo'>
      <c:attribute name='bar'>123</c:attribute>
      <c:text>baz</c:text>
   </c:element>
</c:variable>
<c:assert test='foo is XElement'/>
<c:assert test='"foo" == foo.Name.LocalName'/>
<c:assert test='"123" == foo.Attribute("bar").Value'/>
<c:assert test='"baz" == foo.Value'/>
```

You can also create an [XElement] using literal result elements.

</div>

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object], [XElement] or [XmlElement].

## See Also

- [`c:attribute`](attribute.html)
- [`c:attribute-set`](attribute-set.html)

[Object]: {{ page.bcl_url }}system.object
[XElement]: {{ page.bcl_url }}system.xml.linq.xelement
[XmlElement]: {{ page.bcl_url }}system.xml.xmlelement
