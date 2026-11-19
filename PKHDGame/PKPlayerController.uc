class PKPlayerController extends EvilPlayerController
    native(PC)
    config(Game)
    hidecategories(Navigation);

const MAX_CUSTOM_MESSAGES = 10;

struct AmmoStoreRecord
{
    var array<int> Amount;
    var string WeaponClassString;

    structdefaultproperties
    {
        Amount=none
        WeaponClassString=""
    }
};

struct CheckpointRecord
{
    var Guid SavedGuid;
    var name CheckpointName;
    var Vector Location;
    var Rotator Rotation;
    var string PawnPathName;
    var string PawnClassName;
    var byte TeamIndex;
    var array<InventoryRecord> InventoryRecords;
    var array<AmmoStoreRecord> AmmoStoreRecords;
    var int MonstersKilled;
    var int ArmourFound;
    var int AmmoFound;
    var int BonusItems;
    var int HolyItems;
    var int SecretsFound;
    var int MonstersKilledInDeamonMode;
    var int PlayerMoney;
    var int PlayerMoneyFound;
    var int TotalArmourFound;
    var int SoulsCollected;
    var int DestroyedObjects;
    var int PlayerCoinsFound;
    var int MonsterHitCounter;
    var int ShotsCounter;
    var int StakeShotCounter;
    var int MonstersGibbed;
    var int GoldenCardsUseLeft;
    var bool bPlayerGotSomeDamage;
    var PKTypes.EDifficultyLevel DifficultyLevel;
    var int GRIMonstersPossessedBySoulCatcher;
    var int GRIBonusItemsFromFallenEnemy;
    var int GRIMonstersKilledInDeamonMode;
    var int GRITotalSoulsCollected;
    var int GRIDemonModeStarts;
    var int GRIGibbedFrozenMonsters;
    var int GRIPawnsDetachedLimbs;
    var int GRIGibbedPawns;
    var int GRIGameplayTime;
    var LevelStatistics CurrentLevelStatistics;
    var int Health;
    var int HealthMax;
    var int Armour;
    var string ArmourClass;
    var float DemonModeRemainingTime;
    var bool bFlashlightOn;
    var bool bFireModeSwitch;
    var bool bPlayingMusic;
    var bool bPlayingBattleMusic;
    var array<MusicTrackStruct> BattleMusic;
    var array<MusicTrackStruct> AmbientMusic;
    var array<string> BattleCues;
    var array<string> AmbientCues;

    structdefaultproperties
    {
        SavedGuid=(A=0,B=0,C=0,D=0)
        CheckpointName="None"
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        PawnPathName=""
        PawnClassName=""
        TeamIndex=0
        InventoryRecords=none
        AmmoStoreRecords=none
        MonstersKilled=0
        ArmourFound=0
        AmmoFound=0
        BonusItems=0
        HolyItems=0
        SecretsFound=0
        MonstersKilledInDeamonMode=0
        PlayerMoney=0
        PlayerMoneyFound=0
        TotalArmourFound=0
        SoulsCollected=0
        DestroyedObjects=0
        PlayerCoinsFound=0
        MonsterHitCounter=0
        ShotsCounter=0
        StakeShotCounter=0
        MonstersGibbed=0
        GoldenCardsUseLeft=0
        bPlayerGotSomeDamage=false
        DifficultyLevel=EDifficultyLevel.DL_Daydream
        GRIMonstersPossessedBySoulCatcher=0
        GRIBonusItemsFromFallenEnemy=0
        GRIMonstersKilledInDeamonMode=0
        GRITotalSoulsCollected=0
        GRIDemonModeStarts=0
        GRIGibbedFrozenMonsters=0
        GRIPawnsDetachedLimbs=0
        GRIGibbedPawns=0
        GRIGameplayTime=0
        CurrentLevelStatistics=(GameplayTime=0,Difficulty=EDifficultyLevel.DL_Daydream,MonstersKilled=0,SoulsCollected=0,ArmorsFound=0,GoldFound=0,BonusItems=0,HolyItemsFound=0,AmmoFound=0,ObjectsDestroyed=0,SecretsFound=0,TotalMonsters=0,TotalSouls=0,TotalArmors=0,TotalGold=0,TotalHolyItems=0,TotalAmmo=0,TotalObjects=0,TotalSecrets=0,TimeDiff=0,MonstersDiff=0,SoulsDiff=0,ArmorsDiff=0,GoldDiff=0,HolyDiff=0,AmmoDiff=0,ObjectsDiff=0,SecretsDiff=0)
        Health=0
        HealthMax=0
        Armour=0
        ArmourClass=""
        DemonModeRemainingTime=0.0000000
        bFlashlightOn=false
        bFireModeSwitch=false
        bPlayingMusic=false
        bPlayingBattleMusic=false
        BattleMusic=none
        AmbientMusic=none
        BattleCues=none
        AmbientCues=none
    }
};

var PainProfileSettings ProfileSettings;
var PKPlayerPersistentData PersistentData;
var PKLeaderboardReadBase LeaderboardStatsRead;
var class<PKLeaderboardWriteBase> LeaderboardStatsWriteClass;
var PKLeaderboardReadBase LeaderboardSingleStatsRead;
var class<PKLeaderboardWriteBase> LeaderboardSingleStatsWriteClass;
var bool bPersistentDataReadComplete;
var bool bGoldenCardsActiveEffects;
var transient bool bHasSigninChanged;
var bool bRespawnInGhostMode;
var bool bDeathLocationNotValid;
var() bool bShowSpeedMeter;
var bool bFlashlightOn;
var() config bool bFireModeSwitch;
var transient bool bPlayerGotSomeDamage;
var bool bIsReturningFromMatch;
var bool bIsReturningToMainMenu;
var transient bool bWinnerOfTheMatch;
var bool bAlienwareLightIsOn;
var private bool bIsJanuaryFreeWeekendSubScribed;
var PainGFxHudWrapper PKHudWrapper;
var() PostProcessChain DemonVisionPPChain;
var() PostProcessChain DemonVisionPPChain_Xbox;
var() float DemonBulletTimeMultiplier;
var() SoundCue DemonModeStartCue;
var() SoundCue DemonModeStopCue;
var() SoundCue DemonModeLoopCue;
var SoundCue CantUseSoundCue;
var SoundCue CanUseSoundCue;
var export editinline AudioComponent DemonModeLoopComponent;
var export editinline array<export editinline PrimitiveComponent> DemonModeHighlights;
var export editinline AudioComponent WeaponModifierAudioLoop;
var array<LevelStatistics> CachedLevelStatistics;
var array<LevelStatistics> CachedCOOPLevelStatistics;
var() PostProcessChain GhostPPChain;
var EvilExplosion CoopRespawnExplosionTemplate;
var int SoulsCollectedInGhost;
var float TimeRemainingInGhost;
var float HUDScale;
var int CrosshairIndex;
var() float GlobalHeadBob;
var() float GlobalWeaponBobDamping;
var transient int CurrentLevelMonsterHitCounter;
var transient int CurrentLevelShotsCount;
var UniqueNetId LobbyUID;
var array<byte> QuickActionCustom1;
var array<byte> QuickActionCustom2;
var array<CustomWeaponSelectInfo> CustomWeaponMapping;
var array<string> CustomMessages;
var transient int StakeGunShots;
var transient PKPartyGameSettings NewPartySettings;
var() SoundMode BulletTimeSoundMode;
var int VoiceChannel;
var Color AlienwareLightColor;
var config float AlienwareBlinkSpeed;
var config float AlienwareBlinkDuration;
var SoundCue ResurrectSound;
var byte DownladedDLCS[EDLCIdentifiers];
var int CurrentDLCIndex;
//var delegate<CanUnpause> __CanUnpause__Delegate;
//var delegate<OnDestroyPartyComplete> __OnDestroyPartyComplete__Delegate;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        TimeRemainingInGhost;
}

function SetCharacter(string inCharacter)
{
    local OnlineGameSettings GameSettings;

    super(Controller).SetCharacter(inCharacter);
    GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
    // End:0x126
    if(((WorldInfo.GRI.IsCoopMultiplayerGame() || WorldInfo.GRI.IsMultiplayerGame()) && int(WorldInfo.NetMode) != int(NM_Client)) && !GameSettings.bIsLanMatch)
    {
        SetupSteamLobby();
    }
    //return;    
}

function bool IsSecondSplitCoopPlayer()
{
    return Player != Class'Engine.Engine'.static.GetEngine().GamePlayers[0];
    //return ReturnValue;    
}

simulated function OnlineSubsystem.ELoginStatus GetMyLoginStatus()
{
    local OnlineSubsystem.ELoginStatus Result;
    local PKLocalPlayer LP;

    LP = PKLocalPlayer(Player);
    Result = Class'Engine.UIInteraction'.static.GetLoginStatus(LP.ControllerId);
    return Result;
    //return ReturnValue;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    local InventoryRecord InvRecord;
    local PKInventoryManager PKInv;
    local AmmoStore AmmoStoreDatum;
    local AmmoStoreRecord AmmoStoreRec;
    local EvilWeap_Base Weapon;
    local Pawn InvHolder;
    local PainPRI PRI;
    local PainGRI GRI;
    local PKGameSP Game;
    local int I;

    PRI = PainPRI(PlayerReplicationInfo);
    GRI = PainGRI(WorldInfo.GRI);
    Game = PKGameSP(WorldInfo.Game);
    // End:0x96B
    if(MyEvilPawn != none)
    {
        Record.SavedGuid = MyGuid;
        Record.CheckpointName = LastCheckpointSaveName;
        Record.TeamIndex = GetTeamNum();
        Record.PawnClassName = PathName(Pawn.Class);
        Record.Location = Pawn.Location;
        Record.Rotation = Pawn.Rotation;
        Record.Health = Pawn.Health;
        Record.HealthMax = Pawn.HealthMax;
        Record.Armour = PKPlayerPawn(Pawn).Armour;
        Record.ArmourClass = string(PKPlayerPawn(Pawn).ArmourClass);
        Record.MonstersKilled = PRI.MonstersKilled;
        Record.ArmourFound = PRI.ArmourFound;
        Record.AmmoFound = PRI.AmmoFound;
        Record.BonusItems = PRI.BonusItems;
        Record.HolyItems = PRI.HolyItems;
        Record.SecretsFound = PRI.SecretsFound;
        Record.MonstersKilledInDeamonMode = PRI.MonstersKilledInDeamonMode;
        Record.PlayerMoney = PRI.PlayerMoney;
        Record.PlayerMoneyFound = PRI.PlayerMoneyFound;
        Record.TotalArmourFound = PRI.TotalArmourFound;
        Record.SoulsCollected = PRI.SoulsCollected;
        Record.DestroyedObjects = PRI.DestroyedObjects;
        Record.PlayerCoinsFound = PRI.PlayerCoinsFound;
        Record.MonstersGibbed = PRI.MonstersGibbed;
        Record.DifficultyLevel = PRI.Difficulty.default.DifficultyLevel;
        Record.GoldenCardsUseLeft = PRI.GoldenCardsUseLeft;
        Record.GRIBonusItemsFromFallenEnemy = GRI.BonusItemsFromFallenEnemy;
        Record.GRIMonstersKilledInDeamonMode = GRI.MonstersKilledInDeamonMode;
        Record.GRITotalSoulsCollected = GRI.TotalSoulsCollected;
        Record.GRIDemonModeStarts = GRI.DemonModeStarts;
        Record.GRIGibbedFrozenMonsters = GRI.GibbedFrozenMonsters;
        Record.GRIMonstersPossessedBySoulCatcher = GRI.MonstersPossessedBySoulCatcher;
        Record.GRIPawnsDetachedLimbs = GRI.PawnsDetachedLimbs;
        Record.GRIGibbedPawns = GRI.GibbedPawns;
        Record.GRIGameplayTime = GRI.GameplayTime;
        Record.ShotsCounter = CurrentLevelShotsCount;
        Record.StakeShotCounter = StakeGunShots;
        Record.MonsterHitCounter = CurrentLevelMonsterHitCounter;
        Record.bPlayerGotSomeDamage = bPlayerGotSomeDamage;
        GRI.CopyGlobalStatisticsToLevelStatisticsStruct(Record.CurrentLevelStatistics);        
    }
    else
    {
        Record.PawnPathName = PathName(Pawn);
    }
    // End:0xBDA
    if(Pawn != none)
    {
        // End:0x9F6
        if(Vehicle(Pawn) != none)
        {
            InvHolder = Vehicle(Pawn).Driver;            
        }
        else
        {
            InvHolder = Pawn;
        }
        // End:0xAC6
        foreach InvHolder.InvManager.InventoryActors(Class'EvilGame.EvilWeap_Base', Weapon)
        {
            // End:0xAC5
            if(Weapon.ShouldSaveForCheckpoint())
            {
                Weapon.CreateCheckpointRecord(InvRecord);
                Record.InventoryRecords.AddItem(InvRecord);
            }            
        }        
        PKInv = PKInventoryManager(InvHolder.InvManager);
        // End:0xBDA
        if(PKInv != none)
        {
            // End:0xBD9
            foreach PKInv.AmmoStorage(AmmoStoreDatum)
            {
                AmmoStoreRec.Amount = AmmoStoreDatum.Amount;
                AmmoStoreRec.WeaponClassString = PathName(AmmoStoreDatum.WeaponClass);
                Record.AmmoStoreRecords.AddItem(AmmoStoreRec);                
            }            
        }
    }
    // End:0xF07
    if(Game != none)
    {
        Record.DemonModeRemainingTime = Game.GetRemainingDemonModeTime();
        Record.bPlayingMusic = Game.IsPlayingMusic();
        // End:0xF07
        if(Record.bPlayingMusic)
        {
            Record.bPlayingBattleMusic = Game.bPlayingBattleMusic;
            Record.BattleMusic = Game.BattleMusic;
            Record.AmbientMusic = Game.AmbientMusic;
            Record.AmbientCues.Length = Record.AmbientMusic.Length;
            I = 0;
            J0xD7B:

            // End:0xE1E [Loop If]
            if(I < Record.AmbientMusic.Length)
            {
                Record.AmbientCues[I] = PathName(Record.AmbientMusic[I].TheSoundCue);
                ++I;
                // [Loop Continue]
                goto J0xD7B;
            }
            Record.BattleCues.Length = Record.BattleMusic.Length;
            I = 0;
            J0xE64:

            // End:0xF07 [Loop If]
            if(I < Record.BattleMusic.Length)
            {
                Record.BattleCues[I] = PathName(Record.BattleMusic[I].TheSoundCue);
                ++I;
                // [Loop Continue]
                goto J0xE64;
            }
        }
    }
    Record.bFlashlightOn = bFlashlightOn;
    Record.bFireModeSwitch = bFireModeSwitch;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local PKInventoryManager PKInv;
    local AmmoStore AmmoStoreDatum;
    local AmmoStoreRecord AmmoStoreRec;
    local Rotator CamRot;
    local Pawn FoundPawn;
    local PainPRI PRI;
    local PainGRI GRI;
    local PKGameSP Game;
    local int I;

    PRI = PainPRI(PlayerReplicationInfo);
    GRI = PainGRI(WorldInfo.GRI);
    MyGuid = Record.SavedGuid;
    LastCheckpointSaveName = Record.CheckpointName;
    // End:0xCF
    if(MyEvilPawn != none)
    {
        MyEvilPawn.LifeSpan = 0.1000000;        
    }
    else
    {
        // End:0x10F
        if(Vehicle(Pawn) != none)
        {
            Vehicle(Pawn).DriverLeft();
        }
    }
    UnPossess();
    // End:0x40F
    if(Record.PawnPathName == "")
    {
        WorldInfo.Game.RestartPlayer(self);
        // End:0x40C
        if(Pawn != none)
        {
            ApplyInventoryRecords(Record.InventoryRecords);
            PKInv = PKInventoryManager(Pawn.InvManager);
            // End:0x2EC
            if(PKInv != none)
            {
                PKInv.AmmoStorage.Length = 0;
                // End:0x2EB
                foreach Record.AmmoStoreRecords(AmmoStoreRec)
                {
                    AmmoStoreDatum.Amount = AmmoStoreRec.Amount;
                    AmmoStoreDatum.WeaponClass = class<EvilWeap_Base>(FindObject(AmmoStoreRec.WeaponClassString, Class'Core.Class'));
                    PKInv.AmmoStorage.AddItem(AmmoStoreDatum);                    
                }                
            }
            WorldInfo.Game.ChangeTeam(self, int(Record.TeamIndex), false);
            Pawn.SetLocation(Record.Location);
            Pawn.SetRotation(Record.Rotation);
            CamRot = Record.Rotation;
            CamRot.Roll = 0;
            SetRotation(CamRot);
            ClientSetRotation(CamRot);
        }        
    }
    else
    {
        FoundPawn = Pawn(FindObject(Record.PawnPathName, Class'Engine.Pawn'));
        // End:0x676
        if(FoundPawn != none)
        {
            FoundPawn.SetHidden(false);
            // End:0x549
            if(Vehicle(FoundPawn) != none)
            {
                // End:0x549
                if(Vehicle(FoundPawn) != Pawn)
                {
                    WorldInfo.Game.RestartPlayer(self);
                    ApplyInventoryRecords(Record.InventoryRecords);
                    // End:0x549
                    if(!Vehicle(FoundPawn).TryToDrive(Pawn))
                    {
                    }
                }
            }
            FoundPawn.SetLocation(Record.Location);
            FoundPawn.SetRotation(Record.Rotation);
            // End:0x5DC
            if(FoundPawn != Pawn)
            {
                Possess(FoundPawn, false);
            }
            SetRotation(Record.Rotation);
            ClientSetRotation(Record.Rotation);
            WorldInfo.Game.ChangeTeam(self, int(Record.TeamIndex), false);
        }
    }
    // End:0x7AD
    if(Pawn != none)
    {
        Pawn.Health = Record.Health;
        Pawn.HealthMax = Record.HealthMax;
        PKPlayerPawn(Pawn).Armour = Record.Armour;
        PKPlayerPawn(Pawn).ArmourClass = class<PainItem_Armour_Base>(DynamicLoadObject("PKHDGame." $ Record.ArmourClass, Class'Core.Class'));
    }
    PRI.MonstersKilled = Record.MonstersKilled;
    PRI.ArmourFound = Record.ArmourFound;
    PRI.AmmoFound = Record.AmmoFound;
    PRI.BonusItems = Record.BonusItems;
    PRI.HolyItems = Record.HolyItems;
    PRI.SecretsFound = Record.SecretsFound;
    PRI.MonstersKilledInDeamonMode = Record.MonstersKilledInDeamonMode;
    PRI.PlayerMoney = Record.PlayerMoney;
    PRI.PlayerMoneyFound = Record.PlayerMoneyFound;
    PRI.TotalArmourFound = Record.TotalArmourFound;
    PRI.SoulsCollected = Record.SoulsCollected;
    PRI.DestroyedObjects = Record.DestroyedObjects;
    PRI.PlayerCoinsFound = Record.PlayerCoinsFound;
    PRI.MonstersGibbed = Record.MonstersGibbed;
    PRI.Difficulty = Class'PainDifficultySettings'.static.GetClassByID(Record.DifficultyLevel);
    PRI.Difficulty.static.ApplyDifficultySettings(self);
    PRI.GoldenCardsUseLeft = Record.GoldenCardsUseLeft;
    GRI.BonusItemsFromFallenEnemy = Record.GRIBonusItemsFromFallenEnemy;
    GRI.MonstersKilledInDeamonMode = Record.GRIMonstersKilledInDeamonMode;
    GRI.TotalSoulsCollected = Record.GRITotalSoulsCollected;
    GRI.DemonModeStarts = Record.GRIDemonModeStarts;
    GRI.GibbedFrozenMonsters = Record.GRIGibbedFrozenMonsters;
    GRI.MonstersPossessedBySoulCatcher = Record.GRIMonstersPossessedBySoulCatcher;
    GRI.PawnsDetachedLimbs = Record.GRIPawnsDetachedLimbs;
    GRI.GibbedPawns = Record.GRIGibbedPawns;
    GRI.GameplayTime = Record.GRIGameplayTime;
    CurrentLevelMonsterHitCounter = Record.MonsterHitCounter;
    CurrentLevelShotsCount = Record.ShotsCounter;
    StakeGunShots = Record.StakeShotCounter;
    bPlayerGotSomeDamage = Record.bPlayerGotSomeDamage;
    GRI.CopyLevelStatisticsToGlobalStatistics(Record.CurrentLevelStatistics);
    // End:0xEE5
    if(IsLocalPlayerController())
    {
        GetPPManager().Reset();
        GRI.ResumeGameplayTimer();
    }
    Game = PKGameSP(WorldInfo.Game);
    // End:0x125C
    if(Game != none)
    {
        // End:0xF87
        if(Record.DemonModeRemainingTime > 0.0000000)
        {
            Game.StartDaemonMode(Record.DemonModeRemainingTime);
        }
        // End:0x125C
        if(Record.bPlayingMusic)
        {
            Game.bPlayingBattleMusic = Record.bPlayingBattleMusic;
            // End:0x1041
            if(Record.bPlayingBattleMusic)
            {
                Game.LastSeenEnemyTime = WorldInfo.TimeSeconds;
            }
            Game.BattleMusic = Record.BattleMusic;
            Game.AmbientMusic = Record.AmbientMusic;
            I = 0;
            J0x10C2:

            // End:0x1179 [Loop If]
            if(I < Record.AmbientCues.Length)
            {
                Game.AmbientMusic[I].TheSoundCue = SoundCue(FindObject(Record.AmbientCues[I], Class'Engine.SoundCue'));
                ++I;
                // [Loop Continue]
                goto J0x10C2;
            }
            I = 0;
            J0x1184:

            // End:0x123B [Loop If]
            if(I < Record.BattleCues.Length)
            {
                Game.BattleMusic[I].TheSoundCue = SoundCue(FindObject(Record.BattleCues[I], Class'Engine.SoundCue'));
                ++I;
                // [Loop Continue]
                goto J0x1184;
            }
            Game.SetMusicController(true, true);
        }
    }
    // End:0x12B9
    if(PKPlayerPawn(Pawn) != none)
    {
        PKPlayerPawn(Pawn).SetFlashlight(Record.bFlashlightOn);
    }
    bFireModeSwitch = Record.bFireModeSwitch;
    //return;    
}

reliable client simulated function ClientSetHUD(class<HUD> newHUDType)
{
    super(PlayerController).ClientSetHUD(newHUDType);
    PKHudWrapper = PainGFxHudWrapper(myHUD);
    //return;    
}

reliable client simulated function ClientSetWinnerOfTheMatch(bool bWinner)
{
    // End:0x1B
    if(bWinner)
    {
        IncrementGlobalIntStat(128, 1);
    }
    bWinnerOfTheMatch = bWinner;
    //return;    
}

exec function SetSprint(bool SprintState)
{
    //return;    
}

reliable server function ServerSetSprint(bool SprintState)
{
    //return;    
}

exec function BossFastDamage(int Dmg)
{
    local PKPawn CurrentPawn;

    // End:0x65
    foreach DynamicActors(Class'PKPawn', CurrentPawn)
    {
        // End:0x64
        if(CurrentPawn.bIsBoss)
        {
            CurrentPawn.Health -= Dmg;
        }        
    }    
    //return;    
}

exec function BossSetState(name NewState)
{
    local PKPawn CurrentPawn;

    // End:0x14C
    foreach DynamicActors(Class'PKPawn', CurrentPawn)
    {
        // End:0x14B
        if(CurrentPawn.bIsBoss)
        {
            PKAIController(CurrentPawn.Controller).DumpCommandStack();
            PKAIController(CurrentPawn.Controller).BeginCombatCommand(PKAIController(CurrentPawn.Controller).GetDefaultCommand(),, true);
            PKAIController(CurrentPawn.Controller).GetActiveCommand().GotoState(NewState);
        }        
    }    
    //return;    
}

simulated function float GetLevelHitRatio()
{
    local float Ratio;

    // End:0x32
    if((CurrentLevelMonsterHitCounter == 0) || CurrentLevelShotsCount == 0)
    {
        Ratio = 0.0000000;        
    }
    else
    {
        Ratio = float(CurrentLevelMonsterHitCounter) / float(CurrentLevelShotsCount);
    }
    return Ratio;
    //return ReturnValue;    
}

