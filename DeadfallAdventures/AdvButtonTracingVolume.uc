class AdvButtonTracingVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display,Volume);

var() bool bEnabled;
var AdvPawn P;
var AdvPlayerController APC;

event PawnEnteredVolume(Pawn Other)
{
    P = AdvPawn(Other);
    // End:0x2D
    if(P == none)
    {
        return;
    }
    APC = AdvPlayerController(P.Controller);
    // End:0x7C
    if(!self.bEnabled)
    {
        return;
    }
    // End:0xAA
    if(APC != none)
    {
        APC.StartButtonTracing();
    }
    //return;    
}

event PawnLeavingVolume(Pawn Other)
{
    // End:0x1E
    if(!self.bEnabled)
    {
        return;
    }
    P = AdvPawn(Other);
    // End:0x4B
    if(P == none)
    {
        return;
    }
    APC = AdvPlayerController(P.Controller);
    // End:0xAA
    if(APC != none)
    {
        APC.StopButtonTracing();
    }
    P = none;
    APC = none;
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    super.OnToggle(inAction);
    // End:0x94
    if(inAction.InputLinks[0].bHasImpulse)
    {
        self.bEnabled = true;
        // End:0x91
        if(APC != none)
        {
            APC.StartButtonTracing();
        }        
    }
    else
    {
        // End:0x115
        if(inAction.InputLinks[1].bHasImpulse)
        {
            // End:0xF9
            if(APC != none)
            {
                APC.StopButtonTracing();
            }
            self.bEnabled = false;            
        }
        else
        {
            // End:0x171
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
    // Reference: BrushComponent'Default__AdvButtonTracingVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}