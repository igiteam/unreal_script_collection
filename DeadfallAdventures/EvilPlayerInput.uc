class EvilPlayerInput extends UTConsolePlayerInput within EvilPlayerController
    transient
    config(Input)
    hidecategories(Object,UIRoot);

struct InputButtonData
{
    var name ButtonNameMapping;
    var delegate<HandleButtonInput> ButtonHandler;
    var delegate<HandleButtonInput> ButtonHandlerHold;
    var byte Active;
    var byte RawActive;
    var byte HoldActive;
    var float LastPressTime;
    var bool bHoldHandled;

    structdefaultproperties
    {
        ButtonNameMapping="None"
        ButtonHandler=None
        ButtonHandlerHold=None
        Active=0
        RawActive=0
        HoldActive=0
        LastPressTime=0.0000000
        bHoldHandled=false
    }
};

var array<InputButtonData> InputButtonDataList;
var transient float LastInputTime;
var float PressHoldTime;
var transient EvilWeap_Base tmpWeapZoom;
var protected bool bButtonFilter;
var bool bHoldZoom;
var protected EvilTypes.EGameButtons ButtonFilterException;
//var delegate<HandleButtonInput> __HandleButtonInput__Delegate;

delegate bool HandleButtonInput(bool bPressed)
{
    return false;
    //return ReturnValue;    
}

function InitInputSystem()
{
    super(MobilePlayerInput).InitInputSystem();
    InitializeButtonHandling();
    //return;    
}

function InitializeButtonHandling()
{
    InputButtonDataList.Length = 25;
    InputButtonDataList[0].ButtonNameMapping = 'A';
    InputButtonDataList[1].ButtonNameMapping = 'X';
    InputButtonDataList[2].ButtonNameMapping = 'Y';
    InputButtonDataList[3].ButtonNameMapping = 'B';
    InputButtonDataList[4].ButtonNameMapping = 'Start';
    InputButtonDataList[5].ButtonNameMapping = 'back';
    InputButtonDataList[6].ButtonNameMapping = 'l2';
    InputButtonDataList[7].ButtonNameMapping = 'l1';
    InputButtonDataList[8].ButtonNameMapping = 'r2';
    InputButtonDataList[9].ButtonNameMapping = 'r1';
    InputButtonDataList[10].ButtonNameMapping = 'DPad_Up';
    InputButtonDataList[11].ButtonNameMapping = 'DPad_Left';
    InputButtonDataList[12].ButtonNameMapping = 'DPad_Down';
    InputButtonDataList[13].ButtonNameMapping = 'DPad_Right';
    InputButtonDataList[14].ButtonNameMapping = 'L3';
    InputButtonDataList[15].ButtonNameMapping = 'R3';
    InputButtonDataList[24].ButtonNameMapping = 'PC_USE';
    InitializeButtonHandlingHandlers();
    //return;    
}

final function SetInputButtonHandle(EvilTypes.EGameButtons GBType, delegate<HandleButtonInput> Handler)
{
    InputButtonDataList[int(GBType)].ButtonHandler = Handler;
    //return;    
}

