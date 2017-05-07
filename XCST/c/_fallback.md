## Notes

Currently in XCST 1.0 there's no much use for `c:fallback`, except to handle unknown extension instructions.

## Examples

```xml
<c:template name='c:initial-template' extension-element-prefixes='eg' xmlns:eg='http://example.com/ns/foo'>
   <eg:foo>
      <c:fallback>
         <c:message>eg:foo not available.</c:message>
         <c:call-template name='fallback-foo'/>
      </c:fallback>
   </eg:foo>
</c:template>
```
