class LCDUIInterface extends Actor
    notplaceable;

enum SoftButtonID
{
    SB,                             // 0
    SB_1,                           // 1
    SB_2,                           // 2
    SB_3,                           // 3
    SB_MAX                          // 4
};

var class<LCDInterface> LCD;
var PandoraPlayerController PlayerController;
var PandoraGRI GRI;
var int CurrentPageIndex;
var float VScroll;
var float ScrollSpeed;
var string FontName;
var int GlyphWidth;
var int GlyphHeight;

function Initialize(PandoraPlayerController PPC)
{
    PlayerController = PPC;
    GRI = PandoraGRI(PPC.WorldInfo.GRI);
    LCD.static.LCDFlushResources();
    LCD.static.AddOnSoftKeyPressedDelegate(SoftKeyPressed);
    //return;    
}

function SoftKeyPressed(int Id)
{
    // End:0x52
    if(PlayerController != none)
    {
        // End:0x52
        if((int(PlayerController.WorldInfo.NetMode) != int(NM_Standalone)) && Id != 2)
        {
            CurrentPageIndex = Id;
            UpdateLCDInformation();
        }
    }
    //return;    
}

function UpdateLCDInformation()
{
    local int LogoRes;

    // End:0x106
    if(PlayerController.InShellLevel() || PlayerController.IsLobbySceneActive())
    {
        // End:0x6D
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            // End:0x6D
            if(IsTimerActive('CycleTimer'))
            {
                ClearTimer('CycleTimer');
            }
        }
        LogoRes = LCD.static.LoadLCDResource("LOGO_splash.lcd");
        LCD.static.LCDClear();
        LCD.static.LCDForceForeground();
        LCD.static.Blt(LogoRes, 0, 0);
        LCD.static.LCDUpdate();
        LCD.static.LCDFlushResources();        
    }
    else
    {
        // End:0x148
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            // End:0x148
            if(!IsTimerActive('CycleTimer'))
            {
                SetTimer(5.0000000, true, 'CycleTimer');
            }
        }
        switch(CurrentPageIndex)
        {
            // End:0x161
            case 0:
                UpdateWeaponInformation();
                // End:0x199
                break;
            // End:0x172
            case 1:
                UpdatePersonalStats();
                // End:0x199
                break;
            // End:0x184
            case 2:
                UpdatePage2();
                // End:0x199
                break;
            // End:0x196
            case 3:
                UpdateScoreBoard();
                // End:0x199
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    //return;    
}

function UpdateWeaponInformation()
{
    local SPWeapon PlayerWeapon;
    local int FontId, FontRes, GrenadeType;

    // End:0x299
    if((PlayerController != none) && PlayerController.Pawn != none)
    {
        PlayerWeapon = SPWeapon(PlayerController.Pawn.Weapon);
        // End:0x299
        if(PlayerWeapon != none)
        {
            FontRes = LCD.static.LoadLCDResource(FontName);
            FontId = LCD.static.RegisterFont(FontRes, GlyphWidth, GlyphHeight);
            LCD.static.LCDClear();
            LCD.static.LCDForceForeground();
            // End:0x12F
            if(PlayerWeapon.WeapID != 'DummyWeapon')
            {
                LCD.static.RenderText(FontId, 0, 0, Caps(Localize("Weapons", string(PlayerWeapon.default.WeapID), "PandoraGame")));                
            }
            else
            {
                LCD.static.RenderText(FontId, 0, 0, Caps(Localize("OptionsGrabKey", "None", "PandoraGame")));
            }
            LCD.static.RenderText(FontId, 0, 15, (string(PlayerWeapon.ammoInMagazine) $ " / ") $ string(PlayerWeapon.AmmoCount));
            GrenadeType = int(SPInventoryManager(PlayerController.Pawn.InvManager).curGrenadeType);
            LCD.static.RenderText(FontId, 0, 30, ((Localize("Weapons", "Grenade", "PandoraGame")) $ ": ") $ string(SPInventoryManager(PlayerController.Pawn.InvManager).GetGrenadeAmmo(GrenadeType)));
            LCD.static.LCDUpdate();
            LCD.static.LCDFlushResources();
        }
    }
    //return;    
}

