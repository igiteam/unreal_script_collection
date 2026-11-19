class AdvCheatManager extends EvilCheatManager within AdvPlayerController
    config(Game);

var transient bool bFlashlightOffsetEditorMode;

exec function TeleportToGameTeleportInfo(int Index)
{
    local AdvGameSP EvilGame;

    EvilGame = AdvGameSP(Outer.WorldInfo.Game);
    // End:0x13D
    if(EvilGame != none)
    {
        // End:0x13D
        if(EvilGame.TeleportInfos.Length > Index)
        {
            Outer.ViewTarget.SetLocation(EvilGame.TeleportInfos[Index].PawnLocation);
            Outer.SetRotation(EvilGame.TeleportInfos[Index].ControllerRotation);
        }
    }
    //return;    
}

exec function ToggleRain()
{
    local SeqAct_WeatherEffectControl WEC;

    WEC = new (self) Class'SeqAct_WeatherEffectControl';
    WEC.InputLinks[0].bHasImpulse = (Outer.WeatherEffect == none) || !Outer.WeatherEffect.bEnabled;
    WEC.InputLinks[1].bHasImpulse = !WEC.InputLinks[0].bHasImpulse;
    WEC.Activated();
    //return;    
}

exec function TeleportAllFriends()
{
    local AdvAIController FriendController;
    local Vector FriendLocation;

    // End:0x12A
    foreach Outer.WorldInfo.AllControllers(Class'AdvAIController', FriendController)
    {
        // End:0x129
        if(FriendController.IsFriendly(Outer))
        {
            FriendController.GetNearGoalLocation(200.0000000, Outer.Pawn.Location, FriendLocation);
            FriendController.ReturnToIdle();
            FriendController.Pawn.SetLocation(FriendLocation);
        }        
    }    
    //return;    
}

exec function SetDifficultyLevel(int DifficultyLevel)
{
    local AdvPlayerController PC;

    // End:0x9E
    foreach Outer.WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        PC.SetPuzzleDifficultyLevel(byte(DifficultyLevel));
        PC.SetFightDifficultyLevel(byte(DifficultyLevel));        
    }    
    //return;    
}

exec function AllWeapons()
{
    // End:0x66
    if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
    {
        return;
    }
    GiveWeapon("AdvGameContent.AdvWeap_MP38");
    GiveWeapon("AdvGameContent.AdvWeap_MP34");
    GiveWeapon("AdvGameContent.AdvWeap_Suomi");
    GiveWeapon("AdvGameContent.AdvWeap_Bergman");
    GiveWeapon("AdvGameContent.AdvWeap_P38");
    GiveWeapon("AdvGameContent.AdvWeap_Tokarev");
    GiveWeapon("AdvGameContent.AdvWeap_LugerFix");
    GiveWeapon("AdvGameContent.AdvWeap_Webley");
    GiveWeapon("AdvGameContent.AdvWeap_C96");
    GiveWeapon("AdvGameContent.AdvWeap_Vis");
    GiveWeapon("AdvGameContent.AdvWeap_Roth");
    GiveWeapon("AdvGameContent.AdvWeap_M1887");
    GiveWeapon("AdvGameContent.AdvWeap_SLD");
    GiveWeapon("AdvGameContent.AdvWeap_MG34");
    GiveWeapon("AdvGameContent.AdvWeap_DP27");
    GiveWeapon("AdvGameContent.AdvWeap_Browning");
    GiveWeapon("AdvGameContent.AdvWeap_Thompson");
    GiveWeapon("AdvGameContent.AdvWeap_MauserSelbstlader");
    GiveWeapon("AdvGameContent.AdvWeap_FlareGun");
    GiveWeapon("AdvGameContent.AdvWeap_Leuchpistol");
    GiveWeapon("AdvGameContent.AdvWeap_Fedorov");
    GiveWeapon("AdvGameContent.AdvWeap_Smle");
    GiveWeapon("AdvGameContent.AdvWeap_Throw_Dynamite");
    GiveWeapon("AdvGame.AdvWeap_Melee_Machete");
    GiveWeapon("AdvGame.AdvInventoryItem_Compass");
    GiveWeapon("AdvGame.AdvInventoryItem_Torch");
    GiveWeapon("AdvGame.AdvInventoryItem_Notepad");
    //return;    
}

