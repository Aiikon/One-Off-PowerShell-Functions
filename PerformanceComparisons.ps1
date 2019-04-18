# ========================================================================
# Switch vs If ElseIf Else vs Dictionary
# ========================================================================

Write-Host -ForegroundColor Cyan "Three Item Switch"
Measure-Command {
    for ($i = 0; $i -lt 1000000; $i++)
    {
        switch ($i)
        {
            1 { 'nothing' }
            10000 { 'nothing' }
            default { 'nothing' }
        }
    }
}

Write-Host -ForegroundColor Cyan "Three Item If ElseIf Else"
Measure-Command {
    for ($i = 0; $i -lt 1000000; $i++)
    {
        if ($i -eq 1) { 'nothing' }
        elseif ($i -eq 2) { 'nothing' }
        else { 'nothing' }
    }
}

Write-Host -ForegroundColor Cyan "Ten Item Switch"
Measure-Command {
    for ($i = 0; $i -lt 1000000; $i++)
    {
        switch ($i)
        {
            1 { 'nothing' }
            1000 { 'nothing' }
            2000 { 'nothing' }
            4000 { 'nothing' }
            8000 { 'nothing' }
            20000 { 'nothing' }
            40000 { 'nothing' }
            80000 { 'nothing' }
            100000 { 'nothing' }
            default { 'nothing' }
        }
    }
}

Write-Host -ForegroundColor Cyan "Ten Item If ElseIf Else"
Measure-Command {
    for ($i = 0; $i -lt 1000000; $i++)
    {
        if ($i -eq 1) { 'nothing' }
        elseif ($i -eq 1000) { 'nothing' }
        elseif ($i -eq 2000) { 'nothing' }
        elseif ($i -eq 4000) { 'nothing' }
        elseif ($i -eq 8000) { 'nothing' }
        elseif ($i -eq 20000) { 'nothing' }
        elseif ($i -eq 40000) { 'nothing' }
        elseif ($i -eq 80000) { 'nothing' }
        elseif ($i -eq 100000) { 'nothing' }
        else { 'nothing' }
    }
}

Write-Host -ForegroundColor Cyan "Dictionary"
Measure-Command {
    $dict = @{}
    $dict.Add(1, 'nothing')
    $dict.Add(1000, 'nothing')
    $dict.Add(2000, 'nothing')
    $dict.Add(4000, 'nothing')
    $dict.Add(8000, 'nothing')
    $dict.Add(20000, 'nothing')
    $dict.Add(40000, 'nothing')
    $dict.Add(80000, 'nothing')
    $dict.Add(100000, 'nothing')
    for ($i = 0; $i -lt 1000000; $i++)
    {
        if ($dict.Contains($i)) { $dict[$i] }
        else { 'nothing' }
    }
}
