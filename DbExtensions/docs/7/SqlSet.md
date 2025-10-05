---
title: SqlSet Tutorial
---

Overview
--------
[SqlSet][1] is a class designed to build and optionally execute SQL queries. It's a LINQ-inspired query API that uses SQL instead of lambda expressions. The main design goals are:

- Execute the most common queries without having to build the complete SQL yourself.
- Abstract-away SQL dialect differences (e.g. pagination).

Let's take a look at the first example:

```csharp
var db = new Database("<connection string>", "<provider invariant name>");
SqlSet<Product> products = db.From<Product>("Products");
```

To get an instance call the [Database.From][2] method specifying the table name and the type you want to map to.

AsEnumerable, ToArray, ToList
-----------------------------
```csharp
IEnumerable<Product> r1 = products.AsEnumerable();
Product[] r2 = products.ToArray();
List<Product> r3 = products.ToList();
```

Because SqlSet is a *connected* query, you can directly call methods like [AsEnumerable][3], [ToArray][4] or [ToList][5] to get back results. Note that in the above code only two queries are executed, because AsEnumerable is deferred-executed.

First, FirstOrDefault, Single, SingleOrDefault
----------------------------------------------
```csharp
Product p1 = products.First();
Product p2 = products.FirstOrDefault();
Product p3 = products.Single();
Product p4 = products.SingleOrDefault();
```

Call these methods to get a single result. If you know LINQ you should know the difference between them :)

All, Any
--------
```csharp
bool haveProducts = products.Any();
bool allHavePrice = products.All("NOT UnitPrice IS NULL");
```

...which executes:

```sql
SELECT (CASE WHEN EXISTS (
   SELECT * 
   FROM Products) THEN 1 ELSE 0 END)

SELECT (CASE WHEN EXISTS (
   SELECT *
   FROM Products
   WHERE NOT (NOT UnitPrice IS NULL)) THEN 1 ELSE 0 END)
```

Count, LongCount
----------------
```csharp
int count1 = products.Count();
long count2 = products.LongCount();
```

Both execute the same query:

```sql
SELECT COUNT(*) FROM Products

SELECT COUNT(*) FROM Products
```

Where, OrderBy, Skip, Take, Select
----------------------------------
These methods return a new SqlSet instance. Unlike [SqlBuilder][6], SqlSet is **immutable**. Also unlike SqlBuilder, you can call methods in any order. For example:

```csharp
Product[] topFiveWithLeastStock = products
   .OrderBy("UnitsInStock")
   .Take(5)
   .ToArray();
```

...which executes:

<figure class="code">
<ul id="output1">
	<li><a data-tabby-default href="#output1-1">Default</a></li>
	<li><a href="#output1-2">SQL Server</a></li>
</ul>
<div id="output1-1" markdown="1">

```sql
SELECT *
FROM Products
ORDER BY UnitsInStock
LIMIT @p0
-- @p0: Input Int32 (Size = 0) [5]
-- [-1] records affected.
```

</div>
<div id="output1-2" markdown="1">

```sql
SELECT TOP(@p0) * 
FROM Products
ORDER BY UnitsInStock
-- @p0: Input Int32 (Size = 0) [5]
-- [-1] records affected.
```

</div>
<script>new Tabby('#output1');</script>
</figure>

...but if we call Take first and then OrderBy:

```csharp
Product[] firstFiveOrderedByStock = products
   .Take(5) 
   .OrderBy("UnitsInStock")
   .ToArray();
```

...it executes:

<figure class="code">
<ul id="output2">
	<li><a data-tabby-default href="#output2-1">Default</a></li>
	<li><a href="#output2-2">SQL Server</a></li>
</ul>
<div id="output2-1" markdown="1">

```sql
SELECT *
FROM (
   SELECT *
   FROM Products
   LIMIT @p0) dbex_set3
ORDER BY UnitsInStock
-- @p0: Input Int32 (Size = 0) [5]
-- [-1] records affected.
```

</div>
<div id="output2-2" markdown="1">

```sql
SELECT *
FROM (
   SELECT TOP(@p0) *
   FROM Products) dbex_set4
ORDER BY UnitsInStock
OFFSET 0 ROWS
-- @p0: Input Int32 (Size = 0) [5]
-- [-1] records affected.
```

</div>
<script>new Tabby('#output2');</script>
</figure>

Again, if you know LINQ this shouldn't come as a surprise.

