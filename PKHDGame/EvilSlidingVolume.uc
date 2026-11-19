class EvilSlidingVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

var() export editinline ArrowComponent Arrow;
var() float SlidingSpeed;
var() Rotator SlidingRotation;
var() bool bEnabled;

event PawnEnteredVolume(Pawn Other)
{
    local EvilPawn P;
    local EvilPlayerController EPC;

    // End:0x1E
    if(!self.bEnabled)
    {
        return;
    }
    P = EvilPawn(Other);
    // End:0x4B
    if(P == none)
    {
        return;
    }
    EPC = EvilPlayerController(P.Controller);
    // End:0xD8
    if(EPC != none)
    {
        EPC.StartSliding(Vector(self.SlidingRotation), self.SlidingSpeed);
    }
    //return;    
}

event PawnLeavingVolume(Pawn Other)
{
    local EvilPawn P;
    local EvilPlayerController EPC;

    // End:0x1E
    if(!self.bEnabled)
    {
        return;
    }
    P = EvilPawn(Other);
    // End:0x4B
    if(P == none)
    {
        return;
    }
    EPC = EvilPlayerController(P.Controller);
    // End:0xAA
    if(EPC != none)
    {
        EPC.StopSliding();
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
    SlidingSpeed=30.0000000
    bEnabled=true
    // Reference: BrushComponent'Default__EvilSlidingVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BrushComponent0'
    // Archetype: BrushComponent'Engine.Default__PhysicsVolume.BrushComponent0'
    begin object name="BrushComponent0"
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=none
    CollisionComponent=BrushComponent0
}