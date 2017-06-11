---
title: Project Overview
---

The execution of an XCST program consists of three separate processes: code generation, compilation and evaluation.

![](xcst-flow.svg)

## Code Generation

Code generation takes an XCST source and produces C# source code. The XCST source is an XML document rooted at [`c:module`](../c/module.html) or [`c:package`](../c/package.html). The [`Xcst.Compiler`](installing.html) package implements this process. The resulting C# code consists of a single class that is a pure C# version of your XCST program.

## Compilation

Compilation takes the C# source and produces a .NET assembly. This process is **not** implemented by this project, you have to invoke the C# compiler yourself, or use an IDE like Visual Studio. The C# code can be included in your existing project. A reference to the [`Xcst`](installing.html) package is required.

This project provides integration with ASP.NET which includes its own compilation infrastructure. This means that by using the [`Xcst.AspNet`](installing.html) or [`Xcst.Web.Mvc`](installing.html) packages you can simply add XCST modules to your site and these will be compiled by the framework at run-time.

## Evaluation

Evaluation takes an instance of your compiled class and produces a result document or object. This process is implemented by the [`Xcst`](installing.html) package.
