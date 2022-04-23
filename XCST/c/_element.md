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

You can also create an [XElement] using a literal result element.

</div>

<div class="note" markdown="1">

###### Differences with `xsl:element`
When the 'namespace' attribute is omitted and the 'name' attribute specifies an un-prefixed qualified name, the namespace for `c:element` is resolved at run-time. This allows you to write code that works the same way for any namespace. For example:

```xml
<c:template name='html'>
   <html>
      <body>
         <c:call-template name='table'/>
      </body>
   </html>
</c:template>

<c:template name='xhtml'>
   <html xmlns='http://www.w3.org/1999/xhtml'>
      <body>
         <c:call-template name='table'/>
      </body>
   </html>
</c:template>

<c:template name='table'>
   <c:element name='table'>
      ...
   </c:element>
</c:template>
```

When the `html` template is called, the `table` element will be in the null namespace. When the `xhtml` template is called, the `table` element will be in the `http://www.w3.org/1999/xhtml` namespace.

Being unaffected by the default namespace also allows you to use `c:element` when writing XCST code without using a prefix.

</div>

## Error Conditions

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object], [XElement] or [XmlElement].

## See Also

- [`c:attribute`](attribute.html)
- [`c:attribute-set`](attribute-set.html)

[Object]: {{ page.bcl_url }}system.object
[XElement]: {{ page.bcl_url }}system.xml.linq.xelement
[XmlElement]: {{ page.bcl_url }}system.xml.xmlelement
