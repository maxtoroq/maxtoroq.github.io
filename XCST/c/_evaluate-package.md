## Examples

```xml
<c:evaluate-package package='LoadPage("/account/sign-in.xcst")'
   initial-template='content'
   tunnel-params='new { returnUrl = this.Request.Url.PathAndQuery }'/>
```
