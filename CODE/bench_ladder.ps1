# bench_ladder.ps1 - Group 21 efficiency ladder. Run from CODE\ :  .\bench_ladder.ps1
# Runs each version 5 times on stress_full.csv; reports median "Benchmark time" (load + replay).
$common = @('-f','stress','-s','0','-q','-o','bench_sig.csv')
$ladder = [ordered]@{
  'V0 -O0 naive   sscanf fixed-array' = @('.\StageC_O0', @('-n','--parser','old','--memory','fixed'))
  'V1 -O2 naive   sscanf fixed-array' = @('.\StageC_O2', @('-n','--parser','old','--memory','fixed'))
  'V2 -O3 naive   sscanf fixed-array' = @('.\StageC_O3', @('-n','--parser','old','--memory','fixed'))
  'V3 -O3 naive   fast   fixed-array' = @('.\StageC_O3', @('-n','--parser','fast','--memory','fixed'))
  'V4 -O3 running fast   fixed-array' = @('.\StageC_O3', @('--parser','fast','--memory','fixed'))
  'V5 -O3 running fast   malloc'      = @('.\StageC_O3', @('--parser','fast','--memory','malloc'))
}
New-Item -ItemType Directory -Force results | Out-Null
$log = 'results\bench_ladder.log'
'' | Set-Content $log
$base = $null
foreach ($name in $ladder.Keys) {
    $exe = $ladder[$name][0]; $extra = $ladder[$name][1]
    $times = @()
    1..5 | ForEach-Object {
        $out = & $exe @common @extra
        $out | Add-Content $log                                  # raw output kept as evidence
        $line = $out | Select-String 'Benchmark time'
        $times += [double](($line.ToString().Trim() -split '\s+')[3])
    }
    $med = ($times | Sort-Object)[2]
    if ($null -eq $base) { $base = $med }
    $msg = '{0,-36} median {1,8:N3} s   speedup vs V0 {2,6:N2}x   runs: {3}' -f $name, $med, ($base / $med), ($times -join ', ')
    $msg; $msg | Add-Content $log
}