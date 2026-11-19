class AxonControllerBrainState extends AxonBrainState
    abstract;

const BS_IDLE = 0;
const BS_IDLECOVER = 1;
const BS_IDLEMG = 2;
const BS_ALERT = 3;
const BS_NONCOMBATSQUADMOVE = 4;
const BS_OPENCOMBAT = 5;
const BS_COMBAT = 6;
const BS_TAKECOVER = 7;
const BS_OUTOFCOVER = 8;
const BS_TAKEMG = 9;
const BS_MELEE = 10;
const BS_MGCOMBAT = 11;
const BS_CUSTOMPERFORMANCE = 12;
const BS_COMBATSQUADMOVE = 13;
const BS_GTFO = 14;
const BS_SCRIPTORDER = 15;
const BS_AAGUN = 16;
const BS_GRENADE = 17;
const BS_GAG = 18;
const BS_DEATH = 19;

var MOHAScriptAIController Controller;

function InitializeAxonBrainState(AxonBrainStateStack iOwningBSS, Actor OwningActor)
{
    // End:0x20
    if(MOHAScriptAIController(OwningActor) != none)
    {
        Controller = MOHAScriptAIController(OwningActor);
    }
    super.InitializeAxonBrainState(iOwningBSS, OwningActor);
    //return;    
}

function Vector GetBotLocation()
{
    // End:0x24
    if((Controller == none) || Controller.Pawn == none)
    {        
    }
    else
    {
        return Controller.GetPathablePosition();
    }
    return Controller.Pawn.Location;
    //return ReturnValue;    
}

function bool GetEnemyLocation(out Vector vEnemyloc)
{
    // End:0x0D
    if(Controller == none)
    {
        return false;
    }
    return Controller.GetEnemyLocation(vEnemyloc);
    //return ReturnValue;    
}

function Pawn GetBot()
{
    // End:0x23
    if((Controller == none) || Controller.Pawn == none)
    {
        return none;
    }
    return MOHAPawn(Controller.Pawn).GetPawnBody();
    //return ReturnValue;    
}

function float GetTimeSeconds()
{
    return Controller.WorldInfo.TimeSeconds;
    //return ReturnValue;    
}

function AddToStateTransitionRecord(Object Caller, coerce string Text)
{
    // End:0x43
    if((Controller != none) && Controller.ABSS != none)
    {
        Controller.ABSS.super(AxonBrainStateStack).AddToStateTransitionRecord(Caller, Text);
    }
    //return;    
}

function bool FindRunaheadPoint(float Distance, out Vector vLookAheadPos)
{
    local MOHAAIPawn Pawn;

    Pawn = MOHAAIPawn(GetBot());
    // End:0x22
    if(Pawn == none)
    {
        return false;
    }
    // End:0x44
    if(Pawn.vCurrentSubgoal == vect(0.0000000, 0.0000000, 0.0000000))
    {
        return false;
    }
    Distance += 40.0000000;
    vLookAheadPos = Pawn.vCurrentSubgoal - Pawn.Location;
    vLookAheadPos = Normal(vLookAheadPos);
    vLookAheadPos *= Distance;
    vLookAheadPos += Pawn.Location;
    // End:0xEB
    if(!Controller.PathableCanGo(Pawn.Location, vLookAheadPos) || Controller.IsPointLocked(vLookAheadPos, 50.0000000))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}
