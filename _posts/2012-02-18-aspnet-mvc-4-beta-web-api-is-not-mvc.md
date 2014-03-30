---
layout: post
title: "ASP.NET MVC 4 Beta: Web API is not MVC"
date: 2012-02-18 13:18:00 -0300
tags: [asp.net mvc, asp.net web api]
---

The [ASP.NET MVC 4 Beta][1] release includes a new API called [ASP.NET Web API][2]:

> ASP.NET Web API is a framework that makes it easy to build HTTP services that reach a broad range of clients, including browsers and mobile devices. ASP.NET Web API is an ideal platform for building RESTful applications on the .NET Framework.

You can find a better description on [this post][3]. In short, Web API is [WCF Web API][4] rewritten in an MVC-ish way. It takes a lot of ideas from MVC, like Controllers, Routes, Model Metatada, Model Binding, Model Validation, Value Providers, Filter Attributes, etc., and adds WCF Web API features, like [OData][5] and non-ASP.NET hosting.

The bad thing is that, even though Web API looks and feels like MVC, **it's not MVC**. All those great MVC features we all love, the Web API team decided to copy/re-implement, instead of building on top of MVC. **Web API does not depend on MVC**. It doesn't even depend on ASP.NET.

The best thing about MVC is its extensibility. Now all those great MVC extensions will have to be recompiled/adapted for Web API. This is a terrible design choice, all they had to do was provide more RESTful features directly in MVC, instead of creating the Web API beast.

**Update (2014-03)**: This was my initial reaction. I don't think it was a bad design choice anymore, as the decoupling from *System.Web* improves the portability, modularity and extensibility of the framework. Also, adapting some of my MVC libraries for Web API wasn't so hard, as many of the features that were copied from MVC work pretty much the same.

[1]: http://www.asp.net/mvc/mvc4
[2]: http://www.asp.net/web-api
[3]: http://weblogs.asp.net/jgalloway/archive/2012/02/16/asp-net-4-beta-released.aspx
[4]: http://wcf.codeplex.com/wikipage?title=WCF+HTTP
[5]: http://www.odata.org/