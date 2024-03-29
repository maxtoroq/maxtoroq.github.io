---
title: DbExtensions — The SQL framework for .NET
omit_site_title: yes
---

DbExtensions is a data-access framework with a strong focus on **query composition, granularity and code aesthetics**. It supports both POCO and dynamic (untyped) mapping.

Querying with SqlSet
--------------------
[SqlSet](docs/SqlSet.html) provides a LINQish API for making queries, but using SQL instead of lambda expressions.

```csharp
var db = new Database("<connection string>", "<provider invariant name>");

SqlSet<Product> products = db.From<Product>("Products");
SqlSet<Product> productsToReorder = products.Where("UnitsInStock < {0}", 10);

if (productsToReorder.Any()) {

   SqlSet<Product> top5WithLowestStock = productsToReorder.OrderBy("UnitsInStock").Take(5);
   Product first = top5WithLowestStock.First();

   if (top5WithLowestStock.Count() > 1) {
      Product second = top5WithLowestStock.Skip(1).First();
   }
}
```

<details markdown="1">
<summary>The above code executes the following queries (click to expand).</summary>

```sql
SELECT (CASE WHEN EXISTS (
   SELECT *
   FROM Products
   WHERE UnitsInStock < @p0) THEN 1 ELSE 0 END)
-- @p0: Input Int32 (Size = 0) [10]
-- [-1] records affected.
SELECT *
FROM (
   SELECT *
   FROM Products
   WHERE UnitsInStock < @p0
   ORDER BY UnitsInStock
   LIMIT @p1) dbex_set5
LIMIT @p2
-- @p0: Input Int32 (Size = 0) [10]
-- @p1: Input Int32 (Size = 0) [5]
-- @p2: Input Int32 (Size = 0) [1]
-- [-1] records affected.
SELECT COUNT(*)
FROM (
   SELECT *
   FROM Products
   WHERE UnitsInStock < @p0
   ORDER BY UnitsInStock
   LIMIT @p1) dbex_count
-- @p0: Input Int32 (Size = 0) [10]
-- @p1: Input Int32 (Size = 0) [5]
-- [-1] records affected.
SELECT *
FROM (
   SELECT *
   FROM Products
   WHERE UnitsInStock < @p0
   ORDER BY UnitsInStock
   LIMIT @p1) dbex_set6
LIMIT @p2
OFFSET @p3
-- @p0: Input Int32 (Size = 0) [10]
-- @p1: Input Int32 (Size = 0) [5]
-- @p2: Input Int32 (Size = 0) [1]
-- @p3: Input Int32 (Size = 0) [1]
-- [-1] records affected.
```

</details>

Building queries with SqlBuilder
--------------------------------
With [SqlBuilder](docs/SqlBuilder.html) you have complete control of the executing SQL.

```csharp
var query = SQL
   .SELECT("p.ProductID, p.ProductName, p.UnitPrice, p.CategoryID")
   ._("c.CategoryID AS Category$CategoryID, c.CategoryName AS Category$CategoryName")
   .FROM("Products p")
   .JOIN("Categories c ON p.CategoryID = c.CategoryID")
   .WHERE()
   ._If(categoryId.HasValue, "p.CategoryID = {0}", categoryId);

IEnumerable<Product> products = db.Map<Product>(query);
```

Changing data
-------------
```csharp
public class NorthwindDatabase : Database {

   public NorthwindDatabase() 
      : base("<connection string>", "<provider invariant name>") { }
}

var db = new NorthwindDatabase();

Product prod = db.Find<Product>(1);
prod.UnitPrice = prod.UnitPrice * 1.1;

db.Update(prod);
```
You can also use SqlBuilder to build insert, update and delete commands.

Features
--------
- Deferred execution
- POCO and dynamic mapping for queries
  - Mapping to properties (including complex)
  - Mapping to constructor arguments
- Attribute mapping for inserts, updates and deletes
- Generic and non-generic APIs (for when the type of the entity is not known at build time)
- Automatic connection management (no need to explicitly open connection, but you are allowed to)
- Eager loading
- Optimistic concurrency (using version column)
- Batch commands
- Profiling
- Provider-independent (tested against SQL Server, MySQL and SQLite)

Not included
------------------------
DbExtensions doesn't provide the following functionality:

- Unit of work
- Change tracking
- Identity map
- Lazy loading

<div style="text-align: center">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=DbExtensions&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>
