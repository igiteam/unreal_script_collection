class EvilPlayerInput extends UTConsolePlayerInput within EvilPlayerController
    transient
    config(Input)
    hidecategories(Object,UIRoot);

struct InputButtonData
{
    var name ButtonNameMapping;
    var delegate<HandleButtonInput> ButtonHandler;
    var byte Active;
    var byte RawActive;

    structdefaultproperties
    {
        ButtonNameMapping="None"
        ButtonHandler=None
        Active=0
        RawActive=0
    }
};

var array<InputButtonData> InputButtonDataList;
var transient float LastInputTime;
var transient EvilWeap_Base tmpWeapZoom;
var protected bool bButtonFilter;
var protected EvilTypes.EGameButtons ButtonFilterException;
//var delegate<HandleButtonInput> __HandleButtonInput__Delegate;

delegate HandleButtonInput(bool bPressed, optional bool bDblClickMove)
{
    //return;    
}

function InitInputSystem()
{
    super(MobilePlayerInput).InitInputSystem();
    InitializeButtonHandling();
    //return;    
}

function InitializeButtonHandling()
{
    InputButtonDataList.Length = 24;
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
    InputButtonDataList[1].ButtonHandler = HandleButtonInput_X;
    InputButtonDataList[2].ButtonHandler = HandleButtonInput_Y;
    InputButtonDataList[3].ButtonHandler = HandleButtonInput_B;
    InputButtonDataList[4].ButtonHandler = HandleButtonInput_Start;
    InputButtonDataList[5].ButtonHandler = HandleButtonInput_Back;
    InputButtonDataList[6].ButtonHandler = HandleButtonInput_LeftTrigger;
    InputButtonDataList[7].ButtonHandler = HandleButtonInput_LeftBumper;
    InputButtonDataList[8].ButtonHandler = HandleButtonInput_RightTrigger;
    InputButtonDataList[9].ButtonHandler = HandleButtonInput_RightBumper;
    InputButtonDataList[10].ButtonHandler = HandleButtonInput_DPad_Up;
    InputButtonDataList[11].ButtonHandler = HandleButtonInput_DPad_Left;
    InputButtonDataList[12].ButtonHandler = HandleButtonInput_DPad_Down;
    InputButtonDataList[13].ButtonHandler = HandleButtonInput_DPad_Right;
    InputButtonDataList[14].ButtonHandler = HandleButtonInput_LeftStickButton;
    InputButtonDataList[15].ButtonHandler = HandleButtonInput_RightStickButton;
    InputButtonDataList[16].ButtonHandler = HandleButtonInput_LeftStickUp;
    InputButtonDataList[17].ButtonHandler = HandleButtonInput_LeftStickDown;
    InputButtonDataList[18].ButtonHandler = HandleButtonInput_LeftStickLeft;
    InputButtonDataList[19].ButtonHandler = HandleButtonInput_LeftStickRight;
    InputButtonDataList[20].ButtonHandler = HandleButtonInput_RightStickUp;
    InputButtonDataList[21].ButtonHandler = HandleButtonInput_RightStickDown;
    InputButtonDataList[22].ButtonHandler = HandleButtonInput_RightStickLeft;
    InputButtonDataList[23].ButtonHandler = HandleButtonInput_RightStickRight;
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

    // End:0x323 [Loop If]
    if(int(Idx) <= 23)
    {
        // End:0x315
        if(int(InputButtonDataList[int(Idx)].RawActive) != int(InputButtonDataList[int(Idx)].Active))
        {
            InputButtonDataList[int(Idx)].Active = InputButtonDataList[int(Idx)].RawActive;
            ButtonHandler = InputButtonDataList[int(Idx)].ButtonHandler;
            // End:0x315
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
    // End:0x153
    if(int(InputButtonDataList[ButtonIdx].RawActive) == int(0))
    {
        InputButtonDataList[ButtonIdx].RawActive = 1;
        // End:0x153
        if(!FilterButtonInput(ButtonName, true, ButtonIdx))
        {
            InputButtonDataList[ButtonIdx].Active = 1;
            ButtonHandler = InputButtonDataList[ButtonIdx].ButtonHandler;
            // End:0x153
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
    local delegate<HandleButtonInput> ButtonHandler;

    LastInputTime = Outer.WorldInfo.TimeSeconds;
    ButtonIdx = FindInputButtonDataIndex(ButtonName);
    // End:0x153
    if(int(InputButtonDataList[ButtonIdx].RawActive) == int(1))
    {
        InputButtonDataList[ButtonIdx].RawActive = 0;
        // End:0x153
        if(!FilterButtonInput(ButtonName, false, ButtonIdx))
        {
            InputButtonDataList[ButtonIdx].Active = 0;
            ButtonHandler = InputButtonDataList[ButtonIdx].ButtonHandler;
            // End:0x153
            if(ButtonHandler != none)
            {
                HandleButtonInput(false);
            }
        }
    }
    //return;    
}

function HandleButtonInput_A(bool bPressed, optional bool bDblClickMove)
{
    // End:0xD5
    if(bPressed && !EvilPawn(Outer.Pawn).bIsJumping)
    {
        // End:0xAE
        if(Outer.bCinematicMode)
        {            
            Outer.ConsoleCommand("CANCELMATINEE");
            return;
        }
        // End:0xC8
        if(bUsingGamepad)
        {
            SmartJump();            
        }
        else
        {
            Jump();
        }        
    }
    //return;    
}

function HandleButtonInput_X(bool bPressed, optional bool bDblClickMove)
{
    // End:0x54
    if(bPressed)
    {
        // End:0x51
        if(Outer.UsableTrigger == none)
        {
            Outer.Reload();
        }        
    }
    else
    {
        Outer.Use();
    }
    //return;    
}

function HandleButtonInput_Y(bool bPressed, optional bool bDblClickMove)
{
    // End:0x30
    if(bPressed)
    {
        Outer.NextWeapon();        
    }
    //return;    
}

function HandleButtonInput_B(bool bPressed, optional bool bDblClickMove)
{
    // End:0x30
    if(bPressed)
    {
        Outer.Melee();        
    }
    //return;    
}

function HandleButtonInput_Start(bool bPressed, optional bool bDblClickMove)
{
    // End:0x11
    if(bPressed)
    {        
    }
    else
    {
        EvilGFxHudWrapper(Outer.myHUD).ShowMenu();
    }
    //return;    
}

function HandleButtonInput_Back(bool bPressed, optional bool bDblClickMove)
{
    // End:0x179
    if(bPressed)
    {
        // End:0x6B
        if(Outer.bCinematicMode)
        {            
            Outer.ConsoleCommand("CANCELMATINEE");            
        }
        else
        {
            // End:0x176
            if((Outer.MyEvilPawn == none) || (int(Outer.MyEvilPawn.PawnAction) == 0) || !Outer.MyEvilPawn.PawnActions[int(Outer.MyEvilPawn.PawnAction)].bDisablePOIs)
            {
                // End:0x176
                if(!Outer.TryPOILookAt())
                {
                }
            }
        }        
    }
    else
    {
        // End:0x19D
        if(!Outer.TryPOILookAway())
        {
        }
    }
    //return;    
}

function HandleButtonInput_LeftTrigger(bool bPressed, optional bool bDblClickMove)
{
    // End:0x31
    if(bPressed)
    {
        Outer.StartAltFire();        
    }
    else
    {
        // End:0x18D
        if(((EvilWeap_Base(Outer.Pawn.Weapon) == none) || int(EvilWeap_Base(Outer.Pawn.Weapon).GetZoomedState()) == int(0)) || (EvilWeap_Base(Outer.Pawn.WeaponLeft) != none) && EvilWeap_Base(Outer.Pawn.WeaponLeft).SeperateOffHandFiring)
        {
            Outer.StopAltFire();
        }
    }
    //return;    
}

function HandleButtonInput_LeftBumper(bool bPressed, optional bool bDblClickMove)
{
    // End:0x30
    if(bPressed)
    {
        Outer.MeleeKick();        
    }
    //return;    
}

function HandleButtonInput_RightTrigger(bool bPressed, optional bool bDblClickMove)
{
    // End:0x31
    if(bPressed)
    {
        Outer.StartFire();        
    }
    else
    {
        Outer.StopFire();
    }
    //return;    
}

function HandleButtonInput_RightBumper(bool bPressed, optional bool bDblClickMove)
{
    // End:0x30
    if(bPressed)
    {
        Outer.GrenadeThrow();        
    }
    else
    {
        Outer.GrenadeRelease();
    }
    //return;    
}

function HandleButtonInput_DPad(EvilTypes.EGameButtons Button, bool bPressed, optional bool bDblClickMove)
{
    //return;    
}

function HandleButtonInput_DPad_Up(bool bPressed, optional bool bDblClickMove)
{
    HandleButtonInput_DPad(10, bPressed, bDblClickMove);
    //return;    
}

function HandleButtonInput_DPad_Left(bool bPressed, optional bool bDblClickMove)
{
    HandleButtonInput_DPad(11, bPressed, bDblClickMove);
    //return;    
}

function HandleButtonInput_DPad_Down(bool bPressed, optional bool bDblClickMove)
{
    HandleButtonInput_DPad(12, bPressed, bDblClickMove);
    //return;    
}

function HandleButtonInput_DPad_Right(bool bPressed, optional bool bDblClickMove)
{
    HandleButtonInput_DPad(13, bPressed, bDblClickMove);
    //return;    
}

function HandleButtonInput_LeftStickButton(bool bPressed, optional bool bDblClickMove)
{
    // End:0xC7
    if(bPressed)
    {
        // End:0x41
        if(int(Outer.bDuck) == int(1))
        {
            UnDuck();
        }
        // End:0x85
        if(IsButtonActive(16) && !IsButtonActive(17))
        {
            Outer.SetSprint(true);
        }
        // End:0xC4
        if(IsButtonActive(15))
        {            
            Outer.ConsoleCommand("shot");
        }        
    }
    //return;    
}

function HandleButtonInput_RightStickButton(bool bPressed, optional bool bDblClickMove)
{
    // End:0x90
    if(bPressed)
    {
        // End:0x44
        if(int(Outer.bDuck) == int(1))
        {
            UnDuck();            
        }
        else
        {
            Duck();
        }
        // End:0x8D
        if(IsButtonActive(14))
        {            
            Outer.ConsoleCommand("shot");
        }        
    }
    //return;    
}

function HandleButtonInput_LeftStickUp(bool bPressed, optional bool bDblClickMove)
{
    local EvilWeap_Base Weap;

    // End:0x56
    if((Outer.Pawn == none) || EvilPawn(Outer.Pawn) == none)
    {
        return;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0x131
    if(bPressed)
    {
        // End:0xFE
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(true);
        }
        // End:0x12E
        if(IsButtonActive(14))
        {
            Outer.SetSprint(true);
        }        
    }
    else
    {
        // End:0x191
        if(EvilPawn(Outer.Pawn).IsSprinting)
        {
            Outer.SetSprint(false);
        }
        // End:0x1E6
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(false);
        }
    }
    //return;    
}

function HandleButtonInput_LeftStickDown(bool bPressed, optional bool bDblClickMove)
{
    local EvilWeap_Base Weap;

    // End:0x56
    if((Outer.Pawn == none) || EvilPawn(Outer.Pawn) == none)
    {
        return;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0x175
    if(bPressed)
    {
        // End:0x11D
        if(EvilPawn(Outer.Pawn).IsSprinting && !IsButtonActive(16))
        {
            Outer.SetSprint(false);
        }
        // End:0x172
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        // End:0x1CA
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(false);
        }
    }
    //return;    
}

function HandleButtonInput_LeftStickLeft(bool bPressed, optional bool bDblClickMove)
{
    local EvilWeap_Base Weap;

    // End:0x56
    if((Outer.Pawn == none) || EvilPawn(Outer.Pawn) == none)
    {
        return;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0x175
    if(bPressed)
    {
        // End:0x11D
        if(EvilPawn(Outer.Pawn).IsSprinting && !IsButtonActive(16))
        {
            Outer.SetSprint(false);
        }
        // End:0x172
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        // End:0x1CA
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(false);
        }
    }
    //return;    
}

function HandleButtonInput_LeftStickRight(bool bPressed, optional bool bDblClickMove)
{
    local EvilWeap_Base Weap;

    // End:0x56
    if((Outer.Pawn == none) || EvilPawn(Outer.Pawn) == none)
    {
        return;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0x175
    if(bPressed)
    {
        // End:0x11D
        if(EvilPawn(Outer.Pawn).IsSprinting && !IsButtonActive(16))
        {
            Outer.SetSprint(false);
        }
        // End:0x172
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        // End:0x1CA
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(false);
        }
    }
    //return;    
}

function HandleButtonInput_RightStickUp(bool bPressed, optional bool bDblClickMove)
{
    // End:0x11
    if(bPressed)
    {        
    }
    //return;    
}

function HandleButtonInput_RightStickDown(bool bPressed, optional bool bDblClickMove)
{
    // End:0x11
    if(bPressed)
    {        
    }
    //return;    
}

function HandleButtonInput_RightStickLeft(bool bPressed, optional bool bDblClickMove)
{
    // End:0x11
    if(bPressed)
    {        
    }
    //return;    
}

function HandleButtonInput_RightStickRight(bool bPressed, optional bool bDblClickMove)
{
    // End:0x11
    if(bPressed)
    {        
    }
    //return;    
}

final simulated function SetButtonFilter(bool newEnabled, optional EvilTypes.EGameButtons except = 24)
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
        ButtonFilterException = 24;
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
    // End:0x1A0
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
        Outer.SetSprint(false);
        // End:0x163
        if((Outer.WorldInfo.TimeSeconds - LastDuckTime) < DoubleClickTime)
        {
            bHoldDuck = true;
        }
        LastDuckTime = Outer.WorldInfo.TimeSeconds;
    }
    //return;    
}

simulated exec function UnDuck()
{
    // End:0x30
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

defaultproperties
{
    bUsingGamepad=false
}