---
title: Code Generation
---

To get started with code generation [install](installing.html) the `Xcst.Compiler` NuGet package.

## MSBuild

Generating code for your C# project can done in a pre-build event. Add the following script to your project (e.g. `xcst.ps1`):

```powershell
$ErrorActionPreference = "Stop"
Push-Location (Split-Path $script:MyInvocation.MyCommand.Path)

function GeneratePackages {

   $startDirectory = Get-Item .
   $pkgFileExtension = "xcst"

   Add-Type -Path ..\..\packages\Saxon-HE.*\lib\net40\saxon9he-api.dll
   Add-Type -Path ..\..\packages\Xcst.*\lib\net45\Xcst.dll
   Add-Type -Path ..\..\packages\Xcst.Compiler.*\lib\net45\Xcst.Compiler.dll

   $compilerFactory = New-Object Xcst.Compiler.XcstCompilerFactory
   $compilerFactory.PackagesLocation = $startDirectory.FullName
   $compilerFactory.PackageFileExtension = $pkgFileExtension

   # Enable Application Extension

   Add-Type -Path ..\..\packages\Xcst.AspNet.*\lib\net45\Xcst.AspNet.dll
   $compilerFactory.EnableExtensions = $true
   [Xcst.Compiler.ApplicationExtensionConfiguration]::RegisterApplicationExtension($compilerFactory)

   foreach ($file in ls $startDirectory.FullName *.$pkgFileExtension -Recurse) {

      # Treat files starting with underscore as non-principal modules

      if ($file.Name[0] -eq '_') {
         continue
      }

      $compiler = $compilerFactory.CreateCompiler()
      $compiler.LibraryPackage = $true

      $xcstResult = $compiler.Compile((New-Object Uri $file.FullName))

      foreach ($src in $xcstResult.CompilationUnits) {
         write $src
      }
   }
}

try {

   GeneratePackages | Out-File xcst.generated.cs -Encoding utf8

} finally {
   Pop-Location
}
```

...and add the following to your project file (`.csproj`):

```xml
<PropertyGroup>
   <PreBuildEvent>powershell -NoProfile -ExecutionPolicy RemoteSigned -File $(ProjectDir)\xcst.ps1</PreBuildEvent>
</PropertyGroup>
```

When you build your project a `xcst.generated.cs` file will be generated. This file will include the code of all the library packages in any subdirectory starting from the location of the powershell script.

The last step is to add `xcst.generated.cs` to your project. Note that, because we are using a pre-build event, this file does not need to exist when you build and generate code for the first time.
