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
   $nugetPackages = Resolve-Path ..\..\packages

   # AssemblyResolve is used to enable loading **newer versions** of Xcst.Compiler's dependencies
   $onAssemblyResolve = [ResolveEventHandler] {
      param($sender, $e)
      
      $assemblyName = $e.Name.Split(',')[0]
      $assemblyPath = "$nugetPackages\$assemblyName.*\lib\net46\$assemblyName.dll"

      if ($assemblyName.StartsWith("saxon9he") -or $assemblyName.StartsWith("IKVM.")) {
         $assemblyPath = "$nugetPackages\Saxon-HE.*\lib\net40\$assemblyName.dll"
      
      } elseif ($assemblyName.StartsWith("Newtonsoft.Json")) {
         $assemblyPath = "$nugetPackages\$assemblyName.*\lib\net45\$assemblyName.dll"
      }
      
      if (-not (Test-Path $assemblyPath)) {
         return $null
      }

      return [Reflection.Assembly]::LoadFrom((Resolve-Path $assemblyPath))
   }

   [AppDomain]::CurrentDomain.add_AssemblyResolve($onAssemblyResolve)
   
   try {
      Add-Type -Path $nugetPackages\Xcst.Compiler.*\lib\net46\Xcst.Compiler.dll

      $compilerFactory = New-Object Xcst.Compiler.XcstCompilerFactory
      $compilerFactory.EnableExtensions = $true

      # Enable "application" extension
      $appExtension = [Reflection.Assembly]::LoadFrom((Resolve-Path $nugetPackages\Xcst.AspNet.Extension.*\lib\net46\Xcst.AspNet.Extension.dll))
      $compilerFactory.RegisterExtensionsForAssembly($appExtension)

      foreach ($file in ls $startDirectory.FullName *.$pkgFileExtension -Recurse) {

         # Treat files starting with underscore as non-principal modules
         if ($file.Name[0] -eq '_') {
            continue
         }

         $compiler = $compilerFactory.CreateCompiler()
         $compiler.PackagesLocation = $startDirectory.FullName
         $compiler.PackageFileExtension = $pkgFileExtension
         $compiler.NamedPackage = $true

         $xcstResult = $compiler.Compile((New-Object Uri $file.FullName))
         
         $xcstResult.CompilationUnits | %{ write $_ }
      }
   } finally {
      # Detach the event handler (not detaching can lead to stack overflow issues when closing PS)
      [AppDomain]::CurrentDomain.remove_AssemblyResolve($onAssemblyResolve)
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

When you build your project a `xcst.generated.cs` file will be generated. This file will include the code for all the [named packages](..\c\package.html#dt-named-package) in any subdirectory starting from the location of the powershell script.

Next, add `xcst.generated.cs` to your project. Note that, because we are using a pre-build event, this file does not need to exist when you build and generate code for the first time.

Lastly, make sure your project references the `Xcst.Runtime` NuGet package.
