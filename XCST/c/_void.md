## Remarks

The `c:void` instruction has two uses. The first use is to call methods that don't return values (`void` methods in C#), or when you don't want to output the return value. The expression in the `value` attribute must be a valid C# statement.

<div class="note eg" markdown="1">

###### Example: Redirecting
In the following example, the `Redirect` method is a void method, you can use `c:void` to call it.
 
```xml
<c:void value='Redirect("/")'/>
```

</div>

The second use is to evaluate a sequence constructor but discarding the output. This can be useful if you run a program only for its side-effects.

## Error Conditions

It is a compilation error if the `value` attribute is present when the content of the element is non-empty.

## See Also

- [`c:script`](script.html)