simulated function float GetGlobalHitRatio()
{
    local float Ratio;
    local int ShootsCount, HitsCount;

    ProfileSettings.GetProfileSettingValueInt(125, ShootsCount);
    ProfileSettings.GetProfileSettingValueInt(126, HitsCount);
    // End:0x86
    if((ShootsCount == 0) || HitsCount == 0)
    {
        Ratio = 0.0000000;        
    }
    else
    {
        Ratio = float(HitsCount) / float(ShootsCount);
    }
    return Ratio;
    //return ReturnValue;    
}

simulated function float GetGlobalGibRatio()
{
    local float Ratio;
    local int KillsCount, GibsCount;

    ProfileSettings.GetProfileSettingValueInt(113, KillsCount);
    ProfileSettings.GetProfileSettingValueInt(120, GibsCount);
    // End:0x86
    if((KillsCount == 0) || GibsCount == 0)
    {
        Ratio = 0.0000000;        
    }
    else
    {
        Ratio = float(GibsCount) / float(KillsCount);
    }
    return Ratio;
    //return ReturnValue;    
}

simulated function float GetGlobalDemonRatio()
{
    local float Ratio;
    local int KillsCount, DemonKillsCount;

    ProfileSettings.GetProfileSettingValueInt(113, KillsCount);
    ProfileSettings.GetProfileSettingValueInt(131, DemonKillsCount);
    // End:0x86
    if((KillsCount == 0) || DemonKillsCount == 0)
    {
        Ratio = 0.0000000;        
    }
    else
    {
        Ratio = float(DemonKillsCount) / float(KillsCount);
    }
    return Ratio;
    //return ReturnValue;    
}

simulated function int GetGlobalAmmo()
{
    local int Ammo;

    ProfileSettings.GetProfileSettingValueInt(117, Ammo);
    return Ammo;
    //return ReturnValue;    
}

simulated function int GetGlobalStat(int stat)
{
    local int StatValue;

    ProfileSettings.GetProfileSettingValueInt(stat, StatValue);
    return StatValue;
    //return ReturnValue;    
}

simulated function int GetGlobalGold()
{
    local int Gold;

    ProfileSettings.GetProfileSettingValueInt(114, Gold);
    return Gold;
    //return ReturnValue;    
}

simulated function int GetGlobalBunnyTime()
{
    local int BunnySeconds;

    ProfileSettings.GetProfileSettingValueInt(119, BunnySeconds);
    return BunnySeconds;
    //return ReturnValue;    
}

simulated function int GetKillsWhenBunnyHop()
{
    local int BunnySeconds;

    ProfileSettings.GetProfileSettingValueInt(129, BunnySeconds);
    return BunnySeconds;
    //return ReturnValue;    
}

simulated function int GetGlobalSoul()
{
    local int Souls;

    ProfileSettings.GetProfileSettingValueInt(116, Souls);
    return Souls;
    //return ReturnValue;    
}

simulated function int GetGlobalKills()
{
    local int Kills;

    ProfileSettings.GetProfileSettingValueInt(113, Kills);
    return Kills;
    //return ReturnValue;    
}

simulated function int GetKillsInDemonMode()
{
    local int killsindemon;

    ProfileSettings.GetProfileSettingValueInt(131, killsindemon);
    return killsindemon;
    //return ReturnValue;    
}

reliable client simulated function CommitGlobalIntStat()
{
    //return;    
}

reliable client simulated function IncrementGlobalIntStat(int StatId, optional int Amount = 1, optional bool bForceSaveProfile = true)
{
    local PKAchievements.EPKGameAchievements AchievID;
    local int CurrentValue;

    // End:0x1B
    if(ProfileSettings == none)
    {
        return;
    }
    // End:0x2C
    if(ProfileSettings == none)
    {
        return;
    }
    ProfileSettings.GetProfileSettingValueInt(StatId, CurrentValue);
    ProfileSettings.SetProfileSettingValueInt(StatId, CurrentValue + Amount);
    // End:0xC0
    if(StatId == 126)
    {
        CurrentLevelMonsterHitCounter += Amount;        
    }
    else
    {
        // End:0xE4
        if(StatId == 125)
        {
            CurrentLevelShotsCount += Amount;
        }
    }
    // End:0x186
    if(((((((((StatId == 114) || StatId == 126) || StatId == 127) || StatId == 128) || StatId == 131) || StatId == 136) || StatId == 139) || StatId == 140) || StatId == 141)
    {
        return;
    }
    AchievID = Class'PKAchievements'.default.GlobalStatToAchievementMap[StatId];
    switch(AchievID)
    {
        // End:0x20E
        case 25:
            // End:0x20B
            if((CurrentValue + Amount) >= 666)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x251
        case 26:
            // End:0x24E
            if((CurrentValue + Amount) >= 999)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x28D
        case 45:
            // End:0x28A
            if((CurrentValue + Amount) >= 6666)
            {
                ClientUnlockAchievement(45, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x2D0
        case 27:
            // End:0x2CD
            if((CurrentValue + Amount) >= 2012)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x310
        case 28:
            // End:0x30D
            if((CurrentValue + Amount) >= 25)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x353
        case 32:
            // End:0x350
            if((CurrentValue + Amount) >= 667)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x396
        case 35:
            // End:0x393
            if((CurrentValue + Amount) >= 500)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x3D9
        case 36:
            // End:0x3D6
            if((CurrentValue + Amount) >= 300)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x41C
        case 39:
            // End:0x419
            if((CurrentValue + Amount) >= 666)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x45F
        case 40:
            // End:0x45C
            if((CurrentValue + Amount) >= 500)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x49F
        case 43:
            // End:0x49C
            if((CurrentValue + Amount) >= 40)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x4E2
        case 49:
            // End:0x4DF
            if((CurrentValue + Amount) >= 1000)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x525
        case 46:
            // End:0x522
            if((CurrentValue + Amount) >= 500)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x568
        case 37:
            // End:0x565
            if((CurrentValue + Amount) >= 333)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x5AB
        case 33:
            // End:0x5A8
            if((CurrentValue + Amount) >= 50000)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x5EE
        case 65:
            // End:0x5EB
            if((CurrentValue + Amount) >= 256)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0x62E
        case 47:
            // End:0x62B
            if((CurrentValue + Amount) >= 123)
            {
                ClientUnlockAchievement(AchievID, bForceSaveProfile);
            }
            // End:0x631
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function KilledSomeEnemiesByExplosion(const out array<EvilPawn> KilledPawns, class<DamageType> DamageType)
{
    local float CurrentTime;
    local int I, iKilledPawns;

    // End:0xFD
    if((KilledPawns.Length >= 5) && ClassIsChildOf(DamageType, Class'PKDmgType_Rocket'))
    {
        CurrentTime = WorldInfo.TimeSeconds;
        iKilledPawns = 0;
        I = 0;
        J0x69:

        // End:0xE0 [Loop If]
        if(I < KilledPawns.Length)
        {
            // End:0xD2
            if((CurrentTime - PKPawn(KilledPawns[I]).TimeOfDeath) < 0.2000000)
            {
                iKilledPawns++;
            }
            I++;
            // [Loop Continue]
            goto J0x69;
        }
        // End:0xFD
        if(iKilledPawns >= 5)
        {
            ClientUnlockAchievement(38);
        }
    }
    //return;    
}

simulated exec function SetHUDScale(float Scale)
{
    HUDScale = Scale;
    // End:0x97
    if((PKHudWrapper != none) && PainGFxHud(PKHudWrapper.HudMovie) != none)
    {
        PainGFxHud(PKHudWrapper.HudMovie).SetHUDScale(Scale);
    }
    //return;    
}

simulated function DrawHUD(HUD H)
{
    local int PosX, PosY;
    local float DisplayedSpeed;

    super.DrawHUD(H);
    // End:0x2F8
    if((PainGRI(WorldInfo.GRI) != none) && PainGRI(WorldInfo.GRI).GameClass.IsA('PKGameTeamDeathmatch'))
    {
        PosX = 10;
        PosY = 100;
        H.Canvas.Font = Class'Engine.Engine'.static.GetSubtitleFont();
        H.Canvas.SetPos(float(PosX), float(PosY - 20));
        H.Canvas.DrawColor.R = 255;
        H.Canvas.DrawColor.G = 255;
        H.Canvas.DrawColor.B = 255;
        H.Canvas.DrawColor.A = 255;
        H.Canvas.DrawText("Score limit:     " @ string(WorldInfo.GRI.GoalScore));
    }
    // End:0x814
    if(bShowSpeedMeter)
    {
        DisplayedSpeed = ((MyEvilPawn != none) ? VSize2D(MyEvilPawn.Velocity) : 0.0000000);
        // End:0x635
        if(PainGRI(WorldInfo.GRI) != none)
        {
            H.Canvas.SetPos((H.Canvas.ClipX * 0.5000000) - 33.0000000, H.Canvas.ClipY - float(12));
            H.Canvas.SetDrawColor(128, 128, 128, 255);
            H.Canvas.DrawRect(66.0000000, 12.0000000);
            H.Canvas.SetPos((H.Canvas.ClipX * 0.5000000) - 32.0000000, H.Canvas.ClipY - float(11));
            H.Canvas.SetDrawColor(128, 0, 0, 255);
            H.Canvas.DrawRect((64.0000000 * DisplayedSpeed) / class<PKGame>(PainGRI(WorldInfo.GRI).GameClass).default.MaximalBunnyHopSpeed, 10.0000000);
        }
        DisplayedSpeed = 0.0100000 * float(Round(DisplayedSpeed * 100.0000000));
        H.Canvas.SetPos((H.Canvas.ClipX * 0.5000000) - 32.0000000, H.Canvas.ClipY - float(13));
        H.Canvas.SetDrawColor(((PKPlayerPawn(MyEvilPawn).bCanBunnyHop) ? 0 : 255), 255, 0, 255);
        H.Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
        H.Canvas.DrawText(string(DisplayedSpeed / float(14 * 4)));
    }
    //return;    
}

final function UpdateDifficultySetting()
{
    local class<PainDifficultySettings> DiffSettingsClass;
    local PainPRI MyPRI;
    local int ValueId;
    local bool bCanUpdate;

    // End:0x22
    if((ProfileSettings == none) && !IsSecondSplitCoopPlayer())
    {
        return;
    }
    // End:0x2AD
    if((WorldInfo.GRI != none) && !WorldInfo.GRI.IsMultiplayerGame())
    {
        // End:0x162
        if(((PlayerReplicationInfo != none) && ProfileSettings != none) && ProfileSettings.GetProfileSettingValueId(35, ValueId))
        {
            switch(ValueId)
            {
                // End:0xFE
                case 0:
                    DiffSettingsClass = Class'PainDifficultySettings_Daydream';
                    // End:0x153
                    break;
                // End:0x118
                case 1:
                    DiffSettingsClass = Class'PainDifficultySettings_Insomnia';
                    // End:0x153
                    break;
                // End:0x133
                case 2:
                    DiffSettingsClass = Class'PainDifficultySettings_Nightmare';
                    // End:0x153
                    break;
                // End:0x14E
                case 3:
                    DiffSettingsClass = Class'PainDifficultySettings_Trauma';
                    // End:0x153
                    break;
                // End:0xFFFF
                default:
                    return;
                    break;
            }
            bCanUpdate = true;            
        }
        else
        {
            // End:0x232
            if(IsSecondSplitCoopPlayer())
            {
                switch(PKGame(WorldInfo.Game).SplitCoopPlayerDifficulty)
                {
                    // End:0x1D0
                    case 0:
                        DiffSettingsClass = Class'PainDifficultySettings_Daydream';
                        // End:0x226
                        break;
                    // End:0x1EB
                    case 1:
                        DiffSettingsClass = Class'PainDifficultySettings_Insomnia';
                        // End:0x226
                        break;
                    // End:0x206
                    case 2:
                        DiffSettingsClass = Class'PainDifficultySettings_Nightmare';
                        // End:0x226
                        break;
                    // End:0x221
                    case 3:
                        DiffSettingsClass = Class'PainDifficultySettings_Trauma';
                        // End:0x226
                        break;
                    // End:0xFFFF
                    default:
                        return;
                        break;
                }
                bCanUpdate = true;
            }
        }
        MyPRI = PainPRI(PlayerReplicationInfo);
        // End:0x2AD
        if((bCanUpdate && MyPRI != none) && MyPRI.Difficulty != DiffSettingsClass)
        {
            ServerSetDifficulty(DiffSettingsClass);
        }
    }
    //return;    
}

final function SetDifficulty(PKTypes.EDifficultyLevel DifficultyIdx)
{
    // End:0x45
    if(ProfileSettings != none)
    {
        ProfileSettings.SetProfileSettingValueId(35, int(DifficultyIdx));
        UpdateDifficultySetting();
    }
    //return;    
}

reliable server final function ServerSetDifficulty(class<PainDifficultySettings> DiffSettings)
{
    local PainPRI MyPRI, OtherPRI;
    local int I;

    // End:0x297
    if(((WorldInfo.GRI != none) && !WorldInfo.GRI.IsMultiplayerGame()) && !PKGame(WorldInfo.Game).bURLDifficultyOverride)
    {
        MyPRI = PainPRI(PlayerReplicationInfo);
        // End:0x297
        if(MyPRI != none)
        {
            MyPRI.Difficulty = DiffSettings;
            MyPRI.Difficulty.static.ApplyDifficultySettings(self);
            I = 0;
            J0x136:

            // End:0x297 [Loop If]
            if(I < WorldInfo.GRI.PRIArray.Length)
            {
                OtherPRI = PainPRI(WorldInfo.GRI.PRIArray[I]);
                // End:0x289
                if((OtherPRI != none) && AIController(OtherPRI.Owner) != none)
                {
                    OtherPRI.Difficulty = DiffSettings;
                    OtherPRI.Difficulty.static.ApplyDifficultySettings(Controller(OtherPRI.Owner));
                }
                I++;
                // [Loop Continue]
                goto J0x136;
            }
        }
    }
    //return;    
}

function GetDefaultCustomMessages(out array<string> DefaultMessages)
{
    local int I;

    DefaultMessages.Remove(0, DefaultMessages.Length);
    DefaultMessages.Length = 10;
    I = 0;
    J0x2E:

    // End:0xA9 [Loop If]
    if(I < 10)
    {
        DefaultMessages[I] = Localize("PKControllerMessages", "DefaultMsgTxt" $ string(I + 1), "PKHDGame");
        I++;
        // [Loop Continue]
        goto J0x2E;
    }
    //return;    
}

exec function SayCustomMessage(int Index)
{
    // End:0x46
    if(!bCinematicMode && Index < CustomMessages.Length)
    {
        Say(CustomMessages[Index]);
    }
    //return;    
}

exec function StartFire(optional byte FireModeNum)
{
    // End:0xC4
    if(((Pawn != none) && PainWeap_Base(Pawn.Weapon) != none) && PainWeap_Base(Pawn.Weapon).FireModeSwitch)
    {
        // End:0xA4
        if(int(FireModeNum) == int(0))
        {
            FireModeNum = 1;            
        }
        else
        {
            // End:0xC4
            if(int(FireModeNum) == int(1))
            {
                FireModeNum = 0;
            }
        }
    }
    // End:0x114
    if(bFireModeSwitch)
    {
        // End:0xF4
        if(int(FireModeNum) == int(0))
        {
            FireModeNum = 1;            
        }
        else
        {
            // End:0x114
            if(int(FireModeNum) == int(1))
            {
                FireModeNum = 0;
            }
        }
    }
    super.StartFire(FireModeNum);
    //return;    
}

exec function StopFire(optional byte FireModeNum)
{
    // End:0xC4
    if(((Pawn != none) && PainWeap_Base(Pawn.Weapon) != none) && PainWeap_Base(Pawn.Weapon).FireModeSwitch)
    {
        // End:0xA4
        if(int(FireModeNum) == int(0))
        {
            FireModeNum = 1;            
        }
        else
        {
            // End:0xC4
            if(int(FireModeNum) == int(1))
            {
                FireModeNum = 0;
            }
        }
    }
    // End:0x114
    if(bFireModeSwitch)
    {
        // End:0xF4
        if(int(FireModeNum) == int(0))
        {
            FireModeNum = 1;            
        }
        else
        {
            // End:0x114
            if(int(FireModeNum) == int(1))
            {
                FireModeNum = 0;
            }
        }
    }
    super(PlayerController).StopFire(FireModeNum);
    //return;    
}

exec function ChoseCustom1()
{
    // End:0x62
    if(((PKPlayerPawn(Pawn) != none) && !bCinematicMode) && !IsGhost())
    {
        PKPlayerPawn(Pawn).DoQuickCustom1();
    }
    //return;    
}

exec function ChoseCustom2()
{
    // End:0x62
    if(((PKPlayerPawn(Pawn) != none) && !bCinematicMode) && !IsGhost())
    {
        PKPlayerPawn(Pawn).DoQuickCustom2();
    }
    //return;    
}

exec function QuickCustom1Fire(bool bEnable)
{
    // End:0x6C
    if(((PKPlayerPawn(Pawn) != none) && !bCinematicMode) && !IsGhost())
    {
        PKPlayerPawn(Pawn).DoQuickCustom1Fire(bEnable);
    }
    //return;    
}

exec function QuickCustom2Fire(bool bEnable)
{
    // End:0x6C
    if(((PKPlayerPawn(Pawn) != none) && !bCinematicMode) && !IsGhost())
    {
        PKPlayerPawn(Pawn).DoQuickCustom2Fire(bEnable);
    }
    //return;    
}

reliable server function ServerFireModeSwitch()
{
    FireModeSwitch();
    //return;    
}

exec function FireModeSwitch()
{
    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerFireModeSwitch();
    }
    // End:0x80
    if(!bCinematicMode)
    {
        StopFire(0);
        StopFire(1);
        StopFire(2);
        StopFire(3);
        StopFire(4);
        bFireModeSwitch = !bFireModeSwitch;
    }
    //return;    
}

reliable server function ServerToggleFlashlight()
{
    ToggleFlashlight();
    //return;    
}

exec function ToggleFlashlight()
{
    // End:0x20
    if(int(Role) < int(ROLE_Authority))
    {
        ServerToggleFlashlight();
        return;
    }
    // End:0x8E
    if(((PKPlayerPawn(Pawn) != none) && !bCinematicMode) && !IsGhost())
    {
        PKPlayerPawn(Pawn).SetFlashlight(!bFlashlightOn);
    }
    //return;    
}

reliable server function ServerRocketJump(bool bEnable)
{
    RocketJump(bEnable);
    //return;    
}

exec function RocketJump(bool bEnable)
{
    // End:0x28
    if(int(Role) < int(ROLE_Authority))
    {
        ServerRocketJump(bEnable);
    }
    // End:0x94
    if(((PKPlayerPawn(Pawn) != none) && !bCinematicMode) && !IsGhost())
    {
        PKPlayerPawn(Pawn).DoRocketJump(bEnable);
    }
    //return;    
}

reliable server function ServerForwardRocketJump(bool bEnable)
{
    ForwardRocketJump(bEnable);
    //return;    
}

exec function ForwardRocketJump(bool bEnable)
{
    // End:0x73
    if((PainGRI(WorldInfo.GRI) == none) || !PainGRI(WorldInfo.GRI).bForwardRocketJump)
    {
        return;
    }
    // End:0x9B
    if(int(Role) < int(ROLE_Authority))
    {
        ServerForwardRocketJump(bEnable);
    }
    // End:0x107
    if(((PKPlayerPawn(Pawn) != none) && !bCinematicMode) && !IsGhost())
    {
        PKPlayerPawn(Pawn).DoForwardRocketJump(bEnable);
    }
    //return;    
}

simulated function bool IsDemon()
{
    return false;
    //return ReturnValue;    
}

simulated function ToggleBansheeFade(optional bool bUnFade)
{
    local EvilPostProcessManager EPP;
    local int Index;

    EPP = GetPPManager();
    // End:0x292
    if(EPP != none)
    {
        // End:0x14C
        if(!bUnFade)
        {
            // End:0x100
            if(PainGRI(WorldInfo.GRI).BansheeScreamAffectedPawnsList.Find(Pawn) < 0)
            {
                EPP.EnableFade(ColorToLinearColor(MakeColor(byte(0.3500000), byte(0.3500000), byte(0.3500000))), 2.5000000, false, 0.9500000, 0.0000000);
                EPP.EnableBleachBypass(true, 0.5000000);
            }
            PainGRI(WorldInfo.GRI).BansheeScreamAffectedPawnsList.AddItem(Pawn);            
        }
        else
        {
            Index = PainGRI(WorldInfo.GRI).BansheeScreamAffectedPawnsList.Find(Pawn);
            // End:0x1FA
            if(Index > -1)
            {
                PainGRI(WorldInfo.GRI).BansheeScreamAffectedPawnsList.Remove(Index, 1);
            }
            // End:0x292
            if(PainGRI(WorldInfo.GRI).BansheeScreamAffectedPawnsList.Find(Pawn) < 0)
            {
                EPP.Unfade(2.0000000);
                EPP.EnableBleachBypass(false, 1.0000000);
            }
        }
    }
    // End:0x2B5
    if(!IsLocalPlayerController())
    {
        ClientToggleBansheeFade(bUnFade);
    }
    //return;    
}

simulated function ToggleDemon()
{
    // End:0x7F
    if((((MyEvilPawn == none) || MyEvilPawn.Health <= 0) || MyEvilPawn.bDeleteMe) || MyEvilPawn.bPlayedDeath)
    {
        return;
    }
    PushState('Demon');
    // End:0xAC
    if(!IsLocalPlayerController())
    {
        ClientToggleDemon();
    }
    //return;    
}

reliable client simulated function ClientToggleDemon()
{
    ToggleDemon();
    //return;    
}

reliable client simulated function ClientToggleBansheeFade(optional bool bUnFade)
{
    ToggleBansheeFade(bUnFade);
    //return;    
}

function GoldenCardsUseDelay()
{
    //return;    
}

reliable client simulated function ClientPlayResurrectEfect()
{
    local PKPostProcessManager PKPP;

    PKPP = PKPostProcessManager(GetPPManager());
    PKPP.EnableFlash(MakeLinearColor(1.0000000, 1.0000000, 0.0000000, 1.0000000), 0.1000000,, 2.0000000);
    PlaySound(ResurrectSound, true);
    //return;    
}

reliable client simulated function ClientPlayGoldenCardsUseEffects()
{
    // End:0x5E
    if(PainGFxHudWrapper(myHUD) != none)
    {
        PainGFxHud(PainGFxHudWrapper(myHUD).HudMovie).ShowCardsActive();
    }
    PlaySound(CanUseSoundCue);
    bGoldenCardsActiveEffects = true;
    //return;    
}

reliable client simulated function ClientPlayGoldenCardsDeactivateWarningEffects()
{
    // End:0x5F
    if(PainGFxHudWrapper(myHUD) != none)
    {
        PainGFxHud(PainGFxHudWrapper(myHUD).HudMovie).HideCards();
    }
    //return;    
}

reliable client simulated function ClientPlayGoldenCardsDeactivateEffects()
{
    bGoldenCardsActiveEffects = false;
    // End:0x6B
    if(PainGFxHudWrapper(myHUD) != none)
    {
        PainGFxHud(PainGFxHudWrapper(myHUD).HudMovie).HideCards(true);
    }
    //return;    
}

reliable server function ServerDeactivateGoldenCards()
{
    // End:0x42
    if(PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        return;
    }
    PKGame(WorldInfo.Game).DeactivateGoldenCards();
    //return;    
}

reliable server function ServerUseGoldenCards()
{
    local PainGRI GRI;
    local PainPRI PRI;

    GRI = PainGRI(WorldInfo.GRI);
    PRI = PainPRI(PlayerReplicationInfo);
    // End:0x71
    if(GRI.IsMultiplayerGame())
    {
        return;
    }
    // End:0xDC
    if(!GRI.bGoldenCardsUseUnlimited && !PRI.IsLocalPlayerPRI())
    {
        PRI.GoldenCardsUseLeft -= 1;
    }
    PKGame(WorldInfo.Game).UseGoldenCards();
    //return;    
}

reliable client simulated function ClientUseGoldenCards()
{
    local PainGRI GRI;

    GRI = PainGRI(WorldInfo.GRI);
    // End:0x55
    if(GRI.IsMultiplayerGame())
    {
        return;
    }
    UseGoldenCards();
    //return;    
}

exec function UseGoldenCards()
{
    local PainGRI GRI;
    local PainPRI PRI;

    GRI = PainGRI(WorldInfo.GRI);
    PRI = PainPRI(PlayerReplicationInfo);
    // End:0xB4
    if(((((IsTimerActive('GoldenCardsUseDelay') || bGoldenCardsActiveEffects) || bCinematicMode) || IsGhost()) || IsInState('Dead', true)) || GamePlayEndedState())
    {
        return;
    }
    // End:0x189
    if((PRI.GoldenCardsUseLeft < 1) && !GRI.bGoldenCardsUseUnlimited)
    {
        // End:0x15C
        if(PainGFxHudWrapper(myHUD) != none)
        {
            PainGFxHud(PainGFxHudWrapper(myHUD).HudMovie).ShowCardsInactive();
        }
        PlaySound(CantUseSoundCue);
        SetTimer(1.0000000, false, 'GoldenCardsUseDelay');
        return;
    }
    // End:0x1CE
    if(!GRI.bGoldenCardsUseUnlimited)
    {
        PRI.GoldenCardsUseLeft -= 1;
    }
    ServerUseGoldenCards();
    //return;    
}

reliable client simulated function ClientUnlockGoldCard(PKTarotManager.EGoldenTarrotCard InCardId)
{
    local PKAchievements.EPKGameAchievements achievement;
    local PKGame PKG;
    local bool bCanUnlock;

    bCanUnlock = false;
    // End:0x78
    if(PKLocalPlayer(Player) != none)
    {
        bCanUnlock = true;
        // End:0x78
        if((int(InCardId) == int(12)) && !WorldInfo.IsConsoleBuild(2))
        {
            bCanUnlock = false;
        }
    }
    // End:0x89
    if(!bCanUnlock)
    {
        return;
    }
    achievement = Class'PKAchievements'.static.TranslateGoldCardToAchievement(InCardId);
    ClientUnlockAchievement(achievement);
    // End:0x185
    if(ProfileSettings.MarkGoldCardAsUnlocked(InCardId, self))
    {
        PKG = PKGame(WorldInfo.GetWorldInfo().Game);
        // End:0x17B
        if(PKG != none)
        {
            PKG.OnGoldenCardUnlocked(self, InCardId);
        }
        PostUnlockTarotCard();
    }
    //return;    
}

reliable client simulated function ClientUnlockSilverCard(PKTarotManager.ESilverTarrotCard InCardId)
{
    local PKAchievements.EPKGameAchievements achievement;
    local PKGame PKG;
    local bool bCanUnlock;

    bCanUnlock = false;
    // End:0xC0
    if(LocalPlayer(Player) != none)
    {
        bCanUnlock = true;
        // End:0x78
        if((int(InCardId) == int(6)) && WorldInfo.IsConsoleBuild())
        {
            bCanUnlock = false;            
        }
        else
        {
            // End:0xC0
            if((int(InCardId) == int(10)) && !WorldInfo.IsConsoleBuild(1))
            {
                bCanUnlock = false;
            }
        }
    }
    // End:0xD1
    if(!bCanUnlock)
    {
        return;
    }
    achievement = Class'PKAchievements'.static.TranslateSilverCardToAchievement(InCardId);
    ClientUnlockAchievement(achievement);
    // End:0x1CD
    if(ProfileSettings.MarkSilverCardAsUnlocked(InCardId, self))
    {
        PKG = PKGame(WorldInfo.GetWorldInfo().Game);
        // End:0x1C3
        if(PKG != none)
        {
            PKG.OnSilverCardUnlocked(self, InCardId);
        }
        PostUnlockTarotCard();
    }
    //return;    
}

reliable client simulated function ShowSingleSurvivalObjective(int DescriptionIndex)
{
    PainGFxHud(PKHudWrapper.HudMovie).SetObjectiveMessageText(Localize("PKGFxUI_Menu_SurvivalSP", ("SVDescription[" $ string(DescriptionIndex)) $ "]", "PKHDGame"), false);
    //return;    
}

reliable client simulated function ShowSingleSurvivalEndScreen(int Index, bool bCompleted, int InAdditionalScore, int InDescriptionId)
{
    PKHudWrapper.ShowEndSurvivalSPScreen(Index, bCompleted, PlayerReplicationInfo.Kills, InAdditionalScore, InDescriptionId);
    //return;    
}

simulated function PostUnlockTarotCard()
{
    local int GoldMask, SilverMask, GoldUnlockMaskPerPlatform, SilverUnlockMaskPerPlatform;

    GoldMask = ProfileSettings.GetGoldCardUnlockMaskValue();
    SilverMask = ProfileSettings.GetSilverCardUnlockMaskValue();
    GoldUnlockMaskPerPlatform = 8190;
    SilverUnlockMaskPerPlatform = 8190;
    // End:0xCF
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        GoldUnlockMaskPerPlatform = GoldUnlockMaskPerPlatform & ~1 << 12;
        SilverUnlockMaskPerPlatform = SilverUnlockMaskPerPlatform & ~1 << 6;        
    }
    else
    {
        // End:0x12E
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
        {
            SilverUnlockMaskPerPlatform = SilverUnlockMaskPerPlatform & ~1 << 10;
            SilverUnlockMaskPerPlatform = SilverUnlockMaskPerPlatform & ~1 << 6;            
        }
        else
        {
            GoldUnlockMaskPerPlatform = GoldUnlockMaskPerPlatform & ~1 << 12;
            SilverUnlockMaskPerPlatform = SilverUnlockMaskPerPlatform & ~1 << 10;
        }
    }
    // End:0x1A3
    if((GoldMask == GoldUnlockMaskPerPlatform) && SilverMask == SilverUnlockMaskPerPlatform)
    {
        ClientUnlockAchievement(53);
    }
    //return;    
}

function OnUnlockAchievement(SeqAct_UnlockAchievement Action)
{
    ClientUnlockAchievement(Action.AchievementId);
    //return;    
}

reliable client simulated function ClientUnlockAchievement(byte achievement, optional bool bForceSaveProfile = true)
{
    local LocalPlayer LocPlayer;

    // End:0x29
    if((int(achievement) == 0) || !IsPrimaryPlayer())
    {
        return;
    }
    // End:0x64
    if(WorldInfo.IsConsoleBuild() && int(achievement) > int(50))
    {
        return;
    }
    // End:0x93
    if(ProfileSettings.IsAchievementUnlocked(int(achievement)))
    {
        return;
    }
    // End:0x194
    if(OnlineSub != none)
    {
        // End:0x191
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            LocPlayer = LocalPlayer(Player);
            // End:0x18E
            if(OnlineSub.PlayerInterface.UnlockAchievement(byte(LocPlayer.ControllerId), int(achievement)))
            {
                ProfileSettings.MarkAchievementAsUnlocked(int(achievement), self, bForceSaveProfile);                
            }            
        }        
    }
    //return;    
}

function ProcessGameOver()
{
    local PKPlayerController PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        PC.ClientGameOver();        
    }    
    //return;    
}

