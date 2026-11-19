class ConsolePandoraPlayerInput extends PandoraPlayerInput within ConsolePandoraPlayerController
    transient
    config(Input);

enum eDebugAnalogVariableType
{
    DAVT_UT3,                       // 0
    DAVT_INI,                       // 1
    DAVT_PREV,                      // 2
    DAVT_CUR,                       // 3
    DAVT_MAX                        // 4
};

struct native DebugAnalogVariableStruct
{
    var string VarName;
    var float Value[4];

    structdefaultproperties
    {
        VarName=""
        Value[0]=0.0000000
        Value[1]=0.0000000
        Value[2]=0.0000000
        Value[3]=0.0000000
    }
};

var array<DebugAnalogVariableStruct> debugAnalogVariable;
var config float SensitivityMultiplier;
var config float AnalogSensitivityScaling;
var config float SensitivityMultiplierLow;
var config float SensitivityMultiplierMed;
var config float SensitivityMultiplierHigh;
var config float TurningAccelerationMultiplier;
var config float PitchAccelerationMultiplier;
var config bool bAutoCenterPitch;
/** Whether ViewAcceleration is enabled or not */
var() config bool bViewAccelerationEnabled;
var() config bool bPitchAccelerationEnabled;
var protected config bool bDebugViewAcceleration;
/** Whether TargetFriction is enabled or not */
var() config bool bTargetFrictionEnabled;
var protected config bool bDebugTargetFriction;
var protected bool bAppliedTargetFriction;
var private bool bIsLookingUp;
var private bool bIsLookingDown;
var transient bool bSetStickSensitivity;
var transient bool cdumped;
var bool bDebugShowAnalog;
var float LastTurnTime;
var globalconfig float AutoCenterDelay;
var globalconfig float AutoVehicleCenterSpeed;
var globalconfig float SlowTurnScaling;
/** Threshold above when Yaw Acceleration kicks in */
var() config float ViewAccel_YawThreshold;
var() config float ViewAccel_DiagonalThreshold;
var() config float PitchAccel_PitchThreshold;
/** How fast to start accelerating when the stick is slammed to the edge. It goes to a max of 2.0 over time */
var() config float ViewAccel_BaseMultiplier;
var() private float ViewAccel_CurrMutliplier;
/** How fast to start accelerating when the stick is slammed to the edge. It goes to a max of 2.0 over time */
var() config float PitchAccel_BaseMultiplier;
var() private float PitchAccel_CurrMutliplier;
/** how long you need to hold at edge before the fast acceleration kicks in */
var() config float ViewAccel_TimeToHoldBeforeFastAcceleration;
var private float ViewAccel_TimeHeld;
var() config float PitchAccel_TimeToHoldBeforeFastAcceleration;
var private float PitchAccel_TimeHeld;
/** Amount of twitchy we will handle before just taking the real value of the aTurn.  This basically make the controls feel a lot smoother and not just spastic looking all over the place. */
var() config float ViewAccel_Twitchy;
/** If user hits A when the thumbstick is above this threshold, they will dodge in the direction of their thumbstick */
var() config float Dodge_Threshold;
var private Pawn LastFrictionTarget;
var private float LastFrictionTargetTime;
var private float LastDistToTarget;
var private float LastDistMultiplier;
var private float LastDistFromAimZ;
var private float LastDistFromAimY;
var private float LastFrictionMultiplier;
var private float LastAdhesionAmtY;
var private float LastAdhesionAmtZ;
var private float LastTargetRadius;
var private float LastTargetHeight;
var private float LastDistFromAimYa;
var private float LastDistFromAimZa;
var private float LastAdjustY;
var private float LastAdjustZ;
var private Vector LastCamLoc;
var private Rotator LastDeltaRot;
var config float LeftThumbStickDeadZoneThreshold;
var config float RightThumbStickDeadZoneThreshold;
var config float MagicScaleForSensitivityMiddle;
var config float MagicScaleForSensitivityEdge;
var config float ViewAccel_RampSpeed;
var config float PitchAccel_RampSpeed;
var config float ViewAccel_MaxTurnSpeed;
var config float PitchAccel_MaxTurnSpeed;
var config float ViewAccel_PitchThreshold;
var config float ViewAccel_LookingUpOrDownBoundary;
var config float ViewAccel_BackToCenterBoundary;
var config float ViewAccel_BackToCenterSpeed;
var config float AutoPitchCenterSpeed;
var config float AutoPitchStopAdjustingValue;
var() config float minMouseSensitivity;
var() config float maxMouseSensitivity;
var config float HoverBoardPitchMultiplier;
var int nDebugAnalogSelection;

