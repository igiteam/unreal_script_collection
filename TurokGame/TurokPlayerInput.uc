class TurokPlayerInput extends PlayerInput within PlayerController
    transient
    native
    config(Game)
    hidecategories(Object,UIRoot);

enum ETurokDebugCamState
{
    ETDCS_None,                     // 0
    ETDCS_PlayerLocked,             // 1
    ETDCS_CameraLocked,             // 2
    ETDCS_MAX                       // 3
};

struct native AnalogJoyInputData
{
    var float rightShoulderButton;
    var float leftShoulderButton;
    var float rightThumbStickX;
    var float rightThumbStickY;
    var float leftThumbStickX;
    var float leftThumbStickY;
    var float rightThumbStickXCleared;
    var float rightThumbStickYCleared;
    var float leftThumbStickXCleared;
    var float leftThumbStickYCleared;
    var float rightShoulderButtonAsMouse;

    structdefaultproperties
    {
        rightShoulderButton=0.0000000
        leftShoulderButton=0.0000000
        rightThumbStickX=0.0000000
        rightThumbStickY=0.0000000
        leftThumbStickX=0.0000000
        leftThumbStickY=0.0000000
        rightThumbStickXCleared=0.0000000
        rightThumbStickYCleared=0.0000000
        leftThumbStickXCleared=0.0000000
        leftThumbStickYCleared=0.0000000
        rightShoulderButtonAsMouse=0.0000000
    }
};

var int mIsMultiPlayer;
var(AimAssist) bool mEnableAimAssist;
var(AimAssist) bool mbLerpToTarget;
var bool mbRotatingTowardsTarget;
var(sensitivity) bool mbUseRawAnalogInput;
var(sensitivity) bool mbEnableRotationScaling;
var bool mbLockPlayer;
var bool mbManualCameraInput;
var(AimAssist) float mLerpToTargetRate;
var(AimAssist) float mMinRotSlowDownPct;
var(AimAssist) float mMinRotSlowDownPctVert;
var(AimAssist) float mMinRotSlowDownPctMP;
var(AimAssist) float mMinRotSlowDownPctVertMP;
var(AimAssist) float mPS3MinRotSlowDownPct;
var(AimAssist) float mPS3MinRotSlowDownPctMP;
var(AimAssist) float mPS3AimAssistFadeDistFar;
var(AimAssist) float mPS3AimAssistFadeDistNear;
var float mLerpToTargetPct;
var @NULL mLerpToTargetRot;
var @NULL mCurrentTargetActor;
var @NULL mAnalogInputData;
var(sensitivity) float mSensitivityPlayerAdjustment;
var float mMaxATurn;
var float mMaxALookUp;
var(sensitivity) float mBaseMaxATurn;
var(sensitivity) float mMPBaseMaxATurn;
var(sensitivity) float mBaseMaxALookUp;
var(sensitivity) float mPS3BaseMaxATurn;
var(sensitivity) float mPS3MaxScaledATurn;
var(sensitivity) float mPS3MPBaseMaxATurn;
var(sensitivity) float mPS3MPMaxScaledATurn;
var(sensitivity) float mPS3BaseMaxALookUp;
var(sensitivity) float mMaxScaledATurn;
var(sensitivity) float mMPMaxScaledATurn;
var(sensitivity) float mRotScaleRate;
var(sensitivity) float mStartRotScaleThreshold;
var(sensitivity) float mRotScaleDelayActivationTime;
var(sensitivity) float mPS3RotScaleRate;
var float mRotScaleDelayTime;
var @NULL mDebugCamModifier;
var byte mDebugCamState;
var float mDebugCamTurn;
var float mDebugCamLookUp;
var float mDebugCamForward;
var float mDebugCamStrafe;

exec function bool InvertMouseLocal()
{
    bInvertMouse = !bInvertMouse;
    return bInvertMouse;
    //return ReturnValue;    
}

// Export UTurokPlayerInput::execIsPlayerLocked(FFrame&, void* const)
native function bool IsPlayerLocked();

function bool IsDebugCamLocked()
{
    return int(mDebugCamState) == int(2);
    //return ReturnValue;    
}

event bool InFreeDebugCamera()
{
    return int(mDebugCamState) == int(1);
    //return ReturnValue;    
}

function SetDebugCameraFree()
{
    mDebugCamState = 1;
    mbLockPlayer = true;
    // End:0xAC
    if(Outer.Pawn != none)
    {
        TurokPlayerCamera(PlayerController(Outer.Pawn.Controller).PlayerCamera).mParameters.RelatedController = Outer.Pawn.Controller;
        PlayerController(Outer.Pawn.Controller).SetCameraMode('DebugCam');
    }
    //return;    
}

function SetDebugCameraLocked()
{
    mDebugCamState = 2;
    mbLockPlayer = false;
    //return;    
}

function SetDebugCameraOff()
{
    mDebugCamState = 0;
    // End:0x4F
    if(Outer.Pawn != none)
    {
        PlayerController(Outer.Pawn.Controller).SetCameraMode('FirstPerson');
    }
    //return;    
}

function ToggleDebugCameraInput()
{
    // End:0x1D
    if(int(mDebugCamState) == int(0))
    {
        SetDebugCameraFree();        
    }
    else
    {
        // End:0x3A
        if(int(mDebugCamState) == int(1))
        {
            SetDebugCameraLocked();            
        }
        else
        {
            // End:0x54
            if(int(mDebugCamState) == int(2))
            {
                SetDebugCameraOff();
            }
        }
    }
    //return;    
}