reliable client simulated event ClientGameOver()
{
    ClearTimer('ProcessGameOver');
    // End:0x54
    if(PainGFxHudWrapper(myHUD) != none)
    {
        PainGFxHudWrapper(myHUD).ShowGameOverMenu();
    }
    //return;    
}

reliable client simulated function ClosePauseMenu()
{
    PainGFxHudWrapper(myHUD).UnPauseGame();
    //return;    
}

reliable client simulated function NotifyGotKill()
{
    AlienwareLightColor.R = 0;
    AlienwareLightColor.G = 255;
    AlienwareLightColor.B = 0;
    AlienwareLightColor.A = 255;
    SetTimer(AlienwareBlinkSpeed, true, 'SwitchAlienwareLight');
    SetTimer(AlienwareBlinkDuration, false, 'ClearSwitchAlienwareLight');
    //return;    
}

reliable client simulated function NotifyWasKilled()
{
    AlienwareLightColor.R = 255;
    AlienwareLightColor.G = 0;
    AlienwareLightColor.B = 0;
    AlienwareLightColor.A = 255;
    SetTimer(AlienwareBlinkSpeed, true, 'SwitchAlienwareLight');
    SetTimer(AlienwareBlinkDuration, false, 'ClearSwitchAlienwareLight');
    //return;    
}

reliable client simulated function EnableGhostEffect()
{
    local PKPostProcessManager PPMgr;

    PPMgr = PKPostProcessManager(GetPPManager());
    // End:0x92
    if(PPMgr != none)
    {
        PPMgr.PushChainOverride(GhostPPChain);
        PPMgr.DemonTransitionFlash();
        PPMgr.EnableGhost();
    }
    //return;    
}

reliable client simulated function DisableGhostEffect()
{
    local PKPostProcessManager PPMgr;

    PPMgr = PKPostProcessManager(GetPPManager());
    // End:0x6A
    if(PPMgr != none)
    {
        PPMgr.PopChainOverride();
        PPMgr.DemonTransitionFlash();
    }
    //return;    
}

function bool IsGhost()
{
    return false;
    //return ReturnValue;    
}

function RespawnInSamePlace()
{
    //return;    
}

function SwitchAlienwareLight()
{
    local EvilEngine Engine;

    // End:0xCA
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x96
        if(bAlienwareLightIsOn)
        {
            Engine.AlienwareTurnOffLights();
            bAlienwareLightIsOn = false;            
        }
        else
        {
            Engine.AlienwareSetLights(AlienwareLightColor);
            bAlienwareLightIsOn = true;
        }
    }
    //return;    
}

function ClearSwitchAlienwareLight()
{
    local EvilEngine Engine;

    // End:0x8E
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        ClearTimer('SwitchAlienwareLight');
        Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
        Engine.AlienwareSetDefaultLights();
    }
    //return;    
}

function TurnOffAlinewareLight()
{
    local EvilEngine Engine;

    // End:0x7A
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
        Engine.AlienwareTurnOffLights();
    }
    //return;    
}

private final simulated function SetDemonMaterialOnMonsters(bool bEnable)
{
    local PKPawn P;

    // End:0xA3
    foreach DynamicActors(Class'PKPawn', P)
    {
        P.SetDemonMaterial(bEnable, P.IsSameTeam(Pawn));
        // End:0xA2
        if(bEnable)
        {
            DemonModeHighlights.AddItem(P.Mesh);
        }        
    }    
    //return;    
}

protected simulated function EnableDemonFX(bool bEnable, optional bool bDemonHUD = true, optional bool bSetDemonMaterialOnMonsters = true)
{
    local PKPostProcessManager PPMgr;

    // End:0x211
    if(bEnable)
    {
        PPMgr = PKPostProcessManager(GetPPManager());
        // End:0x107
        if(PPMgr != none)
        {
            // End:0x72
            if(IsInState('CoopGhost', true))
            {
                PPMgr.PopChainOverride();
            }
            PPMgr.PushChainOverride(((WorldInfo.IsConsoleBuild(1)) ? DemonVisionPPChain_Xbox : DemonVisionPPChain));
            PPMgr.EnableDemonVision();
            PPMgr.DemonTransitionFlash();
        }
        // End:0x11F
        if(bSetDemonMaterialOnMonsters)
        {
            SetDemonMaterialOnMonsters(true);
        }
        bAlienwareLightIsOn = false;
        AlienwareLightColor.R = 255;
        AlienwareLightColor.G = 0;
        AlienwareLightColor.B = 0;
        AlienwareLightColor.A = 255;
        SetTimer(AlienwareBlinkSpeed, true, 'SwitchAlienwareLight');
        // End:0x20E
        if(bDemonHUD && EvilGFxHudWrapper(myHUD) != none)
        {
            EvilGFxHudWrapper(myHUD).HideHUD(true);
        }        
    }
    else
    {
        // End:0x234
        if(bAlienwareLightIsOn)
        {
            TurnOffAlinewareLight();
            bAlienwareLightIsOn = false;
        }
        ClearTimer('SwitchAlienwareLight');
        PPMgr = PKPostProcessManager(GetPPManager());
        // End:0x2B2
        if(PPMgr != none)
        {
            PPMgr.PopChainOverride();
            PPMgr.DemonTransitionFlash();
        }
        // End:0x2CA
        if(bSetDemonMaterialOnMonsters)
        {
            SetDemonMaterialOnMonsters(false);
        }
        // End:0x331
        if(!myHUD.bShowHUD && EvilGFxHudWrapper(myHUD) != none)
        {
            EvilGFxHudWrapper(myHUD).OpenHUD(true);
        }
        DemonModeHighlights.Length = 0;
    }
    //return;    
}

function UpdatePowerUpEffectsFor(PKPawn P)
{
    //return;    
}

protected function BroadcastPowerupLoopSound(name PowerupID, bool bNewEnabled)
{
    local PKPlayerController PC;

    // End:0x30
    if((int(Role) != int(ROLE_Authority)) || PKPlayerPawn(Pawn) == none)
    {
        return;
    }
    // End:0xB8
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        // End:0xB7
        if(PC != self)
        {
            PC.SetPowerupLoopSound(PowerupID, bNewEnabled, PKPlayerPawn(Pawn));
        }        
    }    
    //return;    
}

private reliable client final simulated function SetPowerupLoopSound(name PowerupID, bool bNewEnabled, PKPlayerPawn P)
{
    local editinline AudioComponent AC;
    local SoundCue Cue;

    Cue = GetSoundCueForPowerup(PowerupID);
    // End:0x2E
    if(Cue == none)
    {
        return;
    }
    // End:0xA7
    if(bNewEnabled)
    {
        AC = GetPooledAudioComponent(Cue, P, true);
        AC.bAllowSpatialization = true;
        AC.Play();        
    }
    else
    {
        // End:0x163
        foreach HearSoundActiveComponents(AC)
        {
            // End:0x162
            if((AC.SoundCue == Cue) && AC.Owner == P)
            {
                AC.Stop();
                P.DetachComponent(AC);                
            }
            else
            {                
            }
        }        
    }
    //return;    
}

protected simulated function SoundCue GetSoundCueForPowerup(name PowerupID)
{
    // End:0x36
    if(PowerupID == 'WeaponModifier')
    {
        return Class'PainItemWeaponModifier'.default.ActiveSound;
    }
    return none;
    //return ReturnValue;    
}

simulated function EnableWeaponModifier(optional float SuggestedTimeout = 0.0000000)
{
    local float PowerUpTimeout;

    // End:0xEA
    if(!PainPRI(PlayerReplicationInfo).bHasWeaponModifier)
    {
        PainPRI(PlayerReplicationInfo).bHasWeaponModifier = true;
        EnableWeaponModifierFX(true);
        BroadcastPowerupLoopSound('WeaponModifier', true);
        PowerUpTimeout = GetWeaponModifierTimeout(SuggestedTimeout);
        // End:0xC4
        if(PowerUpTimeout > float(0))
        {
            SetTimer(PowerUpTimeout, false, 'DisableWeaponModifier');
        }
        // End:0xEA
        if(!IsInState('WeaponModifier'))
        {
            PushState('WeaponModifier');
        }
    }
    //return;    
}

simulated function DisableWeaponModifier()
{
    PainPRI(PlayerReplicationInfo).bHasWeaponModifier = false;
    EnableWeaponModifierFX(false);
    BroadcastPowerupLoopSound('WeaponModifier', false);
    ClearTimer('DisableWeaponModifier');
    // End:0x78
    if(IsInState('WeaponModifier'))
    {
        PopState();
    }
    //return;    
}

private final simulated function float GetWeaponModifierTimeout(float SuggestedTimeout)
{
    local float PowerUpTimeout;

    // End:0x27
    if(SuggestedTimeout > float(0))
    {
        PowerUpTimeout = SuggestedTimeout;        
    }
    else
    {
        PowerUpTimeout = 0.0000000;
    }
    return PowerUpTimeout;
    //return ReturnValue;    
}

private reliable client final simulated function EnableWeaponModifierFX(bool bEnable)
{
    // End:0x107
    if(bEnable)
    {
        WeaponModifierAudioLoop = CreateAudioComponent(Class'PainItemWeaponModifier'.default.ActiveSound1p, false, true,,, true);
        // End:0xB4
        if(WeaponModifierAudioLoop != none)
        {
            WeaponModifierAudioLoop.bAllowSpatialization = false;
            WeaponModifierAudioLoop.bAutoDestroy = true;
            WeaponModifierAudioLoop.Play();
        }
        PKPostProcessManager(GetPPManager()).SetWeaponModifier(true);
        // End:0x104
        if(!IsInState('WeaponModifier'))
        {
            PushState('WeaponModifier');
        }        
    }
    else
    {
        // End:0x135
        if(WeaponModifierAudioLoop != none)
        {
            WeaponModifierAudioLoop.Stop();
        }
        PlaySound(Class'PainItemWeaponModifier'.default.TimeoutSound);
        PKPostProcessManager(GetPPManager()).SetWeaponModifier(false);
        // End:0x1A7
        if(IsInState('WeaponModifier'))
        {
            PopState();
        }
    }
    //return;    
}

event PlayerTick(float DeltaTime)
{
    super.PlayerTick(DeltaTime);
    CheckForProfileUpdate();
    //return;    
}

function CheckForProfileUpdate()
{
    // End:0xA4
    if((((bProfileSettingsUpdated && ProfileSettings != none) && ProfileSettings.ProfileSettings.Length > 0) && PainPRI(PlayerReplicationInfo) != none) && PainGRI(WorldInfo.GRI) != none)
    {
        UpdateLocalCacheOfProfileSettings();
        bProfileSettingsUpdated = false;
    }
    //return;    
}

function OnUnlockTarotCard(SeqAct_UnlockTarotCard Action)
{
    // End:0x51
    if(int(Action.GoldenCard) != int(0))
    {
        ClientUnlockGoldCard(Action.GoldenCard);
    }
    // End:0xA2
    if(int(Action.SilverCard) != int(0))
    {
        ClientUnlockSilverCard(Action.SilverCard);
    }
    //return;    
}

simulated function UpdateRotationOnRollercoaster(float DeltaTime)
{
    local Rotator DeltaRot, NewRotation, ViewRotation;
    local Vector X, Y, Z;

    ViewRotation = Rotation;
    // End:0x4E
    if(Pawn != none)
    {
        Pawn.SetDesiredRotation(ViewRotation);
    }
    DeltaRot.Yaw = int(PlayerInput.aTurn);
    DeltaRot.Pitch = int(PlayerInput.aLookUp);
    ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
    SetRotation(ViewRotation);
    ViewShake(DeltaTime);
    GetAxes(MyEvilPawn.ClampedBase.Rotation, X, Y, Z);
    NewRotation = QuatToRotator(QuatProduct(QuatFromAxisAndAngle(Z, float(RailCarRotation.Yaw) * 0.0000959), QuatFromRotator(MyEvilPawn.ClampedBase.Rotation)));
    // End:0x22F
    if(Pawn != none)
    {
        Pawn.FaceRotation(NewRotation, DeltaTime);
    }
    //return;    
}

protected simulated function RegisterStandardPlayerDataStores()
{
    // End:0x11
    if(!IsPrimaryPlayer())
    {
        return;
    }
    super(PlayerController).RegisterStandardPlayerDataStores();
    //return;    
}

function RegisterOnlineDelegates()
{
    local OnlinePlayerInterface PlayerInterface;
    local LocalPlayer LocPlayer;

    // End:0x11
    if(!IsPrimaryPlayer())
    {
        return;
    }
    super(PlayerController).RegisterOnlineDelegates();
    LocPlayer = LocalPlayer(Player);
    // End:0x393
    if((LocPlayer != none) && OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x214
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.AddLoginStatusChangeDelegate(OnLoginStatusChange, byte(LocPlayer.ControllerId));
            PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
            PlayerInterface.AddReadProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileReadComplete);
            PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(LocPlayer.ControllerId), OnPersistentDataReadComplete);
            PlayerInterface.AddWriteProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileWriteComplete);
        }
        // End:0x30C
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
            OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChange);
            OnlineSub.SystemInterface.SetNetworkNotificationPosition(2);
        }
        OnlineSubsystemSteamworks(OnlineSub).AddOnDLCDownloadCompleteDelegate(OnDLCDownloadComplete);
        OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.AddLobbyInviteDelegate(OnLobbyInviteDelegate);
    }
    //return;    
}

function ClearOnlineDelegates()
{
    local OnlinePlayerInterface PlayerInterface;
    local OnlinePlaylistManager PlaylistMan;
    local LocalPlayer LocPlayer;

    // End:0x11
    if(!IsPrimaryPlayer())
    {
        return;
    }
    super(UTPlayerController).ClearOnlineDelegates();
    LocPlayer = LocalPlayer(Player);
    // End:0x481
    if((LocPlayer != none) && OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x214
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.ClearLoginStatusChangeDelegate(OnLoginStatusChange, byte(LocPlayer.ControllerId));
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
            PlayerInterface.ClearReadProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileReadComplete);
            PlayerInterface.ClearReadPlayerStorageCompleteDelegate(byte(LocPlayer.ControllerId), OnPersistentDataReadComplete);
            PlayerInterface.ClearWriteProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), OnProfileWriteComplete);
        }
        // End:0x28F
        if(NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
        {
            OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(ReadLeaderboardStatsComplete);
        }
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
        // End:0x339
        if(PlaylistMan != none)
        {
            PlaylistMan.__OnPlaylistPopulationDataUpdated__Delegate = None;
            PlaylistMan.__OnReadPlaylistComplete__Delegate = None;
        }
        // End:0x3FA
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
            OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChange);
        }
        OnlineSubsystemSteamworks(OnlineSub).ClearOnDLCDownloadCompleteDelegate(OnDLCDownloadComplete);
        OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.ClearLobbyInviteDelegate(OnLobbyInviteDelegate);
    }
    //return;    
}

function UpdateCardsAndGoldStatus(PainGRI PKGRI)
{
    local int I, SilverCardsUnlockMask, GoldCardsUnlockMask;

    GoldCardsUnlockMask = ProfileSettings.GetGoldCardUnlockMaskValue();
    SilverCardsUnlockMask = ProfileSettings.GetSilverCardUnlockMaskValue();
    I = 1;
    J0x5D:

    // End:0xED [Loop If]
    if(I <= 12)
    {
        PKGRI.AvailableCardsGold[I] = (((GoldCardsUnlockMask & (1 << I)) != 0) ? 1 : PKGRI.AvailableCardsGold[I]);
        I++;
        // [Loop Continue]
        goto J0x5D;
    }
    I = 1;
    J0xF8:

    // End:0x188 [Loop If]
    if(I <= 12)
    {
        PKGRI.AvailableCardsSilver[I] = (((SilverCardsUnlockMask & (1 << I)) != 0) ? 1 : PKGRI.AvailableCardsSilver[I]);
        I++;
        // [Loop Continue]
        goto J0xF8;
    }
    PKGRI.AvailableCardsSilver[13] = ((int(IsDLCInstalled(8)) == int(1)) ? 1 : PKGRI.AvailableCardsSilver[13]);
    PKGRI.AvailableCardsSilver[14] = ((int(IsDLCInstalled(9)) == int(1)) ? 1 : PKGRI.AvailableCardsSilver[14]);
    PKGRI.AvailableCardsSilver[15] = ((int(IsDLCInstalled(10)) == int(1)) ? 1 : PKGRI.AvailableCardsSilver[15]);
    PKGRI.AvailableCardsSilver[16] = (((int(IsDLCInstalled(11)) == int(1)) || int(IsDLCInstalled(13)) == int(1)) ? 1 : PKGRI.AvailableCardsSilver[16]);
    PKGRI.AvailableCardsSilver[17] = ((int(IsDLCInstalled(12)) == int(1)) ? 1 : PKGRI.AvailableCardsSilver[17]);
    //return;    
}

reliable server function ServerSetMPCharacter(PainPRI PKPRI, int Idx)
{
    PKPRI.SetupPlayerCharacter(Idx);
    //return;    
}

simulated function SetMPCharacter()
{
    local PainPRI PKPRI;
    local int characterIndex;

    PKPRI = PainPRI(PlayerReplicationInfo);
    // End:0x108
    if((PKPRI != none) && WorldInfo.GRI != none)
    {
        // End:0xF4
        if(WorldInfo.GRI.IsMultiplayerGame())
        {
            characterIndex = GetPlayerCharacterMP();
            // End:0xD8
            if(int(Role) > int(ROLE_Authority))
            {
                PKPRI.SetupPlayerCharacter(characterIndex);
            }
            ServerSetMPCharacter(PKPRI, characterIndex);
        }
        ClearTimer('SetMPCharacter');
    }
    //return;    
}

