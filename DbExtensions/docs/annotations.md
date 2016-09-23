---
title: Annotations
---
Annotations provide metadata about your objects that allows DbExtensions generate commands for you. There are three attributes available for this purpose: [TableAttribute][1], [ColumnAttribute][2] and [AssociationAttribute][3]. The use of these attributes is always required, DbExtensions doesn't infer any mapping between your objects and your database (no conventions).

TableAttribute
--------------
Use the TableAttribute to associate a class with a database table. If no name is specified, the class name is used as table name.

```csharp
[Table(Name = "Products")]
public class Product {
  ...
}
```

ColumnAttribute
---------------
Use the ColumnAttribute to associate a property with a column in a database table.  If no name is specified, the property name is used as column name.

```csharp
[Column(IsPrimaryKey = true, IsDbGenerated = true)]
public int ProductID { get; set; }
```

AssociationAttribute
--------------------

[1]: {{ page.repository_url }}/blob/master/docs/api/DbExtensions/TableAttribute/README.md
[2]: {{ page.repository_url }}/blob/master/docs/api/DbExtensions/ColumnAttribute/README.md
[3]: {{ page.repository_url }}/blob/master/docs/api/DbExtensions/AssociationAttribute/README.md