event AdjustDebugCamera()
{
    mDebugCamTurn = (aTurn + aBaseX) + (aMouseX * MouseSensitivity);
    mDebugCamLookUp = aLookUp + (aMouseY * MouseSensitivity);
    mDebugCamForward = aForward + aBaseY;
    mDebugCamStrafe = aStrafe + aBaseX;
    //return;    
}

event PreProcessInput(float DeltaTime)
{
    local @NULL PC;
    local float xValue, yValue;

    // End:0x150
    if((Outer.Pawn != none) && Outer.Pawn.IsLocallyControlled())
    {
        PC = TurokPlayerController(Outer.Pawn.Controller);
        // End:0x13C
        if(((PC != none) && !PC.IsInState('CinematicState')) && !PC.IsInState('PlayerImpulse'))
        {
            xValue = mAnalogInputData.leftThumbStickX / mMaxATurn;
            yValue = mAnalogInputData.leftThumbStickY / mMaxALookUp;
            xValue = FMax(RawJoyRight * RawJoyRight, xValue * xValue);
            yValue = FMax(RawJoyUp * RawJoyUp, yValue * yValue);
            PC.mAnalogSpeedModifier = FClamp(Sqrt(xValue + yValue), 0.0000000, 1.0000000);            
        }
        else
        {
            PC.mAnalogSpeedModifier = 1.0000000;
        }
    }
    //return;    
}

// Export UTurokPlayerInput::execPostProcessInput(FFrame&, void* const)
native function PostProcessInput(float DeltaTime);

state CinematicState
{
    function BeginState(name PreviousStateName)
    {
        PushedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        PoppedState();
        //return;        
    }

    function PushedState()
    {
        TurokPlayerController(Outer).mbSkipCinema = false;
        //return;        
    }

    function PoppedState()
    {
        TurokPlayerController(Outer).mbSkipCinema = false;
        //return;        
    }

    function bool IsKeyAllowed(name Key)
    {
        // End:0x18F
        if(((((((((((((((((((Key == 'XboxTypeS_Start') || Key == 'XboxTypeS_Back') || Key == 'LeftMouseButton') || Key == 'RightMouseButton') || Key == 'MiddleMouseButton') || Key == 'XboxTypeS_A') || Key == 'XboxTypeS_B') || Key == 'XboxTypeS_X') || Key == 'XboxTypeS_Y') || Key == 'XboxTypeS_DPad_Up') || Key == 'XboxTypeS_DPad_Down') || Key == 'XboxTypeS_DPad_Left') || Key == 'XboxTypeS_DPad_Right') || Key == 'XboxTypeS_LeftThumbstick') || Key == 'XboxTypeS_RightThumbstick') || Key == 'XboxTypeS_RightTrigger') || Key == 'XboxTypeS_LeftTrigger') || Key == 'XboxTypeS_RightShoulder') || Key == 'XboxTypeS_LeftShoulder')
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    event bool InputKey(int ControllerId, name Key, byte Event, optional float AmountDepressed = 1.0000000)
    {
        // End:0xAD
        if((((((Key == 'XboxTypeS_B') || Key == 'LeftMouseButton') || Key == 'RightMouseButton') || Key == 'MiddleMouseButton') || Key == 'Enter') || Key == 'SpaceBar')
        {
            // End:0xAB
            if(int(Event) == int(0))
            {
                TurokPlayerController(Outer).mbSkipCinema = true;
            }
            return true;
        }
        // End:0xD8
        if(int(Event) == int(1))
        {
            return super(Interaction).InputKey(ControllerId, Key, Event, AmountDepressed);
        }
        // End:0x105
        if(IsKeyAllowed(Key))
        {
            return super(Interaction).InputKey(ControllerId, Key, Event, AmountDepressed);
        }
        return true;
        //return ReturnValue;        
    }

    event bool InputAxis(int ControllerId, name Key, float Delta, float DeltaTime)
    {
        return super(PlayerInput).InputAxis(ControllerId, Key, Delta, DeltaTime);
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    mIsMultiPlayer=-1
    mEnableAimAssist=true
    mbLerpToTarget=true
    mbUseRawAnalogInput=true
    mbEnableRotationScaling=true
    mLerpToTargetRate=0.0080000
    mMinRotSlowDownPct=0.4500000
    mMinRotSlowDownPctVert=0.8000000
    mMinRotSlowDownPctMP=0.4700000
    mMinRotSlowDownPctVertMP=0.7500000
    mPS3MinRotSlowDownPct=0.4500000
    mPS3MinRotSlowDownPctMP=0.3700000
    mPS3AimAssistFadeDistFar=560.0000000
    mPS3AimAssistFadeDistNear=160.0000000
    mSensitivityPlayerAdjustment=0.7500000
    mMaxATurn=1600.0000000
    mMaxALookUp=900.0000000
    mBaseMaxATurn=1600.0000000
    mMPBaseMaxATurn=1600.0000000
    mBaseMaxALookUp=900.0000000
    mPS3BaseMaxATurn=1250.0000000
    mPS3MaxScaledATurn=1600.0000000
    mPS3MPBaseMaxATurn=1250.0000000
    mPS3MPMaxScaledATurn=1600.0000000
    mPS3BaseMaxALookUp=600.0000000
    mMaxScaledATurn=1800.0000000
    mMPMaxScaledATurn=1800.0000000
    mRotScaleRate=1.8000000
    mStartRotScaleThreshold=0.9500000
    mRotScaleDelayActivationTime=0.6000000
    mPS3RotScaleRate=1.7000000
}