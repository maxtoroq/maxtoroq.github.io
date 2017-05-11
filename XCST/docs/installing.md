---
title: Installing
---
XCST is distributed as a set of NuGet packages (not to be confused with XCST packages).

Xcst package
------------
[![NuGet](https://img.shields.io/nuget/v/Xcst.svg?label=Xcst)](https://www.nuget.org/packages/Xcst)
[![GitHub](https://img.shields.io/github/stars/maxtoroq/XCST.svg?style=social&label=Star)](https://github.com/maxtoroq/XCST)

The Xcst package is the package that all other packages, directly or indirectly, depend on. It contains an API for executing pre-compiled XCST programs, as well as types that all compiled XCST programs depend on.

Uses:

- Execute pre-compiled XCST programs
- Distribute as dependency of pre-compiled XCST programs

Xcst.Compiler package
---------------------
[![NuGet](https://img.shields.io/nuget/v/Xcst.Compiler.svg?label=Xcst.Compiler)](https://www.nuget.org/packages/Xcst.Compiler)
[![GitHub](https://img.shields.io/github/stars/maxtoroq/XCST.svg?style=social&label=Star)](https://github.com/maxtoroq/XCST)

The Xcst.Compiler package provides an API for translating your XCST programs into C# code.

Uses:

- Generate C# from XCST modules

Xcst.AspNet package
-------------------
[![NuGet](https://img.shields.io/nuget/v/Xcst.AspNet.svg?label=Xcst.AspNet)](https://www.nuget.org/packages/Xcst.AspNet)
[![GitHub](https://img.shields.io/github/stars/maxtoroq/XCST-a.svg?style=social&label=Star)](https://github.com/maxtoroq/XCST-a)

The Xcst.AspNet package provides XCST web pages for ASP.NET.

Uses:

- Develop web applications with XCST pages

Xcst.Web.Mvc package
--------------------
[![NuGet](https://img.shields.io/nuget/v/Xcst.Web.Mvc.svg?label=Xcst.Web.Mvc)](https://www.nuget.org/packages/Xcst.Web.Mvc)
[![GitHub](https://img.shields.io/github/stars/maxtoroq/XCST-a.svg?style=social&label=Star)](https://github.com/maxtoroq/XCST-a)

The Xcst.Web.Mvc package provides XCST views for ASP.NET MVC 5.

Uses:

- Develop web applications using the MVC pattern with the XCST view engine
