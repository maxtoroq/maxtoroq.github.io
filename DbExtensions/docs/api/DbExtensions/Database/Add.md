Database.Add Method
===================
Recursively executes INSERT commands for the specified *entity* and all its one-to-one and one-to-many associations.

  **Namespace:**  [DbExtensions][1]  
  **Assembly:** DbExtensions.dll

Syntax
------

```csharp
public void Add(
	Object entity
)
```

#### Parameters

##### *entity*
Type: [System.Object][2]  
 The object whose INSERT command is to be executed. This parameter is named entity for consistency with the other CRUD methods, but in this case it doesn't need to be an actual entity, which means it doesn't need to have a primary key.


Remarks
-------
This method is a shortcut for `db.Table(entity.GetType()).Add(entity)`.

See Also
--------

#### Reference
[Database Class][3]  
[DbExtensions Namespace][1]  
[SqlTable.Add(Object)][4]  

[1]: ../README.md
[2]: https://docs.microsoft.com/dotnet/api/system.object
[3]: README.md
[4]: ../SqlTable/Add.md