# ========================================================================
# Comparison of Write-Verbose vs $PSCmdlet.WriteVerbose()
# ========================================================================

Function Test-VerboseSpeed
{
    [CmdletBinding()]
    Param ()
    End
    {
        Write-Host -ForegroundColor Gray "Baseline - No Verbose"
        Measure-Command {
            for ($i = 0; $i -lt 100000; $i++)
            {
                $i
            }
        } | % TotalMilliseconds | Write-Host -ForegroundColor Green

        Write-Host -ForegroundColor Gray "Using Write-Verbose"
        Measure-Command {
            for ($i = 0; $i -lt 100000; $i++)
            {
                Write-Verbose $i
            }
        } | % TotalMilliseconds | Write-Host -ForegroundColor Green

        Write-Host -ForegroundColor Gray "Using `$PSCmdlet.WriteVerbose"
        Measure-Command {
            for ($i = 0; $i -lt 100000; $i++)
            {
                $PSCmdlet.WriteVerbose($i)
            }
        } | % TotalMilliseconds | Write-Host -ForegroundColor Green
    }
}

Write-Host -ForegroundColor Red "Running without -Verbose"
Test-VerboseSpeed

Write-Host -ForegroundColor Red "Running with -Verbose (Verbose redirected to null)"
Test-VerboseSpeed -Verbose 4>$null