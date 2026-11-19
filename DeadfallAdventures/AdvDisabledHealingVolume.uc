class AdvDisabledHealingVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display,Volume);

var() bool bEnabled;

event PawnEnteredVolume(Pawn Other)
{
    local AdvPlayerPawnMP P;

    P = AdvPlayerPawnMP(Other);
    // End:0x124
    if(bEnabled)
    {
        P.SurvivalWoundedDisabled = true;
        // End:0x124
        if(P.Controller.IsInState('Wounded') || P.Controller.IsInState('SurvivalWounded'))
        {
            P.Died(P.LastHitBy, Class'AdvDmgType_Trap_Base', P.Location);
        }
    }
    //return;    
}

event PawnLeavingVolume(Pawn Other)
{
    local AdvPlayerPawnMP P;

    P = AdvPlayerPawnMP(Other);
    // End:0x4A
    if(bEnabled)
    {
        P.SurvivalWoundedDisabled = false;
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    super.OnToggle(inAction);
    // End:0x66
    if(inAction.InputLinks[0].bHasImpulse)
    {
        self.bEnabled = true;        
    }
    else
    {
        // End:0xB9
        if(inAction.InputLinks[1].bHasImpulse)
        {
            self.bEnabled = false;            
        }
        else
        {
            // End:0x115
            if(inAction.InputLinks[2].bHasImpulse)
            {
                self.bEnabled = !bEnabled;
            }
        }
    }
    //return;    
}

defaultproperties
{
    bEnabled=true
    // Reference: BrushComponent'Default__AdvDisabledHealingVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}