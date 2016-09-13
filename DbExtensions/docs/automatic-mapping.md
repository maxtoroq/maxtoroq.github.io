---
title: Automatic Mapping
---
**Automatic mapping** is about turning rows into objects, matching column names to property names. Automatic mapping is:

- Supported for both POCO and dynamic objects
- Supported on all query APIs (using [SqlBuilder][1], [SqlSet][2] or `string`)
- One way only, to turn objects into rows you have to use [explicit mapping][3]

Basic mapping
-------------
```csharp
var db = new Database("<connection string>", "<provider invariant name>");

var query = SQL
  .SELECT("*")
  .FROM("Products");

return db.Map<Product>(query);
```

If the column names in your database exactly match your object's properties then there's nothing else to do. If a column name does not match a property it's simply ignored.

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

You can use the following query to return `Product`s that include `Category` and `Supplier`:

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

**Use the `$` character in column aliases to specify a path into a complex property**. There's no depth limit, e.g.:

```csharp
var query = SQL
  .SELECT("et.EmployeeID, et.TerritoryID")
  ._("t.TerritoryID AS Territory$TerritoryID, t.TerritoryDescription AS Territory$TerritoryDescription, t.RegionID AS Territory$RegionID")
  ._("r.RegionID AS Territory$Region$RegionID, r.RegionDescription AS Territory$Region$RegionDescription")
  .FROM("EmployeeTerritories et")
  .LEFT_JOIN("Territories t ON et.TerritoryID = t.TerritoryID")
  .LEFT_JOIN("Region r ON t.RegionID = r.RegionID");

return db.Map<EmployeeTerritory>(query);
```

<div class="note">If all columns related to a complex property are null, the property is set to null.</div>

Constructors
------------
You can also map columns to constructor arguments, e.g.:

```csharp
public class SupplierInfo {
  
  public string CompanyName { get; set; }
  public Uri CompanyWebsite { get; set; }
}

var query = SQL
  .SELECT("CompanyName, CompanyWebsite AS CompanyWebsite$1")
  .FROM("Supplier");

return db.Map<SupplierInfo>(query);
```

In the example above, `CompanyWebsite AS CompanyWebsite$1` means *map the `CompanyWebsite` column to the first constructor parameter of the `CompanyWebsite` property*, which in this case is a [Uri][4] object.

```text
CompanyWebsite AS CompanyWebsite$1
\____________/    \____________/  \
      |                  |         \
  column in       property in     first parameter
Supplier table    SupplierInfo    in property's
                  object          constructor
```

*[POCO]: Plain Old CLR Object
[1]: SqlBuilder.html
[2]: SqlSet.html
[3]: explicit-mapping.html
[4]: https://msdn.microsoft.com/en-us/library/system.uri
