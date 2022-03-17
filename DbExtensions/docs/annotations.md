---
title: Annotations
---
Annotations provide metadata about your objects that allows DbExtensions generate commands for you. There are four attributes available for this purpose: [TableAttribute], [ColumnAttribute], [AssociationAttribute] and [ComplexPropertyAttribute]. The use of these attributes is always required, DbExtensions doesn't infer any mapping between your objects and your database (no conventions).

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
Use the ColumnAttribute to associate a property with a column in a database table. If no name is specified, the property name is used as column name.

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

For multi-column keys use a comma-separated list.

ComplexPropertyAttribute
-----------------------
Use the ComplexPropertyAttribute (starting v6.3) to group columns into a separate type. Some ORMs call these objects *value objects*. If no name is specified, the property name is used as base name, which is prepended to the column names as defined in the complex type. 

<figure class="code" data-highlight-lines="10 16 19" markdown="1">

```csharp
[Table(Name = "Customers")]
public class Customer {

  [Column(IsPrimaryKey = true)]
  public string CustomerID { get; set; }

  [Column]
  public string CompanyName { get; set; }

  [ComplexProperty]
  public Contact Contact { get; set; }
}

public class Contact {

  [Column]
  public string Name { get; set; }

  [Column]
  public string Title { get; set; }
}
```

</figure>

Use the [Separator][ComplexPropertyAttribute.Separator] property if the columns names use a naming convention that separate words, e.g. if the column names are `Contact_Name` and `Contact_Title`:

```csharp
[ComplexProperty(Separator = "_")]
public Contact Contact { get; set; }
```

<div class="note" markdown="1">

###### Tip: Automatic query mapping of complex properties
If you use `$` as separator, then you can query your table using [SqlBuilder] with a simple `SELECT *` and get your complex properties populated, as explained in [Query Mapping](query-mapping.md#complex-properties).

</div>

<div class="note" markdown="1">

###### Tip: Nesting complex types
You can nest the complex type definition in the entity type that uses it, to avoid polluting the namespace.

</div>


[TableAttribute]: api/DbExtensions/TableAttribute/README.md
[ColumnAttribute]: api/DbExtensions/ColumnAttribute/README.md
[AssociationAttribute]: api/DbExtensions/AssociationAttribute/README.md
[ComplexPropertyAttribute]: api/DbExtensions/ComplexPropertyAttribute/README.md
[ComplexPropertyAttribute.Separator]: api/DbExtensions/ComplexPropertyAttribute/Separator.md
[SqlBuilder]: SqlBuilder.md
[4]: https://msdn.microsoft.com/en-us/library/9eekhta0
[5]: https://msdn.microsoft.com/en-us/library/ms132397
