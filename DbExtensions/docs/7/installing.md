---
title: Installing
---

DbExtensions' binaries are hosted on NuGet.org, see the [DbExtensions](https://www.nuget.org/packages/DbExtensions) package.

Target frameworks
-----------------
See the table below for DbExtensions' framework support.

| Version | Frameworks
| ------- | ----------
| v7.0    | .NET 8

Query Edition
-------------

[DbExtensions-QE](https://www.nuget.org/packages/DbExtensions-QE) (Query Edition) is a version of DbExtensions that excludes:

- SqlTable, SqlTable&lt;T>
- Annotations (TableAttribute, ColumnAttribute, etc.)
- SqlSet methods that depend on annotations (Contains, ContainsKey, Find, Include)
- Internal Metadata namespace

Query Edition is intended for projects where the CRUD operations are source-generated, or implemented using another ORM.
