class AdvPRI extends EvilPlayerReplicationInfo
    native
    hidecategories(Navigation,Movement,Collision);

const BLESSINGS_AMOUNT = 7;

struct native PossibleInputHijackInfo
{
    var EvilPawn Target;
    var float TargetDistance;
    var float ExpiryTime;

    structdefaultproperties
    {
        Target=none
        TargetDistance=0.0000000
        ExpiryTime=0.0000000
    }
};

var float LastComboTime;
var float ElapsedComboTime;
var float HighestMiltiplierStat;
var int CountDown;
var int TreasuresColected;
var int TreasuresPerTypeColected[ETreasureType];
var int TreasuresPerTypeAvailable[ETreasureType];
var int ItemsCount[EAdvItemType];
var int ActiveBlessings[7];
var bool bIsDevastator;
var bool bIsMummy;
var bool bIsAlive;
var bool bWantToChangeTeam;
var bool bQuadDamage;
var bool bInLiveParty;
var bool bIsGuest;
var bool bIsTalking;
var bool bSubmittedVote;
var bool bIsTournamentSpectator;
var bool bCanBeRescued;
var int TeamMultiplayerTreasuresColected;
var int TotalTeamMultiplayerTreasuresColected;
var int EnemyMultiplayerTreasuresColected;
var int TotalEnemyMultiplayerTreasuresColected;
var int RescuesCount;
var int WavesCount;
var int SurvivalMummiesKilledStat;
var int SurvivalTreetersKilledStat;
var int SurvivalBossesKilledStat;
var int SurvivalTrapKillsStat;
var AdvBlessingManager BlessingManager;
var PossibleInputHijackInfo PossibleInputHijacks[ECombatActionType];
var repnotify int KillStrikePoints[EActivationType];
var class<EvilDifficultySettings> Difficulty;
var int AmmoFound;
var int BonusItems;
var int SecretsFound;
var int MonstersKilled;
var int DestroyedObjects;
var float ScoreLMS;
var int KillsLMS;
var int DeathsLMS;
var int RescuesLMS;
var transient int StatOfScoreFlag;
var transient int StatsOfReturnedFlag;
var protected transient int StatOfDeaths;
var protected transient int StatOfKills;
var protected transient int TotalKillsWritten;
var protected transient int TotalDeathsWritten;
var protected transient int TotalScoreFlagWritten;
var protected transient int TotalScoreReturnFlagWritten;
var AdvCharacterStore CharacterStore;
var repnotify UniqueNetId PartyOwnerUniqueId;
var float LastTalkTime;
var int PlayerLevel;
var int PlayerSkill;
var int XP;
var int BaseXP;
var int Assists;
var int NextSpawnClassIndex;
var int NextSpawnPrimaryWeaponIndex;
var int NextSpawnSecondaryWeaponIndex;
var class<EvilFamilyInfoBase> MummyCharClassInfo;
var class<EvilFamilyInfoBase> DevastatorCharClassInfo;
var int DLCFlag;
var int BonusScore;

