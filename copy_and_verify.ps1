<#
================================================================================

    Projeto:      Script de Cópia e Verificação de Arquivos com PowerShell
    Descrição:    Automatiza a cópia de arquivos de múltiplos diretórios para
                  uma única pasta de destino, verificando integridade por hash
                  e exibindo progresso detalhado com estimativa de tempo.

    --------------------------------------------------------------------------------
    Autor:        Guilherme Veras (github.com/guilhermeveras)
    Data:         2025-05-21
    Versão:       1.0.0
    Licença:      MIT License

    --------------------------------------------------------------------------------
    
    Requisitos:   PowerShell 5.1 ou superior
    Testado em:   Windows 10, Windows Server 2019

================================================================================
#>

# Defina os caminhos de origem e destino
$sourcePath = "D:\OneDriveBkp\OneDrive\Imagens"           # Caminho da pasta de origem
$destinationPath = "D:\ImagesBackup"     # Caminho da pasta de destino

# Crie a pasta de destino se não existir
if (!(Test-Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

# Obtenha todos os arquivos da origem (recursivamente)
$files = Get-ChildItem -Path $sourcePath -Recurse -File

$totalFiles = $files.Count          # Total de arquivos a copiar
$copiedFiles = 0                    # Contador de arquivos copiados
$verifiedFiles = 0                  # Contador de arquivos verificados com sucesso
$errorFiles = 0                     # Contador de arquivos com erro
$errors = @()                       # Lista de erros

$startTime = Get-Date               # Hora de início

# Função para gerar nome único se houver conflito
function Get-UniqueFileName($destFolder, $fileName) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $ext = [System.IO.Path]::GetExtension($fileName)
    $i = 1
    $newName = $fileName
    while (Test-Path (Join-Path $destFolder $newName)) {
        $newName = "${baseName}_$i$ext"
        $i++
    }
    return $newName
}

# Função para calcular o hash SHA256 de um arquivo
function Get-FileHashSHA256($filePath) {
    return (Get-FileHash -Path $filePath -Algorithm SHA256).Hash
}

Write-Host "Iniciando copia de $totalFiles arquivos..." -ForegroundColor Cyan

foreach ($file in $files) {
    $fileStopwatch = [System.Diagnostics.Stopwatch]::StartNew() # Cronômetro por arquivo
    try {
        # Defina o nome do arquivo de destino (evitando sobrescrita)
        $destFileName = Get-UniqueFileName $destinationPath $file.Name
        $destFilePath = Join-Path $destinationPath $destFileName

        # Copie o arquivo
        Copy-Item -Path $file.FullName -Destination $destFilePath -ErrorAction Stop

        $copiedFiles++

        # Calcule e compare os hashes SHA256
        $srcHash = Get-FileHashSHA256 $file.FullName
        $dstHash = Get-FileHashSHA256 $destFilePath

        if ($srcHash -eq $dstHash) {
            $verifiedFiles++
        } else {
            # Hash diferente: apague o arquivo copiado e registre o erro
            Remove-Item $destFilePath -ErrorAction SilentlyContinue
            $errorFiles++
            $errors += "Hash mismatch: $($file.FullName) -> $destFilePath"
        }
    } catch {
        # Em caso de erro, registre e continue
        $errorFiles++
        $errors += "Erro ao copiar/verificar: $($file.FullName) - $($_.Exception.Message)"
    }

    $fileStopwatch.Stop()

    # Progresso e estimativa de tempo
    $elapsed = (Get-Date) - $startTime
    $avgTime = if ($copiedFiles -gt 0) { $elapsed.TotalSeconds / $copiedFiles } else { 0 }
    $remaining = $totalFiles - $copiedFiles
    $estRemaining = [TimeSpan]::FromSeconds($avgTime * $remaining)

    Write-Host ("[{0}/{1}] Copiado: {2} | Tempo: {3:hh\:mm\:ss} | Estimado restante: {4:hh\:mm\:ss}" -f `
        $copiedFiles, $totalFiles, $file.Name, $elapsed, $estRemaining) -ForegroundColor Yellow
}

$totalTime = (Get-Date) - $startTime

# Resumo final
Write-Host "Resumo Final:" -ForegroundColor Green
Write-Host "Arquivos copiados: $copiedFiles"
Write-Host "Arquivos verificados com sucesso: $verifiedFiles"
Write-Host "Arquivos com erro: $errorFiles"
Write-Host "Tempo total gasto: $($totalTime.ToString("hh\:mm\:ss"))"

if ($errors.Count -gt 0) {
    Write-Host "Erros encontrados:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Red }
}

Write-Host "Processo concluido." -ForegroundColor Cyan

# Fim do script
