---
title: Project Overview
---

The execution of an XCST program consists of three separate processes: [code generation](code-generation.html), [compilation](compilation.html) and [evaluation](evaluation.html).

![](xcst-flow.svg)

## XCST Web Pages

This project provides integration with ASP.NET which includes its own compilation infrastructure. Using the `Xcst.AspNet` package you can simply add XCST modules to your site and the framework takes care of code generation and compilation at run-time. Evaluation is triggered by visiting the URL of the page.

## XCST Views

For legacy projects you can use the `Xcst.Web.Mvc` package which implements an XCST view engine for ASP.NET MVC.