replication
{
    // Pos:0x000
    if(bNetDirty
        ActiveBlessings, Assists, 
        DLCFlag, DevastatorCharClassInfo, 
        EnemyMultiplayerTreasuresColected, KillStrikePoints, 
        MummyCharClassInfo, NextSpawnClassIndex, 
        NextSpawnPrimaryWeaponIndex, NextSpawnSecondaryWeaponIndex, 
        PlayerLevel, PossibleInputHijacks, 
        SurvivalBossesKilledStat, SurvivalMummiesKilledStat, 
        SurvivalTrapKillsStat, SurvivalTreetersKilledStat, 
        TeamMultiplayerTreasuresColected, TotalEnemyMultiplayerTreasuresColected, 
        TotalTeamMultiplayerTreasuresColected, WavesCount, 
        XP, bCanBeRescued, 
        bIsDevastator, bIsMummy, 
        bIsTournamentSpectator, bWantToChangeTeam;

    // Pos:0x00A
    if(bNetDirty && !WorldInfo.GRI.bMatchHasBegun
        CountDown;

    // Pos:0x04F
    if(bNetDirty
        DeathsLMS, Difficulty, 
        KillsLMS, PartyOwnerUniqueId, 
        RescuesCount, RescuesLMS, 
        ScoreLMS, StatOfDeaths, 
        StatOfKills, StatOfScoreFlag, 
        StatsOfReturnedFlag, bIsAlive, 
        bQuadDamage;

    // Pos:0x059
    if(bNetOwner
        AmmoFound, BonusItems, 
        DestroyedObjects, MonstersKilled, 
        SecretsFound;
}

simulated event PostBeginPlay()
{
    CharacterStore = new (self) Class'AdvCharacterStore';
    CharacterStore.__LoadComplete__Delegate = FamilyInfoLoaded;
    super(PlayerReplicationInfo).PostBeginPlay();
    //return;    
}

reliable server function InitXP(int NewBaseXP)
{
    BaseXP = NewBaseXP;
    PlayerLevel = CalculatePlayerLevel(BaseXP);
    //return;    
}

static function int CalculatePlayerLevel(int PlayerXP)
{
    local int I, Level;

    I = 0;
    J0x0B:

    // End:0x92 [Loop If]
    if(I < Class'AdvClassInfo_MP_Base'.default.LevelThresholds.Length)
    {
        // End:0x84
        if(PlayerXP < Class'AdvClassInfo_MP_Base'.default.LevelThresholds[I])
        {
            Level = I;
            // [Explicit Break]
            goto J0x92;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x92:

    // End:0xCA
    if(Level == 0)
    {
        Level = Class'AdvClassInfo_MP_Base'.default.LevelThresholds.Length;
    }
    return Level;
    //return ReturnValue;    
}

function SeamlessTravelTo(PlayerReplicationInfo NewPRI)
{
    super.SeamlessTravelTo(NewPRI);
    AdvPRI(NewPRI).bIsTournamentSpectator = bIsTournamentSpectator;
    // End:0xA2
    if(bIsTournamentSpectator)
    {
        AdvGameMP_Base(WorldInfo.Game).TurnInTournamentSpectator(AdvPRI(NewPRI));
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'PartyOwnerUniqueId')
    {
        RegisterPlayerWithParty();        
    }
    else
    {
        // End:0x1EF
        if(VarName == 'KillStrikePoints')
        {
            // End:0x12D
            if(((class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none) && AdvPlayerController(Owner) != none) && AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD) != none)
            {
                AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD).HudMovie).SetKillStreakKillCount(KillStrikePoints[1]);                
            }
            else
            {
                // End:0x1EC
                if((AdvPlayerController(Owner) != none) && AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD) != none)
                {
                    AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD).HudMovie).SetKillStreakKillCount(KillStrikePoints[0]);
                }
            }            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}

reliable server function SetNextSpawnInfo(int NewClassIndex, optional int MainWeaponIndex = 0, optional int SecondWeaponIndex = 0)
{
    NextSpawnClassIndex = NewClassIndex;
    // End:0x53
    if(NewClassIndex >= 5)
    {
        NextSpawnPrimaryWeaponIndex = MainWeaponIndex;
        NextSpawnSecondaryWeaponIndex = SecondWeaponIndex;
    }
    //return;    
}

reliable server function BecomeTournamentSpectator()
{
    bIsTournamentSpectator = true;
    //return;    
}

simulated function GotInvalidCharClassInfoAndInformServerAboutIt()
{
    local AdvPlayerController PC;

    // End:0x43
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        PC.ServerPleaseSendMeInfoWhichSkinLoad(self);
        // End:0x43
        break;        
    }    
    //return;    
}

simulated function FamilyInfoLoaded(class<AdvFamilyInfoBase> LoadedClass)
{
    local AdvPlayerController PC;
    local UTPawn UTP;

    // End:0x83
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        // End:0x7F
        foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
        {
            PC.ServerFamilyInfoLoaded(PathName(LoadedClass), self);
            // End:0x7F
            break;            
        }                
    }
    else
    {
        // End:0x168
        foreach WorldInfo.AllPawns(Class'EvilGame.UTPawn', UTP)
        {
            // End:0x167
            if((UTP.PlayerReplicationInfo == self) || (UTP.DrivenVehicle != none) && UTP.DrivenVehicle.PlayerReplicationInfo == self)
            {
                UTP.SetCharacterClassFromInfo(LoadedClass);
            }            
        }        
        SetCharClassInfo(LoadedClass);
    }
    //return;    
}

// Export UAdvPRI::execMarkCharClassInfoAsDirtyOrResetActorChannel(FFrame&, void* const)
reliable server native function MarkCharClassInfoAsDirtyOrResetActorChannel(string ClassName);

simulated function SetupPlayerCharacter(int characterIndex)
{
    // End:0xAB
    if((characterIndex >= 0) && characterIndex < CharacterStore.default.FamilyInfosToPackages.Length)
    {
        CharacterSkinIndex = characterIndex;
        CharacterStore.LoadFamilyInfoClass(CharacterStore.default.FamilyInfosToPackages[characterIndex].FamilyInfoPath);
    }
    //return;    
}

