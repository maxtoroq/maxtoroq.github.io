$ErrorActionPreference = "Stop"
Push-Location (Split-Path $script:MyInvocation.MyCommand.Path)

try {

   java -cp \util\saxonhe\j\9.8.0.7\saxon9he.jar net.sf.saxon.Transform `
      -xsl:toc-api.xsl -s:../../../DbExtensions/docs/api/_toc.xml -o:../../_data/DbExtensions_api_toc.yml

} finally {
   Pop-Location
}
