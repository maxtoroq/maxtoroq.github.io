---
title: Querying with LINQ to SQL against the DBMS of your choice
date: 2007-07-24 19:02:25 -0400
tags: [ado.net]
originally_published_at: http://maxtoroq.wordpress.com/2007/07/24/querying-with-linq-to-sql-against-the-dbms-of-your-choice/
comments: off
---

Too bad LINQ to SQL isn't a generic ADO.NET API. Although the difficult part is SQL translation, because of the differences in syntax between DBMSs, there are other features that shouldn't cause any trouble, like object tracking and object materializing. However, if you try for instance `DataContext.Translate<T>(DbDataReader)` and pass any reader except SqlDataReader you'll get an exception.

So, what can we do besides rewriting the whole API? In my solution I take advantage of `DataContext.GetCommand(IQueryable)`, which returns a SqlCommand, then convert that command to another DbCommand, like MySqlCommand, and finally create the objects myself.

Here is an example. Notice that data shaping is supported. Proyections are not supported.

```csharp
// Since we are passing String.Empty to the base ctor Linq2Sql builds a default 
// connection string that looks like this: "Server=;Database=northwind;Integrated Security=SSPI" 
using (NorthwindDB db = new NorthwindDB()) {           

   // See the log on your Output window 
   db.Log = new DebuggerWriter();           

   // Setting our connection  
   // Because we are hiding DataContext.Connection then Linq2Sql won't use this one 
   db.Connection = new MySqlConnection("server=localhost; database=northwind; ");           

   // Disabling entity navegation, insert and updates that would use SqlConnection 
   db.ObjectTrackingEnabled = false;           

   // Immediate loading of Categories 
   var shape = new DataShape(); 
   shape.LoadWith<Product>(p => p.Category); 
   db.Shape = shape;           

   // Create our query 
   var query = from p in db.Products 
               where p.Category.CategoryName.StartsWith("B") 
               select p;           

   db.Log.WriteLine(db.Log.NewLine + "======== Connecting to SqlServer ========");           

   foreach (var p in query) { 
      db.Log.WriteLine("Product: {0}, Category: {1}", p.ProductName, p.Category.CategoryName); 
   }           

   // myQuery will now use the connection we previously set 
   var myQuery = db.TransformQuery(query);           

   db.Log.WriteLine(db.Log.NewLine + "======== Connecting to MySql ========");           

   foreach (var p in myQuery) { 
      db.Log.WriteLine("Product: {0}, Category: {1}", p.ProductName, p.Category.CategoryName); 
   } 
}
```
