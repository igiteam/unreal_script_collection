class AdvPlayerInput extends EvilPlayerInput within AdvPlayerController
    transient
    config(Input)
    hidecategories(Object,UIRoot);

const MAX_BINDINGS = 31;

var EvilTypes.EGameButtons DPADStoredButton;

function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
{
    local AdvPRI PRI;

    // End:0xB7
    if(((ControllerId == LocalPlayer(Outer.Player).ControllerId) && int(Event) == int(0)) && Outer.bShowingTutorial)
    {
        Outer.ClientHideTutorial();
        return true;        
    }
    else
    {
        // End:0x26F
        if(((int(Event) == int(0)) && int(AdvGRI(Outer.WorldInfo.GRI).LastVotingState) == int(1)) && !Outer.WorldInfo.IsConsoleBuild(0) && !bUsingGamepad)
        {
            PRI = AdvPRI(Outer.PlayerReplicationInfo);
            // End:0x26F
            if(!PRI.bSubmittedVote)
            {
                // End:0x21F
                if(string(Key) == Class'AdvGFxVotingComponent'.default.YesPCKey)
                {
                    PRI.SubmitVote(true);
                    return true;                    
                }
                else
                {
                    // End:0x26F
                    if(string(Key) == Class'AdvGFxVotingComponent'.default.NoPCKey)
                    {
                        PRI.SubmitVote(false);
                        return true;
                    }
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_DPad(EvilTypes.EGameButtons Button, bool bPressed)
{
    // End:0x152
    if(!Outer.WorldInfo.GRI.IsMultiplayerGame())
    {
        // End:0x71
        if(bPressed)
        {
            DPADStoredButton = Button;            
        }
        else
        {
            switch(DPADStoredButton)
            {
                // End:0xB6
                case 10:
                    Class'AdvGFxUI_InventoryMenu'.static.SelectInventory(5, Outer);
                    // End:0x14F
                    break;
                // End:0xE8
                case 11:
                    Class'AdvGFxUI_InventoryMenu'.static.SelectInventory(3, Outer);
                    // End:0x14F
                    break;
                // End:0x11A
                case 13:
                    Class'AdvGFxUI_InventoryMenu'.static.SelectInventory(4, Outer);
                    // End:0x14F
                    break;
                // End:0x14C
                case 12:
                    Class'AdvGFxUI_InventoryMenu'.static.SelectInventory(6, Outer);
                    // End:0x14F
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }        
    }
    else
    {
        // End:0x2E1
        if(bPressed)
        {
            // End:0x229
            if(!bUsingGamepad)
            {
                switch(Button)
                {
                    // End:0x1A9
                    case 10:
                        Outer.SelectPerk(0);
                        // End:0x226
                        break;
                    // End:0x1D2
                    case 11:
                        Outer.SelectPerk(2);
                        // End:0x226
                        break;
                    // End:0x1FB
                    case 13:
                        Outer.SelectPerk(3);
                        // End:0x226
                        break;
                    // End:0x223
                    case 12:
                        Outer.SelectPerk(1);
                        // End:0x226
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }                
            }
            else
            {
                switch(Button)
                {
                    // End:0x264
                    case 10:
                        Outer.SelectPerk(0);
                        // End:0x2E1
                        break;
                    // End:0x28C
                    case 11:
                        Outer.SelectPerk(1);
                        // End:0x2E1
                        break;
                    // End:0x2B5
                    case 13:
                        Outer.SelectPerk(3);
                        // End:0x2E1
                        break;
                    // End:0x2DE
                    case 12:
                        Outer.SelectPerk(2);
                        // End:0x2E1
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
            }
        }
        else
        {
        }
        return true;
        //return ReturnValue;        
    }
}

function bool HandleButtonInputHold_DPad(EvilTypes.EGameButtons Button, bool bPressed)
{
    // End:0x13D
    if(!Outer.WorldInfo.GRI.IsMultiplayerGame())
    {
        // End:0x11C
        if(bPressed)
        {
            switch(DPADStoredButton)
            {
                // End:0x98
                case 10:
                    Outer.ToggleQuickMenu(5);
                    // End:0x119
                    break;
                // End:0xC2
                case 11:
                    Outer.ToggleQuickMenu(3);
                    // End:0x119
                    break;
                // End:0xEC
                case 13:
                    Outer.ToggleQuickMenu(4);
                    // End:0x119
                    break;
                // End:0x116
                case 12:
                    Outer.ToggleQuickMenu(6);
                    // End:0x119
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
        else
        {
            Outer.ToggleQuickMenu();
        }
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_B(bool bPressed)
{
    // End:0x0F
    if(bUsingGamepad)
    {
        return false;
    }
    // End:0xB2
    if(!Outer.WorldInfo.GRI.IsMultiplayerGame())
    {
        // End:0x8F
        if(bPressed)
        {
            Outer.ToggleQuickMenu(5, true);            
        }
        else
        {
            Outer.ToggleQuickMenu();
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool HandleButtonInput_LeftBumper(bool bPressed)
{
    // End:0x10
    if(bPressed)
    {        
    }
    else
    {
        Class'AdvGFxUI_InventoryMenu'.static.SelectInventory(1, Outer);
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInputHold_LeftBumper(bool bPressed)
{
    // End:0x30
    if(bPressed)
    {
        Outer.FocusFlashlight(true);        
    }
    else
    {
        Outer.FocusFlashlight(false);
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_Start(bool bPressed)
{
    local AdvPRI PRI;

    // End:0x182
    if(bPressed)
    {
        PRI = AdvPRI(Outer.PlayerReplicationInfo);
        // End:0x16A
        if(((int(AdvGRI(Outer.WorldInfo.GRI).LastVotingState) == int(1)) && !PRI.bSubmittedVote) && Outer.WorldInfo.IsConsoleBuild(1) || !Outer.WorldInfo.IsConsoleBuild(0) && bUsingGamepad)
        {
            PRI.SubmitVote(true);            
        }
        else
        {
            return super.HandleButtonInput_Start(bPressed);
        }        
    }
    else
    {
        return super.HandleButtonInput_Start(bPressed);
    }
    return true;
    //return ReturnValue;    
}

function bool HandleButtonInput_Back(bool bPressed)
{
    local AdvGRI GRI;
    local AdvPRI PRI;
    local bool bScoreboardIsOpen;

    GRI = AdvGRI(Outer.WorldInfo.GRI);
    PRI = AdvPRI(Outer.PlayerReplicationInfo);
    bScoreboardIsOpen = ((AdvGFxHudWrapper(Outer.myHUD) != none) && AdvGFxHudWrapper(Outer.myHUD).AdvScoreboardMovie != none) && AdvGFxHudWrapper(Outer.myHUD).AdvScoreboardMovie.bMovieIsOpen;
    // End:0x4E4
    if(bPressed)
    {
        // End:0x1B1
        if(Outer.bCinematicMode)
        {            
            Outer.ConsoleCommand("CANCELMATINEE");            
        }
        else
        {
            // End:0x4C2
            if(((GRI == none) && int(Outer.WorldInfo.NetMode) == int(NM_Client)) || GRI.IsMultiplayerGame())
            {
                // End:0x3A7
                if(Outer.WorldInfo.IsConsoleBuild(0))
                {
                    // End:0x28C
                    if(bScoreboardIsOpen)
                    {
                        Outer.HideInGameStatsScreen();                        
                    }
                    else
                    {
                        // End:0x385
                        if(((int(GRI.LastVotingState) == int(1)) && !PRI.bSubmittedVote) && Outer.WorldInfo.IsConsoleBuild(1) || !Outer.WorldInfo.IsConsoleBuild(0) && bUsingGamepad)
                        {
                            PRI.SubmitVote(false);                            
                        }
                        else
                        {
                            Outer.ShowInGameStatsScreen();
                        }
                    }                    
                }
                else
                {
                    // End:0x4A0
                    if(((int(GRI.LastVotingState) == int(1)) && !PRI.bSubmittedVote) && Outer.WorldInfo.IsConsoleBuild(1) || !Outer.WorldInfo.IsConsoleBuild(0) && bUsingGamepad)
                    {
                        PRI.SubmitVote(false);                        
                    }
                    else
                    {
                        Outer.ShowInGameStatsScreen();
                    }
                }                
            }
            else
            {
                Outer.ToggleInventoryMap();
            }
        }        
    }
    else
    {
        // End:0x5D8
        if(!Outer.bCinematicMode)
        {
            // End:0x5D8
            if(((GRI == none) && int(Outer.WorldInfo.NetMode) == int(NM_Client)) || GRI.IsMultiplayerGame())
            {
                // End:0x5D5
                if(!Outer.WorldInfo.IsConsoleBuild(0))
                {
                    Outer.HideInGameStatsScreen();
                }                
            }
        }
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

function bool HandleButtonInput_PC_Use(bool bPressed)
{
    super.HandleButtonInput_PC_Use(bPressed);
    // End:0x66
    if(bPressed && !Outer.bCinematicMode)
    {
        Outer.Puzzle_Jump();
    }
    return true;
    //return ReturnValue;    
}

function bool CanUseUsableTrigger()
{
    // End:0x26
    if(Outer.UsableTrigger == none)
    {
        return false;
    }
    // End:0x90
    if((EvilTouchPickUp_AmmoAll(Outer.UsableTrigger.Base) != none) && !Outer.bShowAmmoBoxCaption)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

exec function SmartJump()
{
    // End:0x61
    if(bUsingGamepad && (CanUseUsableTrigger()) || Outer.IsThereOtherReasonToLetUseHold())
    {
        Outer.Use();
        return;
    }
    // End:0x96
    if(int(Outer.bDuck) == int(1))
    {
        UnDuck();
        return;
    }
    super.SmartJump();
    Outer.Puzzle_Jump();
    //return;    
}

function bool HandleButtonInput_A(bool bPressed)
{
    // End:0x1B8
    if(bPressed)
    {
        // End:0x69
        if(Outer.bCinematicMode)
        {            
            Outer.ConsoleCommand("CANCELMATINEE");
            return true;
        }
        Outer.PreventDeath();
        // End:0x156
        if(((Outer.Pawn != none) && !EvilPawn(Outer.Pawn).bIsJumping) && !PlayerController(Outer.Pawn.Controller).IsMoveInputIgnored())
        {
            SmartJump();            
        }
        else
        {
            // End:0x1B5
            if(AdvPRI(Outer.PlayerReplicationInfo).bIsTournamentSpectator)
            {
                Outer.SwitchView();
            }
        }        
    }
    else
    {
        // End:0x1FB
        if(!Outer.bCinematicMode)
        {
            Outer.Input_A_Released();
        }
    }
    return true;
    //return ReturnValue;    
}

function GetDefaultBindingsForPC(out array<BindingInfo> DefaultBinding)
{
    DefaultBinding.Remove(0, DefaultBinding.Length);    
    DefaultBinding.Length = 31;
    DefaultBinding[0].Command = "GBA_MoveForward";
    DefaultBinding[0].PrimaryBind = 'W';
    DefaultBinding[0].SecondaryBind = 'None';
    DefaultBinding[1].Command = "GBA_Backward";
    DefaultBinding[1].PrimaryBind = 'S';
    DefaultBinding[1].SecondaryBind = 'None';
    DefaultBinding[2].Command = "GBA_StrafeLeft";
    DefaultBinding[2].PrimaryBind = 'A';
    DefaultBinding[2].SecondaryBind = 'None';
    DefaultBinding[3].Command = "GBA_StrafeRight";
    DefaultBinding[3].PrimaryBind = 'D';
    DefaultBinding[3].SecondaryBind = 'None';
    DefaultBinding[4].Command = "GBA_Jump";
    DefaultBinding[4].PrimaryBind = 'SpaceBar';
    DefaultBinding[4].SecondaryBind = 'None';
    DefaultBinding[5].Command = "GBA_Fire";
    DefaultBinding[5].PrimaryBind = 'LeftMouseButton';
    DefaultBinding[5].SecondaryBind = 'None';
    DefaultBinding[6].Command = "GBA_AltFire";
    DefaultBinding[6].PrimaryBind = 'RightMouseButton';
    DefaultBinding[6].SecondaryBind = 'None';
    DefaultBinding[7].Command = "GBA_Duck";
    DefaultBinding[7].PrimaryBind = 'LeftControl';
    DefaultBinding[7].SecondaryBind = 'None';
    DefaultBinding[8].Command = "GBA_Use";
    DefaultBinding[8].PrimaryBind = 'E';
    DefaultBinding[8].SecondaryBind = 'None';
    DefaultBinding[9].Command = "GBA_Stats";
    DefaultBinding[9].PrimaryBind = 'Tab';
    DefaultBinding[9].SecondaryBind = 'None';
    DefaultBinding[10].Command = "GBA_NextWeapon";
    DefaultBinding[10].PrimaryBind = 'MouseScrollDown';
    DefaultBinding[10].SecondaryBind = 'None';
    DefaultBinding[11].Command = "GBA_PrevWeapon";
    DefaultBinding[11].PrimaryBind = 'MouseScrollUp';
    DefaultBinding[11].SecondaryBind = 'None';
    DefaultBinding[12].Command = "GBA_Melee";
    DefaultBinding[12].PrimaryBind = 'MiddleMouseButton';
    DefaultBinding[12].SecondaryBind = 'None';
    DefaultBinding[13].Command = "GBA_GameplayObject";
    DefaultBinding[13].PrimaryBind = 'LeftAlt';
    DefaultBinding[13].SecondaryBind = 'None';
    DefaultBinding[14].Command = "GBA_Sprint";
    DefaultBinding[14].PrimaryBind = 'LeftShift';
    DefaultBinding[14].SecondaryBind = 'None';
    DefaultBinding[15].Command = "GBA_Grenade";
    DefaultBinding[15].PrimaryBind = 'G';
    DefaultBinding[15].SecondaryBind = 'None';
    DefaultBinding[16].Command = "GBA_ReloadWeapon";
    DefaultBinding[16].PrimaryBind = 'R';
    DefaultBinding[16].SecondaryBind = 'None';
    DefaultBinding[17].Command = "GBA_WeaponSwitch";
    DefaultBinding[17].PrimaryBind = 'X';
    DefaultBinding[17].SecondaryBind = 'None';
    DefaultBinding[18].Command = "GBA_PC_TEST_Torch";
    DefaultBinding[18].PrimaryBind = 'F';
    DefaultBinding[18].SecondaryBind = 'None';
    DefaultBinding[19].Command = "GBA_PC_TEST_Compass";
    DefaultBinding[19].PrimaryBind = 'C';
    DefaultBinding[19].SecondaryBind = 'None';
    DefaultBinding[20].Command = "GBA_PC_TEST_Map";
    DefaultBinding[20].PrimaryBind = 'N';
    DefaultBinding[20].SecondaryBind = 'None';
    DefaultBinding[21].Command = "GBA_PC_TEST_NotepadPrev";
    DefaultBinding[21].PrimaryBind = 'LeftBracket';
    DefaultBinding[21].SecondaryBind = 'None';
    DefaultBinding[22].Command = "GBA_PC_TEST_NotepadNext";
    DefaultBinding[22].PrimaryBind = 'RightBracket';
    DefaultBinding[22].SecondaryBind = 'None';
    DefaultBinding[23].Command = "GBA_TEST_None";
    DefaultBinding[23].PrimaryBind = 'four';
    DefaultBinding[23].SecondaryBind = 'None';
    DefaultBinding[24].Command = "GBA_TEST_Torch";
    DefaultBinding[24].PrimaryBind = 'five';
    DefaultBinding[24].SecondaryBind = 'None';
    DefaultBinding[25].Command = "GBA_TEST_Compass";
    DefaultBinding[25].PrimaryBind = 'six';
    DefaultBinding[25].SecondaryBind = 'None';
    DefaultBinding[26].Command = "GBA_TEST_Map";
    DefaultBinding[26].PrimaryBind = 'seven';
    DefaultBinding[26].SecondaryBind = 'None';
    DefaultBinding[27].Command = "GBA_Talk";
    DefaultBinding[27].PrimaryBind = 'T';
    DefaultBinding[27].SecondaryBind = 'None';
    DefaultBinding[28].Command = "GBA_TeamTalk";
    DefaultBinding[28].PrimaryBind = 'Y';
    DefaultBinding[28].SecondaryBind = 'None';
    DefaultBinding[29].Command = "GBA_Waypoint";
    DefaultBinding[29].PrimaryBind = 'V';
    DefaultBinding[29].SecondaryBind = 'None';
    DefaultBinding[30].Command = "DONT_DISPLAY";
    DefaultBinding[30].PrimaryBind = 'None';
    DefaultBinding[30].SecondaryBind = 'None';
    //return;    
}

function SetBindingsForPC(array<BindingInfo> NewBindings)
{
    local int I;
    local KeyBind NewBind;

    I = 0;
    J0x0B:

    // End:0x263 [Loop If]
    if(I < NewBindings.Length)
    {
        ClearAllBindingsForCommand(NewBindings[I].Command, true, false);
        // End:0x155
        if(NewBindings[I].PrimaryBind != 'None')
        {
            ClearAllBindingsWithName(NewBindings[I].PrimaryBind);
            NewBind.Name = NewBindings[I].PrimaryBind;
            NewBind.Command = NewBindings[I].Command;
            Bindings.AddItem(NewBind);            
        }
        // End:0x255
        if(NewBindings[I].SecondaryBind != 'None')
        {
            ClearAllBindingsWithName(NewBindings[I].SecondaryBind);
            NewBind.Name = NewBindings[I].SecondaryBind;
            NewBind.Command = NewBindings[I].Command;
            Bindings.AddItem(NewBind);            
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    SaveConfig();
    //return;    
}

function ClearAllPCBindings()
{
    local int I;

    I = Bindings.Length - 1;
    J0x17:

    // End:0xD2 [Loop If]
    if(I >= 0)
    {
        // End:0xC4
        if(!Class'AdvFrontEnd'.static.IsGamepadKey(Bindings[I].Name) && InStr(string(Bindings[I].Name), "GBA_",, true) == -1)
        {
            Bindings.Remove(I, 1);            
        }
        I--;
        // [Loop Continue]
        goto J0x17;
    }
    SaveConfig();
    //return;    
}

function ClearAllBindingsWithName(name KeyName)
{
    local int I;

    I = Bindings.Length - 1;
    J0x17:

    // End:0x7D [Loop If]
    if(I >= 0)
    {
        // End:0x6F
        if(Bindings[I].Name == KeyName)
        {
            Bindings.Remove(I, 1);            
        }
        I--;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

function ClearAllBindingsForCommand(string Command, bool bRemovePCBinds, bool bRemoveConsoleBinds)
{
    local int I;
    local bool bConsole;

    I = Bindings.Length - 1;
    J0x17:

    // End:0x104 [Loop If]
    if(I >= 0)
    {
        // End:0xF6
        if(Bindings[I].Command == Command)
        {
            bConsole = InStr(string(Bindings[I].Name), "XboxTypeS_") != -1;
            // End:0xF6
            if((bConsole && bRemoveConsoleBinds) || !bConsole && bRemovePCBinds)
            {
                Bindings.Remove(I, 1);                
            }
        }
        I--;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

defaultproperties
{
    OnReceivedNativeInputKey=InputKey
}