event InitializeButtonHandlingHandlers()
{
    InputButtonDataList[0].ButtonHandler = HandleButtonInput_A;
    InputButtonDataList[0].ButtonHandlerHold = HandleButtonInputHold_A;
    InputButtonDataList[1].ButtonHandler = HandleButtonInput_X;
    InputButtonDataList[1].ButtonHandlerHold = HandleButtonInputHold_X;
    InputButtonDataList[2].ButtonHandler = HandleButtonInput_Y;
    InputButtonDataList[2].ButtonHandlerHold = HandleButtonInputHold_Y;
    InputButtonDataList[3].ButtonHandler = HandleButtonInput_B;
    InputButtonDataList[3].ButtonHandlerHold = HandleButtonInputHold_B;
    InputButtonDataList[4].ButtonHandler = HandleButtonInput_Start;
    InputButtonDataList[4].ButtonHandlerHold = HandleButtonInputHold_Start;
    InputButtonDataList[5].ButtonHandler = HandleButtonInput_Back;
    InputButtonDataList[5].ButtonHandlerHold = HandleButtonInputHold_Back;
    InputButtonDataList[6].ButtonHandler = HandleButtonInput_LeftTrigger;
    InputButtonDataList[6].ButtonHandlerHold = HandleButtonInputHold_LeftTrigger;
    InputButtonDataList[7].ButtonHandler = HandleButtonInput_LeftBumper;
    InputButtonDataList[7].ButtonHandlerHold = HandleButtonInputHold_LeftBumper;
    InputButtonDataList[8].ButtonHandler = HandleButtonInput_RightTrigger;
    InputButtonDataList[8].ButtonHandlerHold = HandleButtonInputHold_RightTrigger;
    InputButtonDataList[9].ButtonHandler = HandleButtonInput_RightBumper;
    InputButtonDataList[9].ButtonHandlerHold = HandleButtonInputHold_RightBumper;
    InputButtonDataList[10].ButtonHandler = HandleButtonInput_DPad_Up;
    InputButtonDataList[10].ButtonHandlerHold = HandleButtonInputHold_DPad_Up;
    InputButtonDataList[11].ButtonHandler = HandleButtonInput_DPad_Left;
    InputButtonDataList[11].ButtonHandlerHold = HandleButtonInputHold_DPad_Left;
    InputButtonDataList[12].ButtonHandler = HandleButtonInput_DPad_Down;
    InputButtonDataList[12].ButtonHandlerHold = HandleButtonInputHold_DPad_Down;
    InputButtonDataList[13].ButtonHandler = HandleButtonInput_DPad_Right;
    InputButtonDataList[13].ButtonHandlerHold = HandleButtonInputHold_DPad_Right;
    InputButtonDataList[14].ButtonHandler = HandleButtonInput_LeftStickButton;
    InputButtonDataList[14].ButtonHandlerHold = HandleButtonInputHold_LeftStickButton;
    InputButtonDataList[15].ButtonHandler = HandleButtonInput_RightStickButton;
    InputButtonDataList[15].ButtonHandlerHold = HandleButtonInputHold_RightStickButton;
    InputButtonDataList[16].ButtonHandler = HandleButtonInput_LeftStickUp;
    InputButtonDataList[17].ButtonHandler = HandleButtonInput_LeftStickDown;
    InputButtonDataList[18].ButtonHandler = HandleButtonInput_LeftStickLeft;
    InputButtonDataList[19].ButtonHandler = HandleButtonInput_LeftStickRight;
    InputButtonDataList[20].ButtonHandler = HandleButtonInput_RightStickUp;
    InputButtonDataList[21].ButtonHandler = HandleButtonInput_RightStickDown;
    InputButtonDataList[22].ButtonHandler = HandleButtonInput_RightStickLeft;
    InputButtonDataList[23].ButtonHandler = HandleButtonInput_RightStickRight;
    InputButtonDataList[24].ButtonHandler = HandleButtonInput_PC_Use;
    //return;    
}

final simulated function bool IsButtonActive(EvilTypes.EGameButtons Button, optional bool bRaw)
{
    return ((bRaw) ? int(InputButtonDataList[int(Button)].RawActive) == int(1) : int(InputButtonDataList[int(Button)].Active) == int(1));
    //return ReturnValue;    
}

final function ForceButtonRelease(EvilTypes.EGameButtons Button, optional bool bSilent)
{
    // End:0x45
    if(!bSilent)
    {
        ButtonRelease(InputButtonDataList[int(Button)].ButtonNameMapping);        
    }
    else
    {
        InputButtonDataList[int(Button)].RawActive = 0;
        InputButtonDataList[int(Button)].Active = 0;
    }
    //return;    
}

