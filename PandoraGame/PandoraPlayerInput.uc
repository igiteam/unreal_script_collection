class PandoraPlayerInput extends PlayerInput within PandoraPlayerController
    transient
    native
    config(Input);

enum ECommand
{
    Command_NoCommand,              // 0
    switchbutton,                   // 1
    siphonbutton,                   // 2
    healbutton,                     // 3
    throwgbutton,                   // 4
    crouchupbutton,                 // 5
    crouchdownbutton,               // 6
    aimbutton,                      // 7
    crouchbutton,                   // 8
    movebutton,                     // 9
    lookbutton,                     // 10
    sprintbutton,                   // 11
    jumpbutton,                     // 12
    firebutton,                     // 13
    reloadbutton,                   // 14
    usebutton,                      // 15
    pickupbutton,                   // 16
    cyclebutton,                    // 17
    pdabutton,                      // 18
    swapbutton,                     // 19
    animususebutton,                // 20
    switchgbutton,                  // 21
    switchmeleebutton,              // 22
    waypointbutton,                 // 23
    ECommand_MAX                    // 24
};

enum EUICommand
{
    Command_None,                   // 0
    selectbutton,                   // 1
    backbutton,                     // 2
    confirmbutton,                  // 3
    cancelbutton,                   // 4
    togglebutton,                   // 5
    gamertagbutton,                 // 6
    nextpagebutton,                 // 7
    prevpagebutton,                 // 8
    startbutton,                    // 9
    EUICommand_MAX                  // 10
};

enum EPandoraCtrlConfig
{
    EPSC_Default,                   // 0
    EPSC_SouthPaw,                  // 1
    EPSC_Legacy,                    // 2
    EPSC_LegacySouthPaw,            // 3
    EPSC_Tactical,                  // 4
    EPSC_Assault,                   // 5
    EPSC_MAX                        // 6
};

struct native InputAccelData
{
    /** MACROS STRUCT DECLARATIONS */
    var() bool Enabled;
    /** Acceleration multiplier */
    var() float accelMultiPlier;
    /** Threshold above when Yaw Acceleration kicks in */
    var() float accelInputThreshold;
    /** Time for Yaw Accel to ramp up */
    var() float accelRampUptime;
    /** Multiplier for turn acceleration fade down time */
    var() float fadeDownMultiplier;
    var float currAccelPct;

    structdefaultproperties
    {
        Enabled=false
        accelMultiPlier=0.0000000
        accelInputThreshold=0.0000000
        accelRampUptime=0.0000000
        fadeDownMultiplier=0.0000000
        currAccelPct=0.0000000
    }
};

struct native SpringDampingData
{
    var() bool bSpringEnabled;
    var() bool bCurveAccelEnabled;
    var() bool bUseCubicCurveAccel;
    var() float accelMultiPlier;
    var() float decelMultiplier;
    var() float letGoDecelMultiplier;
    var float startVal;
    var float currDelta;
    var float MaxDelta;

    structdefaultproperties
    {
        bSpringEnabled=false
        bCurveAccelEnabled=false
        bUseCubicCurveAccel=false
        accelMultiPlier=0.0000000
        decelMultiplier=0.0000000
        letGoDecelMultiplier=0.0000000
        startVal=0.0000000
        currDelta=0.0000000
        MaxDelta=0.0000000
    }
};

struct native AimAssistData
{
    var() float YawDegreeAssistRange;
    var() float PitchDegreeAssistRange;
    var() float YawAssistMaxScaleDown;
    var() float PitchAssistMaxScaleDown;
    var() float StrafeAngleGain;
    var() float StrafeTargetGain;
    var() float StrafeGainClampSpeed;
    var() float DodgeGain;
    var() float LineCheckWidth;
    var() float MaxTargetDist;
    var() float ShotAssistDegreeCheat;
    var() float ShotAssistDisableRadius;
    var() float delayTargetLoss;
    var() bool bEnableSubTargets;
    var() float MinScaleByDistanceAmt;
    var() float ScaleByDistance;

    structdefaultproperties
    {
        YawDegreeAssistRange=0.0000000
        PitchDegreeAssistRange=0.0000000
        YawAssistMaxScaleDown=0.0000000
        PitchAssistMaxScaleDown=0.0000000
        StrafeAngleGain=0.0000000
        StrafeTargetGain=0.0000000
        StrafeGainClampSpeed=0.0000000
        DodgeGain=0.0000000
        LineCheckWidth=0.0000000
        MaxTargetDist=0.0000000
        ShotAssistDegreeCheat=0.0000000
        ShotAssistDisableRadius=0.0000000
        delayTargetLoss=0.0000000
        bEnableSubTargets=false
        MinScaleByDistanceAmt=0.0000000
        ScaleByDistance=0.0000000
    }
};

struct native LifeForceData
{
    var() bool bEnable;
    var() float PMinDistance;
    var() float PMinYawAngle;
    var() float PMinPitchAngle;
    var() float PDuration;
    var() float AMinDistance;
    var() float AMinYawAngle;
    var() float AMinPitchAngle;
    var() float ADuration;
    var() float HealDelayTime;
    var() float PHealRate[3];
    var() float AHealRate[3];
    var() float ASiphonRate[3];

    structdefaultproperties
    {
        bEnable=false
        PMinDistance=0.0000000
        PMinYawAngle=0.0000000
        PMinPitchAngle=0.0000000
        PDuration=0.0000000
        AMinDistance=0.0000000
        AMinYawAngle=0.0000000
        AMinPitchAngle=0.0000000
        ADuration=0.0000000
        HealDelayTime=0.0000000
        PHealRate[0]=0.0000000
        PHealRate[1]=0.0000000
        PHealRate[2]=0.0000000
        AHealRate[0]=0.0000000
        AHealRate[1]=0.0000000
        AHealRate[2]=0.0000000
        ASiphonRate[0]=0.0000000
        ASiphonRate[1]=0.0000000
        ASiphonRate[2]=0.0000000
    }
};

struct native MeleeImpactShakeData
{
    var() float YawImpactDegrees;
    var() float PitchImpactDegrees;
    var() float impactTime;
    var() float RecoveryTime;
    var() float ShakeAmpl;
    var() float BiteShakeAmpl;
    var() float BiteImpactTime;
    var() float DamageValToOne;
    var() float FromBehindImpactScale;
    var() float MultiHitReductionScale;
    var() float MultiHitTimeTakenToReduce;
    var() float MultiHitReductionTimeOut;

    structdefaultproperties
    {
        YawImpactDegrees=0.0000000
        PitchImpactDegrees=0.0000000
        impactTime=0.0000000
        RecoveryTime=0.0000000
        ShakeAmpl=0.0000000
        BiteShakeAmpl=0.0000000
        BiteImpactTime=0.0000000
        DamageValToOne=0.0000000
        FromBehindImpactScale=0.0000000
        MultiHitReductionScale=0.0000000
        MultiHitTimeTakenToReduce=0.0000000
        MultiHitReductionTimeOut=0.0000000
    }
};

struct native TargetBoneInfo
{
    /** Should probably contain other info like vulnerability, damage multiplier... */
    var() name BoneName;

    structdefaultproperties
    {
        BoneName="None"
    }
};

struct native InputCurvePointInfo
{
    var() float RawVal;
    var() float OutVal;

    structdefaultproperties
    {
        RawVal=0.0000000
        OutVal=0.0000000
    }
};

struct native ButtonBindingInfo
{
    var name Name;
    var name ButtonFontName;
    var string Command;
    var const localized string Description;

    structdefaultproperties
    {
        Name="None"
        ButtonFontName="None"
        Command=""
        Description=""
    }
};

struct native Button2Font
{
    var string ButtonName;
    var string FontMarkup;

    structdefaultproperties
    {
        ButtonName=""
        FontMarkup=""
    }
};

struct native KeyCommandToButtonCommandBindingInfo
{
    var string KeyCommand;
    var string ButtonCommand;

    structdefaultproperties
    {
        KeyCommand=""
        ButtonCommand=""
    }
};

