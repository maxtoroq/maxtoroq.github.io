---
title: LINQ to MySQL, based on Matt Warren's provider
date: 2008-10-19 18:16:39 -0400
tags: [ado.net]
originally_published_at: http://maxtoroq.wordpress.com/2008/10/19/linq-to-mysql-based-on-matt-warrens-provider/
comments: off
---

On each release Matt Warren's IQueryable provider is getting more and more interesting. On this post I'll show you how easy is to plug-in your custom QueryFormatter to start querying MySQL databases.

## Step 1: Download Matt Warren's provider
The code on this post is based on [release 11][1]. Although I cannot ensure it will work with newer releases it is always recommended that you download the latest.

## Step 2: Create a custom QueryFormatter class
The following code is a custom QueryFormatter for MySQL.

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

namespace Sample {

   internal class MySqlQueryFormatter : QueryFormatter {

      protected override Expression VisitNamedValue(NamedValueExpression value) {
         sb.Append("?" + value.Name);
         return value;
      }

      protected override Expression VisitSelect(SelectExpression select) {
         sb.Append("SELECT ");
         if (select.IsDistinct) {
            sb.Append("DISTINCT ");
         }

         if (select.Columns.Count > 0) {
            for (int i = 0, n = select.Columns.Count; i < n; i++) {
               ColumnDeclaration column = select.Columns[i];
               if (i > 0) {
                  sb.Append(", ");
               }
               ColumnExpression c = this.VisitValue(column.Expression) as ColumnExpression;
               if (!string.IsNullOrEmpty(column.Name) && (c == null || c.Name != column.Name)) {
                  sb.Append(" AS ");
                  sb.Append(column.Name);
               }
            }
         } else {
            sb.Append("NULL ");
            if (this.isNested) {
               sb.Append("AS tmp ");
            }
         }
         if (select.From != null) {
            this.AppendNewLine(Indentation.Same);
            sb.Append("FROM ");
            this.VisitSource(select.From);
         }
         if (select.Where != null) {
            this.AppendNewLine(Indentation.Same);
            sb.Append("WHERE ");
            this.VisitPredicate(select.Where);
         }
         if (select.GroupBy != null && select.GroupBy.Count > 0) {
            this.AppendNewLine(Indentation.Same);
            sb.Append("GROUP BY ");
            for (int i = 0, n = select.GroupBy.Count; i < n; i++) {
               if (i > 0) {
                  sb.Append(", ");
               }
               this.VisitValue(select.GroupBy[i]);
            }
         }
         if (select.OrderBy != null && select.OrderBy.Count > 0) {
            this.AppendNewLine(Indentation.Same);
            sb.Append("ORDER BY ");
            for (int i = 0, n = select.OrderBy.Count; i < n; i++) {
               OrderExpression exp = select.OrderBy[i];
               if (i > 0) {
                  sb.Append(", ");
               }
               this.VisitValue(exp.Expression);
               if (exp.OrderType != OrderType.Ascending) {
                  sb.Append(" DESC");
               }
            }
         }
         if (select.Take != null) {
            this.AppendNewLine(Indentation.Same);
            sb.Append("LIMIT ");
            this.Visit(select.Take);
            sb.Append(" ");
         }
         if (select.Skip != null) {
            sb.Append("OFFSET ");
            this.Visit(select.Skip);
            sb.Append(" ");
         }
         return select;
      }
   }
}
```

Try to build and you'll notice that MySqlQueryFormatter is trying to access a lot of QueryFormatter members that are private, so you'll need to make those protected.

Since all interaction with QueryFormatter is done through a single static method called Format, which creates an instance of the same type, we need to change the type of the created instance to MySqlQueryFormatter.

```csharp
// line 22, QueryFormatter.cs
QueryFormatter formatter = new MySqlQueryFormatter();
```

This is the fast way to get things working, a better approach would be to have a QueryFormatter property on DbQueryProvider.

## Step 3: Comment-out the following two lines in the DbQueryProvider.Translate method

```csharp
// line 123-124, DbQueryProvider.cs
//expression = SkipRewriter.Rewrite(expression);
//expression = OrderByRewriter.Rewrite(expression);
```

Since these calls are used to support SQL Server's complicated syntax for paging, for MySQL we don't need them.

And that's it!

[1]: http://blogs.msdn.com/mattwar/archive/2008/07/14/linq-building-an-iqueryable-provider-part-xi.aspx
