---
redirect_from: /DbExtensions/docs/api/DbExtensions/SqlSet_1/Take.html
---

SqlSet&lt;TResult>.Take Method
==============================
Returns a specified number of contiguous elements from the start of the set.
  
**Namespace:** [DbExtensions][1]  
**Assembly:** DbExtensions.dll

Syntax
------

```csharp
public SqlSet<TResult> Take(
	int count
)
```

#### Parameters

##### *count*  [Int32][2]
The number of elements to return.

#### Return Value
[SqlSet][3]&lt;[TResult][3]>  
A new [SqlSet&lt;TResult>][3] that contains the specified number of elements from the start of the current set.

See Also
--------

#### Reference
[SqlSet&lt;TResult> Class][3]  
[DbExtensions Namespace][1]  

[1]: ../README.md
[2]: https://learn.microsoft.com/dotnet/api/system.int32
[3]: README.md