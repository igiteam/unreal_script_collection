class PKCheatManager extends EvilCheatManager within PKPlayerController
    config(Game);

var private PKEngine.EPKInputBlockType PendingIBT;
var private int PendingControllerReconnects;

exec function AllWeapons()
{
    // End:0x66
    if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
    {
        return;
    }
    GiveWeapon("PKHDGameContent.PKWeap_Shotgun");
    GiveWeapon("PKHDGameContent.PKWeap_Chaingun");
    GiveWeapon("PKHDGameContent.PKWeap_SMG");
    GiveWeapon("PKHDGameContent.PKWeap_Stakegun");
    GiveWeapon("PKHDGameContent.PKWeap_Electrodriver");
    GiveWeapon("PKHDGameContent.PKWeap_Painkiller");
    GiveWeapon("PKHDGameContent.PKWeap_Boltgun");
    GiveWeapon("PKHDGameContent.PKWeap_SoulReaper");
    //return;    
}

exec function AllWeaponsDLC5()
{
    // End:0x66
    if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
    {
        return;
    }
    GiveWeapon("PKHDGameDLC5.PKWeap_ChaingunDLC5");
    GiveWeapon("PKHDGameDLC5.PKWeap_BoltGunDLC5");
    GiveWeapon("PKHDGameDLC5.PKWeap_ShotgunDLC5");
    GiveWeapon("PKHDGameDLC5.PKWeap_SMGDLC5");
    GiveWeapon("PKHDGameDLC5.PKWeap_StakeGunDLC5");
    //return;    
}

exec function PKWeapons()
{
    AllWeapons();
    //return;    
}

exec function PKGod()
{
    God();
    //return;    
}

exec function PKAlienwareStart()
{
    local EvilEngine Engine;
    local Color LightColor;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    LightColor.R = 0;
    LightColor.G = 255;
    LightColor.B = 0;
    LightColor.A = 255;
    Engine.AlienwareSetLights(LightColor);
    //return;    
}

exec function PKAlienwareStop()
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.AlienwareTurnOffLights();
    //return;    
}

exec function PKPower()
{
    AllAmmo();
    PKPawn(Outer.Pawn).InitDefaultHealth();
    //return;    
}

exec function PKHaste()
{
    //return;    
}

exec function PKWeakEnemies()
{
    //return;    
}

exec function PKAlwaysGib()
{
    //return;    
}

exec function PKKeepBodies()
{
    //return;    
}

exec function PKKeepDecals()
{
    //return;    
}

exec function Evilution()
{
    // End:0xBC
    if(Outer.bGodMode)
    {
        God();
        EvilInventoryManager(Outer.Pawn.InvManager).bInfiniteAmmo = false;
        Outer.ClientMessage("Infinite ammunition off");
        return;
    }
    AllWeapons();
    God();
    AllAmmo();
    Outer.ClientMessage("All Weapons & Infinite Ammunition");
    //return;    
}

exec function PKWeapMod(optional float Duration = 0.0000000)
{
    // End:0xAF
    if(PainPRI(Outer.PlayerReplicationInfo).bHasWeaponModifier)
    {
        Outer.DisableWeaponModifier();
        Outer.ClientMessage("Weapon Modifier cheat deactivated");        
    }
    else
    {
        Outer.EnableWeaponModifier(Duration);
        Outer.ClientMessage("Weapon Modifier cheat activated");
    }
    //return;    
}

exec function PKSoulReaperCombo()
{
    local PKWeap_SoulReaper_Base SoulReaper;

    // End:0xAC
    if(PKPlayerPawn(Outer.Pawn) != none)
    {
        SoulReaper = PKWeap_SoulReaper_Base(PKPlayerPawn(Outer.Pawn).Weapon);
        // End:0xAC
        if(SoulReaper != none)
        {
            SoulReaper.SoulComboMeter = 7;
        }
    }
    //return;    
}

exec function PKToggleSpawnSkeletons()
{
    local PKGame Game;

    Game = PKGame(Outer.WorldInfo.Game);
    // End:0x96
    if(Game != none)
    {
        Game.bSpawnSkeletons = !Game.bSpawnSkeletons;
    }
    //return;    
}

