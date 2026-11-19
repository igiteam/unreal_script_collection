interface SpawnInOIRInterface extends Interface
    abstract;

function SetOIRData(out OIRData oir)
{
    //return;    
}

function Actor SpawnOIRPawn(class<Pawn> PawnClass)
{
    //return ReturnValue;    
}

function name GetInitialActivity()
{
    //return ReturnValue;    
}

function class<AxonBrainState> GetSpawnTransplantBrain()
{
    //return ReturnValue;    
}

event NPCLeavingOIR(Pawn P)
{
    //return;    
}

function InitBrainState(AxonBrainState Abs)
{
    //return;    
}

simulated function OnSpawnOIRPawn(SeqAct_SpawnOIRPawn Action)
{
    //return;    
}

simulated function OnExitOIR(SeqAct_ExitOIR Action)
{
    //return;    
}

function SetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    //return;    
}
