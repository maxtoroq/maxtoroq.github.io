---
title: Installing
---
XCST is distributed as a set of NuGet packages (not to be confused with XCST packages).

Xcst package
------------
The Xcst package is the package that all other packages, directly or indirectly, depend on. It contains an API for executing pre-compiled XCST programs, as well as types that all compiled XCST programs depend on.

Uses:

- Execute pre-compiled XCST programs
- Distribute as dependency of pre-compiled XCST programs

[:package: Package][1] · [:octocat: Source][7]

Xcst.Compiler package
---------------------
The Xcst.Compiler package provides an API for translating your XCST programs into C# code.

Uses:

- Generate C# from XCST modules

[:package: Package][2] · [:octocat: Source][7]

Xcst.AspNet package
-------------------
The Xcst.AspNet package provides XCST web pages for ASP.NET. It's based on [AspNetLib][6].

Uses:

- Develop web applications with XCST pages

[:package: Package][5] · [:octocat: Source][8]

Xcst.Web.Mvc package
--------------------
The Xcst.Web.Mvc package provides XCST views for ASP.NET MVC 5.

Uses:

- Develop web applications using the MVC pattern with the XCST view engine

[:package: Package][4] · [:octocat: Source][8]

[1]: https://www.nuget.org/packages/Xcst
[2]: https://www.nuget.org/packages/Xcst.Compiler
[4]: https://www.nuget.org/packages/Xcst.Web.Mvc
[5]: https://www.nuget.org/packages/Xcst.AspNet
[6]: {{ site.github.owner_url }}/AspNetLib
[7]: {{ site.github.owner_url }}/XCST
[8]: {{ site.github.owner_url }}/XCST-a
