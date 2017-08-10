<div class="note eg" markdown="1">

###### Example
```xml
<c:evaluate-package package='LoadPage("/account/sign-in.xcst")'
   initial-template='content'
   tunnel-params='new { returnUrl = this.Request.Url.PathAndQuery }'/>
```

</div>
