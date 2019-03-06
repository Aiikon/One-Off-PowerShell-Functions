Function Invoke-PipelineThreading
{
    <#
    .SYNOPSIS
    Behaves similar to ForEach-Object, except it creates threads and executes
    the script in parallel. Execution is done with runspaces so variables are
    not shared by default. It's written such that you can simply replace
    "ForEach-Object" with "Invoke-PipelineThreading".

    .PARAMETER Script
    The script to execute for each object. By default one object is passed to
    this script at a time in the $_ variable, exactly like ForEach-Object.

    .PARAMETER Threads
    The number of threads to create. Defaults to 10.

    .PARAMETER ChunkSize
    The number of objects to pass to each thread. Defaults to 1. Values greater
    than 1 will pass a List (System.Collections.Generic.List[object]) object to
    the script.

    .PARAMETER StartupScript
    A script to execute once when each thread is created. Use it to import
    modules or define functions.

    .PARAMETER ImportVariables
    Variable names to import into the script session, use it to import
    configuration or credentials, or to write alternate output streams.

    .EXAMPLE
    Get-ADComputer |
        Select-Object -ExpandProperty Name |
        Invoke-PipelineThreading -Threads 30 -ShowProgress -Script {
            $temp = [ordered]@{}
            $temp.ComputerName = $_
            $temp.IsOnline = Test-Connection -ComputerName $_ -Count 1 -Quiet
            New-Object -TypeName PSCustomObject -Property $temp
        }

    #>
    Param
    (
        [Parameter(ValueFromPipeline=$true)] [object[]] $InputObject,
        [Parameter(Position=0,Mandatory=$true)] [Alias('Process')] [scriptblock] $Script,
        [Parameter()] [int] $Threads = 10,
        [Parameter()] [int] $ChunkSize = 1,
        [Parameter()] [scriptblock] $StartupScript,
        [Parameter()] [string[]] $ImportVariables,
        [Parameter()] [switch] $ShowProgress
    )
    Begin
    {
        $inputObjectList = New-Object System.Collections.Generic.List[object]
    }
    Process
    {
        foreach ($inputObjectItem in $InputObject) { $inputObjectList.Add($inputObjectItem) }
    }
    End
    {
        $hashCode = $PSCmdlet.GetHashCode()
        $inputCount = $inputObjectList.Count
        if (!$inputCount) { return }
        $finalThreadCount = [Math]::Min([Math]::Ceiling($inputCount / $ChunkSize), $Threads)
        $threadList = @(for($i = 1; $i -le $finalThreadCount; $i++)
        {
            $thread = [ordered]@{}
            $thread.PowerShell = [PowerShell]::Create()
            $thread.Invocation = $null
            $thread.ReadyToProcess = $false
            foreach ($varName in $ImportVariables)
            {
                $var = $PSCmdlet.SessionState.PSVariable.Get($varName)
                $thread.PowerShell.Runspace.SessionStateProxy.SetVariable($var.Name, $var.Value)
            }
            if ($StartupScript) { $thread.Invocation = $thread.PowerShell.AddScript($StartupScript).BeginInvoke() }
            [pscustomobject]$thread
        })

        $index = 0
        $completedCount = 0

        while ($completedCount -lt $inputCount)
        {
            do
            {
                $readyThreads = $threadList.Where({-not $_.Invocation -or $_.Invocation.IsCompleted})
            }
            while (!$readyThreads)

            foreach ($thread in $readyThreads)
            {
                if ($thread.Invocation)
                {
                    $result = $thread.PowerShell.EndInvoke($thread.Invocation)
                    $result
                    $thread.Invocation = $null
                    if ($thread.ReadyToProcess) { $completedCount += $ChunkSize }
                }
                if ($index -ge $inputCount) { continue }
                if (!$thread.ReadyToProcess)
                {
                    $thread.PowerShell.Commands.Clear()
                    [void]$thread.PowerShell.AddScript($Script)
                    $thread.ReadyToProcess = $true
                }
                $incrementSize = [Math]::Min($ChunkSize, $inputCount - $index)
                $nextItems = $inputObjectList.GetRange($index, $incrementSize)
                $index += $incrementSize
                if ($nextItems.Count -eq 1)
                {
                    $thread.PowerShell.Runspace.SessionStateProxy.SetVariable('_', $nextItems[0])
                }
                else
                {
                    $thread.PowerShell.Runspace.SessionStateProxy.SetVariable('_', $nextItems)
                }
                $thread.Invocation = $thread.PowerShell.BeginInvoke()
            }

            if ($ShowProgress)
            {
                $progressRecord = New-Object System.Management.Automation.ProgressRecord $hashCode, "Threading", "Processing"
                $progressRecord.PercentComplete = 100 * $completedCount / $inputCount
                $PSCmdlet.WriteProgress($progressRecord)
            }
        }

            if ($ShowProgress)
            {
                $progressRecord = New-Object System.Management.Automation.ProgressRecord $hashCode, "Threading", "Completed"
                $progressRecord.RecordType = 'Completed'
                $PSCmdlet.WriteProgress($progressRecord)
            }
    }
}
