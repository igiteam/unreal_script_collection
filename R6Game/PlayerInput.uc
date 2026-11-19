class PlayerInput extends Input within PlayerController
    transient
    native
    config(Input);

var globalconfig bool bInvertMouse;
var bool bWasForward;
var bool bWasBack;
var bool bWasLeft;
var bool bWasRight;
var bool bEdgeForward;
var bool bEdgeBack;
var bool bEdgeLeft;
var bool bEdgeRight;
var bool bAdjustSampling;
var globalconfig float MouseSensitivity;
var float DoubleClickTimer;
var globalconfig float DoubleClickTime;
var input float aBaseX;
var input float aBaseY;
var input float aBaseZ;
var input float aMouseX;
var input float aMouseY;
var input float aForward;
var input float aTurn;
var input float aStrafe;
var input float aUp;
var input float aLookUp;
var transient float RawJoyUp;
var transient float RawJoyRight;
var transient float RawJoyLookRight;
var transient float RawJoyLookUp;
var() config float MoveForwardSpeed;
var() config float MoveStrafeSpeed;
var() config float LookRightScale;
var() config float LookUpScale;
var input byte bStrafe;
var input byte bTurn180;
var input byte bXAxis;
var input byte bYAxis;

exec function bool InvertMouse()
{
    bInvertMouse = !bInvertMouse;
    SaveConfig();
    return bInvertMouse;
    return;
}

function DrawHUD(HUD H)
{
    return;
}

function PreProcessInput(float DeltaTime)
{
    return;
}

function PostProcessInput(float DeltaTime)
{
    return;
}

event PlayerInput(float DeltaTime)
{
    local float FOVScale, TimeScale;

    RawJoyUp = aBaseY;
    RawJoyRight = aStrafe;
    RawJoyLookRight = aTurn;
    RawJoyLookUp = aLookUp;
    PreProcessInput(DeltaTime);
    TimeScale = 100.0000000 * DeltaTime;
    aBaseY *= (TimeScale * MoveForwardSpeed);
    aStrafe *= (TimeScale * MoveStrafeSpeed);
    aUp *= (TimeScale * MoveStrafeSpeed);
    aTurn *= (TimeScale * LookRightScale);
    aLookUp *= (TimeScale * LookUpScale);
    PostProcessInput(DeltaTime);
    ProcessInputMatching(DeltaTime);
    bEdgeForward = bWasForward ^^ (aBaseY > float(0));
    bEdgeBack = bWasBack ^^ (aBaseY < float(0));
    bEdgeLeft = bWasLeft ^^ (aStrafe < float(0));
    bEdgeRight = bWasRight ^^ (aStrafe > float(0));
    bWasForward = aBaseY > float(0);
    bWasBack = aBaseY < float(0);
    bWasLeft = aStrafe < float(0);
    bWasRight = aStrafe > float(0);
    aMouseX *= MouseSensitivity;
    aMouseY *= MouseSensitivity;
    // End:0x1A3
    if(int(bStrafe) > 0)
    {
        aStrafe += (aBaseX + aMouseX);        
    }
    else
    {
        aTurn += (aBaseX + aMouseX);
    }
    aLookUp += aMouseY;
    // End:0x1D7
    if(bInvertMouse)
    {
        aLookUp *= -1.0000000;
    }
    aForward += aBaseY;
    FOVScale = Outer.GetFOVAngle() * 0.0111100;
    aLookUp *= FOVScale;
    aTurn *= FOVScale;
    Outer.HandleWalking();
    // End:0x25D
    if(Outer.IsMoveInputIgnored())
    {
        aForward = 0.0000000;
        aStrafe = 0.0000000;
        aUp = 0.0000000;
    }
    // End:0x286
    if(Outer.IsLookInputIgnored())
    {
        aTurn = 0.0000000;
        aLookUp = 0.0000000;
    }
    return;
}