simulated function UnregisterPlayerFromSession()
{
    // End:0x19
    if(!bFromPreviousLevel)
    {
        super(PlayerReplicationInfo).UnregisterPlayerFromSession();
    }
    UnregisterPlayerFromParty();
    //return;    
}

simulated function RegisterPlayerWithParty()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings PartySettings;
    local UniqueNetId ZeroId;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x267
    if((((((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && PartyOwnerUniqueId != ZeroId) && UniqueId != ZeroId) && AdvPlayerController(Owner) != none) && !AdvPlayerController(Owner).IsPrimaryPlayer())
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x1D6
        if((PartySettings != none) && PartySettings.OwningPlayerId == PartyOwnerUniqueId)
        {
            ScriptTrace();
            OnlineSub.GameInterface.RegisterPlayer('Party', UniqueId, true);
        }
        // End:0x267
        if((AdvPlayerController(Owner) != none) && !AdvPlayerController(Owner).IsPartyLeader())
        {
            AdvPlayerController(Owner).ClientSetPartyInviteFlags(false, false, false, PartySettings.NumPublicConnections, false);
        }
    }
    //return;    
}

simulated function UnregisterPlayerFromParty()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings PartySettings;
    local UniqueNetId ZeroId;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x12D
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && UniqueId != ZeroId)
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        // End:0x12D
        if(PartySettings != none)
        {
            OnlineSub.GameInterface.UnregisterPlayer('Party', UniqueId);
        }
    }
    //return;    
}

function AddTreasure(string TreasureID, AdvTypes.ETreasureType TreasureType)
{
    local AdvPlayerController PC;

    TreasuresColected++;
    TreasuresPerTypeColected[int(TreasureType)]++;
    TreasuresPerTypeAvailable[int(TreasureType)]++;
    PC = AdvPlayerController(Owner);
    // End:0xB7
    if(PC != none)
    {
        PC.SetAlienFxLight(0, 255, 150, 0, 2, 0, AdvPlayerController(Owner).afterPickTreasureDuration);
    }
    //return;    
}

function AddItem(AdvTypes.EAdvItemType ItemType, optional int Count = 1)
{
    // End:0x98
    if(Count > 0)
    {
        ItemsCount[int(ItemType)] += Count;
        AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD).HudMovie).UpdateItemsOnHud();
    }
    //return;    
}

function RemoveItem(AdvTypes.EAdvItemType ItemType, optional int Count = 1)
{
    // End:0xCA
    if(Count > 0)
    {
        ItemsCount[int(ItemType)] -= Count;
        // End:0x66
        if(ItemsCount[int(ItemType)] < 0)
        {
            ItemsCount[int(ItemType)] = 0;
        }
        AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD).HudMovie).UpdateItemsOnHud();
    }
    //return;    
}

function NotifyPossibleInputHijack(EvilTypes.ECombatActionType CAT, EvilPawn Target, float Distance, float TimeOut)
{
    PossibleInputHijacks[int(CAT)].Target = Target;
    PossibleInputHijacks[int(CAT)].TargetDistance = Distance;
    PossibleInputHijacks[int(CAT)].ExpiryTime = WorldInfo.TimeSeconds + TimeOut;
    bForceNetUpdate = true;
    //return;    
}

function ChoosePlayerSkin()
{
    local AdvMapInfo MapInfo;

    MapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0xA5
    if((MapInfo != none) && MapInfo.PlayerSkinClass != none)
    {
        SetCharClassInfo(MapInfo.PlayerSkinClass);
    }
    //return;    
}

function ChoosePlayerSkinMP()
{
    //return;    
}

simulated function int GetDeltaStat(int TotalStat, out int CounterStat)
{
    local int Delta;

    Delta = Max(TotalStat - Max(CounterStat, 0), 0);
    CounterStat = TotalStat;
    return Delta;
    //return ReturnValue;    
}

simulated function int GetDeathsSinceLastWrite()
{
    return GetDeltaStat(StatOfDeaths, TotalDeathsWritten);
    //return ReturnValue;    
}

simulated function int GetKillsSinceLastWrite()
{
    return GetDeltaStat(StatOfKills, TotalKillsWritten);
    //return ReturnValue;    
}

simulated function int GetFlagsCapturedSinceLastWrite()
{
    return GetDeltaStat(StatOfScoreFlag, TotalScoreFlagWritten);
    //return ReturnValue;    
}