struct native OverrideControls
{
    var int overrideState;
    var Rotator rotVel;
    var float markTime;
    var float DeltaTime;
    var float recoverTime;
    var Actor recoverTargetActor;
    var bool recoverTargetActorSet;
    var Rotator explicitRecoverRot;
    var bool bDisableRecovery;
    var int overrideLevel;

    structdefaultproperties
    {
        overrideState=0
        rotVel=(Pitch=0,Yaw=0,Roll=0)
        markTime=0.0000000
        DeltaTime=0.0000000
        recoverTime=0.0000000
        recoverTargetActor=none
        recoverTargetActorSet=false
        explicitRecoverRot=(Pitch=0,Yaw=0,Roll=0)
        bDisableRecovery=false
        overrideLevel=0
    }
};

var const float FRAMESPERSEC;
/** Turn Acceleration */
var(TurnAcceleration) config InputAccelData TurnAcceleration;
/** Turn damping */
var(TurnSpringDamping) config SpringDampingData TurnSpringDamping;
/** Pitch Acceleration */
var(PitchAcceleration) config InputAccelData PitchAcceleration;
/** Pitch damping */
var(PitchSpringDamping) config SpringDampingData PitchSpringDamping;
/** Forward damping */
var(ForwardSpringDamping) config SpringDampingData ForwardSpringDamping;
/** Strafe damping */
var(StrafeSpringDamping) config SpringDampingData StrafeSpringDamping;
/** Aim Assist Stuff */
var(AimAssist) config AimAssistData AimAssistParams;
/** Life Force (Animus Vitae) */
var(LifeForce) config LifeForceData LifeForceParams;
var MeleeImpactShakeData MeleeImpactShakeParams;
var() config array<config InputCurvePointInfo> PitchInputCurvePoints;
var() config array<config InputCurvePointInfo> TurnInputCurvePoints;
var Actor lastAimAssistTarget;
var Vector lastAimAssistTargetLoc;
var float lastAimAssistTime;
var bool bHoldDuck;
var bool bAPressed;
var bool bBPressed;
var bool bXPressed;
var bool bYPressed;
var bool bLeftShoulderPressed;
var bool bPlayerInputEnabled;
var bool bLeftShoulderHeldDown;
var bool bRightShoulderHeldDown;
var bool bLeftTriggerHeldDown;
var bool bRightTriggerHeldDown;
var bool PandoraPlayerInput_Skip_PreProcessInput;
var bool PandoraPlayerInput_Skip_PostProcessInput;
var bool bFakeWalk;
var bool bSwitchFake;
var OverrideControls orControls;
var array<TargetBoneInfo> DefaultPawnTargetInfo;
var config array<config ButtonBindingInfo> PandoraDefaultCtrlConfig;
var config array<config ButtonBindingInfo> PandoraLegacyCtrlConfig;
var config array<config ButtonBindingInfo> PandoraSouthPawCtrlConfig;
var config array<config ButtonBindingInfo> PandoraLegacySouthPawCtrlConfig;
var config array<config ButtonBindingInfo> PandoraTacticalCtrlConfig;
var config array<config ButtonBindingInfo> PandoraAssaultCtrlConfig;
var config array<config ButtonBindingInfo> PandoraDefaultCtrlConfigButtonMaps;
var config array<config ButtonBindingInfo> PandoraLegacyCtrlConfigButtonMaps;
var config array<config ButtonBindingInfo> PandoraSouthPawCtrlConfigButtonMaps;
var config array<config ButtonBindingInfo> PandoraLegacySouthPawCtrlConfigButtonMaps;
var config array<config ButtonBindingInfo> PandoraTacticalCtrlConfigButtonMaps;
var config array<config ButtonBindingInfo> PandoraAssaultCtrlConfigButtonMaps;
var config array<config KeyCommandToButtonCommandBindingInfo> KeyCommandToButtonCommandBindingMaps;
var float LastFakeTime;
var config array<config string> Commands;
var config array<config Button2Font> XboxButtonFonts;
var config array<config Button2Font> PCbuttonFonts;
var config array<config Button2Font> PS3buttonFonts;
var config array<config KeyBind> DefaultBindings;

// Export UPandoraPlayerInput::execForceFlushOfInput(FFrame&, void* const)
native function ForceFlushOfInput();

function ResetKeyStates()
{
    bAPressed = false;
    bBPressed = false;
    bXPressed = false;
    bYPressed = false;
    //return;    
}

function ResetAllKeyStates()
{
    ResetKeyStates();
    bLeftTriggerHeldDown = false;
    bRightTriggerHeldDown = false;
    bLeftShoulderHeldDown = false;
    bRightShoulderHeldDown = false;
    //return;    
}

function bool InputKey(int ControllerId, name Key, Object.EInputEvent EventType, optional float AmountDepressed = 1.0000000, optional bool bGamepad)
{
    // End:0x56
    if(((Key == 'A') || Key == 'XboxTypeS_A') && int(EventType) == int(0))
    {
        ResetKeyStates();
        bAPressed = true;
    }
    // End:0xA2
    if(((Key == 'B') || Key == 'XboxTypeS_B') && int(EventType) == int(0))
    {
        ResetKeyStates();
        bBPressed = true;
    }
    // End:0xEE
    if(((Key == 'X') || Key == 'XboxTypeS_X') && int(EventType) == int(0))
    {
        ResetKeyStates();
        bXPressed = true;
    }
    // End:0x13A
    if(((Key == 'Y') || Key == 'XboxTypeS_Y') && int(EventType) == int(0))
    {
        ResetKeyStates();
        bYPressed = true;
    }
    // End:0x179
    if((Key == 'XboxTypeS_LeftShoulder') && (int(EventType) == int(0)) || int(EventType) == int(2))
    {
        bLeftShoulderHeldDown = true;
    }
    // End:0x1B8
    if((Key == 'XboxTypeS_RightShoulder') && (int(EventType) == int(0)) || int(EventType) == int(2))
    {
        bRightShoulderHeldDown = true;
    }
    // End:0x1F7
    if((Key == 'XboxTypeS_LeftTrigger') && (int(EventType) == int(0)) || int(EventType) == int(2))
    {
        bLeftTriggerHeldDown = true;
    }
    // End:0x236
    if((Key == 'XboxTypeS_RightTrigger') && (int(EventType) == int(0)) || int(EventType) == int(2))
    {
        bRightTriggerHeldDown = true;
    }
    // End:0x263
    if((Key == 'XboxTypeS_LeftShoulder') && int(EventType) == int(1))
    {
        bLeftShoulderHeldDown = false;
    }
    // End:0x290
    if((Key == 'XboxTypeS_RightShoulder') && int(EventType) == int(1))
    {
        bRightShoulderHeldDown = false;
    }
    // End:0x2BD
    if((Key == 'XboxTypeS_LeftTrigger') && int(EventType) == int(1))
    {
        bLeftTriggerHeldDown = false;
    }
    // End:0x2EA
    if((Key == 'XboxTypeS_RightTrigger') && int(EventType) == int(1))
    {
        bRightTriggerHeldDown = false;
    }
    return false;
    //return ReturnValue;    
}

function bool IsQuickMenuComboKeyPressed()
{
    return ((bLeftTriggerHeldDown && bRightTriggerHeldDown) && bLeftShoulderHeldDown) && bRightShoulderHeldDown;
    //return ReturnValue;    
}

function ResetOverrides()
{
    orControls.recoverTargetActor = none;
    orControls.overrideState = 0;
    //return;    
}

event PlayerInput(float DeltaTime)
{
    // End:0x0E
    if(bPlayerInputEnabled == false)
    {
        return;
    }
    super.PlayerInput(DeltaTime);
    // End:0x9C
    if(bFakeWalk)
    {
        // End:0x7A
        if((Outer.WorldInfo.TimeSeconds - LastFakeTime) > 5.0000000)
        {
            bSwitchFake = !bSwitchFake;
            LastFakeTime = Outer.WorldInfo.TimeSeconds;
        }
        // End:0x91
        if(bSwitchFake)
        {
            aForward = 1935.0000000;            
        }
        else
        {
            aForward = -1935.0000000;
        }
    }
    //return;    
}

exec function FakeWalk()
{
    bFakeWalk = !bFakeWalk;
    //return;    
}