exec function PKDemon(optional float DemonTime)
{
    // End:0xAB
    if(PKGame(Outer.WorldInfo.Game).IsDeamonMode())
    {
        PKGame(Outer.WorldInfo.Game).StopDaemonMode();        
    }
    else
    {
        PKGame(Outer.WorldInfo.Game).StartDaemonMode(DemonTime);
    }
    //return;    
}

exec function PKQuad()
{
    // End:0x40
    if(PKPlayerController_MP(Outer) != none)
    {
        PKPlayerController_MP(Outer).EnableQuadDamage();
    }
    //return;    
}

exec function AddSouls(optional int Amount = 33)
{
    local int I;

    // End:0xDD
    if((Outer.Pawn != none) && PainPRI(Outer.Pawn.PlayerReplicationInfo) != none)
    {
        I = 0;
        J0x79:

        // End:0xDD [Loop If]
        if(I < Amount)
        {
            PainPRI(Outer.PlayerReplicationInfo).ScoreSoulTaken();
            ++I;
            // [Loop Continue]
            goto J0x79;
        }
    }
    //return;    
}

exec function PKGold(optional int Amount = 9999)
{
    Outer.SetGold(Amount);
    //return;    
}

exec function PKEndOfLevel()
{
    local PainGRI_SP GRI;
    local PKPawn MyPKPawn;

    // End:0x6C
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllPawns(Class'PKPawn', MyPKPawn)
    {
        MyPKPawn.CapturedSuicide();        
    }    
    GRI = PainGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    GRI.ShowAndWriteLevelStatistics();
    //return;    
}

exec function PKEndOfGame()
{
    local PainGRI_SP GRI;

    GRI = PainGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    GRI.ShowAndWriteLevelStatistics();
    GRI.EndOfGame();
    //return;    
}

exec function PKKillBoss()
{
    local PKPawn P;

    // End:0x10B
    foreach Outer.DynamicActors(Class'PKPawn', P)
    {
        // End:0x10A
        if(P.bIsBoss)
        {
            P.Died(Outer.Pawn.Controller, Outer.Pawn.Weapon.InstantHitDamageTypes[0], P.Location);
        }        
    }    
    //return;    
}

exec function PKUnlockLevel(int Id)
{
    Outer.PersistentData.MarkLevelAsCompleted(byte(Id));
    //return;    
}

exec function PKUnlockAllLevels()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x68 [Loop If]
    if(I < 41)
    {
        Outer.PersistentData.MarkLevelAsCompleted(byte(I));
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    Outer.ClientSaveAllPlayerData();
    // End:0x1BB
    if(((PainGFxMenuHudWrapper(Outer.myHUD) != none) && PainGFxMenuHudWrapper(Outer.myHUD).FrontEnd != none) && PainGFxMenuHudWrapper(Outer.myHUD).FrontEnd.MapSelectMenu != none)
    {
        PainGFxMenuHudWrapper(Outer.myHUD).FrontEnd.MapSelectMenu.UpdateMapList(true);
    }
    //return;    
}

exec function PKUnlockTraumaDifficulty()
{
    Outer.UnlockTrauma();
    //return;    
}

exec function DebugSaveProfile()
{
    Outer.ClientSaveAllPlayerData();
    //return;    
}

exec function DebugDetachZombieSoldiersHeads()
{
    local PKPawn_ZombieSoldier_Base zombs;

    // End:0x4E
    foreach Outer.AllActors(Class'PKPawn_ZombieSoldier_Base', zombs)
    {
        zombs.DetachHead();        
    }    
    //return;    
}

exec function OpenBetaWWW()
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).OpenPainkillerBetaWWW();
    //return;    
}

exec function ChangeCharacter(int NewIndex)
{
    PainPRI(Outer.PlayerReplicationInfo).SetupPlayerCharacter(NewIndex);
    PKPawn(Outer.Pawn).SetCharacterClassFromInfo(PainPRI(Outer.PlayerReplicationInfo).CharClassInfo);
    //return;    
}

exec function DebugFakeFailedNetworkMatchTransition()
{
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.DisplayErrorMessage("NeedGoldTier_Message", "NeedGoldTier_Title", "GenericContinue", LocalPlayer(Outer.Player));
    PainGFxMenuHudWrapper(Outer.myHUD).FrontEnd.bDeferredFrontendRestart = true;
    //return;    
}