function Actor.EDoubleClickDir CheckForDoubleClickMove(float DeltaTime)
{
    local Actor.EDoubleClickDir DoubleClickMove, OldDoubleClick;

    // End:0x24
    if(int(Outer.DoubleClickDir) == int(5))
    {
        DoubleClickMove = 5;        
    }
    else
    {
        DoubleClickMove = 0;
    }
    // End:0x2CB
    if(DoubleClickTime > 0.0000000)
    {
        // End:0xAB
        if(int(Outer.DoubleClickDir) == int(5))
        {
            // End:0xA8
            if((Outer.Pawn != none) && int(Outer.Pawn.Physics) == int(1))
            {
                DoubleClickTimer = 0.0000000;
                Outer.DoubleClickDir = 6;
            }            
        }
        else
        {
            // End:0x202
            if(int(Outer.DoubleClickDir) != int(6))
            {
                OldDoubleClick = Outer.DoubleClickDir;
                Outer.DoubleClickDir = 0;
                // End:0x111
                if(bEdgeForward && bWasForward)
                {
                    Outer.DoubleClickDir = 3;                    
                }
                else
                {
                    // End:0x139
                    if(bEdgeBack && bWasBack)
                    {
                        Outer.DoubleClickDir = 4;                        
                    }
                    else
                    {
                        // End:0x161
                        if(bEdgeLeft && bWasLeft)
                        {
                            Outer.DoubleClickDir = 1;                            
                        }
                        else
                        {
                            // End:0x186
                            if(bEdgeRight && bWasRight)
                            {
                                Outer.DoubleClickDir = 2;
                            }
                        }
                    }
                }
                // End:0x1B6
                if(int(Outer.DoubleClickDir) == int(0))
                {
                    Outer.DoubleClickDir = OldDoubleClick;                    
                }
                else
                {
                    // End:0x1EE
                    if(int(Outer.DoubleClickDir) != int(OldDoubleClick))
                    {
                        DoubleClickTimer = DoubleClickTime + (0.5000000 * DeltaTime);                        
                    }
                    else
                    {
                        DoubleClickMove = Outer.DoubleClickDir;
                    }
                }
            }
        }
        // End:0x262
        if(int(Outer.DoubleClickDir) == int(6))
        {
            DoubleClickTimer = FMin(DoubleClickTimer - DeltaTime, 0.0000000);
            // End:0x25F
            if(DoubleClickTimer < -0.3500000)
            {
                Outer.DoubleClickDir = 0;
                DoubleClickTimer = DoubleClickTime;
            }            
        }
        else
        {
            // End:0x2CB
            if((int(Outer.DoubleClickDir) != int(0)) && int(Outer.DoubleClickDir) != int(5))
            {
                DoubleClickTimer -= DeltaTime;
                // End:0x2CB
                if(DoubleClickTimer < float(0))
                {
                    Outer.DoubleClickDir = 0;
                    DoubleClickTimer = DoubleClickTime;
                }
            }
        }
    }
    return DoubleClickMove;
    return;
}