function UpdateControllerConfig()
{
    local array<byte> CustomWeaponData;
    local array<BindingInfo> KeyBindingData;
    local int BindingHash;
    local PainProfileSettings.EStickConfigOpts CurrentStickScheme;

    // End:0x548
    if(ProfileSettings != none)
    {
        PlayerInput.bInvertMouse = ProfileSettings.GetInvertY();
        PlayerInput.bEnableMouseSmoothing = ProfileSettings.GetMouseSmoothing();
        PlayerInput.SetSensitivity(ProfileSettings.GetMouseSensitivity());
        PKPlayerInput(PlayerInput).SensitivityMultiplier = ProfileSettings.GetSensitivity();
        ForceFeedbackManager.bAllowsForceFeedback = ProfileSettings.GetControllerVibrationOption();
        // End:0x21C
        if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
        {
            ProfileSettings.GetKeyBindings(76, KeyBindingData, BindingHash);
            // End:0x1EB
            if(KeyBindingData.Length == 0)
            {
                PKPlayerInput(PlayerInput).GetDefaultBindingsForPC(KeyBindingData);
            }
            PKPlayerInput(PlayerInput).SetBindingsForPC(KeyBindingData);
        }
        ProfileSettings.GetProfileSettingValueBlob(77, CustomWeaponData);
        // End:0x287
        if(CustomWeaponData.Length == 0)
        {
            PKPlayerInput(PlayerInput).GetDefaultCustom1Weapons(CustomWeaponData);
        }
        QuickActionCustom1 = CustomWeaponData;
        ProfileSettings.GetProfileSettingValueBlob(78, CustomWeaponData);
        // End:0x305
        if(CustomWeaponData.Length == 0)
        {
            PKPlayerInput(PlayerInput).GetDefaultCustom2Weapons(CustomWeaponData);
        }
        QuickActionCustom2 = CustomWeaponData;
        CurrentStickScheme = ProfileSettings.GetStickConfigOption();
        // End:0x43F
        if(int(CurrentStickScheme) == int(0))
        {
            UpdateControllerSettings_Worker('XboxTypeS_LeftX', "GBA_StrafeLeft_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_LeftY', "GBA_MoveForward_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_RightX', "GBA_TurnLeft_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_RightY', "GBA_Look_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_LeftThumbStick', "GBA_Jump_Gamepad");
            UpdateControllerSettings_Worker('XboxTypeS_RightThumbStick', "GBA_Zoom");            
        }
        else
        {
            // End:0x548
            if(int(CurrentStickScheme) == int(2))
            {
                UpdateControllerSettings_Worker('XboxTypeS_LeftX', "GBA_TurnLeft_Gamepad");
                UpdateControllerSettings_Worker('XboxTypeS_LeftY', "GBA_Look_Gamepad_Invert");
                UpdateControllerSettings_Worker('XboxTypeS_RightX', "GBA_StrafeLeft_Gamepad");
                UpdateControllerSettings_Worker('XboxTypeS_RightY', "GBA_MoveForward_Gamepad_Invert");
                UpdateControllerSettings_Worker('XboxTypeS_LeftThumbStick', "GBA_Zoom");
                UpdateControllerSettings_Worker('XboxTypeS_RightThumbStick', "GBA_Jump_Gamepad");
            }
        }
    }
    //return;    
}

private final function UpdateControllerSettings_Worker(name TheName, string TheCommand)
{
    local int BindIndex;

    BindIndex = 0;
    J0x0B:

    // End:0xD4 [Loop If]
    if(BindIndex < PlayerInput.Bindings.Length)
    {
        // End:0xC6
        if(PlayerInput.Bindings[BindIndex].Name == TheName)
        {
            PlayerInput.Bindings[BindIndex].Command = TheCommand;
        }
        ++BindIndex;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function CheckForProfileForSlitscreenPlayer()
{
    local PKPlayerController MainPlayer;
    local PainProfileSettings MainPlayerProfileSettings;

    // End:0x199
    if((ProfileSettings == none) && IsSecondSplitCoopPlayer())
    {
        MainPlayer = PKPlayerController(Class'Engine.Engine'.static.GetEngine().GamePlayers[0].Actor);
        // End:0x199
        if(MainPlayer != none)
        {
            MainPlayerProfileSettings = MainPlayer.ProfileSettings;
            // End:0x199
            if(MainPlayerProfileSettings != none)
            {
                FOV(MainPlayerProfileSettings.GetFOV());
                SetHUDScale(MainPlayerProfileSettings.GetHUDScale());
                GlobalHeadBob = MainPlayerProfileSettings.GetHeadBob();
                GlobalWeaponBobDamping = MainPlayerProfileSettings.GetWeaponBobDamping();
                RefreshPawnParamsFromPC();
                CrosshairIndex = MainPlayerProfileSettings.GetCrosshairType();
            }
        }
    }
    //return;    
}

function OnProfileReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local PainGRI PKGRI;
    local PKLocalPlayer LP;
    local array<string> CustomMsg;

    bHasSigninChanged = false;
    bProfileSettingsUpdated = true;
    SetTimer(0.1000000, true, 'SetMPCharacter');
    ProfileSettings = PainProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
    CheckDLCs();
    LP = PKLocalPlayer(Player);
    // End:0x10C
    if((LP != none) && !LP.bAchievementsMasksResetComplete)
    {
        LP.bAchievementsMasksResetComplete = true;
        ProfileSettings.ResetAchievementsMasks();
    }
    PKGRI = PainGRI(WorldInfo.GRI);
    // End:0x162
    if(PKGRI != none)
    {
        UpdateCardsAndGoldStatus(PKGRI);        
    }
    // End:0x403
    if(bWasSuccessful && ProfileSettings != none)
    {
        ProfileSettings.UpdateControllerSensitivity();
        ProfileSettings.UpdateGearStickConfig();
        // End:0x244
        if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(0))
        {
            ProfileSettings.GetCustomMessages(79, CustomMsg);
            // End:0x231
            if(CustomMsg.Length == 0)
            {
                GetDefaultCustomMessages(CustomMsg);
            }
            CustomMessages = CustomMsg;
        }
        SetAudioGroupVolume('Master', ProfileSettings.GetMasterVolume());
        SetAudioGroupVolume('Music', ProfileSettings.GetMusicVolume());
        SetAudioGroupVolume('SFX', ProfileSettings.GetSFXVolume());
        SetGamma(ProfileSettings.GetGamma());
        SetShowSubtitles(ProfileSettings.GetShowSubtitles());
        FOV(ProfileSettings.GetFOV());
        SetHUDScale(ProfileSettings.GetHUDScale());
        GlobalHeadBob = ProfileSettings.GetHeadBob();
        GlobalWeaponBobDamping = ProfileSettings.GetWeaponBobDamping();
        RefreshPawnParamsFromPC();
        CrosshairIndex = ProfileSettings.GetCrosshairType();
    }
    //return;    
}

exec function SaveCheckpoint(optional name InCheckpointName, optional bool bIsLevelStart)
{
    local EvilEngine Engine;
    local PKLocalPlayer LP;

    // End:0x2A0
    if(((((!IsCoop() && IsPrimaryPlayer()) && Pawn != none) && Pawn.Health > 0) && int(Role) == int(ROLE_Authority)) && (WorldInfo.TimeSeconds - LastCheckpointSaveTime) > 0.5000000)
    {
        EvilGame(WorldInfo.Game).DebugMsg(Localize("PKPlayerController", "CheckpointSavedString" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), 3.0000000);
        Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x2A0
        if(Engine != none)
        {
            LP = PKLocalPlayer(Player);
            // End:0x2A0
            if(LP != none)
            {
                Engine.bShouldWriteCheckpointToDisk = !LP.bWantsToSkipSaves;
                // End:0x237
                if(!WorldInfo.IsConsoleBuild())
                {
                    Engine.bShouldWriteCheckpointToDisk = true;
                }
                // End:0x283
                if(PersistentData != none)
                {
                    Engine.SetCurrentDeviceID(PersistentData.DeviceID);
                }
                SaveCheckpointWorker(bIsLevelStart, InCheckpointName);
            }
        }
    }
    //return;    
}

function NotifyDeviceSelectComplete(bool bWasSuccessful)
{
    local int DeviceID;
    local string DeviceName;
    local OnlinePlayerInterfaceEx PlayerInterfaceEx;

    // End:0x12A
    if(bWasSuccessful && ProfileSettings != none)
    {
        // End:0x12A
        if(OnlineSub != none)
        {
            PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;
            // End:0x12A
            if(NotEqual_InterfaceInterface(PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
            {
                DeviceID = PlayerInterfaceEx.GetDeviceSelectionResults(byte(LocalPlayer(Player).ControllerId), DeviceName);
                SetDeviceId(DeviceID);
                PKEngine(Player.Outer).SetCurrentDeviceID(DeviceID);
            }
        }
    }
    //return;    
}

exec function UpdateLocalCacheOfProfileSettings()
{
    local int PlayerIndex;

    UpdateControllerConfig();
    PlayerIndex = GetUIPlayerIndex();
    // End:0xFA
    if((PlayerIndex == 0) && OnlineSub != none)
    {
        // End:0xFA
        if(LocalPlayer(Player) != none)
        {
            // End:0xBB
            if(Class'Engine.WorldInfo'.static.IsMenuLevel())
            {
                LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(0);                
            }
            else
            {
                LocalPlayer(Player).ViewportClient.SetSplitscreenConfiguration(2);
            }
        }
    }
    //return;    
}

function int GetDeviceId()
{
    // End:0x2E
    if(PersistentData != none)
    {
        return PersistentData.DeviceID;
    }
    return -1;
    //return ReturnValue;    
}

function SetDeviceId(int DeviceID)
{
    // End:0x37
    if(PersistentData != none)
    {
        PersistentData.DeviceID = DeviceID;
    }
    //return;    
}

function bool IsStorageDeviceValid()
{
    // End:0x27
    if(!WorldInfo.IsConsoleBuild())
    {
        return true;
    }
    // End:0x9D
    if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        return OnlineSub.PlayerInterfaceEx.IsDeviceValid(GetDeviceId());
    }
    return true;
    //return ReturnValue;    
}

function OnPersistentDataReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local int I;
    local LevelStatistics tmpLs;
    local PainGRI GRI;
    local PainPRI PRI;

    PersistentData = PKPlayerPersistentData(OnlinePlayerData.StorageProvider.Profile);
    bPersistentDataReadComplete = true;
    CachedLevelStatistics.Length = 41;
    CachedCOOPLevelStatistics.Length = 41;
    I = 0;
    J0x77:

    // End:0x137 [Loop If]
    if(I < 41)
    {
        PersistentData.ReadEndLevelStatistics(byte(I), tmpLs, false);
        CachedLevelStatistics[I] = tmpLs;
        PersistentData.ReadEndLevelStatistics(byte(I), tmpLs, true);
        CachedCOOPLevelStatistics[I] = tmpLs;
        I++;
        // [Loop Continue]
        goto J0x77;
    }
    // End:0x3E1
    if(PKGame(WorldInfo.Game) != none)
    {
        GRI = PKGame(WorldInfo.Game).GetGRI();
        PRI = PainPRI(PlayerReplicationInfo);
        // End:0x377
        if((GRI != none) && IsPrimaryPlayer())
        {
            GRI.SelectedGoldCards[0] = byte(PersistentData.GetValue(37));
            GRI.SelectedGoldCards[1] = byte(PersistentData.GetValue(38));
            GRI.SelectedGoldCards[2] = byte(PersistentData.GetValue(39));
            GRI.SelectedSilverCards[0] = byte(PersistentData.GetValue(45));
            GRI.SelectedSilverCards[1] = byte(PersistentData.GetValue(46));
            PKGame(WorldInfo.Game).ApplyCards();
        }
        // End:0x3E1
        if(PRI != none)
        {
            PRI.GoldenCardsUseLeft = PKGame(WorldInfo.Game).GoldenCardsUseLeft;
        }
    }
    //return;    
}

function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
    //return;    
}

function bool IsOnTitleScreen()
{
    local PainGFxMenuHudWrapper MenuHUD;

    MenuHUD = PainGFxMenuHudWrapper(myHUD);
    return ((MenuHUD != none) && MenuHUD.FrontEnd != none) && MenuHUD.FrontEnd.bOnTitleScreen;
    //return ReturnValue;    
}

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    // End:0x37
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.SetUniqueId(NewId);
    }
    //return;    
}

function ShowOSSConnectionLostMessage()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericAccept');
    PKUIManager(Class'Engine.UIManager'.static.GetUIManager()).ShowUIMessage('ConfirmNetworkLost', Localize("MessageBoxErrorStrings", "XboxLive_Title" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), Localize("MessageBoxErrorStrings", "LostLiveConnection_Message" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), ButtonAliases, None,,,,, false, false);
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    local LocalPlayer GLP;
    local UniqueNetId NetId;
    local string GamerTag;

    // End:0x2EB
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        GLP = LocalPlayer(Player);
        // End:0x22F
        if((GLP != none) && GLP.ControllerId == int(LocalUserNum))
        {
            bHasSigninChanged = true;
            OnlineSub.PlayerInterface.GetUniquePlayerId(byte(GLP.ControllerId), NetId);
            PlayerReplicationInfo.SetUniqueId(NetId);
            GamerTag = OnlineSub.PlayerInterface.GetPlayerNickname(byte(GLP.ControllerId));
            // End:0x1CD
            if(GamerTag != "")
            {
                PlayerReplicationInfo.SetPlayerName(GamerTag);                
            }
            else
            {
                PlayerReplicationInfo.SetPlayerName(Class'PKGame'.default.DefaultPlayerName @ string(GLP.ControllerId + 1));
            }
        }
        // End:0x2E1
        if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
        {
            OnPersistentDataReadComplete(LocalUserNum, true);
            OnProfileReadComplete(LocalUserNum, true);
            // End:0x2DE
            if(int(WorldInfo.NetMode) == int(NM_Client))
            {
                ShowLoginChangeError();
                ReturnToMainMenu(true);
            }            
        }
        else
        {
            OnNewLogin();
        }
    }
    //return;    
}

function OnNewLogin()
{
    ShowLoginChangeError();
    //return;    
}

function OnLinkStatusChange(bool bIsConnected)
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local PKLocalPlayer LP;
    local PainGRI GRI;

    GRI = PainGRI(WorldInfo.GRI);
    LP = PKLocalPlayer(Player);
    // End:0x228
    if((LP != none) && LP.bHasSeenStartScreen)
    {
        // End:0x228
        if(!bIsConnected && GRI.IsMultiplayerGame() || GRI.IsCoopMultiplayerGame() && int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0x228
            if(UIManager != none)
            {
                ButtonAliases.AddItem('GenericAccept');
                UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "PKHDGame"), Localize("MessageBoxErrorStrings", "LostLink_Message", "PKHDGame"), ButtonAliases, None,,,,, false, false);
                ReturnToMainMenu(true);
            }
        }
    }
    //return;    
}

final function ShowLoginChangeError()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local PKLocalPlayer LP;

    LP = PKLocalPlayer(Player);
    // End:0x1B1
    if((LP != none) && LP.bHasSeenStartScreen)
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x1B1
        if(UIManager != none)
        {
            UIManager.CloseAllUIMessageBoxes(LP);
            ButtonAliases.AddItem('GenericAccept');
            UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "IllegalSigninChange_Title", "PKHDGame"), Localize("MessageBoxErrorStrings", "IllegalSigninChange_Message", "PKHDGame"), ButtonAliases, None, LP,,,, false, false);
        }
    }
    //return;    
}

reliable client simulated event ClientWasKicked()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x132
    if(IsPrimaryPlayer())
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x132
        if(UIManager != none)
        {
            ButtonAliases.AddItem('GenericAccept');
            UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "PKHDGame"), Localize("MessageBoxStrings", "AFKKicked_Desc", "PKHDGame"), ButtonAliases, None, LocalPlayer(Player),,,, false, false);
        }
    }
    //return;    
}

protected simulated function RegisterCustomPlayerDataStores()
{
    local LocalPlayer LP;

    // End:0x11
    if(!IsPrimaryPlayer())
    {
        return;
    }
    // End:0x2A
    if(ProfileSettings != none)
    {
        UnregisterPlayerDataStores();
    }
    LP = LocalPlayer(Player);
    super(UTPlayerController).RegisterCustomPlayerDataStores();
    // End:0x119
    if(LP != none)
    {
        ProfileSettings = PainProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
        // End:0xD3
        if(OnlineSub == none)
        {
            ProfileSettings.SetToDefaults();
        }
        PersistentData = PKPlayerPersistentData(OnlinePlayerData.StorageProvider.Profile);
    }
    //return;    
}

simulated function UnregisterPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;

    LP = LocalPlayer(Player);
    // End:0xC6
    if(LP != none)
    {
        ProfileSettings = none;
        PersistentData = none;
        DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
        // End:0xC6
        if(DataStoreManager != none)
        {
            // End:0xC3
            if(BoundEventsStringDataStore != none)
            {
                // End:0xB5
                if(!DataStoreManager.UnregisterDataStore(BoundEventsStringDataStore))
                {
                }
                BoundEventsStringDataStore = none;                
            }            
        }
    }
    super(UTPlayerController).UnregisterPlayerDataStores();
    //return;    
}

reliable client simulated function ClientSaveAllPlayerData(optional bool bShouldForce, optional bool bSkipCacheUpdate)
{
    // End:0x2D
    if(IsPrimaryPlayer())
    {
        super.ClientSaveAllPlayerData(bShouldForce, bSkipCacheUpdate);
    }
    //return;    
}

protected function SaveProfile()
{
    local int ControllerId;

    ControllerId = LocalPlayer(Player).ControllerId;
    // End:0xE2
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        // End:0xE2
        if(ControllerId != -1)
        {
            // End:0xE2
            if(!bHasSigninChanged)
            {
                OnlineSub.PlayerInterface.WriteProfileSettings(byte(ControllerId), ProfileSettings);
            }
        }
    }
    //return;    
}

protected function SavePersistentData()
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    ControllerId = LocalPlayer(Player).ControllerId;
    // End:0xFE
    if((OnlineSub != none) && PersistentData != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0xFE
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            // End:0xFE
            if(ControllerId != -1)
            {
                PlayerInt.WritePlayerStorage(byte(ControllerId), PersistentData, PersistentData.DeviceID);
            }
        }
    }
    //return;    
}

function SetGold(int goldAmount)
{
    ProfileSettings.SetProfileSettingValueInt(106, goldAmount);
    //return;    
}

function SetDynamicLightSettings(int val)
{
    // End:0x2F
    if(!ProfileSettings.SetProfileSettingValueInt(61, val))
    {
    }
    //return;    
}

function int GetDynamicLightSettings()
{
    local int Retval;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(61, Retval))
    {
    }
    return Retval;
    //return ReturnValue;    
}

function bool CanReadProfileMP()
{
    local int Retval;

    // End:0x31
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function int GetPlayerCharacterMP()
{
    local int Retval;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(62, Retval))
    {
    }
    return Retval;
    //return ReturnValue;    
}

function SetPlayerCharacterMP(int val)
{
    // End:0x2F
    if(!ProfileSettings.SetProfileSettingValueInt(62, val))
    {
    }
    //return;    
}

function string GetStringValueMP(int dataID)
{
    local string Retval;

    // End:0x37
    if(!ProfileSettings.GetProfileSettingValue(dataID, Retval))
    {
    }
    return Retval;
    //return ReturnValue;    
}

function SetStringValueMP(int dataID, string val)
{
    // End:0x36
    if(!ProfileSettings.SetProfileSettingValue(dataID, val))
    {
    }
    //return;    
}

function int GetIntValueMP(int dataID)
{
    local int Retval;

    // End:0x36
    if(!ProfileSettings.GetProfileSettingValueInt(dataID, Retval))
    {
    }
    return Retval;
    //return ReturnValue;    
}

function SetIntValueMP(int dataID, int val)
{
    // End:0x36
    if(!ProfileSettings.SetProfileSettingValueInt(dataID, val))
    {
    }
    //return;    
}

function bool GetPublicGameMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 0)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetTeamDamageMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 1)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetWeaponStayMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 2)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetPowerupsMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 3)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetPowerupsDropMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 4)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetAllowBunnyMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 5)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetBrightskinMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 6)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function bool GetRocketJumpMP()
{
    local int Retval;
    local bool retFlag;

    // End:0x2F
    if(!ProfileSettings.GetProfileSettingValueInt(74, Retval))
    {
    }
    retFlag = (Retval & (1 << 7)) != 0;
    return retFlag;
    //return ReturnValue;    
}

function SetFlagsMP(bool PublicGameMP, bool TeamDamageMP, bool WeaponStayMP, bool PowerupsMP, bool PowerupsDropMP, bool AllowBunnyMP, bool BrightskinMP, bool RocketJumpMP)
{
    local int val;

    val = 0;
    // End:0x31
    if(PublicGameMP)
    {
        val = val | (1 << 0);
    }
    // End:0x57
    if(TeamDamageMP)
    {
        val = val | (1 << 1);
    }
    // End:0x7E
    if(WeaponStayMP)
    {
        val = val | (1 << 2);
    }
    // End:0xA5
    if(PowerupsMP)
    {
        val = val | (1 << 3);
    }
    // End:0xCC
    if(PowerupsDropMP)
    {
        val = val | (1 << 4);
    }
    // End:0xF3
    if(AllowBunnyMP)
    {
        val = val | (1 << 5);
    }
    // End:0x11A
    if(BrightskinMP)
    {
        val = val | (1 << 6);
    }
    // End:0x141
    if(RocketJumpMP)
    {
        val = val | (1 << 7);
    }
    // End:0x170
    if(!ProfileSettings.SetProfileSettingValueInt(74, val))
    {
    }
    //return;    
}

simulated function GetMySingleLadderStats(out int HitScore, out int GibScore, out int GoldScore, out int SoulScore, out int BunnyScore, out int DemonScore, out int TotalScore)
{
    local int GlobalKills, GlobalKillsInDemon, GlobalGold, GlobalBunnyTime;
    local float GlobalHitRatio;

    GlobalKills = GetGlobalKills();
    GlobalKillsInDemon = GetKillsInDemonMode();
    GlobalGold = GetGlobalGold();
    GlobalHitRatio = GetGlobalHitRatio();
    GlobalBunnyTime = GetGlobalBunnyTime();
    HitScore = int(GlobalHitRatio * float(GlobalKills));
    GibScore = int((GetGlobalGibRatio()) * float(GlobalKills));
    GoldScore = GlobalGold;
    SoulScore = GetGlobalSoul();
    BunnyScore = (GlobalBunnyTime * (GetKillsWhenBunnyHop())) / 10;
    DemonScore = GlobalKillsInDemon;
    TotalScore = ((((HitScore + GibScore) + GoldScore) + SoulScore) + BunnyScore) + DemonScore;
    //return;    
}

reliable client simulated function ClientShowEndStatisticsScreen()
{
    //return;    
}

simulated function UnlockTrauma()
{
    ProfileSettings.SetProfileSettingValueInt(105, 1);
    //return;    
}

simulated function bool IsTraumaUnlocked()
{
    local int Value;

    ProfileSettings.GetProfileSettingValueInt(105, Value);
    return Value == 1;
    //return ReturnValue;    
}

