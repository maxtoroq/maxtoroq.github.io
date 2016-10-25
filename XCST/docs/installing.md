---
title: Installing
---

Package            | Description                                | Framework
------------------ | ------------------------------------------ | ---------
[Xcst][1]          | Runtime API                                | .NET 4.5
[Xcst.Compiler][2] | Compiler API. Use this package to translate your XCST programs into C# code. | .NET 4.5
[Xcst.Web][3]      | XCST pages for ASP.NET. This package provides only the most basic web functionality (e.g. Request/Response/Session ...). For new projects use the Xcst.AspNet package instead. For existing ASP.NET MVC 5 projects use the Xcst.Web.Mvc package. | .NET 4.5
[Xcst.Web.Mvc][4] \*  | XCST pages and views for ASP.NET MVC 5. Use this package for existing ASP.NET MVC projects. For new projects use the Xcst.AspNet package instead. | .NET 4.5
[Xcst.AspNet][5] \*   | XCST pages and views for ASP.NET (based on [AspNetLib][6]). | .NET 4.5

<small>* Includes the <a href="intro-for-razor-dev.html#html-helpers">application extension</a>.</small>

[1]: https://www.nuget.org/packages/Xcst
[2]: https://www.nuget.org/packages/Xcst.Compiler
[3]: https://www.nuget.org/packages/Xcst.Web
[4]: https://www.nuget.org/packages/Xcst.Web.Mvc
[5]: https://www.nuget.org/packages/Xcst.AspNet
[6]: https://github.com/maxtoroq/AspNetLib
