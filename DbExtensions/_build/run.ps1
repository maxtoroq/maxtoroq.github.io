$ErrorActionPreference = "Stop"
Push-Location (Split-Path $script:MyInvocation.MyCommand.Path)

try {

   java -cp \util\saxonhe\j\9.8.0.7\saxon9he.jar net.sf.saxon.Transform `
      -xsl:toc-api.xsl -s:../../../DbExtensions/docs/api/_toc.xml -o:toc-api.yml

   ((Get-Content toc-static.yml -Raw) -replace '# {{API-TOC-PLACEHOLDER}}', (Get-Content toc-api.yml -Raw)) |
      Set-Content ..\..\_data\DbExtensions_toc.yml

} finally {
   Pop-Location
}
