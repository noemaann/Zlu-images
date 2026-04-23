$files = git ls-files -o --exclude-standard images/
$batchSize = 5
$batchNum = 1

for ($i = 0; $i -lt $files.Count; $i += $batchSize) {
    if (!$batch) { continue; }
    $batch = $files | Select-Object -Skip $i -First $batchSize
    foreach ($file in $batch) {
        git add $file
    }
    git commit -m "Upload images batch $batchNum"
    Write-Host "Pushing batch $batchNum..."
    git push origin main
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Push failed on batch $batchNum"
        exit $LASTEXITCODE
    }
    $batchNum++
}
git add batch_upload.ps1
git commit -m "Add upload script"
git push origin main

Write-Host "All batches uploaded successfully!"
