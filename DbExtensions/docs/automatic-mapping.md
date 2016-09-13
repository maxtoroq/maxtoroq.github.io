---
title: Automatic Mapping
---
**Automatic mapping** is about turning rows into objects, matching column names to property names. Automatic mapping is:

- Supported for both POCO and dynamic objects
- Supported on all query APIs (using [SqlBuilder][1], [SqlSet][2] or `string`)
- One way only, to turn objects into rows you have to use [Explicit Mapping]

Basic mapping
-------------
```csharp
var db = new Database("<connection string>", "<provider invariant name>");

var query = SQL
  .SELECT("*")
  .FROM("Products");

return db.Map<Product>(query);
```

If the column names in your database exactly match your object then there's nothing else to do.

Complex properties
------------------
Given the types:

```csharp
public class Product {

  public int ProductID { get; set; }
  public string ProductName { get; set; }
  public Category Category { get; set; }
  public Supplier Supplier { get; set; }
}

public class Category {

  public int CategoryID { get; set; }
  public string CategoryName { get; set; }
}

public class Supplier {

  public int SupplierID { get; set; }
  public string CompanyName { get; set; }
}
```

You can make the following query to return `Product`s that include `Category` and `Supplier`:

```csharp
var query = SQL
  .SELECT("p.ProductID, p.ProductName")
  ._("c.CategoryID AS Category$CategoryID, c.CategoryName AS Category$CategoryName")
  ._("s.SupplierID AS Supplier$SupplierID, s.CompanyName AS Supplier$CompanyName")
  .FROM("Products p")
  .LEFT_JOIN("Categories c ON p.CategoryID = c.CategoryID")
  .LEFT_JOIN("Suppliers s ON p.SupplierID = s.SupplierID");

return db.Map<Product>(query);
```



[1]: SqlBuilder.html
[2]: SqlSet.html