exec function GiveNext(int invGroup)
{
    local string weaponToGive;
    local class<EvilWeap_Base> WeaponClass;

    // End:0x66
    if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
    {
        return;
    }
    // End:0x349
    if(EvilInventoryManager(Outer.Pawn.InvManager) != none)
    {
        weaponToGive = "AdvGameContent." $ EvilInventoryManager(Outer.Pawn.InvManager).GiveNextTest(invGroup);
        GiveWeapon(weaponToGive);
        WeaponClass = class<EvilWeap_Base>(DynamicLoadObject(weaponToGive, Class'Core.Class'));
        // End:0x245
        if((EvilWeap_Base(Outer.Pawn.Weapon) != none) && !EvilWeap_Base(Outer.Pawn.Weapon).bSuppressPickupSwitch)
        {
            EvilPawn(Outer.Pawn).SetCurrentWeaponClass(WeaponClass);
        }
        GiveWeapon("AdvGameContent.AdvWeap_Throw_Dynamite");
        GiveWeapon("AdvGame.AdvWeap_Melee_Machete");
        GiveWeapon("AdvGame.AdvInventoryItem_Compass");
        GiveWeapon("AdvGame.AdvInventoryItem_Torch");
        GiveWeapon("AdvGame.AdvInventoryItem_Notepad");
        GiveWeapon("AdvGame.AdvInventoryItem_Map");
    }
    //return;    
}

exec function FlashlightOffsetEditor()
{
    // End:0x3C
    if(bFlashlightOffsetEditorMode)
    {
        bFlashlightOffsetEditorMode = false;
        Outer.PopState();        
    }
    else
    {
        bFlashlightOffsetEditorMode = true;
        Outer.PushState('FlashlightOffsetEditor');
    }
    //return;    
}

exec function DemoWeapons()
{
    // End:0x66
    if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
    {
        return;
    }
    GiveWeapon("AdvGameContent.AdvWeap_MP38");
    GiveWeapon("AdvGameContent.AdvWeap_Suomi");
    GiveWeapon("AdvGameContent.AdvWeap_P38");
    GiveWeapon("AdvGameContent.AdvWeap_Tokarev");
    GiveWeapon("AdvGameContent.AdvWeap_LugerFix");
    GiveWeapon("AdvGameContent.AdvWeap_Webley");
    GiveWeapon("AdvGameContent.AdvWeap_Roth");
    GiveWeapon("AdvGameContent.AdvWeap_MG34");
    GiveWeapon("AdvGameContent.AdvWeap_Browning");
    GiveWeapon("AdvGameContent.AdvWeap_Thompson");
    GiveWeapon("AdvGameContent.AdvWeap_Throw_Dynamite");
    GiveWeapon("AdvGame.AdvWeap_Melee_Machete");
    GiveWeapon("AdvGame.AdvInventoryItem_Compass");
    GiveWeapon("AdvGame.AdvInventoryItem_Torch");
    GiveWeapon("AdvGame.AdvInventoryItem_Notepad");
    //return;    
}

exec function KillAllCreatures()
{
    local EvilCreature P;

    // End:0x98
    foreach Outer.DynamicActors(Class'EvilGame.EvilCreature', P)
    {
        // End:0x7F
        if(P.Controller != none)
        {
            P.Controller.Destroy();
        }
        P.Destroy();        
    }    
    //return;    
}

exec function AddOneKillPerk()
{
    local AdvPlayerController PC;

    // End:0x299
    foreach Outer.WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[0]++;
        AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[1]++;
        // End:0x228
        if(AdvGFxHudWrapper(PC.myHUD) != none)
        {
            AdvGFxHud(AdvGFxHudWrapper(PC.myHUD).HudMovie).SetKillStreakKillCount(AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[0]);
            AdvGFxHud(AdvGFxHudWrapper(PC.myHUD).HudMovie).SetKillStreakKillCount(AdvPRI(PC.PlayerReplicationInfo).KillStrikePoints[1]);
        }
        AdvGameMP_Base(Outer.WorldInfo.Game).PerkManager.PreparePerkNotification(PC);        
    }    
    //return;    
}