static simulated function PKTypes.ELevelID ComputeNextLevelIDForCurrentLevel(PKTypes.ELevelID inLevelID)
{
    local PKTypes.ELevelID NextLevelID;

    switch(inLevelID)
    {
        // End:0x27
        case 17:
            NextLevelID = 19;
            // End:0x2C5
            break;
        // End:0x3B
        case 19:
            NextLevelID = 1;
            // End:0x2C5
            break;
        // End:0x4F
        case 1:
            NextLevelID = 2;
            // End:0x2C5
            break;
        // End:0x63
        case 2:
            NextLevelID = 3;
            // End:0x2C5
            break;
        // End:0x77
        case 3:
            NextLevelID = 4;
            // End:0x2C5
            break;
        // End:0x8B
        case 4:
            NextLevelID = 5;
            // End:0x2C5
            break;
        // End:0x9F
        case 5:
            NextLevelID = 6;
            // End:0x2C5
            break;
        // End:0xB3
        case 6:
            NextLevelID = 7;
            // End:0x2C5
            break;
        // End:0xC7
        case 7:
            NextLevelID = 8;
            // End:0x2C5
            break;
        // End:0xDB
        case 8:
            NextLevelID = 9;
            // End:0x2C5
            break;
        // End:0xEF
        case 9:
            NextLevelID = 10;
            // End:0x2C5
            break;
        // End:0x103
        case 10:
            NextLevelID = 11;
            // End:0x2C5
            break;
        // End:0x117
        case 11:
            NextLevelID = 12;
            // End:0x2C5
            break;
        // End:0x12B
        case 12:
            NextLevelID = 13;
            // End:0x2C5
            break;
        // End:0x13F
        case 13:
            NextLevelID = 18;
            // End:0x2C5
            break;
        // End:0x153
        case 22:
            NextLevelID = 23;
            // End:0x2C5
            break;
        // End:0x167
        case 23:
            NextLevelID = 24;
            // End:0x2C5
            break;
        // End:0x17B
        case 24:
            NextLevelID = 0;
            // End:0x2C5
            break;
        // End:0x18F
        case 25:
            NextLevelID = 26;
            // End:0x2C5
            break;
        // End:0x1A3
        case 26:
            NextLevelID = 27;
            // End:0x2C5
            break;
        // End:0x1B7
        case 27:
            NextLevelID = 0;
            // End:0x2C5
            break;
        // End:0x1CB
        case 28:
            NextLevelID = 29;
            // End:0x2C5
            break;
        // End:0x1DF
        case 29:
            NextLevelID = 30;
            // End:0x2C5
            break;
        // End:0x1F3
        case 30:
            NextLevelID = 31;
            // End:0x2C5
            break;
        // End:0x207
        case 31:
            NextLevelID = 32;
            // End:0x2C5
            break;
        // End:0x21B
        case 32:
            NextLevelID = 0;
            // End:0x2C5
            break;
        // End:0x22F
        case 33:
            NextLevelID = 34;
            // End:0x2C5
            break;
        // End:0x243
        case 34:
            NextLevelID = 35;
            // End:0x2C5
            break;
        // End:0x257
        case 35:
            NextLevelID = 0;
            // End:0x2C5
            break;
        // End:0x26B
        case 36:
            NextLevelID = 37;
            // End:0x2C5
            break;
        // End:0x27F
        case 37:
            NextLevelID = 38;
            // End:0x2C5
            break;
        // End:0x293
        case 38:
            NextLevelID = 0;
            // End:0x2C5
            break;
        // End:0x298
        case 18:
        // End:0x29D
        case 14:
        // End:0x2A2
        case 15:
        // End:0x2A7
        case 16:
        // End:0x2AC
        case 20:
        // End:0x2B1
        case 21:
        // End:0x2B6
        case 39:
        // End:0xFFFF
        default:
            NextLevelID = 0;
            break;
    }
    return NextLevelID;
    //return ReturnValue;    
}

simulated function bool CheckChapterCompletion(int Chapter)
{
    local int LevelCampaignUnlockMask;

    LevelCampaignUnlockMask = ProfileSettings.GetLevelsUnlockedMaskValueForAchiev() | ProfileSettings.GetCOOPLevelsUnlockedMaskValueForAchiev();
    // End:0x113
    if(Chapter == 1)
    {
        return ((Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 1) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 2)) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 3)) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 4);        
    }
    else
    {
        // End:0x1AF
        if(Chapter == 2)
        {
            return (Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 5) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 6)) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 7);            
        }
        else
        {
            // End:0x24B
            if(Chapter == 3)
            {
                return (Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 8) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 9)) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 10);                
            }
            else
            {
                // End:0x2E4
                if(Chapter == 4)
                {
                    return (Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 11) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 12)) && Class'PainProfileSettings'.static.BitIsSet(LevelCampaignUnlockMask, 13);
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

reliable client simulated function WriteEndLevelStatistics(PKTypes.ELevelID inLevelID, bool bIsCoop)
{
    local LevelStatistics ls;
    local int I, CoopBitCounter, CoopCompletedLevels;
    local PainPRI PRI;
    local PainGRI PGRI;

    PRI = PainPRI(PlayerReplicationInfo);
    PGRI = PainGRI(WorldInfo.GRI);
    // End:0x5E
    if(!IsPrimaryPlayer())
    {
        return;
    }
    PRI.CopyLevelStatsToLevelStatsStruct(ls);
    // End:0x10F
    if(!bIsCoop)
    {
        PersistentData.MarkLevelAsCompleted(inLevelID);
        // End:0xF9
        if(int(inLevelID) < int(21))
        {
            ProfileSettings.MarkLevelAsCompletedForAchiev(inLevelID);
        }
        SetLastCompletedLevelID(inLevelID);        
    }
    else
    {
        PersistentData.MarkCOOPLevelAsCompleted(inLevelID);
        // End:0x173
        if(int(inLevelID) < int(21))
        {
            ProfileSettings.MarkCOOPLevelAsCompletedForAchiev(inLevelID);
        }
    }
    PGRI.NextLevelID = ComputeNextLevelIDForCurrentLevel(inLevelID);
    // End:0x1D4
    if(bIsCoop)
    {
        CachedCOOPLevelStatistics[int(inLevelID)] = ls;        
    }
    else
    {
        CachedLevelStatistics[int(inLevelID)] = ls;
    }
    // End:0x277
    if(((int(inLevelID) != int(17)) && int(inLevelID) != int(19)) && int(inLevelID) != int(18))
    {
        PersistentData.WriteEndLevelStatistics(inLevelID, ls, PRI, IsCoop());
    }
    ProfileSettings.SetGold(ProfileSettings.GetGold() + PRI.PlayerMoneyFound);
    // End:0x3A5
    if((bIsCoop && int(inLevelID) >= int(1)) && int(inLevelID) <= int(13))
    {
        CoopCompletedLevels = ProfileSettings.GetCOOPLevelsUnlockedMaskValueForAchiev();
        I = 1;
        J0x342:

        // End:0x388 [Loop If]
        if(I < 41)
        {
            // End:0x37A
            if((CoopCompletedLevels & (1 << I)) != 0)
            {
                CoopBitCounter++;
            }
            I++;
            // [Loop Continue]
            goto J0x342;
        }
        // End:0x3A5
        if(CoopBitCounter >= 10)
        {
            ClientUnlockAchievement(34, false);
        }
    }
    // End:0x413
    if((!PGRI.IsMultiplayerGame() && !PGRI.IsTeamMultiPlayerGame()) && int(inLevelID) != int(18))
    {
        IncrementGlobalIntStat(139,, false);
    }
    // End:0x42E
    if(CheckChapterCompletion(1))
    {
        ClientUnlockAchievement(29, false);
    }
    // End:0x44A
    if(CheckChapterCompletion(2))
    {
        ClientUnlockAchievement(30, false);
    }
    // End:0x466
    if(CheckChapterCompletion(3))
    {
        ClientUnlockAchievement(31, false);
    }
    // End:0x557
    if(PGRI.IsPureSinglePlayerGame())
    {
        IncrementGlobalIntStat(114, ls.GoldFound, false);
        IncrementGlobalIntStat(115, ls.SecretsFound, false);
        // End:0x50C
        if(!bPlayerGotSomeDamage && int(inLevelID) != int(17))
        {
            ClientUnlockAchievement(51, false);
        }
        // End:0x557
        if(((StakeGunShots > 0) && StakeGunShots == CurrentLevelShotsCount) && int(inLevelID) != int(17))
        {
            ClientUnlockAchievement(44, false);
        }
    }
    // End:0x5B4
    if((((GetLevelHitRatio()) > 0.9000000) && !PGRI.IsMultiplayerGame()) && int(inLevelID) != int(17))
    {
        ClientUnlockAchievement(66, false);
    }
    // End:0x639
    if((int(PRI.Difficulty.default.DifficultyLevel) == int(2)) && int(PersistentData.GetLowestDifficultyLevelFromCompletedLevels(false)) >= int(2))
    {
        ClientUnlockAchievement(41, false);
        UnlockTrauma();        
    }
    else
    {
        // End:0x6C8
        if((int(PRI.Difficulty.default.DifficultyLevel) == int(3)) && int(PersistentData.GetLowestDifficultyLevelFromCompletedLevels(false)) == int(3))
        {
            ClientUnlockAchievement(42, false);
            ClientUnlockAchievement(41, false);
            UnlockTrauma();
        }
    }
    // End:0x710
    if((int(inLevelID) == int(20)) && !WorldInfo.IsConsoleBuild())
    {
        ClientUnlockAchievement(67, false);
    }
    // End:0x758
    if((int(inLevelID) == int(21)) && !WorldInfo.IsConsoleBuild())
    {
        ClientUnlockAchievement(68, false);
    }
    // End:0x7A0
    if((int(inLevelID) == int(39)) && !WorldInfo.IsConsoleBuild())
    {
        ClientUnlockAchievement(79, false);
    }
    // End:0x7C1
    if(int(inLevelID) == int(40))
    {
        ClientUnlockAchievement(80, false);
    }
    // End:0x7E5
    if(int(inLevelID) == int(28))
    {
        ClientUnlockAchievement(96, false);        
    }
    else
    {
        // End:0x809
        if(int(inLevelID) == int(29))
        {
            ClientUnlockAchievement(97, false);            
        }
        else
        {
            // End:0x82D
            if(int(inLevelID) == int(30))
            {
                ClientUnlockAchievement(98, false);                
            }
            else
            {
                // End:0x851
                if(int(inLevelID) == int(31))
                {
                    ClientUnlockAchievement(99, false);                    
                }
                else
                {
                    // End:0x872
                    if(int(inLevelID) == int(32))
                    {
                        ClientUnlockAchievement(100, false);
                    }
                }
            }
        }
    }
    PostUnlockTarotCard();
    ClientWriteLeaderboardSingleStats();
    CommitGlobalIntStat();
    ClientSaveAllPlayerData(true);
    //return;    
}

simulated function ReadEndLevelStatistics(PKTypes.ELevelID inLevelID, out LevelStatistics ls, bool bIsCoop)
{
    // End:0x2F
    if(bIsCoop)
    {
        ls = CachedCOOPLevelStatistics[int(inLevelID)];        
    }
    else
    {
        ls = CachedLevelStatistics[int(inLevelID)];
    }
    //return;    
}

reliable client simulated function WriteEndGameInformations()
{
    //return;    
}

simulated function PKTypes.ELevelID GetLastCompletedLevelID()
{
    return byte(PersistentData.GetLastCompletedLevel());
    //return ReturnValue;    
}

reliable client simulated function SetLastCompletedLevelID(PKTypes.ELevelID inLevelID)
{
    PersistentData.SetLastCompletedLevel(inLevelID);
    //return;    
}

function DeleteSaveGame(int InControllerID, int InDeviceId)
{
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x10A
    if(WorldInfo.IsConsoleBuild())
    {
        // End:0x107
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.DeleteSaveGame(byte(InControllerID), InDeviceId, Class'EvilGame.Checkpoint'.default.DisplayName, "PKCheckpoint");
        }        
    }
    else
    {
        // End:0x1CA
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.DeleteSaveGame(byte(InControllerID), InDeviceId, Class'EvilGame.Checkpoint'.default.DisplayName, "PKCheckpoint0.sav");
        }
    }
    //return;    
}

simulated function ClearPlayerProfileOnSignThePact()
{
    local LevelStatistics tmpLs;
    local PKLocalPlayer LP;
    local int I;

    LP = PKLocalPlayer(Player);
    DeleteSaveGame(LP.ControllerId, GetDeviceId());
    PersistentData.ClearDataOnSignThePact();
    ProfileSettings.ClearDataOnSignThePact();
    I = 0;
    J0x97:

    // End:0x157 [Loop If]
    if(I < 41)
    {
        PersistentData.ReadEndLevelStatistics(byte(I), tmpLs, false);
        CachedLevelStatistics[I] = tmpLs;
        PersistentData.ReadEndLevelStatistics(byte(I), tmpLs, true);
        CachedCOOPLevelStatistics[I] = tmpLs;
        I++;
        // [Loop Continue]
        goto J0x97;
    }
    //return;    
}

function OnDestroyDestructibleObject(EvilDestructibleObject O)
{
    local PainPRI PRI;

    PRI = PainPRI(PlayerReplicationInfo);
    // End:0x4A
    if(PRI != none)
    {
        PRI.ScoreDestroyedObject();
    }
    //return;    
}

function OnDestroyDynamicDestructibleObject(EvilDynamicDestructibleObject O)
{
    local PainPRI PRI;

    PRI = PainPRI(PlayerReplicationInfo);
    // End:0x4A
    if(PRI != none)
    {
        PRI.ScoreDestroyedObject();
    }
    // End:0xCB
    if((O.DamageMods.Length > 0) && O.DamageMods[0].ExploMod.ExplosionTemplate != none)
    {
        IncrementGlobalIntStat(118, 1);
    }
    //return;    
}

reliable client simulated function ClientAttachStakeToPawn(EvilPawn P, name BoneName, Vector HitLocation, Rotator ProjRotation, StaticMesh MeshToAttach)
{
    local editinline EvilDissolvingStaticMeshComponent SMC;
    local Rotator boneSpaceRot;
    local Vector boneSpacePos, ApplyImpulse;
    local float relScale;
    local Vector relScaleVector, ForceVector;

    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    P.Mesh.TransformToBoneSpace(BoneName, HitLocation, ProjRotation, boneSpacePos, boneSpaceRot);
    relScale = 1.0000000 / P.Mesh.Scale;
    relScaleVector.X = relScale;
    relScaleVector.Y = relScale;
    relScaleVector.Z = relScale;
    SMC = new (P) Class'EvilGame.EvilDissolvingStaticMeshComponent';
    SMC.SetStaticMesh(MeshToAttach);
    SMC.SetScale(0.0400000);
    SMC.SetLightEnvironment(P.LightEnvironment);
    P.Mesh.AttachComponent(SMC, BoneName, boneSpacePos, boneSpaceRot, relScaleVector);
    SMC.SetupDissolving();
    SMC.StartDissolving();
    // End:0x32B
    if(PKPawn(P).bPinned)
    {
        ForceVector = Vector(boneSpaceRot) * float(800);
        P.Mesh.AddImpulse(ForceVector, vect(0.0000000, 0.0000000, 0.0000000), BoneName, true);        
    }
    else
    {
        ApplyImpulse = Vector(ProjRotation) * Class'PKDmgType_Stake'.default.KDeathVel;
        ApplyImpulse.Z = RandRange(1.0000000, Class'PKDmgType_Stake'.default.KDeathUpKick);
        P.Mesh.AddImpulse(ApplyImpulse, HitLocation, BoneName, false);
    }
    //return;    
}

reliable client simulated function ClientCreateStakeVirtualProjectile(Vector InHitLocation, Vector InVelocity, Controller StakeOwner)
{
    local PKStakeVirtualProjectile SVP;

    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    SVP = Spawn(Class'PKStakeVirtualProjectile',,, InHitLocation, Rotator(InVelocity),, true);
    SVP.SetInitialVelocity(InVelocity, StakeOwner);
    //return;    
}

function OnSoulTaken()
{
    //return;    
}

exec function SpeedMeter()
{
    bShowSpeedMeter = !bShowSpeedMeter;
    //return;    
}

exec function CoopGhostMatOn()
{
    PKPlayerPawn(MyEvilPawn).SetGhostMaterial();
    //return;    
}

exec function CoopGhostMatOff()
{
    PKPlayerPawn(MyEvilPawn).RestoreMaterial();
    //return;    
}

exec function FindGoodSpawnSpot(optional float TraceExtent = 10.0000000)
{
    local Vector pos, Extent;

    Extent.X = TraceExtent;
    Extent.Y = TraceExtent;
    Extent.Z = TraceExtent;
    PKGame(WorldInfo.Game).GetValidSpawnLocationNearPawn(pos, Pawn, 150.0000000, 600.0000000, Extent);
    //return;    
}

exec function GiveArmorStrong()
{
    PKPlayerPawn(Pawn).Armour = Class'PainItem_Armour_Strong'.default.ArmorAdd;
    PKPlayerPawn(Pawn).ArmourClass = Class'PainItem_Armour_Strong';
    //return;    
}

exec function GiveArmorWeak()
{
    PKPlayerPawn(Pawn).Armour = Class'PainItem_Armour_Weak'.default.ArmorAdd;
    PKPlayerPawn(Pawn).ArmourClass = Class'PainItem_Armour_Weak';
    //return;    
}

exec function GiveArmorMedium()
{
    PKPlayerPawn(Pawn).Armour = Class'PainItem_Armour_Medium'.default.ArmorAdd;
    PKPlayerPawn(Pawn).ArmourClass = Class'PainItem_Armour_Medium';
    //return;    
}

simulated function NotifyClientsHostLeavingForMigration()
{
    local PKPlayerController PC;

    // End:0x18A
    if((((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && int(WorldInfo.NetMode) == int(NM_ListenServer)) && IsPrimaryPlayer())
    {
        // End:0x189
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
        {
            // End:0x188
            if(!PC.IsLocalPlayerController())
            {
                PC.CleanupLobbyByID(LobbyUID);
                PC.CleanupSteamLobby();
                PC.ClientSetProgressMessage(4, Localize("KGFxUI_PreGameLobby", "ServerConnectionLostMessage", "PKHDGame"));
            }            
        }        
    }
    //return;    
}

function ForceCloseUIMessageScene(optional name SceneTag = 'ProgressMessage', optional bool bSimulateCancel = true)
{
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x8E
    if(UIManager != none)
    {
        UIManager.ClearUIMessage(SceneTag, LocalPlayer(Player));
    }
    //return;    
}

simulated function CloseUnwantedMessageBoxes()
{
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ClearUIMessage('NotifyHostMigrationStart');
    //return;    
}

simulated function ReturnToMainMenu(bool bReturnToStartScreen)
{
    local bool bShouldTravel;
    local PKLocalPlayer LP;

    // End:0x1E
    if(bIsReturningFromMatch || bIsReturningToMainMenu)
    {
        return;
    }
    CloseUnwantedMessageBoxes();
    NotifyClientsHostLeavingForMigration();
    CleanupSteamLobby();
    LP = PKLocalPlayer(Player);
    // End:0xB5
    if(LP != none)
    {
        LP.ClearPostProcessSettingsOverride(0.0000000);
        LP.bIsFirstFrontEndLoad = bReturnToStartScreen;
    }
    bShouldTravel = true;
    bIsReturningFromMatch = true;
    bIgnoreNetworkMessages = true;
    bIsReturningToMainMenu = true;
    // End:0x169
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OnlineSub.GameInterface.DestroyOnlineGame('Game');
    }
    // End:0x18D
    if(bShouldTravel)
    {
        ClientTravel("?Closed", 0);
    }
    //return;    
}

final simulated function bool IsCoop()
{
    local PainGRI GRI;

    GRI = PainGRI(WorldInfo.GRI);
    return (GRI != none) && GRI.IsCoopMultiplayerGame();
    //return ReturnValue;    
}

function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x43E
    if(IsPrimaryPlayer())
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x196
        if(int(ConnectionStatus) == int(7))
        {
            ButtonAliases.AddItem('GenericAccept');
            UIManager.ShowUIMessage('ConfirmNetworkLost', Localize("MessageBoxErrorStrings", "SignedOut_Title" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), Localize("MessageBoxErrorStrings", "DuplicateSignin_Message" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), ButtonAliases, None, LocalPlayer(Player),,,, false, false);
            ReturnToMainMenu(true);            
        }
        else
        {
            // End:0x43E
            if(!IsCoop() && WorldInfo.IsConsoleBuild())
            {
                // End:0x43E
                if(((PainGRI(WorldInfo.GRI) != none) && int(PainGRI(WorldInfo.GRI).CurrentPartyType) != int(2)) || ((int(WorldInfo.NetMode) == int(NM_Standalone)) && !IsSplitscreenPlayer()) && !WorldInfo.bIsMenuLevel)
                {
                    switch(ConnectionStatus)
                    {
                        // End:0x2BB
                        case 2:
                        // End:0x2C0
                        case 3:
                        // End:0x2C5
                        case 4:
                        // End:0x2CA
                        case 5:
                        // End:0x43B
                        case 6:
                            // End:0x438
                            if(OnlineSub.SystemInterface.HasLinkConnection())
                            {
                                ButtonAliases.AddItem('GenericAccept');
                                UIManager.ShowUIMessage('ConfirmNetworkLost', Localize("MessageBoxErrorStrings", "XboxLive_Title" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), Localize("MessageBoxErrorStrings", "LostLiveConnection_Message" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), ButtonAliases, None,,,,, false, false);
                                ReturnToMainMenu(true);
                            }
                            // End:0x43E
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                }
                else
                {
                }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x43E! */
            }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x196! */
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x196! */
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x000! */
}

static function string GetLobbySettingsData(const array<LobbyMetaData> LobbyData, string Key)
{
    local LobbyMetaData LD;

    // End:0x60
    foreach LobbyData(LD)
    {
        // End:0x5F
        if(LD.Key ~= Key)
        {            
            return LD.Value;
        }        
    }    
    return "";
    //return ReturnValue;    
}

static function string GetLobbyData(BasicLobbyInfo LobbyInfo, string Key)
{
    return GetLobbySettingsData(LobbyInfo.LobbySettings, Key);
    //return ReturnValue;    
}

static function string GetActiveLobbyData(ActiveLobbyInfo LobbyInfo, string Key)
{
    return GetLobbySettingsData(LobbyInfo.LobbySettings, Key);
    //return ReturnValue;    
}

reliable server function SetupSteamLobby()
{
    local UniqueNetId ZeroId;

    // End:0x72
    if((LobbyUID == ZeroId && !IsTimerActive('TryToCreateLobby')) && !Class'Engine.Engine'.static.IsEditor())
    {
        SetTimer(0.5000000, true, 'TryToCreateLobby');
    }
    //return;    
}

function TryToCreateLobby()
{
    local string sid;
    local UniqueNetId ServerID;

    // End:0xDD
    if(OnlineSubsystemSteamworks(OnlineSub).CachedAuthInt.GetServerUniqueId(ServerID))
    {
        ClearTimer('TryToCreateLobby');
        sid = OnlineSub.UniqueNetIdToStringDEC(ServerID);
        CreateLobby(16, sid);
        OnlineSubsystemSteamworks(OnlineSub).ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
    }
    //return;    
}

exec function CreateLobby(int NumPlayers, string steamId)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;
    local array<LobbyMetaData> InitialSettings;
    local OnlineGameSettings Settings;
    local int settingsUsePassword;
    local string GameMode, OwnerId;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    Settings = OnlineSub.GameInterface.GetGameSettings('Game');
    // End:0xA6
    if(Settings.GetStringSettingValue(7, settingsUsePassword))
    {
    }
    GameMode = Settings.GetPropertyAsStringByName('CustomGameMode');
    OwnerId = Settings.GetPropertyAsStringByName('OwnerId');
    InitialSettings.Add(7);
    InitialSettings[0].Key = "STEAMID";
    InitialSettings[0].Value = steamId;
    InitialSettings[1].Key = "SERVERNAME";
    InitialSettings[1].Value = Settings.OwningPlayerName;
    InitialSettings[2].Key = "GAMETYPE";
    InitialSettings[2].Value = Right(GameMode, Len(GameMode) - 9);
    InitialSettings[3].Key = "PLAYERS";
    InitialSettings[3].Value = (("" @ string(Settings.NumPublicConnections - Settings.NumOpenPublicConnections)) @ " / ") @ string(Settings.NumPublicConnections);
    InitialSettings[4].Key = "USEPASSWORD";
    InitialSettings[4].Value = ((settingsUsePassword == 1) ? "1" : "0");
    InitialSettings[5].Key = "MAPNAME";
    InitialSettings[5].Value = WorldInfo.GetMapName(true);
    InitialSettings[6].Key = "OWNERID";
    InitialSettings[6].Value = OwnerId;
    LobbyInterface.AddCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    // End:0x471
    if(LobbyInterface.CreateLobby(NumPlayers, 0, InitialSettings))
    {        
    }
    else
    {
        LobbyInterface.ClearCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    }
    //return;    
}

reliable server function CleanupSteamLobby()
{
    local UniqueNetId ZeroId;
    local OnlineLobbyInterfaceSteamworks LobbyInterface;
    local PKPlayerController PC;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0xF9
    if((LobbyInterface != none) && LobbyUID != ZeroId)
    {
        // End:0xBD
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
        {
            PC.CleanupLobbyByID(LobbyUID);            
        }        
        LobbyInterface.LeaveLobby(LobbyUID);
        LobbyUID = ZeroId;
    }
    //return;    
}

simulated function CleanupLobbyByID(UniqueNetId lUID)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x68
    if(LobbyInterface != none)
    {
        LobbyInterface.LeaveLobby(lUID);
    }
    //return;    
}

