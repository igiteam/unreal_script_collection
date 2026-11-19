class SkyPlayerInput extends PlayerInput within PlayerController
    transient
    native
    config(Input);

enum EStickTapDirection
{
    StickTap_Forward,               // 0
    StickTap_Back,                  // 1
    StickTap_Left,                  // 2
    StickTap_Right,                 // 3
    StickTap_MAX                    // 4
};

enum EInputCommandType
{
    ICMD_Unknown,                   // 0
    ICMD_Function,                  // 1
    ICMD_Redirect,                  // 2
    ICMD_Button,                    // 3
    ICMD_Pulse,                     // 4
    ICMD_Clear,                     // 5
    ICMD_Toggle,                    // 6
    ICMD_Axis,                      // 7
    ICMD_Count,                     // 8
    ICMD_MAX                        // 9
};

struct native LockedInputRetriggerState
{
    var name Label;
    var bool bNoRepeat;
    var bool bBlocked;
    var int Controller;
    var Object.EInputEvent Event;
    var float Depress;
    var bool bGamepad;

    structdefaultproperties
    {
        Label="None"
        bNoRepeat=false
        bBlocked=false
        Controller=0
        Event=IE_Pressed
        Depress=0.0000000
        bGamepad=false
    }
};

struct MoveItem extends QueueItem
{
    var float StickX;
    var float StickY;
    var float TimeStamp;

    structdefaultproperties
    {
        StickX=0.0000000
        StickY=0.0000000
        TimeStamp=0.0000000
    }
};

struct native ParsedKeyCommand
{
    var Object.EInputEvent EventType;
    var SkyPlayerInput.EInputCommandType CommandType;
    var name ModifierName;
    var name CommandName;
    var string CommandParameters;
    var Pointer LookUp;

    structdefaultproperties
    {
        EventType=IE_Pressed
        CommandType=ICMD_Unknown
        ModifierName="None"
        CommandName="None"
        CommandParameters=""
        LookUp=none
    }
};

struct native ParsedKeyBind
{
    var name KeyName;
    var bool Control;
    var bool Shift;
    var bool Alt;
    var array<ParsedKeyCommand> ExeCommands;

    structdefaultproperties
    {
        KeyName="None"
        Control=false
        Shift=false
        Alt=false
        ExeCommands=none
    }
};

struct native InverseKey
{
    var name KeyName;
    var name ModifierName;
    var int Precedence;
    var bool IsKeyboardKey;
    var bool IsControllerKey;

    structdefaultproperties
    {
        KeyName="None"
        ModifierName="None"
        Precedence=0
        IsKeyboardKey=false
        IsControllerKey=false
    }
};

struct native InverseKeyBind
{
    var name CommandName;
    var array<InverseKey> Keys;

    structdefaultproperties
    {
        CommandName="None"
        Keys=none
    }
};

