class SkyStatsSummary extends Object within SkyGameStats
    abstract;

function string TimeStr(float TimeToConvert)
{
    local int minutes, hours, Seconds;
    local string Result;

    Seconds = int(TimeToConvert);
    // End:0x53
    if(Seconds > 3600)
    {
        hours = Seconds / 3600;
        Seconds -= (hours * 3600);
        Result = string(hours) $ ":";
    }
    minutes = Seconds / 60;
    Seconds -= (minutes * 60);
    // End:0xAC
    if(minutes < 10)
    {
        // End:0x9C
        if(hours == 0)
        {
            Result = Result $ " ";            
        }
        else
        {
            Result = Result $ "0";
        }
    }
    Result = (Result $ string(minutes)) $ ":";
    // End:0xE1
    if(Seconds < 10)
    {
        Result = Result $ "0";
    }
    Result = Result $ string(Seconds);
    return Result;
    //return ReturnValue;    
}

function GenerateSummary()
{
    //return;    
}
