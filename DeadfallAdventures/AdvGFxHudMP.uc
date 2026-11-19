class AdvGFxHudMP extends AdvGFxHud
    config(UI);

var int LastHealthAmount;
var float LastEnemyHitTime;
var int LastRemainingTime;
var bool GRIRecived;

function Init(optional LocalPlayer Player)
{
    local int I, IconIndex;

    super.Init(Player);
    I = 0;
    J0x1F:

    // End:0x17A [Loop If]
    if(I < 4)
    {
        // End:0x93
        if((GRI != none) && AdvGRI(GRI) != none)
        {
            IconIndex = AdvGRI(GRI).KillStrikeIconIndexes[I];
        }
        SetKillStreakIcon(I, IconIndex + 1);
        // End:0x159
        if(((AdvPlayerControllerMP(GetPC()) != none) && AdvPlayerControllerMP(GetPC()).bAvaiblePerks.Length > I) && int(AdvPlayerControllerMP(GetPC()).bAvaiblePerks[I]) == int(1))
        {
            PlayKillStreakActiveAnim(I);            
        }
        else
        {
            PlayKillStreakInactiveAnim(I);
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    // End:0x1F4
    if(AdvPRI(GetPC().PlayerReplicationInfo) != none)
    {
        SetKillStreakKillCount(AdvPRI(GetPC().PlayerReplicationInfo).KillStrikePoints[0]);        
    }
    else
    {
        SetKillStreakKillCount(0);
    }
    //return;    
}

function bool SetKSIcons()
{
    local int I, IconIndex;

    // End:0x2B
    if((GRI == none) || AdvGRI(GRI) == none)
    {
        return false;
    }
    MultiplayerStreaksMC.SetVisible((((AdvGRI(GRI) == none) || !AdvGRI(GRI).bKillingSpree) ? false : true));
    I = 0;
    J0xA0:

    // End:0x203 [Loop If]
    if(I < 4)
    {
        // End:0x127
        if(AdvGRI(GRI).KillStrikeIcons[I] == 0)
        {
            KillStreakObjects[I].KillStreakMC.SetVisible(false);            
        }
        else
        {
            // End:0x19B
            if(AdvGRI(GRI).KillStrikeIcons[I] == 1)
            {
                KillStreakObjects[I].KillStreakMC.SetVisible(true);
            }
        }
        IconIndex = AdvGRI(GRI).KillStrikeIconIndexes[I];
        SetKillStreakIcon(I, IconIndex + 1);
        I++;
        // [Loop Continue]
        goto J0xA0;
    }
    I = 0;
    J0x20E:

    // End:0x2F1 [Loop If]
    if(I < 12)
    {
        // End:0x282
        if(AdvGRI(GRI).KillStrikeDots[I] == 0)
        {
            KillStreakCountMC[I].SetVisible(false);            
        }
        else
        {
            // End:0x2E3
            if(AdvGRI(GRI).KillStrikeDots[I] == 1)
            {
                KillStreakCountMC[I].SetVisible(true);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x20E;
    }
    return true;
    //return ReturnValue;    
}

function SetHUDElementsVisible(bool Visible)
{
    local int I, IconIndex;

    super.SetHUDElementsVisible(Visible);
    MultiplayerStreaksMC.SetVisible((((AdvGRI(GRI) == none) || !AdvGRI(GRI).bKillingSpree) ? false : Visible));
    MultiplayerStatsMC.SetVisible(Visible);
    // End:0x3B2
    if(Visible)
    {
        // End:0x1CD
        if(GetPC().WorldInfo.IsConsoleBuild(1) || AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            SetKillStreakActivationText(0, "<img src='xbox_lup_small'>");
            SetKillStreakActivationText(1, "<img src='xbox_lleft_small'>");
            SetKillStreakActivationText(2, "<img src='xbox_ldown_small'>");
            SetKillStreakActivationText(3, "<img src='xbox_lright_small'>");            
        }
        else
        {
            SetKillStreakActivationText(0, Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvPlayerInput(GetPC().PlayerInput).FindPrimaryBindingForCommand("GBA_TEST_None", true)));
            SetKillStreakActivationText(1, Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvPlayerInput(GetPC().PlayerInput).FindPrimaryBindingForCommand("GBA_TEST_Torch", true)));
            SetKillStreakActivationText(2, Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvPlayerInput(GetPC().PlayerInput).FindPrimaryBindingForCommand("GBA_TEST_Compass", true)));
            SetKillStreakActivationText(3, Class'AdvGFxUI_Menu_Options_Controls'.static.GetLocalizedTextForKeyName(AdvPlayerInput(GetPC().PlayerInput).FindPrimaryBindingForCommand("GBA_TEST_Map", true)));
        }
    }
    // End:0x637
    if((GRI != none) && AdvGRI(GRI) != none)
    {
        I = 0;
        J0x3E6:

        // End:0x549 [Loop If]
        if(I < 4)
        {
            // End:0x46D
            if(AdvGRI(GRI).KillStrikeIcons[I] == 0)
            {
                KillStreakObjects[I].KillStreakMC.SetVisible(false);                
            }
            else
            {
                // End:0x4E1
                if(AdvGRI(GRI).KillStrikeIcons[I] == 1)
                {
                    KillStreakObjects[I].KillStreakMC.SetVisible(true);
                }
            }
            IconIndex = AdvGRI(GRI).KillStrikeIconIndexes[I];
            SetKillStreakIcon(I, IconIndex + 1);
            I++;
            // [Loop Continue]
            goto J0x3E6;
        }
        I = 0;
        J0x554:

        // End:0x637 [Loop If]
        if(I < 12)
        {
            // End:0x5C8
            if(AdvGRI(GRI).KillStrikeDots[I] == 0)
            {
                KillStreakCountMC[I].SetVisible(false);                
            }
            else
            {
                // End:0x629
                if(AdvGRI(GRI).KillStrikeDots[I] == 1)
                {
                    KillStreakCountMC[I].SetVisible(true);
                }
            }
            I++;
            // [Loop Continue]
            goto J0x554;
        }
    }
    RedTeamMC.SetVisible(false);
    BlueTeamMC.SetVisible(false);
    //return;    
}

function TickHud(float DeltaTime)
{
    local AdvPlayerController PC;
    local AdvPlayerPawn UTP;
    local EvilVehicle_Base UTV;
    local UTWeaponPawn UWP;
    local EvilWeap_Base Weapon, WeaponLeft;

    PC = AdvPlayerController(GetPC());
    // End:0x2E
    if(PC == none)
    {
        return;
    }
    UTP = AdvPlayerPawn(PC.Pawn);
    // End:0x1DB
    if(EqualEqual_InterfaceInterface(EvilPlayer_interface(PC.Pawn), EvilPlayer_interface(none)))
    {
        UTV = EvilVehicle_Base(PC.Pawn);
        // End:0x182
        if(UTV == none)
        {
            UWP = UTWeaponPawn(PC.Pawn);
            // End:0x17F
            if(UWP != none)
            {
                UTV = EvilVehicle_Base(UWP.MyVehicle);
                UTP = AdvPlayerPawn(UWP.Driver);
            }            
        }
        else
        {
            UTP = AdvPlayerPawn(UTV.Driver);
        }
        // End:0x1DB
        if(UTV == none)
        {
            SetHUDElementsVisible(false);
            bVisibilityNeedsUpdate = true;
            return;
        }
    }
    // End:0x24C
    if(UTP != none)
    {
        Weapon = EvilWeap_Base(UTP.Weapon);
        WeaponLeft = EvilWeap_Base(UTP.WeaponLeft);
    }
    // End:0x37D
    if(((Weapon != none) && Weapon.LastHitEnemyTime > LastEnemyHitTime) || (WeaponLeft != none) && WeaponLeft.LastHitEnemyTime > LastEnemyHitTime)
    {
        LastEnemyHitTime = ((((Weapon != none) && WeaponLeft != none) && WeaponLeft.LastHitEnemyTime > Weapon.LastHitEnemyTime) ? WeaponLeft.LastHitEnemyTime : Weapon.LastHitEnemyTime);
        ShowEnemyHitIndicator();
    }
    // End:0x573
    if(GRI != none)
    {
        // End:0x53F
        if(((GRI.TimeLimit != 0) && LastRemainingTime != GRI.RemainingTime) || (GRI.TimeLimit == 0) && LastRemainingTime != GRI.ElapsedTime)
        {
            LastRemainingTime = ((GRI.TimeLimit != 0) ? GRI.RemainingTime : GRI.ElapsedTime);
            TimeLeftTF.SetText(Class'AdvGFxUI_Scoreboard'.static.FormatTime(((GRI.TimeLimit != 0) ? GRI.RemainingTime : GRI.ElapsedTime)));
        }
        VotingComponent.SetGRI(AdvGRI(GRI));        
    }
    else
    {
        TimeLeftTF.SetText("");
    }
    super.TickHud(DeltaTime);
    // End:0x5DE
    if((GRIRecived == false) && GRI != none)
    {
        GRIRecived = SetKSIcons();
    }
    //return;    
}

function PlayShowHideWeaponStatsAnimation(bool bShow)
{
    WeaponStatsMC.GotoAndStop("visible");
    //return;    
}

defaultproperties
{
    LastHealthAmount=-1
    LastEnemyHitTime=-1000.0000000
    LastRemainingTime=-1000
}