## Remarks

While [`c:template`](template.html) is optimized for content (markup, text), `c:function` is optimized for logic. Functions can be called from C# code, because it compiles to a regular method. See the table below for more differences.

feature | `c:template` | `c:function`
------- | ------------ | -----------
Implicit output | yes | no
Invocation method | [`c:call-template`](call-template.html) | C# (e.g. `Foo()`)
Parameter binding | by name | by position
[Tunnel parameters](call-template.html#dt-tunnel-parameter) | yes | no

Because functions don't have an implicit output, to return a value you need to use the [`c:return`](return.html) instruction, or return from code in a [`c:script`](script.html) element.

<div class="note eg" markdown="1">

###### Example: Returning from a [`c:script`](script.html) Element
```xml
<c:function name='Truncate' as='string'>
   <c:param name='s' as='string'/>
   <c:param name='maxLength' as='int'/>
   <c:param name='suffix'>…</c:param>

   <c:script>
      <![CDATA[

      if (string.IsNullOrEmpty(s)) {
         return string.Empty;
      }

      if (s.Length <= maxLength) {
         return s;
      }

      return string.Concat(s.Substring(0, maxLength - suffix.Length), suffix);
      ]]>
   </c:script>
</c:function>
```

</div>

<div class="note eg" markdown="1">

###### Example: Returning with [`c:return`](return.html)
```xml
<c:function name='MailBody' as='string'>
   <c:param name='contact' as='Contact'/>

   <c:return>
      <c:serialize method='html'>
         <a:model value='contact'>
            <dl>
               <a:display>
                  <a:member-template>
                     <dt>
                        <a:display-name/>
                        <c:text>:</c:text>
                     </dt>
                     <dd>
                        <a:display/>
                     </dd>
                  </a:member-template>
               </a:display>
            </dl>
         </a:model>
      </c:serialize>
   </c:return>
</c:function>
```

</div>

## Function Parameters

Function parameters have several limitations, due to the fact that they compile to method parameters in C#. Type inference does not work when the value is supplied by the `value` attribute (defaults to [Object][System.Object]). Default values are limited to [constant expressions]({{ page.csharp_spec_url}}expressions.md#constant-expressions). The order of parameters is significant. Cannot have a parameter without a default value after one with a default value.

<div class="note" markdown="1">

###### Note: Differences with `xsl:function`
As explained above, values must be returned explicitly, there's no implicit output. `c:function` parameters [have several limitations](#function-parameters). `c:function` parameters can have default values.

</div>

## Error Conditions

It is a compilation error if a `c:function` declaration has `visibility='abstract'` and the content of the element, excluding any `c:param` elements, is non-empty.

It is a compilation error if there's another `c:function` declaration in the containing module with the same name and number of parameters.

## See Also

- [Function Parameters](param.html#function-parameters)
- [`c:template`](template.html)


[System.Object]: {{ page.bcl_url }}system.object
