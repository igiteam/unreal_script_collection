class AdvWalkableObstacleVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

simulated event PawnEnteredVolume(Pawn P)
{
    // End:0x41
    if(AdvPawn(P) != none)
    {
        AdvPawn(P).CurrentWalkableObstacle = self;
    }
    super.PawnEnteredVolume(P);
    //return;    
}

simulated event PawnLeavingVolume(Pawn P)
{
    // End:0x41
    if(AdvPawn(P) != none)
    {
        AdvPawn(P).CurrentWalkableObstacle = none;
    }
    super.PawnLeavingVolume(P);
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    super.OnToggle(inAction);
    // End:0x4D
    if(inAction.InputLinks[0].bHasImpulse)
    {        
    }
    else
    {
        // End:0x87
        if(inAction.InputLinks[1].bHasImpulse)
        {            
        }
        else
        {
            // End:0xBF
            if(inAction.InputLinks[2].bHasImpulse)
            {
            }
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: BrushComponent'Default__AdvWalkableObstacleVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}