final function ProcessInputMatching(float DeltaTime)
{
    local float Value;
    local int I, MatchIdx;
    local bool bMatch;

    I = 0;
    J0x07:

    // End:0x3EA [Loop If]
    if(I < Outer.InputRequests.Length)
    {
        // End:0x3E0
        if(((Outer.InputRequests[I].MatchActor != none) && Outer.InputRequests[I].MatchIdx >= 0) && Outer.InputRequests[I].MatchIdx < Outer.InputRequests[I].Inputs.Length)
        {
            MatchIdx = Outer.InputRequests[I].MatchIdx;
            // End:0x1C0
            if((MatchIdx != 0) && (Outer.WorldInfo.TimeSeconds - Outer.InputRequests[I].LastMatchTime) >= Outer.InputRequests[I].Inputs[MatchIdx].TimeDelta)
            {
                Outer.InputRequests[I].LastMatchTime = 0.0000000;
                Outer.InputRequests[I].MatchIdx = 0;
                // End:0x1BD
                if(Outer.InputRequests[I].FailedFuncName != 'None')
                {
                    Outer.InputRequests[I].MatchActor.SetTimer(0.0100000, false, Outer.InputRequests[I].FailedFuncName);
                }
                // [Explicit Continue]
                goto J0x3E0;
            }
            Value = 0.0000000;
            switch(Outer.InputRequests[I].Inputs[MatchIdx].Type)
            {
                // End:0x204
                case 0:
                    Value = aStrafe;
                    // End:0x21A
                    break;
                // End:0x217
                case 1:
                    Value = aBaseY;
                    // End:0x21A
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            switch(Outer.InputRequests[I].Inputs[MatchIdx].Action)
            {
                // End:0x27A
                case 0:
                    bMatch = Value >= Outer.InputRequests[I].Inputs[MatchIdx].Value;
                    // End:0x2B7
                    break;
                // End:0x2B4
                case 1:
                    bMatch = Value <= Outer.InputRequests[I].Inputs[MatchIdx].Value;
                    // End:0x2B7
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x3E0
            if(bMatch)
            {
                Outer.InputRequests[I].LastMatchTime = Outer.WorldInfo.TimeSeconds;
                Outer.InputRequests[I].MatchIdx++;
                // End:0x3E0
                if(Outer.InputRequests[I].MatchIdx >= Outer.InputRequests[I].Inputs.Length)
                {
                    // End:0x3A6
                    if(Outer.InputRequests[I].MatchFuncName != 'None')
                    {
                        Outer.InputRequests[I].MatchActor.SetTimer(0.0100000, false, Outer.InputRequests[I].MatchFuncName);
                    }
                    Outer.InputRequests[I].LastMatchTime = 0.0000000;
                    Outer.InputRequests[I].MatchIdx = 0;
                }
            }
        }
        J0x3E0:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

exec function Jump()
{
    // End:0x3E
    if(Outer.WorldInfo.Pauser == Outer.PlayerReplicationInfo)
    {
        Outer.SetPause(false);        
    }
    else
    {
        Outer.bPressedJump = true;
    }
    return;
}

defaultproperties
{
    bAdjustSampling=true
    MouseSensitivity=60.0000000
    DoubleClickTime=0.2500000
    MoveForwardSpeed=1200.0000000
    MoveStrafeSpeed=1200.0000000
    LookRightScale=300.0000000
    LookUpScale=-250.0000000
    Bindings[0]=(Name="Fire",Command="Button bFire | StartFire | OnRelease StopFire",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[1]=(Name="AltFire",Command="StartAltFire | OnRelease StopAltFire",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[2]=(Name="MoveForward",Command="Axis aBaseY Speed=1.0",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[3]=(Name="MoveBackward",Command="Axis aBaseY Speed=-1.0",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[4]=(Name="TurnLeft",Command="Axis aBaseX Speed=-200.0 AbsoluteAxis=100",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[5]=(Name="TurnRight",Command="Axis aBaseX  Speed=+200.0 AbsoluteAxis=100",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[6]=(Name="StrafeLeft",Command="Axis aStrafe Speed=-1.0",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[7]=(Name="StrafeRight",Command="Axis aStrafe Speed=+1.0",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[8]=(Name="Jump",Command="Jump | Axis aUp Speed=+1.0 AbsoluteAxis=100",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[9]=(Name="DoDuck",Command="Duck | Axis aUp Speed=-1.0  AbsoluteAxis=100",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[10]=(Name="Look",Command="Button bLook",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[11]=(Name="DoPause",Command="Pause",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[12]=(Name="LookToggle",Command="Toggle bLook",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[13]=(Name="LookUp",Command="Axis aLookUp Speed=+25.0 AbsoluteAxis=100",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[14]=(Name="LookDown",Command="Axis aLookUp Speed=-25.0 AbsoluteAxis=100",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[15]=(Name="CenterView",Command="Button bSnapLevel",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[16]=(Name="Walking",Command="Button bRun",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[17]=(Name="Strafe",Command="Button bStrafe",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[18]=(Name="NextWeapon",Command="NextWeapon",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[19]=(Name="ViewTeam",Command="ViewClass Pawn",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[20]=(Name="TurnToNearest",Command="Button bTurnToNearest",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[21]=(Name="Turn180",Command="Button bTurn180",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[22]=(Name="W",Command="Axis aForward",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[23]=(Name="S",Command="Axis aForward Speed=-1.0f",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[24]=(Name="A",Command="Axis aStrafe Speed=-1.0f",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[25]=(Name="D",Command="Axis aStrafe",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[26]=(Name="MouseX",Command="Count bXAxis | Axis aMouseX",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[27]=(Name="MouseY",Command="Count bYAxis | Axis aMouseY",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[28]=(Name="LeftMouseButton",Command="Button bFire | NextPlayer",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[29]=(Name="RightMouseButton",Command="NextScope | PrevPlayer",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[30]=(Name="Escape",Command="OpenMenu",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[31]=(Name="E",Command="SwitchWeaponBut | OnHold SwitchWeaponButHeld | OnRelease SwitchWeaponButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[32]=(Name="MouseScrollUp",Command="PrevWeapon",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[33]=(Name="MouseScrollDown",Command="NextWeapon",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[34]=(Name="C",Command="ChangePOV | SetVisionModeBut | OnHold VisionModeButHeld | OnRelease SetVisionModeButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[35]=(Name="P",Command="TogglePhysicsMode",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[36]=(Name="LeftShift",Command="TakeCoverToggle",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[37]=(Name="F",Command="PlayerAction | OnRelease PlayerActionOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[38]=(Name="XboxTypeS_A",Command="PlayerAction | OnRelease PlayerActionOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[39]=(Name="XboxTypeS_B",Command="PlayerPressB | UseGadgetButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[40]=(Name="XboxTypeS_X",Command="ReloadBut | OnHold ReloadButHeld | OnRelease ReloadButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[41]=(Name="XboxTypeS_Y",Command="SetVisionModeBut | OnHold VisionModeButHeld | OnRelease SetVisionModeButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[42]=(Name="XboxTypeS_Back",Command="TagEnemyBut | OnHold TagEnemyButHeld | OnRelease TagEnemyButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[43]=(Name="XboxTypeS_Start",Command="OpenMenu",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[44]=(Name="XboxTypeS_LeftShoulder",Command="ChangePOV | ROEBut",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[45]=(Name="XboxTypeS_RightShoulder",Command="SwitchWeaponBut | OnHold SwitchWeaponButHeld | OnRelease SwitchWeaponButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[46]=(Name="XboxTypeS_DPad_Up",Command="GiveOrderUp 0",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[47]=(Name="XboxTypeS_DPad_Down",Command="GiveOrderDown 0",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[48]=(Name="XboxTypeS_DPad_Left",Command="GiveOrderLeft 0",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[49]=(Name="XboxTypeS_DPad_Right",Command="GiveOrderRight 0",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[50]=(Name="XboxTypeS_RightTrigger",Command="Axis m_aFire | NextPlayer",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[51]=(Name="XboxTypeS_LeftTrigger",Command="Axis m_aTakeCover | PrevPlayer",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[52]=(Name="XboxTypeS_LeftX",Command="Axis aStrafe",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[53]=(Name="XboxTypeS_LeftY",Command="Axis aForward Invert=1",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[54]=(Name="XboxTypeS_RightX",Command="Axis aTurn",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[55]=(Name="XboxTypeS_RightY",Command="Axis aLookup",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[56]=(Name="XboxTypeS_LeftThumbstick",Command="ChangePosture",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[57]=(Name="XboxTypeS_RightThumbstick",Command="NextScope",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[58]=(Name="M",Command="ROEBut",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[59]=(Name="RightShift",Command="TakeCoverToggle",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[60]=(Name="Tab",Command="ChangePosture",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[61]=(Name="X",Command="TagEnemyBut | OnHold TagEnemyButHeld | OnRelease TagEnemyButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[62]=(Name="R",Command="ReloadBut | OnHold ReloadButHeld | OnRelease ReloadButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[63]=(Name="Q",Command="PlayerPressB | OnRelease UseGadgetButOff",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[64]=(Name="Up",Command="GiveOrderUp 0 | OnHold GiveOrderUp 1 | OnRelease GiveOrderUp 2",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[65]=(Name="Left",Command="GiveOrderLeft 0 | OnHold GiveOrderLeft 1 | OnRelease GiveOrderLeft 2",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[66]=(Name="Right",Command="GiveOrderRight 0 | OnHold GiveOrderRight 1 | OnRelease GiveOrderRight 2",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[67]=(Name="Down",Command="GiveOrderDown 0 | OnHold GiveOrderDown 1 | OnRelease GiveOrderDown 2",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[68]=(Name="B",Command="PlayerPressB",Control=false,Shift=false,Axis=false,Alt=false)
    Bindings[69]=(Name="Four",Command="TagEnemy",Control=false,Shift=false,Axis=false,Alt=false)
}