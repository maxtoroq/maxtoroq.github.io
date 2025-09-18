---
redirect_from: /DbExtensions/docs/api/DbExtensions/SqlBuilder/LEFT_JOIN.html
---

SqlBuilder.LEFT_JOIN Method
===========================
Appends the LEFT JOIN clause using the provided *format* string and parameters.
  
**Namespace:** [DbExtensions][1]  
**Assembly:** DbExtensions.dll

Syntax
------

```csharp
public SqlBuilder LEFT_JOIN(
	string format,
	params Object[] args
)
```

#### Parameters

##### *format*  [String][2]
The format string that represents the body of the LEFT JOIN clause.

##### *args*  [Object][3][]
The parameters of the clause body.

#### Return Value
[SqlBuilder][4]  
A reference to this instance after the append operation has completed.

See Also
--------

#### Reference
[SqlBuilder Class][4]  
[DbExtensions Namespace][1]  

[1]: ../README.md
[2]: https://learn.microsoft.com/dotnet/api/system.string
[3]: https://learn.microsoft.com/dotnet/api/system.object
[4]: README.md