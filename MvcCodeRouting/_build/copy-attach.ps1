$ErrorActionPreference = "Stop"
Push-Location (Split-Path $script:MyInvocation.MyCommand.Path)

try {

   $issues = ConvertFrom-Json (Get-Content .\codeplex-archive\issues\issues.json -Raw)

   foreach ($entry in $issues) {
      $issue = ConvertFrom-Json (Get-Content .\codeplex-archive\issues\$($entry.Id)\$($entry.Id).json -Raw)
      foreach ($attach in $issue.FileAttachments) {
         $dir = "..\issues\attachments\$($entry.Id)"
         if (-not (Test-Path $dir -PathType Container)) {
            md $dir | Out-Null
         }
         Copy-Item .\codeplex-archive\issues\$($entry.Id)\$($attach.FileId) $dir\$($attach.FileName)
      }
   }

} finally {
   Pop-Location
}