simulated function bool IsIdle()
{
    // End:0xBE
    if((((((((((aBaseX != float(0)) || aBaseY != float(0)) || aBaseZ != float(0)) || aMouseX != float(0)) || aMouseY != float(0)) || aForward != float(0)) || aTurn != float(0)) || aStrafe != float(0)) || aUp != float(0)) || aLookUp != float(0))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function AdjustMouseSensitivity(float FOVScale)
{
    aMouseX *= (MouseSensitivity * FOVScale);
    aMouseY *= (MouseSensitivity * FOVScale);
    //return;    
}

function PreProcessInput(float DeltaTime)
{
    // End:0x8A
    if(!bUsingGamepad)
    {
        // End:0x8A
        if(!Outer.WorldInfo.IsConsoleBuild(2))
        {
            aTurn /= 1.5000000;
            aLookUp /= 1.5000000;
            aMouseX /= 1.5000000;
            aMouseY /= 1.5000000;
        }
    }
    super.PreProcessInput(DeltaTime);
    UpdateJoystickInput(DeltaTime);
    //return;    
}

function UpdateJoystickInput(float DeltaTime)
{
    local delegate<HandleButtonInput> ButtonHandler;
    local byte Idx;

    InputButtonDataList[16].RawActive = ((aBaseY >= 0.3000000) ? 1 : 0);
    InputButtonDataList[17].RawActive = ((aBaseY <= -0.3000000) ? 1 : 0);
    InputButtonDataList[18].RawActive = ((aStrafe <= -0.3000000) ? 1 : 0);
    InputButtonDataList[19].RawActive = ((aStrafe >= 0.3000000) ? 1 : 0);
    InputButtonDataList[20].RawActive = ((aLookUp >= 0.3000000) ? 1 : 0);
    InputButtonDataList[21].RawActive = ((aLookUp <= -0.3000000) ? 1 : 0);
    InputButtonDataList[22].RawActive = ((aTurn <= -0.3000000) ? 1 : 0);
    InputButtonDataList[23].RawActive = ((aTurn >= 0.3000000) ? 1 : 0);
    Idx = 16;
    J0x1D4:

    // End:0x3DC [Loop If]
    if(int(Idx) <= 23)
    {
        // End:0x3CE
        if(int(InputButtonDataList[int(Idx)].RawActive) != int(InputButtonDataList[int(Idx)].Active))
        {
            InputButtonDataList[int(Idx)].Active = InputButtonDataList[int(Idx)].RawActive;
            // End:0x31F
            if(int(InputButtonDataList[int(Idx)].Active) == int(1))
            {
                InputButtonDataList[int(Idx)].LastPressTime = Outer.WorldInfo.TimeSeconds;
            }
            InputButtonDataList[int(Idx)].HoldActive = 0;
            ButtonHandler = InputButtonDataList[int(Idx)].ButtonHandler;
            // End:0x3CE
            if(ButtonHandler != none)
            {
                HandleButtonInput(int(InputButtonDataList[int(Idx)].Active) == int(1));
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x1D4;
    }
    //return;    
}

event Tick(float DeltaTime)
{
    local delegate<HandleButtonInput> ButtonHandlerHold;
    local byte Idx;

    super(Interaction).Tick(DeltaTime);
    Idx = 0;
    J0x1F:

    // End:0x257 [Loop If]
    if(int(Idx) < 25)
    {
        // End:0x249
        if(((int(InputButtonDataList[int(Idx)].Active) == int(1)) && int(InputButtonDataList[int(Idx)].HoldActive) == int(0)) && (Outer.WorldInfo.TimeSeconds - InputButtonDataList[int(Idx)].LastPressTime) > PressHoldTime)
        {
            LastInputTime = Outer.WorldInfo.TimeSeconds;
            InputButtonDataList[int(Idx)].LastPressTime = Outer.WorldInfo.TimeSeconds;
            InputButtonDataList[int(Idx)].HoldActive = 1;
            ButtonHandlerHold = InputButtonDataList[int(Idx)].ButtonHandlerHold;
            // End:0x249
            if(ButtonHandlerHold != none)
            {
                InputButtonDataList[int(Idx)].bHoldHandled = HandleButtonInput(true);
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x1F;
    }
    //return;    
}

function bool FilterButtonInput(name ButtonName, bool bPressed, int ButtonIdx)
{
    return bButtonFilter && ButtonIdx != int(ButtonFilterException);
    //return ReturnValue;    
}

final function int FindInputButtonDataIndex(name ButtonName)
{
    local int Idx;

    Idx = 0;
    J0x0B:

    // End:0x6F [Loop If]
    if(Idx < InputButtonDataList.Length)
    {
        // End:0x61
        if(InputButtonDataList[Idx].ButtonNameMapping == ButtonName)
        {
            return Idx;
        }
        Idx++;
        // [Loop Continue]
        goto J0x0B;
    }
    return -1;
    //return ReturnValue;    
}

exec function ButtonPress(coerce name ButtonName)
{
    local int ButtonIdx;
    local delegate<HandleButtonInput> ButtonHandler;

    LastInputTime = Outer.WorldInfo.TimeSeconds;
    ButtonIdx = FindInputButtonDataIndex(ButtonName);
    // End:0x1FE
    if(int(InputButtonDataList[ButtonIdx].RawActive) == int(0))
    {
        InputButtonDataList[ButtonIdx].RawActive = 1;
        InputButtonDataList[ButtonIdx].HoldActive = 0;
        InputButtonDataList[ButtonIdx].bHoldHandled = false;
        // End:0x1FE
        if(!FilterButtonInput(ButtonName, true, ButtonIdx))
        {
            InputButtonDataList[ButtonIdx].Active = 1;
            InputButtonDataList[ButtonIdx].LastPressTime = Outer.WorldInfo.TimeSeconds;
            ButtonHandler = InputButtonDataList[ButtonIdx].ButtonHandler;
            // End:0x1FE
            if(ButtonHandler != none)
            {
                HandleButtonInput(true);
            }
        }
    }
    //return;    
}

exec function ButtonRelease(coerce name ButtonName)
{
    local int ButtonIdx;
    local delegate<HandleButtonInput> ButtonHandler, ButtonHandlerHold;

    LastInputTime = Outer.WorldInfo.TimeSeconds;
    ButtonIdx = FindInputButtonDataIndex(ButtonName);
    // End:0x1FE
    if(int(InputButtonDataList[ButtonIdx].RawActive) == int(1))
    {
        InputButtonDataList[ButtonIdx].RawActive = 0;
        // End:0x1FE
        if(!FilterButtonInput(ButtonName, false, ButtonIdx))
        {
            InputButtonDataList[ButtonIdx].Active = 0;
            ButtonHandler = InputButtonDataList[ButtonIdx].ButtonHandler;
            ButtonHandlerHold = InputButtonDataList[ButtonIdx].ButtonHandlerHold;
            // End:0x1DB
            if(ButtonHandlerHold != none && InputButtonDataList[ButtonIdx].bHoldHandled)
            {
                // End:0x1D8
                if(!HandleButtonInput(false) && ButtonHandler != none)
                {
                    HandleButtonInput(false);
                }                
            }
            else
            {
                // End:0x1FE
                if(ButtonHandler != none)
                {
                    HandleButtonInput(false);
                }
            }
        }
    }
    //return;    
}

function bool HandleButtonInput_A(bool bPressed)
{
    // End:0xD4
    if(bPressed && !EvilPawn(Outer.Pawn).bIsJumping)
    {
        // End:0xAD
        if(Outer.bCinematicMode)
        {            
            Outer.ConsoleCommand("CANCELMATINEE");
            return true;
        }
        // End:0xC7
        if(bUsingGamepad)
        {
            SmartJump();            
        }
        else
        {
            Jump();
        }        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_A(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_X(bool bPressed)
{
    // End:0x2F
    if(bPressed)
    {
        Outer.Reload();        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_X(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_Y(bool bPressed)
{
    // End:0x2F
    if(bPressed)
    {
        Outer.NextWeapon();        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_Y(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_B(bool bPressed)
{
    // End:0x8A
    if(bPressed)
    {
        // End:0x87
        if(Outer.WorldInfo.GRI.IsMultiplayerGame() || bUsingGamepad)
        {
            Outer.Melee();
        }        
    }
    else
    {
        // End:0x108
        if(!Outer.WorldInfo.GRI.IsMultiplayerGame() && !bUsingGamepad)
        {
            Outer.Melee();
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_B(bool bPressed)
{
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_Start(bool bPressed)
{
    // End:0x30
    if(bPressed)
    {
        Outer.PauseGame();        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_Start(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_Back(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_Back(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftTrigger(bool bPressed)
{
    // End:0x76
    if(bPressed)
    {
        tmpWeapZoom = EvilWeap_Base(Outer.Pawn.Weapon);
        Outer.StartAltFire();        
    }
    else
    {
        // End:0x11E
        if((bHoldZoom && tmpWeapZoom == EvilWeap_Base(Outer.Pawn.Weapon)) && int(tmpWeapZoom.GetZoomedState()) > int(1))
        {
            Outer.StartAltFire();            
        }
        else
        {
            // End:0x27A
            if(((EvilWeap_Base(Outer.Pawn.Weapon) == none) || int(EvilWeap_Base(Outer.Pawn.Weapon).GetZoomedState()) == int(0)) || (EvilWeap_Base(Outer.Pawn.WeaponLeft) != none) && EvilWeap_Base(Outer.Pawn.WeaponLeft).SeperateOffHandFiring)
            {
                Outer.StopAltFire();
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_LeftTrigger(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftBumper(bool bPressed)
{
    // End:0x11B
    if(bPressed)
    {
        // End:0x118
        if((Outer.MyEvilPawn == none) || (int(Outer.MyEvilPawn.PawnAction) == 0) || !Outer.MyEvilPawn.PawnActions[int(Outer.MyEvilPawn.PawnAction)].bDisablePOIs)
        {
            // End:0x118
            if(!Outer.TryPOILookAt())
            {
            }
        }        
    }
    else
    {
        // End:0x13F
        if(!Outer.TryPOILookAway())
        {
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_LeftBumper(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightTrigger(bool bPressed)
{
    // End:0x30
    if(bPressed)
    {
        Outer.StartFire();        
    }
    else
    {
        Outer.StopFire();
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_RightTrigger(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightBumper(bool bPressed)
{
    // End:0x2F
    if(bPressed)
    {
        Outer.GrenadeThrow();        
    }
    else
    {
        Outer.GrenadeRelease();
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_RightBumper(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_DPad(EvilTypes.EGameButtons Button, bool bPressed)
{
    //return ReturnValue;    
}

function bool HandleButtonInputHold_DPad(EvilTypes.EGameButtons Button, bool bPressed)
{
    //return ReturnValue;    
}

function bool HandleButtonInput_DPad_Up(bool bPressed)
{
    return HandleButtonInput_DPad(10, bPressed);
    //return ReturnValue;    
}

function bool HandleButtonInputHold_DPad_Up(bool bPressed)
{
    return HandleButtonInputHold_DPad(10, bPressed);
    //return ReturnValue;    
}

function bool HandleButtonInput_DPad_Left(bool bPressed)
{
    return HandleButtonInput_DPad(11, bPressed);
    //return ReturnValue;    
}

function bool HandleButtonInputHold_DPad_Left(bool bPressed)
{
    return HandleButtonInputHold_DPad(11, bPressed);
    //return ReturnValue;    
}

function bool HandleButtonInput_DPad_Down(bool bPressed)
{
    return HandleButtonInput_DPad(12, bPressed);
    //return ReturnValue;    
}

function bool HandleButtonInputHold_DPad_Down(bool bPressed)
{
    return HandleButtonInputHold_DPad(12, bPressed);
    //return ReturnValue;    
}

function bool HandleButtonInput_DPad_Right(bool bPressed)
{
    return HandleButtonInput_DPad(13, bPressed);
    //return ReturnValue;    
}

function bool HandleButtonInputHold_DPad_Right(bool bPressed)
{
    return HandleButtonInputHold_DPad(13, bPressed);
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftStickButton(bool bPressed)
{
    // End:0x87
    if(bPressed)
    {
        // End:0x40
        if(int(Outer.bDuck) == int(1))
        {
            UnDuck();
        }
        // End:0x84
        if(IsButtonActive(16) && !IsButtonActive(17))
        {
            Outer.SetSprint(true);
        }        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_LeftStickButton(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightStickButton(bool bPressed)
{
    // End:0x50
    if(bPressed)
    {
        // End:0x43
        if(int(Outer.bDuck) == int(1))
        {
            UnDuck();            
        }
        else
        {
            Duck();
        }        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_RightStickButton(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftStickUp(bool bPressed)
{
    local EvilWeap_Base Weap;

    // End:0x55
    if((Outer.Pawn == none) || EvilPawn(Outer.Pawn) == none)
    {
        return true;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0x173
    if(bPressed)
    {
        // End:0xEB
        if(IsButtonActive(18) || IsButtonActive(19))
        {
            Outer.SetMovingSideways(0);
        }
        // End:0x140
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(true);
        }
        // End:0x170
        if(IsButtonActive(14))
        {
            Outer.SetSprint(true);
        }        
    }
    else
    {
        // End:0x1A7
        if(IsButtonActive(18))
        {
            Outer.SetMovingSideways(1);            
        }
        else
        {
            // End:0x1D8
            if(IsButtonActive(19))
            {
                Outer.SetMovingSideways(2);
            }
        }
        // End:0x238
        if(EvilPawn(Outer.Pawn).IsSprinting)
        {
            Outer.SetSprint(false);
        }
        // End:0x28D
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(false);
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftStickDown(bool bPressed)
{
    local EvilWeap_Base Weap;

    // End:0x55
    if((Outer.Pawn == none) || EvilPawn(Outer.Pawn) == none)
    {
        return true;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0x1D7
    if(bPressed)
    {
        Outer.SetMovingBackward(true);
        // End:0x10B
        if(IsButtonActive(18) || IsButtonActive(19))
        {
            Outer.SetMovingSideways(0);
        }
        // End:0x17F
        if(EvilPawn(Outer.Pawn).IsSprinting && !IsButtonActive(16))
        {
            Outer.SetSprint(false);
        }
        // End:0x1D4
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        // End:0x20B
        if(IsButtonActive(18))
        {
            Outer.SetMovingSideways(1);            
        }
        else
        {
            // End:0x23C
            if(IsButtonActive(19))
            {
                Outer.SetMovingSideways(2);
            }
        }
        Outer.SetMovingBackward(false);
        // End:0x2B1
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(false);
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftStickLeft(bool bPressed)
{
    local EvilWeap_Base Weap;

    // End:0x55
    if((Outer.Pawn == none) || EvilPawn(Outer.Pawn) == none)
    {
        return true;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0x1BB
    if(bPressed)
    {
        // End:0xEF
        if(!IsButtonActive(16) && !IsButtonActive(17))
        {
            Outer.SetMovingSideways(1);
        }
        // End:0x163
        if(EvilPawn(Outer.Pawn).IsSprinting && !IsButtonActive(16))
        {
            Outer.SetSprint(false);
        }
        // End:0x1B8
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        Outer.SetMovingSideways(0);
        // End:0x231
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(false);
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftStickRight(bool bPressed)
{
    local EvilWeap_Base Weap;

    // End:0x55
    if((Outer.Pawn == none) || EvilPawn(Outer.Pawn) == none)
    {
        return true;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0x1BB
    if(bPressed)
    {
        // End:0xEF
        if(!IsButtonActive(16) && !IsButtonActive(17))
        {
            Outer.SetMovingSideways(2);
        }
        // End:0x163
        if(EvilPawn(Outer.Pawn).IsSprinting && !IsButtonActive(16))
        {
            Outer.SetSprint(false);
        }
        // End:0x1B8
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        Outer.SetMovingSideways(0);
        // End:0x231
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(false);
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightStickUp(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightStickDown(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightStickLeft(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_RightStickRight(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_PC_Use(bool bPressed)
{
    // End:0x54
    if(!bPressed && !Outer.bCinematicMode)
    {
        Outer.Use();
    }
    return true;
    //return ReturnValue;    
}

final simulated function SetButtonFilter(bool newEnabled, optional EvilTypes.EGameButtons except = 25)
{
    local byte btnidx;

    // End:0x74
    if(newEnabled)
    {
        btnidx = 0;
        J0x1F:

        // End:0x71 [Loop If]
        if(int(btnidx) <= 9)
        {
            // End:0x4F
            if(int(btnidx) == int(except))
            {                
            }
            else
            {
                ForceButtonRelease(btnidx, false);
            }
            ++btnidx;
            // [Loop Continue]
            goto J0x1F;
        }        
    }
    else
    {
        ButtonFilterException = 25;
    }
    bButtonFilter = newEnabled;
    ButtonFilterException = except;
    //return;    
}

simulated exec function Duck()
{
    // End:0x61
    if((Outer.MyEvilPawn != none) && !Outer.MyEvilPawn.CanCrouch())
    {
        return;
    }
    // End:0x17B
    if(UTPawn(Outer.Pawn) != none)
    {
        // End:0xCA
        if(bHoldDuck)
        {
            bHoldDuck = false;
            Outer.bDuck = 0;
            return;
        }
        Outer.bDuck = 1;
        LastDuckTime = Outer.WorldInfo.TimeSeconds;
        EvilWeap_Base(Outer.Pawn.Weapon).SetSpreadCrouching(true);
    }
    //return;    
}

simulated exec function UnDuck()
{
    EvilWeap_Base(Outer.Pawn.Weapon).SetSpreadCrouching(false);
    // End:0x83
    if(!bHoldDuck)
    {
        Outer.bDuck = 0;
    }
    //return;    
}

exec function SmartJump()
{
    // End:0x67
    if((Outer.MyEvilPawn == none) || Outer.MyEvilPawn.CanJump())
    {
        super.SmartJump();
    }
    //return;    
}

exec function Jump()
{
    // End:0x67
    if((Outer.MyEvilPawn == none) || Outer.MyEvilPawn.CanJump())
    {
        super.Jump();
    }
    //return;    
}

function name FindPrimaryBindingForCommand(string Command, optional bool bIgnoreGamepad = false)
{
    local int I;
    local bool bGamepad;

    I = 0;
    J0x10:

    // End:0xFC [Loop If]
    if(I < Bindings.Length)
    {
        // End:0xEE
        if(Bindings[I].Command == Command)
        {
            bGamepad = InStr(string(Bindings[I].Name), "XboxTypeS_") != -1;
            // End:0xEE
            if(!bIgnoreGamepad || !bGamepad)
            {
                return Bindings[I].Name;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x10;
    }
    return 'None';
    //return ReturnValue;    
}

defaultproperties
{
    PressHoldTime=0.2000000
    bUsingGamepad=false
}