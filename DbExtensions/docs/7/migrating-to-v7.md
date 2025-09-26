---
title: Migrating to v7
---

Overview
--------
DbExtensions v7 builds on the success of v6 by providing better performance and an optimized overall experience for .NET (Core) and C#.

String Interpolation
--------------------
<div class="note" markdown="1">

At the time of first release of v7, F# and Visual Basic don't implement the string interpolation handler pattern, which means you cannot use v7 with these languages.

</div>

Historically, DbExtensions has extensively used composite formatting as part of main APIs in types like SqlBuilder, SqlSet, and other methods like Database.Execute. v7 finally makes the switch to string interpolation for better performance and code aesthetics. Every method that in v6 accepted a `string` and an `object[]` params array, now accepts a type that implements the string interpolation handler pattern (the type will vary depending on the declaring type and/or specific method). An overload that accepts a `string` is also provided so you are not forced to use an interpolated string if you don't need to. For example, in SqlBuilder:

| v6                         | v7
| -------------------------- | -----------
| `SELECT(string, object[])` | `SELECT(ref ClauseStringHandler&lt;SELECT> handler)`<br/>`SELECT(string)`

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

One consequence of using the string interpolation handler pattern is that you cannot conditionally concatenate strings and have those strings handled by the handler. For example:

```csharp
// This is a v6 example
query.WHERE("(Foo = {0}" + (someCondition ? " OR Bar = {1})" : ")"), foo, bar);
```

Trying to make the above code work in v7 would result in the compiler choosing the string overload of the WHERE method, which leads to SQL injection of `foo` and `bar`.

In v7, do this instead:

```csharp
query.WHERE($"(Foo = {foo}");

if (someCondition) {
   query.Append($"OR Bar = {bar})");
} else {
   query.Append(")");
}
```

... or use the new AppendIf/AppendElseIf/AppendElse methods:

```csharp
query.WHERE($"(Foo = {foo}")
   .AppendIf(someCondition, $"OR Bar = {bar})")
   .AppendElse($")");
```

Note that the AppendElse call above uses an interpolated string even though it doesn't include any parameters. These conditional methods don't have overloads that accept string, you must use an interpolated string. These methods take advantage of the string interpolation handler pattern's support for conditional appends, which means any expressions inside the placeholders are never evaluated. The same is true for _If/_ElseIf/_Else. You can now write code like this:

```csharp
query.WHERE()
   ._If(cat != null, $"CategoryId = {cat.Id}");
```

Note the `cat.Id` expression doesn't need to check again if `cat` is not null. The above code would result in a NullReferenceException in v6.