function OnCreateLobbyComplete(bool bWasSuccessful, UniqueNetId LobbyId, string Error)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    LobbyInterface.ClearCreateLobbyCompleteDelegate(OnCreateLobbyComplete);
    LobbyUID = LobbyId;
    //return;    
}

function UpdateSteamLobby(string MapName, string NumPlayers)
{
    local UniqueNetId ZeroId;
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0xC3
    if(LobbyUID != ZeroId)
    {
        LobbyInterface.SetLobbySetting(LobbyUID, "MAPNAME", MapName);
        LobbyInterface.SetLobbySetting(LobbyUID, "PLAYERS", NumPlayers);
    }
    //return;    
}

protected function OnLeaderboardStatsFlushed(name SessionName, bool bWasSuccessful)
{
    OnlineSub.StatsInterface.ClearFlushOnlineStatsCompleteDelegate(OnLeaderboardStatsFlushed);
    //return;    
}

reliable client simulated function ClientWriteLeaderboardSingleStats()
{
    local array<UniqueNetId> UIDList;

    // End:0x1C5
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        // End:0x8E
        if(!IsPrimaryPlayer())
        {
            return;
        }
        LeaderboardStatsWriteClass = Class'PKLeaderboardWriteSingle';
        LeaderboardStatsRead = new LeaderboardStatsWriteClass.default.LeaderboardReaderClass;
        LeaderboardStatsRead.ViewId = LeaderboardStatsWriteClass.default.ViewIds[0];
        UIDList.AddItem(PlayerReplicationInfo.UniqueId);
        OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(ReadLeaderboardSingleStatsComplete);
        OnlineSub.StatsInterface.ReadOnlineStats(UIDList, LeaderboardStatsRead);
    }
    //return;    
}

function ReadLeaderboardSingleStatsComplete(bool bWasSuccessful)
{
    local PainPRI PRI;
    local PKLeaderboardReadSingle Reader;
    local PKLeaderboardWriteSingle Writer;
    local int CurrentKills, OldKills, CurrentGibbedEnemies, OldEnemiesGibbed, CurrentCollectedGold, OldCollectedGold;

    PRI = PainPRI(PlayerReplicationInfo);
    OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(ReadLeaderboardSingleStatsComplete);
    // End:0x374
    if((bWasSuccessful && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        Reader = PKLeaderboardReadSingle(LeaderboardStatsRead);
        OldKills = Reader.GetKills(PRI.UniqueId);
        OldEnemiesGibbed = Reader.GetGibbedEnemies(PRI.UniqueId);
        OldCollectedGold = Reader.GetCollectedGold(PRI.UniqueId);
        CurrentKills = PRI.MonstersKilled + OldKills;
        CurrentGibbedEnemies = PRI.MonstersGibbed + OldEnemiesGibbed;
        CurrentCollectedGold = PRI.PlayerMoneyFound + OldCollectedGold;
        Writer = new Class'PKLeaderboardWriteSingle';
        Writer.SetKills(CurrentKills);
        Writer.SetGibbedEnemies(CurrentGibbedEnemies);
        Writer.SetCollectedGold(CurrentCollectedGold);
        OnlineSub.StatsInterface.WriteOnlineStats('Game', PRI.UniqueId, Writer);
        OnlineSub.StatsInterface.FlushOnlineStats('Game');
    }
    //return;    
}

reliable client simulated function ClientWriteSoloSurvivalStats(bool bCompleted)
{
    local array<UniqueNetId> UIDList;

    // End:0x1F8
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        // End:0x8E
        if(!IsPrimaryPlayer())
        {
            return;
        }
        LeaderboardStatsWriteClass = Class'PKLeaderboardWriteSingleSV';
        LeaderboardStatsRead = new LeaderboardStatsWriteClass.default.LeaderboardReaderClass;
        LeaderboardStatsRead.ViewId = LeaderboardStatsWriteClass.default.ViewIds[0];
        PKLeaderboardReadSingleSV(LeaderboardStatsRead).bSurvivalCompleted = bCompleted;
        UIDList.AddItem(PlayerReplicationInfo.UniqueId);
        OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(ReadLeaderboardSoloSurvivalStatsComplete);
        OnlineSub.StatsInterface.ReadOnlineStats(UIDList, LeaderboardStatsRead);
    }
    //return;    
}

function ReadLeaderboardSoloSurvivalStatsComplete(bool bWasSuccessful)
{
    local PainPRI PRI;
    local PKLeaderboardReadSingleSV Reader;
    local PKLeaderboardWriteSingleSV Writer;
    local int CurrentScore, OldScore, CurrentEnemiesKills, OldEnemiesKilled, CurrentMatches, OldMatches;

    PRI = PainPRI(PlayerReplicationInfo);
    Reader = PKLeaderboardReadSingleSV(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldEnemiesKilled = Reader.GetEnemiesKilled(PRI.UniqueId);
    OldMatches = Reader.GetMatches(PRI.UniqueId);
    CurrentScore = OldScore + Max(0, int(PRI.Score));
    CurrentEnemiesKills = OldEnemiesKilled + Max(0, PRI.Kills);
    // End:0x1B6
    if(Reader.bSurvivalCompleted)
    {
        CurrentMatches = OldMatches + 1;        
    }
    else
    {
        CurrentMatches = OldMatches;
    }
    Writer = PKLeaderboardWriteSingleSV(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetEnemiesKilled(CurrentEnemiesKills);
    Writer.SetMatches(CurrentMatches);
    OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName, PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats(PRI.SessionName);
    //return;    
}

reliable client simulated function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete = false)
{
    local array<UniqueNetId> UIDList;

    // End:0x18B
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        LeaderboardStatsWriteClass = class<PKLeaderboardWriteBase>(OnlineStatsWriteClass);
        LeaderboardStatsRead = new LeaderboardStatsWriteClass.default.LeaderboardReaderClass;
        LeaderboardStatsRead.ViewId = OnlineStatsWriteClass.default.ViewIds[0];
        UIDList.AddItem(PlayerReplicationInfo.UniqueId);
        OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(ReadLeaderboardStatsComplete);
        OnlineSub.StatsInterface.ReadOnlineStats(UIDList, LeaderboardStatsRead);
    }
    //return;    
}

simulated function ReadLeaderboardStatsComplete(bool bWasSuccessful)
{
    OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(ReadLeaderboardStatsComplete);
    // End:0x12C
    if((bWasSuccessful && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        // End:0xC0
        if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'PKLeaderboardWriteDM'))
        {
            ReadAndWriteDMLeaderBoard();            
        }
        else
        {
            // End:0xE5
            if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'PKLeaderboardWriteTDM'))
            {
                ReadAndWriteTDMLeaderBoard();                
            }
            else
            {
                // End:0x10A
                if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'PKLeaderboardWriteSV'))
                {
                    ReadAndWriteSurvivalLeaderBoard();                    
                }
                else
                {
                    // End:0x12C
                    if(ClassIsChildOf(LeaderboardStatsWriteClass, Class'PKLeaderboardWriteCTF'))
                    {
                        ReadAndWriteCTFLeaderBoard();
                    }
                }
            }
        }
    }
    LeaderboardStatsRead = none;
    //return;    
}

simulated function ReadAndWriteSurvivalLeaderBoard()
{
    local PainPRI PRI;
    local PKLeaderboardReadSV Reader;
    local PKLeaderboardWriteSV Writer;
    local int CurrentScore, OldScore, CurrentEnemiesKills, OldEnemiesKilled, CurrentMatches, OldMatches;

    PRI = PainPRI(PlayerReplicationInfo);
    Reader = PKLeaderboardReadSV(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldEnemiesKilled = Reader.GetEnemiesKilled(PRI.UniqueId);
    OldMatches = Reader.GetMatches(PRI.UniqueId);
    CurrentScore = OldScore + Max(0, int(PRI.Score));
    CurrentEnemiesKills = OldEnemiesKilled + Max(0, PRI.Kills);
    CurrentMatches = OldMatches + 1;
    Writer = PKLeaderboardWriteSV(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetEnemiesKilled(CurrentEnemiesKills);
    Writer.SetMatches(CurrentMatches);
    OnlineSub.StatsInterface.WriteOnlineStats(PRI.SessionName, PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats(PRI.SessionName);
    //return;    
}

simulated function ReadAndWriteCTFLeaderBoard()
{
    local PainPRI PRI;
    local PKLeaderboardReadCTF Reader;
    local PKLeaderboardWriteCTF Writer;
    local int CurrentScore, OldScore, CurrentFlagsCaptured, OldFlagsCaptured, CurrentFlagsReturned, OldFlagsReturned;

    PRI = PainPRI(PlayerReplicationInfo);
    Reader = PKLeaderboardReadCTF(LeaderboardStatsRead);
    OldScore = Reader.GetScore(PRI.UniqueId);
    OldFlagsCaptured = Reader.GetFlagsCaptured(PRI.UniqueId);
    OldFlagsReturned = Reader.GetFlagsReturned(PRI.UniqueId);
    CurrentScore = Max(0, int(PRI.Score)) + OldScore;
    CurrentFlagsCaptured = PRI.GetFlagsCapturedSinceLastWrite() + OldFlagsCaptured;
    CurrentFlagsReturned = PRI.GetFlagsReturnedSinceLastWrite() + OldFlagsReturned;
    // End:0x1FA
    if(!((CurrentScore > OldScore) || CurrentFlagsCaptured > OldFlagsCaptured) || CurrentFlagsReturned > OldFlagsReturned)
    {
        return;
    }
    Writer = PKLeaderboardWriteCTF(new LeaderboardStatsWriteClass);
    Writer.SetScore(CurrentScore);
    Writer.SetFlagsCaptured(CurrentFlagsCaptured);
    Writer.SetFlagsReturned(CurrentFlagsReturned);
    OnlineSub.StatsInterface.WriteOnlineStats('Game', PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats('Game');
    //return;    
}

simulated function ReadAndWriteDMLeaderBoard()
{
    local PainPRI PRI;
    local PKLeaderboardReadDM Reader;
    local PKLeaderboardWriteDM Writer;
    local int CurrentKills, OldKills, CurrentDeaths, OldDeaths, CurrentMatchesWon, OldMatchesWon;

    PRI = PainPRI(PlayerReplicationInfo);
    Reader = PKLeaderboardReadDM(LeaderboardStatsRead);
    OldKills = Reader.GetKills(PRI.UniqueId);
    OldDeaths = Reader.GetDeaths(PRI.UniqueId);
    OldMatchesWon = Reader.GetMatchesWon(PRI.UniqueId);
    CurrentKills = Max(0, int(PRI.Score)) + OldKills;
    CurrentDeaths = PRI.Deaths + OldDeaths;
    CurrentMatchesWon = OldMatchesWon + ((bWinnerOfTheMatch) ? 1 : 0);
    // End:0x1EB
    if(!((CurrentKills > OldKills) || CurrentDeaths > OldDeaths) || CurrentMatchesWon > OldMatchesWon)
    {
        return;
    }
    Writer = PKLeaderboardWriteDM(new LeaderboardStatsWriteClass);
    Writer.SetKills(CurrentKills);
    Writer.SetDeaths(CurrentDeaths);
    Writer.SetMatchesWon(CurrentMatchesWon);
    OnlineSub.StatsInterface.WriteOnlineStats('Game', PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats('Game');
    //return;    
}

simulated function ReadAndWriteTDMLeaderBoard()
{
    local PainPRI PRI;
    local PKLeaderboardReadTDM Reader;
    local PKLeaderboardWriteTDM Writer;
    local int CurrentKills, OldKills, CurrentDeaths, OldDeaths, CurrentMatchesWon, OldMatchesWon;

    PRI = PainPRI(PlayerReplicationInfo);
    Reader = PKLeaderboardReadTDM(LeaderboardStatsRead);
    OldKills = Reader.GetKills(PRI.UniqueId);
    OldDeaths = Reader.GetDeaths(PRI.UniqueId);
    OldMatchesWon = Reader.GetMatchesWon(PRI.UniqueId);
    CurrentKills = Max(0, int(PRI.Score)) + OldKills;
    CurrentDeaths = Max(0, PRI.Deaths) + OldDeaths;
    CurrentMatchesWon = OldMatchesWon + ((bWinnerOfTheMatch) ? 1 : 0);
    // End:0x1EE
    if(!((CurrentKills > OldKills) || CurrentDeaths > OldDeaths) || CurrentMatchesWon > OldMatchesWon)
    {
        return;
    }
    Writer = PKLeaderboardWriteTDM(new LeaderboardStatsWriteClass);
    Writer.SetKills(CurrentKills);
    Writer.SetDeaths(CurrentDeaths);
    Writer.SetMatchesWon(CurrentMatchesWon);
    OnlineSub.StatsInterface.WriteOnlineStats('Game', PRI.UniqueId, Writer);
    OnlineSub.StatsInterface.FlushOnlineStats('Game');
    //return;    
}

unreliable client simulated function ClientNotifyPickup()
{
    NotifyPickup();
    //return;    
}

simulated function NotifyPickup()
{
    local PKPostProcessManager PPMgr;

    // End:0x49
    if((int(WorldInfo.NetMode) < int(NM_Client)) && int(RemoteRole) == int(ROLE_AutonomousProxy))
    {
        ClientNotifyPickup();
    }
    PPMgr = PKPostProcessManager(GetPPManager());
    // End:0x94
    if(PPMgr != none)
    {
        PPMgr.PickupFlash();
    }
    //return;    
}

reliable client simulated function ClientSetFlashlight(bool bEnabled)
{
    // End:0x4A
    if(PKPlayerPawn(MyEvilPawn) != none)
    {
        PKPlayerPawn(MyEvilPawn).SetFlashlight(bEnabled);
    }
    //return;    
}

function Possess(Pawn inPawn, bool bVehicleTransition)
{
    local Actor A;

    super.Possess(inPawn, bVehicleTransition);
    // End:0xA3
    if(inPawn.IsA('PKPlayerPawn'))
    {
        PKPlayerPawn(inPawn).SetFlashlight(bFlashlightOn);
        PKPlayerPawn(inPawn).Bob = GlobalHeadBob;
    }
    // End:0xFF
    foreach Children(A)
    {
        // End:0xFE
        if(A.IsA('PainItemBase'))
        {
            A.SetOwner(inPawn);
        }        
    }    
    //return;    
}

function UnPossess()
{
    // End:0x4C
    if(Pawn.IsA('PKPlayerPawn'))
    {
        PKPlayerPawn(Pawn).SetFlashlight(false);
    }
    super.UnPossess();
    //return;    
}

simulated function RefreshPawnParamsFromPC()
{
    local Actor A;

    // End:0x49
    if(PKPlayerPawn(Pawn) != none)
    {
        PKPlayerPawn(Pawn).Bob = GlobalHeadBob;
    }
    // End:0xA5
    foreach Children(A)
    {
        // End:0xA4
        if(A.IsA('PainItemBase'))
        {
            A.SetOwner(Pawn);
        }        
    }    
    //return;    
}

simulated event Destroyed()
{
    local PainGRI GRI;

    super.Destroyed();
    GRI = PainGRI(WorldInfo.GRI);
    // End:0x91
    if((GRI != none) && GRI.IsMultiplayerGame())
    {
        Pawn.Destroy();
        MyEvilPawn = none;
    }
    // End:0xC3
    if(PKHudWrapper != none)
    {
        PKHudWrapper.Destroy();
        PKHudWrapper = none;
    }
    // End:0xF5
    if(PlayerCamera != none)
    {
        PlayerCamera.Destroy();
        PlayerCamera = none;
    }
    CleanupSteamLobby();
    ClearOnlineDelegates();
    UnregisterPlayerDataStores();
    //return;    
}

event PreClientTravel(string PendingURL, Actor.ETravelType TravelType, bool bIsSeamlessTravel)
{
    local PKPlayerController PC;

    super(PlayerController).PreClientTravel(PendingURL, TravelType, bIsSeamlessTravel);
    // End:0x8C
    if(!bIsSeamlessTravel)
    {
        // End:0x81
        foreach LocalPlayerControllers(Class'PKPlayerController', PC)
        {
            PC.ClientSaveAllPlayerData(!bIsSeamlessTravel);            
        }        
        ClientShowLevelLoadingMovie();
    }
    //return;    
}

event StartupStopLoadingMovie()
{
    ClientStopLevelLoadingMovie();
    //return;    
}

exec function LoadCheckpoint(optional name InCheckpointName)
{
    local PKPlayerController PC;
    local PainGFxHudWrapper HUD;

    // End:0xA2
    foreach LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        HUD = PainGFxHudWrapper(PC.myHUD);
        // End:0xA1
        if(HUD != none)
        {
            HUD.bWasVisibleBeforePause = true;
            HUD.SetVisible(true);
        }        
    }    
    ServerDeactivateGoldenCards();
    super.LoadCheckpoint(InCheckpointName);
    //return;    
}

exec function RestartLevel()
{
    local PKPlayerController PC;
    local PainGFxHudWrapper HUD;

    // End:0xA1
    foreach LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        HUD = PainGFxHudWrapper(PC.myHUD);
        // End:0xA0
        if(HUD != none)
        {
            HUD.bWasVisibleBeforePause = true;
            HUD.SetVisible(true);
        }        
    }    
    // End:0x16F
    if(!WorldInfo.GRI.IsMultiplayerGame())
    {
        ClientShowLevelLoadingMovie();
        WorldInfo.ServerTravel("PKHDGame_P?loadcheckpoint=0?chapter=" $ string(PKGameSP(WorldInfo.Game).CurrentChapter));        
    }
    else
    {
        super(PlayerController).RestartLevel();
    }
    //return;    
}

exec function RestartLevel2()
{
    // End:0x41
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        ClientTravel("?restart", NM_ListenServer);
    }
    //return;    
}

simulated function int GetControllerId()
{
    local LocalPlayer LP;

    LP = LocalPlayer(Player);
    // End:0x4A
    if(LP != none)
    {
        return LP.ControllerId;
    }
    return -1;
    //return ReturnValue;    
}

event InitInputSystem()
{
    super(UTPlayerController).InitInputSystem();
    PKEngine(Class'PKEngine'.static.GetEngine()).SetCanBreakFullscreenMovie(false);
    // End:0x8B
    if((int(WorldInfo.NetMode) == int(NM_Client)) && IsPrimaryPlayer())
    {
        StartupStopLoadingMovie();
    }
    //return;    
}

reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
    super.ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD);
    // End:0x7E
    if(((PKHudWrapper != none) && bAffectsHUD) && bInCinematicMode)
    {
        PKHudWrapper.HideInGameStatsScreen();
    }
    // End:0x10B
    if(bInCinematicMode)
    {
        // End:0x10B
        if((int(Role) == int(ROLE_Authority)) && PKGame(WorldInfo.Game) != none)
        {
            PKGame(WorldInfo.Game).DisableBulletTime();
        }
    }
    //return;    
}

exec function ConditionalPauseGame()
{
    local string CurrentMovieName;

    GetCurrentMovie(CurrentMovieName);
    // End:0x2E
    if(CurrentMovieName == "")
    {
        PauseGame();
    }
    //return;    
}

delegate bool CanUnpause()
{
    return (WorldInfo.Pauser == PlayerReplicationInfo) || IsSplitscreenPlayer();
    //return ReturnValue;    
}

function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local bool bRetval;
    local PKPlayerController PC;
    local PKUIManager UIManager;

    bRetval = super(PlayerController).SetPause(bPause, CanUnpauseDelegate);
    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0xC0
    if(bPause)
    {
        // End:0xBD
        if(PainGFxHudWrapper(myHUD) != none)
        {
            PainGFxHudWrapper(myHUD).SetVisibilityForPause(true);
        }        
    }
    else
    {
        // End:0x128
        if(WorldInfo.Pauser == none)
        {
            // End:0x125
            if(PainGFxHudWrapper(myHUD) != none)
            {
                PainGFxHudWrapper(myHUD).SetVisibilityForPause(false);
            }            
        }
        else
        {
            // End:0x172
            if(!UIManager.IsUIMessageActive('HostPaused', LocalPlayer(Player)))
            {
                ClientUpdateHostPause(true);
            }
        }
    }
    // End:0x279
    if((!bPause && int(WorldInfo.NetMode) != int(NM_Client)) && WorldInfo.Pauser == none)
    {
        // End:0x279
        if(WorldInfo.Pauser == none)
        {
            // End:0x278
            foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
            {
                // End:0x277
                if(LocalPlayer(PC.Player) == none)
                {
                    PC.ClientUpdateHostPause(false);
                }                
            }            
        }
    }
    return bRetval;
    //return ReturnValue;    
}

function UnPauseGame()
{
    PKHudWrapper.UnPauseGame();
    //return;    
}

function PauseGame(optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local PKPlayerController PC;
    local bool bCanPauseGame;
    local delegate<CanUnpause> DefaultUnpauseDelegate;

    DefaultUnpauseDelegate = CanUnpause;
    bCanPauseGame = true;
    // End:0x22F
    if(bCanPauseGame && !bCinematicMode || IsPrimaryPlayer())
    {
        // End:0xF6
        if(PKHudWrapper != none)
        {
            // End:0xCB
            if(CanUnpauseDelegate == DefaultUnpauseDelegate || CanUnpauseDelegate == )
            {
                PKHudWrapper.PauseGame();                
            }
            else
            {
                PKHudWrapper.PauseGame(CanUnpauseDelegate);
            }            
        }
        else
        {
            SetPause(true, CanUnpauseDelegate);
        }
        // End:0x22F
        if((int(Role) == int(ROLE_Authority)) && WorldInfo.Pauser != none)
        {
            // End:0x22E
            foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
            {
                // End:0x22D
                if((LocalPlayer(PC.Player) == none) || PC.IsSplitscreenPlayer() && PC.PlayerReplicationInfo != WorldInfo.Pauser)
                {
                    PC.ClientUpdateHostPause(true);
                }                
            }            
        }
    }
    //return;    
}

simulated function bool DoNotClose(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    return false;
    //return ReturnValue;    
}

function ProcessClientPauseKey(int ControllerIdx)
{
    local PKPlayerController PC;

    // End:0x8A
    foreach LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        // End:0x89
        if(LocalPlayer(PC.Player).ControllerId == ControllerIdx)
        {
            PC.PauseGame();
        }        
    }    
    //return;    
}

exec function ForceHostPause(optional bool bEnable = true)
{
    local array<name> ButtonArray;
    local PKUIManager UIManager;
    local UIScene_MessageBox MessageBox;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x180
    if(bEnable)
    {
        ButtonArray.Length = 0;
        UIManager.ClearUIMessage('HostPaused', none, true);
        UIManager.ShowUIMessage('HostPaused', Localize("MessageBoxStrings", "HostPaused_Title", "PKHDGame"), Localize("MessageBoxStrings", "HostPaused_Text", "PKHDGame"), ButtonArray, DoNotClose,, MessageBox, 60,, false);
        // End:0x17D
        if(MessageBox != none)
        {
            MessageBox.__OnStartButtonPressed__Delegate = ProcessClientPauseKey;
        }        
    }
    else
    {
        UIManager.ClearUIMessage('HostPaused');
    }
    //return;    
}

reliable client simulated function ClientUpdateHostPause(bool bNowPaused)
{
    local array<name> ButtonArray;
    local PKUIManager UIManager;
    local UIScene_MessageBox MessageBox;
    local string Title, Text;

    // End:0x2E5
    if((int(WorldInfo.NetMode) == int(NM_Client)) || IsSplitscreenPlayer())
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0xB5
        if(PainGFxHudWrapper(myHUD) != none)
        {
            PainGFxHudWrapper(myHUD).SetVisibilityForPause(bNowPaused);
        }
        // End:0x2A7
        if(bNowPaused)
        {
            ButtonArray.Length = 0;
            // End:0x112
            if(IsSplitscreenPlayer())
            {
                Title = Localize("Generic", "GamePaused", "PKHDGame");                
            }
            else
            {
                Title = Localize("MessageBoxStrings", "HostPaused_Title", "PKHDGame");
                Text = Localize("MessageBoxStrings", "HostPaused_Text", "PKHDGame");
            }
            UIManager.ClearUIMessage('HostPaused', LocalPlayer(Player), true);
            UIManager.ShowUIMessage('HostPaused', Title, Text, ButtonArray, DoNotClose, LocalPlayer(Player), MessageBox, 60,, IsSplitscreenPlayer());
            // End:0x291
            if(MessageBox != none)
            {
                MessageBox.__OnStartButtonPressed__Delegate = ProcessClientPauseKey;
            }
            SetTimer(0.5000000, true, 'ServerVerifyPausedState');            
        }
        else
        {
            UIManager.ClearUIMessage('HostPaused');
            ClearTimer('ServerVerifyPausedState');
        }
    }
    //return;    
}

