class SeqAct_SetCustomTimer extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() string TimerTitleLocKey;
var() int TimerSeconds;

event Activated()
{
    local AdvGRI GRI;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x87
    if(GRI != none)
    {
        GRI.SetCustomTimer(TimerSeconds, TimerTitleLocKey);
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks=none
    ObjName="Set Custom Timer"
}