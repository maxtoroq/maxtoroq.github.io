<div class="note eg" markdown="1">

###### Example
```xml
<c:processing-instruction name='xml-stylesheet'>href="atom.xsl" type="text/xsl"</c:processing-instruction>
```

</div>

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

It is a compilation error if the required item type of the containing sequence constructor is not one of, or a super class of, [Object], [XProcessingInstruction] or [XmlProcessingInstruction].

[Object]: {{ page.bcl_url }}system.object
[XProcessingInstruction]: {{ page.bcl_url }}system.xml.linq.xprocessinginstruction
[XmlProcessingInstruction]: {{ page.bcl_url }}system.xml.xmlprocessinginstruction
