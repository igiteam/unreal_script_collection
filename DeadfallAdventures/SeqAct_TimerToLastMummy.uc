class SeqAct_TimerToLastMummy extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() string TimerTitleLocKey;
var() string TimerExpiredLocKey;
var() float TimerSeconds;

event Activated()
{
    local AdvGRI GRI;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x92
    if(GRI != none)
    {
        GRI.SetTimerToLastMummy(int(TimerSeconds), TimerTitleLocKey, TimerExpiredLocKey);
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks=none
    ObjName="Set Timer To Last Mummy"
}