var float aForwardPrev;
var float aStrafePrev;
var float aUpPrev;
var float aBaseYPrev;
var input float aFFSpeed;
var input byte bSprint;
var input byte bDodge;
var input byte bDriving;
var input byte bPosture;
var input byte bFastFreeCam;
var input byte bSlowFreeCam;
var input byte bSpeedUpFreeCam;
var input byte bSlowDownFreeCam;
var input byte bFreeCamPlayerInput;
var input byte bFreeCamConstrainToPlayer;
var input byte bFreeCamShowMesh;
var input byte bFreeCamUp;
var input byte bFreeCamDown;
var input byte bLockOnCam;
var input byte bActionButton;
var input byte bCheatButton;
var input byte bCameraTest;
var input float aSprintSteering;
var transient float SprintHoldTimeLeft;
var float flightInputX;
var float flightInputY;
var bool bDebounceJump;
var bool bWasSprint;
var bool bIsLooking;
var bool bWasLockedInput;
var bool bHoldDuck;
var transient bool bTrackingJerk;
var bool bWaitingForSpecialMoveInput;
var transient bool bForegroundStatus;
var transient bool bIsInForeground;
var config array<config string> OnFootLayouts;
var config array<config string> InAirLayouts;
var config array<config string> InAAGunLayouts;
var transient array<SkyInputLayout> LayoutObjects;
var int CurrentLayoutIndex;
var transient array<KeyBind> MinBindings;
var array<LockedInputRetriggerState> LISButtons;
var array<LockedInputState> LockedInputs;
var array<LockedInputRetriggerState> RetriggerInputs;
var float LastDuckTime;
var transient float Display_aBaseX;
var transient float Display_aBaseY;
var transient float Display_aStrafe;
var transient float Display_aTurn;
var transient float Display_aLookUp;
var transient float Display_aUp;
var transient float Display_aMouseX;
var transient float Display_aMouseY;
var transient float Display_aMouseXTotal;
var transient float Display_aMouseYTotal;
var transient float Display_aFFSpeed;
var transient array<string> Display_StickHistory;
var transient int DisplayLineCount;
var() config float LookRightScaleMin;
var() config float LookRightScaleMax;
var() config float LookRightPegFactor;
var() config float LookUpScaleMin;
var() config float LookUpScaleMax;
var() config float LookUpPegFactor;
var transient AirCircularQueue MoveTracker;
var() int MoveTrackerEntries;
var() config float StickJerkDotThreshold;
var() config float StickJerkTime;
var() config float StickJerkStartThreshold;
var transient Vector JerkAnchor;
var transient Vector JerkAnchorNorm;
var transient float JerkStartTime;
var array<name> InputsIgnoredDuringTransitions;
var() config float StickTapDirectionTolerance;
var transient array<float> LastTapTimes;
var transient float LastNotifiedKismetOfInput;
var array<ParsedKeyBind> ParsedBindings;
var map{VOID,VOID} OnFootInvertedBindings;
var map{VOID,VOID} InAirInvertedBindings;
var transient array<name> KeyboardButtons;
var transient array<name> ControllerButtons;
var config array<config KeyBind> DebugBindings;
//var delegate<OnInputKey> __OnInputKey__Delegate;

delegate bool OnInputKey(int ControllerId, name Key, Object.EInputEvent Event, float AmountDepressed)
{
    //return ReturnValue;    
}

// Export USkyPlayerInput::execUpdateLockedInputs(FFrame&, void* const)
native function UpdateLockedInputs(float DeltaTime);

// Export USkyPlayerInput::execLockKey(FFrame&, void* const)
native function LockKey(name Key, float Duration);

// Export USkyPlayerInput::execUnlockKey(FFrame&, void* const)
native function UnlockKey(name Key);

// Export USkyPlayerInput::execIsKeyLocked(FFrame&, void* const)
native function bool IsKeyLocked(name Key);

event Tick(float DeltaTime)
{
    local bool ignoreInput;
    local int CurIndex;

    // End:0x44
    if(SkyPawn(Outer.Pawn) != none)
    {
        ignoreInput = SkyPawn(Outer.Pawn).IgnoreInputForTransition();
    }
    // End:0x12E
    if((ignoreInput == false) && bWasLockedInput == true)
    {
        CurIndex = 0;
        J0x65:

        // End:0x12E [Loop If]
        if(CurIndex < LISButtons.Length)
        {
            // End:0x124
            if(LISButtons[CurIndex].bBlocked == true)
            {
                InputKey(LISButtons[CurIndex].Controller, LISButtons[CurIndex].Label, LISButtons[CurIndex].Event, LISButtons[CurIndex].Depress, LISButtons[CurIndex].bGamepad);
                LISButtons[CurIndex].bBlocked = false;
            }
            ++CurIndex;
            // [Loop Continue]
            goto J0x65;
        }
    }
    bWasLockedInput = ignoreInput;
    UpdateLockedInputs(DeltaTime);
    UpdateForegroundStatus();
    super(Interaction).Tick(DeltaTime);
    //return;    
}

// Export USkyPlayerInput::execConstructLayouts(FFrame&, void* const)
native function ConstructLayouts();

// Export USkyPlayerInput::execSetCustomLayout(FFrame&, void* const)
native function SetCustomLayout(SkyInputLayout layout, SkyCustomControllerManager.ECustomControllerLayouts Index);

