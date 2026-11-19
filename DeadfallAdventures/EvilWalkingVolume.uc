class EvilWalkingVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

var() bool bBlockCrouch;
var() bool bBlockJump;
var() bool bBlockSprint;
var() bool bEnabled;
var() float MoveSpeedModifier;
var transient array<Pawn> PawnsInVolume;

event PawnEnteredVolume(Pawn Other)
{
    PawnsInVolume.AddItem(Other);    
    // End:0x27
    if(!bEnabled)
    {
        return;
    }
    ActivateWalkingVolumeFor(Other);
    //return;    
}

event PawnLeavingVolume(Pawn Other)
{
    PawnsInVolume.RemoveItem(Other);    
    // End:0x27
    if(!bEnabled)
    {
        return;
    }
    DeactivateWalkingVolumeFor(Other);
    //return;    
}

function ActivateWalkingVolumeFor(Pawn Other)
{
    local EvilPawn P;

    P = EvilPawn(Other);
    // End:0x82
    if(bBlockSprint)
    {
        P.SetSprint(false);
        // End:0x82
        if(MoveSpeedModifier > float(0))
        {
            P.ChangeSpeedModifier(MoveSpeedModifier);
        }
    }
    // End:0x174
    if(bBlockCrouch && int(PlayerController(P.Controller).bDuck) == int(1))
    {
        PlayerController(P.Controller).bDuck = 0;
        EvilPlayerInput(PlayerController(P.Controller).PlayerInput).bHoldDuck = false;
    }
    //return;    
}

function DeactivateWalkingVolumeFor(Pawn Other)
{
    local EvilPawn P;

    P = EvilPawn(Other);
    // End:0xF5
    if(MoveSpeedModifier > float(0))
    {
        // End:0xB8
        if(EvilWeap_Base(P.Weapon) != none)
        {
            P.ChangeSpeedModifier(EvilWeap_Base(P.Weapon).MovementSpeedModifier);            
        }
        else
        {
            P.ChangeSpeedModifier(P.default.MovementSpeedModifier);
        }
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    local int I;

    super.OnToggle(inAction);
    // End:0x59
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x9F
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;            
        }
        else
        {
            // End:0xEE
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
            }
        }
    }
    I = 0;
    J0xF9:

    // End:0x1E3 [Loop If]
    if(I < PawnsInVolume.Length)
    {
        // End:0x18B
        if(((PawnsInVolume[I] == none) || !PawnsInVolume[I].IsAliveAndWell()) || PawnsInVolume[I].bDeleteMe)
        {            
        }
        else
        {
            // End:0x1B8
            if(bEnabled)
            {
                ActivateWalkingVolumeFor(PawnsInVolume[I]);                
            }
            else
            {
                DeactivateWalkingVolumeFor(PawnsInVolume[I]);
            }
        }
        I++;
        // [Loop Continue]
        goto J0xF9;
    }
    //return;    
}

defaultproperties
{
    bEnabled=true
    // Reference: BrushComponent'Default__EvilWalkingVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}