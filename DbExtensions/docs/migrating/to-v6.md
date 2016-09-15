---
title: Migrating to v6
---

**Contents**

- [Overview](#overview)
- [General features](#general-features)
- [Database](#database)
- [SqlBuilder](#sqlbuilder)
- [SqlSet](#sqlset)
- [SqlTable](#sqltable)

Overview
--------
**Less is more** is the theme for v6. No new big features were are added, and there were no rewrites of internal code, so you can consider it stable. The focus has been to maximize the longevity and reusability of the code. To this end, **some features have been removed**, although most of the breaking changes are removal of methods where an alternative exists, or removal of non-essential features.

The source code has also been re-organized so you can compile components independently.

General features
----------------

### Removed strong name

The DbExtensions assembly is no longer strong named.

### Target frameworks

v6 targets .NET 4.5, ending support for .NET 4.0. .NET Core support is coming (waiting for some missing APIs).

### Removed extension methods

Most of the extension methods are gone, except those for **IDataRecord**. v5 had a lot of duplicated APIs, e.g. `Map(this DbCommand command, ...)` and `Database.Map(...)`. Having two ways of doing the same thing is not only confusing, but also costly in terms of maintenance. Whether developing using extension methods is a good idea is also debatable. Having a centralized place where you can tweak things, e.g. configure profiling, is much better, and that is what **Database** provides.

So, if you can't find the extension method, look in Database.

### Depending on System.Data interfaces instead of System.Data.Common classes

Every reference to **DbConnection**, **DbCommand**, etc. has been replaced with **IDbConnection**, **IDbCommand**, etc.

Database
--------

### Removed named connection string support

**ConfigurationManager** is not available on .NET Core, so all dependencies on **System.Configuration** were removed. That means you can no longer use a named connection string, e.g.:

```csharp
// this doesn't work anymore
var db = new Database("name=Northwind");
```

Instead you can use a new constructor and pass in the connection string and provider invariant name. Your application can still use ConfigurationManager on .NET Full, e.g.:

```csharp
ConnectionStringSetings connSettings = ConfigurationManager.ConnectionStrings["Northwind"];

var db = new Database(connSettings.ConnectionString, connSettings.ProviderName);
```

### Removed Affect* methods

*Affect* was a weird name to begin with. The [Execute][1] method now provides the same functionality. See the table below.

v5                                                    | v6
----------------------------------------------------- | -----------------------------------------
`db.Affect(sql, 1)`                                   | `db.Execute(sql, affect: 1, exact: true)`
`db.Affect(sql, 1, AffectedRecordsPolicy.AllowLower)` | `db.Execute(sql, affect: 1)`
`db.AffectOne(sql)`                                   | `db.Execute(sql, affect: 1, exact: true)`
`db.AffectOneOrNone(sql)`                             | `db.Execute(sql, affect: 1)`
`db.Execute(sql)`                                     | `db.Execute(sql)`

`Execute` throws the new [ChangeConflictException][2] class.

### Removed dependency on DbCommandBuilder and added new configuration properties

DbExtensions relied on **DbCommandBuilder** for provider specific details, such as how to quote identifiers and what parameter prefix to use. This ensured maximum compatibility with providers. Sadly, DbCommandBuilder is not available on .NET Core. Instead, new configuration properties were added to [DatabaseConfiguration][3], with defaults for popular providers like **System.Data.SqlClient** and **MySql.Data.MySqlClient**.

SqlBuilder
----------

### Removed superfluous overloads

Most **SqlBuilder** and **SqlSet** methods had two overloads, e.g. `SELECT(string)` and `SELECT(string, params object[])`. The overloads without the `params` array were added as an optimization to avoid creating array instances when not needed. However, it added a lot of noise to the API. Also, the optimization is now done by the C# compiler, so it's not needed anymore.

### Arrays in SqlBuilder and SqlSet are no longer *special*

SqlBuilder and SqlSet would automatically expand an array value as a list of parameters, e.g. `WHERE("foo IN ({0})", (object)new[] { "a", "b", "c" })` was equivalent to `WHERE("foo IN ({0}, {1}, {2})", "a", "b", "c")`. This turned out to be problematic for a couple of reasons. First, sometimes a cast was required (like in the given example) so the array was not to be interpreted as the full `params` array. Second, if you had an array member in your model, e.g. binary columns that map to `byte[]`, then you had to workaround this feature.

In v6 you have to call [SQL.List][4] to opt-in into this feature. See the [SqlBuilder tutorial][5] for more information.

### Removed ToCommand method

Use [Database.CreateCommand(SqlBuilder)][6].

SqlSet
------

### Removed public constructors

Since extension methods were removed and every command goes through Database now, use the [From][7] and [From&lt;TResult>][8] methods to get an instance of SqlSet.

### Find and Include extension methods are now instance methods

You no longer need to import the DbExtensions namespace to call [Find][9] and [Include][10].

### Removed Oracle and SQL Server 2008 support

These added complexity and were rarely used. However, I plan on adding support for pluggable formatters to make SqlSet extensible.

SqlTable
--------

### Removed ConcurrencyConflictPolicy enumeration

And the methods that used it. Behavior depends on [DatabaseConfiguration][3] properties.

### Renamed SQL property and all SqlCommandBuilder methods

Instead having methods that looked like SqlBuilder methods, it now has methods with proper naming and casing, e.g. `table.SQL.UPDATE_SET_WHERE(entity)` becomes `table.CommandBuilder.BuildUpdateStatementForEntity(entity)`.

[1]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/Database/Execute.md
[2]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/ChangeConflictException/README.md
[3]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/DatabaseConfiguration/README.md#properties
[4]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/SQL/List_1.md
[5]: ../SqlBuilder.html#lists
[6]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/Database/CreateCommand.md
[7]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/Database/From.md
[8]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/Database/From__1.md
[9]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/SqlSet/Find.md
[10]: {{ page.repository_url }}/blob/v6/docs/api/DbExtensions/SqlSet/Include.md
