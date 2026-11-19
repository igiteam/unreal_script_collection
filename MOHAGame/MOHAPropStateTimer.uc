class MOHAPropStateTimer extends MOHAPropState
    editinlinenew
    hidecategories(Object);

var(Timer) float StateTime;

function float GetStateTime()
{
    return StateTime;
    //return ReturnValue;    
}

defaultproperties
{
    StateTime=1.0000000
    bTimerState=true
}