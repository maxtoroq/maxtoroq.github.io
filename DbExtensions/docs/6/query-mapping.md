---
title: Query Mapping
redirect_from: /DbExtensions/docs/query-mapping.html
---
DbExtensions supports a special column alias syntax to match columns to properties and constructor parameters. This syntax is:

- Supported for both <abbr title="Plain Old CLR Object">POCO</abbr> and dynamic objects
- Supported on all query APIs (using [SqlBuilder], [SqlSet] or `string`)

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

<div class="note danger" markdown="1">

###### Warning
It's not recommended to project onto an [annotated][annotations] entity type. Updating a partially loaded entity may cause data loss.

</div>

To map to dynamic objects omit the type:

```csharp
return db.Map(query);
```

Complex properties
------------------
Use the `$` character in column aliases to specify a path into a complex property. For example,
given the types:

<figure class="code" data-highlight-lines="5 6" markdown="1">

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

</figure>

You can use the following query to return Product objects that include Category and Supplier:

<figure class="code" data-highlight-lines="3 4" markdown="1">

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

</figure>

 There's no depth limit, e.g.:

<figure class="code" data-highlight-lines="4" markdown="1">

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

</figure>

<div class="note" markdown="1">

###### Note
If all columns related to a complex property are null, the property is set to null.

</div>

Constructors
------------

### Positional arguments
Use numbers to map columns to constructor arguments. e.g.:

<figure class="code" data-highlight-lines="6 13" markdown="1">

```csharp
public class SupplierInfo {
  
  public string CompanyName { get; }
  public string CompanyWebsite { get; }
  
  public SupplierInfo(string companyName, string companyWebsite) {
    this.CompanyName = companyName;
    this.CompanyWebsite = companyWebsite;
  }
}

var query = SQL
  .SELECT("CompanyName AS '1', CompanyWebsite AS '2'")
  .FROM("Supplier");

return db.Map<SupplierInfo>(query);
```

</figure>

This also works for complex properties, e.g:

<figure class="code" data-highlight-lines="4 8" markdown="1">

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

</figure>

In the example above, `CompanyWebsite AS CompanyWebsite$1` means *map the CompanyWebsite column to the first constructor parameter of the CompanyWebsite property*, which in this case is a [Uri] object.

<pre>
CompanyWebsite AS CompanyWebsite$1
\____________/    \____________/  \
      |                  |         \
  column in       property in     first parameter
Supplier table    SupplierInfo    in property's
                  object          constructor
</pre>

Let's use the Uri type again, but as parameter in SupplierInfo:

<figure class="code" data-highlight-lines="6 13" markdown="1">

```csharp
public class SupplierInfo {
  
  public string CompanyName { get; }
  public Uri CompanyWebsite { get; }
  
  public SupplierInfo(string companyName, Uri companyWebsite) {
    this.CompanyName = companyName;
    this.CompanyWebsite = companyWebsite;
  }
}

var query = SQL
  .SELECT("CompanyName AS '1', CompanyWebsite AS '2$1'")
  .FROM("Supplier");

return db.Map<SupplierInfo>(query);
```

</figure>

In the example above, `CompanyWebsite AS 2$1` means *map the CompanyWebsite column to the first constructor parameter (of Uri) of the second constructor parameter (of SupplierInfo)*.

<div class="note" markdown="1">

###### Note
Numbers only have meaning relative to each other. For instance, instead of using 1 and 2, you can use 0 and 1, or 100 and 200. The number of <em>numeric</em> column names determines which constructor to use (number of parameters), and the arguments are ordered based on the column names.

</div>

### Named arguments
Starting v6.3 you can use the same syntax for complex properties to map columns to arguments by name instead of position. This only works for types that have a single public constructor.


[SqlBuilder]: SqlBuilder.md
[SqlSet]: SqlSet.md
[Uri]: https://msdn.microsoft.com/en-us/library/system.uri
[annotations]: annotations.md
