---
title: Code Generation
---
XCST does not distribute an executable, you have to use the API. This means you have to include some boilerplate code in your project, but you also get more power to customize code generation to your needs.

## MSBuild

Download the [xcst-codegen](https://github.com/maxtoroq/XCST-a/tree/master/samples/xcst-codegen) sample project to get started. There's one change you need to make to the project: if you are working with ASP.NET, change the `Xcst.AspNet.Extension` project reference to a NuGet reference of `Xcst.AspNet.Extension`; otherwise, remove the reference.

Generating code for your C# project can done in a pre-build event. Add the following to your project file (`.csproj`):

```xml
<PropertyGroup>
  <PreBuildEventDependsOn>ResolveReferences</PreBuildEventDependsOn>
  <PreBuildEvent>$(ProjectDir)\..\xcst-codegen\bin\$(ConfigurationName)\xcst-codegen.exe $(ProjectPath) $(ConfigurationName) -LibsAndPages</PreBuildEvent>
</PropertyGroup>
```

Note the `-LibsAndPages` flag, this is only relevant in ASP.NET; otherwise, remove it.

When you build your project a `xcst.generated.cs` file will be generated. This file will include the code for all the [named packages](..\c\package.html#dt-named-package) in any subdirectory starting from the project directory.

Next, add `xcst.generated.cs` to your project. Note that, because we are using a pre-build event, this file does not need to exist when you build and generate code for the first time.

Lastly, make sure your project references the `Xcst.Runtime` NuGet package.