function Initialized()
{
    //return;    
}

// Export USkyPlayerInput::execPreProcessInputNative(FFrame&, void* const)
native final function PreProcessInputNative(float DeltaTime, Pawn inPawn);

function PreProcessInput(float DeltaTime)
{
    super.PreProcessInput(DeltaTime);
    PreProcessInputNative(DeltaTime, Outer.Pawn);
    //return;    
}

function PostProcessInput(float DeltaTime)
{
    local SkyPawn SP;
    local Vector StickVec;

    super.PostProcessInput(DeltaTime);
    SP = SkyPawn(Outer.Pawn);
    // End:0xC9
    if(SP != none)
    {
        // End:0xC9
        if(SP.bSprintingMode2)
        {
            StickVec.X = RawJoyUp - SP.SprintCancelStickConeOffset;
            StickVec.Y = RawJoyRight;
            StickVec = Normal(StickVec);
            // End:0xC9
            if((StickVec Dot vect(1.0000000, 0.0000000, 0.0000000)) < SP.SprintCancelStickConeAngle)
            {
                SP.StopSprint();
            }
        }
    }
    Display_aBaseX = aBaseX;
    Display_aBaseY = aBaseY;
    Display_aStrafe = aStrafe;
    Display_aTurn = aTurn;
    Display_aLookUp = aLookUp;
    Display_aUp = aUp;
    Display_aMouseX = aMouseX;
    Display_aMouseY = aMouseY;
    Display_aMouseXTotal = aMouseXTotal;
    Display_aMouseYTotal = aMouseYTotal;
    Display_aFFSpeed = aFFSpeed;
    //return;    
}

// Export USkyPlayerInput::execAnalyzeJerkiness(FFrame&, void* const)
native function AnalyzeJerkiness(float DeltaTime, Pawn inPawn);

// Export USkyPlayerInput::execPlayerInputNative(FFrame&, void* const)
native final function PlayerInputNative(float DeltaTime, Pawn inPawn);

// Export USkyPlayerInput::execPlayerInputNative2(FFrame&, void* const)
native final function PlayerInputNative2(float DeltaTime, Pawn inPawn);

event PlayerInput(float DeltaTime)
{
    PlayerInputNative(DeltaTime, Outer.Pawn);
    super.PlayerInput(DeltaTime);
    PlayerInputNative2(DeltaTime, Outer.Pawn);
    //return;    
}

// Export USkyPlayerInput::execGetShuffleSlotRotation(FFrame&, void* const)
native function Rotator GetShuffleSlotRotation();

// Export USkyPlayerInput::execRemapControlsByCamera(FFrame&, void* const)
native function RemapControlsByCamera(SkyPawnCoverUser InPlayer, Rotator CamForward, Rotator SlotForward, out float NewX, out float NewY);

// Export USkyPlayerInput::execUpdateSpecialInputKeys(FFrame&, void* const)
native function UpdateSpecialInputKeys(SkyPawnCoverUser InPlayer, float NewX, float NewY);

exec function OnStartTargetingInput()
{
    local SkyPawn SP;
    local SkyVehicle Veh;
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(Outer.PlayerCamera);
    // End:0x40
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    SP = SkyPawn(Outer.Pawn);
    Veh = SkyVehicle(Outer.Pawn);
    // End:0xAC
    if(SP != none)
    {
        SP.SetZooming(true);
        SP.SetTargeting(true);        
    }
    else
    {
        // End:0xC9
        if(Veh != none)
        {
            Veh.bTargeting = true;
        }
    }
    StartTargeting();
    //return;    
}

simulated function EnableForegroundStatus()
{
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(Outer.Pawn);
    bForegroundStatus = true;
    // End:0x7D
    if(((SPCU != none) && SPCU.IsInCover()) && int(SPCU.GetCoverFacing(100.0000000, 100.0000000)) == int(0))
    {
        SetForegroundRendering(true);
    }
    //return;    
}

simulated function DisableForegroundStatus()
{
    local SkyPawn SP;

    SP = SkyPawn(Outer.Pawn);
    bForegroundStatus = false;
    // End:0x38
    if(SP != none)
    {
        SetForegroundRendering(false);
    }
    //return;    
}

