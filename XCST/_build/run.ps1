$ErrorActionPreference = "Stop"
Push-Location (Split-Path $script:MyInvocation.MyCommand.Path)

try {

   java -cp \lib\saxonhe\j\9.8.0.3\saxon9he.jar net.sf.saxon.Transform -it:main -xsl:xcst-ref.xsl

} finally {
   Pop-Location
}