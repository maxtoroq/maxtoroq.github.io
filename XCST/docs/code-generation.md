---
title: Code Generation
---
XCST does not distribute an executable, you have to use the API. This means you have to include some boilerplate code in your project, but you also get more power to customize code generation to your needs.

## MSBuild

Download the [xcst-codegen](https://github.com/maxtoroq/XCST-a/tree/master/samples/xcst-codegen) sample project to get started. There's one change you need to make to the project: if you are working with ASP.NET, change the `Xcst.AspNet.Extension` project reference to a NuGet reference of `Xcst.AspNet.Extension`; otherwise, remove the reference.

Generating code for your C# project can done in a pre-build event. Add the following to your project file (`.csproj`):

<figure class="code">
<ul id="output1">
	<li><a data-tabby-default href="#output1-1">SDK-style projects</a></li>
	<li><a href="#output1-2">Classic projects</a></li>
</ul>
<div id="output1-1" markdown="1">
  
  ```xml
<Target Name="PreBuild" BeforeTargets="PreBuildEvent" DependsOnTargets="ResolveReferences">
  <Exec Command="$(ProjectDir)\..\xcst-codegen\bin\$(Configuration)\xcst-codegen.exe $(ProjectPath) $(Configuration) -LibsAndPages" />
  <ItemGroup>
    <Compile Remove="xcst.generated.cs" />
    <Compile Include="xcst.generated.cs" />
  </ItemGroup>
</Target>
```

</div>
<div id="output1-2" markdown="1">

```xml
<PropertyGroup>
  <PreBuildEventDependsOn>ResolveReferences</PreBuildEventDependsOn>
  <PreBuildEvent>$(ProjectDir)\..\xcst-codegen\bin\$(ConfigurationName)\xcst-codegen.exe $(ProjectPath) $(ConfigurationName) -LibsAndPages</PreBuildEvent>
</PropertyGroup>
```

</div>
<script>new Tabby('#output1');</script>
</figure>

Note the `-LibsAndPages` flag, this is only relevant in ASP.NET; otherwise, remove it.

When you build your project a `xcst.generated.cs` file will be generated. This file will include the code for all packages located in any subdirectory starting from the project directory.

Next, add `xcst.generated.cs` to your project. Note that, because we are using a pre-build event, this file does not need to exist when you build and generate code for the first time.

Lastly, make sure your project references the `Xcst.Runtime` NuGet package.
