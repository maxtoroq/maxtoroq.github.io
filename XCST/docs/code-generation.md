---
title: Code Generation
---
XCST does not distribute an executable, you have to use the API. This means you have to include some boilerplate code in your project, but you also get more power to customize code generation to your needs.

## MSBuild

Download the [xcst-codegen](https://github.com/maxtoroq/XCST-a/tree/master/samples/xcst-codegen) sample project to get started. There's one change you need to make to the project: if you are working with ASP.NET, change the `Xcst.AspNet.Extension` project reference to a NuGet reference of `Xcst.AspNet.Extension`; otherwise, remove the reference.

Open your project file and import `xcst-codegen.targets`:

```xml
<Import Project="..\xcst-codegen\xcst-codegen.targets" />
```

When you build your project a `xcst.generated.cs` file will be generated. This file will include the code for all packages located in any subdirectory starting from the project directory.

Lastly, make sure your project references the `Xcst.Runtime` NuGet package.
