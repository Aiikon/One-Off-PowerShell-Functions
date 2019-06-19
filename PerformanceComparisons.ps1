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

Write-Host -ForegroundColor Cyan "Three Item Switch w/ Break"
Measure-Command {
    for ($i = 0; $i -lt 1000000; $i++)
    {
        switch ($i)
        {
            1 { 'nothing'; break }
            10000 { 'nothing'; break }
            default { 'nothing'; break }
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

Write-Host -ForegroundColor Cyan "Ten Item Switch w/ Break"
Measure-Command {
    for ($i = 0; $i -lt 1000000; $i++)
    {
        switch ($i)
        {
            1 { 'nothing'; break }
            1000 { 'nothing'; break }
            2000 { 'nothing'; break }
            4000 { 'nothing'; break }
            8000 { 'nothing'; break }
            20000 { 'nothing'; break }
            40000 { 'nothing'; break }
            80000 { 'nothing'; break }
            100000 { 'nothing'; break }
            default { 'nothing'; break }
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


# ========================================================================
# Property Access
# ========================================================================

Write-Host -ForegroundColor Cyan "Accessing Object via Property"
Measure-Command {
    $object = [pscustomobject]$PSVersionTable
    for ($i = 0; $i -lt 1000000; $i++)
    {
        $PSVersionTable.PSVersion
    }
}


Write-Host -ForegroundColor Cyan "Accessing Object via String"
Measure-Command {
    $object = [pscustomobject]$PSVersionTable
    for ($i = 0; $i -lt 1000000; $i++)
    {
        $PSVersionTable."PSVersion"
    }
}

Write-Host -ForegroundColor Cyan "Accessing Object via Variable"
Measure-Command {
    $object = [pscustomobject]$PSVersionTable
    $propertyName = 'PSVersion'
    for ($i = 0; $i -lt 1000000; $i++)
    {
        $PSVersionTable.$propertyName
    }
}


Write-Host -ForegroundColor Cyan "Accessing Dictionary via Property"
Measure-Command {
    $object = $PSVersionTable
    for ($i = 0; $i -lt 1000000; $i++)
    {
        $PSVersionTable.PSVersion
    }
}


Write-Host -ForegroundColor Cyan "Accessing Dictionary via String"
Measure-Command {
    $object = $PSVersionTable
    for ($i = 0; $i -lt 1000000; $i++)
    {
        $PSVersionTable."PSVersion"
    }
}

Write-Host -ForegroundColor Cyan "Accessing Dictionary via Variable"
Measure-Command {
    $object = $PSVersionTable
    $propertyName = 'PSVersion'
    for ($i = 0; $i -lt 1000000; $i++)
    {
        $PSVersionTable.$propertyName
    }
}

Write-Host -ForegroundColor Cyan "Accessing Dictionary via Key String"
Measure-Command {
    $object = $PSVersionTable
    for ($i = 0; $i -lt 1000000; $i++)
    {
        $PSVersionTable['PSVersion']
    }
}

Write-Host -ForegroundColor Cyan "Accessing Dictionary via Key Variable"
Measure-Command {
    $object = $PSVersionTable
    $propertyName = 'PSVersion'
    for ($i = 0; $i -lt 1000000; $i++)
    {
        $PSVersionTable[$propertyName]
    }
}

# ========================================================================
# Creating DateTime values relative to the current date
# ========================================================================

Write-Host -ForegroundColor Cyan "From New-Object"
Measure-Command {
    for ($i = 0; $i -lt 100000; $i++)
    {
        $date = [DateTime]::Now
        New-Object DateTime $date.Year, $date.Month, $date.Day, $date.Hour, $date.Minute, $date.Second
    }
}

Write-Host -ForegroundColor Cyan "From [DateTime]::New()"
Measure-Command {
    for ($i = 0; $i -lt 100000; $i++)
    {
        $date = [DateTime]::Now
        [DateTime]::new($date.Year, $date.Month, $date.Day, $date.Hour, $date.Minute, $date.Second)
    }
}

Write-Host -ForegroundColor Cyan "From Date.AddHours.AddMinutes.AddSeconds"
Measure-Command {
    for ($i = 0; $i -lt 100000; $i++)
    {
        $date = [DateTime]::Now
        $date.Date.AddHours($date.Hour).AddMinutes($date.Minute).AddSeconds($date.Second)
    }
}


# ========================================================================
# Typecasting
# ========================================================================

Write-Host -ForegroundColor Cyan "Baseline int"
Measure-Command {
    for ($i = 0; $i -lt 100000; $i++)
    {
        $value = [int]1000
        $newValue = $value
    }
}

Write-Host -ForegroundColor Cyan "Casting int as int"
Measure-Command {
    for ($i = 0; $i -lt 100000; $i++)
    {
        $value = [int]1000
        $newValue = [int]$value
    }
}


Write-Host -ForegroundColor Cyan "Casting int as int64"
Measure-Command {
    for ($i = 0; $i -lt 100000; $i++)
    {
        $value = [int]1000
        $newValue = [int64]$value
    }
}

Write-Host -ForegroundColor Cyan "Casting int as double"
Measure-Command {
    for ($i = 0; $i -lt 100000; $i++)
    {
        $value = [int]1000
        $newValue = [double]$value
    }
}

Write-Host -ForegroundColor Cyan "Casting int as string"
Measure-Command {
    for ($i = 0; $i -lt 100000; $i++)
    {
        $value = [int]1000
        $newValue = [double]$value
    }
}
