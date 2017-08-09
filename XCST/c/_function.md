## Returning Values

To return a value from a function you need to use the [`c:return`](return.html) instruction, or return from code in a [`c:script`](script.html) element. `c:function` is optimized for logic, while [`c:template`](template.html) is optimized for content.

<div class="note eg" markdown="1">

###### Example: Returning from a [`c:script`](script.html) element
```xml
<c:function name='Truncate' as='string' visibility='public'>
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

## Error Conditions

It is a compilation error if there's another `c:function` declaration in the containing module with the same name and number of parameters.

It is a compilation error if a `c:function` declaration has `visibility='abstract'` and the content of the element is non-empty.

## Differences with `xsl:function`

As explained above, values must be returned explicitly, there's no implicit output. `c:function` parameters have several limitations, see [Function Parameters](param.html#function-parameters). `c:function` parameters can have default values.

## See Also

- [`c:template`](template.html)