simulated function UpdateForegroundStatus()
{
    local SkyPawnCoverUser SPCU;

    // End:0x8C
    if(bForegroundStatus)
    {
        SPCU = SkyPawnCoverUser(Outer.Pawn);
        // End:0x81
        if(((SPCU != none) && SPCU.IsInCover()) && int(SPCU.GetCoverFacing(70.0000000, 70.0000000)) == int(0))
        {
            SetForegroundRendering(true);            
        }
        else
        {
            SetForegroundRendering(false);
        }
    }
    //return;    
}

simulated function SetForegroundRendering(bool bRenderToForeground)
{
    local SkyPawn SP;

    SP = SkyPawn(Outer.Pawn);
    // End:0x4F4
    if(bIsInForeground != bRenderToForeground)
    {
        bIsInForeground = bRenderToForeground;
        // End:0x2FF
        if(bRenderToForeground)
        {
            // End:0x9B
            if(SP.Mesh != none)
            {
                SP.SavedMeshDPG = SP.Mesh.DepthPriorityGroup;
                SP.Mesh.SetDepthPriorityGroup(2);
            }
            // End:0xF5
            if(SP.HeadMesh != none)
            {
                SP.SavedHeadMeshDPG = SP.HeadMesh.DepthPriorityGroup;
                SP.HeadMesh.SetDepthPriorityGroup(2);
            }
            // End:0x14F
            if(SP.HairMesh != none)
            {
                SP.SavedHairMeshDPG = SP.HairMesh.DepthPriorityGroup;
                SP.HairMesh.SetDepthPriorityGroup(2);
            }
            // End:0x1DE
            if((SP.CurrWeaponAttachment != none) && SP.CurrWeaponAttachment.Mesh != none)
            {
                SP.SavedWeaponMeshDPG = SP.CurrWeaponAttachment.Mesh.DepthPriorityGroup;
                SP.CurrWeaponAttachment.Mesh.SetDepthPriorityGroup(2);
            }
            // End:0x26D
            if((SP.CurrWeaponAttachment != none) && SP.CurrWeaponAttachment.MuzzleFlashPSC != none)
            {
                SP.SavedMuzzleFlashDPG = SP.CurrWeaponAttachment.MuzzleFlashPSC.DepthPriorityGroup;
                SP.CurrWeaponAttachment.MuzzleFlashPSC.SetDepthPriorityGroup(2);
            }
            // End:0x2FC
            if((SP.RocketPack != none) && SP.RocketPack.Mesh != none)
            {
                SP.SavedRocketPackMeshDPG = SP.RocketPack.Mesh.DepthPriorityGroup;
                SP.RocketPack.Mesh.SetDepthPriorityGroup(2);
            }            
        }
        else
        {
            // End:0x33D
            if(SP.Mesh != none)
            {
                SP.Mesh.SetDepthPriorityGroup(SP.SavedMeshDPG);
            }
            // End:0x37B
            if(SP.HeadMesh != none)
            {
                SP.HeadMesh.SetDepthPriorityGroup(SP.SavedHeadMeshDPG);
            }
            // End:0x3B9
            if(SP.HairMesh != none)
            {
                SP.HairMesh.SetDepthPriorityGroup(SP.SavedHairMeshDPG);
            }
            // End:0x422
            if((SP.CurrWeaponAttachment != none) && SP.CurrWeaponAttachment.Mesh != none)
            {
                SP.CurrWeaponAttachment.Mesh.SetDepthPriorityGroup(SP.SavedWeaponMeshDPG);
            }
            // End:0x48B
            if((SP.CurrWeaponAttachment != none) && SP.CurrWeaponAttachment.MuzzleFlashPSC != none)
            {
                SP.CurrWeaponAttachment.MuzzleFlashPSC.SetDepthPriorityGroup(SP.SavedMuzzleFlashDPG);
            }
            // End:0x4F4
            if((SP.RocketPack != none) && SP.RocketPack.Mesh != none)
            {
                SP.RocketPack.Mesh.SetDepthPriorityGroup(SP.SavedRocketPackMeshDPG);
            }
        }
    }
    //return;    
}

