class SeqAct_MPDrawObjectiveText extends SequenceAction
    native
    hidecategories(Object);

var() name ObjectiveName;
var() string MessageTitle;
var() string MessageAllied;
var() string MessageAxis;
var() float Duration;

event LoadLocalizedSettings()
{
    local string newDuration;

    MessageTitle = GetLocalizedStr(MessageTitle, string(ObjectiveName), "MessageTitle", "Objectives");
    MessageAllied = GetLocalizedStr(MessageAllied, string(ObjectiveName), "MessageAllied", "Objectives");
    MessageAxis = GetLocalizedStr(MessageAxis, string(ObjectiveName), "MessageAxis", "Objectives");
    newDuration = LocalizeOpt(string(ObjectiveName), "Duration", "Objectives", true);
    // End:0xDD
    if(newDuration != "")
    {
        Duration = float(newDuration);
    }
    //return;    
}

defaultproperties
{
    Duration=5.0000000
    VariableLinks=none
    ObjName="MP Draw Objective Text"
    ObjCategory="MPGame"
}