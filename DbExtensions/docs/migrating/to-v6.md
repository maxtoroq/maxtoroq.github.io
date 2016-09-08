---
title: Migrating to v6
---

**Less is more** is the theme for v6. No new big features are added, and there are no rewrites of internal code, so you can consider it stable. The focus has been to maximize the longevity and reusability of the code. To this end, **some features have been removed**, although most of the breaking changes are removal of methods where an alternative exists, or removal of non-essential features.

Some of the breaking changes are to ensure compatibility with .NET Core. Everything except `SqlTable` will be usable on .NET Core. `SqlTable` depends on `System.Data.Linq.Mapping` which is not available on .NET Core, so either a fork/port is required, or using/developing a new mapping library.

The source code has also been re-organized so you can compile components independently.

Removed extension methods
-------------------------
Most of the extension methods are gone, except those for `IDataRecord`. v5 had a lot of duplicated APIs, e.g. `Map(this DbConnection connection, ...)` and `Database.Map(...)`. Having two ways of doing the same thing is not only confusing, but also costly in terms of maintenance. Whether developing using extension methods is a good idea is also debatable. Having a centralized place where you can tweak things, e.g. configure profiling, is much better, and that is what `Database` provides.

So, if you can't find the extension method, look in `Database`.

Removed superfluous overloads
-----------------------------
Most `SqlBuilder` and `SqlSet` methods had two overloads, e.g. `SELECT(string)` and `SELECT(string, params object[])`. The overloads without the `params` array were added as an optimization, to avoid creating array instances when not needed. However, it added a lot of noise to the API. Also, the optimization is now done by the C# compiler, so it's not needed anymore.

Arrays in SqlBuilder and SqlSet are no longer *special*
-----------------------------------------------------------
`SqlBuilder` and `SqlSet` would automatically expand an array value as a list of parameters, e.g. `WHERE("foo IN ({0})", (object)new[] { "a", "b", "c" })` was equivalent to `WHERE("foo IN ({0}, {1}, {2})", "a", "b", "c")`. This turned out to be problematic for a couple of reasons. First, sometimes a cast was required (like in the given example) so the array was not to be interpreted as the full `params` array. Second, if you had array member in your models, e.g. binary columns that map to `byte[]`, then you had to workaround this feature.

In v6 you have to call [SQL.List][1] to opt-in into this feature. See the [SqlBuilder tutorial][2] for more information.

[1]: {{ page.repository_url }}/blob/master/docs/api/DbExtensions/SQL/List_1.md
[2]: ../SqlBuilder.html#lists