For more about Select, see [Projections](#projections).

SqlSet vs. SqlSet&lt;TResult>
-----------------------------
So far we've been using the generic [SqlSet&lt;TResult>][7]. There is also a non-generic [SqlSet][1] (inherited by SqlSet&lt;TResult>) which is useful when you don't know the type you are mapping to until runtime.

```csharp
SqlSet<Product> products1 = db.From<Product>("Products");
SqlSet products2 = db.From("Products", typeof(Product));
```

A SqlSet can be promoted to a SqlSql&lt;TResult> using the [Cast][8] method:

```csharp
// The type parameter must be the same type used when products2 was created
SqlSet<Product> products3 = products2.Cast<Product>();
```

Typed vs. Untyped
-----------------
You can also completely omit the result type:

```csharp
// Untyped set
SqlSet products = db.From("Products");
```

When you execute queries with an untyped set you get *dynamic* objects:

```csharp
dynamic p1 = products.First();
string name = p1.ProductName;
```

Untyped sets are also useful when you don't need to execute and just want to build a query and get back a SqlBuilder representation of it.

```csharp
SqlBuilder query = products.GetDefiningQuery();
```

Again, you can promote an untyped set to a typed set using the Cast method.

Projections
-----------
To change the result type of a set you must call the Select method.

```csharp
SqlSet<Product> products = db.From<Product>("Products");
SqlSet<ProductStock> productStocks = products.Select<ProductStock>("ProductID, ProductName, UnitsInStock");
```

<div class="note danger" markdown="1">

###### Warning
It's not recommended to project onto an [annotated][13] entity type. Updating a partially loaded entity may cause data loss.

</div>

You can also provide a custom mapping function:

```csharp
SqlSet<string> productNames = products.Select("ProductName", r => r.GetString(0));
```

The function takes a [DbDataReader][9] and can return anything you want, which means you can also use SqlSet for simple values like `string` or `int`.

If you provide no result type or mapping function it turns into an untyped set.

```csharp
SqlSet productNames = products.Select("ProductName");
```

Complex queries
---------------
SqlSet doesn't support joins or grouping. After all, the goal is not to completely abstract the SQL language, but to provide a simple API for the most common queries. For complex queries use SqlBuilder instead, then you can pass the query to the From method and continue building using SqlSet:

```csharp
public IEnumerable<Product> GetProductsByCategory(int categoryId, int skip = 0, int take = 20) {

   var query = SQL
      .SELECT("p.ProductID, p.ProductName, p.CategoryID")
      ._("c.CategoryID AS Category$CategoryID, c.CategoryName AS Category$CategoryName")
      .FROM("Products p")
      .LEFT_JOIN("Categories c ON p.CategoryID = c.CategoryID");

   return this.db
      .From<Product>(query)
      .Where($"CategoryID = {categoryId}")
      .OrderBy("ProductID DESC")
      .Skip(skip)
      .Take(take)
      .AsEnumerable();
}
```

...which executes:

<figure class="code">
<ul id="output3">
	<li><a data-tabby-default href="#output3-1">Default</a></li>
	<li><a href="#output3-2">SQL Server</a></li>
</ul>
<div id="output3-1" markdown="1">

```sql
SELECT *
FROM (
   SELECT p.ProductID, p.ProductName, p.CategoryID, c.CategoryID AS Category$CategoryID, c.CategoryName AS Category$CategoryName
   FROM Products p
   LEFT JOIN Categories c ON p.CategoryID = c.CategoryID) dbex_set5
WHERE CategoryID = @p0
ORDER BY ProductID DESC
LIMIT @p1
OFFSET @p2
-- @p0: Input Int32 (Size = 0) [1]
-- @p1: Input Int32 (Size = 0) [20]
-- @p2: Input Int32 (Size = 0) [0]
-- [-1] records affected.
```

</div>
<div id="output3-2" markdown="1">

```sql
SELECT *
FROM (
   SELECT p.ProductID, p.ProductName, p.CategoryID, c.CategoryID AS Category$CategoryID, c.CategoryName AS Category$CategoryName
   FROM Products p
   LEFT JOIN Categories c ON p.CategoryID = c.CategoryID) dbex_set6
WHERE CategoryID = @p0
ORDER BY ProductID DESC
OFFSET @p1 ROWS
FETCH NEXT @p2 ROWS ONLY
-- @p0: Input Int32 (Size = 0) [1]
-- @p1: Input Int32 (Size = 0) [0]
-- @p2: Input Int32 (Size = 0) [20]
-- [-1] records affected.
```

</div>
<script>new Tabby('#output3');</script>
</figure>

Include
-------
The previous example used [query mapping][10] syntax to eagerly-load the Category for each Product. The same can be acomplished using the [Include][11] method:

```csharp
public IEnumerable<Product> GetProductsByCategory(int categoryId, int skip = 0, int take = 20) {

   return this.db
      .Table<Product>()
      .Include("Category")
      .Where($"CategoryID = {categoryId}")
      .OrderBy("ProductID DESC")
      .Skip(skip)
      .Take(take)
      .AsEnumerable();
}
```

...which executes:

<figure class="code">
<ul id="output4">
	<li><a data-tabby-default href="#output4-1">MySQL</a></li>
	<li><a href="#output4-2">SQL Server</a></li>
</ul>
<div id="output4-1" markdown="1">

```sql
SELECT *
FROM (
   SELECT `dbex_l`.*, `dbex_r1`.`CategoryID` AS Category$CategoryID, `dbex_r1`.`CategoryName` AS Category$CategoryName, `dbex_r1`.`Description` AS Category$Description, `dbex_r1`.`Picture` AS Category$Picture
   FROM (
      SELECT `ProductID`, `ProductName`, `SupplierID`, `CategoryID`, `QuantityPerUnit`, `UnitPrice`, `UnitsInStock`, `UnitsOnOrder`, `ReorderLevel`, `Discontinued`
      FROM `Products`) `dbex_l`
   LEFT JOIN `Categories` `dbex_r1` ON (`dbex_l`.`CategoryID` = `dbex_r1`.`CategoryID`)) dbex_set6
WHERE CategoryID = @p0
ORDER BY ProductID DESC
LIMIT @p1
OFFSET @p2
-- @p0: Input Int32 (Size = 0) [1]
-- @p1: Input Int32 (Size = 0) [20]
-- @p2: Input Int32 (Size = 0) [0]
-- [-1] records affected.
```

</div>
<div id="output4-2" markdown="1">

```sql
SELECT *
FROM (
   SELECT [dbex_l].*, [dbex_r1].[CategoryID] AS Category$CategoryID, [dbex_r1].[CategoryName] AS Category$CategoryName, [dbex_r1].[Description] AS Category$Description, [dbex_r1].[Picture] AS Category$Picture
   FROM (
      SELECT [ProductID], [ProductName], [SupplierID], [CategoryID], [QuantityPerUnit], [UnitPrice], [UnitsInStock], [UnitsOnOrder], [ReorderLevel], [Discontinued]
      FROM [Products]) [dbex_l]
   LEFT JOIN [Categories] [dbex_r1] ON ([dbex_l].[CategoryID] = [dbex_r1].[CategoryID])) dbex_set6
WHERE CategoryID = @p0
ORDER BY ProductID DESC
OFFSET @p1 ROWS
FETCH NEXT @p2 ROWS ONLY
-- @p0: Input Int32 (Size = 0) [1]
-- @p1: Input Int32 (Size = 0) [0]
-- @p2: Input Int32 (Size = 0) [20]
-- [-1] records affected.
```

</div>
<script>new Tabby('#output4');</script>
</figure>



Note that I called the [Database.Table][12] method instead of Database.From. Although using Database.From would also work, with Database.Table you don't need to specify the table name. Both Database.Table and Include only work for [annotated types][13].

Include can be called many times:

```csharp
return this.db
   .Table<Product>()
   .Include("Category")
   .Include("Supplier")
   .AsEnumerable();
```

And you can use a deep path:

```csharp
return this.db
   .Table<EmployeeTerritory>()
   .Include("Territory.Region")
   .AsEnumerable();
```

And load one-to-many associations:

```csharp
return this.db
   .Table<Order>()
   .Include("OrderDetails.Product")
   .AsEnumerable();
```

Find
----
Find is another method that only works for annotated types. You can use it to get a single result (or null) that matches the given primary key value.

```csharp
Order order = db
   .Table<Order>()
   .Include("OrderDetails.Product")
   .Find(orderId);
```

Conclusions
-----------
Having the power to write your own SQL is great. Not having to write the same simple queries over and over is even better. SqlSet helps you compose and reuse SQL in a database independent way. While SqlBuilder is meant for private use, SqlSet can be shared, allowing the caller to further refine the query. LINQ lovers should feel right at home with SqlSet.

[1]: api/DbExtensions/SqlSet/README.md
[2]: api/DbExtensions/Database/From__1.md
[3]: api/DbExtensions/SqlSet/AsEnumerable.md
[4]: api/DbExtensions/SqlSet/ToArray.md
[5]: api/DbExtensions/SqlSet/ToList.md
[6]: SqlBuilder.md
[7]: api/DbExtensions/SqlSet_1/README.md
[8]: api/DbExtensions/SqlSet/Cast__1.md
[9]: https://learn.microsoft.com/en-us/dotnet/api/system.data.common.dbdatareader
[10]: query-mapping.md
[11]: api/DbExtensions/SqlSet/Include.md
[12]: api/DbExtensions/Database/Table__1.md
[13]: annotations.md
