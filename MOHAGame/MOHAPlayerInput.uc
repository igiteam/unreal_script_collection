class MOHAPlayerInput extends PlayerInput within MOHAPlayerController
    transient
    native
    config(Input)
    hidecategories(Object,UIRoot);

const MAX_CHEAT_ENTRIES = 5;

var(ViewAcceleration) config bool bUseViewAcceleration;
var(ViewAcceleration) bool bDrawYawSpeedGraph;
var(ViewAcceleration) bool bDrawPitchSpeedGraph;
var bool bEnterCheatListen;
var bool bSprintCrouchToStandRequested;
var bool bCrouchDown;
var bool bJumpDown;
var bool bUsingMouse;
var config bool bLoadDefaultKeyBindings;
var(ViewAcceleration) config float fDefaultYawSpeed;
var(ViewAcceleration) config float fDefaultPitchSpeed;
var(ViewAcceleration) config float fMiddleYawAxis;
var(ViewAcceleration) config float fQuickYawAxis;
var(ViewAcceleration) config float fQuickPitchAxis;
var(ViewAcceleration) config float fSlowYaw_Speed;
var(ViewAcceleration) config float fMiddleYaw_Speed;
var(ViewAcceleration) config float fQuickYaw_Speed;
var(ViewAcceleration) config float fSlowYaw_Speed_Aiming;
var(ViewAcceleration) config float fMiddleYaw_Speed_Aiming;
var(ViewAcceleration) config float fQuickYaw_Speed_Aiming;
var(ViewAcceleration) config float fSlowPitch_Speed;
var(ViewAcceleration) config float fQuickPitch_Speed;
var(ViewAcceleration) config float fSlowPitch_Speed_Aiming;
var(ViewAcceleration) config float fQuickPitch_Speed_Aiming;
var(ViewAcceleration) config float fMiddleYaw_Acceleration;
var(ViewAcceleration) config float fQuickYaw_Acceleration;
var(ViewAcceleration) config float fMiddleYaw_Acceleration_Aiming;
var(ViewAcceleration) config float fQuickYaw_Acceleration_Aiming;
var(ViewAcceleration) config float fQuickPitch_Acceleration;
var(ViewAcceleration) config float fQuickPitch_Acceleration_Aiming;
var(ViewAcceleration) config float fMaxLeanCollisionYawSpeed;
var(ViewAcceleration) config float fMinTimeForFullYawDeflection;
var(ViewAcceleration) config float fMinUserProfileSpeedMult;
var(ViewAcceleration) config float fMaxUserProfileSpeedMult;
var(ViewAcceleration) config float fUserProfileSpeedMult;
var(ViewAcceleration) config float fMinUserProfileAccelMult;
var(ViewAcceleration) config float fMaxUserProfileAccelMult;
var(ViewAcceleration) config float fUserProfileAccelMult;
var(ViewAcceleration) config float fMMGYaw_Speed;
var(ViewAcceleration) config float fMMGPitch_Speed;
var(AimAssist) config float fAimAssist_YawFriction;
var(AimAssist) config float fAimAssist_YawFriction_Aiming;
var(AimAssist) config float fAimAssist_YawFriction_Min;
var(AimAssist) config float fAimAssist_YawFriction_Min_Aiming;
var(AimAssist) config float fAimAssist_Pitch_Friction;
var(AimAssist) config float fAimAssist_Pitch_Friction_Aiming;
var(AimAssist) config float fAimAssist_YawRate;
var(AimAssist) config float fAimAssist_YawRate_Aiming;
var(AimAssist) config float fAimAssist_MinDistance;
var(AimAssist) config float fAimAssist_MaxDistance;
var(AimAssist) config float fAimAssist_MinDistance_Aiming;
var(AimAssist) config float fAimAssist_MaxDistance_Aiming;
var(AimAssist) config float fAimAssist_MaxLateralDist;
var(AimAssist) config float fAimAssist_MaxUpwardDist;
var(AimAssist) config float fAimAssist_StickyAimCurveSharpness;
var(AimAssist) config float fAimAssist_MaxFrictionDist;
var(AimAssist) config float fAimAssist_StickyBlendOutTime;
var(Controls) config float fMarsalaLookStickCornerMult;
var() MOHAIncludeClass.eControllerScheme ControllerScheme;
var input byte bSprint;
var input byte bAim;
var input byte bCrouch;
var input byte bJump;
var input byte bFlare;
var() config array<config KeyBind> Bindings_Default;
var() config array<config KeyBind> Bindings_GOW;
var() config array<config KeyBind> Bindings_Halo;
var() config array<config KeyBind> DebugBindings;
var array<float> MouseAveragerX;
var array<float> MouseAveragerY;
var int MouseAveragerIndex;
var int MouseAveragerMaxSamples;
var float AdjustedMouseSensitivity;
var array<name> EnterCheatBuffer;
var name EnterCheatMenuCheat[5];
var name DebugMenuCheat[5];
var name GodModeCheat[5];
var name InvisibleCheat[5];
var name GhostCheat[5];
var name GiveAmmoCheat[5];
var name UpgradeWeaponCheat[5];
var float fCurrentYawMaxSpeed;
var float fCurrentPitchMaxSpeed;
var Actor AimAssistEnemy;
var Vector vPlayerToAimAssistEnemy_AS;
var input float aFire;
var float RawFireDown;
var float fLastAimAssistYawRate;
var float fLastAimAssistTime;
var float fFullYawDeflectionTime;
var export editinline MOHAGraph YawSpeedGraph;
var export editinline MOHAGraph PitchSpeedGraph;

