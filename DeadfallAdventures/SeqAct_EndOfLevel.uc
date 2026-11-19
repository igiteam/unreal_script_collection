class SeqAct_EndOfLevel extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bForceNextLevel;
var() bool bSuppressSaveCheckpoint;

event Activated()
{
    local AdvGRI_SP GRI;

    GRI = AdvGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    GRI.bForceNextLevel = bForceNextLevel;
    GRI.ShowAndWriteLevelStatistics(bSuppressSaveCheckpoint);
    //return;    
}

defaultproperties
{
    bCallHandler=false
    ObjName="End of level"
}