exec function DebugGetMultiGameMode()
{
    local PKTypes.EMultiGameMode MGM;

    MGM = PainGRI(Outer.WorldInfo.GRI).GetMultiGameMode();
    //return;    
}

exec function DebugInputBlocking(PKEngine.EPKInputBlockType IBT, optional float TimeOut = 5.0000000)
{
    PendingIBT = IBT;
    Class'PKEngine'.static.OpenInputBlockingScene(IBT);
    Outer.SetTimer(TimeOut, false, 'ReleaseInputBlock', self);
    //return;    
}

private final function ReleaseInputBlock()
{
    Class'PKEngine'.static.CloseInputBlockingScene(PendingIBT);
    //return;    
}

exec function DebugFakeFastPadReconnect(optional int Count = 10, optional float Period = 0.3000000)
{
    PendingControllerReconnects = Count * 2;
    Outer.SetTimer(Period, true, 'ReconnectPad', self);
    ReconnectPad();
    //return;    
}

private final function ReconnectPad()
{
    local bool bNewConnected;

    bNewConnected = (PendingControllerReconnects-- % 2) == 1;
    Outer.OnControllerChanged(LocalPlayer(Outer.Player).ControllerId, bNewConnected);
    // End:0xBA
    if(PendingControllerReconnects <= 0)
    {
        Outer.ClearTimer('ReconnectPad', self);
    }
    //return;    
}

exec function DebugSteamStore(int AppID, optional int Flags = 0)
{
    local PKEngine Engine;

    Engine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SteamActivateGameOverlayToStore(AppID, Flags);
    //return;    
}

exec function ToggleHUDForPlayer(int Index)
{
    local Engine Engine;
    local EvilGFxHudWrapper HUD;

    Engine = Class'Engine.Engine'.static.GetEngine();
    // End:0x58
    if(Index >= Engine.GamePlayers.Length)
    {
        return;
    }
    // End:0x9D
    if(Engine.GamePlayers[Index].Actor == none)
    {
        return;
    }
    // End:0xF7
    if(Engine.GamePlayers[Index].Actor.myHUD == none)
    {
        return;
    }
    HUD = EvilGFxHudWrapper(Engine.GamePlayers[Index].Actor.myHUD);
    HUD.SetVisible(!HUD.bShowHUD);
    //return;    
}

exec function DebugFakeSplitScreenJoin()
{
    local PKFrontEnd FrontEnd;
    local PKUIManager UIManager;
    local Engine Engine;
    local UIScene_MessageBox MsgBox;
    local LocalPlayer LP;

    FrontEnd = Class'PKFrontEnd'.static.GetFrontEnd();
    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    Engine = Class'Engine.Engine'.static.GetEngine();
    // End:0xA6
    if((FrontEnd == none) || UIManager == none)
    {
        return;
    }
    // End:0xCA
    if(FrontEnd.bOnTitleScreen)
    {
        return;
    }
    // End:0xF2
    if(Engine.GamePlayers.Length > 2)
    {
        return;
    }
    // End:0x14E
    foreach UIManager.OpenMessageBoxes(MsgBox)
    {
        // End:0x14D
        if(MsgBox.MessageName == 'SplitScreen')
        {            
        }
        else
        {            
        }
    }    
    // End:0x23B
    if(MsgBox != none)
    {
        FrontEnd.bHasInactiveControllers = true;
        FrontEnd.UnregisteredInput(Engine.GamePlayers.Length);
        MsgBox.OnOptionSelected(MsgBox, 'GenericAccept', Engine.GamePlayers.Length - 1);
        MsgBox.StartExit();        
    }
    else
    {
        // End:0x34C
        if(((FrontEnd.CurrentScene == FrontEnd.DifficultyMenu) && FrontEnd.DifficultyMenu != none) && Engine.GamePlayers.Length > 1)
        {
            // End:0x348
            foreach Engine.GamePlayers(LP)
            {
                FrontEnd.DifficultyMenu.OnDaydreamBtn(LP.ControllerId);                
            }                        
        }
        else
        {
            return;
        }
    }
    //return;    
}
