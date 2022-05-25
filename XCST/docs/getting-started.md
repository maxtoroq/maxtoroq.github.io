---
title: Getting Started
---

## Code Generation

While you can use the `Xcst.Compiler` API to generate code for your XCST packages yourself, the most common scenario is to ship compiled code and generate it as part of your build process in Visual Studio.

### MSBuild

Follow these steps to start generating code:

1. Download the [xcst-codegen](https://github.com/maxtoroq/XCST-a/tree/v2/samples/xcst-codegen) sample project and add it to your solution. There's one change you need to make to the project: if you are working with ASP.NET Core, change the `Xcst.AspNetCore.Extension` project reference to a NuGet reference of `Xcst.AspNetCore.Extension`; otherwise, remove the reference.

2. Open your project file (the project you want to generate code for) and import `xcst-codegen.targets`:

   ```xml
   <Import Project="..\xcst-codegen\xcst-codegen.targets" />
   ```

   Also, add a reference to the `Xcst.Runtime` NuGet package.

   ```xml
   <PackageReference Include="Xcst.Runtime" Version="XXX" />
   ```

When you build your project a `xcst.generated.cs` file will be generated. This file will include the code for all packages located in any subdirectory starting from the project directory.

## Execution

To execute your XCST packages install the `Xcst.Runtime` NuGet package.

### API

The API starts with the `Xcst.XcstEvaluator` class, which provides a fluent interface. See the following example and the comments for guidance:

```csharp
// pass new instance of compiled package
XcstEvaluator.Using(new FooPackage())
   
   // optionally set a package parameter
   .WithParam("a", 5)
   
   // call initial template (or CallTemplate("bar"))
   .CallInitialTemplate()
   
   // optionally set a template parameter
   .WithParam("b", 10)
   
   // specify the output destination (overloads available)
   .OutputTo(Console.Out) 
   
   // optionally override serialization parameters
   .WithParams(new OutputParameters { Indent = true }) 
   
   // execute
   .Run();
```

### Executing from XCST

If you are executing from XCST, instead of using the API you can use the [`c:invoke-package`](../c/invoke-package.html) instruction.
