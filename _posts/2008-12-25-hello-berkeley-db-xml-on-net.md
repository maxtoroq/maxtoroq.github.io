---
title: Hello Berkeley DB XML on .NET
date: 2008-12-25 02:39:00 -0300
originally_published_at: http://maxtoroq.wordpress.com/2008/12/25/hello-berkeley-db-xml-on-net/
comments: off
---

If you're not familiar with [Berkeley DB XML][1] (BDB XML), it is an open source embeddable XML database engine that provides support for XQuery access.

The official BDB XML distribution provides the library in the C++, Java, Perl, Python, PHP, and Tcl languages. Sadly, no .NET version.

I tried to look for a third-party .NET library and found [this one][2] from Parthenon Computing. The problem with this product is that it doesn’t seem up-to-date with .NET 2.0 and the most recent versions of BDB XML. Also it's free only for non-commercial use.

Since I couldn’t find any other .NET libraries I started to think what I could do with the existing ones, and it occurred to me I could cross-compile the Java version using [IKVM.NET][3]. Because I use IKVM all the time with [Saxon XSLT/XQuery][4] I trust and have a good opinion of this product.

Running the IKVM compiler is very simple. For this task you have to grab db.jar and dbxml.jar (available from the official BDB XML distribution) and execute this command:

```shell
ikvmc -out:dbxml_net.dll db.jar dbxml.jar
```

And that's it! You have your .NET API, officially maintained and up-to-date with the latest BDB XML release. The API will have the Java look-and-feel, camelCase for members, no properties, etc. If you can live with that then there’s no problem. Please note that I haven't tested much this library, but I suspect it shouldn't have problems, I encourage you to try it and let me know your experience.

Here's my hello-world program, it queries a container I had previously created using the dbxml command line shell:

```csharp
using System;
using com.sleepycat.db;
using com.sleepycat.dbxml;

namespace BerkeleyDB_XML1 {
   class Program {

      static void Main() {
         Console.WriteLine("Running {0}...", com.sleepycat.db.Environment.getVersionString());

         XmlManager mgr = new XmlManager();
         XmlContainer cont = mgr.openContainer(@"c:/temp/bdb-hello/hello.dbxml");

         int count = cont.getNumDocuments();

         Console.WriteLine("Number of available documents: {0}", count);

         XmlQueryContext qctx = mgr.createQueryContext(XmlQueryContext.Eager);

         XmlResults results = mgr.query(
@"for $h in collection('dbxml:c:/temp/bdb-hello/hello.dbxml')/hello
return $h", qctx);

         while (results.hasNext())
            Console.WriteLine(results.next().asString());

         cont.close();
         mgr.close();
      }
   }
}
```

[1]: http://www.oracle.com/database/berkeley-db/xml
[2]: http://www.parthcomp.com/dbxml_dotnet.html
[3]: http://ikvm.net/
[4]: http://saxon.sf.net/
