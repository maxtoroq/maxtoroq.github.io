<div class="note eg" markdown="1">

###### Example: Displaying a Sign-in Form Without Redirecting
The following example uses the `LoadPage` method available in ASP.NET to dynamically load the sign-in page of a web app and call the `content` template.

```xml
<c:evaluate-package package='LoadPage("/account/sign-in.xcst")'
   initial-template='content'
   tunnel-params='new { returnUrl = this.Request.Url.PathAndQuery }'/>
```

</div>