simulated event StartTargeting()
{
    local SkyPlayerController SPC;
    local SkyPawnCoverUser SPCU;
    local SkyPawn SP;
    local SkyCamera SkyCam;
    local SkyCameraTree CamTree;

    // End:0x17
    if(Outer.Pawn == none)
    {
        return;
    }
    SP = SkyPawn(Outer.Pawn);
    SPCU = SkyPawnCoverUser(Outer.Pawn);
    // End:0x71
    if((SPCU != none) && SPCU.TryTriggerStepout())
    {
        return;
    }
    // End:0x99
    if((SP != none) && !SP.CanPerformTargeting())
    {
        return;
    }
    EnableForegroundStatus();
    // End:0xD7
    if((SPCU != none) && SPCU.bBlockStopTargetingInput)
    {
        SPCU.bTriggerStopTargetingInputEvent = false;
        return;
    }
    // End:0x153
    if((SkyWeapon(Outer.Pawn.Weapon) != none) && Outer.Pawn.Weapon.bAllowZoom)
    {
        SkyWeapon(Outer.Pawn.Weapon).ClientStartZoom();
        return;
    }
    SPC = SkyPlayerController(Outer.Pawn.Controller);
    // End:0x1EA
    if(SPC != none)
    {
        SkyCam = SkyCamera(SPC.PlayerCamera);
        // End:0x1EA
        if(SkyCam != none)
        {
            CamTree = SkyCam.CamTreeRoot;
            // End:0x1EA
            if(CamTree != none)
            {
                CamTree.StartTargetingTransition(CamTree.fTargetTransMinTraceHitDistIn);
            }
        }
    }
    //return;    
}

exec event OnStopTargetingInput()
{
    local SkyPawn SP;
    local SkyVehicle Veh;
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(Outer.PlayerCamera);
    // End:0x40
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    SP = SkyPawn(Outer.Pawn);
    Veh = SkyVehicle(Outer.Pawn);
    // End:0xAC
    if(SP != none)
    {
        SP.SetZooming(false);
        SP.SetTargeting(false);        
    }
    else
    {
        // End:0xC9
        if(Veh != none)
        {
            Veh.bTargeting = false;
        }
    }
    StopTargeting();
    //return;    
}

simulated function StopTargeting()
{
    local SkyPlayerController pSPC;
    local SkyPawn pSP;
    local SkyPawnCoverUser SPCU;
    local SkyCamera SkyCam;
    local SkyCameraTree CamTree;

    SPCU = SkyPawnCoverUser(Outer.Pawn);
    // End:0x43
    if(SPCU.bSteppingOut)
    {
        SPCU.AbortStepoutAction();
        return;
    }
    // End:0x77
    if((SPCU != none) && SPCU.bBlockStopTargetingInput)
    {
        SPCU.bTriggerStopTargetingInputEvent = true;
        return;
    }
    pSP = SkyPawn(Outer.Pawn);
    // End:0x1D3
    if(pSP != none)
    {
        // End:0x117
        if((SkyWeapon(Outer.Pawn.Weapon) != none) && Outer.Pawn.Weapon.bAllowZoom)
        {
            SkyWeapon(Outer.Pawn.Weapon).ClientStopZoom();
        }
        DisableForegroundStatus();
        // End:0x146
        if(!pSP.PrimaryWSM.IsTargeting())
        {
            return;
        }
        pSPC = SkyPlayerController(pSP.Controller);
        // End:0x1D3
        if(pSPC != none)
        {
            SkyCam = SkyCamera(pSPC.PlayerCamera);
            // End:0x1D3
            if(SkyCam != none)
            {
                CamTree = SkyCam.CamTreeRoot;
                // End:0x1D3
                if(CamTree != none)
                {
                    CamTree.StartTargetingTransition(CamTree.fTargetTransMinTraceHitDistOut);
                }
            }
        }
    }
    //return;    
}

