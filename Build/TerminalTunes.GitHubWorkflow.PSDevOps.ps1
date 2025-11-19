#requires -Module PSDevOps

Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow

Push-Location ($PSScriptRoot | Split-Path)
New-GitHubWorkflow -Name "Build Module" -On Push,
    PullRequest, 
    Demand -Job  TestPowerShellOnLinux, 
    TagReleaseAndPublish, BuildModule -OutputPath .\.github\workflows\TestAndPublish.yml

Pop-Location

return 

