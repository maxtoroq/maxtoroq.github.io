---
title: Project Overview
---

XCST programs are called **packages** (not to be confused with NuGet packages). Packages are XML documents rooted at [`c:module`](../c/module.html) or [`c:package`](../c/package.html).

The execution of a package consists of three separate processes: **[code generation](code-generation.html)**, **compilation** and **[evaluation](evaluation.html)**.

<img src="xcst-flow.svg" style="max-width: 100%"/>

The code generation process takes an XCST package and produces C# source code. The resulting C# code consists of a single class that is a pure C# version of your XCST program.

The compilation process takes the C# source and produces a **compiled package**. This process is **not** implemented by this project, you have to invoke the C# compiler yourself, or use an IDE like Visual Studio. The C# code can be included in your existing project, see [Code Generation: MSBuild](code-generation.html#msbuild).

The evaluation process takes an instance of your compiled package and produces a result document or object.

## ASP.NET

Taking advantage of ASP.NET's extensible build infrastructure, you can use XCST for web application development. The framework takes care of code generation and compilation at run-time. Compiled packages inherit a base class that provide access to HTTP objects, with properties like `Request`, `Response`, `Context`, `Session`, etc.

Additionally, you can use a set of extension instructions known as [the application extension](../a/). These are based on the HTML helpers from ASP.NET MVC, and can greatly simplify the development of web forms.