simulated exec function AnimusActivate()
{
    local float timeSinceAnimusButtonPressed;

    // End:0x30
    if(Outer.IsInWerewolfTackleState() == true)
    {
        Outer.TMGTransitionY();
        return;
    }
    // End:0x153
    if(int(Outer.WorldInfo.NetMode) == int(NM_Standalone))
    {
        timeSinceAnimusButtonPressed = Outer.WorldInfo.TimeSeconds - Outer.AnimusButton.PressedTime;
        // End:0xEA
        if(timeSinceAnimusButtonPressed <= Outer.AnimusButton.DoubleClickTime)
        {
            Outer.AttemptAnimusPulse();
            Outer.AnimusButton.PressedTime = 0.0000000;            
        }
        else
        {
            Outer.AnimusButton.PressedTime = Outer.WorldInfo.TimeSeconds;
            Outer.SetTimer(Outer.AnimusButton.DoubleClickTime, false, 'AttemptSiphonOrHeal');
        }        
    }
    else
    {
        Outer.AttemptSiphonOrHeal();
    }
    //return;    
}

simulated exec function AnimusDeActivate()
{
    local float timeSinceAnimusButtonPressed;

    timeSinceAnimusButtonPressed = Outer.WorldInfo.TimeSeconds - Outer.AnimusButton.PressedTime;
    // End:0x7C
    if(timeSinceAnimusButtonPressed <= Outer.AnimusButton.DoubleClickTime)
    {
        Outer.ClearTimer('AttemptSiphonOrHeal');        
    }
    else
    {
        UnSiphon();
        UnHeal();
    }
    // End:0xB7
    if(Outer.m_bUsingAnimusUsedAndHeld)
    {
        Outer.ReleaseAnimusUse();
    }
    //return;    
}

function PreProcessInput(float DeltaTime)
{
    // End:0x19
    if(PandoraPlayerInput_Skip_PreProcessInput == true)
    {
        super.PreProcessInput(DeltaTime);
        return;
    }
    CurveAccel(aTurn, TurnSpringDamping, TurnInputCurvePoints);
    CurveAccel(aLookUp, PitchSpringDamping, PitchInputCurvePoints);
    CurveAccel(aBaseY, ForwardSpringDamping, TurnInputCurvePoints);
    CurveAccel(aStrafe, StrafeSpringDamping, TurnInputCurvePoints);
    Accelerate(DeltaTime, aTurn, RawJoyLookRight, TurnAcceleration, RawJoyLookUp / 0.8000000, PitchAcceleration.accelInputThreshold);
    Accelerate(DeltaTime, aLookUp, RawJoyLookUp, PitchAcceleration, RawJoyLookRight * 0.8000000, TurnAcceleration.accelInputThreshold);
    // End:0x1EC
    if((((PlayerPawn(Outer.Pawn) != none) && PlayerPawn(Outer.Pawn).GetIsFullyLookingDownSite()) && PlayerPawn(Outer.Pawn).Weapon != none) && SPWeapon(PlayerPawn(Outer.Pawn).Weapon) != none)
    {
        aTurn *= SPWeapon(PlayerPawn(Outer.Pawn).Weapon).DampValue;
        aLookUp *= SPWeapon(PlayerPawn(Outer.Pawn).Weapon).DampValue;
    }
    //return;    
}

function PostProcessInput(float DeltaTime)
{
    // End:0x19
    if(PandoraPlayerInput_Skip_PostProcessInput == true)
    {
        super.PostProcessInput(DeltaTime);
        return;
    }
    SpringDamp(DeltaTime, aTurn, RawJoyLookRight, TurnSpringDamping);
    SpringDamp(DeltaTime, aLookUp, RawJoyLookUp, PitchSpringDamping);
    SpringDamp(DeltaTime, aBaseY, RawJoyUp, ForwardSpringDamping);
    SpringDamp(DeltaTime, aStrafe, RawJoyRight, StrafeSpringDamping);
    //return;    
}

function Accelerate(float DeltaTime, out float outAccelVar, float inputVal, out InputAccelData accelData, optional float associatedInputVal, optional float associatedValThreshold)
{
    local float absInputVal, combinedInputVal;

    // End:0x1B
    if(accelData.Enabled == false)
    {
        return;
    }
    absInputVal = Abs(inputVal);
    combinedInputVal = absInputVal + Abs(associatedInputVal);
    // End:0xCC
    if(combinedInputVal > accelData.accelInputThreshold)
    {
        // End:0x99
        if(accelData.currAccelPct < 1.0000000)
        {
            accelData.currAccelPct += (DeltaTime / accelData.accelRampUptime);
        }
        // End:0xC9
        if(accelData.currAccelPct > 1.0000000)
        {
            accelData.currAccelPct = 1.0000000;
        }        
    }
    else
    {
        // End:0x121
        if(accelData.currAccelPct > 0.0000000)
        {
            accelData.currAccelPct -= ((accelData.fadeDownMultiplier * DeltaTime) / accelData.accelRampUptime);
        }
        // End:0x151
        if(accelData.currAccelPct < 0.0000000)
        {
            accelData.currAccelPct = 0.0000000;
        }
    }
    // End:0x190
    if(outAccelVar != 0.0000000)
    {
        outAccelVar *= (1.0000000 + (accelData.accelMultiPlier * accelData.currAccelPct));
    }
    //return;    
}

