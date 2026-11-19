class UTConsolePlayerController extends UTPlayerController
    native(PC)
    config(Game)
    hidecategories(Navigation);

struct native ProfileSettingToUE3BindingDatum
{
    var name ProfileSettingName;
    var name UE3BindingName;

    structdefaultproperties
    {
        ProfileSettingName="None"
        UE3BindingName="None"
    }
};

var() config bool bTargetAdhesionEnabled;
var protected config bool bDebugTargetAdhesion;
var array<ProfileSettingToUE3BindingDatum> ProfileSettingToUE3BindingMapping360;
var array<ProfileSettingToUE3BindingDatum> ProfileSettingToUE3BindingMappingPS3;

function UpdateRotation(float DeltaTime)
{
    local Rotator DeltaRot, NewRotation, ViewRotation;

    ViewRotation = Rotation;
    // End:0x4E
    if(Pawn != none)
    {
        Pawn.SetDesiredRotation(ViewRotation);
    }
    DeltaRot.Yaw = int(PlayerInput.aTurn);
    DeltaRot.Pitch = int(PlayerInput.aLookUp);
    // End:0x19E
    if((bTargetAdhesionEnabled && Pawn != none) && PlayerInput.aForward != float(0))
    {
        UTConsolePlayerInput(PlayerInput).ApplyTargetAdhesion(DeltaTime, EvilWeap_Base(Pawn.Weapon), DeltaRot.Yaw, DeltaRot.Pitch);
    }
    ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
    SetRotation(ViewRotation);
    ViewShake(DeltaTime);
    NewRotation = ViewRotation;
    NewRotation.Roll = Rotation.Roll;
    // End:0x26E
    if(Pawn != none)
    {
        Pawn.FaceRotation(NewRotation, DeltaTime);
    }
    //return;    
}

function bool AimingHelp(bool bInstantHit)
{
    return true;
    //return ReturnValue;    
}

function float AimHelpModifier()
{
    return ((FOVAngle < (DefaultFOV - float(8))) ? 0.7500000 : 1.0000000);
    //return ReturnValue;    
}

