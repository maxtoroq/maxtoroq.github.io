---
title: Migrating to v7
---

Overview
--------
DbExtensions v7 builds on the success of v6 by providing better performance and an optimized overall experience for .NET (Core) and C#.

General features
----------------

### Target frameworks

v7 targets .NET 8, ending support for .NET Framework and .NET Standard.

### Depending on System.Data.Common classes instead of System.Data interfaces

Every reference to IDbConnection, IDbCommand, etc. has been replaced with DbConnection, DbCommand, etc. Interfaces don't have all the features that DbExtensions now need, like async methods or the DbDataReader.GetFieldValue method.

String Interpolation
--------------------
<div class="note" markdown="1">

###### Language support
At the time of first release of v7, F# and Visual Basic don't implement the string interpolation handler pattern, which means you cannot use v7 with these languages.

</div>

Historically, DbExtensions has extensively used composite formatting as part of main APIs in types like SqlBuilder, SqlSet, and other methods like Database.Execute. v7 finally makes the switch to string interpolation for better performance and code aesthetics. Every method that in v6 accepted a string and a params array, now accepts a type that implements the string interpolation handler pattern (the type will vary depending on the declaring type and/or specific method). An overload that accepts a string is also provided so you are not forced to use an interpolated string if you don't need to. For example, in SqlBuilder:

| v6                       | v7
| ------------------------ | -----------
| SELECT(string, object[]) | SELECT(ref ClauseStringHandler&lt;SELECT>)<br/>SELECT(string)

Usage example:

| v6                                    | v7
| ------------------------------------- | -----------
| `SELECT("UnitPrice * {0}", discount)` | `SELECT($"UnitPrice * {discount}")`

Any query that previously used string interpolation to inject things like table aliases or other non-parameter part must be updated, otherwise it will be treated as a parameter. You can use the `sql` format string:

| v6                             | v7
| ------------------------------ | -----------
| `SELECT($"{alias}.UnitPrice")` | `SELECT($"{alias:sql}.UnitPrice")`

Another format string supported is `list`, use it instead of SQL.List:

| v6                                            | v7
| --------------------------------------------- | -----------
| `WHERE("CategoryId IN ({0})", SQL.List(ids))` | `WHERE($"CategoryId IN ({ids:list})")`

### Conditional Appends

One consequence of using the string interpolation handler pattern is that you cannot conditionally concatenate strings and have those strings handled by the handler. For example, in v6:

```csharp
// This is a v6 example
query.WHERE("(Foo = {0}" + (someCondition ? " OR Bar = {1})" : ")"), foo, bar);
```

Trying to make the above code work in v7 would result in the compiler choosing the string overload of the WHERE method, which leads to SQL injection of *foo* and *bar*.

In v7 you can use the new AppendIf/AppendElseIf/AppendElse methods:

```csharp
query.WHERE($"(Foo = {foo}")
   .AppendIf(someCondition, $"OR Bar = {bar}")
   .Append(")");
```

These conditional methods don't have overloads that accept string, you must use an interpolated string. These methods take advantage of the string interpolation handler pattern's support for conditional appends, which means any expressions inside the placeholders are never evaluated. The same is true for _If/_ElseIf/_Else. You can now write code like this:

```csharp
query.WHERE()
   ._If(cat != null, $"CategoryId = {cat.Id}");
```

Note the `cat.Id` expression doesn't need to check again if *cat* is not null. The above code would result in a NullReferenceException in v6.

### Static Queries

Internally, SqlBuilder still uses composite formatting as it makes it easy to combine and reuse queries, e.g. using a SqlBuilder instance as sub-query in another instance. When there's a large portion of a query that is static, in v6 you can pass it to the constructor:

```csharp
// This is a v6 example
var query = new SqlBuilder("""
   SELECT ProductID, ProductName
   FROM Products
   WHERE CategoryID = {0}
   """, categoryId);
```

Because of how the string interpolation handler pattern works, using a constructor to initialize the query is not practical, since you need an instance of SqlBuilder before you call the constructor. However, there's a simpler way, because SqlBuilder itself is also a string interpolation handler, so you can simply assign an interpolated string to a SqlBuilder variable:

```csharp
// This is a v7 example
SqlBuilder query = $"""
   SELECT ProductID, ProductName
   FROM Products
   WHERE CategoryID = {categoryId}
   """;
```

Any method that accepts a SqlBuilder can now be called with an interpolated string, like Database.Map or Database.Execute:

```csharp
db.Execute($"CALL myProc({foo})");
var products = db.Map($"SELECT * FROM Products", r => new { ... });
```

If you want to use the same parameter reference multiple times in the query you can use composite formatting syntax by starting your raw string with `$$` so curly braces are not interpreted as placeholders for parameters, then you manually add the parameters:

```csharp
SqlBuilder query = $$"""
   SELECT ProductID, ProductName, Price * {0}
   FROM Products
   WHERE CategoryID = {1}
   ORDER BY Price * {0}
   """;
query.ParameterValues.Add(discount);
query.ParameterValues.Add(categoryId);
```

