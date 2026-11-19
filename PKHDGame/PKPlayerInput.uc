class PKPlayerInput extends EvilPlayerInput within PKPlayerController
    transient
    config(Input)
    hidecategories(Object,UIRoot);

const MAX_BINDINGS = 42;

function HandleButtonInput_A(bool bPressed, optional bool bDblClickMove)
{
    // End:0xBB
    if(bPressed && !EvilPawn(Outer.Pawn).bIsJumping)
    {
        // End:0xAE
        if(Outer.bCinematicMode)
        {            
            Outer.ConsoleCommand("CANCELMATINEE");
            return;
        }
        Jump();        
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
            Outer.ClientUseGoldenCards();
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
    // End:0x31
    if(bPressed)
    {
        Outer.QuickCustom1Fire(true);        
    }
    else
    {
        Outer.QuickCustom1Fire(false);
    }
    //return;    
}

function HandleButtonInput_B(bool bPressed, optional bool bDblClickMove)
{
    // End:0x31
    if(bPressed)
    {
        Outer.QuickCustom2Fire(true);        
    }
    else
    {
        Outer.QuickCustom2Fire(false);
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
        Outer.PauseGame();
    }
    //return;    
}

function HandleButtonInput_Back(bool bPressed, optional bool bDblClickMove)
{
    // End:0xC6
    if(bPressed)
    {
        // End:0x6B
        if(Outer.bCinematicMode)
        {            
            Outer.ConsoleCommand("CANCELMATINEE");            
        }
        else
        {
            // End:0xC3
            if(Outer.PKHudWrapper != none)
            {
                Outer.PKHudWrapper.ShowInGameStatsScreen();
            }
        }        
    }
    else
    {
        // End:0x144
        if(!Outer.bCinematicMode && Outer.PKHudWrapper != none)
        {
            Outer.PKHudWrapper.HideInGameStatsScreen();
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
        Outer.StopAltFire();
    }
    //return;    
}

function HandleButtonInput_LeftBumper(bool bPressed, optional bool bDblClickMove)
{
    // End:0x30
    if(bPressed)
    {
        Outer.PrevWeapon();        
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
        Outer.NextWeapon();        
    }
    //return;    
}

function HandleButtonInput_DPad(EvilTypes.EGameButtons Button, bool bPressed, optional bool bDblClickMove)
{
    // End:0x197
    if(bPressed)
    {
        switch(Button)
        {
            // End:0x7D
            case 10:
                EvilInventoryManager(Outer.Pawn.InvManager).SwitchWeapon(1);
                // End:0x194
                break;
            // End:0xD9
            case 11:
                EvilInventoryManager(Outer.Pawn.InvManager).SwitchWeapon(2);
                // End:0x194
                break;
            // End:0x135
            case 13:
                EvilInventoryManager(Outer.Pawn.InvManager).SwitchWeapon(3);
                // End:0x194
                break;
            // End:0x191
            case 12:
                EvilInventoryManager(Outer.Pawn.InvManager).SwitchWeapon(4);
                // End:0x194
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
            // End:0x1B2
            case 10:
                // End:0x1CD
                break;
            // End:0x1BA
            case 11:
                // End:0x1CD
                break;
            // End:0x1C2
            case 13:
                // End:0x1CD
                break;
            // End:0x1CA
            case 12:
                // End:0x1CD
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    //return;    
}

function HandleButtonInput_LeftStickButton(bool bPressed, optional bool bDblClickMove)
{
    // End:0x50
    if(bPressed)
    {
        // End:0x4D
        if(IsButtonActive(15))
        {            
            Outer.ConsoleCommand("shot");
        }        
    }
    //return;    
}

function HandleButtonInput_RightStickButton(bool bPressed, optional bool bDblClickMove)
{
    // End:0x71
    if(bPressed)
    {
        Outer.StartFire(3);
        // End:0x6E
        if(IsButtonActive(14))
        {            
            Outer.ConsoleCommand("shot");
        }        
    }
    else
    {
        // End:0x177
        if(((EvilWeap_Base(Outer.Pawn.Weapon) == none) || int(EvilWeap_Base(Outer.Pawn.Weapon).GetZoomedState()) == int(0)) || EvilWeap_Base(Outer.Pawn.WeaponLeft) != none)
        {
            Outer.StopFire(3);
        }
    }
    //return;    
}

function HandleButtonInput_LeftStickUp(bool bPressed, optional bool bDblClickMove)
{
    local EvilWeap_Base Weap;

    // End:0x27
    if(Outer.Pawn == none)
    {
        return;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0xD2
    if(bPressed)
    {
        // End:0xCF
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        // End:0x127
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

    // End:0x27
    if(Outer.Pawn == none)
    {
        return;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0xD2
    if(bPressed)
    {
        // End:0xCF
        if((Weap != none) && !IsButtonActive(18) || IsButtonActive(19))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        // End:0x127
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

    // End:0x27
    if(Outer.Pawn == none)
    {
        return;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0xD2
    if(bPressed)
    {
        // End:0xCF
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        // End:0x127
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

    // End:0x27
    if(Outer.Pawn == none)
    {
        return;
    }
    Weap = EvilWeap_Base(Outer.Pawn.Weapon);
    // End:0xD2
    if(bPressed)
    {
        // End:0xCF
        if((Weap != none) && !IsButtonActive(16) || IsButtonActive(17))
        {
            Weap.SetSpreadMoving(true);
        }        
    }
    else
    {
        // End:0x127
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

exec function Jump()
{
    // End:0x7A
    if(Outer.WorldInfo.Pauser == Outer.PlayerReplicationInfo)
    {
        Outer.SetPause(false);        
    }
    else
    {
        Outer.bPressedJump = true;
    }
    //return;    
}

function GetDefaultCustom1Weapons(out array<byte> DefaultCustom1)
{
    DefaultCustom1.Remove(0, DefaultCustom1.Length);
    DefaultCustom1.Length = 36;
    DefaultCustom1[0] = 1;
    DefaultCustom1[1] = 8;
    DefaultCustom1[2] = 14;
    DefaultCustom1[3] = 12;
    DefaultCustom1[4] = 4;
    DefaultCustom1[5] = 2;
    DefaultCustom1[6] = 6;
    DefaultCustom1[7] = 10;
    DefaultCustom1[8] = 5;
    DefaultCustom1[9] = 7;
    DefaultCustom1[10] = 13;
    DefaultCustom1[11] = 11;
    DefaultCustom1[12] = 15;
    DefaultCustom1[13] = 9;
    DefaultCustom1[14] = 3;
    DefaultCustom1[15] = 0;
    DefaultCustom1[16] = 16;
    DefaultCustom1[17] = 18;
    DefaultCustom1[18] = 20;
    DefaultCustom1[19] = 22;
    DefaultCustom1[20] = 24;
    DefaultCustom1[21] = 26;
    DefaultCustom1[22] = 28;
    DefaultCustom1[23] = 30;
    DefaultCustom1[24] = 32;
    DefaultCustom1[25] = 34;
    DefaultCustom1[26] = 17;
    DefaultCustom1[27] = 19;
    DefaultCustom1[28] = 21;
    DefaultCustom1[29] = 23;
    DefaultCustom1[30] = 25;
    DefaultCustom1[31] = 27;
    DefaultCustom1[32] = 29;
    DefaultCustom1[33] = 31;
    DefaultCustom1[34] = 33;
    DefaultCustom1[35] = 35;
    //return;    
}

function GetDefaultCustom2Weapons(out array<byte> DefaultCustom2)
{
    DefaultCustom2.Remove(0, DefaultCustom2.Length);
    DefaultCustom2.Length = 36;
    DefaultCustom2[0] = 5;
    DefaultCustom2[1] = 7;
    DefaultCustom2[2] = 13;
    DefaultCustom2[3] = 11;
    DefaultCustom2[4] = 15;
    DefaultCustom2[5] = 9;
    DefaultCustom2[6] = 3;
    DefaultCustom2[7] = 0;
    DefaultCustom2[8] = 1;
    DefaultCustom2[9] = 8;
    DefaultCustom2[10] = 14;
    DefaultCustom2[11] = 12;
    DefaultCustom2[12] = 4;
    DefaultCustom2[13] = 2;
    DefaultCustom2[14] = 6;
    DefaultCustom2[15] = 10;
    DefaultCustom2[16] = 17;
    DefaultCustom2[17] = 19;
    DefaultCustom2[18] = 21;
    DefaultCustom2[19] = 23;
    DefaultCustom2[20] = 25;
    DefaultCustom2[21] = 27;
    DefaultCustom2[22] = 29;
    DefaultCustom2[23] = 31;
    DefaultCustom2[24] = 33;
    DefaultCustom2[25] = 35;
    DefaultCustom2[26] = 16;
    DefaultCustom2[27] = 18;
    DefaultCustom2[28] = 20;
    DefaultCustom2[29] = 22;
    DefaultCustom2[30] = 24;
    DefaultCustom2[31] = 26;
    DefaultCustom2[32] = 28;
    DefaultCustom2[33] = 30;
    DefaultCustom2[34] = 32;
    DefaultCustom2[35] = 34;
    //return;    
}

function GetDefaultBindingsForPC(out array<BindingInfo> DefaultBinding)
{
    DefaultBinding.Remove(0, DefaultBinding.Length);
    DefaultBinding.Length = 42;
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
    DefaultBinding[6].Command = "GBA_Zoom";
    DefaultBinding[6].PrimaryBind = 'MiddleMouseButton';
    DefaultBinding[6].SecondaryBind = 'None';
    DefaultBinding[7].Command = "GBA_AltFire";
    DefaultBinding[7].PrimaryBind = 'RightMouseButton';
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
    DefaultBinding[12].Command = "GBA_SwitchWeapon1";
    DefaultBinding[12].PrimaryBind = 'one';
    DefaultBinding[12].SecondaryBind = 'None';
    DefaultBinding[13].Command = "GBA_SwitchWeapon2";
    DefaultBinding[13].PrimaryBind = 'two';
    DefaultBinding[13].SecondaryBind = 'None';
    DefaultBinding[14].Command = "GBA_SwitchWeapon3";
    DefaultBinding[14].PrimaryBind = 'three';
    DefaultBinding[14].SecondaryBind = 'None';
    DefaultBinding[15].Command = "GBA_SwitchWeapon4";
    DefaultBinding[15].PrimaryBind = 'four';
    DefaultBinding[15].SecondaryBind = 'None';
    DefaultBinding[16].Command = "GBA_SwitchWeapon5";
    DefaultBinding[16].PrimaryBind = 'five';
    DefaultBinding[16].SecondaryBind = 'None';
    DefaultBinding[17].Command = "GBA_SwitchWeapon6";
    DefaultBinding[17].PrimaryBind = 'six';
    DefaultBinding[17].SecondaryBind = 'None';
    DefaultBinding[18].Command = "GBA_SwitchWeapon7";
    DefaultBinding[18].PrimaryBind = 'seven';
    DefaultBinding[18].SecondaryBind = 'None';
    DefaultBinding[19].Command = "GBA_SwitchWeapon8";
    DefaultBinding[19].PrimaryBind = 'eight';
    DefaultBinding[19].SecondaryBind = 'None';
    DefaultBinding[20].Command = "GBA_Flashlight";
    DefaultBinding[20].PrimaryBind = 'L';
    DefaultBinding[20].SecondaryBind = 'None';
    DefaultBinding[21].Command = "GBA_Screenshot";
    DefaultBinding[21].PrimaryBind = 'None';
    DefaultBinding[21].SecondaryBind = 'None';
    DefaultBinding[22].Command = "GBA_Talk";
    DefaultBinding[22].PrimaryBind = 'Y';
    DefaultBinding[22].SecondaryBind = 'None';
    DefaultBinding[23].Command = "GBA_TeamTalk";
    DefaultBinding[23].PrimaryBind = 'U';
    DefaultBinding[23].SecondaryBind = 'None';
    DefaultBinding[24].Command = "GBA_RocketJump";
    DefaultBinding[24].PrimaryBind = 'R';
    DefaultBinding[24].SecondaryBind = 'None';
    DefaultBinding[25].Command = "GBA_ForwardRocket";
    DefaultBinding[25].PrimaryBind = 'None';
    DefaultBinding[25].SecondaryBind = 'None';
    DefaultBinding[26].Command = "GBA_Fireswitch";
    DefaultBinding[26].PrimaryBind = 'None';
    DefaultBinding[26].SecondaryBind = 'None';
    DefaultBinding[27].Command = "GBA_FireswitchToggle";
    DefaultBinding[27].PrimaryBind = 'T';
    DefaultBinding[27].SecondaryBind = 'None';
    DefaultBinding[28].Command = "GBA_SelectCustom1";
    DefaultBinding[28].PrimaryBind = 'None';
    DefaultBinding[28].SecondaryBind = 'None';
    DefaultBinding[29].Command = "GBA_SelectCustom2";
    DefaultBinding[29].PrimaryBind = 'None';
    DefaultBinding[29].SecondaryBind = 'None';
    DefaultBinding[30].Command = "GBA_FireCustom1";
    DefaultBinding[30].PrimaryBind = 'LeftControl';
    DefaultBinding[30].SecondaryBind = 'None';
    DefaultBinding[31].Command = "GBA_FireCustom2";
    DefaultBinding[31].PrimaryBind = 'LeftShift';
    DefaultBinding[31].SecondaryBind = 'None';
    DefaultBinding[32].Command = "GBA_Message1";
    DefaultBinding[32].PrimaryBind = 'None';
    DefaultBinding[32].SecondaryBind = 'None';
    DefaultBinding[33].Command = "GBA_Message2";
    DefaultBinding[33].PrimaryBind = 'None';
    DefaultBinding[33].SecondaryBind = 'None';
    DefaultBinding[34].Command = "GBA_Message3";
    DefaultBinding[34].PrimaryBind = 'None';
    DefaultBinding[34].SecondaryBind = 'None';
    DefaultBinding[35].Command = "GBA_Message4";
    DefaultBinding[35].PrimaryBind = 'None';
    DefaultBinding[35].SecondaryBind = 'None';
    DefaultBinding[36].Command = "GBA_Message5";
    DefaultBinding[36].PrimaryBind = 'None';
    DefaultBinding[36].SecondaryBind = 'None';
    DefaultBinding[37].Command = "GBA_Message6";
    DefaultBinding[37].PrimaryBind = 'None';
    DefaultBinding[37].SecondaryBind = 'None';
    DefaultBinding[38].Command = "GBA_Message7";
    DefaultBinding[38].PrimaryBind = 'None';
    DefaultBinding[38].SecondaryBind = 'None';
    DefaultBinding[39].Command = "GBA_Message8";
    DefaultBinding[39].PrimaryBind = 'None';
    DefaultBinding[39].SecondaryBind = 'None';
    DefaultBinding[40].Command = "GBA_Message9";
    DefaultBinding[40].PrimaryBind = 'None';
    DefaultBinding[40].SecondaryBind = 'None';
    DefaultBinding[41].Command = "GBA_Message10";
    DefaultBinding[41].PrimaryBind = 'None';
    DefaultBinding[41].SecondaryBind = 'None';
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
    Bindings=/* Array type was not detected. */
}