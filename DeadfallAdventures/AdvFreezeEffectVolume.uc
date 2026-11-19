class AdvFreezeEffectVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

var() bool bEnabled;
var() float EffectScale;
var() float EffectEnableSpeed;
var() float EffectDisableSpeed;
var transient array<Pawn> PawnsInVolume;

private final function HandlePawn(Pawn Other, bool bEntering, optional bool bFromToggle)
{
    local AdvPlayerController PC;
    local AdvPostProcessManager PPMgr;
    local bool bEnableEffect;

    PC = AdvPlayerController(Other.Controller);
    // End:0x73
    if(PC != none)
    {
        PPMgr = AdvPostProcessManager(PC.GetPPManager());
    }
    bEnableEffect = bEnabled && bEntering;
    // End:0xF9
    if(PPMgr != none)
    {
        PPMgr.EnableHoarfrost(bEnableEffect, EffectScale, ((bEnableEffect) ? EffectEnableSpeed : EffectDisableSpeed));
    }
    // End:0x164
    if(!bFromToggle)
    {
        // End:0x14E
        if(bEntering)
        {
            // End:0x14B
            if(PawnsInVolume.Find(Other) == )
            {                
                PawnsInVolume.AddItem(Other);                
            }            
        }
        else
        {
            PawnsInVolume.RemoveItem(Other);            
        }
    }
    //return;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local Pawn P;

    P = Pawn(Other);
    // End:0x40
    if(P != none)
    {
        HandlePawn(P, true);
    }
    //return;    
}

simulated event UnTouch(Actor Other)
{
    local Pawn P;

    P = Pawn(Other);
    // End:0x40
    if(P != none)
    {
        HandlePawn(P, false);
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    local Pawn P;

    // End:0x46
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x8C
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;            
        }
        else
        {
            // End:0xDB
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
            }
        }
    }
    // End:0x111
    foreach PawnsInVolume(P)
    {
        HandlePawn(P, bEnabled, true);        
    }    
    //return;    
}

defaultproperties
{
    bEnabled=true
    EffectScale=1.0000000
    EffectEnableSpeed=0.5000000
    EffectDisableSpeed=0.8000000
    bVelocityAffectsWalking=false
    bPawnsOnly=true
    // Reference: BrushComponent'Default__AdvFreezeEffectVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
    SupportedEvents=/* Array type was not detected. */
}