function AdjustMouseSensitivity(float FOVScale)
{
    // End:0x43
    if(SkyAirVehicle(Outer.Pawn) != none)
    {
        aMouseX *= (MouseSensitivityInAir * FOVScale);
        aMouseY *= (MouseSensitivityInAir * FOVScale);        
    }
    else
    {
        aMouseX *= (MouseSensitivity * FOVScale);
        aMouseY *= (MouseSensitivity * FOVScale);
    }
    //return;    
}

exec function Jump()
{
    // End:0x28
    if(SkyPawn(Outer.Pawn).CannotJumpNow())
    {
        return;
    }
    // End:0x8C
    if(int(SkyPawn(Outer.Pawn).SprintState) == int(2))
    {
        Outer.Pawn.JumpZ = SkyPawn(Outer.Pawn).JumpZSprintDive;        
    }
    else
    {
        Outer.Pawn.JumpZ = Outer.Pawn.default.JumpZ;
    }
    super.Jump();
    //return;    
}

event LaunchJump()
{
    // End:0x64
    if(int(SkyPawn(Outer.Pawn).SprintState) == int(2))
    {
        Outer.Pawn.JumpZ = SkyPawn(Outer.Pawn).JumpZSprintDive;        
    }
    else
    {
        Outer.Pawn.JumpZ = Outer.Pawn.default.JumpZ;
    }
    Jump();
    //return;    
}

simulated exec function StartDuck()
{
    // End:0x29
    if(Outer.PlayerCamera.CameraStyle == 'FreeCam')
    {
        return;
    }
    Duck();
    //return;    
}

simulated exec function StopDuck()
{
    // End:0x29
    if(Outer.PlayerCamera.CameraStyle == 'FreeCam')
    {
        return;
    }
    Duck();
    //return;    
}

simulated exec function Duck()
{
    // End:0x78
    if(((SkyPawnCoverUser(Outer.Pawn) != none) && int(SkyPawnCoverUser(Outer.Pawn).GetCoverMacroState()) == int(2)) && int(SkyPawnCoverUser(Outer.Pawn).GetCoverType()) == int(2))
    {
        return;
    }
    // End:0xFB
    if(SkyPawn(Outer.Pawn) != none)
    {
        // End:0xBC
        if(!SkyPawn(Outer.Pawn).CanDuck())
        {
            return;
        }
        // End:0xE1
        if(bHoldDuck)
        {
            bHoldDuck = false;
            Outer.bDuck = 0;
            return;
        }
        Outer.bDuck = 1;
        bHoldDuck = true;
    }
    //return;    
}

simulated exec function UnDuck()
{
    // End:0x39
    if((SkyPawn(Outer.Pawn) != none) && !bHoldDuck)
    {
        Outer.bDuck = 0;
    }
    //return;    
}

function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    local float fMoveLen;

    Canvas = HUD.Canvas;
    // End:0x749
    if(HUD.ShouldDisplayDebug('Input'))
    {
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.DrawText("Input: " $ string(Class));
        out_YPos += out_YL;
        Canvas.DrawText("aBaseX " $ string(Display_aBaseX));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("aBaseY " $ string(Display_aBaseY));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("aStrafe " $ string(Display_aStrafe));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("aTurn " $ string(Display_aTurn)) $ ", RawJoyLookRight ") $ string(RawJoyLookRight));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("aLookUp " $ string(Display_aLookUp)) $ ", RawJoyLookUp ") $ string(RawJoyLookUp));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("aUp " $ string(Display_aUp));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("aMouseX " $ string(Display_aMouseX));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("aMouseY " $ string(Display_aMouseY));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("aMouseXTotal " $ string(Display_aMouseXTotal));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("aMouseYTotal " $ string(Display_aMouseYTotal));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText("aFFSpeed " $ string(Display_aFFSpeed));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((((("LookRightScale " $ string(LookRightScale)) $ ", LookRightScaleMin ") $ string(LookRightScaleMin)) $ ", LookRightScaleMax ") $ string(LookRightScaleMax));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((((("LookUpScale " $ string(LookUpScale)) $ ", LookUpScaleMin ") $ string(LookUpScaleMin)) $ ", LookUpScaleMax ") $ string(LookUpScaleMax));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        fMoveLen = Sqrt((Display_aStrafe * Display_aStrafe) + (Display_aBaseY * Display_aBaseY));
        Canvas.DrawText("fMoveLen " $ string(fMoveLen));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("MoveInputIgnored " $ string(Outer.IsMoveInputIgnored())) $ ": ") $ string(Outer.bIgnoreMoveInput));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("MoveInputLocked " $ string(SkyPlayerController(Outer.Pawn.Controller).IsMoveInputLocked())) $ ": ") $ string(SkyPlayerController(Outer.Pawn.Controller).bLockMoveInput));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.DrawText((("LookInputIgnored " $ string(Outer.IsLookInputIgnored())) $ ": ") $ string(Outer.bIgnoreLookInput));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x812
    if(HUD.ShouldDisplayDebug('Sprint'))
    {
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.DrawText((((((("bSprint: " $ string(bSprint)) $ ", SprintHoldTimeLeft: ") $ string(SprintHoldTimeLeft)) $ "/") $ " (") $ string(SprintHoldTimeLeft * 100.0000000)) $ "%)");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    //return;    
}