unreliable server final function ServerVerifyPausedState()
{
    // End:0x2E
    if(WorldInfo.Pauser == none)
    {
        UnreliableClientClearHostPause();
    }
    //return;    
}

unreliable client final simulated function UnreliableClientClearHostPause()
{
    ClientUpdateHostPause(false);
    //return;    
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    local LocalPlayer LP;
    local bool bIsTraveling, bMenuLevel, bOpenPauseMenu, bOpenPauseMenuNoPause;
    local OnlinePlayerInterface PlayerInterface;
    local byte PlayerID;
    local int NumPlayersOnMachine;
    local string ActiveMovieName;
    local PKPlayerController PC;
    local Engine Eng;
    local UIInteraction UICtrl;

    LP = LocalPlayer(Player);
    Eng = Class'Engine.Engine'.static.GetEngine();
    UICtrl = Eng.GamePlayers[0].ViewportClient.UIController;
    // End:0x5A3
    if(((LP != none) && WorldInfo.IsConsoleBuild()) && (WorldInfo.Game == none) || !WorldInfo.Game.IsAutomatedPerfTesting())
    {
        PlayerID = byte(LP.ControllerId);
        bMenuLevel = Class'Engine.WorldInfo'.static.IsMenuLevel();
        // End:0x1AF
        if(bMenuLevel)
        {
            OnControllerChangedInMenu(ControllerId, bIsConnected);
            return;
        }
        // End:0x5A3
        if(int(PlayerID) == ControllerId)
        {
            bIsControllerConnected = bIsConnected;
            // End:0x3E1
            if(OnlineSub != none)
            {
                PlayerInterface = OnlineSub.PlayerInterface;
                // End:0x3E1
                if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
                {
                    GetCurrentMovie(ActiveMovieName);
                    bIsTraveling = (GameEngine(LP.Outer).TravelURL != "") || ActiveMovieName ~= "LoadingMovie";
                    // End:0x3E1
                    if(!bIsTraveling && !bIsConnected)
                    {
                        // End:0x3CA
                        if(WorldInfo.Game != none)
                        {
                            NumPlayersOnMachine = Class'Engine.UIInteraction'.static.GetPlayerCount();
                            // End:0x383
                            if(NumPlayersOnMachine > 2)
                            {
                                Eng.GamePlayers[0].ViewportClient.RemovePlayer(LP);
                                return;
                            }
                            // End:0x3B0
                            if((NumPlayersOnMachine == 1) || IsCoop())
                            {
                                bOpenPauseMenu = true;                                
                            }
                            else
                            {
                                bOpenPauseMenuNoPause = !bMenuLevel;
                            }                            
                        }
                        else
                        {
                            bOpenPauseMenuNoPause = !bMenuLevel;
                        }
                    }
                }
            }
            // End:0x541
            if(bOpenPauseMenu || bOpenPauseMenuNoPause && PKHudWrapper != none)
            {
                // End:0x439
                if(bOpenPauseMenu)
                {
                    PauseGame(CanUnpauseControllerConnected);                    
                }
                else
                {
                    // End:0x53E
                    if(bOpenPauseMenuNoPause && PKHudWrapper != none)
                    {
                        // End:0x51E
                        if(int(WorldInfo.NetMode) != int(NM_Client))
                        {
                            // End:0x51D
                            foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
                            {
                                // End:0x51C
                                if(!PC.IsLocalPlayerController() && PC.IsPrimaryPlayer())
                                {
                                    PC.ClientUpdateHostPause(true);
                                }                                
                            }                            
                        }
                        PKHudWrapper.PauseGame();
                    }
                }                
            }
            else
            {
                // End:0x5A3
                if(bIsConnected)
                {
                    // End:0x5A3
                    if((PKHudWrapper == none) || !PKHudWrapper.IsGamePaused())
                    {
                        LP.ClearPostProcessSettingsOverride();
                    }
                }
            }
        }
    }
    //return;    
}

function OnControllerChangedInMenu(int ControllerId, bool bIsConnected)
{
    local array<name> ButtonArray;
    local PKUIManager UIManager;
    local UIInteraction UICtrl;
    local LocalPlayer LP;
    local Engine Eng;

    LP = LocalPlayer(Player);
    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    Eng = Class'Engine.Engine'.static.GetEngine();
    UICtrl = Eng.GamePlayers[0].ViewportClient.UIController;
    // End:0x1F2
    if(!bIsConnected)
    {
        // End:0x1EF
        if(UICtrl.GetConnectedGamepadCount() == 0)
        {
            ButtonArray.Length = 0;
            UIManager.ShowUIMessage('ControllerRemoved', Localize("MessageBoxErrorStrings", "ReconnectController_Title", "PKHDGame"), Localize("MessageBoxErrorStrings", "ReconnectController_Message", "PKHDGame"), ButtonArray, DoNotClose, LP,, 60,, false);
        }        
    }
    else
    {
        UIManager.ClearUIMessage('ControllerRemoved', none, true);
    }
    //return;    
}

function OnExternalUIChanged(bool bIsOpening)
{
    local PKPlayerController PC;

    super(PlayerController).OnExternalUIChanged(bIsOpening);
    // End:0xD1
    if((int(Role) == int(ROLE_Authority)) && WorldInfo.Pauser != none)
    {
        // End:0xD0
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
        {
            // End:0xCF
            if(!PC.IsLocalPlayerController())
            {
                PC.ClientUpdateHostPause(bIsOpening);
            }            
        }        
    }
    //return;    
}

reliable client simulated event ClientShowLevelLoadingMovie()
{
    local PKGameViewportClient Viewport;

    Class'Engine.Engine'.static.PlayLoadMapMovie("PKHD_LoadingMovie");
    // End:0xC1
    if(IsPrimaryPlayer() && LocalPlayer(Player) != none)
    {
        Viewport = PKGameViewportClient(LocalPlayer(Player).ViewportClient);
        // End:0xC1
        if(Viewport != none)
        {
            Viewport.LoadMapTransition();
        }
    }
    //return;    
}

reliable server function ServerSetPartyOwner(UniqueNetId PartyOwnerUniqueId)
{
    //return;    
}

reliable client simulated function ClientRegisterWithParty()
{
    local UniqueNetId PartyOwnerUniqueId;
    local OnlineGameSettings PartySettings;

    // End:0xD8
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0xC5
        if(PartySettings != none)
        {
            PartyOwnerUniqueId = PartySettings.OwningPlayerId;
        }
        ServerSetPartyOwner(PartyOwnerUniqueId);
    }
    //return;    
}

reliable server function ServerMaskAsGuest(bool bIsGuest)
{
    local PainPRI PRI;

    PRI = PainPRI(PlayerReplicationInfo);
    // End:0x55
    if(PRI != none)
    {
        PRI.bIsGuest = bIsGuest;
    }
    //return;    
}

simulated function UpdateGuestStatus()
{
    local LocalPlayer LP;

    LP = LocalPlayer(Player);
    // End:0x149
    if((((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && PlayerReplicationInfo != none)
    {
        // End:0x114
        if(OnlineSub.PlayerInterface.IsGuestLogin(byte(LP.ControllerId)))
        {
            PainPRI(PlayerReplicationInfo).bIsGuest = true;
            ServerMaskAsGuest(true);            
        }
        else
        {
            PainPRI(PlayerReplicationInfo).bIsGuest = false;
            ServerMaskAsGuest(false);
        }
    }
    //return;    
}

reliable client simulated function ClientSetPartyInviteFlags(bool bAllowInvites, bool bAllowJoinViaPresence, bool bAllowJoinViaPresenceFriendsOnly, int NumPublicConnections)
{
    local OnlineGameSettings PartySettings;
    local int PartyType;

    // End:0x2C9
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && IsPrimaryPlayer())
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x2C9
        if(PartySettings != none)
        {
            // End:0x11F
            if(PartySettings.GetStringSettingValue(88, PartyType))
            {
                // End:0x103
                if(PartyType == 0)
                {
                    bAllowJoinViaPresence = false;
                    bAllowJoinViaPresenceFriendsOnly = false;                    
                }
                else
                {
                    // End:0x11F
                    if(PartyType == 2)
                    {
                        bAllowJoinViaPresenceFriendsOnly = false;
                    }
                }
            }
            // End:0x2C9
            if((((PartySettings.bAllowInvites != bAllowInvites) || PartySettings.bAllowJoinViaPresence != bAllowJoinViaPresence) || PartySettings.bAllowJoinViaPresenceFriendsOnly != bAllowJoinViaPresenceFriendsOnly) || PartySettings.NumPublicConnections != NumPublicConnections)
            {
                PartySettings.bAllowInvites = bAllowInvites;
                PartySettings.bAllowJoinViaPresence = bAllowJoinViaPresence;
                PartySettings.bAllowJoinViaPresenceFriendsOnly = bAllowJoinViaPresenceFriendsOnly;
                PartySettings.NumPublicConnections = NumPublicConnections;
                OnlineSub.GameInterface.UpdateOnlineGame('Party', PartySettings, true);
            }
        }
    }
    //return;    
}

reliable client final simulated function ClientLoadGameTypeConfigs(string GameTypeExtension)
{
    // End:0x1E
    if((PersistentData != none) && bPersistentDataReadComplete)
    {
    }
    //return;    
}

reliable client simulated function ClientLogoutPartyHost(UniqueNetId PartyHostNetId)
{
    local PKLocalPlayer GLP;
    local int PartyType;
    local OnlineGameSettings OldParty;

    // End:0x3F0
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && !bIsReturningFromMatch)
    {
        OldParty = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x3F0
        if(((((OldParty != none) && PlayerReplicationInfo != none) && PlayerReplicationInfo.UniqueId != PartyHostNetId) && IsPrimaryPlayer()) && !bIsReturningToMainMenu)
        {
            NewPartySettings = new Class'PKPartyGameSettings';
            NewPartySettings.NumPublicConnections = OldParty.NumPublicConnections;
            NewPartySettings.NumPrivateConnections = OldParty.NumPrivateConnections;
            // End:0x210
            if(true)
            {
                NewPartySettings.bAllowInvites = false;
                NewPartySettings.bAllowJoinViaPresence = false;
                NewPartySettings.bAllowJoinViaPresenceFriendsOnly = false;                
            }
            else
            {
                NewPartySettings.bAllowInvites = OldParty.bAllowInvites;
                NewPartySettings.bAllowJoinViaPresence = OldParty.bAllowJoinViaPresence;
                NewPartySettings.bAllowJoinViaPresenceFriendsOnly = OldParty.bAllowJoinViaPresenceFriendsOnly;
            }
            GLP = PKLocalPlayer(Player);
            // End:0x3D5
            if((GLP != none) && ProfileSettings != none)
            {
                PartyType = int(PainGRI(WorldInfo.GRI).CurrentPartyType);
                // End:0x3A5
                if(PartyType == 0)
                {
                    NewPartySettings.bAllowJoinViaPresence = false;
                    NewPartySettings.bAllowJoinViaPresenceFriendsOnly = false;                    
                }
                else
                {
                    // End:0x3D5
                    if(PartyType == 1)
                    {
                        NewPartySettings.bAllowJoinViaPresenceFriendsOnly = false;
                    }
                }
            }
            CheckOkToDeletePartySession(OnDestroyPartyCompleteToRecreate);
        }
    }
    //return;    
}

function OnDestroyPartyCompleteToRecreate(name SessionName, bool bWasSuccessful)
{
    local LocalPlayer LP;

    // End:0x175
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyCompleteToRecreate);
        LP = LocalPlayer(Player);
        // End:0x175
        if((LP != none) && !bIsReturningToMainMenu)
        {
            OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreateNewPartyComplete);
            OnlineSub.GameInterface.CreateOnlineGame(byte(LP.ControllerId), 'Party', NewPartySettings);
        }
    }
    NewPartySettings = none;
    //return;    
}

function OnCreateNewPartyComplete(name SessionName, bool bWasSuccessful)
{
    local PKPlayerController PCIter;

    // End:0x121
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateNewPartyComplete);
        // End:0x121
        if(bWasSuccessful)
        {
            CreatePersistentPartyHostBeacon();
            // End:0xE2
            foreach LocalPlayerControllers(Class'PKPlayerController', PCIter)
            {
                PCIter.ClientRegisterWithParty();                
            }            
            OnlineSub.GameInterface.StartOnlineGame(SessionName);
        }
    }
    //return;    
}

reliable client simulated function ClientLogoutPersistentParty()
{
    local PKPersistentPartyBeaconHost HostPersistentPartyBeacon;

    // End:0x77
    if(((OnlineSub != none) && IsLocalPlayerController()) && IsPrimaryPlayer())
    {
        HostPersistentPartyBeacon = PKPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
        // End:0x77
        if(HostPersistentPartyBeacon != none)
        {
        }
    }
    //return;    
}

reliable client simulated function ClientLoginPersistentParty()
{
    local PKPersistentPartyBeaconHost HostPersistentPartyBeacon;

    // End:0x77
    if(((OnlineSub != none) && IsLocalPlayerController()) && IsPrimaryPlayer())
    {
        HostPersistentPartyBeacon = PKPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
        // End:0x77
        if(HostPersistentPartyBeacon != none)
        {
        }
    }
    //return;    
}

function CreatePersistentPartyHostBeacon()
{
    local LocalPlayer LP;
    local OnlineGameSettings PartySettings;
    local array<PlayerReservation> HostPartyMembers;
    local PKPersistentPartyBeaconHost HostPersistentPartyBeacon;

    LP = LocalPlayer(Player);
    // End:0x248
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        DestroyPersistentParty();
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x248
        if((PartySettings != none) && !PartySettings.bIsLanMatch)
        {
            // End:0x248
            if((IsLocalPlayerController()) && IsPrimaryPlayer())
            {
                HostPersistentPartyBeacon = new Class'PKPersistentPartyBeaconHost';
                HostPersistentPartyBeacon.BeaconName = 'PersistentPartyHost';
                OnlineSub.SetNamedInterface('PersistentPartyHostBeacon', HostPersistentPartyBeacon);
                HostPersistentPartyBeacon.InitHostBeacon(1, PartySettings.NumPublicConnections, PartySettings.NumPublicConnections, 'Party');
                GetHostPartyMembers(HostPartyMembers);
                HostPersistentPartyBeacon.AddPartyReservationEntry(PlayerReplicationInfo.UniqueId, HostPartyMembers, 0, true);
            }
        }
    }
    //return;    
}

function DestroyPersistentParty()
{
    local PKPersistentPartyBeaconHost HostPersistentPartyBeacon;

    // End:0xA1
    if(OnlineSub != none)
    {
        HostPersistentPartyBeacon = PKPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
        // End:0x78
        if(HostPersistentPartyBeacon != none)
        {
            HostPersistentPartyBeacon.DestroyBeacon();
        }
        OnlineSub.SetNamedInterface('PersistentPartyHostBeacon', none);
    }
    //return;    
}

function GetHostPartyMembers(out array<PlayerReservation> HostPartyMembers)
{
    local PKPlayerController PC;
    local LocalPlayer LP;
    local UniqueNetId PlayerID;
    local PlayerReservation PlayerRes;

    HostPartyMembers.Length = 0;
    // End:0x159
    foreach LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        LP = LocalPlayer(PC.Player);
        // End:0x158
        if((LP != none) && OnlineSub.PlayerInterface.GetUniquePlayerId(byte(LP.ControllerId), PlayerID))
        {
            PlayerRes.NetId = PlayerID;
            // End:0x11B
            if(PC.ProfileSettings != none)
            {                
            }
            // End:0x142
            if(PC.PersistentData != none)
            {                
            }
            HostPartyMembers.AddItem(PlayerRes);
        }        
    }    
    //return;    
}

delegate OnDestroyPartyComplete(name SessionName, bool bWasSuccessful)
{
    //return;    
}

function CheckOkToDeletePartySession(delegate<OnDestroyPartyComplete> DestroyPartyCompleteDelegate)
{
    local OnlineGameSettings PartySettings;
    local bool bWaiting;

    // End:0x199
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        DestroyPersistentParty();
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x199
        if(PartySettings != none)
        {
            bWaiting = true;
            // End:0x186
            if((int(PartySettings.GameState) != int(2)) && int(PartySettings.GameState) != int(4))
            {
                OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(DestroyPartyCompleteDelegate);
                OnlineSub.GameInterface.DestroyOnlineGame('Party');                
            }
            else
            {
                SetTimer(0.2500000, false, 'CheckOkToDeletePartySession');
            }
        }
    }
    // End:0x1C5
    if(!bWaiting)
    {
        OnDestroyPartyComplete('Party', true);
    }
    //return;    
}

simulated function SetRichPresenceString(int StringId)
{
    local LocalPlayer LP;
    local array<LocalizedStringSetting> StringSettings;
    local array<SettingsProperty> Properties;

    LP = LocalPlayer(Player);
    // End:0xE3
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), StringId, StringSettings, Properties);
    }
    //return;    
}

reliable client simulated function ClientSetRichPresenceString(int StringId)
{
    SetRichPresenceString(StringId);
    //return;    
}

reliable client simulated function ClientSetCampaignRichPresence(int characterIndex, int Chapter)
{
    local LocalPlayer LP;
    local array<LocalizedStringSetting> StringSettings;
    local array<SettingsProperty> Properties;
    local bool bIsCoop;

    LP = LocalPlayer(Player);
    // End:0x426
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        bIsCoop = ((WorldInfo.GRI != none) && WorldInfo.GRI.GameClass != none) && WorldInfo.GRI.GameClass != Class'PKGameSP';
        StringSettings.Length = ((bIsCoop) ? 2 : 1);
        StringSettings[0].AdvertisementType = 1;
        StringSettings[0].Id = 3;
        StringSettings[0].ValueIndex = Chapter;
        // End:0x225
        if(bIsCoop)
        {
            StringSettings[1].AdvertisementType = 1;
            StringSettings[1].Id = 10;
            StringSettings[1].ValueIndex = ((characterIndex == 0) ? 0 : 1);
        }
        // End:0x2A0
        if(!bIsCoop)
        {
            OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), 5, StringSettings, Properties);            
        }
        else
        {
            // End:0x3BD
            if(!WorldInfo.GRI.IsMultiplayerGame() || (PainGRI(WorldInfo.GRI) != none) && int(PainGRI(WorldInfo.GRI).CurrentPartyType) != int(1))
            {
                OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), 7, StringSettings, Properties);                
            }
            else
            {
                OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), 6, StringSettings, Properties);
            }
        }
    }
    //return;    
}

reliable client simulated function ClientSetMPRichPresenceString(byte StringId, PKTypes.EMultiGameMode MPType, byte MapNameId)
{
    local LocalPlayer LP;
    local array<LocalizedStringSetting> StringSettings;
    local array<SettingsProperty> Properties;

    LP = LocalPlayer(Player);
    // End:0x1D3
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        StringSettings.Length = 2;
        StringSettings[0].AdvertisementType = 1;
        StringSettings[0].Id = 7;
        StringSettings[0].ValueIndex = Max(int(MPType) - int(1), 0);
        StringSettings[1].AdvertisementType = 1;
        StringSettings[1].Id = 9;
        StringSettings[1].ValueIndex = int(MapNameId);
        OnlineSub.PlayerInterface.SetOnlineStatus(byte(LP.ControllerId), int(StringId), StringSettings, Properties);
    }
    //return;    
}

function OnCheckDLC(SeqAct_CheckDLC Action)
{
    // End:0x2B
    if(int(Action.DLC) == int(0))
    {
        return;
    }
    ClientCheckDLC(Action.DLC);
    //return;    
}

reliable client simulated function ClientCheckDLC(PKTypes.EDLCIdentifiers DLCID)
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x15E
    if((((int(DLCID) != int(0)) && int(IsDLCInstalled(DLCID)) == int(0)) && IsPrimaryPlayer()) && !WorldInfo.IsPlayInEditor())
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        ButtonAliases.AddItem('GenericAccept');
        UIManager.ShowUIMessage('ConnectionError', Localize("PKGFxUI_Menu_MainMenu", "DLC", "PKHDGame"), Localize("Errors", "NoDownload", "PKHDGame"), ButtonAliases, None,,,,, false, false);
        ReturnToMainMenu(false);
    }
    //return;    
}

simulated function PKTypes.EDLCIdentifiers GetCurrentLevelDLC()
{
    local SeqAct_CheckDLC DlcSeq;
    local array<SequenceObject> CheckDlcSeqences;
    local array<Sequence> RootSequences;
    local Sequence Seq;
    local int Idx;

    RootSequences = Class'Engine.WorldInfo'.static.GetWorldInfo().GetAllRootSequences();
    // End:0x10F
    foreach RootSequences(Seq)
    {
        Seq.FindSeqObjectsByClass(Class'SeqAct_CheckDLC', true, CheckDlcSeqences);
        Idx = 0;
        J0x93:

        // End:0x10E [Loop If]
        if(Idx < CheckDlcSeqences.Length)
        {
            DlcSeq = SeqAct_CheckDLC(CheckDlcSeqences[Idx]);
            // End:0x100
            if(DlcSeq != none)
            {                
                return DlcSeq.DLC;
            }
            Idx++;
            // [Loop Continue]
            goto J0x93;
        }        
    }    
    return 0;
    //return ReturnValue;    
}

