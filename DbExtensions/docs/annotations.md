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
Use the AssociationAttribute to represent a database association, such as a foreign key relationship.

```csharp
[Association(ThisKey = nameof(CategoryID))]
public Category Category { get; set; }
```

For one-to-many relationships, use a type that implements [IEnumerable&lt;T>][4], such as [Collection&lt;T>][5].

```csharp
[Association(OtherKey = nameof(OrderDetail.ProductID))]
public Collection<OrderDetail> OrderDetails { get; } = new Collection<OrderDetail>();
```

The default for ThisKey and OtherKey, when not specified, is the type's primary key properties.

[1]: {{ page.repository_url }}/blob/master/docs/api/DbExtensions/TableAttribute/README.md
[2]: {{ page.repository_url }}/blob/master/docs/api/DbExtensions/ColumnAttribute/README.md
[3]: {{ page.repository_url }}/blob/master/docs/api/DbExtensions/AssociationAttribute/README.md
[4]: https://msdn.microsoft.com/en-us/library/9eekhta0
[5]: https://msdn.microsoft.com/en-us/library/ms132397