// Export USkyPlayerInput::execCinematicInputKey(FFrame&, void* const)
native function bool CinematicInputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false);

// Export USkyPlayerInput::execInputKey(FFrame&, void* const)
native function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false);

// Export USkyPlayerInput::execStickTapCheck(FFrame&, void* const)
native function bool StickTapCheck(SkyPlayerInput.EStickTapDirection Direction, float Tolerance);

event SetLayout(string layout)
{
    local int Offset, layoutoption, invertoption;
    local SkyPlayerControllerBase PC;
    local OnlineProfileSettings Settings;

    PC = SkyPlayerControllerBase(Outer);
    // End:0x209
    if(PC != none)
    {
        Settings = PC.GetProfileSettings();
        // End:0x74
        if(layout == "InAir")
        {
            Offset = ((OnFootLayouts.Length == 0) ? 1 : OnFootLayouts.Length);
            layoutoption = 58;
            invertoption = 61;            
        }
        else
        {
            Offset = 0;
            layoutoption = 57;
            invertoption = 2;
        }
        // End:0x104
        if(((Settings == none) || !Settings.GetProfileSettingValueId(layoutoption, layoutoption)) || !Settings.GetProfileSettingValueId(invertoption, invertoption))
        {
            layoutoption = 0;
            invertoption = ((layout == "InAir") ? 1 : 0);
        }
        bInvertMouse = invertoption == 1;
        layoutoption += Offset;
        // End:0x209
        if(layoutoption < LayoutObjects.Length)
        {
            Bindings = LayoutObjects[layoutoption].Bindings;
            CurrentLayoutIndex = layoutoption;
            PreParseLayout(((layout == "InAir") ? 1 : 0));
            // End:0x1B1
            if(SkyHUD(PC.myHUD) != none)
            {
                SkyHUD(PC.myHUD).CheckInteractionModifiers();
            }
            // End:0x1F3
            if(Class'Engine.GameEngine'.static.IsConsumerDemo())
            {
                SkyGameReplicationInfo(PC.WorldInfo.GRI).SetCurrentObjectiveText("");
            }
            ActivateInputEvent(name(layout), PC);
        }
    }
    //return;    
}

// Export USkyPlayerInput::execActivateInputEvent(FFrame&, void* const)
native function bool ActivateInputEvent(name Key, PlayerController PC);

// Export USkyPlayerInput::execPreParseLayout(FFrame&, void* const)
native function PreParseLayout(int List);

// Export USkyPlayerInput::execFlushLog(FFrame&, void* const)
native exec function FlushLog();

function ClearOtherMoveInput()
{
    RawJoyUp = 0.0000000;
    RawJoyRight = 0.0000000;
    flightInputX = 0.0000000;
    flightInputY = 0.0000000;
    //return;    
}

function ClearOtherLookInput()
{
    RawJoyLookRight = 0.0000000;
    RawJoyLookUp = 0.0000000;
    //return;    
}