exec function DebugAnalog(string Cmd, optional int varID = -1, optional float Value = -1.0000000)
{
    local int I, nloop;

    // End:0x41
    if(Cmd ~= "on")
    {
        // End:0x3E
        if(!bDebugShowAnalog)
        {
            bDebugShowAnalog = true;
            DebugInitializeAnalog(true);
        }        
    }
    else
    {
        // End:0x5A
        if(Cmd ~= "log")
        {
            DebugLogAnalogStick();
        }
    }
    nloop = 1;
    J0x61:

    // End:0x2AC [Loop If]
    if(nloop < (debugAnalogVariable.Length + 1))
    {
        // End:0x95
        if(!(varID == 0) || varID == nloop)
        {
            // [Explicit Continue]
            goto J0x2A2;
        }
        I = nloop - 1;
        // End:0x116
        if((Cmd ~= "set") && Value >= float(0))
        {
            debugAnalogVariable[I].Value[2] = debugAnalogVariable[I].Value[3];
            debugAnalogVariable[I].Value[3] = Value;
            // [Explicit Continue]
            goto J0x2A2;
        }
        // End:0x19A
        if(Cmd ~= "swap")
        {
            Value = debugAnalogVariable[I].Value[2];
            debugAnalogVariable[I].Value[2] = debugAnalogVariable[I].Value[3];
            debugAnalogVariable[I].Value[3] = Value;
            // [Explicit Continue]
            goto J0x2A2;
        }
        // End:0x220
        if(Cmd ~= "default")
        {
            Value = debugAnalogVariable[I].Value[3];
            debugAnalogVariable[I].Value[3] = debugAnalogVariable[I].Value[1];
            debugAnalogVariable[I].Value[2] = Value;
            // [Explicit Continue]
            goto J0x2A2;
        }
        // End:0x2A2
        if(Cmd ~= "unreal")
        {
            Value = debugAnalogVariable[I].Value[3];
            debugAnalogVariable[I].Value[3] = debugAnalogVariable[I].Value[0];
            debugAnalogVariable[I].Value[2] = Value;
        }
        J0x2A2:

        nloop++;
        // [Loop Continue]
        goto J0x61;
    }
    nDebugAnalogSelection = varID;
    // End:0x2CD
    if(varID == 0)
    {
        nDebugAnalogSelection = -1;
    }
    //return;    
}

function DebugInitializeAnalog(optional bool onStartup = false)
{
    local int I;

    // End:0x51E
    if(onStartup)
    {
        nDebugAnalogSelection = -1;
        debugAnalogVariable.Remove(0, debugAnalogVariable.Length);
        debugAnalogVariable.Add(11);
        debugAnalogVariable[0].VarName = "AnalogSensitivityScaling";
        debugAnalogVariable[0].Value[0] = 1.0000000;
        debugAnalogVariable[0].Value[1] = AnalogSensitivityScaling;
        debugAnalogVariable[1].VarName = "TurningAccelerationMultiplier";
        debugAnalogVariable[1].Value[0] = 1.0000000;
        debugAnalogVariable[1].Value[1] = TurningAccelerationMultiplier;
        debugAnalogVariable[2].VarName = "PitchAccelerationMultiplier";
        debugAnalogVariable[2].Value[0] = 1.0000000;
        debugAnalogVariable[2].Value[1] = PitchAccelerationMultiplier;
        debugAnalogVariable[3].VarName = "ViewAccel_RampSpeed";
        debugAnalogVariable[3].Value[0] = 0.1000000;
        debugAnalogVariable[3].Value[1] = ViewAccel_RampSpeed;
        debugAnalogVariable[4].VarName = "PitchAccel_RampSpeed";
        debugAnalogVariable[4].Value[0] = 0.1000000;
        debugAnalogVariable[4].Value[1] = PitchAccel_RampSpeed;
        debugAnalogVariable[5].VarName = "ViewAccel_MaxTurnSpeed";
        debugAnalogVariable[5].Value[0] = 3.0000000;
        debugAnalogVariable[5].Value[1] = ViewAccel_MaxTurnSpeed;
        debugAnalogVariable[6].VarName = "PitchAccel_MaxTurnSpeed";
        debugAnalogVariable[6].Value[0] = 3.0000000;
        debugAnalogVariable[6].Value[1] = PitchAccel_MaxTurnSpeed;
        debugAnalogVariable[7].VarName = "ViewAccel_TimeToHoldBeforeFastAcceleration";
        debugAnalogVariable[7].Value[0] = 0.1250000;
        debugAnalogVariable[7].Value[1] = ViewAccel_TimeToHoldBeforeFastAcceleration;
        debugAnalogVariable[8].VarName = "PitchAccel_TimeToHoldBeforeFastAcceleration";
        debugAnalogVariable[8].Value[0] = 0.1250000;
        debugAnalogVariable[8].Value[1] = PitchAccel_TimeToHoldBeforeFastAcceleration;
        debugAnalogVariable[9].VarName = "ViewAccel_BaseMultiplier";
        debugAnalogVariable[9].Value[0] = 1.1000000;
        debugAnalogVariable[9].Value[1] = ViewAccel_BaseMultiplier;
        debugAnalogVariable[10].VarName = "PitchAccel_BaseMultiplier";
        debugAnalogVariable[10].Value[0] = 1.1000000;
        debugAnalogVariable[10].Value[1] = PitchAccel_BaseMultiplier;
        I = 0;
        J0x49D:

        // End:0x51B [Loop If]
        if(I < debugAnalogVariable.Length)
        {
            debugAnalogVariable[I].Value[2] = debugAnalogVariable[I].Value[1];
            debugAnalogVariable[I].Value[3] = debugAnalogVariable[I].Value[1];
            I++;
            // [Loop Continue]
            goto J0x49D;
        }        
    }
    else
    {
        AnalogSensitivityScaling = debugAnalogVariable[0].Value[3];
        TurningAccelerationMultiplier = debugAnalogVariable[1].Value[3];
        PitchAccelerationMultiplier = debugAnalogVariable[2].Value[3];
        ViewAccel_RampSpeed = debugAnalogVariable[3].Value[3];
        PitchAccel_RampSpeed = debugAnalogVariable[4].Value[3];
        ViewAccel_MaxTurnSpeed = debugAnalogVariable[5].Value[3];
        PitchAccel_MaxTurnSpeed = debugAnalogVariable[6].Value[3];
        ViewAccel_TimeToHoldBeforeFastAcceleration = debugAnalogVariable[7].Value[3];
        PitchAccel_TimeToHoldBeforeFastAcceleration = debugAnalogVariable[8].Value[3];
        ViewAccel_BaseMultiplier = debugAnalogVariable[9].Value[3];
        PitchAccel_BaseMultiplier = debugAnalogVariable[10].Value[3];
    }
    //return;    
}

