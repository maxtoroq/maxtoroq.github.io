---
redirect_from: /DbExtensions/docs/api/DbExtensions/SqlSet/First_1.html
---

SqlSet.First(String, Object[]) Method
=====================================
Returns the first element in the set that satisfies a specified condition.
  
**Namespace:** [DbExtensions][1]  
**Assembly:** DbExtensions.dll

Overloads
---------

|                  | Name                        | Description                                                                |
| ---------------- | --------------------------- | -------------------------------------------------------------------------- |
| ![Public method] | [First()][2]                | Returns the first element of the set.                                      |
| ![Public method] | **First(String, Object[])** | Returns the first element in the set that satisfies a specified condition. |


Syntax
------

```csharp
public Object First(
	string predicate,
	params Object[] parameters
)
```

#### Parameters

##### *predicate*  [String][3]
A SQL expression to test each row for a condition.

##### *parameters*  [Object][4][]
The parameters to apply to the *predicate*.

#### Return Value
[Object][4]  
The first element in the set that passes the test in the specified *predicate*.

Exceptions
----------

| Exception                      | Condition                                                               |
| ------------------------------ | ----------------------------------------------------------------------- |
| [InvalidOperationException][5] | No element satisfies the condition in *predicate*.-or-The set is empty. |


See Also
--------

#### Reference
[SqlSet Class][6]  
[DbExtensions Namespace][1]  

[1]: ../README.md
[2]: First.md
[3]: https://learn.microsoft.com/dotnet/api/system.string
[4]: https://learn.microsoft.com/dotnet/api/system.object
[5]: https://learn.microsoft.com/dotnet/api/system.invalidoperationexception
[6]: README.md
[Public method]: ../../icons/pubmethod.svg "Public method"