Database
--------

### EnsureInTransaction is no longer System.Transactions aware

In v6, EnsureInTransaction uses a TransactionScope if Transaction.Current is not null. v7 only deals with ADO.NET transactions. You can override EnsureInTransaction to use TransactionScope if you need to.

### Using `SCOPE_IDENTITY()` in LastInsertIdCommand

This change makes the LastInsertId method useless when using SqlClient because of how SqlClient is implemented, `SCOPE_IDENTITY()` will always return null unless you use it in the same command after the INSERT statement. I decided I prefer to make LastInsertId unusable rather than risking returning the wrong value with `@@IDENTITY`. When using SqlClient, SqlTable uses the OUTPUT clause when doing inserts.

### Removed some CRUD shortcut methods

The following methods have been removed to declutter the API:

| Method removed            | Fix
| ------------------------- | ---------
| Contains(object)	        | `db.Table(entity.GetType()).Contains(entity)`
| ContainsKey&lt;T>(object) | `db.Table<T>().ContainsKey(id)`
| ContainsKey(Type, object) | `db.Table(typeof(MyEntity)).ContainsKey(id)`
| Find(Type, object)        | `db.Table(typeof(MyEntity)).Find(id)`
| RemoveKey(Type, object)   | `db.Table(typeof(MyEntity)).RemoveKey(id)`
| RemoveKey&lt;T>(object)   | `db.Table<T>().RemoveKey(id)`

### Signature changes

The following methods have been renamed, or their parameters' order have changed:

| v6                           | v7
| ---------------------------- | ---------
| Map(Type, SqlBuilder)        | Map(SqlBuilder, Type)
| From(SqlBuilder)             | **FromQuery**(SqlBuilder)
| From(SqlBuilder, Type)       | **FromQuery**(SqlBuilder, Type)
| From&lt;TResult>(SqlBuilder) | **FromQuery**&lt;TResult>(SqlBuilder)
| From&lt;TResult>(SqlBuilder, Func&lt;DbDataReader, TResult>) | **FromQuery**&lt;TResult>(SqlBuilder, Func&lt;DbDataReader, TResult>)

SqlBuilder
----------

### New SqlClause class for CurrentClause and NextClause

The new SqlClause class now encapsulates the clause name and separator, so the properties CurrentSeparator and NextSeparator were removed and can be replaced by `CurrentClause.Separator` and `NextClause.Separator`.

The AppendClause method has also changed to accept either a SqlClause instance or type parameter. There are subclasses of SqlClause available as nested classes for all of the clauses used by SqlBuilder.

| v6                                                  | v7
| --------------------------------------------------- | ---------
| `sql.AppendClause("WHERE", " AND ", "foo IS NULL")` | `sql.AppendClause<SqlClause.WHERE>().Append("foo IS NULL")`
| `sql.AppendToCurrentClause("foo IS NULL")`          | `sql.AppendClause<SqlClause.Current>().Append("foo IS NULL")`

### Signature changes

The following methods have been renamed, or their parameters' order have changed:

| v6                           | v7
| ---------------------------- | ---------
| Append(SqlBuilder)           | **AppendSql**(SqlBuilder)
| Insert(int, string)          | **InsertText**(int, string)
| WITH(SqlBuilder, string)     | WITH(string, SqlBuilder)
| WITH(SqlSet, string)         | WITH(string, SqlSet)

The following methods on the SQL class have also changed accordingly:

| v6                           | v7
| ---------------------------- | ---------
| WITH(SqlBuilder, string)     | WITH(string, SqlBuilder)
| WITH(SqlSet, string)         | WITH(string, SqlSet)

SqlSet
------

### Changed parameters order on Select overloads

The column list string or interpolated string handler parameter now always goes first:

| v6                                      | v7
| --------------------------------------- | -----------
| `Select(r => r.GetInt32(0), "OrderId")` | `Select("OrderId", r => r.GetInt32(0))`

Now that the params array is not needed the column list can go first as originally intended.

### Include and IncludeMany methods, with typed lambda overloads

The Include method is now used only for `*:1` associations, and IncludeMany was added for `1:N` associations. On SqlSet these methods accept string. On SqlSet&lt;T> there are overloads that accept a lambda expression.

| v6                                | v7
| --------------------------------- | -----------
| `Include("OrderDetails.Product")` | `IncludeMany("OrderDetails", set => set.Include("Product"))`

The second parameter of IncludeMany can be used to customize how the collection is loaded, like including related objects, sorting, limiting the number of objects to load, etc.

If you are loading a collection in a `*:1` association you have to first call Include to load that association. For example, in v6:

```csharp
// This is a v6 example
var set = _db.Table<EmployeeTerritory>()
   .Include("Employee.Orders");
```

In v7:

```csharp
// This is a v7 example
var set = _db.Table<EmployeeTerritory>()
   .Include(p => p.Employee)
   .IncludeMany(p => p.Employee.Orders);
```
