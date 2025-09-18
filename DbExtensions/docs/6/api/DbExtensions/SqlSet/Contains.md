---
redirect_from: /DbExtensions/docs/api/DbExtensions/SqlSet/Contains.html
---

SqlSet.Contains Method
======================
Checks the existance of the *entity*, using the primary key value.
  
**Namespace:** [DbExtensions][1]  
**Assembly:** DbExtensions.dll

Syntax
------

```csharp
public bool Contains(
	Object entity
)
```

#### Parameters

##### *entity*  [Object][2]
The entity whose existance is to be checked.

#### Return Value
[Boolean][3]  
true if the primary key value exists in the database; otherwise false.

Exceptions
----------

| Exception                      | Condition                                                                         |
| ------------------------------ | --------------------------------------------------------------------------------- |
| [InvalidOperationException][4] | This method can only be used on sets where the result type is an annotated class. |


See Also
--------

#### Reference
[SqlSet Class][5]  
[DbExtensions Namespace][1]  

[1]: ../README.md
[2]: https://learn.microsoft.com/dotnet/api/system.object
[3]: https://learn.microsoft.com/dotnet/api/system.boolean
[4]: https://learn.microsoft.com/dotnet/api/system.invalidoperationexception
[5]: README.md