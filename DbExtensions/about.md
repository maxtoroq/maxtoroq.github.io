---
title: About DbExtensions
---

The story of DbExtensions starts with its predecesor project **DynamicSql** ([CodePlex](https://web.archive.org/web/20080304033020/www.codeplex.com/dsql)) back in 2007, which was a library for building complex SQL queries. DynamicSql had an object-oriented API that could make your code very hard to read and understand, so it quickly became evident the need for a different approach.

Soon after .NET 3.5 was released I started working on **DbExtensions** ([CodePlex](https://web.archive.org/web/20080124152637/www.codeplex.com/dbextensions)). The name of the project denoted that most of the mapping functionality was exposed as extension methods of the various *Db* classes in the System.Data.Common namespace, such as DbConnection and DbCommand. Inspired by LINQ, **SqlBuilder** was born, but in v1 it used lambda expressions instead of strings. It was a clear improvement from DynamicSql, and although lambda expressions enabled more type-safeness, it also limited the kind of expressions that were allowed, and still suffered from some readability issues.

In v2 SqlBuilder was completely rewritten to use strings and capitalized method names. The result was code that looked very close to SQL, and the possibility to express any SQL expression/query.

v3 was an API simplification release.

v4 marked the introduction of **SqlSet**, a middle-ground between LINQ and SqlBuilder. SqlSet is in my opinion this project's greatest achievement.

v5 and v6 are both API refinement releases. The codebase has been pretty much stable since v4. DbExtensions is now a mature product that fullfiled its goal to provide better APIs for dynamic SQL programming.
