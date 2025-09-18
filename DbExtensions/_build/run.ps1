$ErrorActionPreference = "Stop"
Push-Location (Split-Path $script:MyInvocation.MyCommand.Path)

try {

   $nuget = .\ensure-nuget.ps1

   if (-not (Test-Path Saxon-HE -PathType Container)) {
      &$nuget install Saxon-HE -Version 10.9.0 -ExcludeVersion
   }

   .\Saxon-HE\tools\Transform.exe -xsl:toc-api.xsl `
      -s:../../../DbExtensions/docs/api/_toc.xml `
      -o:../../_data/DbExtensions_api_toc_7.yml

} finally {
   Pop-Location
}
