
<div class="note eg" markdown="1">

###### Example
```xml
<c:use-package name='com.example.LayoutPackage'>
   <c:override>
      <c:template name='content' expand-text='yes'>
         <h1>{this.title}</h1>
         ...
      </c:template>
   </c:override>
</c:use-package>
```

</div>

<div class="note" markdown="1">

###### Note: Differences with `xsl:use-package`
While `xsl:use-package` can be used only at the highest import precedence level, `c:use-package` can be used at any level.

</div>
