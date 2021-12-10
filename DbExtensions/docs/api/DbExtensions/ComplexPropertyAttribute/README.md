ComplexPropertyAttribute Class
==============================
Designates a property as a complex property that groups columns of a table that share the same base name.


Inheritance Hierarchy
---------------------
[System.Object][1]  
  [System.Attribute][2]  
    **DbExtensions.ComplexPropertyAttribute**  

  **Namespace:**  [DbExtensions][3]  
  **Assembly:**  DbExtensions (in DbExtensions.dll)

Syntax
------

```csharp
public sealed class ComplexPropertyAttribute : Attribute
```

The **ComplexPropertyAttribute** type exposes the following members.


Constructors
------------

                 | Name                          | Description                                                          
---------------- | ----------------------------- | -------------------------------------------------------------------- 
![Public method] | [ComplexPropertyAttribute][4] | Initializes a new instance of the **ComplexPropertyAttribute** class 


Properties
----------

                   | Name           | Description                                                                                                                           
------------------ | -------------- | ------------------------------------------------------------------------------------------------------------------------------------- 
![Public property] | [Name][5]      | The base name for the columns on the complex property. The default is the property name.                                              
![Public property] | [Separator][6] | The separator to use between the base name and the complex property's columns. The default is null, which means no separator is used. 


See Also
--------

#### Reference
[DbExtensions Namespace][3]  

[1]: http://msdn.microsoft.com/en-us/library/e5kfa45b
[2]: http://msdn.microsoft.com/en-us/library/e8kc3626
[3]: ../README.md
[4]: _ctor.md
[5]: Name.md
[6]: Separator.md
[Public method]: ../../icons/pubmethod.gif "Public method"
[Public property]: ../../icons/pubproperty.gif "Public property"