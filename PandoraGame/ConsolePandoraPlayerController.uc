class ConsolePandoraPlayerController extends PandoraPlayerController
    native
    config(Game);

var protected config bool bDebugTargetAdhesion;
var() config bool bTargetAdhesionEnabled;
var() Vector CalcViewLocation;
var() Rotator CalcViewRotation;
var config string DemoMapName;

// Export UConsolePandoraPlayerController::execGetTargetAdhesionFrictionTarget(FFrame&, void* const)
native function Pawn GetTargetAdhesionFrictionTarget(float MaxDistance, const out Vector CamLoc, const out Rotator CamRot);

// Export UConsolePandoraPlayerController::execGetPlayerViewPoint(FFrame&, void* const)
native function GetPlayerViewPoint(out Vector POVLocation, out Rotator POVRotation);

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    SetSavedStickSensitivity();
    //return;    
}

function UpdateRotation(float DeltaTime)
{
    local Rotator DeltaRot, NewRotation, ViewRotation;
    local PandoraPlayerInput PPlayerInput;

    ViewRotation = Rotation;
    DesiredRotation = ViewRotation;
    DeltaRot.Yaw = int(PlayerInput.aTurn);
    DeltaRot.Pitch = int(PlayerInput.aLookUp);
    // End:0xDB
    if((bTargetAdhesionEnabled && Pawn != none) && PlayerInput.aForward != float(0))
    {
        ConsolePandoraPlayerInput(PlayerInput).ApplyTargetAdhesion(DeltaTime, SPWeapon(Pawn.Weapon), DeltaRot.Yaw, DeltaRot.Pitch);
    }
    PPlayerInput = PandoraPlayerInput(PlayerInput);
    // End:0x121
    if((LocalPlayer(Player) != none) && PPlayerInput != none)
    {
        PPlayerInput.ProcessOverrides(DeltaTime);
    }
    // End:0x15D
    if((Pawn != none) && int(Pawn.Physics) == int(9))
    {
        PlayerInput.aTurn = 0.0000000;
    }
    DeltaRot.Yaw = int(PlayerInput.aTurn);
    DeltaRot.Pitch = int(PlayerInput.aLookUp);
    ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
    SetRotation(ViewRotation);
    ViewShake(DeltaTime);
    NewRotation = ViewRotation;
    NewRotation.Roll = Rotation.Roll;
    // End:0x226
    if(Pawn != none)
    {
        Pawn.FaceRotation(NewRotation, DeltaTime);
    }
    //return;    
}

function float AimHelpModifier()
{
    return ((FOVAngle < (DefaultFOV - float(8))) ? 0.7500000 : 1.0000000);
    //return ReturnValue;    
}

function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
    super.OnProfileWriteComplete(LocalUserNum, bWasSuccessful);
    // End:0x24
    if(bWasSuccessful)
    {
        LoadSettingsFromProfile();
    }
    //return;    
}

simulated function LoadSettingsFromProfile()
{
    local int CurrStickSensitivity, OutIntValue;
    local ConsolePandoraPlayerInput ConsolePlayerInput;

    ConsolePlayerInput = ConsolePandoraPlayerInput(PlayerInput);
    CurrStickSensitivity = ProfileSettings.GetControllerSensitivityValue();
    SetStickSensitivity(CurrStickSensitivity);
    // End:0x71
    if(ProfileSettings.GetProfileSettingValueId(17, OutIntValue))
    {
        ConsolePlayerInput.bAutoCenterPitch = OutIntValue == 1;
    }
    // End:0xA8
    if(0 == ProfileSettings.GetAutoAim())
    {
        bTargetAdhesionEnabled = false;
        ConsolePlayerInput.bTargetFrictionEnabled = false;        
    }
    else
    {
        bTargetAdhesionEnabled = false;
        ConsolePlayerInput.bTargetFrictionEnabled = true;
    }
    //return;    
}

simulated function SetSavedStickSensitivity()
{
    local int controlSensitivity;

    controlSensitivity = SavedProfile.CtrlSensitivity;
    // End:0x29
    if(controlSensitivity == 0)
    {
        controlSensitivity = 5;
    }
    SetStickSensitivity(controlSensitivity);
    //return;    
}

simulated function SetStickSensitivity(int Sensitivity)
{
    local ConsolePandoraPlayerInput ConsolePlayerInput;

    ConsolePlayerInput = ConsolePandoraPlayerInput(PlayerInput);
    // End:0x34
    if(ConsolePlayerInput != none)
    {
        ConsolePlayerInput.SetStickSensitivity(Sensitivity);
    }
    //return;    
}
