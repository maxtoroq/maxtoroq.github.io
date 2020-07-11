---
title: Project Overview
---

XCST programs are called [packages](../c/package.html#dt-package) (not to be confused with NuGet packages). The execution of a package consists of three separate processes: **[code generation](code-generation.html)**, **compilation** and **[evaluation](evaluation.html)**.

<img src="xcst-flow.svg" style="max-width: 100%"/>

The code generation process takes an XCST package and produces C# source code. The resulting C# code consists of a single class that is a pure C# version of your XCST program.

The compilation process takes the C# source and produces a **compiled package**. This process is **not** implemented by this project, you have to invoke the C# compiler yourself, or use an IDE like Visual Studio. The C# code can be included in your existing project, see [Code Generation: MSBuild](code-generation.html#msbuild).

The evaluation process takes an instance of your compiled package and produces a result document or object.

## ASP.NET

XCST integrates with ASP.NET using a base class that provides access to HTTP objects, with properties like `Request`, `Response`, `Context`, `Session`, etc. Additionally, you can use a set of extension instructions known as [the application extension](../a/). These are based on the HTML helpers from ASP.NET MVC, and can greatly simplify the development of web forms.

You can use either run-time compilation or pre-compilation. Run-time compilation is what most developers are familiar with, and is a good choice for small to medium sized, content heavy sites. It takes advantage of ASP.NET's extensible build infrastructure.

Pre-compilation is a good choice for medium to large sized, code heavy sites, as explained on [this post](/2019/01/the-ultimate-aspnet-project.html).