function float GetValFromInputCurvePoints(float Val, array<InputCurvePointInfo> InputCurvePoints)
{
    local int I;
    local float origVal;

    origVal = Val;
    Val = Abs(Val);
    I = 0;
    J0x1F:

    // End:0x103 [Loop If]
    if(I < (InputCurvePoints.Length - 1))
    {
        // End:0xF9
        if(Val < InputCurvePoints[I + 1].RawVal)
        {
            Val = InputCurvePoints[I].OutVal + (((Val - InputCurvePoints[I].RawVal) * (InputCurvePoints[I + 1].OutVal - InputCurvePoints[I].OutVal)) / (InputCurvePoints[I + 1].RawVal - InputCurvePoints[I].RawVal));
            // [Explicit Break]
            goto J0x103;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    J0x103:

    // End:0x11F
    if(origVal < 0.0000000)
    {
        Val = -Val;
    }
    return Val;
    //return ReturnValue;    
}

function CurveAccel(out float Val, SpringDampingData SpringData, array<InputCurvePointInfo> InputCurvePoints)
{
    // End:0x77
    if(SpringData.bCurveAccelEnabled == true)
    {
        // End:0x4B
        if(SpringData.bUseCubicCurveAccel == true)
        {
            Val = GetValFromInputCurvePoints(Val, InputCurvePoints);            
        }
        else
        {
            Val = ((Val < float(0)) ? float(-1) * Square(Val) : Square(Val));
        }
    }
    //return;    
}

function SpringDamp(float DeltaTime, out float endVal, out float RawVal, out SpringDampingData SpringData)
{
    local float Delta, actualDeltaTime;
    local int numIter, I;
    local float TimeScale;

    // End:0x19
    if(SpringData.bSpringEnabled == false)
    {
        return;
    }
    TimeScale = 100.0000000 * DeltaTime;
    endVal = endVal / TimeScale;
    actualDeltaTime = DeltaTime;
    // End:0x62
    if(actualDeltaTime < FRAMESPERSEC)
    {
        actualDeltaTime = FRAMESPERSEC;
    }
    numIter = int(actualDeltaTime / FRAMESPERSEC);
    I = 0;
    J0x7D:

    // End:0x216 [Loop If]
    if(I < numIter)
    {
        // End:0xD8
        if(Abs(RawVal) == 0.0000000)
        {
            SpringData.startVal *= SpringData.letGoDecelMultiplier;
            SpringData.currDelta = 0.0000000;            
        }
        else
        {
            Delta = endVal - SpringData.startVal;
            SpringData.currDelta = (Delta * SpringData.accelMultiPlier) + (SpringData.currDelta * SpringData.decelMultiplier);
            // End:0x18A
            if(SpringData.currDelta > SpringData.MaxDelta)
            {
                SpringData.currDelta = SpringData.MaxDelta;                
            }
            else
            {
                // End:0x1D4
                if(SpringData.currDelta < -SpringData.MaxDelta)
                {
                    SpringData.currDelta = -SpringData.MaxDelta;
                }
            }
            SpringData.startVal += SpringData.currDelta;
        }
        endVal = SpringData.startVal;
        I++;
        // [Loop Continue]
        goto J0x7D;
    }
    endVal = endVal * TimeScale;
    //return;    
}

function GetShotAssistInfo(out Actor targetActor, out Vector assistLoc, out float shotDegreeRange, out float ShotAssistDisableRadius)
{
    // End:0x2D
    if(int(Outer.WorldInfo.NetMode) != int(NM_Standalone))
    {
        targetActor = none;
        return;
    }
    targetActor = lastAimAssistTarget;
    assistLoc = lastAimAssistTargetLoc;
    shotDegreeRange = AimAssistParams.ShotAssistDegreeCheat;
    ShotAssistDisableRadius = AimAssistParams.ShotAssistDisableRadius;
    //return;    
}

function Actor GetPlayerTarget(out Vector HitLocation, out Vector TargetLocation, out Vector CamLoc, out Rotator CamRot)
{
    local Vector EndPt, HitNormal, LookAt, BestBoneLocation, CurrentBoneLocation;

    local Actor HitActor;
    local Vector LineCheckExtent;
    local float LineCheckWidth, CurrDistance, BestDistance;
    local Pawn hitPawn;
    local SPGriffonPawnPersistent GriffonPawn;
    local int I, BonesToCheck;
    local name BestBoneName;
    local SPAIController HitSPAIController;

    HitActor = none;
    // End:0x2A
    if(AimAssistParams.bEnableSubTargets)
    {
        BonesToCheck = DefaultPawnTargetInfo.Length;        
    }
    else
    {
        BonesToCheck = 1;
    }
    // End:0x2C4
    if(Outer.Pawn != none)
    {
        Outer.GetPlayerViewPoint(CamLoc, CamRot);
        LookAt = Normal(Vector(CamRot));
        EndPt = CamLoc + (LookAt * AimAssistParams.MaxTargetDist);
        LineCheckWidth = AimAssistParams.LineCheckWidth;
        LineCheckExtent.X = LineCheckWidth;
        LineCheckExtent.Y = LineCheckWidth;
        LineCheckExtent.Z = LineCheckWidth;
        HitActor = Outer.Trace(HitLocation, HitNormal, EndPt, CamLoc, true, LineCheckExtent,,, false);
        GriffonPawn = SPGriffonPawnPersistent(HitActor);
        // End:0x13C
        if(GriffonPawn != none)
        {
            return none;
        }
        hitPawn = Pawn(HitActor);
        // End:0x2B2
        if(hitPawn != none)
        {
            HitSPAIController = SPAIController(hitPawn.Controller);
            // End:0x2A8
            if((HitSPAIController == none) || !HitSPAIController.IsFriendly(Outer.Pawn.Controller))
            {
                BestDistance = 20000000.0000000;
                BestBoneLocation = HitLocation;
                BestBoneName = 'None';
                I = 0;
                J0x1DC:

                // End:0x287 [Loop If]
                if(I < BonesToCheck)
                {
                    CurrentBoneLocation = hitPawn.Mesh.GetBoneLocation(SPPawn(hitPawn).GetDefaultBoneName());
                    CurrDistance = VSize(HitLocation - CurrentBoneLocation);
                    // End:0x27D
                    if(CurrDistance < BestDistance)
                    {
                        BestDistance = CurrDistance;
                        BestBoneLocation = CurrentBoneLocation;
                        BestBoneName = SPPawn(hitPawn).GetDefaultBoneName();
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x1DC;
                }
                TargetLocation = BestBoneLocation;
                // End:0x2A5
                if(BestBoneName != 'None')
                {
                }                
            }
            else
            {
                HitActor = none;
            }            
        }
        else
        {
            // End:0x2C4
            if(HitActor != none)
            {
                HitActor = none;
            }
        }
    }
    return HitActor;
    //return ReturnValue;    
}

function bool AdjustRotationForAimAssist(float DeltaTime, out float NewDeltaYaw, out float NewDeltaPitch)
{
    local Actor HitActor;
    local Vector HitLocation, TargetLocation, ToTargetDelta, cameraLoc, NextLocDelta;

    local Rotator RotToTarget, ToTargetDeltaRot, cameraRot;
    local Vector XAxis, YAxis, ZAxis;
    local float fStrafeYawAng;
    local int ExtraStrafeAng;
    local float velScale, combinedStrafeAngleGain, RampScale, StrafeGainScale, ByDistanceScaleValue;

    // End:0x26
    if(int(Outer.WorldInfo.NetMode) != int(NM_Standalone))
    {
        return false;
    }
    HitActor = GetPlayerTarget(HitLocation, TargetLocation, cameraLoc, cameraRot);
    RampScale = 1.0000000;
    // End:0x82
    if(HitActor != none)
    {
        lastAimAssistTime = Outer.WorldInfo.TimeSeconds;        
    }
    else
    {
        // End:0x12E
        if((lastAimAssistTarget != none) && AimAssistParams.delayTargetLoss != 0.0000000)
        {
            RampScale = (Outer.WorldInfo.TimeSeconds - lastAimAssistTime) / AimAssistParams.delayTargetLoss;
            // End:0x12E
            if(RampScale < 1.0000000)
            {
                HitActor = lastAimAssistTarget;
                TargetLocation = HitActor.Location;
                RampScale = FClamp(1.0000000 - RampScale, 0.0000000, 1.0000000);
            }
        }
    }
    lastAimAssistTarget = HitActor;
    // End:0x543
    if((HitActor != none) && (SPPawn(HitActor) != none) || Class'SPAIController'.static.IsAPhysicsObject(HitActor))
    {
        lastAimAssistTargetLoc = TargetLocation;
        GetAxes(cameraRot, XAxis, YAxis, ZAxis);
        ToTargetDelta = lastAimAssistTargetLoc - cameraLoc;
        RotToTarget = Rotator(ToTargetDelta);
        // End:0x238
        if(AimAssistParams.ScaleByDistance > 0.0010000)
        {
            ByDistanceScaleValue = FMin(VSize(ToTargetDelta), AimAssistParams.ScaleByDistance);
            ByDistanceScaleValue = AimAssistParams.MinScaleByDistanceAmt + (((1.0000000 - AimAssistParams.MinScaleByDistanceAmt) * ByDistanceScaleValue) / AimAssistParams.ScaleByDistance);            
        }
        else
        {
            ByDistanceScaleValue = 1.0000000;
        }
        ToTargetDeltaRot = Normalize(RotToTarget - cameraRot);
        velScale = Abs(float(ToTargetDeltaRot.Yaw)) / ((AimAssistParams.YawDegreeAssistRange * float(65536)) / float(360));
        velScale = FClamp(1.0000000 - velScale, 0.0000000, 1.0000000);
        StrafeGainScale = velScale;
        velScale = 1.0000000 - (((AimAssistParams.YawAssistMaxScaleDown * velScale) * RampScale) * ByDistanceScaleValue);
        fStrafeYawAng = Abs(Outer.Pawn.Velocity Dot YAxis) / AimAssistParams.StrafeGainClampSpeed;
        fStrafeYawAng = FClamp(fStrafeYawAng, 0.0000000, 1.0000000);
        fStrafeYawAng *= AimAssistParams.StrafeTargetGain;
        // End:0x3B3
        if(SPPawn(Outer.Pawn).bDodging)
        {
            fStrafeYawAng = FClamp(fStrafeYawAng + AimAssistParams.DodgeGain, 0.0000000, 1.0000000);
            RampScale = 1.0000000;
        }
        NextLocDelta = (HitLocation + (((lastAimAssistTargetLoc + (HitActor.Velocity * DeltaTime)) - HitLocation) * fStrafeYawAng)) - (cameraLoc + (Outer.Pawn.Velocity * DeltaTime));
        fStrafeYawAng = Atan(NextLocDelta Dot YAxis, NextLocDelta Dot XAxis);
        fStrafeYawAng = FClamp(fStrafeYawAng, -3.1415930 / 16.0000000, 3.1415930 / 16.0000000);
        ExtraStrafeAng = int((fStrafeYawAng * float(32768)) / 3.1415930);
        combinedStrafeAngleGain = AimAssistParams.StrafeAngleGain * StrafeGainScale;
        NewDeltaYaw *= velScale;
        NewDeltaYaw += ((((float(ExtraStrafeAng) - NewDeltaYaw) * combinedStrafeAngleGain) * RampScale) * ByDistanceScaleValue);
        velScale = Abs(float(ToTargetDeltaRot.Pitch)) / ((AimAssistParams.YawDegreeAssistRange * float(65536)) / float(360));
        velScale = FClamp(velScale, 1.0000000 - AimAssistParams.PitchAssistMaxScaleDown, 1.0000000);
        NewDeltaPitch *= velScale;
        return true;        
    }
    else
    {
        lastAimAssistTarget = none;
        return false;
    }
    //return ReturnValue;    
}

function ProcessOverrides(float DeltaTime)
{
    local float scaleVal, oneMinusScaleVal, tempScaleVal, saveATurn, saveALookUp;

    local Vector scratchVector, CamLoc;
    local Rotator scratchRot, CamRot;
    local float maxJSAmp, timeVal;
    local bool bTransToRecoveryMode;

    // End:0x19
    if(Outer.CanIDebug())
    {
        return;
    }
    bTransToRecoveryMode = false;
    // End:0xF4
    if(orControls.overrideState == 0)
    {
        // End:0xF1
        if(AimAssistParams.YawDegreeAssistRange != 0.0000000)
        {
            saveATurn = Abs(aTurn);
            saveALookUp = Abs(aLookUp);
            // End:0xF1
            if(ConsolePandoraPlayerInput(self) == none)
            {
                // End:0xF1
                if(AdjustRotationForAimAssist(DeltaTime, aTurn, aLookUp))
                {
                    // End:0xC2
                    if(saveATurn > 0.0000100)
                    {
                        TurnAcceleration.currAccelPct *= (Abs(aTurn) / saveATurn);
                    }
                    // End:0xF1
                    if(saveALookUp > 0.0000100)
                    {
                        PitchAcceleration.currAccelPct *= (Abs(aLookUp) / saveALookUp);
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x460
        if(orControls.overrideState == 1)
        {
            timeVal = FMin((orControls.markTime + orControls.DeltaTime) - (Outer.WorldInfo.TimeSeconds - DeltaTime), DeltaTime);
            scaleVal = FClamp(1.0000000 - (((Outer.WorldInfo.TimeSeconds - DeltaTime) - orControls.markTime) / orControls.DeltaTime), 0.0000000, 1.0000000);
            // End:0x376
            if(scaleVal > 0.0000000)
            {
                tempScaleVal = scaleVal * scaleVal;
                scaleVal = (scaleVal + tempScaleVal) * 0.5000000;
                // End:0x297
                if(orControls.recoverTargetActorSet)
                {
                    aTurn = (float(orControls.rotVel.Yaw) * scaleVal) * timeVal;
                    aLookUp = (float(orControls.rotVel.Pitch) * scaleVal) * timeVal;
                    PitchAcceleration.currAccelPct = 1.0000000;
                    TurnAcceleration.currAccelPct = 1.0000000;                    
                }
                else
                {
                    orControls.explicitRecoverRot.Yaw += int(aTurn);
                    aTurn = ((float(orControls.rotVel.Yaw) * scaleVal) * timeVal) + aTurn;
                    orControls.explicitRecoverRot.Pitch += int(aLookUp);
                    aLookUp = ((float(orControls.rotVel.Pitch) * scaleVal) * timeVal) + aLookUp;
                    orControls.explicitRecoverRot = Normalize(orControls.explicitRecoverRot);
                }
            }
            // End:0x460
            if((Outer.WorldInfo.TimeSeconds - orControls.markTime) >= orControls.DeltaTime)
            {
                // End:0x43C
                if(!orControls.bDisableRecovery)
                {
                    orControls.overrideState = 2;
                    bTransToRecoveryMode = true;
                    DeltaTime = DeltaTime - timeVal;
                    orControls.markTime += orControls.DeltaTime;
                    Outer.GetPlayerViewPoint(CamLoc, CamRot);                    
                }
                else
                {
                    orControls.recoverTargetActor = none;
                    orControls.overrideState = 0;
                }
            }
        }
    }
    // End:0x88D
    if(orControls.overrideState == 2)
    {
        maxJSAmp = FMax(FMax(Abs(RawJoyLookRight), Abs(RawJoyLookUp)), FMax(Abs(RawJoyRight), Abs(RawJoyUp)));
        tempScaleVal = FMin((orControls.markTime + orControls.recoverTime) - (Outer.WorldInfo.TimeSeconds - DeltaTime), DeltaTime);
        timeVal = ((Outer.WorldInfo.TimeSeconds - DeltaTime) + tempScaleVal) - orControls.markTime;
        scaleVal = FClamp(timeVal / orControls.recoverTime, 0.0000000, 1.0000000);
        timeVal = orControls.recoverTime - tempScaleVal;
        // End:0x869
        if(scaleVal <= 1.0000000)
        {
            Outer.GetPlayerViewPoint(CamLoc, CamRot);
            // End:0x72D
            if(orControls.recoverTargetActorSet)
            {
                // End:0x5E0
                if(orControls.recoverTargetActor == none)
                {
                    orControls.overrideState = 0;
                    return;
                }
                scratchVector = orControls.recoverTargetActor.Location - CamLoc;
                scratchRot = Rotator(scratchVector);
                scratchRot = Normalize(scratchRot - CamRot);
                scratchRot.Pitch = -CamRot.Pitch;
                scratchRot = scratchRot / timeVal;
                scaleVal = 1.0000000 - (1.5000000 * Abs(0.5000000 - scaleVal));
                oneMinusScaleVal = 1.0000000 - scaleVal;
                aLookUp = ((float(scratchRot.Pitch) * scaleVal) * tempScaleVal) + (aLookUp * oneMinusScaleVal);
                scaleVal = (1.0000000 - maxJSAmp) * scaleVal;
                oneMinusScaleVal = 1.0000000 - scaleVal;
                aTurn = ((float(scratchRot.Yaw) * scaleVal) * tempScaleVal) + (aTurn * oneMinusScaleVal);                
            }
            else
            {
                scratchRot = Normalize(orControls.explicitRecoverRot - CamRot);
                // End:0x7CB
                if(!bTransToRecoveryMode)
                {
                    orControls.explicitRecoverRot.Yaw += int(aTurn);
                    orControls.explicitRecoverRot.Pitch += int(aLookUp);
                    orControls.explicitRecoverRot = Normalize(orControls.explicitRecoverRot);
                }
                scaleVal = scaleVal * scaleVal;
                saveATurn = float(scratchRot.Yaw) * scaleVal;
                saveALookUp = float(scratchRot.Pitch) * scaleVal;
                aTurn += saveATurn;
                aLookUp += saveALookUp;
            }
            // End:0x866
            if(DeltaTime > tempScaleVal)
            {
                orControls.recoverTargetActor = none;
                orControls.overrideState = 0;
            }            
        }
        else
        {
            orControls.recoverTargetActor = none;
            orControls.overrideState = 0;
        }
    }
    //return;    
}

function SetOverrideRotVel(Rotator newRotDelta, float deltaVelTime, Actor recoverTargetActor, float recoverTime, bool bDisableRecovery, optional int overrideLevel = 5)
{
    local Vector CamLoc;
    local Rotator CamRot;

    // End:0x1FD
    if((orControls.overrideState != 1) || overrideLevel >= orControls.overrideLevel)
    {
        // End:0x49
        if(deltaVelTime == 0.0000000)
        {
            return;
        }
        Outer.GetPlayerViewPoint(CamLoc, CamRot);
        orControls.overrideLevel = overrideLevel;
        orControls.rotVel.Yaw = int((2.5000000 * float(newRotDelta.Yaw)) / deltaVelTime);
        orControls.rotVel.Pitch = int((2.5000000 * float(newRotDelta.Pitch)) / deltaVelTime);
        orControls.markTime = Outer.WorldInfo.TimeSeconds;
        orControls.DeltaTime = deltaVelTime;
        // End:0x177
        if(((orControls.overrideState != 0) && !bDisableRecovery) && !orControls.bDisableRecovery)
        {            
        }
        else
        {
            orControls.recoverTargetActor = recoverTargetActor;
            orControls.explicitRecoverRot = CamRot;
            orControls.recoverTime = recoverTime;
            orControls.bDisableRecovery = bDisableRecovery;
            orControls.recoverTargetActorSet = recoverTargetActor != none;
        }
        orControls.overrideState = 1;
    }
    //return;    
}

simulated exec function Jump()
{
    // End:0x19
    if(Outer.IsJumpingInputIgnored())
    {
        return;
    }
    // End:0x9A
    if((PlayerPawn(Outer.Pawn) != none) && !PlayerPawn(Outer.Pawn).GetIsPartiallyLookingDownSite())
    {
        // End:0x94
        if(Outer.Pawn.bIsCrouched)
        {
            Outer.bDuck = 0;
            bHoldDuck = false;
        }
        super.Jump();
    }
    //return;    
}

simulated exec function ToggleDuck()
{
    // End:0x19
    if(Outer.IsCrouchingInputIgnored())
    {
        return;
    }
    // End:0xF5
    if(SPPawn(Outer.Pawn) != none)
    {
        // End:0x58
        if(bHoldDuck)
        {
            bHoldDuck = false;
            Outer.bDuck = 0;
            return;
        }
        // End:0xF5
        if(((Outer.WorldInfo.TimeSeconds > (Outer.LastDuckTime + 0.5000000)) && !Outer.GetSprint()) && !Outer.IsInWerewolfTackleState())
        {
            Outer.bDuck = 1;
            Outer.EnableDuckDisplay(0.0000000);
            bHoldDuck = true;
        }
    }
    //return;    
}

simulated exec function Duck()
{
    // End:0x19
    if(Outer.IsCrouchingInputIgnored())
    {
        return;
    }
    // End:0xC8
    if(SPPawn(Outer.Pawn) != none)
    {
        // End:0xC8
        if(((Outer.WorldInfo.TimeSeconds > (Outer.LastDuckTime + 0.5000000)) && !Outer.GetSprint()) && !Outer.IsInWerewolfTackleState())
        {
            Outer.bDuck = 1;
            Outer.EnableDuckDisplay(0.0000000);
        }
    }
    //return;    
}

simulated exec function UnDuck()
{
    // End:0x39
    if((SPPawn(Outer.Pawn) != none) && !bHoldDuck)
    {
        Outer.bDuck = 0;
    }
    //return;    
}

simulated exec function Sprint()
{
    // End:0x19
    if(Outer.IsSprintInputIgnored())
    {
        return;
    }
    // End:0x90
    if(Outer.IsAllowedToSprint())
    {
        // End:0x7C
        if(Outer.Pawn != none)
        {
            // End:0x7C
            if(Outer.Pawn.bIsCrouched)
            {
                Outer.bDuck = 0;
                bHoldDuck = false;
            }
        }
        Outer.OnSprintStartSuccess();
    }
    //return;    
}

simulated exec function UnSprint()
{
    // End:0x19
    if(Outer.IsSprintInputIgnored())
    {
        return;
    }
    // End:0xF6
    if(((Outer.Pawn != none) && SPPawn(Outer.Pawn) != none) && Outer.GetSprint())
    {
        // End:0xE4
        if(((Outer.WorldInfo.TimeSeconds - Outer.LastSprintTime) > Outer.SprintDurationMin) || VSize(SPPawn(Outer.Pawn).Velocity) < 1.0000000)
        {
            Outer.OnSprintStop();            
        }
        else
        {
            Outer.bForceSprintExtension = true;
        }
    }
    //return;    
}

simulated exec function DodgeForward()
{
    // End:0x2C
    if(SPPawn(Outer.Pawn) != none)
    {
        Outer.forceDodgeMove = 3;
    }
    //return;    
}

simulated exec function DodgeBackward()
{
    // End:0x2C
    if(SPPawn(Outer.Pawn) != none)
    {
        Outer.forceDodgeMove = 4;
    }
    //return;    
}

simulated exec function DodgeLeft()
{
    // End:0x2C
    if(SPPawn(Outer.Pawn) != none)
    {
        Outer.forceDodgeMove = 1;
    }
    //return;    
}

simulated exec function DodgeRight()
{
    // End:0x2C
    if(SPPawn(Outer.Pawn) != none)
    {
        Outer.forceDodgeMove = 2;
    }
    //return;    
}

simulated exec function DodgeCombine()
{
    // End:0x2C
    if(SPPawn(Outer.Pawn) != none)
    {
        Outer.bDodgeCombineDown = true;
    }
    //return;    
}

simulated exec function UnDodgeCombine()
{
    // End:0x2C
    if(SPPawn(Outer.Pawn) != none)
    {
        Outer.bDodgeCombineDown = false;
    }
    //return;    
}

simulated exec function ZoomIn()
{
    PandoraPlayerCamera(Outer.PlayerCamera).bZoomIn = true;
    //return;    
}

simulated exec function StopZoomIn()
{
    PandoraPlayerCamera(Outer.PlayerCamera).bZoomIn = false;
    //return;    
}

simulated exec function ZoomOut()
{
    PandoraPlayerCamera(Outer.PlayerCamera).bZoomOut = true;
    //return;    
}

simulated exec function StopZoomOut()
{
    PandoraPlayerCamera(Outer.PlayerCamera).bZoomOut = false;
    //return;    
}

simulated exec function Siphon()
{
    local SPPawn SPPawn;
    local PlayerPawn PlayerPawn;

    // End:0x19
    if(Outer.IsAnimusSiphonInputIgnored())
    {
        return;
    }
    SPPawn = SPPawn(Outer.Pawn);
    PlayerPawn = PlayerPawn(Outer.Pawn);
    // End:0x67
    if((SPPawn == none) || PlayerPawn == none)
    {
        return;
    }
    // End:0x1B7
    if(((int(PlayerPawn.m_eGrenadeState) == int(0)) && !PlayerPawn.bInEquip) && !PlayerPawn.bInUnequip)
    {
        // End:0x1A3
        if((PlayerPawn.LifeForce < PlayerPawn.maxLifeForce) || PlayerPawn.Health < PlayerPawn.HealthMax)
        {
            // End:0x17C
            if(SPPawn.IsReloading())
            {
                // End:0x17C
                if((Outer.Pawn.Weapon != none) && SPWeapon(Outer.Pawn.Weapon) != none)
                {
                    SPWeapon(Outer.Pawn.Weapon).ForceInterruptReload();
                }
            }
            Outer.bSiphonRequest = true;
            SPPawn.m_bResetDeathFromSiphon = true;            
        }
        else
        {
            PlayerPawn.SetAnimusRedGlowForFullAnimus();
        }
    }
    //return;    
}

simulated exec function UnSiphon()
{
    local SPPawn SPPawn;

    SPPawn = SPPawn(Outer.Pawn);
    // End:0x5E
    if((SPPawn != none) && Outer.bSiphonRequest)
    {
        Outer.bSiphonRequest = false;
        SPPawn.m_bResetDeathFromSiphon = false;
    }
    //return;    
}

simulated exec function Heal()
{
    // End:0x2C
    if(SPPawn(Outer.Pawn) != none)
    {
        Outer.bHealRequest = true;
    }
    //return;    
}

simulated exec function UnHeal()
{
    // End:0x41
    if((SPPawn(Outer.Pawn) != none) && Outer.bHealRequest)
    {
        Outer.bHealRequest = false;
    }
    //return;    
}

simulated exec function CollectHealContext()
{
    local PlayerPawn myPawn;

    myPawn = PlayerPawn(Outer.Pawn);
    // End:0x27
    if(myPawn == none)
    {
        return;
    }
    // End:0x5C
    if(myPawn.bActiveCollect && Outer.bCanSiphon)
    {
        Siphon();        
    }
    else
    {
        // End:0x79
        if(myPawn.bActiveHeal)
        {
            Heal();
        }
    }
    //return;    
}

simulated exec function UnCollectHealContext()
{
    UnSiphon();
    UnHeal();
    //return;    
}

simulated exec function ActiveCollect()
{
    local PlayerPawn myPawn;

    myPawn = PlayerPawn(Outer.Pawn);
    // End:0x27
    if(myPawn == none)
    {
        return;
    }
    myPawn.bActiveCollect = !myPawn.bActiveCollect;
    //return;    
}

simulated exec function ActiveHeal()
{
    local PlayerPawn myPawn;

    myPawn = PlayerPawn(Outer.Pawn);
    // End:0x48
    if(myPawn != none)
    {
        myPawn.bActiveHeal = !myPawn.bActiveHeal;
    }
    //return;    
}

simulated event int QueryCanSiphon()
{
    local PlayerPawn thePlayer;
    local SPHudScene hudUIScene;

    thePlayer = PlayerPawn(Outer.Pawn);
    // End:0x7B
    if((thePlayer != none) && thePlayer.playerHud != none)
    {
        hudUIScene = thePlayer.playerHud.HudScene;
        // End:0x7B
        if(hudUIScene != none)
        {
            hudUIScene.HealthBarFadeIn();
        }
    }
    // End:0xFA
    if(thePlayer != none)
    {
        // End:0xB0
        if(Outer.bCanSiphon && thePlayer.bActiveCollect)
        {
            return 1;
        }
        // End:0xFA
        if((thePlayer.LifeForce >= thePlayer.maxLifeForce) && thePlayer.Health == thePlayer.HealthMax)
        {
            return 1;
        }
    }
    return 0;
    //return ReturnValue;    
}

simulated event int CanDoMinigameInput()
{
    // End:0x59
    if(PlayerPawn(Outer.Pawn) != none)
    {
        // End:0x59
        if((Outer.tackleMinigameManager.IsMiniGameInProgress() == true) || Outer.IsBeingTackled())
        {
            return 1;
        }
    }
    return 0;
    //return ReturnValue;    
}

simulated event int CanDoKillshotInput()
{
    // End:0x40
    if(PlayerPawn(Outer.Pawn) != none)
    {
        // End:0x40
        if(Outer.tackleMinigameManager.IsKillshotInProgress() == true)
        {
            return 1;
        }
    }
    return 0;
    //return ReturnValue;    
}

simulated event int CanDoPDAInput()
{
    // End:0x26
    if(int(Outer.WorldInfo.NetMode) == int(NM_Standalone))
    {
        return 1;
    }
    return 0;
    //return ReturnValue;    
}

function SPBaseWerewolfAIController FindClosestWWController()
{
    local SPBaseWerewolfAIController BestAIController;
    local SPBaseWerewolfPawnPersistent CurrWWPawn, BestWWPawn;
    local float MinDistance, TargetDistance;

    MinDistance = 10000000.0000000;
    BestAIController = none;
    // End:0x93
    foreach Outer.WorldInfo.AllPawns(Class'SPBaseWerewolfPawnPersistent', CurrWWPawn)
    {
        TargetDistance = VSize(CurrWWPawn.Location - Outer.Pawn.Location);
        // End:0x92
        if(TargetDistance < MinDistance)
        {
            MinDistance = TargetDistance;
            BestWWPawn = CurrWWPawn;
        }        
    }    
    // End:0xB9
    if(BestWWPawn != none)
    {
        BestAIController = SPBaseWerewolfAIController(BestWWPawn.Controller);
    }
    return BestAIController;
    //return ReturnValue;    
}

simulated exec function tmgon()
{
    local SPBaseWerewolfAIController BestAIController;

    BestAIController = FindClosestWWController();
    // End:0x96
    if(((BestAIController != none) && BestAIController.m_WerewolfPawn != none) && BestAIController.m_WerewolfPawn.HasConcentratedArmDamage() == false)
    {
        BestAIController.bForceTackle = true;
        BestAIController.LastForceTackleTime = Outer.WorldInfo.TimeSeconds - 3.0000000;
    }
    //return;    
}

simulated exec function tentaclehit()
{
    local PlayerPawn pPawn;

    pPawn = PlayerPawn(Outer.Pawn);
    // End:0x48
    if(pPawn != none)
    {
        pPawn.m_bTentacleCollisionViewOn = !pPawn.m_bTentacleCollisionViewOn;
    }
    //return;    
}

simulated exec function ForceWWKnife()
{
    local SPBaseWerewolfAIController BestAIController;

    BestAIController = FindClosestWWController();
    // End:0x69
    if(BestAIController != none)
    {
        BestAIController.bForceHAR = !BestAIController.bForceHAR;
        Outer.WorldInfo.SPAllowHARMinigameTest = BestAIController.bForceHAR;
    }
    //return;    
}

function UpdateControllerConfig(int ConfigId)
{
    local int I, J;
    local array<ButtonBindingInfo> currConfig;

    switch(ConfigId)
    {
        // End:0x1B
        case 2:
            currConfig = PandoraLegacyCtrlConfig;
            // End:0x7B
            break;
        // End:0x2D
        case 1:
            currConfig = PandoraSouthPawCtrlConfig;
            // End:0x7B
            break;
        // End:0x40
        case 3:
            currConfig = PandoraLegacySouthPawCtrlConfig;
            // End:0x7B
            break;
        // End:0x53
        case 4:
            currConfig = PandoraTacticalCtrlConfig;
            // End:0x7B
            break;
        // End:0x66
        case 5:
            currConfig = PandoraAssaultCtrlConfig;
            // End:0x7B
            break;
        // End:0x6A
        case 0:
        // End:0xFFFF
        default:
            currConfig = PandoraDefaultCtrlConfig;
            // End:0x7B
            break;
            break;
    }
    J = 0;
    J0x82:

    // End:0x11B [Loop If]
    if(J < currConfig.Length)
    {
        I = 0;
        J0x99:

        // End:0x111 [Loop If]
        if(I < Bindings.Length)
        {
            // End:0x107
            if(Bindings[I].Name == currConfig[J].Name)
            {
                Bindings[I].Command = currConfig[J].Command;
            }
            I++;
            // [Loop Continue]
            goto J0x99;
        }
        J++;
        // [Loop Continue]
        goto J0x82;
    }
    //return;    
}

function string GetCommandButtonName(string Command, optional int ConfigId = 0, optional bool bFontLookupName = false)
{
    local int J;
    local array<ButtonBindingInfo> currConfig;
    local string ButtonName;

    ButtonName = "";
    switch(ConfigId)
    {
        // End:0x2D
        case 2:
            currConfig = PandoraLegacyCtrlConfigButtonMaps;
            // End:0x8D
            break;
        // End:0x3F
        case 1:
            currConfig = PandoraSouthPawCtrlConfigButtonMaps;
            // End:0x8D
            break;
        // End:0x52
        case 3:
            currConfig = PandoraLegacySouthPawCtrlConfigButtonMaps;
            // End:0x8D
            break;
        // End:0x65
        case 4:
            currConfig = PandoraTacticalCtrlConfigButtonMaps;
            // End:0x8D
            break;
        // End:0x78
        case 5:
            currConfig = PandoraAssaultCtrlConfigButtonMaps;
            // End:0x8D
            break;
        // End:0x7C
        case 0:
        // End:0xFFFF
        default:
            currConfig = PandoraDefaultCtrlConfigButtonMaps;
            // End:0x8D
            break;
            break;
    }
    J = 0;
    J0x94:

    // End:0x13F [Loop If]
    if(J < currConfig.Length)
    {
        // End:0x135
        if(Command ~= currConfig[J].Command)
        {
            // End:0x114
            if((currConfig[J].ButtonFontName != 'None') && bFontLookupName)
            {
                ButtonName = string(currConfig[J].ButtonFontName);                
            }
            else
            {
                ButtonName = string(currConfig[J].Name);
            }
            // [Explicit Break]
            goto J0x13F;
        }
        J++;
        // [Loop Continue]
        goto J0x94;
    }
    J0x13F:

    return ButtonName;
    //return ReturnValue;    
}

function string ProcessButtonToFontMapping(string Str, optional bool bForcePlatformXbox = false)
{
    local int I;
    local string modifiedStr, locsStr;

    // End:0x18
    if(Len(Str) == 0)
    {
        return Str;
    }
    modifiedStr = Str;
    locsStr = Locs(Str);
    I = 0;
    J0x37:

    // End:0x9F [Loop If]
    if(I < Commands.Length)
    {
        // End:0x95
        if(InStr(locsStr, Commands[I]) != -1)
        {
            modifiedStr = ReplaceCommandByFont(Commands[I], Str, bForcePlatformXbox);
            Str = modifiedStr;
        }
        I++;
        // [Loop Continue]
        goto J0x37;
    }
    return modifiedStr;
    //return ReturnValue;    
}

function string ReplaceCommandByFont(string Command, string S, optional bool bForcePlatformXbox = false)
{
    local int I, stickConfig;
    local string ButtonName, modifiedStr;
    local WorldInfo wInfo;
    local array<Button2Font> ButtonFontList;

    wInfo = Class'SPHud'.static.GetWorldInfo();
    // End:0x6B
    if(!wInfo.IsConsoleBuild())
    {
        // End:0x53
        if(bUsingGamepad || bForcePlatformXbox)
        {
            ButtonFontList = XboxButtonFonts;            
        }
        else
        {
            return ProcessPCKeyMapping(Command, S);
        }        
    }
    else
    {
        // End:0x8E
        if(wInfo.IsConsoleBuild(1))
        {
            ButtonFontList = XboxButtonFonts;            
        }
        else
        {
            ButtonFontList = PS3buttonFonts;
        }
    }
    modifiedStr = S;
    stickConfig = int(Outer.ProfileSettings.GetStickConfigOption());
    ButtonName = GetCommandButtonName(Command, stickConfig, true);
    I = 0;
    J0xEC:

    // End:0x152 [Loop If]
    if(I < ButtonFontList.Length)
    {
        // End:0x148
        if(ButtonName ~= ButtonFontList[I].ButtonName)
        {
            modifiedStr = Repl(S, Command, ButtonFontList[I].FontMarkup);
            // [Explicit Break]
            goto J0x152;
        }
        I++;
        // [Loop Continue]
        goto J0xEC;
    }
    J0x152:

    return modifiedStr;
    //return ReturnValue;    
}

function string GetCommandButtonNameByIndex(int Index)
{
    local string Command, ButtonName;
    local int stickConfig;

    ButtonName = "";
    stickConfig = int(Outer.ProfileSettings.GetStickConfigOption());
    // End:0x77
    if((Index >= 0) && Index < Commands.Length)
    {
        Command = Commands[Index];
        ButtonName = GetCommandButtonName(Command, stickConfig, false);
    }
    return ButtonName;
    //return ReturnValue;    
}

function bool DoesKeyBondedCommandMatchThisCommand(int CommandIndex, name KeyName)
{
    local string CommandName, keysBondedCommand, bondedCommand;

    // End:0x69
    if((CommandIndex >= 0) && CommandIndex < Commands.Length)
    {
        CommandName = Commands[CommandIndex];
        bondedCommand = GetBondedCommandFromCommandName(CommandName);
        keysBondedCommand = GetKeysBondedCommand(KeyName);
        // End:0x69
        if(keysBondedCommand == bondedCommand)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function string GetBondedCommandFromCommandName(string CommandName)
{
    local int BindIndex;
    local string KeyCommand, ButtonCommand;

    BindIndex = 0;
    J0x07:

    // End:0x6E [Loop If]
    if(BindIndex < KeyCommandToButtonCommandBindingMaps.Length)
    {
        KeyCommand = KeyCommandToButtonCommandBindingMaps[BindIndex].KeyCommand;
        ButtonCommand = KeyCommandToButtonCommandBindingMaps[BindIndex].ButtonCommand;
        // End:0x64
        if(CommandName == ButtonCommand)
        {
            return KeyCommand;
        }
        ++BindIndex;
        // [Loop Continue]
        goto J0x07;
    }
    return "";
    //return ReturnValue;    
}

simulated function string GetKeysBondedCommand(name KeyName)
{
    local int BindIndex;
    local string Command;

    Command = "";
    BindIndex = 0;
    J0x0F:

    // End:0x65 [Loop If]
    if(BindIndex < Bindings.Length)
    {
        // End:0x5B
        if(Bindings[BindIndex].Name == KeyName)
        {
            Command = Bindings[BindIndex].Command;
        }
        ++BindIndex;
        // [Loop Continue]
        goto J0x0F;
    }
    return Command;
    //return ReturnValue;    
}

simulated function name GetNonControllerBinding(string TheCommand)
{
    local int BindIndex;
    local name Binding, TempBinding;

    BindIndex = 0;
    J0x07:

    // End:0x86 [Loop If]
    if(BindIndex < Bindings.Length)
    {
        // End:0x7C
        if(Bindings[BindIndex].Command == TheCommand)
        {
            TempBinding = Bindings[BindIndex].Name;
            // End:0x71
            if(Class'PandoraPlayerController'.static.IsAXBoxButton(TempBinding))
            {
                // [Explicit Continue]
                goto J0x7C;
                // [Explicit Continue]
                goto J0x7C;
            }
            Binding = TempBinding;
        }
        J0x7C:

        ++BindIndex;
        // [Loop Continue]
        goto J0x07;
    }
    return Binding;
    //return ReturnValue;    
}

simulated function string ProcessPCKeyMapping(string Command, string S)
{
    local string PCKeyCommand, LocalizedKeyVal, Comma;

    LocalizedKeyVal = "[";
    Comma = ", ";
    // End:0x102
    if(Command ~= "movebutton")
    {
        LocalizedKeyVal = LocalizedKeyVal $ (GetLocalizedKeyName("GBA_MoveForward"));
        LocalizedKeyVal = LocalizedKeyVal $ Comma;
        LocalizedKeyVal = LocalizedKeyVal $ (GetLocalizedKeyName("GBA_MoveBackward"));
        LocalizedKeyVal = LocalizedKeyVal $ Comma;
        LocalizedKeyVal = LocalizedKeyVal $ (GetLocalizedKeyName("GBA_StrafeLeft"));
        LocalizedKeyVal = LocalizedKeyVal $ Comma;
        LocalizedKeyVal = LocalizedKeyVal $ (GetLocalizedKeyName("GBA_StrafeRight"));        
    }
    else
    {
        // End:0x176
        if(Command ~= "switchbutton")
        {
            LocalizedKeyVal = LocalizedKeyVal $ (GetLocalizedKeyName("GBA_EquipLeftWeapon"));
            LocalizedKeyVal = LocalizedKeyVal @ (GetLocalizedKeyName("GBA_EquipRightWeapon"));            
        }
        else
        {
            PCKeyCommand = GetBondedCommandFromCommandName(Command);
            LocalizedKeyVal = LocalizedKeyVal $ (GetLocalizedKeyName(PCKeyCommand));
        }
    }
    LocalizedKeyVal = LocalizedKeyVal $ "]";
    return Repl(S, Command, LocalizedKeyVal);
    //return ReturnValue;    
}

simulated function string GetLocalizedKeyName(string Command)
{
    local string NewKeyVal, LocalizedKeyVal;

    NewKeyVal = string(GetNonControllerBinding(Command));
    LocalizedKeyVal = Class'UIScene_BindKeys'.static.GetLocalizedKeyName(NewKeyVal);
    return LocalizedKeyVal;
    //return ReturnValue;    
}

function ResetToDefaultKeyBinding()
{
    local int I, J;

    I = 0;
    J0x07:

    // End:0xA0 [Loop If]
    if(I < Bindings.Length)
    {
        J = 0;
        J0x1E:

        // End:0x96 [Loop If]
        if(J < DefaultBindings.Length)
        {
            // End:0x8C
            if(Bindings[I].Command == DefaultBindings[J].Command)
            {
                Bindings[I].Name = DefaultBindings[J].Name;
            }
            J++;
            // [Loop Continue]
            goto J0x1E;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
