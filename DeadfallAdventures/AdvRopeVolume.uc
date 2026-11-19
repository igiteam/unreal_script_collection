class AdvRopeVolume extends LadderVolume
    hidecategories(Navigation,Object,Movement,Display);

var() private bool bIsClimbable;
var private bool bIsUsed;

simulated event PawnEnteredVolume(Pawn P)
{
    // End:0x37
    if(!P.CanGrabLadder() || !bIsClimbable)
    {
        return;
    }
    WallDir = P.Rotation;
    LookDir = Vector(WallDir);
    bIsUsed = true;
    super.PawnEnteredVolume(P);
    //return;    
}

simulated event PawnLeavingVolume(Pawn P)
{
    bIsUsed = false;
    super.PawnLeavingVolume(P);
    //return;    
}

function bool IsRopeUsed()
{
    return bIsUsed;
    //return ReturnValue;    
}

function EnableRope(bool Enable)
{
    bIsClimbable = Enable;
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    super(PhysicsVolume).OnToggle(inAction);
    // End:0x59
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bIsClimbable = true;        
    }
    else
    {
        // End:0x9F
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bIsClimbable = false;            
        }
        else
        {
            // End:0xEE
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bIsClimbable = !bIsClimbable;
            }
        }
    }
    //return;    
}

defaultproperties
{
    bIsClimbable=true
    bAutoPath=false
    // Reference: BrushComponent'Default__AdvRopeVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=none
    CollisionComponent=BrushComponent0
}