exec function AddBlessing(int BlessingIndex)
{
    local AdvPlayerControllerMP PC;
    local AdvBlessing_Base Blessing;

    // End:0x2F
    if(BlessingIndex > Class'AdvBlessingManager'.default.AllBlessings.Length)
    {
        return;
    }
    // End:0x117
    foreach Outer.WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        Blessing = Outer.Spawn(Class'AdvBlessingManager'.default.AllBlessings[BlessingIndex]);
        PC.AddBlessing(Blessing);
        Blessing.PreActivate();        
    }    
    //return;    
}

exec function AddTreasure(int TreasureType, optional int TreasuresCount = 1)
{
    local int I;

    I = 0;
    J0x10:

    // End:0x7F [Loop If]
    if(I < TreasuresCount)
    {
        AdvPRI(Outer.PlayerReplicationInfo).AddTreasure("", byte(TreasureType));
        I++;
        // [Loop Continue]
        goto J0x10;
    }
    //return;    
}

exec function AlienwareStart()
{
    local EvilEngine Engine;
    local Color LightColor;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    LightColor.R = 0;
    LightColor.G = 255;
    LightColor.B = 0;
    LightColor.A = 255;
    Engine.AlienwareSetLights(0, LightColor);
    //return;    
}

exec function AlienwareStop()
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.AlienwareTurnOffLights();
    //return;    
}

exec function ClearTreasuresAndUpgrades()
{
    local byte Data[4];
    local int ProfileInt;

    // End:0x1AF
    if(Outer.ProfileSettings != none)
    {
        Data[0] = 0;
        Data[1] = 0;
        Data[2] = 0;
        Data[3] = 0;
        Data[4] = 0;
        Outer.ProfileSettings.SetBytesArrayIntoInt(Data, ProfileInt);
        Outer.ProfileSettings.SetProfileSettingValueInt(43, ProfileInt);
        Outer.ProfileSettings.SetProfileSettingValueInt(44, ProfileInt);
        Outer.ProfileSettings.SetProfileSettingValueInt(45, ProfileInt);
        Outer.ProfileSettings.SetProfileSettingValueInt(46, ProfileInt);
    }
    //return;    
}

exec function DisplayTreasuresFromProfile()
{
    local byte Data[4];
    local int ProfileInt;

    // End:0x12E
    if(Outer.ProfileSettings != none)
    {
        Outer.ProfileSettings.GetProfileSettingValueInt(43, ProfileInt);
        Outer.ProfileSettings.GetBytesArrayFromInt(ProfileInt, Data);
        Outer.ProfileSettings.GetProfileSettingValueInt(44, ProfileInt);
        Outer.ProfileSettings.GetBytesArrayFromInt(ProfileInt, Data);
    }
    //return;    
}

exec function DisplayUpgradesFromProfile()
{
    local byte Data[4];
    local int ProfileInt;

    // End:0x12E
    if(Outer.ProfileSettings != none)
    {
        Outer.ProfileSettings.GetProfileSettingValueInt(45, ProfileInt);
        Outer.ProfileSettings.GetBytesArrayFromInt(ProfileInt, Data);
        Outer.ProfileSettings.GetProfileSettingValueInt(46, ProfileInt);
        Outer.ProfileSettings.GetBytesArrayFromInt(ProfileInt, Data);
    }
    //return;    
}

exec function ToggleFocusMode()
{
    local AdvGRI_MP GRIMP;

    GRIMP = AdvGRI_MP(Outer.WorldInfo.GRI);
    // End:0xB5
    if(GRIMP != none)
    {
        GRIMP.bFocusHighlightsEnabled = !GRIMP.bFocusHighlightsEnabled;
        GRIMP.UpdateFocusHighlightsEnabled();
    }
    //return;    
}

exec function ADVEndOfLevel()
{
    local AdvGRI_SP GRI;

    GRI = AdvGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x76
    if(GRI != none)
    {
        GRI.ShowAndWriteLevelStatistics(false);
    }
    //return;    
}

exec function ADVUnlockAllLevels()
{
    local AdvEngine Eng;
    local int I;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0xBC
    if(Eng.CurrentCheckpoint != none)
    {
        I = 0;
        J0x61:

        // End:0xBC [Loop If]
        if(I < 118)
        {
            Eng.CurrentCheckpoint.SetLevelCompleted(I);
            I++;
            // [Loop Continue]
            goto J0x61;
        }
    }
    Outer.SaveCheckpoint(,, true);
    //return;    
}

exec function ADVSetMaxLevel()
{
    Outer.IncrementGlobalIntStat(36, 400000, true);
    //return;    
}