// Export UMOHAPlayerInput::execUpdateAimAssistEnemy(FFrame&, void* const)
native simulated function UpdateAimAssistEnemy();

// Export UMOHAPlayerInput::execGetAimAssistMinDistance(FFrame&, void* const)
native function float GetAimAssistMinDistance();

// Export UMOHAPlayerInput::execGetAimAssistMaxDistance(FFrame&, void* const)
native function float GetAimAssistMaxDistance();

// Export UMOHAPlayerInput::execIsAiming(FFrame&, void* const)
native function bool IsAiming();

// Export UMOHAPlayerInput::execIsUsingMMG(FFrame&, void* const)
native function bool IsUsingMMG();

// Export UMOHAPlayerInput::execClampYawSpeed(FFrame&, void* const)
native function float ClampYawSpeed(float fSpeed);

// Export UMOHAPlayerInput::execGetSlowYawSpeed(FFrame&, void* const)
native function float GetSlowYawSpeed();

// Export UMOHAPlayerInput::execGetMiddleYawSpeed(FFrame&, void* const)
native function float GetMiddleYawSpeed();

// Export UMOHAPlayerInput::execGetMiddleYawAcceleration(FFrame&, void* const)
native function float GetMiddleYawAcceleration();

// Export UMOHAPlayerInput::execGetQuickYawSpeed(FFrame&, void* const)
native function float GetQuickYawSpeed();

// Export UMOHAPlayerInput::execGetQuickYawAcceleration(FFrame&, void* const)
native function float GetQuickYawAcceleration();

// Export UMOHAPlayerInput::execGetSlowPitchSpeed(FFrame&, void* const)
native function float GetSlowPitchSpeed();

// Export UMOHAPlayerInput::execGetQuickPitchSpeed(FFrame&, void* const)
native function float GetQuickPitchSpeed();

// Export UMOHAPlayerInput::execGetQuickPitchAcceleration(FFrame&, void* const)
native function float GetQuickPitchAcceleration();

// Export UMOHAPlayerInput::execIronsightsLeanCollision(FFrame&, void* const)
native function bool IronsightsLeanCollision();

// Export UMOHAPlayerInput::execDegreesToUnrealUnits(FFrame&, void* const)
native function float DegreesToUnrealUnits(float fDegrees);

// Export UMOHAPlayerInput::execUnrealUnitsToDegrees(FFrame&, void* const)
native function float UnrealUnitsToDegrees(float fUnrealUnits);

// Export UMOHAPlayerInput::execCalculateNewSpeed(FFrame&, void* const)
native function float CalculateNewSpeed(float fCurValue, float fTargetValue, float fRate, float fDeltaTime);

