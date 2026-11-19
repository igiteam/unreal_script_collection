class SeqAct_PKAIFactory extends SeqAct_AIFactory
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

var(AIFactory) PKTypes.EAITypes PKAIType;
var() PKWalkArea WalkArea;

event PostSpawned(Pawn NewPawn, Actor SpawnPoint)
{
    local PKPawn P;

    P = PKPawn(NewPawn);
    // End:0xB6
    if(P != none)
    {
        P.bNotCountable = bNotCountable;
        // End:0xB6
        if(P.MyPKAI != none)
        {
            P.MyPKAI.WalkArea = WalkArea;
        }
    }
    super.PostSpawned(NewPawn, SpawnPoint);
    //return;    
}

static event int GetObjClassVersion()
{
    return super.GetObjClassVersion() + 2;
    //return ReturnValue;    
}

defaultproperties
{
    SpawnInfo=/* Array type was not detected. */
    // Reference: SpawnMethod_JumpAndFx'Default__SeqAct_PKAIFactory.SpawnMethod_JumpAndFx0'
    begin object name="SpawnMethod_JumpAndFx0" class=Class'SpawnMethod_JumpAndFx'
    end object
    SpawnMethod=SpawnMethod_JumpAndFx0
    ObjName="PKAI Factory"
}