exec function ChangeCharacter(int NewIndex)
{
    AdvPRI(Outer.PlayerReplicationInfo).SetupPlayerCharacter(NewIndex);
    AdvPawn(Outer.Pawn).SetCharacterClassFromInfo(AdvPRI(Outer.PlayerReplicationInfo).GetCharClassInfo());
    //return;    
}

exec function DebugFakeFailedNetworkMatchTransition()
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.DisplayErrorMessage("NeedGoldTierAccount_Message", "XboxLive_Title", "GenericContinue", LocalPlayer(Outer.Player));
    AdvGFxMenuHudWrapper(Outer.myHUD).Frontend.bDeferredFrontendRestart = true;
    //return;    
}

exec function ToggleFlashlightFunction()
{
    local AdvPlayerPawn P;
    local editinline SpotLightComponent SLC;

    P = AdvPlayerPawn(Outer.Pawn);
    // End:0x12E
    if(P != none)
    {
        SLC = P.MyTorch.Parts.SpotLight;
        // End:0xD9
        if(SLC.Function != none)
        {
            SLC.SetLightProperties(,,, none);            
        }
        else
        {
            SLC.SetLightProperties(,,, AdvFlashlightSpotlightComponent'ar_FlashLight.ar_FlashLight_SpotComponent'.Function.DeriveWithMaterialInstance());
        }
    }
    //return;    
}

exec function ToggleFlashlightVolume()
{
    local AdvPlayerPawn P;
    local LinearColor LC;

    P = AdvPlayerPawn(Outer.Pawn);
    // End:0x637
    if(P != none)
    {
        // End:0x1C7
        if(P.MyTorch.Parts.Volume != none)
        {
            P.MyTorch.Parts.Volume.DetachFromAny();
            P.MyTorch.Parts.Volume = none;
            P.MyTorch.Parts.VolumeMI[0] = none;
            P.MyTorch.Parts.VolumeMI[1] = none;            
        }
        else
        {
            P.MyTorch.Parts.Volume = new (Outer) Class'UDKBase.UDKSkeletalMeshComponent' (UDKSkeletalMeshComponent'ar_FlashLight.ar_FlashLight_Volume');
            P.MyTorch.Parts.VolumeMI[0] = P.MyTorch.Parts.Volume.CreateAndSetMaterialInstanceConstant(0);
            P.MyTorch.Parts.VolumeMI[1] = P.MyTorch.Parts.Volume.CreateAndSetMaterialInstanceConstant(1);
            LC = ColorToLinearColor(P.MyTorch.Parts.SpotLight.LightColor);
            LC.A = 1.2000000;
            P.MyTorch.Parts.VolumeMI[0].SetVectorParameterValue('Color', LC);
            P.MyTorch.Parts.VolumeMI[1].SetVectorParameterValue('Color', LC);
            P.MyTorch.Parts.Volume.SetFOV(UDKSkeletalMeshComponent(P.MyTorch.Mesh).FOV);
            UDKSkeletalMeshComponent(P.MyTorch.Mesh).AttachComponentToSocket(P.MyTorch.Parts.Volume, 'LightVolume');
        }
    }
    //return;    
}

exec function DebugFlashlightAttachment()
{
    local AdvPlayerPawn P;

    P = AdvPlayerPawn(Outer.Pawn);
    // End:0x185
    if((P != none) && AdvAttachment_Weap_Base(P.CurrentWeaponAttachment) != none)
    {
        AdvAttachment_Weap_Base(P.CurrentWeaponAttachment).bAttachFlashlightToWeapon = true;
        AdvAttachment_Weap_Base(P.CurrentWeaponAttachment).AttachToWeapon(P.CurrentWeaponAttachment);
        AdvAttachment_Weap_Base(P.CurrentWeaponAttachment).InternalAttach();
        AdvAttachment_Weap_Base(P.CurrentWeaponAttachment).bCheckForFlashlight = true;
    }
    //return;    
}

exec function UnlockPerk(int Index)
{
    local AdvPlayerControllerMP PC;

    // End:0xC8
    foreach Outer.WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        PC.bAvaiblePerks.Length = 4;
        PC.bAvaiblePerks[Index] = 1;
        PC.DebugUnlockPerk(Index, PC);        
    }    
    //return;    
}
