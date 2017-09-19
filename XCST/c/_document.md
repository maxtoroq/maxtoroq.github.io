
## Remarks

`c:document` is used to create in-memory documents, also known as temporary trees. It supports two document models: [XDocument][System.Xml.Linq.XDocument] (which is the default) and [XmlDocument][System.Xml.XmlDocument].

<div class="note eg" markdown="1">

###### Example: Creating an XmlDocument
```xml
<c:variable name='doc' as='XmlDocument'>
   <c:document>
      <foo bar='123'>baz</foo>
   </c:document>
</c:variable>
<c:assert test='"foo" == doc.DocumentElement.LocalName'/>
<c:assert test='"123" == doc.DocumentElement.GetAttribute("bar")'/>
<c:assert test='"baz" == doc.DocumentElement.InnerText'/>
```

</div>

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object][System.Object], [XDocument][System.Xml.Linq.XDocument] or [XmlDocument][System.Xml.XmlDocument].

[System.Object]: {{ page.bcl_url }}system.object
[System.Xml.Linq.XDocument]: {{ page.bcl_url }}system.xml.linq.xdocument
[System.Xml.XmlDocument]: {{ page.bcl_url }}system.xml.xmldocument
