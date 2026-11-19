class SeqAct_CoopSkeletonsSuicide extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local PKPawn MyPKPawn;

    // End:0x6C
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllPawns(Class'PKPawn', MyPKPawn)
    {
        MyPKPawn.CapturedSuicide();        
    }    
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks=none
    ObjName="Coop Skeletons Suicide"
}