simulated function int GetFlagsReturnedSinceLastWrite()
{
    return GetDeltaStat(StatsOfReturnedFlag, TotalScoreReturnFlagWritten);
    //return ReturnValue;    
}

function int IncrementKillStat(name NewStatName)
{
    StatOfKills++;
    return 1;
    //return ReturnValue;    
}

function int IncrementDeathStat(name NewStatName)
{
    StatOfDeaths++;
    return 1;
    //return ReturnValue;    
}

function int IncrementCapturedFlagsStat()
{
    StatOfScoreFlag++;
    return 1;
    //return ReturnValue;    
}

function int IncrementReturnedFlagStat()
{
    StatsOfReturnedFlag++;
    return 1;
    //return ReturnValue;    
}

simulated function CopyLevelStatsToLevelStatsStruct(out LevelStatistics ls)
{
    local AdvGRI GRI;

    GRI = AdvGRI(WorldInfo.GRI);
    ls.GameplayTime = GRI.GameplayTime;
    ls.Difficulty = Difficulty.default.DifficultyLevel;
    ls.MonstersKilled = MonstersKilled;
    ls.BonusItems = BonusItems;
    ls.AmmoFound = AmmoFound;
    ls.ObjectsDestroyed = DestroyedObjects;
    ls.SecretsFound = SecretsFound;
    ls.TotalMonsters = GRI.TotalMonsters;
    ls.TotalAmmo = GRI.TotalAmmo;
    ls.TotalObjects = GRI.TotalObjects;
    ls.TotalSecrets = GRI.TotalSecrets;
    //return;    
}

simulated event Destroyed()
{
    local AdvPlayerControllerMP MPPC;

    // End:0x77
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', MPPC)
    {
        // End:0x76
        if(MPPC.IsLocalPlayerController())
        {
            MPPC.NotifyPreDestroyPRI(self);
        }        
    }    
    CharacterStore = none;
    BlessingManager = none;
    super(PlayerReplicationInfo).Destroyed();
    //return;    
}

simulated function bool IsVotingVisible()
{
    // End:0x10B
    if(((AdvPlayerController(Owner) != none) && AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD) != none) && AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD).HudMovie) != none)
    {
        return AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD).HudMovie).IsVotingCompontentVisible();
    }
    return false;
    //return ReturnValue;    
}

simulated function SubmitVote(bool bFor)
{
    local bool bScoreboardIsOpen;

    bScoreboardIsOpen = ((AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD) != none) && AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD).AdvScoreboardMovie != none) && AdvGFxHudWrapper(AdvPlayerController(Owner).myHUD).AdvScoreboardMovie.bMovieIsOpen;
    // End:0x170
    if(((IsVotingVisible()) && !bScoreboardIsOpen) || AdvGFxMenuHudWrapper(AdvPlayerController(Owner).myHUD) != none)
    {
        // End:0x170
        if(!bSubmittedVote)
        {
            bSubmittedVote = true;
            ServerSubmitVote(bFor);
        }
    }
    //return;    
}

reliable client simulated function SetVoteSubmitted()
{
    local AdvGRI GRI;

    GRI = AdvGRI(WorldInfo.GRI);
    bSubmittedVote = true;
    // End:0x74
    if(GRI != none)
    {
        GRI.VoteStateChanged();
    }
    //return;    
}

reliable server function ServerSubmitVote(bool bFor)
{
    local AdvGRI GRI;

    GRI = AdvGRI(WorldInfo.GRI);
    // End:0x6A
    if(GRI != none)
    {
        GRI.SubmitVote(self, bFor);
    }
    //return;    
}

reliable server function StartKickVoting(PlayerReplicationInfo ToKick)
{
    local AdvGRI GRI;

    GRI = AdvGRI(WorldInfo.GRI);
    // End:0xE2
    if((GRI != none) && int(GRI.LastVotingState) == int(0))
    {
        GRI.PlayerToKick = ToKick.UniqueId;
        // End:0xE2
        if(GRI.StartVoting(self, 1))
        {
            ServerSubmitVote(true);
            SetVoteSubmitted();
        }
    }
    //return;    
}

reliable client simulated function ClearVote()
{
    bSubmittedVote = false;
    //return;    
}

simulated function CopyLMSData()
{
    ScoreLMS += Score;
    KillsLMS += Kills;
    DeathsLMS += Deaths;
    RescuesLMS += RescuesCount;
    //return;    
}

defaultproperties
{
    LastTalkTime=-5.0000000
    DLCFlag=-1
    CharClassInfo=(FamilyInfo=Class'AdvFamilyInfo_MP_Hero_Base')
}