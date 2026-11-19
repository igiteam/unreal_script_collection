class EvilWalkingVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

var() bool bBlockCrouch;
var() bool bBlockJump;
var() bool bBlockSprint;
var() bool bEnabled;
var() float MoveSpeedModifier;

event PawnEnteredVolume(Pawn Other)
{
    local EvilPawn P;

    P = EvilPawn(Other);
    // End:0x2D
    if(!bEnabled)
    {
        return;
    }
    // End:0x20B
    if(bBlockSprint)
    {
        P.SetSprint(false);
        // End:0x20B
        if(MoveSpeedModifier > float(0))
        {
            P.ChangeSpeedModifier(MoveSpeedModifier);
            // End:0x14F
            if((EvilWeap_Base(P.Weapon) != none) && int(EvilWeap_Base(P.Weapon).ZoomedFireModeNum) < int(255))
            {
                EvilWeap_Base(P.Weapon).OldMovementSpeedModifier = MoveSpeedModifier;
            }
            // End:0x20B
            if((EvilWeap_Base(P.WeaponLeft) != none) && int(EvilWeap_Base(P.WeaponLeft).ZoomedFireModeNum) < int(255))
            {
                EvilWeap_Base(P.WeaponLeft).OldMovementSpeedModifier = MoveSpeedModifier;
            }
        }
    }
    // End:0x2FD
    if(bBlockCrouch && int(PlayerController(P.Controller).bDuck) == int(1))
    {
        PlayerController(P.Controller).bDuck = 0;
        EvilPlayerInput(PlayerController(P.Controller).PlayerInput).bHoldDuck = false;
    }
    //return;    
}

event PawnLeavingVolume(Pawn Other)
{
    local EvilPawn P;

    P = EvilPawn(Other);
    // End:0x2D
    if(!bEnabled)
    {
        return;
    }
    // End:0x2E4
    if(MoveSpeedModifier > float(0))
    {
        // End:0xC9
        if(EvilWeap_Base(P.Weapon) != none)
        {
            P.ChangeSpeedModifier(EvilWeap_Base(P.Weapon).MovementSpeedModifier);            
        }
        else
        {
            P.ChangeSpeedModifier(P.default.MovementSpeedModifier);
        }
        // End:0x1F5
        if((EvilWeap_Base(P.Weapon) != none) && int(EvilWeap_Base(P.Weapon).ZoomedFireModeNum) < int(255))
        {
            EvilWeap_Base(P.Weapon).OldMovementSpeedModifier = EvilWeap_Base(P.Weapon).MovementSpeedModifier;
        }
        // End:0x2E4
        if((EvilWeap_Base(P.WeaponLeft) != none) && int(EvilWeap_Base(P.WeaponLeft).ZoomedFireModeNum) < int(255))
        {
            EvilWeap_Base(P.WeaponLeft).OldMovementSpeedModifier = EvilWeap_Base(P.Weapon).MovementSpeedModifier;
        }
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
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
    //return;    
}

defaultproperties
{
    bEnabled=true
    // Reference: BrushComponent'Default__EvilWalkingVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BrushComponent0'
    // Archetype: BrushComponent'Engine.Default__PhysicsVolume.BrushComponent0'
    begin object name="BrushComponent0"
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}