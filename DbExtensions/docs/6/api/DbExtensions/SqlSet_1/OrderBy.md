---
redirect_from: /DbExtensions/docs/api/DbExtensions/SqlSet_1/OrderBy.html
---

SqlSet&lt;TResult>.OrderBy Method
=================================
Sorts the elements of the set according to the *columnList*.
  
**Namespace:** [DbExtensions][1]  
**Assembly:** DbExtensions.dll

Syntax
------

```csharp
public SqlSet<TResult> OrderBy(
	string columnList,
	params Object[] parameters
)
```

#### Parameters

##### *columnList*  [String][2]
The list of columns to base the sort on.

##### *parameters*  [Object][3][]
The parameters to apply to the *columnList*.

#### Return Value
[SqlSet][4]&lt;[TResult][4]>  
A new [SqlSet&lt;TResult>][4] whose elements are sorted according to *columnList*.

See Also
--------

#### Reference
[SqlSet&lt;TResult> Class][4]  
[DbExtensions Namespace][1]  

[1]: ../README.md
[2]: https://learn.microsoft.com/dotnet/api/system.string
[3]: https://learn.microsoft.com/dotnet/api/system.object
[4]: README.md