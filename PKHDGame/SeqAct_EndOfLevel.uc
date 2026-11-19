class SeqAct_EndOfLevel extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bForceNextLevel;

event Activated()
{
    local PainGRI_SP GRI;
    local PKPawn MyPKPawn;

    // End:0x6C
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllPawns(Class'PKPawn', MyPKPawn)
    {
        MyPKPawn.CapturedSuicide();        
    }    
    GRI = PainGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    GRI.bForceNextLevel = bForceNextLevel;
    GRI.ShowAndWriteLevelStatistics();
    Class'PKMapInfo'.static.PrintNotUsedFactories();
    //return;    
}

defaultproperties
{
    bCallHandler=false
    ObjName="End of level"
}