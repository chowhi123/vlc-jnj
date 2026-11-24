$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$outputDir = Join-Path $root 'build-win64'
$ci = Get-Content -Raw -LiteralPath (Join-Path $root 'extras/ci/gitlab-ci.yml')
if ($ci -notmatch '(?m)^\s*VLC_WIN64_IMAGE:\s*(\S+)\s*$') {
    throw 'Cannot find VLC_WIN64_IMAGE in the upstream CI configuration.'
}
$image = $Matches[1]

New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
docker run --rm --platform linux/amd64 `
    --mount "type=bind,source=$root,target=/source,readonly" `
    --mount "type=bind,source=$outputDir,target=/output" `
    $image bash /source/jnj/build-win64.sh
exit $LASTEXITCODE