simulated function bool CheckDLCInSpectator()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local PKTypes.EDLCIdentifiers DLCID;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    DLCID = GetCurrentLevelDLC();
    // End:0x74
    if(UIManager.IsUIMessageActive('SpecDlcInfo'))
    {
        return true;
    }
    // End:0x8A
    if(int(DLCID) == int(0))
    {
        return true;
    }
    // End:0x23B
    if(((int(IsDLCInstalled(DLCID)) == int(0)) && IsPrimaryPlayer()) && !WorldInfo.IsPlayInEditor())
    {
        CurrentDLCIndex = PKEngine(Class'Engine.Engine'.static.GetEngine()).DLCIdentifiersToDLCNum[int(DLCID)];
        ButtonAliases.AddItem('GenericOpenSteamStore');
        ButtonAliases.AddItem('GenericCancel');
        UIManager.ShowUIMessage('SpecDlcInfo', Localize("MessageBoxErrorStrings", "DLCRemovedAtMenuTitle", "PKHDGame"), Localize("MessageBoxErrorStrings", "DLCNeeded_Message", "PKHDGame"), ButtonAliases, OnMissingDLCFound, LocalPlayer(Player),,,,, false);
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool OnMissingDLCFound(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x5E
    if(SelectedInputAlias == 'GenericOpenSteamStore')
    {
        PKEngine(Class'Engine.Engine'.static.GetEngine()).ShowDLCStore(CurrentDLCIndex);
    }
    CurrentDLCIndex = -1;
    return true;
    //return ReturnValue;    
}

simulated function ClearDLCDownloadedStatus()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x3F [Loop If]
    if(I < 21)
    {
        DownladedDLCS[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function DebugDumpDLCStatus()
{
    //return;    
}

simulated function bool IsAnyCampaignDLCAvailable()
{
    return ((((int(IsDLCInstalled(9)) == int(1)) || int(IsDLCInstalled(10)) == int(1)) || int(IsDLCInstalled(12)) == int(1)) || int(IsDLCInstalled(13)) == int(1)) || int(IsDLCInstalled(14)) == int(1);
    //return ReturnValue;    
}

reliable client simulated function CheckDLCs()
{
    local OnlineSubsystemSteamworks SteamSub;

    SteamSub = OnlineSubsystemSteamworks(Class'Engine.GameEngine'.static.GetOnlineSubsystem());
    ClearDLCDownloadedStatus();
    // End:0x4D
    if(SteamSub == none)
    {
        return;
    }
    bIsJanuaryFreeWeekendSubScribed = !SteamSub.IsSubscribedApp(230010);
    DownladedDLCS[1] = SteamSub.IsDLCInstalled(219130);
    DownladedDLCS[2] = SteamSub.IsDLCInstalled(219131);
    DownladedDLCS[3] = SteamSub.IsDLCInstalled(219133);
    DownladedDLCS[4] = SteamSub.IsDLCInstalled(219135);
    DownladedDLCS[5] = SteamSub.IsDLCInstalled(219136);
    DownladedDLCS[6] = 1;
    DownladedDLCS[7] = 1;
    DownladedDLCS[8] = SteamSub.IsDLCInstalled(229190);
    DownladedDLCS[9] = SteamSub.IsDLCInstalled(229210);
    DownladedDLCS[10] = SteamSub.IsDLCInstalled(229230);
    DownladedDLCS[11] = SteamSub.IsDLCInstalled(229250);
    DownladedDLCS[12] = SteamSub.IsDLCInstalled(229270);
    DownladedDLCS[13] = SteamSub.IsDLCInstalled(229290);
    DownladedDLCS[14] = SteamSub.IsDLCInstalled(229310);
    DownladedDLCS[15] = 1;
    DownladedDLCS[16] = 1;
    DownladedDLCS[17] = 1;
    DownladedDLCS[18] = 1;
    DownladedDLCS[19] = 1;
    DownladedDLCS[20] = 1;
    DownladedDLCS[21] = 1;
    DownladedDLCS[22] = 1;
    DownladedDLCS[23] = 1;
    DownladedDLCS[24] = 1;
    DownladedDLCS[25] = 1;
    DownladedDLCS[26] = 1;
    DownladedDLCS[27] = 1;
    ServerUpdateDLCStatusInPRI(3, int(DownladedDLCS[3]) == int(1));
    //return;    
}

reliable server function ServerUpdateDLCStatusInPRI(PKTypes.EDLCIdentifiers DLCID, bool bUnlocked)
{
    DownladedDLCS[int(DLCID)] = ((bUnlocked) ? 1 : 0);
    //return;    
}

simulated function byte IsDLCInstalled(PKTypes.EDLCIdentifiers DLCID)
{
    return DownladedDLCS[int(DLCID)];
    //return ReturnValue;    
}

simulated function bool IsFreeJanuaryWeekendSubscribed()
{
    return bIsJanuaryFreeWeekendSubScribed;
    //return ReturnValue;    
}

reliable client simulated function ClientCheckIfIsJanuaryWeekendSubscribed(int ChapterNum)
{
    // End:0x70
    if((IsFreeJanuaryWeekendSubscribed()) && ChapterNum > 4)
    {
        PKGameViewportClient(LocalPlayer(Player).ViewportClient).ShowJanuarySubscriptionWindow();
        ReturnToMainMenu(false);
    }
    //return;    
}

simulated function bool CheckIfUserHasRightsToThatSpecificMap(string MapName)
{
    local bool bResult;

    bResult = true;
    // End:0x4D
    if(InStr(MapName, "DLC_1") != -1)
    {
        bResult = int(IsDLCInstalled(8)) == int(1);        
    }
    else
    {
        // End:0x8E
        if(InStr(MapName, "DLC_2") != -1)
        {
            bResult = int(IsDLCInstalled(9)) == int(1);            
        }
        else
        {
            // End:0xCF
            if(InStr(MapName, "DLC_3") != -1)
            {
                bResult = int(IsDLCInstalled(10)) == int(1);                
            }
            else
            {
                // End:0x110
                if(InStr(MapName, "DLC_4") != -1)
                {
                    bResult = int(IsDLCInstalled(11)) == int(1);                    
                }
                else
                {
                    // End:0x151
                    if(InStr(MapName, "DLC_5") != -1)
                    {
                        bResult = int(IsDLCInstalled(12)) == int(1);                        
                    }
                    else
                    {
                        // End:0x192
                        if(InStr(MapName, "DLC_6") != -1)
                        {
                            bResult = int(IsDLCInstalled(13)) == int(1);                            
                        }
                        else
                        {
                            // End:0x1D0
                            if(InStr(MapName, "DLC_7") != -1)
                            {
                                bResult = int(IsDLCInstalled(14)) == int(1);
                            }
                        }
                    }
                }
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

function OnDLCDownloadComplete(int AppID)
{
    CheckDLCs();
    //return;    
}

function OnLobbyInviteDelegate(UniqueNetId LobbyId, UniqueNetId FriendId, bool bAccepted)
{
    local OnlineLobbyInterfaceSteamworks LobbyInterface;

    // End:0x11
    if(OnlineSub == none)
    {
        return;
    }
    LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    // End:0x53
    if(LobbyInterface == none)
    {
        return;
    }
    // End:0xC5
    if(bAccepted)
    {
        LobbyInterface.AddJoinLobbyCompleteDelegate(OnJoinLobbyComplete);
        // End:0xC5
        if(LobbyInterface.JoinLobby(LobbyId))
        {
            ClientShowLevelLoadingMovie();
        }
    }
    //return;    
}

function OnJoinLobbyComplete(bool bWasSuccessful, const out array<ActiveLobbyInfo> LobbyList, int LobbyIndex, UniqueNetId InLobbyUID, string Error)
{
    local string URL, ServerSteamID;
    local ActiveLobbyInfo CurrentLobby;

    LobbyUID = InLobbyUID;
    OnlineSubsystemSteamworks(OnlineSub).LobbyInterface.ClearJoinLobbyCompleteDelegate(OnJoinLobbyComplete);
    // End:0xF3
    if(bWasSuccessful)
    {
        CurrentLobby = LobbyList[LobbyIndex];
        ServerSteamID = GetActiveLobbyData(CurrentLobby, "STEAMID");
        URL = "open steam." $ ServerSteamID;        
        ConsoleCommand(URL);        
    }
    else
    {
        ClientStopLevelLoadingMovie();
    }
    //return;    
}

reliable client simulated function ClientSetSoundMode(name NewMode)
{
    SetSoundMode(NewMode);
    //return;    
}

reliable client simulated function ClientSetAllPlayerPawnsCustomTimeDilation(float InCustomTimeDilation)
{
    local EvilPawn EPawn;

    // End:0x83
    foreach WorldInfo.AllPawns(Class'EvilGame.EvilPawn', EPawn)
    {
        // End:0x82
        if(EPawn.PlayerReplicationInfo != none)
        {
            EPawn.CustomTimeDilation = InCustomTimeDilation;
        }        
    }    
    //return;    
}

exec function FOV(float F)
{
    // End:0xA6
    if(((F >= 60.0000000) || int(WorldInfo.NetMode) == int(NM_Standalone)) || PlayerReplicationInfo.bOnlySpectator)
    {
        OnFootDefaultFOV = FClamp(F, 60.0000000, 120.0000000);
        // End:0xA3
        if(Vehicle(Pawn) == none)
        {
            FixFOV();
        }
        SaveConfig();
    }
    //return;    
}

function FixFOV()
{
    // End:0x21
    if(OnFootDefaultFOV < float(60))
    {
        OnFootDefaultFOV = 90.0000000;
    }
    OnFootDefaultFOV = FClamp(OnFootDefaultFOV, 60.0000000, 120.0000000);
    FOVAngle = OnFootDefaultFOV;
    DesiredFOV = OnFootDefaultFOV;
    DefaultFOV = OnFootDefaultFOV;
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
    // End:0x34
    if(VarName == 'Pawn')
    {
        RefreshPawnParamsFromPC();
    }
    //return;    
}

exec function ShowMarketPlace2(int CategoryMask, int OfferId)
{
    local OnlinePlayerInterfaceEx PlayerIntEx;

    PlayerIntEx = OnlineSub.PlayerInterfaceEx;
    // End:0xA3
    if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
    {
        PlayerIntEx.ShowContentMarketplaceUI(byte(PKLocalPlayer(Player).ControllerId), CategoryMask, OfferId);
    }
    //return;    
}

exec function DumpWorkshopProviders()
{
    local int I;
    local array<UDKUIResourceDataProvider> ProviderList;

    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'PKWorkshopPackageResourceDataProvider', ProviderList);
    I = 0;
    J0x3C:

    // End:0x94 [Loop If]
    if(I < ProviderList.Length)
    {
        PKWorkshopPackageResourceDataProvider(ProviderList[I]).Dump();
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    //return;    
}

exec function DumpMapProviders()
{
    local int I;
    local array<UDKUIResourceDataProvider> ProviderList;

    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', ProviderList);
    I = 0;
    J0x3C:

    // End:0x62 [Loop If]
    if(I < ProviderList.Length)
    {
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    //return;    
}

state Dead
{
    ignores StartFire;

    function RespawnDeadCoopPlayer()
    {
        local EvilExplosionActorReplicated Explosion;

        Explosion = Spawn(Class'EvilGame.EvilExplosionActorReplicated', self,, Location);
        Explosion.InstigatorController = self;
        Explosion.Explode(CoopRespawnExplosionTemplate);
        SetTimer(1.0000000, false, 'ServerRestartPlayer');
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x67
        if(((NextStateName == 'None') && LocalPlayer(Player) == none) && IsTimerActive('ProcessGameOver'))
        {
            ProcessGameOver();
        }
        ClearTimer('ProcessGameOver');
        //return;        
    }
Begin:

    stop;                
}

state CoopGhost extends PlayerWalking
{
    ignores StartFire, TakeDamage, NextWeapon, PrevWeapon;

    function OnSoulTaken()
    {
        PainGFxHud(PainGFxHudWrapper(myHUD).HudMovie).FlashSoulCollectedInGhost();
        // End:0xFA
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0xFA
            if(PKGameCooperative(WorldInfo.Game) != none)
            {
                SoulsCollectedInGhost += 1;
                TimeRemainingInGhost -= PKGameCooperative(WorldInfo.Game).SoulTakeTimeReductionToRespawn;
                // End:0xFA
                if(TimeRemainingInGhost < float(1))
                {
                    TimeRemainingInGhost = 1.0000000;
                }
            }
        }
        //return;        
    }

    simulated event BeginState(name PreviousStateName)
    {
        local PKRailCar_Rollercoaster_Base Rollercoaster;

        super.BeginState(PreviousStateName);
        SoulsCollectedInGhost = 0;
        MyEvilPawn.PushState('Ghost');
        // End:0xAB
        if(int(Role) == int(ROLE_Authority))
        {
            EnableGhostEffect();
            TimeRemainingInGhost = PKGameCooperative(WorldInfo.Game).TimeToRespawn;
        }
        // End:0x10C
        if(PainGRI_SP(WorldInfo.GRI).ChapterNum == 11)
        {
            // End:0x10B
            foreach DynamicActors(Class'PKRailCar_Rollercoaster_Base', Rollercoaster)
            {
                // End:0x10B
                break;                
            }            
        }
        // End:0x173
        if((Rollercoaster != none) && Rollercoaster.IsInState('Riding'))
        {
            Rollercoaster.ReattachCoopGhost(PKPlayerPawn(MyEvilPawn));
        }
        //return;        
    }

    event ContinuedState()
    {
        // End:0x1F
        if(TimeRemainingInGhost <= 0.0000000)
        {
            DisableGhost();
            return;
        }
        // End:0x64
        if(MyEvilPawn.IsInState('Ghost'))
        {
            MyEvilPawn.PopState();
        }
        MyEvilPawn.PushState('Ghost');
        // End:0xAB
        if(int(Role) == int(ROLE_Authority))
        {
            EnableGhostEffect();
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x7D
        if(MyEvilPawn.IsInState('Ghost', true))
        {
            // End:0x7D
            if(MyEvilPawn.IsInState('Ghost'))
            {
                MyEvilPawn.PopState();
            }
        }
        // End:0x9B
        if(int(Role) == int(ROLE_Authority))
        {
            DisableGhostEffect();
        }
        // End:0x185
        if((((PainGRI_SP(WorldInfo.GRI).ChapterNum == 11) && MyEvilPawn != none) && PKRailCar_Rollercoaster_Base(MyEvilPawn.ClampedBase) != none) && PKRailCar_Rollercoaster_Base(MyEvilPawn.ClampedBase).IsInState('Riding'))
        {
            GotoState('Rollercoaster');
            ClientGotoState('Rollercoaster');
        }
        //return;        
    }

    function RespawnInSamePlace()
    {
        DisableGhost();
        //return;        
    }

    function RespawnInCheckpoint()
    {
        local NavigationPoint TeleportPoint;
        local int TeamNum;

        TeamNum = (((PlayerReplicationInfo == none) || PlayerReplicationInfo.Team == none) ? 255 : PlayerReplicationInfo.Team.TeamIndex);
        TeleportPoint = WorldInfo.Game.FindPlayerStart(self, byte(TeamNum));
        // End:0x106
        if(TeleportPoint != none)
        {
            Pawn.SetLocation(TeleportPoint.Location);
        }
        DisableGhost();
        //return;        
    }

    function DisableGhost()
    {
        // End:0x20
        if(!IsInState('Demon'))
        {
            GotoState('PlayerWalking');
        }
        //return;        
    }

    function bool IsGhost()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function UpdateRotation(float DeltaTime)
    {
        // End:0x99
        if(((PainGRI_SP(WorldInfo.GRI).ChapterNum == 11) && MyEvilPawn != none) && PKRailCar_Rollercoaster_Base(MyEvilPawn.ClampedBase) != none)
        {
            UpdateRotationOnRollercoaster(DeltaTime);            
        }
        else
        {
            super(UTConsolePlayerController).UpdateRotation(DeltaTime);
        }
        //return;        
    }

    function UnPossess()
    {
        // End:0x5F
        if((PKPlayerPawn(MyEvilPawn) != none) && MyEvilPawn.IsInState('Ghost'))
        {
            MyEvilPawn.PopState();
        }
        DisableGhost();
        super(PlayerController).UnPossess();
        //return;        
    }
Begin:

    stop;                
}

state Demon extends PlayerWalking
{
    ignores QuickCustom1Fire, QuickCustom2Fire, RocketJump, ForwardRocketJump, NextWeapon, PrevWeapon, 
	    ThrowWeapon;

    event PushedState()
    {
        // End:0xA6
        if(IsLocalPlayerController())
        {
            EnableDemonFX(true);
            PlaySound(DemonModeStartCue, true, true, true,, true);
            // End:0x87
            if(DemonModeLoopComponent == none)
            {
                DemonModeLoopComponent = CreateAudioComponent(DemonModeLoopCue, true, true, false);
                DemonModeLoopComponent.bAlwaysPlay = true;                
            }
            else
            {
                DemonModeLoopComponent.Play();
            }
        }
        MyEvilPawn.PushState('Demon');
        // End:0x147
        if(PKGame(WorldInfo.Game) != none)
        {
            PKGame(WorldInfo.Game).BulletTimeBlendIn(DemonBulletTimeMultiplier, 0.0000000);
        }
        //return;        
    }

    event PoppedState()
    {
        // End:0x60
        if(IsLocalPlayerController())
        {
            EnableDemonFX(false);
            // End:0x48
            if(DemonModeLoopComponent != none)
            {
                DemonModeLoopComponent.Stop();
            }
            PlaySound(DemonModeStopCue, true, true, true,, true);
        }
        // End:0xA5
        if(MyEvilPawn.IsInState('Demon'))
        {
            MyEvilPawn.PopState();
        }
        // End:0x114
        if(PKGame(WorldInfo.Game) != none)
        {
            PKGame(WorldInfo.Game).BulletTimeBlendOut(0.0000000);
        }
        FixFOV();
        SetFOV(DefaultFOV);
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local PKWeap_Demon DW;

        super(PlayerController).PlayerTick(DeltaTime);
        // End:0xDB
        if(IsLocalPlayerController())
        {
            DW = PKWeap_Demon(MyEvilPawn.Weapon);
            // End:0xDB
            if(DW != none)
            {
                PKPostProcessManager(GetPPManager()).UpdateDemonWarp(DW.GetTimerCount('RefireCheckTimer'), DW.GetTimerRate('RefireCheckTimer'));
            }
        }
        SetFOV(120.0000000 + (5.0000000 * Sin(WorldInfo.AudioTimeSeconds * 3.0000000)));
        //return;        
    }

    simulated function bool IsDemon()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function ToggleDemon()
    {
        PopState();
        // End:0x24
        if(!IsLocalPlayerController())
        {
            ClientToggleDemon();
        }
        //return;        
    }

    function Possess(Pawn inPawn, bool bVehicleTransition)
    {
        super(UTPlayerController).Possess(inPawn, bVehicleTransition);
        // End:0x87
        if((PKPlayerPawn(MyEvilPawn) != none) && !MyEvilPawn.IsInState('Demon'))
        {
            MyEvilPawn.PushState('Demon');
        }
        //return;        
    }

    function UnPossess()
    {
        // End:0x5F
        if((PKPlayerPawn(MyEvilPawn) != none) && MyEvilPawn.IsInState('Demon'))
        {
            MyEvilPawn.PopState();
        }
        super(PlayerController).UnPossess();
        //return;        
    }
    stop;    
}

state WeaponModifier extends PlayerWalking
{
    function PawnDied(Pawn inPawn)
    {
        global.PawnDied(inPawn);
        DisableWeaponModifier();
        //return;        
    }
    stop;    
}

simulated state Rollercoaster extends PlayerWalking
{
    simulated function UpdateRotation(float DeltaTime)
    {
        UpdateRotationOnRollercoaster(DeltaTime);
        //return;        
    }
    stop;    
}

state TornadoRotate extends PlayerWalking
{
    function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
    {
        super(PlayerController).ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
        out_ViewRotation.Yaw += int((float(180) * DeltaTime) * 182.0444000);
        //return;        
    }
Begin:

    Sleep(RandRange(0.2500000, 0.7500000));
    PopState();
    stop;        
}

simulated state ThrownByGiant extends PlayerWalking
{
    ignores ProcessMove;

    simulated event Landed(Vector HitNormal, Actor FloorActor)
    {
        super(Actor).Landed(HitNormal, FloorActor);
        MyEvilPawn.AirControl = MyEvilPawn.DefaultAirControl;
        PopState();
        //return;        
    }
    stop;    
}

defaultproperties
{
    DemonVisionPPChain=PostProcessChain'PP_PKHD.DemonVisionPPChain'
    DemonVisionPPChain_Xbox=PostProcessChain'PP_PKHD.DemonVisionPPChain_X360'
    DemonBulletTimeMultiplier=0.5000000
    DemonModeStartCue=SoundCue'a_PlayerDemon.Cue.demon-start'
    DemonModeStopCue=SoundCue'a_PlayerDemon.Cue.demon-stop'
    DemonModeLoopCue=SoundCue'a_PlayerDemon.Cue.demon-loop'
    CantUseSoundCue=SoundCue'a_Cards.Cue.card-cannot_use'
    CanUseSoundCue=SoundCue'a_Cards.Cue.golden-card-use'
    GhostPPChain=PostProcessChain'PP_PKHD.GhostPPChain'
    CoopRespawnExplosionTemplate=EvilExplosion'FX_Explosions.ar_player_coop_explosion'
    HUDScale=0.8000000
    GlobalHeadBob=0.0200000
    GlobalWeaponBobDamping=1.3000000
    CustomWeaponMapping[0]=(WeaponClass=Class'PKWeap_Painkiller_Base',bAltMode=false)
    CustomWeaponMapping[1]=(WeaponClass=Class'PKWeap_Painkiller_Base',bAltMode=true)
    CustomWeaponMapping[2]=(WeaponClass=Class'PKWeap_Shotgun_Base',bAltMode=false)
    CustomWeaponMapping[3]=(WeaponClass=Class'PKWeap_Shotgun_Base',bAltMode=true)
    CustomWeaponMapping[4]=(WeaponClass=Class'PKWeap_Stakegun_Base',bAltMode=false)
    CustomWeaponMapping[5]=(WeaponClass=Class'PKWeap_Stakegun_Base',bAltMode=true)
    CustomWeaponMapping[6]=(WeaponClass=Class'PKWeap_Chaingun_Base',bAltMode=true)
    CustomWeaponMapping[7]=(WeaponClass=Class'PKWeap_Chaingun_Base',bAltMode=false)
    CustomWeaponMapping[8]=(WeaponClass=Class'PKWeap_Electrodriver_Base',bAltMode=true)
    CustomWeaponMapping[9]=(WeaponClass=Class'PKWeap_Electrodriver_Base',bAltMode=false)
    CustomWeaponMapping[10]=(WeaponClass=Class'PKWeap_SMG_Base',bAltMode=false)
    CustomWeaponMapping[11]=(WeaponClass=Class'PKWeap_SMG_Base',bAltMode=true)
    CustomWeaponMapping[12]=(WeaponClass=Class'PKWeap_Boltgun_Base',bAltMode=false)
    CustomWeaponMapping[13]=(WeaponClass=Class'PKWeap_Boltgun_Base',bAltMode=true)
    CustomWeaponMapping[14]=(WeaponClass=Class'PKWeap_SoulReaper_Base',bAltMode=false)
    CustomWeaponMapping[15]=(WeaponClass=Class'PKWeap_SoulReaper_Base',bAltMode=true)
    CustomWeaponMapping[16]=(WeaponClass=Class'PKWeap_DLC1_Base',bAltMode=false)
    CustomWeaponMapping[17]=(WeaponClass=Class'PKWeap_DLC1_Base',bAltMode=true)
    CustomWeaponMapping[18]=(WeaponClass=Class'PKWeap_DLC2_Base',bAltMode=false)
    CustomWeaponMapping[19]=(WeaponClass=Class'PKWeap_DLC2_Base',bAltMode=true)
    CustomWeaponMapping[20]=(WeaponClass=Class'PKWeap_DLC3_Base',bAltMode=false)
    CustomWeaponMapping[21]=(WeaponClass=Class'PKWeap_DLC3_Base',bAltMode=true)
    CustomWeaponMapping[22]=(WeaponClass=Class'PKWeap_DLC4_Base',bAltMode=false)
    CustomWeaponMapping[23]=(WeaponClass=Class'PKWeap_DLC4_Base',bAltMode=true)
    CustomWeaponMapping[24]=(WeaponClass=Class'PKWeap_DLC5_Base',bAltMode=false)
    CustomWeaponMapping[25]=(WeaponClass=Class'PKWeap_DLC5_Base',bAltMode=true)
    CustomWeaponMapping[26]=(WeaponClass=Class'PKWeap_DLC6_Base',bAltMode=false)
    CustomWeaponMapping[27]=(WeaponClass=Class'PKWeap_DLC6_Base',bAltMode=true)
    CustomWeaponMapping[28]=(WeaponClass=Class'PKWeap_DLC7_Base',bAltMode=false)
    CustomWeaponMapping[29]=(WeaponClass=Class'PKWeap_DLC7_Base',bAltMode=true)
    CustomWeaponMapping[30]=(WeaponClass=Class'PKWeap_DLC8_Base',bAltMode=false)
    CustomWeaponMapping[31]=(WeaponClass=Class'PKWeap_DLC8_Base',bAltMode=true)
    CustomWeaponMapping[32]=(WeaponClass=Class'PKWeap_DLC9_Base',bAltMode=false)
    CustomWeaponMapping[33]=(WeaponClass=Class'PKWeap_DLC9_Base',bAltMode=true)
    CustomWeaponMapping[34]=(WeaponClass=Class'PKWeap_DLC10_Base',bAltMode=false)
    CustomWeaponMapping[35]=(WeaponClass=Class'PKWeap_DLC10_Base',bAltMode=true)
    BulletTimeSoundMode=SoundMode'PP_PKHD.BulletTimeSoundMode'
    AlienwareBlinkSpeed=0.0500000
    AlienwareBlinkDuration=1.0000000
    ResurrectSound=SoundCue'a_Specials.Cue.resurrection'
    // Reference: EvilSceneCaptureHighlightComponent'Default__PKPlayerController.HighlightComponent'
    // Archetype: EvilSceneCaptureHighlightComponent'EvilGame.Default__EvilPlayerController.HighlightComponent'
    begin object name="HighlightComponent"
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    PPManagerClass=Class'PKPostProcessManager'
    HitEffectsClass=Class'PKPlayerHitEffects'
    PointOfInterestLookatInterpSpeed=7.0000000
    CheckpointSavedString="Saving content. Please don't turn off your computer."
    CheckpointLoadedString="Checkpoint Loaded"
    IconFriend=(Texture=Texture2D'PKHD_HUD.t_playericon',UL=64.0000000,VL=64.0000000)
    IconEnemy=(Texture=Texture2D'PKHD_HUD.t_playericon',UL=64.0000000,VL=64.0000000)
    // Reference: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    FOVAngle=95.0000000
    DesiredFOV=95.0000000
    DefaultFOV=95.0000000
    CheatClass=Class'PKCheatManager'
    InputClass=Class'PKPlayerInput'
    // Reference: CylinderComponent'Default__PKPlayerController.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}