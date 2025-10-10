---
title: SqlBuilder Tutorial
---

Overview
--------
[SqlBuilder][1] is a class designed to make dynamic SQL tasks easier. The main design goals are:

- The query should look like SQL, and all SQL queries should be possible.
- SqlBuilder is about building SQL, not getting or mapping data, so it should not be bound to any particular data-access implementation.

Let's take a look at the first example:

```csharp
var query = new SqlBuilder()
   .SELECT("*")
   .FROM("Products")
   .WHERE($"Name LIKE {"A%"}");
```

What makes SqlBuilder very easy to learn/use is that all methods take either a regular string, or an interpolated string where placeholders are used to pass in parameters. So, if you call ToString() on the first example this is what you get:

```sql
SELECT *
FROM Products
WHERE Name LIKE {0}
```

Pretty much the same. The parameter placeholder is still there but now with an index that refers to the location of the parameter in the [ParameterValues][4] collection. To turn this into a command you use the [Database][5] class:

```csharp
var db = new Database();
Console.WriteLine(db.CreateCommand(query).CommandText);
```

Outputs:

```sql
SELECT *
FROM Products
WHERE Name LIKE @p0
```

The parameter placeholder is now replaced with a parameter name, and the parameter value is included in the command.

Keeping track of the last clause
--------------------------------
SqlBuilder keeps track of the last clause to determine when to use separators like commas (', '), logical operators (' AND '), etc, when building the clause's body. This allows you to call the same method more than once:

```csharp
// SQL.SELECT is just a shortcut to new SqlBuilder().SELECT
var query = SQL
   .SELECT("ID")
   .SELECT("Name")
   .FROM("Products")
   .WHERE($"Name LIKE {"A%"}")
   .WHERE($"CategoryID = {2}"); 

Console.WriteLine(query);
```

Outputs:

```sql
SELECT ID, Name
FROM Products
WHERE Name LIKE {0} AND CategoryID = {1}
```

This is how you can dynamically construct the clause's body. This *separator* feature does not apply for all clauses. For example, calling JOIN two times will append JOIN on both calls.

To keep things DRY you can also use the [_][6] method for clause continuation:

```csharp
var query = SQL
   .SELECT("ID")
   ._("Name")
   .FROM("Products")
   .WHERE($"Name LIKE {"A%"}")
   ._($"CategoryID = {2}");
```

Dynamic SQL
-----------
So far we've only used SqlBuilder to dynamically construct queries that are static, meaning the resulting SQL will always be the same. Let's look at a real dynamic query example:

```csharp
void DynamicSql(int? categoryId, int? supplierId) { 

   var query = SQL
      .SELECT("ID, Name")
      .FROM("Products")
      .WHERE()
      ._If(categoryId.HasValue, $"CategoryID = {categoryId}")
      ._If(supplierId.HasValue, $"SupplierID = {supplierId}")
      .ORDER_BY("Name DESC"); 

   Console.WriteLine(query);
}
```

Let's call this several times with different arguments:

```csharp
DynamicSql(2, null);
DynamicSql(null, 3);
DynamicSql(2, 3);
DynamicSql(null, null);
```

Outputs:

```sql
SELECT ID, Name
FROM Products
WHERE CategoryID = {0}
ORDER BY Name DESC

SELECT ID, Name
FROM Products
WHERE SupplierID = {0}
ORDER BY Name DESC

SELECT ID, Name
FROM Products
WHERE CategoryID = {0} AND SupplierID = {1}
ORDER BY Name DESC

SELECT ID, Name
FROM Products
ORDER BY Name DESC
```

The [WHERE][7] method that takes no parameters only sets WHERE as the next clause, it does not append the clause, so when a clause continuation method is used, such as [_If][8], SqlBuilder knows which clause to use.

Sub-queries
-----------
Parameter placeholders are always used for command parameters, except when you pass another SqlBuilder instance, in which case the supplied builder's text is injected at the placeholder. This is how SqlBuilder supports sub-queries:

```csharp
var query = SQL
   .SELECT("c.CategoryName, t0.TotalProducts")
   .FROM("Categories c")
   .JOIN($"({SQL
      .SELECT("CategoryID, COUNT(*) AS TotalProducts")
      .FROM("Products")
      .GROUP_BY("CategoryID")}) t0 ON c.CategoryID = t0.CategoryID")
   .ORDER_BY("t0.TotalProducts DESC");

Console.WriteLine(query);
```

Outputs:

```sql
SELECT c.CategoryName, t0.TotalProducts
FROM Categories c
JOIN (
   SELECT CategoryID, COUNT(*) AS TotalProducts
   FROM Products
   GROUP BY CategoryID) t0 ON c.CategoryID = t0.CategoryID
ORDER BY t0.TotalProducts DESC
```

If the sub-query contains any parameter values, these are copied to the outer query. SqlBuilder doesn't keep any reference to sub-queries, all instances are completely independent and composability is achieved by copying state from one instance to the other.

Lists
-----
A very common requirement is to use a list of values as the right expression of the `IN` operator:

