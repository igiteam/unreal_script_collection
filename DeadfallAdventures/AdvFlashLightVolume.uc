class AdvFlashLightVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display,Volume);

var() bool bEnabled;
var() bool bInfiniteBattery;
var() bool bLookForGlowableElements;
var() float FlashLightPower;
var() float DrainRate;
var() float RecoveryRate;
var() int TraceColumns;

event PawnEnteredVolume(Pawn Other)
{
    local AdvPlayerPawn P;

    P = AdvPlayerPawn(Other);
    // End:0x9B
    if(bEnabled)
    {
        P.MyTorch.ChangeTorchPowerFromVolume(true, FlashLightPower, DrainRate, RecoveryRate, 0.0000000, bInfiniteBattery, bLookForGlowableElements, TraceColumns);
    }
    //return;    
}

event PawnLeavingVolume(Pawn Other)
{
    local AdvPlayerPawn P;

    P = AdvPlayerPawn(Other);
    // End:0x65
    if(bEnabled)
    {
        P.MyTorch.ChangeTorchPowerFromVolume(false);
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
    bInfiniteBattery=true
    bLookForGlowableElements=true
    FlashLightPower=0.6000000
    // Reference: BrushComponent'Default__AdvFlashLightVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}