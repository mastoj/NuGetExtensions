function Install-NuGetPackagesForSolution() 
{ 
    write-host "Installing packages for the following projects:" 
    $projects = get-project -all 
    $projects 
    
    foreach($project in $projects) 
    { 
        Install-NuGetPackagesForProjectByProject($project) 
    }

}

function Install-NuGetPackagesForProject($projectName)
{
    $project = Get-MSBuildProject $projectName
    InInstall-NuGetPackagesForProjectByProject($project)
}

function Install-NuGetPackagesForProjectByProject($project) 
{ 
    if ($project -eq $null) 
    { 
        write-host "Project is required." 
        return 
    }

    $projectName = $project.ProjectName; 
    write-host "Checking packages for project $projectName" 
    write-host "" 
    
    $projectPath = $project.FullName 
    $projectPath 
    
    $dir = [System.IO.Path]::GetDirectoryName($projectPath) 
    $packagesConfigFileName = [System.IO.Path]::Combine($dir, "packages.config") 
    $hasPackagesConfig = [System.IO.File]::Exists($packagesConfigFileName) 
    
    if ($hasPackagesConfig -eq $true) 
    { 
        write-host "Installing packages for $projectName using $packagesConfigFileName." 
        nuget i $packagesConfigFileName -o ./packages 
    }
}

Register-TabExpansion "Install-NuGetPackagesForProject" @{
    "projectName" = { Get-Project -All | Select -ExpandProperty Name}
}

Export-ModuleMember Install-NuGetPackagesForProject, Install-NuGetPackagesForSolution