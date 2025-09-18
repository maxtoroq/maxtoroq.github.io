---
redirect_from: /DbExtensions/docs/api/DbExtensions/SqlBuilder/_Else.html
---

SqlBuilder._Else Method
=======================
Appends *format* to the current clause if an antecedent call to [_If(Boolean, String, Object[])][1] or [_ElseIf(Boolean, String, Object[])][2] used a false condition.
  
**Namespace:** [DbExtensions][3]  
**Assembly:** DbExtensions.dll

Syntax
------

```csharp
public SqlBuilder _Else(
	string format,
	params Object[] args
)
```

#### Parameters

##### *format*  [String][4]
The format string that represents the body of the current clause.

##### *args*  [Object][5][]
The parameters of the clause body.

#### Return Value
[SqlBuilder][6]  
A reference to this instance after the append operation has completed.

See Also
--------

#### Reference
[SqlBuilder Class][6]  
[DbExtensions Namespace][3]  

[1]: _If.md
[2]: _ElseIf.md
[3]: ../README.md
[4]: https://learn.microsoft.com/dotnet/api/system.string
[5]: https://learn.microsoft.com/dotnet/api/system.object
[6]: README.md