// Export UMOHAPlayerInput::execGetYawMaxSpeed(FFrame&, void* const)
native function float GetYawMaxSpeed(float fRawJoyLookRight, float fDeltaTime);

// Export UMOHAPlayerInput::execGetAimAssistYawFriction(FFrame&, void* const)
native function float GetAimAssistYawFriction();

// Export UMOHAPlayerInput::execGetAimAssistYawRate(FFrame&, void* const)
native function float GetAimAssistYawRate();

// Export UMOHAPlayerInput::execGetFrictionMultByRange(FFrame&, void* const)
native function float GetFrictionMultByRange();

// Export UMOHAPlayerInput::execGetAimAssistPitchFriction(FFrame&, void* const)
native function float GetAimAssistPitchFriction();

// Export UMOHAPlayerInput::execGetPitchMaxSpeed(FFrame&, void* const)
native function float GetPitchMaxSpeed(float fRawJoyLookUp, float fDeltaTime);

// Export UMOHAPlayerInput::execMOHANativePlayerInput(FFrame&, void* const)
native function MOHANativePlayerInput(float DeltaTime);

// Export UMOHAPlayerInput::execMarsalaLookTransformation(FFrame&, void* const)
native function MarsalaLookTransformation(out float out_fAdjustedJoyLookRight, out float out_fAdjustedJoyLookUp);

// Export UMOHAPlayerInput::execFlickFilter(FFrame&, void* const)
native function FlickFilter(out float out_fAdjustedJoyLookRight, float fDeltaTime);

// Export UMOHAPlayerInput::execUpdateMouseAvg(FFrame&, void* const)
native simulated function UpdateMouseAvg(float X, float Y);

// Export UMOHAPlayerInput::execNormalizeFireAxis(FFrame&, void* const)
native simulated function float NormalizeFireAxis(float Val);

// Export UMOHAPlayerInput::execSetBindings(FFrame&, void* const)
native simulated function SetBindings(MOHAIncludeClass.eControllerScheme Scheme);

// Export UMOHAPlayerInput::execSetDebugBindings(FFrame&, void* const)
native simulated function SetDebugBindings();

// Export UMOHAPlayerInput::execSetDefaultLanguageBindings(FFrame&, void* const)
native simulated function SetDefaultLanguageBindings();

// Export UMOHAPlayerInput::execCopyLanguageSpecificBindings(FFrame&, void* const)
native function CopyLanguageSpecificBindings(MOHADefaultKeyBindings DefaultKeyBindingsObject);

event bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000)
{
    // End:0xB5
    if(((bEnterCheatListen && int(Event) == int(0)) && int(Outer.WorldInfo.NetMode) == int(NM_Standalone)) && !Class'MOHAGameEngine'.static.IsDemo())
    {
        EnterCheatBuffer[EnterCheatBuffer.Length] = Key;
        // End:0xB5
        if(EnterCheatBuffer.Length >= 5)
        {
            // End:0xAB
            if(VerifyCheat(EnterCheatBuffer, EnterCheatMenuCheat))
            {
                Outer.ShowEnterCheatMenu();
            }
            ResetCheatEntry();
        }
    }
    return super(Interaction).InputKey(ControllerId, Key, Event, AmountDepressed);
    //return ReturnValue;    
}

function ResetCheatEntry()
{
    EnterCheatBuffer.Remove(0, EnterCheatBuffer.Length);
    bEnterCheatListen = false;
    //return;    
}

