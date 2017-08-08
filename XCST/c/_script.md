## The `src` Attribute

Sometimes it's convenient to move code to a separate file for better organization, or for better tooling support (e.g. code completion). You can use the `src` attribute to include the code in the referenced file in place where the `c:script` element appears. E.g.:

```xml
<c:function name='Save' as='bool'>
   <c:param name='input' as='Document'/>

   <c:script src='_Save.csx'/>
</c:function>
```

Note that the file contents are not modified in any way. The script cannot have `using` directives, the containing module must use [`c:import-namespace`](import-namespace.html) for any namespace required by the script.

## Error Conditions

It is a compilation error if the `src` attribute is present when the content of the element is non-empty.

## Examples

```xml
<c:template name='c:initial-template'>
   <c:script>
      <![CDATA[
      
      int id;
      Product product;
      
      if (!int.TryParse(UrlData[0], out id)
         || (product = Edit(id)) == null) {

         Response.StatusCode = 404;
         return;
      }
      ]]>
   </c:script>
   <c:next-template>
      <c:with-param name='product' value='product' tunnel='yes'/>
   </c:next-template>
</c:template>
```

## See Also

- [`c:void`](void.html)