function DebugLogAnalogStick()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x21 [Loop If]
    if(I < debugAnalogVariable.Length)
    {
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function DebugRenderAnalogStick(HUD HUD)
{
    local Canvas Canvas;
    local int I;

    DebugInitializeAnalog();
    Canvas = HUD.Canvas;
    Canvas.SetPos(15.0000000, 25.0000000);
    Canvas.SetDrawColor(5, 230, 255, 255);
    Canvas.DrawText("#)  Variable name                                                                     UT3                   INI                   OLD                   CUR");
    Canvas.DrawText("===========================================================================================");
    Canvas.SetPos(15.0000000, 50.0000000);
    I = 0;
    J0x193:

    // End:0x229 [Loop If]
    if(I < debugAnalogVariable.Length)
    {
        // End:0x1CD
        if(nDebugAnalogSelection == I)
        {
            Canvas.SetDrawColor(5, 230, 255, 255);            
        }
        else
        {
            Canvas.SetDrawColor(255, 255, 255, 255);
        }
        Canvas.DrawText((string(I + 1) $ ")") @ debugAnalogVariable[I].VarName);
        I++;
        // [Loop Continue]
        goto J0x193;
    }
    Canvas.SetPos(300.0000000, 50.0000000);
    I = 0;
    J0x24A:

    // End:0x2F9 [Loop If]
    if(I < debugAnalogVariable.Length)
    {
        // End:0x2AA
        if(debugAnalogVariable[I].Value[0] == debugAnalogVariable[I].Value[1])
        {
            Canvas.SetDrawColor(139, 0, 0, 255);            
        }
        else
        {
            Canvas.SetDrawColor(255, 20, 147, 255);
        }
        Canvas.DrawText(string(debugAnalogVariable[I].Value[0]));
        I++;
        // [Loop Continue]
        goto J0x24A;
    }
    Canvas.SetPos(375.0000000, 50.0000000);
    I = 0;
    J0x31A:

    // End:0x379 [Loop If]
    if(I < debugAnalogVariable.Length)
    {
        Canvas.SetDrawColor(0, 255, 0, 255);
        Canvas.DrawText(string(debugAnalogVariable[I].Value[1]));
        I++;
        // [Loop Continue]
        goto J0x31A;
    }
    Canvas.SetPos(450.0000000, 50.0000000);
    I = 0;
    J0x39A:

    // End:0x4D3 [Loop If]
    if(I < debugAnalogVariable.Length)
    {
        // End:0x3FC
        if(debugAnalogVariable[I].Value[2] == debugAnalogVariable[I].Value[3])
        {
            Canvas.SetDrawColor(255, 255, 0, 0);            
        }
        else
        {
            Canvas.SetDrawColor(255, 255, 0, 255);
        }
        // End:0x49B
        if((debugAnalogVariable[I].Value[1] == debugAnalogVariable[I].Value[3]) && debugAnalogVariable[I].Value[1] == debugAnalogVariable[I].Value[2])
        {
            Canvas.DrawText(" ");
            // [Explicit Continue]
            goto J0x4C9;
        }
        Canvas.DrawText(string(debugAnalogVariable[I].Value[2]));
        J0x4C9:

        I++;
        // [Loop Continue]
        goto J0x39A;
    }
    Canvas.SetPos(525.0000000, 50.0000000);
    I = 0;
    J0x4F4:

    // End:0x62C [Loop If]
    if(I < debugAnalogVariable.Length)
    {
        // End:0x555
        if(debugAnalogVariable[I].Value[1] == debugAnalogVariable[I].Value[3])
        {
            Canvas.SetDrawColor(80, 80, 80, 255);            
        }
        else
        {
            Canvas.SetDrawColor(255, 255, 255, 255);
        }
        // End:0x5F4
        if((debugAnalogVariable[I].Value[1] == debugAnalogVariable[I].Value[3]) && debugAnalogVariable[I].Value[1] == debugAnalogVariable[I].Value[2])
        {
            Canvas.DrawText(" ");
            // [Explicit Continue]
            goto J0x622;
        }
        Canvas.DrawText(string(debugAnalogVariable[I].Value[3]));
        J0x622:

        I++;
        // [Loop Continue]
        goto J0x4F4;
    }
    Canvas.SetDrawColor(5, 230, 255, 255);
    Canvas.SetPos(15.0000000, Canvas.CurY);
    Canvas.DrawText("===========================================================================================");
    Canvas.DrawText("Syntax: DebugAnalog <command> <variable #> <value>");
    Canvas.DrawText("Commands: set, swap, default, unreal, on, log");
    Canvas.DrawText("Note: Use variable 0 to modify all variables");
    Canvas.DrawText("    User sensitivity is currently set to:" @ string(float(10) * (SensitivityMultiplier - AnalogSensitivityScaling)));
    //return;    
}

function DebugDumpConfig()
{
    // End:0x0E
    if(cdumped == true)
    {
        return;
    }
    cdumped = true;
    //return;    
}

simulated event PostBeginPlay()
{
    Outer.super(ConsolePandoraPlayerInput).PostBeginPlay();
    ViewAccel_CurrMutliplier = ViewAccel_BaseMultiplier;
    Outer.SetSavedStickSensitivity();
    //return;    
}

exec function SetStickSensitivity(int Level)
{
    local float floatLevel, Temp;

    // End:0x12
    if(Level < 1)
    {
        Level = 1;
    }
    // End:0x26
    if(Level > 10)
    {
        Level = 10;
    }
    floatLevel = float(Level);
    floatLevel /= float(10);
    SensitivityMultiplier = AnalogSensitivityScaling + floatLevel;
    bSetStickSensitivity = true;
    // End:0x88
    if(minMouseSensitivity > maxMouseSensitivity)
    {
        Temp = minMouseSensitivity;
        minMouseSensitivity = maxMouseSensitivity;
        maxMouseSensitivity = Temp;
    }
    MouseSensitivity = (floatLevel * (maxMouseSensitivity - minMouseSensitivity)) + minMouseSensitivity;
    //return;    
}

function ProcessOverrides(float DeltaTime)
{
    // End:0x18
    if(orControls.overrideState == 0)
    {
        return;
    }
    super.ProcessOverrides(DeltaTime);
    //return;    
}

function PreProcessInput(float DeltaTime)
{
    local SPWeapon SPWeapon;

    // End:0x11
    if(Abs(aLookUp) > 0.1000000)
    {
    }
    super.PreProcessInput(DeltaTime);
    // End:0x3C
    if(bSetStickSensitivity == false)
    {
        Outer.SetSavedStickSensitivity();
    }
    // End:0x53
    if(Outer.Pawn == none)
    {
        return;
    }
    SPWeapon = SPWeapon(Outer.Pawn.Weapon);
    // End:0xE5
    if(SPWeapon != none)
    {
        aStrafe *= SPWeapon.m_gamePad.WalkSpeedScale;
        aBaseY *= SPWeapon.m_gamePad.WalkSpeedScale;
        aUp *= SPWeapon.m_gamePad.WalkSpeedScale;
    }
    // End:0xFD
    if(bViewAccelerationEnabled)
    {
        ApplyViewAcceleration(DeltaTime);
    }
    // End:0x12D
    if(bTargetFrictionEnabled)
    {
        // End:0x12D
        if(SPWeapon != none)
        {
            bAppliedTargetFriction = false;
            ApplyTargetFriction(DeltaTime, SPWeapon);
        }
    }
    // End:0x233
    if(SPWeapon != none)
    {
        aTurn *= SPWeapon.m_gamePad.TurnSpeedScale;
        aLookUp *= SPWeapon.m_gamePad.TurnSpeedScale;
        // End:0x1D3
        if(SPWeapon.IsLookingDownSight())
        {
            aTurn *= SPWeapon.m_gamePad.ZoomedTurnSpeedScalePct;
            aLookUp *= SPWeapon.m_gamePad.ZoomedTurnSpeedScalePct;
        }
        // End:0x233
        if(!SPWeapon.m_bIsPitchTransitioning && !SPWeapon.m_bIsViewTransitioning)
        {
            SPWeapon.SetADSCameraTurnValue(aTurn, false);
            SPWeapon.SetADSCameraLookValue(aLookUp, false);
        }
    }
    aTurn *= TurningAccelerationMultiplier;
    aLookUp *= PitchAccelerationMultiplier;
    aTurn *= SensitivityMultiplier;
    aLookUp *= SensitivityMultiplier;
    // End:0x274
    if(Abs(aLookUp) > 0.1000000)
    {
    }
    //return;    
}

function ApplyViewAutoPitchCentering(float DeltaTime)
{
    local float AmountToAdjustPitch, CurrentPitch;

    // End:0xD6
    if(((((aTurn != float(0)) || Abs(RawJoyLookUp) > 0.2000000) || Abs(RawJoyLookRight) > 0.2000000) || Outer.Pawn.Weapon.PendingFire(0) || Outer.Pawn.Weapon.PendingFire(1)) || int(Outer.Pawn.Physics) == int(2))
    {
        LastTurnTime = Outer.WorldInfo.TimeSeconds;
        return;
    }
    // End:0x220
    if(((Outer.WorldInfo.TimeSeconds - LastTurnTime) > AutoCenterDelay) && VSize(Outer.Pawn.Velocity) > 10.0000000)
    {
        CurrentPitch = float(NormalizeRotAxis(Outer.Rotation.Pitch));
        AmountToAdjustPitch = FInterpTo(CurrentPitch, 0.0000000, DeltaTime, AutoPitchCenterSpeed) - CurrentPitch;
        // End:0x220
        if(Abs(AmountToAdjustPitch) > AutoPitchStopAdjustingValue)
        {
            // End:0x1DC
            if(AmountToAdjustPitch < AutoPitchStopAdjustingValue)
            {
                // End:0x1BF
                if(bInvertMouse == false)
                {
                    aLookUp += FMin(-1.0000000 * AmountToAdjustPitch, AutoPitchCenterSpeed);                    
                }
                else
                {
                    aLookUp -= FMin(-1.0000000 * AmountToAdjustPitch, AutoPitchCenterSpeed);
                }                
            }
            else
            {
                // End:0x220
                if(AmountToAdjustPitch > AutoPitchStopAdjustingValue)
                {
                    // End:0x20D
                    if(bInvertMouse == false)
                    {
                        aLookUp -= FMin(AmountToAdjustPitch, AutoPitchCenterSpeed);                        
                    }
                    else
                    {
                        aLookUp += FMin(AmountToAdjustPitch, AutoPitchCenterSpeed);
                    }
                }
            }
        }
    }
    //return;    
}

function ApplyTurnViewAcceleration(float DeltaTime)
{
    local SPWeapon UW;

    UW = SPWeapon(Outer.Pawn.Weapon);
    // End:0x1A5
    if((Outer.Pawn.Weapon != none) && (Abs(aTurn) > ViewAccel_YawThreshold) || Square(Abs(RawJoyLookRight) + Square(Abs(RawJoyLookUp / 0.6500000))) > ViewAccel_DiagonalThreshold)
    {
        // End:0x153
        if(((ViewAccel_TimeHeld > ViewAccel_TimeToHoldBeforeFastAcceleration) && !bAppliedTargetFriction) && !Outer.Pawn.Weapon.PendingFire(0) || Outer.Pawn.Weapon.PendingFire(1) || (UW != none) && UW.CanViewAccelerationWhenFiring())
        {
            ViewAccel_CurrMutliplier = Abs(ViewAccel_CurrMutliplier);
            ViewAccel_CurrMutliplier += ViewAccel_RampSpeed;
            aTurn *= FMin(FMax(ViewAccel_CurrMutliplier, ViewAccel_BaseMultiplier), ViewAccel_MaxTurnSpeed);            
        }
        else
        {
            aTurn = ((aTurn < float(0)) ? float(-1) * Square(aTurn) : Square(aTurn));
            aTurn /= MagicScaleForSensitivityEdge;
            ViewAccel_CurrMutliplier = aTurn;
            ViewAccel_TimeHeld += DeltaTime;
        }        
    }
    else
    {
        aTurn = ((aTurn < float(0)) ? float(-1) * Square(aTurn) : Square(aTurn));
        aTurn /= MagicScaleForSensitivityMiddle;
        ViewAccel_CurrMutliplier = ViewAccel_BaseMultiplier;
        ViewAccel_TimeHeld = 0.0000000;
    }
    //return;    
}

function ApplyPitchViewAcceleration(float DeltaTime)
{
    local SPWeapon UW;

    UW = SPWeapon(Outer.Pawn.Weapon);
    // End:0x35
    if(Abs(aLookUp) > 0.1000000)
    {
    }
    // End:0x1B6
    if((Outer.Pawn.Weapon != none) && (Abs(aLookUp) > ViewAccel_PitchThreshold) || Square(Abs(RawJoyLookRight) + Square(Abs(RawJoyLookUp / 0.6500000))) > ViewAccel_DiagonalThreshold)
    {
        // End:0x164
        if(((PitchAccel_TimeHeld > PitchAccel_TimeToHoldBeforeFastAcceleration) && !bAppliedTargetFriction) && !Outer.Pawn.Weapon.PendingFire(0) || Outer.Pawn.Weapon.PendingFire(1) || (UW != none) && UW.CanViewAccelerationWhenFiring())
        {
            PitchAccel_CurrMutliplier = Abs(PitchAccel_CurrMutliplier);
            PitchAccel_CurrMutliplier += PitchAccel_RampSpeed;
            aLookUp *= FMin(FMax(PitchAccel_CurrMutliplier, PitchAccel_BaseMultiplier), PitchAccel_MaxTurnSpeed);            
        }
        else
        {
            aLookUp = ((aLookUp < float(0)) ? float(-1) * Square(aLookUp) : Square(aLookUp));
            aLookUp /= MagicScaleForSensitivityEdge;
            PitchAccel_CurrMutliplier = aLookUp;
            PitchAccel_TimeHeld += DeltaTime;
        }        
    }
    else
    {
        aLookUp = ((aLookUp < float(0)) ? float(-1) * Square(aLookUp) : Square(aLookUp));
        aLookUp /= MagicScaleForSensitivityMiddle;
        PitchAccel_CurrMutliplier = PitchAccel_BaseMultiplier;
        PitchAccel_TimeHeld = 0.0000000;
    }
    //return;    
}

function ApplyViewAcceleration(float DeltaTime)
{
    local float CurrentPitch;

    CurrentPitch = float(NormalizeRotAxis(Outer.Rotation.Pitch));
    // End:0x58
    if((CurrentPitch < (float(-1) * ViewAccel_LookingUpOrDownBoundary)) && !bPitchAccelerationEnabled)
    {
        bIsLookingDown = true;        
    }
    else
    {
        // End:0x7C
        if((CurrentPitch > ViewAccel_LookingUpOrDownBoundary) && !bPitchAccelerationEnabled)
        {
            bIsLookingUp = true;
        }
    }
    // End:0xD0
    if(((bIsLookingDown == true) && RawJoyLookUp < (float(-1) * ViewAccel_PitchThreshold)) || (bIsLookingUp == true) && RawJoyLookUp > ViewAccel_PitchThreshold)
    {
        aLookUp *= ViewAccel_BackToCenterSpeed;        
    }
    else
    {
        ApplyTurnViewAcceleration(DeltaTime);
        // End:0xF7
        if(bPitchAccelerationEnabled)
        {
            ApplyPitchViewAcceleration(DeltaTime);
        }
    }
    // End:0x146
    if(((bIsLookingDown || bIsLookingUp) && CurrentPitch < ViewAccel_BackToCenterBoundary) && CurrentPitch > (float(-1) * ViewAccel_BackToCenterBoundary))
    {
        bIsLookingDown = false;
        bIsLookingUp = false;
    }
    //return;    
}

function ApplyTargetAdhesion(float DeltaTime, SPWeapon W, out int out_YawRot, out int out_PitchRot)
{
    local Vector RealTargetLoc, TargetLoc, CamToTarget, AimLoc, CamLoc, ClosestY,
	    ClosestZ, X, Y, Z;

    local Rotator CamRot, DeltaRot;
    local float DistToTarget, DistFromAimZ, DistFromAimY, AdhesionAmtY, AdhesionAmtZ, TargetRadius,
	    TargetHeight, Pct;

    local int AdjustY, AdjustZ;
    local Pawn AdhesionTarget;

    // End:0x2F
    if((W == none) || !W.m_gamePad.bTargetAdhesionEnabled)
    {
        return;
    }
    CamLoc = Outer.CalcViewLocation;
    CamRot = Outer.CalcViewRotation;
    GetAxes(CamRot, X, Y, Z);
    AdhesionTarget = LastFrictionTarget;
    // End:0xF9
    if((AdhesionTarget == none) || Outer.TimeSince(LastFrictionTargetTime) > W.m_gamePad.TargetAdhesionTimeMax)
    {
        AdhesionTarget = Outer.GetTargetAdhesionFrictionTarget(W.m_gamePad.TargetAdhesionDistanceMax, CamLoc, CamRot);
    }
    // End:0x603
    if(AdhesionTarget != none)
    {
        AdhesionTarget.GetBoundingCylinder(TargetRadius, TargetHeight);
        TargetRadius *= 0.6500000;
        TargetHeight *= 0.6500000;
        RealTargetLoc = AdhesionTarget.Location + (W.m_gamePad.TargetFrictionOffset >> CamRot);
        // End:0x603
        if((((W.m_gamePad.TargetAdhesionTargetVelocityMin == 0.0000000) || VSize(AdhesionTarget.Velocity) > W.m_gamePad.TargetAdhesionTargetVelocityMin) && (W.m_gamePad.TargetAdhesionPlayerVelocityMin == 0.0000000) || VSize(Outer.Pawn.Velocity) > W.m_gamePad.TargetAdhesionPlayerVelocityMin) && ((RealTargetLoc - CamLoc) Dot Vector(CamRot)) > 0.0000000)
        {
            CamToTarget = RealTargetLoc - CamLoc;
            DistToTarget = VSize(CamToTarget);
            AimLoc = CamLoc + (X * DistToTarget);
            TargetLoc = RealTargetLoc;
            TargetLoc.Z = AimLoc.Z;
            DistFromAimY = PointDistToLine(AimLoc, TargetLoc - CamLoc, CamLoc, ClosestY);
            ClosestY = TargetLoc + (Normal(ClosestY - TargetLoc) * TargetRadius);
            TargetLoc = RealTargetLoc;
            TargetLoc.X = AimLoc.X;
            TargetLoc.Y = AimLoc.Y;
            DistFromAimZ = PointDistToLine(AimLoc, TargetLoc - CamLoc, CamLoc, ClosestZ);
            ClosestZ = TargetLoc + (Normal(ClosestZ - TargetLoc) * TargetRadius);
            DeltaRot.Yaw = Rotator(ClosestY - CamLoc).Yaw - CamRot.Yaw;
            DeltaRot.Pitch = Rotator(ClosestZ - CamLoc).Pitch - CamRot.Pitch;
            DeltaRot = Normalize(DeltaRot);
            // End:0x603
            if(((DistToTarget <= W.m_gamePad.TargetAdhesionDistanceMax) && (DistFromAimY > TargetRadius) || DistFromAimZ > TargetHeight) && Outer.LineOfSightTo(AdhesionTarget, CamLoc))
            {
                // End:0x53F
                if(DistFromAimY > TargetRadius)
                {
                    Pct = 1.0000000 - ((DistFromAimY - TargetRadius) / W.m_gamePad.TargetAdhesionAimDistY);
                    // End:0x53F
                    if(Pct > 0.0000000)
                    {
                        Pct = FMin(Pct, 0.8000000);
                        AdhesionAmtY = GetRangeValueByPct(W.m_gamePad.TargetAdhesionScaleRange, Pct);
                        AdjustY = int(float(DeltaRot.Yaw) * (AdhesionAmtY * DeltaTime));
                        out_YawRot += AdjustY;
                    }
                }
                // End:0x603
                if(DistFromAimZ > TargetHeight)
                {
                    Pct = 1.0000000 - ((DistFromAimZ - TargetHeight) / W.m_gamePad.TargetAdhesionAimDistZ);
                    // End:0x603
                    if(Pct > 0.0000000)
                    {
                        Pct = FMin(Pct, 0.8000000);
                        AdhesionAmtZ = GetRangeValueByPct(W.m_gamePad.TargetAdhesionScaleRange, Pct);
                        AdjustZ = int(float(DeltaRot.Pitch) * (AdhesionAmtZ * DeltaTime));
                        out_PitchRot += AdjustZ;
                    }
                }
            }
        }
    }
    //return;    
}

function ApplyTargetFriction(float DeltaTime, SPWeapon W)
{
    local Pawn FrictionTarget;
    local Vector CamLoc, X, Y, Z, CamToTarget, AimLoc,
	    TargetLoc, RealTargetLoc;

    local Rotator CamRot;
    local float DistToTarget, DistMultiplier, DistFromAimZ, DistFromAimY, TargetRadius, TargetHeight,
	    FrictionMultiplier;

    // End:0x39
    if((Outer.Pawn == none) || !W.m_gamePad.bTargetFrictionEnabled)
    {
        return;
    }
    CamLoc = Outer.CalcViewLocation;
    CamRot = Outer.CalcViewRotation;
    GetAxes(CamRot, X, Y, Z);
    FrictionTarget = Outer.GetTargetAdhesionFrictionTarget(W.m_gamePad.TargetFrictionDistanceMax, CamLoc, CamRot);
    // End:0x583
    if(FrictionTarget != none)
    {
        RealTargetLoc = FrictionTarget.Location + (W.m_gamePad.TargetFrictionOffset >> CamRot);
        CamToTarget = RealTargetLoc - CamLoc;
        DistToTarget = VSize(CamToTarget);
        AimLoc = CamLoc + (X * DistToTarget);
        FrictionTarget.GetBoundingCylinder(TargetRadius, TargetHeight);
        // End:0x1C2
        if(bDebugTargetFriction)
        {
            Outer.DrawDebugCylinder(FrictionTarget.Location + (vect(0.0000000, 0.0000000, 1.0000000) * TargetHeight), FrictionTarget.Location - (vect(0.0000000, 0.0000000, 1.0000000) * TargetHeight), TargetRadius, 12, 255, 0, 0);
        }
        TargetLoc = RealTargetLoc;
        TargetLoc.Z = AimLoc.Z;
        DistFromAimY = PointDistToLine(AimLoc, TargetLoc - CamLoc, CamLoc);
        TargetLoc = RealTargetLoc;
        TargetLoc.X = AimLoc.X;
        TargetLoc.Y = AimLoc.Y;
        DistFromAimZ = PointDistToLine(AimLoc, TargetLoc - CamLoc, CamLoc);
        DistMultiplier = 0.0000000;
        // End:0x438
        if((DistToTarget >= W.m_gamePad.TargetFrictionDistanceMin) && DistToTarget <= W.m_gamePad.TargetFrictionDistanceMax)
        {
            // End:0x368
            if(DistToTarget <= W.m_gamePad.TargetFrictionDistancePeak)
            {
                DistMultiplier = FClamp((DistToTarget - W.m_gamePad.TargetFrictionDistanceMin) / (W.m_gamePad.TargetFrictionDistancePeak - W.m_gamePad.TargetFrictionDistanceMin), 0.0000000, 1.0000000);                
            }
            else
            {
                DistMultiplier = FClamp(1.0000000 - ((DistToTarget - W.m_gamePad.TargetFrictionDistancePeak) / (W.m_gamePad.TargetFrictionDistanceMax - W.m_gamePad.TargetFrictionDistancePeak)), 0.0000000, 1.0000000);
            }
            TargetRadius *= (1.0000000 + (W.m_gamePad.TargetFrictionPeakRadiusScale * DistMultiplier));
            TargetHeight *= (1.0000000 + (W.m_gamePad.TargetFrictionPeakHeightScale * DistMultiplier));
        }
        // End:0x477
        if((VSize(FrictionTarget.Velocity) > float(200)) && W.IsLookingDownSight())
        {
            TargetRadius *= 0.0500000;
        }
        // End:0x583
        if((((DistFromAimY < TargetRadius) && DistFromAimZ < TargetHeight) && DistToTarget >= W.m_gamePad.TargetFrictionDistanceMin) && DistToTarget <= W.m_gamePad.TargetFrictionDistanceMax)
        {
            FrictionMultiplier = GetRangeValueByPct(W.m_gamePad.TargetFrictionMultiplierRange, 1.0000000 - (DistFromAimY / TargetRadius));
            // End:0x583
            if(FrictionMultiplier > 0.0000000)
            {
                bAppliedTargetFriction = true;
                aTurn *= (1.0000000 - FrictionMultiplier);
                aLookUp *= (1.0000000 - FrictionMultiplier);
                LastFrictionTargetTime = Outer.WorldInfo.TimeSeconds;
                LastFrictionTarget = FrictionTarget;
            }
        }
    }
    //return;    
}

exec function DebugViewAcceleration()
{
    // End:0x74
    if(int(Outer.WorldInfo.NetMode) == int(NM_Standalone))
    {
        bDebugViewAcceleration = !bDebugViewAcceleration;
        Outer.ClientMessage("bDebugViewAcceleration is now: " $ string(bDebugViewAcceleration));
    }
    //return;    
}

exec function DebugTargetAdhesion()
{
    // End:0x90
    if(int(Outer.WorldInfo.NetMode) == int(NM_Standalone))
    {
        Outer.bDebugTargetAdhesion = !Outer.bDebugTargetAdhesion;
        Outer.ClientMessage("bDebugTargetAdhesion is now: " $ string(Outer.bDebugTargetAdhesion));
    }
    //return;    
}

exec function DebugTargetFriction()
{
    // End:0x72
    if(int(Outer.WorldInfo.NetMode) == int(NM_Standalone))
    {
        bDebugTargetFriction = !bDebugTargetFriction;
        Outer.ClientMessage("bDebugTargetFriction is now: " $ string(bDebugTargetFriction));
    }
    //return;    
}
