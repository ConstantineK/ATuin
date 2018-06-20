function New-Timer {
    $stopWatch = new-object System.Diagnostics.Stopwatch;
    # We really want to be able to call elapsed each time and have it reset 
    # that means we need to override the stopwatch elapsed method to also call stop 
    $stopWatch | Add-Member TimeElapsed -MemberType ScriptMethod { 
        $this.Stop()
        $val = $this.Elapsed
        $this.Reset()
        return $val 
    }
    return $stopWatch
}