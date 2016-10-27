---
title: Installing
---
XCST is distributed as a set of NuGet packages.

[Xcst][1] package
-----------------
The Xcst package is the package that all other packages, directly or indirectly, depend on. It contains an API for executing pre-compiled XCST programs, as well as types that all compiled XCST programs depend on.

Uses:

- Execute pre-compiled XCST programs
- Distribute as dependency of pre-compiled XCST programs

[Xcst.Compiler][2] package
--------------------------
The Xcst.Compiler package provides an API for translating your XCST programs into C# code.

Uses:

- Generate C# from XCST modules

[Xcst.AspNet][5] package \*
---------------------------
The Xcst.AspNet package provides XCST web pages for ASP.NET. It's based on [AspNetLib][6].

Uses:

- Develop web applications with XCST pages

[Xcst.Web.Mvc][4] package \*
----------------------------
The Xcst.Web.Mvc package provides XCST pages and views for ASP.NET MVC 5. If you are only interested in pages, it's recommended you use the Xcst.AspNet package instead.

Uses:

- Develop web applications with XCST pages
- Develop web applications using the MVC pattern with the XCST view engine

[Xcst.Web][3] package
---------------------
The Xcst.Web package provides basic XCST web pages for ASP.NET. This package is not usually referenced directly, but installed as a dependency on both Xcst.AspNet and Xcst.Web.Mvc, which are built on top of the functionality provided by Xcst.Web.

Uses:

- Develop web applications with XCST pages

<small>* Includes the <a href="intro-for-razor-dev.html#html-helpers">application extension</a>.</small>

[1]: https://www.nuget.org/packages/Xcst
[2]: https://www.nuget.org/packages/Xcst.Compiler
[3]: https://www.nuget.org/packages/Xcst.Web
[4]: https://www.nuget.org/packages/Xcst.Web.Mvc
[5]: https://www.nuget.org/packages/Xcst.AspNet
[6]: https://github.com/maxtoroq/AspNetLib