simulated function bool PerformedUseAction()
{
    // End:0x12
    if(super.PerformedUseAction())
    {
        return true;        
    }
    else
    {
        // End:0x43
        if((int(Role) == int(ROLE_Authority)) && !bJustFoundVehicle)
        {
            ClientSmartUse();
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

unreliable client simulated function ClientSmartUse()
{
    ToggleTranslocator();
    //return;    
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    super.ClientRestart(NewPawn);
    // End:0x4C
    if(UTPawn(NewPawn) != none)
    {
        SetOnlyUseControllerTiltInput(false);
        SetUseTiltForwardAndBack(true);
        SetControllerTiltActive(false);
    }
    //return;    
}

exec function PrevWeapon()
{
    // End:0x72
    if((Pawn == none) || Vehicle(Pawn) != none)
    {
        // End:0x6F
        if(UDKVehicleBase(Pawn) != none)
        {
            UDKVehicleBase(Pawn).AdjacentSeat(-1, self);
        }        
    }
    else
    {
        // End:0xA3
        if(!Pawn.IsInState('FeigningDeath'))
        {
            super.PrevWeapon();
        }
    }
    //return;    
}

exec function NextWeapon()
{
    // End:0x6E
    if((Pawn == none) || Vehicle(Pawn) != none)
    {
        // End:0x6B
        if(UDKVehicleBase(Pawn) != none)
        {
            UDKVehicleBase(Pawn).AdjacentSeat(1, self);
        }        
    }
    else
    {
        // End:0x9F
        if(!Pawn.IsInState('FeigningDeath'))
        {
            super.NextWeapon();
        }
    }
    //return;    
}

function ResetPlayerMovementInput()
{
    local UTConsolePlayerInput ConsoleInput;

    super(PlayerController).ResetPlayerMovementInput();
    ConsoleInput = UTConsolePlayerInput(PlayerInput);
    // End:0x56
    if(ConsoleInput != none)
    {
        ConsoleInput.ForcedDoubleClick = 0;
    }
    //return;    
}

state PlayerWalking
{
    ignores SeePlayer, HearNoise, Bump;

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        // End:0x4E
        if((int(DoubleClickMove) == int(5)) && int(Pawn.Physics) == int(2))
        {
            DoubleClickDir = 5;            
        }
        else
        {
            // End:0xF0
            if((int(DoubleClickMove) != int(0)) && int(DoubleClickMove) < int(5))
            {
                // End:0xBB
                if(UTPawn(Pawn).Dodge(DoubleClickMove))
                {
                    DoubleClickDir = 5;                    
                }
                else
                {
                    // End:0xF0
                    if(int(Pawn.Physics) == int(2))
                    {
                        bPressedJump = true;
                    }
                }
            }
        }
        super.ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        //return;        
    }
    stop;    
}

defaultproperties
{
    bTargetAdhesionEnabled=true
    ProfileSettingToUE3BindingMapping360[0]=(ProfileSettingName="GamepadBinding_ButtonA",UE3BindingName="XboxTypeS_A")
    ProfileSettingToUE3BindingMapping360[1]=(ProfileSettingName="GamepadBinding_ButtonB",UE3BindingName="XboxTypeS_B")
    ProfileSettingToUE3BindingMapping360[2]=(ProfileSettingName="GamepadBinding_ButtonX",UE3BindingName="XboxTypeS_X")
    ProfileSettingToUE3BindingMapping360[3]=(ProfileSettingName="GamepadBinding_ButtonY",UE3BindingName="XboxTypeS_Y")
    ProfileSettingToUE3BindingMapping360[4]=(ProfileSettingName="GamepadBinding_Back",UE3BindingName="XboxTypeS_Back")
    ProfileSettingToUE3BindingMapping360[5]=(ProfileSettingName="GamepadBinding_Start",UE3BindingName="XboxTypeS_Start")
    ProfileSettingToUE3BindingMapping360[6]=(ProfileSettingName="GamepadBinding_RightBumper",UE3BindingName="XboxTypeS_RightTrigger")
    ProfileSettingToUE3BindingMapping360[7]=(ProfileSettingName="GamepadBinding_LeftBumper",UE3BindingName="XboxTypeS_LeftTrigger")
    ProfileSettingToUE3BindingMapping360[8]=(ProfileSettingName="GamepadBinding_RightTrigger",UE3BindingName="XboxTypeS_RightShoulder")
    ProfileSettingToUE3BindingMapping360[9]=(ProfileSettingName="GamepadBinding_LeftTrigger",UE3BindingName="XboxTypeS_LeftShoulder")
    ProfileSettingToUE3BindingMapping360[10]=(ProfileSettingName="GamepadBinding_RightThumbstickPressed",UE3BindingName="XboxTypeS_RightThumbStick")
    ProfileSettingToUE3BindingMapping360[11]=(ProfileSettingName="GamepadBinding_LeftThumbstickPressed",UE3BindingName="XboxTypeS_LeftThumbStick")
    ProfileSettingToUE3BindingMapping360[12]=(ProfileSettingName="GamepadBinding_DPadUp",UE3BindingName="XboxTypeS_DPad_Up")
    ProfileSettingToUE3BindingMapping360[13]=(ProfileSettingName="GamepadBinding_DPadDown",UE3BindingName="XboxTypeS_DPad_Down")
    ProfileSettingToUE3BindingMapping360[14]=(ProfileSettingName="GamepadBinding_DPadLeft",UE3BindingName="XboxTypeS_DPad_Left")
    ProfileSettingToUE3BindingMapping360[15]=(ProfileSettingName="GamepadBinding_DPadRight",UE3BindingName="XboxTypeS_DPad_Right")
    ProfileSettingToUE3BindingMappingPS3[0]=(ProfileSettingName="GamepadBinding_ButtonA",UE3BindingName="XboxTypeS_A")
    ProfileSettingToUE3BindingMappingPS3[1]=(ProfileSettingName="GamepadBinding_ButtonB",UE3BindingName="XboxTypeS_B")
    ProfileSettingToUE3BindingMappingPS3[2]=(ProfileSettingName="GamepadBinding_ButtonX",UE3BindingName="XboxTypeS_X")
    ProfileSettingToUE3BindingMappingPS3[3]=(ProfileSettingName="GamepadBinding_ButtonY",UE3BindingName="XboxTypeS_Y")
    ProfileSettingToUE3BindingMappingPS3[4]=(ProfileSettingName="GamepadBinding_Back",UE3BindingName="XboxTypeS_Back")
    ProfileSettingToUE3BindingMappingPS3[5]=(ProfileSettingName="GamepadBinding_Start",UE3BindingName="XboxTypeS_Start")
    ProfileSettingToUE3BindingMappingPS3[6]=(ProfileSettingName="GamepadBinding_RightBumper",UE3BindingName="XboxTypeS_RightShoulder")
    ProfileSettingToUE3BindingMappingPS3[7]=(ProfileSettingName="GamepadBinding_LeftBumper",UE3BindingName="XboxTypeS_LeftShoulder")
    ProfileSettingToUE3BindingMappingPS3[8]=(ProfileSettingName="GamepadBinding_RightTrigger",UE3BindingName="XboxTypeS_RightTrigger")
    ProfileSettingToUE3BindingMappingPS3[9]=(ProfileSettingName="GamepadBinding_LeftTrigger",UE3BindingName="XboxTypeS_LeftTrigger")
    ProfileSettingToUE3BindingMappingPS3[10]=(ProfileSettingName="GamepadBinding_RightThumbstickPressed",UE3BindingName="XboxTypeS_RightThumbStick")
    ProfileSettingToUE3BindingMappingPS3[11]=(ProfileSettingName="GamepadBinding_LeftThumbstickPressed",UE3BindingName="XboxTypeS_LeftThumbStick")
    ProfileSettingToUE3BindingMappingPS3[12]=(ProfileSettingName="GamepadBinding_DPadUp",UE3BindingName="XboxTypeS_DPad_Up")
    ProfileSettingToUE3BindingMappingPS3[13]=(ProfileSettingName="GamepadBinding_DPadDown",UE3BindingName="XboxTypeS_DPad_Down")
    ProfileSettingToUE3BindingMappingPS3[14]=(ProfileSettingName="GamepadBinding_DPadLeft",UE3BindingName="XboxTypeS_DPad_Left")
    ProfileSettingToUE3BindingMappingPS3[15]=(ProfileSettingName="GamepadBinding_DPadRight",UE3BindingName="XboxTypeS_DPad_Right")
    // Reference: ForceFeedbackWaveform'Default__UTConsolePlayerController.ForceFeedbackWaveform7'
    begin object name=ForceFeedbackWaveform7
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__UTConsolePlayerController.ForceFeedbackWaveform8'
    begin object name=ForceFeedbackWaveform8
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    bConsolePlayer=true
    VehicleCheckRadiusScaling=1.5000000
    InputClass=Class'UTConsolePlayerInput'
    // Reference: CylinderComponent'Default__UTConsolePlayerController.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}