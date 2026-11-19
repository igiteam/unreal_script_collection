class AdvSlidingVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

var() bool bEnabled;
var() bool GetUpAfterFall;
var() int SlopeEnd;
var() int SlideSpeed;
var() float TurningModifier;
var SoundCue SlideSound;
var SoundCue JumpSound;
var() float TimeInBlack;

event PawnEnteredVolume(Pawn Other)
{
    local AdvPawn P;
    local AdvPlayerController APC;
    local int TimeMultTen;

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
    // End:0xC3
    if(GetUpAfterFall)
    {
        TimeMultTen = int(TimeInBlack * float(10));
        // End:0xC0
        if(TimeMultTen < 10)
        {
            TimeMultTen = 10;
        }        
    }
    else
    {
        TimeMultTen = 0;
    }
    // End:0x147
    if(APC != none)
    {
        APC.StartSlide(self.SlideSpeed, self.SlopeEnd, self.TurningModifier, TimeMultTen);
    }
    //return;    
}

event PawnLeavingVolume(Pawn Other)
{
    local AdvPawn P;
    local AdvPlayerController APC;

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
        APC.StopSlide();
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
    SlopeEnd=15470
    SlideSpeed=40
    TurningModifier=0.2500000
    TimeInBlack=2.3000000
    // Reference: BrushComponent'Default__AdvSlidingVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}