function UpdatePersonalStats()
{
    local int FontId, FontRes, Kills, Deaths, Points, monsterMachineLevelPoints,
	    fillLevel;

    local SPPointEventMachineBonusPersistent theMachineBonus;
    local SPPlayerReplicationInfo PRI;

    FontRes = LCD.static.LoadLCDResource(FontName);
    FontId = LCD.static.RegisterFont(FontRes, GlyphWidth, GlyphHeight);
    // End:0x43C
    if(PlayerController != none)
    {
        PRI = SPPlayerReplicationInfo(PlayerController.PlayerReplicationInfo);
        LCD.static.LCDClear();
        LCD.static.LCDForceForeground();
        // End:0xAA
        if(GRI == none)
        {
            monsterMachineLevelPoints = 0;            
        }
        else
        {
            theMachineBonus = GRI.GetPointEventMachineBonus();
            fillLevel = theMachineBonus.GetLevelForFillPercent(int(GRI.GetMonsterMachineValue(PRI.Team.TeamIndex)));
            monsterMachineLevelPoints = theMachineBonus.GetPointsForLevel(fillLevel);
        }
        Kills = (((PRI.KillPlayerNormalNum + PRI.KillPlayerInterruptNum) + PRI.KillPlayerDefensiveNum) + PRI.KillAlphaWWNum) + PRI.KillWeakWWNum;
        Deaths = int(PRI.Deaths);
        Points = int(((((((((float(PRI.KillPlayerNormalNum) * Class'SPPointEventKillPlayerNormal'.static.GetPoints()) + (float(PRI.KillPlayerInterruptNum) * Class'SPPointEventKillPlayerInterrupt'.static.GetPoints())) + (float(PRI.KillPlayerDefensiveNum) * Class'SPPointEventKillPlayerDefensive'.static.GetPoints())) + (float(PRI.KillAlphaWWNum) * Class'SPPointEventKillAlphaWW'.static.GetPoints())) + (float(PRI.KillWeakWWNum) * Class'SPPointEventKillWeakWW'.static.GetPoints())) + (float(PRI.AnimusBanked) * Class'SPPointEventAnimusBanked'.static.GetPoints())) + (float(PRI.AnimusCollectedPlayerNum) * Class'SPPointEventAnimusCollectedPlayer'.static.GetPoints())) + (float(PRI.AnimusCollectedWWNum) * Class'SPPointEventAnimusCollectedWW'.static.GetPoints())) + float(monsterMachineLevelPoints));
        LCD.static.RenderText(FontId, 0, 0, ((Localize("UIScene_Scoreboard", "TotalKills", "PandoraGame")) $ ": ") $ string(Kills));
        LCD.static.RenderText(FontId, 0, 15, ((Localize("UIScene_Scoreboard", "Deaths", "PandoraGame")) $ ": ") $ string(Deaths));
        LCD.static.RenderText(FontId, 0, 30, ((Localize("PanLeaderboard_Settings", "Score", "PandoraGame")) $ ": ") $ string(Points));
        LCD.static.LCDUpdate();
        LCD.static.LCDFlushResources();
    }
    //return;    
}

function CycleTimer()
{
    CurrentPageIndex++;
    // End:0x1A
    if(CurrentPageIndex == 2)
    {
        CurrentPageIndex++;
    }
    // End:0x2D
    if(CurrentPageIndex > 3)
    {
        CurrentPageIndex = 0;
    }
    //return;    
}

function DelayTimer()
{
    VScroll = 0.0000000;
    //return;    
}

function Tick(float DeltaTime)
{
    // End:0xE1
    if(GRI != none)
    {
        // End:0xD7
        if((int(GRI.WorldInfo.NetMode) != int(NM_Standalone)) && int(GRI.GameStatus) != int(1))
        {
            UpdateLCDInformation();
            // End:0xD4
            if(CurrentPageIndex == 3)
            {
                VScroll += (DeltaTime * ScrollSpeed);
                // End:0xD4
                if(VScroll > float(((GetPlayerCount()) * 15) - 43))
                {
                    VScroll = float(((GetPlayerCount()) * 15) - 43);
                    // End:0xD4
                    if(!IsTimerActive('DelayTimer'))
                    {
                        SetTimer(2.0000000, false, 'DelayTimer');
                    }
                }
            }            
        }
        else
        {
            UpdateLCDInformation();
        }
    }
    //return;    
}

function int GetPlayerCount()
{
    local int PlayerCount, I;

    I = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(I < GRI.PRIArray.Length)
    {
        // End:0x4D
        if(!GRI.PRIArray[I].bBot)
        {
            PlayerCount++;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return PlayerCount;
    //return ReturnValue;    
}

function UpdateScoreBoard()
{
    local int FontId, FontRes, I;

    FontRes = LCD.static.LoadLCDResource(FontName);
    FontId = LCD.static.RegisterFont(FontRes, GlyphWidth, GlyphHeight);
    // End:0x156
    if(GRI != none)
    {
        LCD.static.LCDClear();
        LCD.static.LCDForceForeground();
        LCD.static.SetFontScale(10, 13);
        I = 0;
        J0x9A:

        // End:0x12E [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x124
            if(!GRI.PRIArray[I].bBot)
            {
                LCD.static.RenderText(FontId, 0, (I * 15) - int(VScroll), GRI.PRIArray[I].PlayerName);
            }
            I++;
            // [Loop Continue]
            goto J0x9A;
        }
        LCD.static.LCDUpdate();
        LCD.static.LCDFlushResources();
    }
    //return;    
}

function UpdatePage2()
{
    //return;    
}

simulated function Destroyed()
{
    LCD.static.AddOnSoftKeyPressedDelegate(None);
    super.Destroyed();
    //return;    
}
