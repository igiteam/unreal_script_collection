class CCChannelState extends Object
    native
    hidecategories(Object);

struct CCKeyInfo
{
    var CCKey Key;
    var float EndTime_sec;

    structdefaultproperties
    {
        Key=none
        EndTime_sec=0.0000000
    }
};

var transient CCPerformanceState PS;
var transient bool bInProgress;
var transient bool bTickKeys;
var transient array<CCKey> CurrentKeys;
var transient int CurrentKey;

function PostBeginPlay(CCPerformanceState InPS, int TeamIndex)
{
    PS = InPS;
    //return;    
}

event float StartChannel(CCChannel Channel, float StartTime_sec)
{
    local float PerformanceLocalTime_sec, ChannelDuration_sec;

    // End:0x31
    if(bInProgress)
    {
        PerformanceLocalTime_sec = PS.GetPerformanceLocalTime_sec();
        StopChannel(PerformanceLocalTime_sec);
    }
    // End:0x67
    if(Channel.GetKeys(CurrentKeys, ChannelDuration_sec))
    {
        bInProgress = true;
        CurrentKey = -1;        
    }
    else
    {
        ChannelDuration_sec = 0.0000000;
    }
    return ChannelDuration_sec;
    //return ReturnValue;    
}

event StopChannel(float PerformanceLocalTime_sec)
{
    // End:0x55
    if(bInProgress)
    {
        // End:0x3A
        if((CurrentKey >= 0) && CurrentKey < CurrentKeys.Length)
        {
            EndKey(CurrentKey, PerformanceLocalTime_sec);
        }
        bInProgress = false;
        CurrentKey = -1;
        CurrentKeys.Length = 0;
    }
    //return;    
}

event float GetChannelDuration_sec(CCChannel Channel)
{
    local float ChannelDuration_sec;

    // End:0x2D
    if(!Channel.GetKeys(CurrentKeys, ChannelDuration_sec))
    {
        ChannelDuration_sec = 0.0000000;
    }
    return ChannelDuration_sec;
    //return ReturnValue;    
}

function BeginKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    //return;    
}

function TickKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    //return;    
}

function EndKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    //return;    
}

event TickChannel(float PerformanceLocalTime_sec)
{
    local bool bNewKey;

    // End:0x1C9
    if(bInProgress)
    {
        bNewKey = false;
        // End:0x173
        if(CurrentKeys.Length > 0)
        {
            // End:0x3E
            if(CurrentKey < 0)
            {
                CurrentKey = -1;
                bNewKey = true;                
            }
            else
            {
                // End:0xA2
                if(CurrentKey < CurrentKeys.Length)
                {
                    // End:0xA2
                    if(!Class'CCKey'.static.IsDurationInfinite(CurrentKeys[CurrentKey].EndTime_sec) && PerformanceLocalTime_sec >= CurrentKeys[CurrentKey].EndTime_sec)
                    {
                        bNewKey = true;
                    }
                }
            }
            // End:0x173
            if(bNewKey)
            {
                // End:0xF6
                if((CurrentKey >= 0) && CurrentKey < CurrentKeys.Length)
                {
                    // End:0xF6
                    if(!CurrentKeys[CurrentKey].bDeadSpace)
                    {
                        EndKey(CurrentKey, PerformanceLocalTime_sec);
                    }
                }
                J0xF6:

                ++CurrentKey;
                // End:0xF6
                if(!((CurrentKey == CurrentKeys.Length) || none != CurrentKeys[CurrentKey]))
                    goto J0xF6;
                // End:0x173
                if(((CurrentKey < CurrentKeys.Length) && none != CurrentKeys[CurrentKey]) && !CurrentKeys[CurrentKey].bDeadSpace)
                {
                    BeginKey(CurrentKey, PerformanceLocalTime_sec);
                }
            }
        }
        // End:0x1C9
        if(!bNewKey)
        {
            // End:0x1C9
            if((bTickKeys && CurrentKey < CurrentKeys.Length) && !CurrentKeys[CurrentKey].bDeadSpace)
            {
                TickKey(CurrentKey, PerformanceLocalTime_sec);
            }
        }
    }
    //return;    
}

defaultproperties
{
    CurrentKey=-1
}