```csharp
var query = SQL
   .SELECT("*")
   .FROM("Products")
   .WHERE($"CategoryID IN ({new[] { 1, 2, 3 }:list})");

Console.WriteLine(query);
```

Outputs:

```sql
SELECT *
FROM Products
WHERE CategoryID IN ({0}, {1}, {2})
```

By using the `list` format string you can expand a collection of values into a list of parameters, instead of being treated as a single parameter.

Extending an existing query
---------------------------
If there's a large portion of the query that is static, there's no need to convert everything to method calls, just cast the interpolated string to SqlBuilder, or assign to a SqlBuilder variable or parameter:

```csharp
var query = (SqlBuilder)$"""
   SELECT ProductID, ProductName
   FROM Products
   WHERE CategoryID = {1}
   """;

Console.WriteLine(query);
```

Outputs:

```sql
SELECT ProductID, ProductName
FROM Products
WHERE CategoryID = {0}
```

You can continue to build the query using method calls.

Inserts, Updates, Deletes
-------------------------
There's really no limit to the kind of statements SqlBuilder can handle:

```csharp
var insert = SQL
   .INSERT_INTO("Products(ProductName, UnitPrice, CategoryID)")
   .VALUES("Chai", 15.56, 5);

var update = SQL
   .UPDATE("Products")
   .SET($"Discontinued = {true}")
   .WHERE($"ProductID = {1}");

var delete = SQL
   .DELETE_FROM("Products")
   .WHERE($"ProductID = {1}")
   .LIMIT(1);

Console.WriteLine(insert);
Console.WriteLine(update);
Console.WriteLine(delete);
```

Outputs:

```sql
INSERT INTO Products(ProductName, UnitPrice, CategoryID)
VALUES ({0}, {1}, {2})

UPDATE Products
SET Discontinued = {0}
WHERE ProductID = {1}

DELETE FROM Products
WHERE ProductID = {0}
LIMIT {1}
```

You can see here some methods where we pass parameters directly, like [VALUES][10] and [LIMIT][11]. Since it's very common to use these clauses with parameters only there are special overloads, although you can still use an interpolated string if you need to.

Extensibility
-------------
To understand how SqlBuilder can be extended let's take a look at how the SELECT clause is implemented:

```csharp
public SqlBuilder SELECT([InterpolatedStringHandlerArgument("")] ref ClauseStringHandler<SqlClause.SELECT> handler) {
   return this;
}

public SqlBuilder SELECT(string? text) {
   return AppendClause<SqlClause.SELECT>().Append(text);
}
```

As you can see implementing a clause can be as easy as writing one line of code. Alternatively, you can access the underlying [StringBuilder][12] directly to append text, through the [Buffer][13] property.

Querying with Entity Framework Core
-----------------------------------
As stated in the design goals, getting and mapping data is beyond the scope of SqlBuilder, so to get data we need a data access component. Entity Framework Core allows you to query using composite format syntax with the [FromSqlRaw][16] and [ExecuteSqlRaw][17] methods:

```csharp
readonly NorthwindContext context = new NorthwindContext();

public IEnumerable<Product> GetProducts(int? categoryId) {

   var query = SQL
      .SELECT("ProductID, ProductName, UnitPrice")
      .FROM("Products")
      .WHERE()
      ._If(categoryId.HasValue, $"CategoryID = {categoryId}")
      .ORDER_BY("ProductName");

   return this.context.Products.FromSqlRaw(query.ToString(), query.ParameterValues.ToArray());
}
```

Entity Framework maps columns to properties based on the column aliases used.

Querying with DbExtensions
--------------------------
SqlBuilder is part of the DbExtensions library, which also supports mapping based on column aliases, see [Query Mapping][19].

Conclusions
-----------
SqlBuilder helps your build dynamic SQL in a database/ORM independent way. A generic query API like LINQ works great for simple queries, but its statically-typed nature tends to become a disadvantage for complex scenarios, and is very difficult to extend. Many ORM products have their own query APIs, but using them means marrying to a particular product and more APIs to learn. To optimize queries you require complete control of the executing SQL. SqlBuilder gives you that control, freeing you from dealing with low-level objects like DbCommand and DbParameter.

[1]: api/DbExtensions/SqlBuilder/README.md
[4]: api/DbExtensions/SqlBuilder/ParameterValues.md
[5]: api/DbExtensions/Database/README.md
[6]: api/DbExtensions/SqlBuilder/_.md
[7]: api/DbExtensions/SqlBuilder/WHERE.md
[8]: api/DbExtensions/SqlBuilder/_If.md
[10]: api/DbExtensions/SqlBuilder/VALUES_1.md
[11]: api/DbExtensions/SqlBuilder/LIMIT_2.md
[12]: https://learn.microsoft.com/dotnet/api/system.text.stringbuilder
[13]: api/DbExtensions/SqlBuilder/Buffer.md
[16]: https://learn.microsoft.com/dotnet/api/microsoft.entityframeworkcore.relationalqueryableextensions.fromsqlraw?view=efcore-9.0
[17]: https://learn.microsoft.com/dotnet/api/microsoft.entityframeworkcore.relationaldatabasefacadeextensions.executesqlraw?view=efcore-9.0
[19]: query-mapping.md
