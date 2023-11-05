Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Write-Host ""
Function CalculateHash($filepath)
{
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}
Function EraseBaseline()
{
    $baselineExists = Test-Path -Path .\baseline.txt
    if($baselineExists)
    {
        Remove-Item -Path .\baseline.txt
    }
}
Write-Host "What should the File Intergrity Monitor do for you?"
Write-Host ""
Write-Host "A) Create a new baseline for the files"
Write-Host "B) Monitor the files with the existing baseline"
Write-Host ""
$response = Read-Host -Prompt "Choose option A or B"
Write-Host "You have entered $($response)"
Write-Host ""
if ($response -eq "A".ToUpper())
{
    Write-Host "Calculating SHA-512 hashes of the files and making a new baseline.txt" -ForegroundColor Cyan
    EraseBaseline
    Write-Host ""
    $files = Get-ChildItem -Path .\Files
    foreach ($i in $files)
    {
        $hash = CalculateHash $i.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }
}
elseif ($response -eq "B".ToUpper())
{
    Write-Host "Monitoring files by comparing the integrity with the exisiting baseline.txt" -ForegroundColor Cyan
    $filehashDictionary = @{}
    $filePathsandHashes = Get-Content -Path .\baseline.txt
    foreach($i in $filePathsandHashes)
    {
         $filehashDictionary.add($i.Split("|")[0],$i.Split("|")[1])
    }
    while($true)
    {
        Start-Sleep -Seconds 1
        $files = Get-ChildItem -Path .\Files
        foreach($i in $files)
        {
            $hash = CalculateHash $i.FullName
            if($filehashDictionary[$hash.Path] -eq $null)
            {
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            }
            else
            {
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash)
                {
                    # The file has not changed
                }
                else
                {
                    Write-Host "$($hash.Path) has changed!" -ForegroundColor Yellow
                }
        }
    }
    foreach ($key in $filehashDictionary.Keys)
    {
        $baselineFileStillExists = Test-Path -Path $key
        if (-Not $baselineFileStillExists) 
        {
            Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
        }
    }
   }
}
else
{
    Write-Host "You have to enter only A or B as the options" -ForegroundColor Cyan
}