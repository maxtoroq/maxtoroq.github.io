---
redirect_from: /DbExtensions/docs/api/DbExtensions/SqlBuilder/SetNextClause.html
---

SqlBuilder.SetNextClause Method
===============================
Sets *clauseName* as the next SQL clause.
  
**Namespace:** [DbExtensions][1]  
**Assembly:** DbExtensions.dll

Syntax
------

```csharp
public SqlBuilder SetNextClause(
	string clauseName,
	string separator
)
```

#### Parameters

##### *clauseName*  [String][2]
The SQL clause.

##### *separator*  [String][2]
The clause body separator, used for consecutive appends to the same clause.

#### Return Value
[SqlBuilder][3]  
A reference to this instance after the operation has completed.

See Also
--------

#### Reference
[SqlBuilder Class][3]  
[DbExtensions Namespace][1]  
[NextClause][4]  

[1]: ../README.md
[2]: https://learn.microsoft.com/dotnet/api/system.string
[3]: README.md
[4]: NextClause.md