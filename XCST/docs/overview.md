---
title: Project Overview
---

The execution of an XCST program consists of three separate processes: [code generation](code-generation.html), [compilation](compilation.html) and [evaluation](evaluation.html).

![](xcst-flow.svg)

## ASP.NET

This project provides integration with ASP.NET which includes its own build infrastructure. By using the `Xcst.AspNet` package you can simply add XCST pages to your site and the framework takes care of code generation and compilation at run-time.

For legacy projects you can use the `Xcst.Web.Mvc` package which implements an XCST view engine for ASP.NET MVC.
