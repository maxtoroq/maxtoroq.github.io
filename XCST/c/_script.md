<div class="note eg" markdown="1">

###### Example: Fetching Data to Pass to Other Templates
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

</div>

## Error Conditions

It is a compilation error if the `src` attribute is present when the content of the element is non-empty.

## See Also

- [`c:void`](void.html)