function bool VerifyCheat(array<name> CheatEntered, name CheatEntry[5])
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(I < CheatEntered.Length)
    {
        // End:0x34
        if(CheatEntered[I] != CheatEntry[I])
        {
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return true;
    //return ReturnValue;    
}

simulated function InitBindings()
{
    SetBindings(0);
    SetDefaultLanguageBindings();
    //return;    
}

simulated exec function SetControllerScheme_Default()
{
    SetBindings(0);
    //return;    
}

simulated exec function SetControllerScheme_GOW()
{
    SetBindings(1);
    //return;    
}

simulated exec function SetControllerScheme_Halo()
{
    SetBindings(2);
    //return;    
}

simulated exec function SetAimSensitivity(float fScale)
{
    local float fWeight;

    fScale = FClamp(fScale, 0.0000000, 1.0000000);
    // End:0x62
    if(fScale <= 0.5000000)
    {
        fWeight = (0.5000000 - fScale) * 2.0000000;
        fUserProfileSpeedMult = ((fMinUserProfileSpeedMult * fWeight) + 1.0000000) - fWeight;        
    }
    else
    {
        fWeight = (fScale - 0.5000000) * 2.0000000;
        fUserProfileSpeedMult = ((fMaxUserProfileSpeedMult * fWeight) + 1.0000000) - fWeight;
    }
    //return;    
}

simulated function InitMouseSensitivity()
{
    AdjustedMouseSensitivity = MouseSensitivity;
    //return;    
}

simulated function UpdateMouseSensitivity()
{
    AdjustedMouseSensitivity = fUserProfileSpeedMult * MouseSensitivity;
    //return;    
}

simulated exec event SprintPress()
{
    Outer.bSprintRequested = true;
    bSprintCrouchToStandRequested = false;
    // End:0xAD
    if(((MOHAPlayerPawn(Outer.Pawn) != none) && int(MOHAPlayerPawn(Outer.Pawn).eDesiredStance) == int(1)) && !MOHAPlayerPawn(Outer.Pawn).IsIronsightsActive())
    {
        Outer.bStanceChangeRequested = true;
        bSprintCrouchToStandRequested = true;
        Outer.bSavedCrouchRequested = true;
    }
    //return;    
}

simulated exec event SprintRelease()
{
    Outer.bSprintRequested = false;
    // End:0x7B
    if((bSprintCrouchToStandRequested && Outer.Pawn != none) && int(MOHAPlayerPawn(Outer.Pawn).eDesiredStance) == int(0))
    {
        Outer.bStanceChangeRequested = true;
        Outer.bSavedCrouchRequested = true;
    }
    //return;    
}

simulated exec event CrouchPress()
{
    Outer.bStanceChangeRequested = true;
    Outer.bSavedCrouchRequested = true;
    bCrouchDown = true;
    //return;    
}

simulated exec event JumpPress()
{
    Outer.bJumpRequested = true;
    bJumpDown = true;
    Outer.bSavedJumpRequested = true;
    //return;    
}

simulated exec event CrouchRelease()
{
    bCrouchDown = false;
    //return;    
}

simulated exec event JumpRelease()
{
    bJumpDown = false;
    //return;    
}

event CallAimPress()
{
    Outer.AimPress();
    //return;    
}

event CallAimRelease()
{
    Outer.AimRelease();
    //return;    
}

simulated function GetBlendedMouse(out float X, out float Y, int NumSamples)
{
    local int I, Count;

    X = 0.0000000;
    Y = 0.0000000;
    NumSamples = Clamp(NumSamples, 1, MouseAveragerMaxSamples);
    Count = NumSamples;
    I = MouseAveragerIndex;
    J0x3F:

    // End:0x98 [Loop If]
    if(NumSamples > 0)
    {
        I--;
        // End:0x6A
        if(I < 0)
        {
            I = MouseAveragerMaxSamples - 1;
        }
        X += MouseAveragerX[I];
        Y += MouseAveragerY[I];
        NumSamples--;
        // [Loop Continue]
        goto J0x3F;
    }
    X /= float(Count);
    Y /= float(Count);
    //return;    
}

event CallPreProcessInput(float DeltaTime)
{
    PreProcessInput(DeltaTime);
    //return;    
}

event CallPostProcessInputAndInputMatching(float DeltaTime)
{
    PostProcessInput(DeltaTime);
    ProcessInputMatching(DeltaTime);
    //return;    
}

event CallSmoothMouse(float DeltaTime)
{
    aMouseX = SmoothMouse(aMouseX, DeltaTime, bXAxis, 0);
    aMouseY = SmoothMouse(aMouseY, DeltaTime, bYAxis, 1);
    //return;    
}

event PlayerInput(float DeltaTime)
{
    MOHANativePlayerInput(DeltaTime);
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    HUD.Canvas.__NFUN_465__((("Yaw Max Speed: " $ string(fCurrentYawMaxSpeed)) $ " Pitch Max Speed: ") $ string(fCurrentPitchMaxSpeed));
    HUD.Canvas.__NFUN_465__("Aim Assist Target: " $ string(AimAssistEnemy));
    out_YPos += out_YL;
    //return;    
}

defaultproperties
{
    bUseViewAcceleration=true
    bLoadDefaultKeyBindings=true
    fDefaultYawSpeed=150.0000000
    fDefaultPitchSpeed=150.0000000
    fMiddleYawAxis=0.6000000
    fQuickYawAxis=0.8000000
    fQuickPitchAxis=0.8000000
    fSlowYaw_Speed=30.0000000
    fMiddleYaw_Speed=160.0000000
    fQuickYaw_Speed=240.0000000
    fSlowYaw_Speed_Aiming=25.0000000
    fMiddleYaw_Speed_Aiming=40.0000000
    fQuickYaw_Speed_Aiming=180.0000000
    fSlowPitch_Speed=60.0000000
    fQuickPitch_Speed=180.0000000
    fSlowPitch_Speed_Aiming=20.0000000
    fQuickPitch_Speed_Aiming=50.0000000
    fMiddleYaw_Acceleration=240.0000000
    fQuickYaw_Acceleration=600.0000000
    fMiddleYaw_Acceleration_Aiming=20.0000000
    fQuickYaw_Acceleration_Aiming=150.0000000
    fQuickPitch_Acceleration=160.0000000
    fQuickPitch_Acceleration_Aiming=10.0000000
    fMaxLeanCollisionYawSpeed=30.0000000
    fMinTimeForFullYawDeflection=0.1500000
    fMinUserProfileSpeedMult=0.5000000
    fMaxUserProfileSpeedMult=2.0000000
    fUserProfileSpeedMult=1.0000000
    fMinUserProfileAccelMult=0.5000000
    fMaxUserProfileAccelMult=2.0000000
    fUserProfileAccelMult=1.0000000
    fMMGYaw_Speed=65.0000000
    fMMGPitch_Speed=50.0000000
    fAimAssist_YawFriction=70.0000000
    fAimAssist_YawFriction_Aiming=50.0000000
    fAimAssist_YawFriction_Min=7.0000000
    fAimAssist_YawFriction_Min_Aiming=5.0000000
    fAimAssist_Pitch_Friction=20.0000000
    fAimAssist_Pitch_Friction_Aiming=5.0000000
    fAimAssist_YawRate=20.0000000
    fAimAssist_YawRate_Aiming=10.0000000
    fAimAssist_MinDistance=200.0000000
    fAimAssist_MaxDistance=2500.0000000
    fAimAssist_MinDistance_Aiming=200.0000000
    fAimAssist_MaxDistance_Aiming=4000.0000000
    fAimAssist_MaxLateralDist=100.0000000
    fAimAssist_MaxUpwardDist=125.0000000
    fAimAssist_StickyAimCurveSharpness=10.0000000
    fAimAssist_MaxFrictionDist=500.0000000
    fAimAssist_StickyBlendOutTime=0.2000000
    fMarsalaLookStickCornerMult=1.2000000
    Bindings_Default[0]=(Name="XboxTypeS_A",Command="Reload | button bFlare | FlareChute | onrelease FlareChuteEnd | SkipToJump | SkipBriefing | FireDebugButtonComboEvents | FireCinematicSkipEvents | Use | onrelease UseRelease | ApplyUpgrade",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[1]=(Name="XboxTypeS_B",Command="SwitchWeaponPress",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[2]=(Name="XboxTypeS_Back",Command="ShowScores",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[3]=(Name="XboxTypeS_LeftShoulder",Command="StartAltFire 1 | OnRelease StopAltFire 1 | PressEnterCheatL | onrelease ReleaseEnterCheatL",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[4]=(Name="XboxTypeS_LeftThumbstick",Command="Button bSprint | EnableIronsightsWalk | onrelease DisableIronsightsWalk",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[5]=(Name="XboxTypeS_LeftTrigger",Command="Button bAim | PreviousUpgrade",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[6]=(Name="XboxTypeS_LeftX",Command="Axis aStrafe Speed=1.0 DeadZone=0.3",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[7]=(Name="XboxTypeS_LeftY",Command="Axis aBaseY Speed=1.0 DeadZone=0.3",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[8]=(Name="XboxTypeS_RightShoulder",Command="SwitchGrenade | PressEnterCheatR | onrelease ReleaseEnterCheatR ",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[9]=(Name="XboxTypeS_RightThumbstick",Command="StartAltFire 2 | OnRelease StopAltFire 2 | AirDropMeleePress",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[10]=(Name="XboxTypeS_RightTrigger",Command="Fire | NextUpgrade",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[11]=(Name="XboxTypeS_RightX",Command="Axis aTurn Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[12]=(Name="XboxTypeS_RightY",Command="Axis aLookup Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[13]=(Name="XboxTypeS_Start",Command="Pause",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[14]=(Name="XboxTypeS_Start",Command="|onrelease showmenu",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[15]=(Name="XboxTypeS_X",Command="Button bCrouch",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[16]=(Name="XboxTypeS_Y",Command="Button bJump",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[17]=(Name="XboxTypeS_DPad_Up",Command="ZoomInDown | onrelease ZoomInRelease",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[18]=(Name="XboxTypeS_DPad_Down",Command="ZoomOutDown | onrelease ZoomOutRelease",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[19]=(Name="XboxTypeS_DPad_Left",Command="",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Default[20]=(Name="XboxTypeS_DPad_Right",Command="",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[0]=(Name="XboxTypeS_A",Command="Reload | button bFlare | onrelease FlareChuteEnd | FlareChute | SkipToJump | SkipBriefing | FireDebugButtonComboEvents | FireCinematicSkipEvents | Use | onrelease UseRelease",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[1]=(Name="XboxTypeS_B",Command="StartAltFire 2 | OnRelease StopAltFire 2 | AirDropMeleePress",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[2]=(Name="XboxTypeS_Back",Command="ShowScores",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[3]=(Name="XboxTypeS_LeftShoulder",Command="Button bSprint | PressEnterCheatL | onrelease ReleaseEnterCheatL",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[4]=(Name="XboxTypeS_LeftThumbstick",Command="EnableIronsightsWalk | onrelease DisableIronsightsWalk",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[5]=(Name="XboxTypeS_LeftTrigger",Command="Button bAim | PreviousUpgrade",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[6]=(Name="XboxTypeS_LeftX",Command="Axis aStrafe Speed=1.0 DeadZone=0.3",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[7]=(Name="XboxTypeS_LeftY",Command="Axis aBaseY Speed=1.0 DeadZone=0.3",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[8]=(Name="XboxTypeS_RightShoulder",Command="StartAltFire 1 | OnRelease StopAltFire 1 | PressEnterCheatR | onrelease ReleaseEnterCheatR",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[9]=(Name="XboxTypeS_RightThumbstick",Command="DiscreteZoomPress",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[10]=(Name="XboxTypeS_RightTrigger",Command="Fire | NextUpgrade",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[11]=(Name="XboxTypeS_RightX",Command="Axis aTurn Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[12]=(Name="XboxTypeS_RightY",Command="Axis aLookup Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[13]=(Name="XboxTypeS_Start",Command="Pause",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[14]=(Name="XboxTypeS_Start",Command="|onrelease showmenu",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[15]=(Name="XboxTypeS_X",Command="Button bCrouch",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[16]=(Name="XboxTypeS_Y",Command="Button bJump",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[17]=(Name="XboxTypeS_DPad_Up",Command="SwitchGrenade",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[18]=(Name="XboxTypeS_DPad_Down",Command="SwitchPistol",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[19]=(Name="XboxTypeS_DPad_Left",Command="SwitchPrimary",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_GOW[20]=(Name="XboxTypeS_DPad_Right",Command="SwitchSecondary",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[0]=(Name="XboxTypeS_A",Command="Button bJump | FireDebugButtonComboEvents",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[1]=(Name="XboxTypeS_B",Command="StartAltFire 2 | OnRelease StopAltFire 2 | AirDropMeleePress",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[2]=(Name="XboxTypeS_Back",Command="ShowScores",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[3]=(Name="XboxTypeS_LeftShoulder",Command="Button bSprint | EnableIronsightsWalk | onrelease DisableIronsightsWalk | PressEnterCheatL | onrelease ReleaseEnterCheatL",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[4]=(Name="XboxTypeS_LeftThumbstick",Command="Button bCrouch",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[5]=(Name="XboxTypeS_LeftTrigger",Command="Button bAim | PreviousUpgrade",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[6]=(Name="XboxTypeS_LeftX",Command="Axis aStrafe Speed=1.0 DeadZone=0.3",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[7]=(Name="XboxTypeS_LeftY",Command="Axis aBaseY Speed=1.0 DeadZone=0.3",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[8]=(Name="XboxTypeS_RightShoulder",Command="SwitchGrenade | PressEnterCheatR | onrelease ReleaseEnterCheatR ",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[9]=(Name="XboxTypeS_RightThumbstick",Command="StartAltFire 1 | OnRelease StopAltFire 1",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[10]=(Name="XboxTypeS_RightTrigger",Command="Fire | NextUpgrade",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[11]=(Name="XboxTypeS_RightX",Command="Axis aTurn Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[12]=(Name="XboxTypeS_RightY",Command="Axis aLookup Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[13]=(Name="XboxTypeS_Start",Command="Pause",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[14]=(Name="XboxTypeS_Start",Command="|onrelease showmenu",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[15]=(Name="XboxTypeS_X",Command="Reload | button bFlare | FlareChute | onrelease FlareChuteEnd | SkipToJump | FireCinematicSkipEvents | Use | onrelease UseRelease",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[16]=(Name="XboxTypeS_Y",Command="SwitchWeaponPress",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[17]=(Name="XboxTypeS_DPad_Up",Command="ZoomInDown | onrelease ZoomInRelease",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[18]=(Name="XboxTypeS_DPad_Down",Command="ZoomOutDown | onrelease ZoomOutRelease",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[19]=(Name="XboxTypeS_DPad_Left",Command="",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    Bindings_Halo[20]=(Name="XboxTypeS_DPad_Right",Command="",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[0]=(Name="F1",Command="viewmode wireframe",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[1]=(Name="F2",Command="viewmode unlit",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[2]=(Name="F3",Command="viewmode lit",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[3]=(Name="F5",Command="quicksave",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[4]=(Name="F6",Command="quickload",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[5]=(Name="F7",Command="set D3DRenderDevice bUsePostProcessEffects False",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[6]=(Name="F8",Command="set D3DRenderDevice bUsePostProcessEffects True",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[7]=(Name="F10",Command="dumpdynamicshadowstats",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[8]=(Name="F11",Command="cleanscreenshot",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[9]=(Name="F",Command="FreezeRendering",Control=false,Shift=false,Alt=true,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[10]=(Name="F12",Command="DebugCCState",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[11]=(Name="F12",Command="CycleCCPerformerVerbosity",Control=false,Shift=true,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[12]=(Name="F12",Command="DebugAllCCState",Control=true,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[13]=(Name="F12",Command="CycleCCVerbosity",Control=true,Shift=true,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[14]=(Name="LeftBracket",Command="UpdateGunView 50 0 -4 -5",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[15]=(Name="Period",Command="kynapse draw affordance body",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[16]=(Name="Slash",Command="kynapse draw cover",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[17]=(Name="NumPadZero",Command="debugaistate",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[18]=(Name="NumPadOne",Command="AiOff",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[19]=(Name="NumPadTwo",Command="AiOn",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[20]=(Name="NumPadThree",Command="ThisAiOn",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[21]=(Name="NumPadFour",Command="DumpSelectedNPCBrainState",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[22]=(Name="NumPadFive",Command="Teleport",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[23]=(Name="NumPadSix",Command="Vaporize",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[24]=(Name="NumPadSeven",Command="Slomo 0.2",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[25]=(Name="NumPadEight",Command="Slomo 1",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[26]=(Name="NumPadNine",Command="Slomo 4",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[27]=(Name="Quote",Command="CreateMonkeySpawn MOHAGameNonNative.MOHA82ndAirborneThompsonPawn",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[28]=(Name="F4",Command="ToggleCCEnabled",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[29]=(Name="F4",Command="ToggleCCLogToCSV",Control=false,Shift=true,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[30]=(Name="F4",Command="TogglePALogToCSV",Control=true,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[31]=(Name="F11",Command="upgradeweapon",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[32]=(Name="Backslash",Command="ToggleDrawSkeleton",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[33]=(Name="Comma",Command="kynapse draw tacaff neighborship",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[34]=(Name="H",Command="ClearMonkeySpawn Axis",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[35]=(Name="I",Command="MonkeySpawn Axis",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[36]=(Name="J",Command="ClearMonkeySpawn Allies",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[37]=(Name="L",Command="ShowPawnAnimDebug",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[38]=(Name="M",Command="kynapse draw tacaff sim",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[39]=(Name="N",Command="ghost",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[40]=(Name="O",Command="MonkeySpawn Allies",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[41]=(Name="P",Command="kynapse debug playerinvisible",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[42]=(Name="Zero",Command="summon mohagame.MOHAAlliedAIPawn",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[43]=(Name="Nine",Command="debugaistate",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[44]=(Name="B",Command="editactorpicker",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[45]=(Name="T",Command="god",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[46]=(Name="Y",Command="CreateMonkeySpawn MOHAGameNonNative.MOHAHeerInfantryTropicalMP40Pawn",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    DebugBindings[47]=(Name="V",Command="editactorpicker true",Control=false,Shift=false,Alt=false,IsRebindable=false,BindPos2=false,MOHAConsoleBinding=false)
    MouseAveragerMaxSamples=10
    EnterCheatMenuCheat[0]="XboxTypeS_X"
    EnterCheatMenuCheat[1]="XboxTypeS_B"
    EnterCheatMenuCheat[2]="XboxTypeS_Y"
    EnterCheatMenuCheat[3]="XboxTypeS_A"
    EnterCheatMenuCheat[4]="XboxTypeS_A"
    DebugMenuCheat[0]="XboxTypeS_X"
    DebugMenuCheat[1]="XboxTypeS_X"
    DebugMenuCheat[2]="XboxTypeS_X"
    DebugMenuCheat[3]="XboxTypeS_X"
    DebugMenuCheat[4]="XboxTypeS_X"
    GodModeCheat[0]="XboxTypeS_Y"
    GodModeCheat[1]="XboxTypeS_Y"
    GodModeCheat[2]="XboxTypeS_Y"
    GodModeCheat[3]="XboxTypeS_Y"
    GodModeCheat[4]="XboxTypeS_Y"
    InvisibleCheat[0]="XboxTypeS_B"
    InvisibleCheat[1]="XboxTypeS_B"
    InvisibleCheat[2]="XboxTypeS_B"
    InvisibleCheat[3]="XboxTypeS_B"
    InvisibleCheat[4]="XboxTypeS_B"
    GhostCheat[0]="XboxTypeS_A"
    GhostCheat[1]="XboxTypeS_A"
    GhostCheat[2]="XboxTypeS_A"
    GhostCheat[3]="XboxTypeS_A"
    GhostCheat[4]="XboxTypeS_A"
    GiveAmmoCheat[0]="XboxTypeS_X"
    GiveAmmoCheat[1]="XboxTypeS_X"
    GiveAmmoCheat[2]="XboxTypeS_X"
    GiveAmmoCheat[3]="XboxTypeS_Y"
    GiveAmmoCheat[4]="XboxTypeS_Y"
    UpgradeWeaponCheat[0]="XboxTypeS_Y"
    UpgradeWeaponCheat[1]="XboxTypeS_Y"
    UpgradeWeaponCheat[2]="XboxTypeS_Y"
    UpgradeWeaponCheat[3]="XboxTypeS_X"
    UpgradeWeaponCheat[4]="XboxTypeS_X"
    // Reference: MOHAGraph'Default__MOHAPlayerInput.YawGraph0'
    begin object name=YawGraph0 class=Class'MOHAGraph'
    end object
    YawSpeedGraph=YawGraph0
    // Reference: MOHAGraph'Default__MOHAPlayerInput.PitchGraph0'
    begin object name=PitchGraph0 class=Class'MOHAGraph'
    end object
    PitchSpeedGraph=PitchGraph0
}