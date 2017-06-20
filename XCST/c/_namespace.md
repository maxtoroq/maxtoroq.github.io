## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

## Examples

```xml
<person>
   <c:if test='associateSchema'>
      <c:variable name='xsiNs'>http://www.w3.org/2001/XMLSchema-instance</c:variable>
      <c:namespace name='xsi' value='xsiNs'/>
      <c:attribute name='noNamespaceSchemaLocation' namespace='{xsiNs}'>http://adventure-works.com/schemas/person.xsd</c:attribute>
   </c:if>
   ...
</person>
```
