class AdvGameMP_Base extends ADVGame
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var bool bTeamDamage;
var bool bTraps;
var bool bKillingSpree;
var bool bOracle;
var bool bRealism;
var bool bAllowDraws;
var bool bPlayCloseToEndSounds;
var bool bDisablePlayerRespawn;
var bool bFirstCloseToEndSoundPlayed;
var bool bSecondCloseToEndSoundPlayed;
var bool bFinalMusicPlay;
var bool bDirectorSpawningFinished;
var float RespawnTime;
var int MummiesInGame;
var int RoundsToWin;
var int ScoreForWin;
var int XPForWin;
var NavigationPoint LastPlayerStartSpot;
var NavigationPoint LastStartSpot;
var int ScoreForFlawlessKill;
var int ScoreForFinisher;
var int ScoreForAssist;
var int ScoreForSuicide;
var int BonusScoreForTrapKill;
var int BonusScoreForHighScore;
var int BonusScoreForMostKills;
var int BonusScoreForFirstBlood;
var int BonusScoreForNoDeath;
var int XPForFlawlessKill;
var int XPForFinisher;
var int XPForAssist;
var int XPForFirstKill;
var int XPforLMSRescue;
var int XPforLMSKill;
var int XPforRoundWon;
var int XPforLMSMatchWon;
var int BonusXPForTrapKill;
var class<AdvClassInfo_MP_Base> MultiplayerClassInfoClass;
var class<AdvWayPointMPBase> WayPointClass;
var class<AdvPerkManager_Base> PerkManagerClass;
var AdvPerkManager_Base PerkManager;
var array< class<EvilFamilyInfoBase> > UsedSkins;
var array<int> UsedSkinsOccurrences;
var SoundCue CountdownSounds[10];
var const localized string FlawlessKillStr;
var const localized string FinisherStr;
var const localized string AssistStr;
var const localized string FirstBloodMsg;
var array<SoundCue> StartMatchSound;
var array<string> StartMatchStringKey;
var array<SoundCue> EndMatchSoundWin;
var array<string> EndMatchWinStringKey;
var array<SoundCue> EndMatchSoundLose;
var array<string> EndMatchLoseStringKey;
var array<SoundCue> EndMatchSoundDraw;
var array<string> EndMatchDrawStringKey;
var array<SoundCue> CloseToEndWinSound;
var array<string> CloseToEndWinStringKey;
var array<SoundCue> CloseToEndLoseSound;
var array<string> CloseToEndLoseStringKey;
var int PlaylistTeamSize;
var int PlaylistTeamCount;
var int PlaylistMaxPartySize;
var AdvPlayerMatchBeaconHost HostPlayerMatchBeacon;
var AdvGameHostMigrationManager GameHostMigrationManager;
var OnlinePlaylistManager PlaylistMan;
var int PlaylistId;
var int GameSettingsId;
var Texture2D FriendlyMarkerIcon;
var Texture2D WaypointIcon;

static function int GetScoreForKill()
{
    return default.ScoreForFlawlessKill;
    //return ReturnValue;    
}

function InitGameReplicationInfo()
{
    local UTGameReplicationInfo GRI;
    local UTMutator M;
    local AdvGRI WGRI;

    super.InitGameReplicationInfo();
    WGRI = GetGRI();
    // End:0xEF
    if(WGRI != none)
    {
        WGRI.NextMap = GetNextMap();
        WGRI.MapsList = AdvEngine(Class'Engine.Engine'.static.GetEngine()).AdvMapsString;
        WGRI.SetPlaylist(PlaylistMan.CurrentPlaylistId);
    }
    GRI = UTGameReplicationInfo(GameReplicationInfo);
    GRI.GoalScore = GoalScore;
    GRI.TimeLimit = TimeLimit;
    AdvGRI(GRI).RoundsToWin = RoundsToWin;
    AdvGRI(GRI).ScoreForWin = ScoreForWin;
    AdvGRI(GRI).XPForWin = XPForWin;
    GameReplicationInfo.RemainingTime = 60 * TimeLimit;
    GRI.MinNetPlayers = MinNetPlayers;
    GRI.bConsoleServer = WorldInfo.bUseConsoleInput || WorldInfo.IsConsoleBuild();
    GRI.bAllowKeyboardAndMouse = bAllowKeyboardAndMouse;
    GRI.bRequireReady = bPlayersMustBeReady;
    M = GetBaseUTMutator();
    J0x30E:

    // End:0x3EF [Loop If]
    if(M != none)
    {        
        GRI.MutatorList $= ((GRI.MutatorList == "") ? PathName(M.Class) : "?" $ PathName(M.Class));
        M = M.GetNextUTMutator();
        // [Loop Continue]
        goto J0x30E;
    }
    GRI.RulesString = "";
    GRI.AddGameRule(GetMapTypeRule());
    GRI.AddGameRule(GetEndGameConditionRule());
    GRI.AddGameRule(" ");
    // End:0x686
    if(GameHostMigrationManager != none)
    {
        GameHostMigrationManager.UpdateGRI(AdvGRI(GameReplicationInfo));
        GoalScore = WGRI.GoalScore;
        RoundsToWin = WGRI.RoundsToWin;
        XPForWin = WGRI.XPForWin;
        ScoreForWin = WGRI.ScoreForWin;
        bRealism = WGRI.bRealism;
        bOracle = WGRI.bOracle;
        bKillingSpree = WGRI.bKillingSpree;
        bTraps = WGRI.bTraps;
        RespawnTime = WGRI.RespawnTime;
        bTeamDamage = WGRI.bTeamDamage;
        TimeLimit = WGRI.TimeLimit;
    }
    //return;    
}

function PostBeginPlay()
{
    local AdvGRI GRI;

    super(EvilGame).PostBeginPlay();
    PerkManager = Spawn(PerkManagerClass);
    GRI = AdvGRI(WorldInfo.GRI);
    // End:0x70
    if(PerkManager == none)
    {        
    }
    else
    {
        GRI.MummyCharClassInfo = GetMummyCharClassInfo();
    }
    // End:0xDD
    if(!GRI.IsPrivateCustomGame())
    {
        WorldInfo.ToggleHostMigration(true);
    }
    //return;    
}

function StartMatch()
{
    local AdvPlayerControllerMP PC;

    super.StartMatch();
    // End:0x12E
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0x12D
        if((PC.Pawn != none) && PC.Pawn.IsHumanControlled())
        {
            PC.LastUpdateTime = WorldInfo.TimeSeconds - float(10);
            // End:0x12D
            if(PerkManager != none)
            {
                PC.bAvaiblePerks.Length = PerkManager.Perks.Length;
            }
        }        
    }    
    //return;    
}

function bool CanChangeTeam(AdvPRI ChangingPRI)
{
    local PlayerReplicationInfo PRI;
    local int PlayersInTeam[2], LocalPlayerTeamIndex;

    LocalPlayerTeamIndex = ChangingPRI.Team.TeamIndex;
    // End:0xF9
    foreach GameReplicationInfo.PRIArray(PRI)
    {
        // End:0xB2
        if(PRI.Team.TeamIndex == 0)
        {
            PlayersInTeam[0]++;            
        }
        else
        {
            // End:0xF8
            if(PRI.Team.TeamIndex == 1)
            {
                PlayersInTeam[1]++;
            }
        }        
    }    
    // End:0x129
    if(LocalPlayerTeamIndex == 0)
    {
        // End:0x126
        if(PlayersInTeam[0] > PlayersInTeam[1])
        {
            return true;
        }        
    }
    else
    {
        // End:0x155
        if(LocalPlayerTeamIndex == 1)
        {
            // End:0x155
            if(PlayersInTeam[1] > PlayersInTeam[0])
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    // End:0xF0
    if((AdvPRI(Viewer.PlayerReplicationInfo) != none) && AdvPRI(Viewer.PlayerReplicationInfo).bIsTournamentSpectator)
    {
        // End:0xEB
        if(((ViewTarget == none) || ViewTarget.bOnlySpectator) || (AdvPRI(ViewTarget) != none) && AdvPRI(ViewTarget).bIsTournamentSpectator)
        {
            return false;
        }
        return true;        
    }
    else
    {
        return super(EvilGame).CanSpectate(Viewer, ViewTarget);
    }
    //return ReturnValue;    
}

function CreateTeam(int TeamIndex)
{
    // End:0xCD
    if((Teams.Length <= TeamIndex) || Teams[TeamIndex] == none)
    {
        Teams[TeamIndex] = Spawn(Class'AdvTeamInfo');
        Teams[TeamIndex].Initialize(TeamIndex);
        GameReplicationInfo.SetTeam(TeamIndex, Teams[TeamIndex]);
    }
    //return;    
}

function RestartPlayer(Controller aPlayer)
{
    local AdvPlayerControllerMP PC;

    // End:0x0F
    if(bDisablePlayerRespawn)
    {
        return;
    }
    PC = AdvPlayerControllerMP(aPlayer);
    // End:0x109
    if(AdvPRI(PC.PlayerReplicationInfo).bWantToChangeTeam)
    {
        ChangeTeam(PC, 1 - PC.PlayerReplicationInfo.Team.TeamIndex, true);
        AdvPRI(PC.PlayerReplicationInfo).bWantToChangeTeam = false;
    }
    super.RestartPlayer(aPlayer);
    PC.AssistingPlayers.Remove(0, PC.AssistingPlayers.Length);    
    PC.bKilledByTrap = false;
    SpawnPlayerBaseInventory(PC);
    PC.SetFiringDisableFlag(false);
    PC.ClientSetHudVisibility(true);
    PlayStartMessage(PC);
    // End:0x226
    if(PC.bFirstSpawn)
    {
        PC.bFirstSpawn = false;
    }
    PC.SetCinematicMode(false, false, false, true, true, false);
    ResetPlayerDevastatorMummyMode(aPlayer);
    //return;    
}

function PlayStartMessage(AdvPlayerControllerMP PC)
{
    local int I;

    I = Rand(StartMatchSound.Length);
    // End:0xA7
    if(PC.bFirstSpawn)
    {
        PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", StartMatchStringKey[I], "AdvGame"), StartMatchSound[I], true);
    }
    //return;    
}

function SpawnPlayerBaseInventory(AdvPlayerControllerMP PC)
{
    local class<Inventory> MainWeaponClass;
    local AdvClassInfo_MP_Base.EThrowWeaponType ThrowWeaponType;
    local int EquipmentIndex, I;

    ThrowWeaponType = class<AdvFamilyInfo_MP_Hero_Base>(AdvPRI(PC.PlayerReplicationInfo).static.GetCharClassInfo()).default.ThrowWeaponType;
    PC.Pawn.CreateInventory(MultiplayerClassInfoClass.default.Equipment[Class'AdvClassInfo_MP_Base'.default.ThrowWeaponIndices[int(ThrowWeaponType)]], true);
    // End:0x2B0
    if(AdvPRI(PC.PlayerReplicationInfo).NextSpawnClassIndex < 5)
    {
        // End:0x24D
        foreach MultiplayerClassInfoClass.default.ClassInfo[AdvPRI(PC.PlayerReplicationInfo).NextSpawnClassIndex].EquipmentIndices(EquipmentIndex, I)
        {
            // End:0x1EF
            if(I == 0)
            {
                MainWeaponClass = MultiplayerClassInfoClass.default.Equipment[EquipmentIndex];
                continue;                
            }
            else
            {
                PC.Pawn.CreateInventory(MultiplayerClassInfoClass.default.Equipment[EquipmentIndex], true);                
            }
        }        
        PC.Pawn.CreateInventory(MainWeaponClass, false);
        PC.bChoseCustomClassesOnly = false;        
    }
    else
    {
        PC.Pawn.CreateInventory(MultiplayerClassInfoClass.default.Equipment[AdvPRI(PC.PlayerReplicationInfo).NextSpawnSecondaryWeaponIndex], true);
        // End:0x422
        foreach MultiplayerClassInfoClass.default.ClassInfo[AdvPRI(PC.PlayerReplicationInfo).NextSpawnClassIndex].EquipmentIndices(EquipmentIndex, I)
        {
            PC.Pawn.CreateInventory(MultiplayerClassInfoClass.default.Equipment[EquipmentIndex], true);            
        }        
        PC.Pawn.CreateInventory(MultiplayerClassInfoClass.default.Equipment[AdvPRI(PC.PlayerReplicationInfo).NextSpawnPrimaryWeaponIndex], false);
    }
    //return;    
}

function DoPostLogin(PlayerController NewPlayer)
{
    local AdvPRI PRI;
    local int TeamIndex;
    local OnlineGameSettings GameSettings;
    local AdvPlayerControllerMP MPPlayer;

    PRI = AdvPRI(NewPlayer.PlayerReplicationInfo);
    // End:0x16D
    if(((NewPlayer != none) && NewPlayer.PlayerReplicationInfo != none) && PRI != none)
    {
        // End:0x16D
        if(((class<AdvGameTreasureHuntBase>(WorldInfo.GetGameClass()) != none) || class<AdvGameTeamTreasureHuntBase>(WorldInfo.GetGameClass()) != none) && AdvPlayerControllerMP(NewPlayer) != none)
        {
            PRI.BlessingManager = Spawn(Class'AdvBlessingManager');
            PRI.BlessingManager.SetOwningPlayer(AdvPlayerControllerMP(NewPlayer));
        }
    }
    // End:0x1C1
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', MPPlayer)
    {
        MPPlayer.ClientCheckWallSee();        
    }    
    AdvPlayerControllerMP(NewPlayer).UpdateHealHudIcon();
    super.DoPostLogin(NewPlayer);
    // End:0x292
    if(GameHostMigrationManager != none)
    {
        // End:0x292
        if(PRI != none)
        {
            GameHostMigrationManager.UpdatePRI(PRI);
            TeamIndex = GameHostMigrationManager.GetTeamId(PRI);
            ChangeTeam(NewPlayer, TeamIndex, false);
        }
    }
    // End:0x307
    if((int(WorldInfo.NetMode) != int(NM_Client)) && NewPlayer.IsLocalPlayerController())
    {
        AdvPlayerController(NewPlayer).SetupSteamLobby();
    }
    // End:0x3EF
    if((NewPlayer != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings('Game');
        // End:0x3EF
        if((GameSettings != none) && (int(GameSettings.GameState) == int(3)) || int(GameSettings.GameState) == int(2))
        {
            NewPlayer.ClientStartOnlineGame();
        }
    }
    OnHostBeaconReservationChange();
    UpdateGameSettings();
    UpdateGameSettingsCounts();
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local AdvPlayerControllerMP AssistingPlayer;
    local EvilAIController EvilKiller;
    local PlayerReplicationInfo OtherPRI;

    // End:0x17A
    if(AdvGRI(WorldInfo.GRI).CanWriteStats())
    {
        // End:0x136
        if((AdvPlayerControllerMP(Killer) != none) && Killer != Other)
        {
            // End:0x10A
            if(AdvGRI(GameReplicationInfo).IsTeamMultiPlayerGame())
            {
                // End:0x107
                if(!AdvGRI(GameReplicationInfo).OnSameTeam(Killer, Other))
                {
                    AdvPlayerControllerMP(Killer).IncrementGlobalIntStat(115);
                }                
            }
            else
            {
                AdvPlayerControllerMP(Killer).IncrementGlobalIntStat(115);
            }
        }
        // End:0x17A
        if(AdvPlayerControllerMP(Other) != none)
        {
            AdvPlayerControllerMP(Other).IncrementGlobalIntStat(116);
        }
    }
    EvilKiller = EvilAIController(Killer);
    // End:0x314
    if((EvilKiller != none) && EvilKiller.PlayerReplicationInfo == none)
    {
        // End:0x314
        if((EvilKiller.Master != none) && EvilKiller.Master.PlayerReplicationInfo != none)
        {
            EvilKiller.Master.PlayerReplicationInfo.Score += float(ScoreForFlawlessKill);
            EvilKiller.Master.PlayerReplicationInfo.bForceNetUpdate = true;
            EvilKiller.Master.PlayerReplicationInfo.Kills++;
        }
    }
    // End:0x504
    if(AdvPlayerControllerMP(Other).bKilledByTrap)
    {
        // End:0x37F
        if(Killer == none)
        {
            Killer = AdvPlayerControllerMP(Other).TrapKiller;
        }
        // End:0x504
        if(Killer.PlayerReplicationInfo.Team != AdvPlayerControllerMP(Other).PlayerReplicationInfo.Team)
        {
            Killer.PlayerReplicationInfo.Score += float(BonusScoreForTrapKill);
            Killer.PlayerReplicationInfo.Team.Score += float(BonusScoreForTrapKill);
            Killer.PlayerReplicationInfo.Team.bForceNetUpdate = true;
            AdvPlayerControllerMP(Killer).AddXP(BonusXPForTrapKill);
        }
    }
    // End:0xBFA
    if(((Killer != none) && Killer != Other) && Other.PlayerReplicationInfo != none)
    {
        // End:0x5D6
        if(AdvPlayerControllerMP(Other).AssistingPlayers.Find(AdvPlayerControllerMP(Killer)) == )
        {            
            AdvPlayerControllerMP(Other).AssistingPlayers.AddItem(AdvPlayerControllerMP(Killer));            
        }
        // End:0x9D9
        if(AdvPlayerControllerMP(Other).AssistingPlayers.Length > 1)
        {
            // End:0x9D5
            foreach AdvPlayerControllerMP(Other).AssistingPlayers(AssistingPlayer)
            {
                // End:0x9D4
                if((AssistingPlayer.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo.Team.TeamIndex != Other.PlayerReplicationInfo.Team.TeamIndex)
                {
                    // End:0x877
                    if(AssistingPlayer != Killer)
                    {
                        AssistingPlayer.SetAssistInfo(ScoreForAssist);
                        AssistingPlayer.PlayerReplicationInfo.Score += float(ScoreForAssist);
                        AdvPRI(AssistingPlayer.PlayerReplicationInfo).Assists++;
                        AssistingPlayer.AddXP(XPForAssist);
                        AssistingPlayer.PlayerReplicationInfo.bForceNetUpdate = true;
                        // End:0x874
                        if(AdvGRI(WorldInfo.GRI).CanWriteStats())
                        {
                            AssistingPlayer.IncrementGlobalIntStat(117);
                        }                        
                    }
                    else
                    {
                        // End:0x8D7
                        if(AdvPlayerControllerMP(Other).bKilledByTrap)
                        {
                            AssistingPlayer.SetFinisherInfo(ScoreForFinisher, true, BonusScoreForTrapKill);                            
                        }
                        else
                        {
                            AssistingPlayer.SetFinisherInfo(ScoreForFinisher);
                        }
                        AssistingPlayer.PlayerReplicationInfo.Score += float(ScoreForFinisher);
                        AssistingPlayer.PlayerReplicationInfo.Kills++;
                        AssistingPlayer.AddXP(XPForFinisher);
                        AssistingPlayer.PlayerReplicationInfo.bForceNetUpdate = true;
                    }
                }                
            }                        
        }
        else
        {
            // End:0xBF7
            if((Killer != none) && Killer.PlayerReplicationInfo.Team.TeamIndex != Other.PlayerReplicationInfo.Team.TeamIndex)
            {
                // End:0xAE8
                if(AdvPlayerControllerMP(Other).bKilledByTrap)
                {
                    AdvPlayerControllerMP(Killer).SetFlawlessInfo(ScoreForFlawlessKill, true, BonusScoreForTrapKill);                    
                }
                else
                {
                    AdvPlayerControllerMP(Killer).SetFlawlessInfo(ScoreForFlawlessKill);
                }
                Killer.PlayerReplicationInfo.Score += float(ScoreForFlawlessKill);
                Killer.PlayerReplicationInfo.Kills++;
                AdvPlayerControllerMP(Killer).AddXP(XPForFlawlessKill);
                Killer.PlayerReplicationInfo.bForceNetUpdate = true;
            }
        }        
    }
    else
    {
        // End:0xCA5
        if((Other != none) && Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.Score -= float(ScoreForSuicide);
            Other.PlayerReplicationInfo.bForceNetUpdate = true;
        }
    }
    OtherPRI = Other.PlayerReplicationInfo;
    // End:0xD87
    if(OtherPRI != none)
    {
        // End:0xD29
        if(AdvGameLastMenStandingBase(WorldInfo.Game) == none)
        {
            OtherPRI.NumLives++;
        }
        // End:0xD87
        if((MaxLives > 0) && OtherPRI.NumLives >= MaxLives)
        {
            OtherPRI.bOutOfLives = true;
        }
    }
    ModifyScoreKill(Killer, Other);
    // End:0xDEB
    if((Killer != none) || MaxLives > 0)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    // End:0xF0F
    if((((PerkManager != none) && bKillingSpree) && AdvPlayerControllerMP(Killer) != none) && Killer != Other)
    {
        // End:0xEDC
        if(AdvGRI(GameReplicationInfo).IsTeamMultiPlayerGame())
        {
            // End:0xED9
            if(!AdvGRI(GameReplicationInfo).OnSameTeam(Killer, Other))
            {
                PerkManager.IncreaseKillStrikeScore(0, Killer, Other);
            }            
        }
        else
        {
            PerkManager.IncreaseKillStrikeScore(0, Killer, Other);
        }
    }
    // End:0xF64
    if(AdvPlayerPawnMP(AdvPlayerControllerMP(Other).Pawn).bIsMummy)
    {
        UpdateMummyMusic(false);
    }
    //return;    
}

function UpdateMummyMusic(bool bNewMummy, optional SoundCue PerkMusic)
{
    // End:0x36
    if(bNewMummy)
    {
        // End:0x28
        if(MummiesInGame == 0)
        {
            SetMummyMusic(true);
        }
        MummiesInGame++;        
    }
    else
    {
        // End:0x50
        if(MummiesInGame == 1)
        {
            SetMummyMusic(false);
        }
        MummiesInGame--;
    }
    //return;    
}

function SetMummyMusic(bool bPlay)
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_StartMusicMP FireEvent;
    local array<int> ActivateIndices;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0xF5
    if(GameSeq != none)
    {
        // End:0x55
        if(bPlay)
        {
            ActivateIndices[0] = 1;            
        }
        else
        {
            ActivateIndices[0] = 0;
        }
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_StartMusicMP', true, ExecutionEvents);
        // End:0xF4
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_StartMusicMP(ExecutionEvent);
            FireEvent.CheckActivate(self, none, false, ActivateIndices);            
        }        
    }
    //return;    
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    local AdvWeap_Base Weap;

    super(EvilGame).Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    Weap = AdvWeap_Base(Killer.Pawn.Weapon);
    // End:0xD9
    if((Weap != none) && Weap.InstantHitDamageTypes.Find(DamageType) != )
    {        
        Weap.IncreaseKillCount();
    }
    //return;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    local AdvPlayerControllerMP PC_MP;

    // End:0x5D
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC_MP)
    {
        PC_MP.StopObservePawn(KilledPawn);        
    }    
    super(GameInfo).NotifyKilled(Killer, Killed, KilledPawn, DamageType);
    // End:0x1B1
    if(class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) == none)
    {
        PC_MP = AdvPlayerControllerMP(Killer);
        // End:0x1B1
        if(PC_MP != none)
        {
            // End:0x1B1
            if(AdvGRI(WorldInfo.GRI).CanWriteStats())
            {
                // End:0x15C
                if(ClassIsChildOf(DamageType, Class'AdvDmgType_TrapFire'))
                {
                    PC_MP.ClientKillByEnemyFireTrap();
                }
                // End:0x1B1
                if(ClassIsChildOf(DamageType, Class'AdvDmgType_Trap_Base') || ClassIsChildOf(DamageType, Class'AdvDmgType_MeleeTrap'))
                {
                    PC_MP.IncrementGlobalIntStat(118);
                }
            }
        }
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local AdvPlayerControllerMP PC;

    super(Actor).Tick(DeltaTime);
    // End:0x3B9
    if(bPlayCloseToEndSounds)
    {
        // End:0x209
        if((((((!bFirstCloseToEndSoundPlayed && WorldInfo.GRI.TimeLimit > 1) && WorldInfo.GRI.RemainingTime < 60) && CloseToEndWinSound.Length > 1) && CloseToEndLoseSound.Length > 1) && CloseToEndWinSound[0] != none) && CloseToEndLoseSound[0] != none)
        {
            bFirstCloseToEndSoundPlayed = true;
            // End:0x208
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
            {
                // End:0x1A8
                if(IsAWinner(PC))
                {
                    PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", CloseToEndWinStringKey[0], "AdvGame"), CloseToEndWinSound[0]);
                    // End:0x207
                    continue;
                }
                PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", CloseToEndLoseStringKey[0], "AdvGame"), CloseToEndLoseSound[0]);                
            }            
        }
        // End:0x3B9
        if(((((!bSecondCloseToEndSoundPlayed && WorldInfo.GRI.RemainingTime < 30) && CloseToEndWinSound.Length >= 2) && CloseToEndLoseSound.Length >= 2) && CloseToEndWinSound[1] != none) && CloseToEndLoseSound[1] != none)
        {
            bSecondCloseToEndSoundPlayed = true;
            // End:0x3B8
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
            {
                // End:0x358
                if(IsAWinner(PC))
                {
                    PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", CloseToEndWinStringKey[1], "AdvGame"), CloseToEndWinSound[1]);
                    // End:0x3B7
                    continue;
                }
                PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", CloseToEndLoseStringKey[1], "AdvGame"), CloseToEndLoseSound[1]);                
            }            
        }
    }
    //return;    
}

function DestroyHostBeacon()
{
    // End:0x39
    if(HostPlayerMatchBeacon != none)
    {
        HostPlayerMatchBeacon.DestroyBeacon();
        HostPlayerMatchBeacon = none;
    }
    //return;    
}

function TellClientsToReturnToPartyHost()
{
    DestroyHostBeacon();
    super(GameInfo).TellClientsToReturnToPartyHost();
    //return;    
}

function TurnInTournamentSpectator(AdvPRI PRI)
{
    local AdvPlayerControllerMP PC;

    // End:0x64
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0x63
        if(PC.PlayerReplicationInfo == PRI)
        {
            // End:0x64
            break;
        }        
    }    
    SetTimer(0.5000000, false, 'TurnInTournamentSpectator', PC);
    //return;    
}

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string ErrorMessage)
{
    local OnlineGameSettings GameSettings;
    local int idPlaylist;

    super(GameInfo).PreLogin(Options, Address, UniqueId, bSupportsAuth, ErrorMessage);
    GameSettings = GameInterface.GetGameSettings('Game');
    // End:0x12D
    if((GameSettings != none) && GameSettings.GetIntProperty(268435457, idPlaylist))
    {
        // End:0x12D
        if((idPlaylist == -1) && !HasOption(Options, "bIsFromInvite"))
        {
            ErrorMessage = "ADVGame.MessageBoxErrorStrings.InviteJoinFailed_Message";
            return;
        }
    }
    //return;    
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local PlayerController NewPlayer;
    local bool DelayedStart;

    DelayedStart = bDelayedStart;
    bDelayedStart = false;
    // End:0x71
    if(PlaylistId != -1)
    {        
        Options $= PlaylistMan.GetUrlFromPlaylist(PlaylistId);
    }
    NewPlayer = super.Login(Portal, Options, UniqueId, ErrorMessage);
    bDelayedStart = DelayedStart;
    return NewPlayer;
    //return ReturnValue;    
}

function Actor FindStartView(Controller Player, optional byte InTeam, optional string IncomingName)
{
    local AdvMapInfo MyMapInfo;

    // End:0xBA
    if(WorldInfo != none)
    {
        MyMapInfo = AdvMapInfo(WorldInfo.GetMapInfo());
        // End:0xBA
        if((MyMapInfo != none) && MyMapInfo.StartViewPointsMP.Length > 0)
        {
            return MyMapInfo.StartViewPointsMP[Rand(MyMapInfo.StartViewPointsMP.Length)];
        }
    }
    return super(GameInfo).FindStartView(Player, InTeam, IncomingName);
    //return ReturnValue;    
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    local NavigationPoint Best;

    // End:0x32
    if(ScriptedStartSpot != none)
    {
        Best = ScriptedStartSpot;
        ScriptedStartSpot = none;        
    }
    else
    {
        // End:0x8F
        if((Player != none) && Player.StartSpot != none)
        {
            LastPlayerStartSpot = Player.StartSpot;
        }
        Best = super(GameInfo).FindPlayerStart(Player, InTeam, IncomingName);
        // End:0xE0
        if(Best != none)
        {
            LastStartSpot = Best;
        }
    }
    return Best;
    //return ReturnValue;    
}

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam)
{
    local PlayerStart P, BestStart;
    local float BestRating, NewRating;
    local array<PlayerStart> PlayerStarts;
    local int I;
    local byte Team;

    BestRating = -1.0000000;
    Team = ((((Player != none) && Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.Team != none) ? byte(Player.PlayerReplicationInfo.Team.TeamIndex) : InTeam);
    // End:0x14C
    foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', P)
    {
        // End:0x14B
        if(P.bEnabled)
        {
            PlayerStarts.AddItem(P);            
        }        
    }    
    I = 0;
    J0x158:

    // End:0x23F [Loop If]
    if(I < PlayerStarts.Length)
    {
        NewRating = RatePlayerStart(PlayerStarts[I], Team, Player);
        // End:0x1EA
        if(NewRating == BestRating)
        {
            // End:0x1E7
            if(Rand(2) == 1)
            {
                BestStart = PlayerStarts[I];
            }            
        }
        else
        {
            // End:0x231
            if(NewRating > BestRating)
            {
                BestRating = NewRating;
                BestStart = PlayerStarts[I];
            }
        }
        I++;
        // [Loop Continue]
        goto J0x158;
    }
    return BestStart;
    //return ReturnValue;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Score, NextDist;
    local Controller OtherPlayer;
    local Vector PlayerStartViewLocation;

    PlayerStartViewLocation = P.Location + vect(0.0000000, 0.0000000, 100.0000000);
    Score = float(((P.bPrimaryStart) ? 110 : 100));
    // End:0xAB
    if((P == LastStartSpot) || P == LastPlayerStartSpot)
    {
        Score -= 15.0000000;
    }
    // End:0x805
    if(Player != none)
    {
        // End:0x804
        foreach WorldInfo.AllControllers(Class'Engine.Controller', OtherPlayer)
        {
            // End:0x803
            if((OtherPlayer.bIsPlayer && OtherPlayer.Pawn != none) && OtherPlayer != Player)
            {
                // End:0x358
                if((Abs(P.Location.Z - AdvPlayerControllerMP(OtherPlayer).MyAdvPlayerPawnMP.Location.Z) < (P.CylinderComponent.CollisionHeight + AdvPlayerControllerMP(OtherPlayer).MyAdvPlayerPawnMP.CylinderComponent.CollisionHeight)) && VSize2D(P.Location - AdvPlayerControllerMP(OtherPlayer).MyAdvPlayerPawnMP.Location) < (P.CylinderComponent.CollisionRadius + AdvPlayerControllerMP(OtherPlayer).MyAdvPlayerPawnMP.CylinderComponent.CollisionRadius))
                {                    
                    return 0.0000000;
                }
                NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
                // End:0x4FB
                if(NumPlayers == 2)
                {
                    // End:0x40A
                    if(NextDist < float(1500))
                    {
                        Score -= float(Clamp(int((float(3000) - NextDist) * 0.0100000), 15, 30));
                    }
                    // End:0x44C
                    if(NextDist > float(3000))
                    {
                        Score -= float(Clamp(int((NextDist - float(3000)) * 0.0100000), 0, 30));
                    }
                    // End:0x4F8
                    if(FastTrace(PlayerStartViewLocation, OtherPlayer.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * OtherPlayer.Pawn.CylinderComponent.CollisionHeight)))
                    {
                        Score += float(20);
                    }
                    // End:0x803
                    continue;
                }
                // End:0x5AD
                if((OtherPlayer.PlayerReplicationInfo != none) && AdvPRI(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo)
                {
                    Score -= float(Clamp(int((float(3000) - NextDist) * 0.0050000), 0, 15));
                }
                // End:0x6D2
                if(WorldInfo.GRI.OnSameTeam(Player, OtherPlayer))
                {
                    // End:0x6A2
                    if(FastTrace(PlayerStartViewLocation, OtherPlayer.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * OtherPlayer.Pawn.CylinderComponent.CollisionHeight)))
                    {
                        Score -= float(5);
                    }
                    Score += float(Clamp(int((float(2000) - NextDist) * 0.0050000), 0, 10));
                    // End:0x803
                    continue;
                }
                // End:0x77E
                if(FastTrace(PlayerStartViewLocation, OtherPlayer.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * OtherPlayer.Pawn.CylinderComponent.CollisionHeight)))
                {
                    Score -= float(15);
                }
                // End:0x7C1
                if(NextDist < float(1500))
                {
                    Score -= float(Clamp(int((float(3000) - NextDist) * 0.0100000), 15, 30));
                }
                // End:0x803
                if(NextDist > float(6000))
                {
                    Score -= float(Clamp(int((NextDist - float(6000)) * 0.0025000), 0, 20));
                }
            }            
        }        
    }
    return float(Max(2, int(Score)));
    //return ReturnValue;    
}

function PlayerReplicationInfo GetWinner()
{
    local Controller P;
    local PlayerReplicationInfo PRI;
    local AdvGRI GRI;
    local float maxscore;
    local int BestTeamIndex;
    local TeamInfo Team;
    local int MaxScorers;

    maxscore = -100000000.0000000;
    MaxScorers = 0;
    // End:0x2E2
    if(ClassIsChildOf(self.Class, Class'AdvGameTeamDeathmatchBase'))
    {
        GRI = AdvGRI(WorldInfo.GRI);
        // End:0x119
        foreach GRI.Teams(Team)
        {
            // End:0x118
            if(Team.Score > maxscore)
            {
                BestTeamIndex = Team.TeamIndex;
                maxscore = Team.Score;
            }            
        }        
        // End:0x17E
        foreach GRI.Teams(Team)
        {
            // End:0x17D
            if(Team.Score == maxscore)
            {
                MaxScorers++;
            }            
        }        
        // End:0x2D4
        if(MaxScorers == 1)
        {
            maxscore = -100000000.0000000;
            // End:0x2D0
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x2CF
                if((P.PlayerReplicationInfo.Score > maxscore) && P.PlayerReplicationInfo.Team.TeamIndex == BestTeamIndex)
                {
                    PRI = P.PlayerReplicationInfo;
                    maxscore = P.PlayerReplicationInfo.Score;
                }                
            }                        
        }
        else
        {
            PRI = none;
        }        
    }
    else
    {
        // End:0x47F
        if(ClassIsChildOf(self.Class, Class'AdvGameDeathmatchBase'))
        {
            // End:0x3E2
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x3E1
                if(P.PlayerReplicationInfo.Score > maxscore)
                {
                    PRI = P.PlayerReplicationInfo;
                    maxscore = P.PlayerReplicationInfo.Score;
                }                
            }            
            // End:0x464
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x463
                if(P.PlayerReplicationInfo.Score == maxscore)
                {
                    MaxScorers++;
                }                
            }            
            // End:0x47F
            if(MaxScorers != 1)
            {
                PRI = none;
            }
        }
    }
    return PRI;
    //return ReturnValue;    
}

function UpdateKillCount(Controller PC, Weapon W)
{
    //return;    
}

function int CalculatedNetSpeed()
{
    local int ModifiedNetBandwidth;

    ModifiedNetBandwidth = TotalNetBandwidth;
    // End:0x2F
    if(IsConsoleDedicatedServer())
    {
        ModifiedNetBandwidth *= float(2);
    }
    return Clamp(ModifiedNetBandwidth / Max(NumPlayers, 1), MinDynamicBandwidth, MaxDynamicBandwidth);
    //return ReturnValue;    
}

function GenericPlayerInitialization(Controller C)
{
    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'AdvGFxHudWrapperMP';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    CommonForGenericPlayerInitialization(C);
    //return;    
}

function CommonForGenericPlayerInitialization(Controller C)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(C);
    PC.ClientPostTravel();
    // End:0xA2
    if(class<AdvGameSurvivalBase>(WorldInfo.GRI.GameClass) == none)
    {
        PC.SetCinematicMode(true, false, false, true, true, false);
    }
    UpdatePlayerMatchInvites(PC);
    UpdatePlayerMatchNeedWantsStatus();
    // End:0xE1
    if(PC != none)
    {
        SetMPRichPresenceString(PC);
    }
    //return;    
}

function PrepareClientWallView(Controller PC, int Time)
{
    local Controller P;

    // End:0x10E
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        // End:0x10D
        if((P.Pawn != none) && P.Pawn.IsSameTeam(PC.Pawn))
        {
            AdvPlayerControllerMP(P).ClientEnableWallSeeFlag();
            P.SetTimer(float(Time), false, 'ClientDisableWallSeeFlag', P);
        }        
    }    
    //return;    
}

function PrepareClientAIWallView(bool bEnabled)
{
    local AdvPlayerControllerMP P;

    // End:0x12D
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', P)
    {
        // End:0x12C
        if((!P.IsInState('Dead') && !P.IsInState('SurvivalWounded')) && !P.IsInState('Spectating'))
        {
            // End:0xED
            if((P != none) && bEnabled)
            {
                P.ClientEnableAIWallSeeFlag();
                // End:0x12C
                continue;
            }
            // End:0x12C
            if((P != none) && !bEnabled)
            {
                P.ClientDisableAIWallSeeFlag();
            }
        }        
    }    
    //return;    
}

function class<EvilFamilyInfoBase> GetMummyCharClassInfo()
{
    return AdvGameMP_Base(WorldInfo.Game).PerkManager.MummyClassInfo;
    //return ReturnValue;    
}

function class<EvilFamilyInfoBase> GetDevastatorCharClassInfo()
{
    return AdvGameMP_Base(WorldInfo.Game).PerkManager.DevastatorClassInfo;
    //return ReturnValue;    
}

function ResetPlayerDevastatorMummyMode(Controller PC)
{
    local AdvPlayerControllerMP MultiplayerPC;

    MultiplayerPC = AdvPlayerControllerMP(PC);
    MultiplayerPC.SetCurrentCharClassInfo(MultiplayerPC.OldPlayerClass);
    // End:0x191
    if((MultiplayerPC.MyAdvPlayerPawnMP != none) && MultiplayerPC.MyAdvPlayerPawnMP.bIsMummy || MultiplayerPC.MyAdvPlayerPawnMP.bIsDevastator)
    {
        MultiplayerPC.MyAdvPlayerPawnMP.bIsMummy = false;
        MultiplayerPC.MyAdvPlayerPawnMP.bIsDevastator = false;
        MultiplayerPC.MyAdvPlayerPawnMP.bForceNetUpdate = true;
    }
    // End:0x244
    if((MultiplayerPC != none) && MultiplayerPC.PlayerReplicationInfo != none)
    {
        AdvPRI(MultiplayerPC.PlayerReplicationInfo).bIsMummy = false;
        AdvPRI(MultiplayerPC.PlayerReplicationInfo).bIsDevastator = false;
    }
    //return;    
}

function bool IsMummyInGame(Controller PC)
{
    local PlayerController LPC;

    // End:0xD8
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', LPC)
    {
        // End:0xD7
        if(AdvPlayerControllerMP(LPC).Pawn.IsSameTeam(PC.Pawn) && AdvPlayerControllerMP(LPC).MyAdvPlayerPawnMP.bIsMummy)
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

function StartHumans()
{
    local PlayerController P;

    // End:0x141
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
    {
        // End:0x140
        if(P.Pawn == none)
        {
            // End:0x68
            if(bGameEnded)
            {                
                return;
            }
            // End:0x140
            if(((P.CanRestartPlayer() && P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.bReadyToPlay) && !AdvPRI(P.PlayerReplicationInfo).bIsTournamentSpectator)
            {
                RestartPlayer(P);
            }
        }        
    }    
    //return;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local PlayerReplicationInfo PRI;
    local float maxscore;
    local int PlayersWithMaxscore;

    maxscore = -100000000.0000000;
    // End:0xFD
    foreach WorldInfo.GRI.PRIArray(PRI)
    {
        // End:0x8A
        if(PRI.Score == maxscore)
        {
            PlayersWithMaxscore++;            
        }
        else
        {
            // End:0xFC
            if(PRI.Score > maxscore)
            {
                PlayersWithMaxscore = 1;
                Winner = PRI;
                maxscore = PRI.Score;
            }
        }        
    }    
    // End:0x163
    if(PlayersWithMaxscore == WorldInfo.GRI.PRIArray.Length)
    {
        GameReplicationInfo.Winner = none;        
    }
    else
    {
        // End:0x1AE
        if(PlayersWithMaxscore > 1)
        {
            // End:0x183
            if(!bAllowDraws)
            {
                return false;
            }
            GameReplicationInfo.Winner = Winner;            
        }
        else
        {
            GameReplicationInfo.Winner = Winner;
        }
    }
    AdvGRI(GameReplicationInfo).bWinnerUpdated = true;
    EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
    SetEndGameFocus(Winner);
    return true;
    //return ReturnValue;    
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
    local Controller P;

    // End:0x55
    if(Winner != none)
    {
        EndGameFocus = Controller(Winner.Owner).Pawn;
    }
    // End:0x85
    if(EndGameFocus != none)
    {
        EndGameFocus.bAlwaysRelevant = true;
    }
    // End:0x103
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, P.PlayerReplicationInfo != none);        
    }    
    //return;    
}

function PlayEndMatchSound()
{
    //return;    
}

function bool EndRound(PlayerReplicationInfo Winner, string Reason)
{
    local AdvGRI GRI;

    // End:0x5D
    if(((Reason ~= "SurvivalLose") || Reason ~= "SurvivalWin") || Reason ~= "NotEnoughPlayers")
    {
        return true;
    }
    GRI = AdvGRI(GameReplicationInfo);
    GRI.bRoundWinnerUpdated = true;
    GRI.RoundWinner = none;
    // End:0x112
    if(Winner != none)
    {
        GRI.RoundWinner = AdvTeamInfo(Winner.Team);        
    }
    else
    {
        // End:0x2FB
        if(Reason ~= "TimeLimit")
        {
            // End:0x2CC
            if(class<AdvGameCTFBase>(GRI.GameClass) != none)
            {
                // End:0x212
                if(GRI.Teams[0].Score > GRI.Teams[1].Score)
                {
                    GRI.RoundWinner = AdvTeamInfo(GRI.Teams[0]);                    
                }
                else
                {
                    // End:0x2C9
                    if(GRI.Teams[1].Score > GRI.Teams[0].Score)
                    {
                        GRI.RoundWinner = AdvTeamInfo(GRI.Teams[1]);
                    }
                }                
            }
            else
            {
                // End:0x2FB
                if(class<AdvGameLastMenStandingBase>(GRI.GameClass) == none)
                {
                    return true;
                }
            }
        }
    }
    // End:0x41F
    if(GRI.RoundWinner != none)
    {
        GRI.RoundWinner.RoundScore++;
        // End:0x41F
        if(GRI.RoundWinner.RoundScore >= RoundsToWin)
        {
            GameReplicationInfo.Winner = GRI.RoundWinner;
            AdvGRI(GameReplicationInfo).bWinnerUpdated = true;
            GameReplicationInfo.bForceNetUpdate = true;
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local AdvPlayerControllerMP PC_MP;
    local float KDMax;
    local int ScoreMax;
    local bool bFirstScoreMaxSet;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC_MP)
    {
        PC_MP.CloseAllMultiMenus();        
    }    
    // End:0x196
    if(!EndRound(Winner, Reason))
    {
        // End:0x186
        if((AdvGameLastMenStandingBase(WorldInfo.Game) != none) || AdvGameCTFBase(WorldInfo.Game) != none)
        {
            // End:0x185
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC_MP)
            {
                // End:0x184
                if(Winner.Team == PC_MP.PlayerReplicationInfo.Team)
                {
                    PC_MP.AddXP(XPforRoundWon);
                }                
            }            
        }
        GotoState('RoundOver');
        return;
    }
    super(EvilGame).EndGame(Winner, Reason);
    KDMax = -10000.0000000;
    bFirstScoreMaxSet = false;
    // End:0x654
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC_MP)
    {
        // End:0x329
        if(PC_MP.PlayerReplicationInfo.Deaths != 0)
        {
            // End:0x326
            if(float(PC_MP.PlayerReplicationInfo.Kills / PC_MP.PlayerReplicationInfo.Deaths) > KDMax)
            {
                KDMax = float(PC_MP.PlayerReplicationInfo.Kills / PC_MP.PlayerReplicationInfo.Deaths);
            }            
        }
        else
        {
            // End:0x3AB
            if(float(PC_MP.PlayerReplicationInfo.Kills) > KDMax)
            {
                KDMax = float(PC_MP.PlayerReplicationInfo.Kills);
            }
        }
        // End:0x468
        if(((PC_MP.PlayerReplicationInfo.Score > float(ScoreMax)) && bFirstScoreMaxSet) || !bFirstScoreMaxSet)
        {
            ScoreMax = int(PC_MP.PlayerReplicationInfo.Score);
            // End:0x468
            if(!bFirstScoreMaxSet)
            {
                bFirstScoreMaxSet = true;
            }
        }
        // End:0x653
        if(AdvGRI(WorldInfo.GRI).CanWriteStats() && NumPlayers >= 2)
        {
            // End:0x5CA
            if(((AdvGameSurvivalBase(WorldInfo.Game) == none) && PC_MP.PlayerReplicationInfo.Deaths == 0) && (PC_MP.PlayerReplicationInfo == Winner) || Winner.Team == PC_MP.PlayerReplicationInfo.Team)
            {
                PC_MP.ClientUnlockAchievement(35);
            }
            // End:0x653
            if(PC_MP.bChoseCustomClassesOnly && AdvPRI(PC_MP.PlayerReplicationInfo).NextSpawnClassIndex > 4)
            {
                PC_MP.ClientUnlockAchievement(47);
            }
        }        
    }    
    // End:0x968
    if((AdvGRI(WorldInfo.GRI).CanWriteStats() && NumPlayers >= 2) && AdvGameSurvivalBase(WorldInfo.Game) == none)
    {
        // End:0x967
        foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC_MP)
        {
            // End:0x850
            if(PC_MP.PlayerReplicationInfo.Deaths != 0)
            {
                // End:0x84D
                if(((PC_MP.PlayerReplicationInfo.Kills / PC_MP.PlayerReplicationInfo.Deaths) > 0) && float(PC_MP.PlayerReplicationInfo.Kills / PC_MP.PlayerReplicationInfo.Deaths) >= KDMax)
                {
                    PC_MP.ClientUnlockAchievement(34);
                }                
            }
            else
            {
                // End:0x8F0
                if((PC_MP.PlayerReplicationInfo.Kills > 0) && float(PC_MP.PlayerReplicationInfo.Kills) >= KDMax)
                {
                    PC_MP.ClientUnlockAchievement(34);
                }
            }
            // End:0x966
            if((PC_MP.PlayerReplicationInfo.Score == float(ScoreMax)) && ScoreMax != 0)
            {
                PC_MP.ClientUnlockAchievement(33);
            }            
        }        
    }
    AddBonusScore();
    // End:0xCE8
    if(AdvGRI(WorldInfo.GRI).CanWriteStats())
    {
        // End:0xB44
        if(AdvTeamInfo(WorldInfo.GRI.Winner) != none)
        {
            // End:0xB40
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC_MP)
            {
                // End:0xB3F
                if(PC_MP.PlayerReplicationInfo.Team == TeamInfo(WorldInfo.GRI.Winner))
                {
                    IncrementEndGameStatistics(PC_MP);
                    PC_MP.ClientAddBonusScoreForWin(ScoreForWin);
                    PC_MP.PlayerReplicationInfo.Score += float(ScoreForWin);
                    PC_MP.AddXP(XPForWin);
                }                
            }                        
        }
        else
        {
            // End:0xCE8
            if(AdvPRI(WorldInfo.GRI.Winner) != none)
            {
                // End:0xCE7
                foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC_MP)
                {
                    // End:0xCE6
                    if(PC_MP.PlayerReplicationInfo.Score == PlayerReplicationInfo(WorldInfo.GRI.Winner).Score)
                    {
                        IncrementEndGameStatistics(PC_MP);
                        PC_MP.ClientAddBonusScoreForWin(ScoreForWin);
                        PC_MP.PlayerReplicationInfo.Score += float(ScoreForWin);
                        PC_MP.AddXP(XPForWin);
                    }                    
                }                
            }
        }
    }
    PlayEndMatchSound();
    ShowEndScreen();
    //return;    
}

function AddBonusScore()
{
    //return;    
}

function ShowEndScreen()
{
    AdvGRI(GameReplicationInfo).ServerShowEndScreenMP();
    //return;    
}

function IncrementEndGameStatistics(AdvPlayerControllerMP Winner)
{
    //return;    
}

function StopAllPawns()
{
    local Pawn P;

    // End:0x56
    foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
    {
        P.TurnOff();        
    }    
    //return;    
}

function PlayEndOfMatchMessage()
{
    local UTPlayerController PC;

    // End:0xB5
    if(DominatingVictory())
    {
        // End:0xB1
        foreach WorldInfo.AllControllers(Class'EvilGame.UTPlayerController', PC)
        {
            // End:0x85
            if(IsAWinner(PC))
            {
                PC.ClientPlayAnnouncement(VictoryMessageClass, 0);
                // End:0xB0
                continue;
            }
            PC.ClientPlayAnnouncement(VictoryMessageClass, 1);            
        }                
    }
    else
    {
        PlayRegularEndOfMatchMessage();
    }
    //return;    
}

function PlayRegularEndOfMatchMessage()
{
    local UTPlayerController PC;

    // End:0x105
    foreach WorldInfo.AllControllers(Class'EvilGame.UTPlayerController', PC)
    {
        // End:0x104
        if((PC.PlayerReplicationInfo != none) && !PC.PlayerReplicationInfo.bOnlySpectator)
        {
            // End:0xD8
            if(IsAWinner(PC))
            {
                PC.ClientPlayAnnouncement(VictoryMessageClass, 2);
                // End:0x104
                continue;
            }
            PC.ClientPlayAnnouncement(VictoryMessageClass, 3);
        }        
    }    
    //return;    
}

function PreEndOfGameTransition()
{
    local array<AdvRecentPlayer> GearPlayers;
    local AdvRecentPlayer GearCurrentPlayer;
    local AdvRecentPlayersList RecentPlayersList;
    local int PartyResIdx, PlayerResIdx, PRIIdx;
    local UniqueNetId ZeroId;
    local AdvPRI PRI;

    EnableStandbyCheatDetection(false);
    SetGameSettingNeedsSize('Game', 0);
    PRIIdx = 0;
    J0x2D:

    // End:0x187 [Loop If]
    if(PRIIdx < AdvGRI(GameReplicationInfo).PRIArray.Length)
    {
        PRI = AdvPRI(AdvGRI(GameReplicationInfo).PRIArray[PRIIdx]);
        // End:0x179
        if(PRI.UniqueId != ZeroId && PRI.PlayerSkill > 0)
        {
            HostPlayerMatchBeacon.UpdatePlayerReservationSkills(PRI.UniqueId, PRI.PlayerSkill, PRI.PlayerLevel);
        }
        PRIIdx++;
        // [Loop Continue]
        goto J0x2D;
    }
    RecentPlayersList = AdvRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
    // End:0x4D5
    if(RecentPlayersList != none)
    {
        RecentPlayersList.ClearAllPKParties();
        PartyResIdx = 0;
        J0x1FB:

        // End:0x4D5 [Loop If]
        if(PartyResIdx < HostPlayerMatchBeacon.Reservations.Length)
        {
            GearPlayers.Length = 0;
            GearCurrentPlayer.TeamNum = HostPlayerMatchBeacon.Reservations[PartyResIdx].TeamNum;
            PlayerResIdx = 0;
            J0x297:

            // End:0x464 [Loop If]
            if(PlayerResIdx < HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyMembers.Length)
            {
                GearCurrentPlayer.Skill = HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyMembers[PlayerResIdx].Skill;
                GearCurrentPlayer.NetId = HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyMembers[PlayerResIdx].NetId;
                GearCurrentPlayer.Level = HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyMembers[PlayerResIdx].XpLevel;
                GearPlayers.AddItem(GearCurrentPlayer);                
                PlayerResIdx++;
                // [Loop Continue]
                goto J0x297;
            }
            RecentPlayersList.AddLastPKParty(HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyLeader, GearPlayers);
            PartyResIdx++;
            // [Loop Continue]
            goto J0x1FB;
        }
    }
    //return;    
}

function UpdateGameSettings()
{
    local string MapName, GameTypeName;
    local OnlineGameSettings GameSettings;
    local AdvPlayerController PC;

    super.UpdateGameSettings();
    // End:0x72
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
    }
    // End:0x25F
    if((GameSettings != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        MapName = WorldInfo.GetMapName(true);
        GameTypeName = PathName(WorldInfo.GetGameClass());
        GameSettings.SetPropertyFromStringByName('CustomMapName', MapName);
        GameSettings.SetPropertyFromStringByName('CustomGameMode', GameTypeName);
        GameSettings.SetStringSettingValue(37, ((RequiresPassword()) ? 1 : 0), false);
        GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName, GameSettings);
        // End:0x25E
        foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
        {
            // End:0x25D
            if(!PC.IsLocalPlayerController())
            {
                PC.UpdateGameSettings('Game');
            }            
        }        
    }
    //return;    
}

function int GetVoiceChannel(AdvPlayerController PC)
{
    return ((PC.IsSpectating()) ? 0 : 1);
    //return ReturnValue;    
}

function RecalculateSkillRating()
{
    //return;    
}

function PreBeginPlay()
{
    super(EvilGame).PreBeginPlay();
    GetGRI().bKillingSpree = bKillingSpree;
    GetGRI().bRealism = bRealism;
    GetGRI().RespawnTime = RespawnTime;
    GetGRI().bOracle = bOracle;
    GetGRI().bTraps = bTraps;
    GetGRI().bTeamDamage = bTeamDamage;
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;
    local OnlineGameSettings GameSettings;
    local AdvPlayerController PC;

    // End:0x44
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0x43
        if(PC != none)
        {
        }        
    }    
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xE1
    if(OnlineSub != none)
    {
        GameHostMigrationManager = AdvGameHostMigrationManager(OnlineSub.GetNamedInterface('GameHostMigrationManager'));
        OnlineSub.SetNamedInterface('GameHostMigrationManager', none);
    }
    // End:0x261
    if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        PlaylistId = -1;
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
        // End:0x239
        if((GameSettings != none) && GameSettings.GetIntProperty(268435457, PlaylistId))
        {
            // End:0x239
            if(PlaylistId > -1)
            {                
                Options $= PlaylistMan.GetUrlFromPlaylist(PlaylistId);
            }
        }
        PlaylistMan.CurrentPlaylistId = PlaylistId;
    }
    InOpt = ParseOption(Options, "mapslist");
    // End:0x2AB
    if(InOpt != "")
    {
        PrepareMapsList(InOpt);
    }
    // End:0x2D6
    if(WorldInfo.TimeSeconds == 0.0000000)
    {
        SaveConfig();
    }
    super.InitGame(Options, ErrorMessage);
    SetGameRulesFromUrl(Options);
    InitBeaconStuff();
    bShouldWaitForNetPlayers = bWaitForNetPlayers && int(WorldInfo.NetMode) != int(NM_Standalone);
    // End:0x5F1
    if(GameHostMigrationManager != none)
    {
        bRealism = GameHostMigrationManager.GameData.bRealism;
        bOracle = GameHostMigrationManager.GameData.bOracle;
        bKillingSpree = GameHostMigrationManager.GameData.bKillingSpree;
        bTraps = GameHostMigrationManager.GameData.bTraps;
        RespawnTime = GameHostMigrationManager.GameData.RespawnTime;
        bTeamDamage = GameHostMigrationManager.GameData.bTeamDamage;
        TimeLimit = GameHostMigrationManager.GameData.TimeLimit;
        GoalScore = GameHostMigrationManager.GameData.GoalScore;
        RoundsToWin = GameHostMigrationManager.GameData.RoundsToWin;
        ScoreForWin = GameHostMigrationManager.GameData.ScoreForWin;
        XPForWin = GameHostMigrationManager.GameData.XPForWin;
    }
    //return;    
}

static function SetDefaultTeamInfo(out int TeamSize, out int TeamCount, out int MaxPartySize)
{
    TeamSize = 6;
    TeamCount = 2;
    MaxPartySize = Class'AdvGameSettingsCommon'.default.MaxPlayers;
    //return;    
}

function InitBeaconStuff()
{
    local int RecentPartyIdx;
    local OnlineGameSettings GameSettings;
    local AdvRecentPlayersList RecentPlayersList;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xC4
    if(OnlineSub != none)
    {
        GameHostMigrationManager = AdvGameHostMigrationManager(OnlineSub.GetNamedInterface('GameHostMigrationManager'));
        OnlineSub.SetNamedInterface('GameHostMigrationManager', none);
        GameInterface = OnlineSub.GameInterface;
    }
    // End:0x88D
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings('Game');
        // End:0x88D
        if((GameSettings != none) && GameSettings.GetIntProperty(268435457, PlaylistId))
        {
            PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
            PlaylistMan.CurrentPlaylistId = PlaylistId;
            // End:0x214
            if(PlaylistId > -1)
            {
                PlaylistMan.GetTeamInfoFromPlaylist(PlaylistId, PlaylistTeamSize, PlaylistTeamCount, PlaylistMaxPartySize);                
            }
            else
            {
                SetDefaultTeamInfo(PlaylistTeamSize, PlaylistTeamCount, PlaylistMaxPartySize);
            }
            bPauseable = false;
            HostPlayerMatchBeacon = new Class'AdvPlayerMatchBeaconHost';
            HostPlayerMatchBeacon.BeaconName = 'AdvPlayerMatchHost';
            HostPlayerMatchBeacon.InitHostBeacon(PlaylistTeamCount, PlaylistTeamSize, PlaylistTeamCount * PlaylistTeamSize, 'Game', 1);
            RecentPlayersList = AdvRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
            // End:0x788
            if(RecentPlayersList != none)
            {
                RecentPartyIdx = 0;
                J0x329:

                // End:0x553 [Loop If]
                if(RecentPartyIdx < RecentPlayersList.LastPKParties.Length)
                {
                    // End:0x545
                    if(RecentPlayersList.LastPKParties[RecentPartyIdx].PartyMembers.Length > 0)
                    {
                        // End:0x545
                        if((RecentPlayersList.LastPKParties[RecentPartyIdx].PartyMembers[0].TeamNum >= 0) && RecentPlayersList.LastPKParties[RecentPartyIdx].PartyMembers[0].TeamNum < PlaylistTeamCount)
                        {
                            HostPlayerMatchBeacon.AddPKPartyReservation(RecentPlayersList.LastPKParties[RecentPartyIdx].PartyLeader, RecentPlayersList.LastPKParties[RecentPartyIdx].PartyMembers, GameSettings.OwningPlayerId == RecentPlayersList.LastPKParties[RecentPartyIdx].PartyLeader);
                        }
                    }
                    RecentPartyIdx++;
                    // [Loop Continue]
                    goto J0x329;
                }
                RecentPartyIdx = 0;
                J0x55E:

                // End:0x788 [Loop If]
                if(RecentPartyIdx < RecentPlayersList.LastPKParties.Length)
                {
                    // End:0x77A
                    if(RecentPlayersList.LastPKParties[RecentPartyIdx].PartyMembers.Length > 0)
                    {
                        // End:0x77A
                        if((RecentPlayersList.LastPKParties[RecentPartyIdx].PartyMembers[0].TeamNum < 0) || RecentPlayersList.LastPKParties[RecentPartyIdx].PartyMembers[0].TeamNum >= PlaylistTeamCount)
                        {
                            HostPlayerMatchBeacon.AddPKPartyReservation(RecentPlayersList.LastPKParties[RecentPartyIdx].PartyLeader, RecentPlayersList.LastPKParties[RecentPartyIdx].PartyMembers, GameSettings.OwningPlayerId == RecentPlayersList.LastPKParties[RecentPartyIdx].PartyLeader);
                        }
                    }
                    RecentPartyIdx++;
                    // [Loop Continue]
                    goto J0x55E;
                }
            }
            // End:0x7DD
            if(!GameSettings.bAllowJoinInProgress && HostPlayerMatchBeacon != none)
            {
                HostPlayerMatchBeacon.PauseReservationRequests(true);
            }
            HostPlayerMatchBeacon.__OnReservationChange__Delegate = OnHostBeaconReservationChange;
            GameSettings.NumPublicConnections = PlaylistTeamCount * PlaylistTeamSize;
            SetGameSettingNeedsSize('Game', 0, false);
            GameInterface.UpdateOnlineGame('Game', GameSettings, false);            
        }
    }
    //return;    
}

function OnHostBeaconReservationChange()
{
    local AdvPlayerController PCIter;

    // End:0x48
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PCIter)
    {
        UpdatePlayerMatchInvites(PCIter);        
    }    
    UpdatePlayerMatchNeedWantsStatus();
    //return;    
}

function UpdatePlayerMatchInvites(AdvPlayerController PC)
{
    local UniqueNetId ZeroId;
    local int CurrentTeamSize;
    local OnlineGameSettings GameSettings;

    CurrentTeamSize = PlaylistTeamSize;
    // End:0x293
    if(((PC != none) && PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.UniqueId != ZeroId)
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        // End:0x134
        if(GameSettings != none)
        {
            CurrentTeamSize = GameSettings.NumPublicConnections - GameSettings.NumOpenPublicConnections;            
        }
        else
        {
            CurrentTeamSize = 0;
        }
        // End:0x25C
        if(CurrentTeamSize < (PlaylistTeamSize * PlaylistTeamCount))
        {
            // End:0x222
            if(GameSettings != none)
            {
                PC.ClientSetPartyInviteFlags(GameSettings.bAllowInvites, GameSettings.bAllowJoinViaPresence, GameSettings.bAllowJoinViaPresenceFriendsOnly, PlaylistTeamSize * PlaylistTeamCount, GameSettings.bAllowJoinInProgress);                
            }
            else
            {
                PC.ClientSetPartyInviteFlags(true, true, true, PlaylistTeamSize * PlaylistTeamCount);
            }            
        }
        else
        {
            PC.ClientSetPartyInviteFlags(false, false, false, PlaylistTeamSize * PlaylistTeamCount, false);
        }
    }
    //return;    
}

function PrepareMapsList(string strList)
{
    local AdvEngine GEngine;

    GEngine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0xB4
    if(GEngine.AdvMapsArray.Length <= 0)
    {
        ParseStringIntoArray(strList, GEngine.AdvMapsArray, ",", true);
        GEngine.AdvMapsString = strList;
    }
    //return;    
}

function string GetNextMap()
{
    return Class'AdvPreGameLobbyGame_Base'.static.GetTravelToPreGameLobbyUrl();
    //return ReturnValue;    
}

function SetGameRulesFromUrl(string Options)
{
    local int IntValue, idPlaylist;
    local AdvGameSettingsCommon MyGameSettings;
    local OnlineGameSettings GameSettings;
    local string InOpt;
    local AdvPlayerController PC;

    GameSettingsId = GetIntOption(Options, "GameSettingsId", -1);
    MyGameSettings = GetGameSettingsObject();
    GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
    // End:0x706
    if((MyGameSettings != none) && GameSettingsId != -1)
    {
        // End:0x14C
        if(MyGameSettings.GetIntProperty(MyGameSettings.268435705, IntValue))
        {
            TimeLimit = IntValue;
            GameSettings.SetIntProperty(MyGameSettings.268435705, IntValue);
        }
        // End:0x1E6
        if(MyGameSettings.GetIntProperty(MyGameSettings.268435704, IntValue))
        {
            GoalScore = IntValue;
            GameSettings.SetIntProperty(MyGameSettings.268435704, IntValue);
        }
        // End:0x280
        if(MyGameSettings.GetIntProperty(MyGameSettings.268435706, IntValue))
        {
            RoundsToWin = IntValue;
            GameSettings.SetIntProperty(MyGameSettings.268435706, IntValue);
        }
        // End:0x31A
        if(MyGameSettings.GetIntProperty(MyGameSettings.268435707, IntValue))
        {
            ScoreForWin = IntValue;
            GameSettings.SetIntProperty(MyGameSettings.268435707, IntValue);
        }
        // End:0x3B4
        if(MyGameSettings.GetIntProperty(MyGameSettings.268435708, IntValue))
        {
            XPForWin = IntValue;
            GameSettings.SetIntProperty(MyGameSettings.268435708, IntValue);
        }
        // End:0x434
        if(MyGameSettings.GetStringSettingValue(MyGameSettings.0, IntValue))
        {
            GameSettings.SetStringSettingValue(MyGameSettings.0, IntValue);
        }
        // End:0x4BC
        if(MyGameSettings.GetStringSettingValue(MyGameSettings.32779, IntValue))
        {
            GameSettings.SetStringSettingValue(MyGameSettings.32779, IntValue);
        }
        InOpt = MyGameSettings.GetPropertyAsStringByName('CustomGameMode');
        // End:0x52F
        if(InOpt != "")
        {
            GameSettings.SetPropertyFromStringByName('CustomGameMode', InOpt);
        }
        GameSettings.bAllowJoinInProgress = MyGameSettings.bAllowJoinInProgress;
        GameSettings.bAllowInvites = MyGameSettings.bAllowInvites;
        GameSettings.bAllowJoinViaPresence = MyGameSettings.bAllowJoinViaPresence;
        GameSettings.bAllowJoinViaPresenceFriendsOnly = MyGameSettings.bAllowJoinViaPresenceFriendsOnly;
        GameSettings.bUsesStats = MyGameSettings.bUsesStats;
        GameSettings.bIsLanMatch = MyGameSettings.bIsLanMatch;
        GameSettings.SetIntProperty(MyGameSettings.1073741829, int(GameSettings.bAllowJoinInProgress));        
    }
    else
    {
        InOpt = ParseOption(Options, "TimeLimit");
        // End:0x753
        if(InOpt != "")
        {
            TimeLimit = int(InOpt);
        }
        InOpt = ParseOption(Options, "GoalScore");
        // End:0x7A0
        if(InOpt != "")
        {
            GoalScore = int(InOpt);
        }
        InOpt = ParseOption(Options, "RoundsToWin");
        // End:0x7EF
        if(InOpt != "")
        {
            RoundsToWin = int(InOpt);
        }
        InOpt = ParseOption(Options, "ScoreForWin");
        // End:0x83E
        if(InOpt != "")
        {
            ScoreForWin = int(InOpt);
        }
        InOpt = ParseOption(Options, "XPForWin");
        // End:0x88A
        if(InOpt != "")
        {
            XPForWin = int(InOpt);
        }
        InOpt = ParseOption(Options, "MultiplayerMode");
        // End:0x961
        if(InOpt != "")
        {
            GameSettings.SetStringSettingValue(MyGameSettings.0, int(InOpt));
            // End:0x961
            if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
            {
                GameSettings.bAllowJoinInProgress = int(InOpt) != 3;
            }
        }
        InOpt = ParseOption(Options, "GameMode");
        // End:0x9DD
        if(InOpt != "")
        {
            GameSettings.SetStringSettingValue(MyGameSettings.32779, int(InOpt));
        }
        InOpt = ParseOption(Options, "CustomGameMode");
        // End:0xA4B
        if(InOpt != "")
        {
            GameSettings.SetPropertyFromStringByName('CustomGameMode', InOpt);
        }
        InOpt = ParseOption(Options, "bIsLanMatch");
        // End:0xAB0
        if(InOpt != "")
        {
            GameSettings.bIsLanMatch = bool(InOpt);
        }
    }
    GameSettings.SetStringProperty(1073741825, WorldInfo.GetMapName(true));
    DesiredPlayerCount = ((HasOption(Options, "NumPlay")) ? Clamp(GetIntOption(Options, "NumPlay", 1), 1, 32) : LevelRecommendedPlayers());
    InOpt = ParseOption(Options, "PlayersMustBeReady");
    // End:0xBA2
    if(InOpt != "")
    {
        bPlayersMustBeReady = bool(InOpt);
    }
    InOpt = ParseOption(Options, "MinNetPlayers");
    // End:0xBF3
    if(InOpt != "")
    {
        MinNetPlayers = int(InOpt);
    }
    InOpt = ParseOption(Options, "TeamDamage");
    // End:0xC57
    if(InOpt != "")
    {
        bTeamDamage = bool(InOpt);
        bAllowFriendlyFire = bTeamDamage;
    }
    InOpt = ParseOption(Options, "RespawnTime");
    // End:0xCA6
    if(InOpt != "")
    {
        RespawnTime = float(InOpt);
    }
    InOpt = ParseOption(Options, "Traps");
    // End:0xCF0
    if(InOpt != "")
    {
        bTraps = bool(InOpt);
    }
    InOpt = ParseOption(Options, "KillingSpree");
    // End:0xD41
    if(InOpt != "")
    {
        bKillingSpree = bool(InOpt);
    }
    InOpt = ParseOption(Options, "Oracle");
    // End:0xD8C
    if(InOpt != "")
    {
        bOracle = bool(InOpt);
    }
    InOpt = ParseOption(Options, "Realism");
    // End:0xDD8
    if(InOpt != "")
    {
        bRealism = bool(InOpt);
    }
    // End:0xE7C
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        InOpt = ParseOption(Options, "WarmupTime");
        // End:0xE79
        if(InOpt != "")
        {
            WarmupTime = int(InOpt);
            WarmupRemaining = WarmupTime;
            bWarmupRound = WarmupTime > 0;
        }        
    }
    else
    {
        bWarmupRound = false;
    }
    GameSettings.GetIntProperty(268435457, idPlaylist);
    // End:0xEE9
    if(idPlaylist == -2)
    {
        GameSettings.bAllowJoinInProgress = true;
    }
    // End:0xF6A
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0xF69
        if(!PC.IsLocalPlayerController())
        {
            PC.UpdateGameSettings('Game');
        }        
    }    
    GameInterface.UpdateOnlineGame('Game', GameSettings, true);
    // End:0xFF3
    if(!GameSettings.bAllowJoinInProgress && HostPlayerMatchBeacon != none)
    {
        HostPlayerMatchBeacon.PauseReservationRequests(true);
    }
    //return;    
}

function AdvGameSettingsCommon GetGameSettingsObject()
{
    local AdvGameSettingsCommon GameSettings, PlaylistSettings;

    // End:0x12F
    if(NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = AdvGameSettingsCommon(OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName));
        // End:0x12F
        if(PlaylistMan != none)
        {
            PlaylistSettings = AdvGameSettingsCommon(PlaylistMan.GetGameSettings(PlaylistMan.CurrentPlaylistId, GameSettingsId));
            // End:0x125
            if(PlaylistSettings == none)
            {
                PlaylistSettings = GameSettings;
            }
            return PlaylistSettings;
        }
    }
    // End:0x15C
    if(GameSettings == none)
    {
        GameSettings = AdvGameSettingsCommon(GetCurrentGameSettings(true));
    }
    return GameSettings;
    //return ReturnValue;    
}

function CheckIfSomeoneUsingSameSkinAsExitingPRIAndInformOtherPRIsToUnloadHisSkinLol(AdvPRI LogoutPRI)
{
    local int I, J;
    local AdvPRI OtherPRI;
    local string FamilyInfoClassPathToUnload;
    local AdvPlayerControllerMP PC;

    // End:0x11
    if(LogoutPRI == none)
    {
        return;
    }
    FamilyInfoClassPathToUnload = PathName(LogoutPRI.GetCharClassInfo());
    I = 0;
    J0x4F:

    // End:0x1CC [Loop If]
    if(I < GameReplicationInfo.PRIArray.Length)
    {
        OtherPRI = AdvPRI(GameReplicationInfo.PRIArray[I]);
        // End:0xD1
        if(OtherPRI == LogoutPRI)
        {            
        }
        else
        {
            // End:0x116
            if(OtherPRI.GetCharClassInfo() == LogoutPRI.GetCharClassInfo())
            {
                return;
            }
            J = 0;
            J0x121:

            // End:0x1BE [Loop If]
            if(J < OtherPRI.CharacterStore.PendingClasses.Length)
            {
                // End:0x1B0
                if(OtherPRI.CharacterStore.PendingClasses[J] == FamilyInfoClassPathToUnload)
                {
                    return;
                }
                J++;
                // [Loop Continue]
                goto J0x121;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x4F;
    }
    // End:0x298
    if(FamilyInfoClassPathToUnload != "")
    {
        // End:0x239
        foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
        {
            PC.ClientUnloadMPCharacter(FamilyInfoClassPathToUnload);            
        }        
        // End:0x297
        foreach WorldInfo.LocalPlayerControllers(Class'AdvPlayerControllerMP', PC)
        {
            PC.ClientUnloadMPCharacter(FamilyInfoClassPathToUnload);            
        }        
    }
    //return;    
}

function Logout(Controller Exiting)
{
    local UniqueNetId ZeroId;
    local AdvPlayerController PC;

    super.Logout(Exiting);
    PC = AdvPlayerController(Exiting);
    // End:0x5D
    if(PC != none)
    {
        PC.CleanupSteamLobby();
    }
    // End:0x140
    if((((HostPlayerMatchBeacon != none) && PC != none) && PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.UniqueId != ZeroId)
    {
        HostPlayerMatchBeacon.HandlePlayerLogout(PC.PlayerReplicationInfo.UniqueId, false);
    }
    // End:0x24D
    if((GameReplicationInfo.PRIArray.Length == 1) && GameReplicationInfo.PRIArray[0] == PlayerController(Exiting).PlayerReplicationInfo)
    {
        GameReplicationInfo.Winner = none;
        AdvGRI(GameReplicationInfo).bWinnerUpdated = true;
        EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
        EndGame(none, "NotEnoughPlayers");
    }
    UpdateGameSettings();
    //return;    
}

event GameEnding()
{
    DestroyHostBeacon();
    super.GameEnding();
    //return;    
}

function UpdateBestNextHosts()
{
    //return;    
}

static simulated function byte GetMPMapNameID(string MapName)
{
    switch(Locs(MapName))
    {
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

function SetMPRichPresenceString(AdvPlayerController PC)
{
    local byte MapNameId;
    local AdvTypes.EMultiGameMode MPType;
    local string MapName;

    // End:0xBB
    if(OnlineSub != none)
    {
        MapName = WorldInfo.GetMapName();
        MapNameId = GetMPMapNameID(MapName);
        MPType = Class'AdvGRI'.static.GetMultiGameMode(Class);
        PC.ClientSetMPRichPresenceString(6, MPType, MapNameId);
    }
    //return;    
}

auto state PendingMatch
{
    ignores CheckLives, CheckScore, ScoreKill;

    event GenericPlayerInitialization(Controller NewPlayer)
    {
        global.GenericPlayerInitialization(NewPlayer);
        //return;        
    }

    function RestartPlayer(Controller aPlayer)
    {
        // End:0x3E
        if(UTGameReplicationInfo(GameReplicationInfo).bWarmupRound)
        {
            global.RestartPlayer(aPlayer);
        }
        //return;        
    }

    function Timer()
    {
        local AdvPlayerControllerMP PC;
        local SoundCue CountDownSound;

        global.Timer();
        // End:0xA4
        if(NumPlayers == 0)
        {
            bShouldWaitForNetPlayers = bWaitForNetPlayers && int(WorldInfo.NetMode) != int(NM_Standalone);
            // End:0xA1
            if(bWarmupRound)
            {
                WarmupRemaining = WarmupTime;
                GameReplicationInfo.RemainingTime = WarmupRemaining;
            }            
        }
        else
        {
            // End:0x185
            if(bWarmupRound)
            {
                // End:0x133
                if(WarmupRemaining > 0)
                {
                    WarmupRemaining--;
                    GameReplicationInfo.RemainingTime = WarmupRemaining;
                    // End:0x12E
                    if((WarmupRemaining % 60) == 0)
                    {
                        GameReplicationInfo.RemainingMinute = WarmupRemaining;
                    }
                    return;                    
                }
                else
                {
                    // End:0x185
                    if(WarmupRemaining == 0)
                    {
                        WarmupRemaining = -1;
                        UTGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
                        ResetLevel();
                    }
                }
            }
        }
        // End:0x227
        if(bShouldWaitForNetPlayers)
        {
            // End:0x1C8
            if((NumPlayers >= MinNetPlayers) && NumPlayers > 0)
            {
                PendingMatchElapsedTime++;                
            }
            else
            {
                PendingMatchElapsedTime = 0;
            }
            // End:0x225
            if((NumPlayers == MaxPlayers) || PendingMatchElapsedTime > NetWait)
            {
                bShouldWaitForNetPlayers = false;
                CountDown = default.CountDown;                
            }
            else
            {
                return;
            }
        }
        StartupStage = 1;
        // End:0x28E
        if(!bStartedCountDown)
        {
            // End:0x282
            if(DemoPrefix != "")
            {                
                ConsoleCommand(("demorec" @ DemoPrefix) $ "-%td");
            }
            bStartedCountDown = true;
        }
        CountDown--;
        // End:0x2B5
        if(CountDown <= 0)
        {
            StartMatch();            
        }
        else
        {
            // End:0x3BE
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
            {
                // End:0x319
                if(CountDown <= 10)
                {
                    CountDownSound = CountdownSounds[CountDown - 1];
                }
                // End:0x386
                if(PC.PlayerReplicationInfo.bReadyToPlay)
                {
                    PC.SetCountDownMessage(string(CountDown), CountDownSound);
                    // End:0x3BD
                    continue;
                }
                // End:0x3BD
                if(CountDownSound != none)
                {
                    PC.ClientPlaySound(CountDownSound);
                }                
            }            
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x5D
        if(bWarmupRound)
        {
            GameReplicationInfo.RemainingTime = WarmupRemaining;
            GameReplicationInfo.RemainingMinute = WarmupRemaining;
        }
        bWaitingToStartMatch = true;
        UTGameReplicationInfo(GameReplicationInfo).bWarmupRound = bWarmupRound;
        StartupStage = 0;
        //return;        
    }

    function EndState(name NextStateName)
    {
        UTGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
        //return;        
    }
Begin:

    // End:0x6D
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_ListenServer)) && !IsConsoleDedicatedServer())
    {
        Sleep(0.0000000);
    }
    // End:0xB3
    if((DesiredPlayerCount <= 1) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        bQuickStart = true;
    }
    // End:0x10A
    if(bQuickStart)
    {
        // End:0x100
        if(DemoPrefix != "")
        {            
            ConsoleCommand(("demorec" @ DemoPrefix) $ "-%td");
        }
        StartMatch();
    }
    stop;        
}

state MatchInProgress
{
    function bool MatchIsInProgress()
    {
        return true;
        //return ReturnValue;        
    }

    function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
    {
        local bool bSuccess;
        local UTPlayerController UTPC;

        bSuccess = global.ChangeTeam(Other, Num, bNewTeam);
        UTPC = UTPlayerController(Other);
        // End:0x70
        if(UTPC != none)
        {
            SetupPlayerMuteList(UTPC, false);
        }
        return bSuccess;
        //return ReturnValue;        
    }

    function Timer()
    {
        local PlayerController P;

        global.Timer();
        // End:0x2F
        if(!bFinalStartup)
        {
            bFinalStartup = true;
            PlayStartupMessage();
        }
        // End:0x120
        if(ForceRespawn())
        {
            // End:0x11F
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
            {
                // End:0x11E
                if(((P.Pawn == none) && !P.PlayerReplicationInfo.bOnlySpectator) && !P.IsTimerActive('DoForcedRespawn'))
                {
                    P.ServerRestartPlayer();
                }                
            }            
        }
        // End:0x14F
        if(bOverTime)
        {
            EndGame(GetWinner(), "TimeLimit");            
        }
        else
        {
            // End:0x1C5
            if(TimeLimit > 0)
            {
                GameReplicationInfo.bStopCountDown = false;
                // End:0x1C2
                if(GameReplicationInfo.RemainingTime <= 0)
                {
                    EndGame(GetWinner(), "TimeLimit");
                }                
            }
            else
            {
                // End:0x1FB
                if((MaxLives > 0) && (NumPlayers + NumBots) != 1)
                {
                    CheckMaxLives(none);
                }
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local PlayerReplicationInfo PRI;

        AdvGRI(GameReplicationInfo).RoundWinner = none;
        // End:0xF3
        if(PreviousStateName != 'RoundOver')
        {
            // End:0x7A
            foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
            {
                PRI.StartTime = 0;                
            }            
            GameReplicationInfo.ElapsedTime = 0;
            AdvGRI(GameReplicationInfo).bRoundWinnerUpdated = false;
            bWaitingToStartMatch = false;
            StartupStage = 5;
            PlayStartupMessage();
            StartupStage = 6;
        }
        // End:0x148
        if(GameHostMigrationManager != none)
        {
            GameHostMigrationManager.UpdateTeamData(AdvGRI(WorldInfo.GRI));
        }
        //return;        
    }
    stop;    
}

state MatchOver
{
    ignores RestartPlayer, ScoreKill;

    function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
    {
        Damage = 0;
        Momentum = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
    {
        // End:0x5A
        if(Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.bOutOfLives = true;
        }
        return true;
        //return ReturnValue;        
    }

    event PostLogin(PlayerController NewPlayer)
    {
        global.PostLogin(NewPlayer);
        NewPlayer.GameHasEnded(EndGameFocus);
        //return;        
    }

    function Timer()
    {
        local PlayerController PC;
        local Sequence GameSequence;
        local array<SequenceObject> AllInterpActions;
        local SeqAct_Interp InterpAction;
        local int I, J;
        local bool bIsInCinematic;

        global.Timer();
        // End:0x5E
        if(!bGameRestarted && WorldInfo.RealTimeSeconds > (EndTime + float(RestartWait)))
        {
            RestartGame();
        }
        // End:0x2CF
        if(EndGameFocus != none)
        {
            EndGameFocus.bAlwaysRelevant = true;
            GameSequence = WorldInfo.GetGameSequence();
            // End:0x261
            if(GameSequence != none)
            {
                GameSequence.FindSeqObjectsByClass(Class'Engine.SeqAct_Interp', true, AllInterpActions);
                I = 0;
                J0x103:

                // End:0x261 [Loop If]
                if((I < AllInterpActions.Length) && !bIsInCinematic)
                {
                    InterpAction = SeqAct_Interp(AllInterpActions[I]);
                    // End:0x253
                    if((InterpAction.InterpData != none) && InterpAction.GroupInst.Length > 0)
                    {
                        J = 0;
                        J0x1A8:

                        // End:0x253 [Loop If]
                        if(J < InterpAction.InterpData.InterpGroups.Length)
                        {
                            // End:0x245
                            if(InterpGroupDirector(InterpAction.InterpData.InterpGroups[J]) != none)
                            {
                                bIsInCinematic = true;
                                // [Explicit Break]
                                goto J0x253;
                            }
                            J++;
                            // [Loop Continue]
                            goto J0x1A8;
                        }
                    }
                    J0x253:

                    I++;
                    // [Loop Continue]
                    goto J0x103;
                }
            }
            // End:0x2CF
            if(!bIsInCinematic)
            {
                // End:0x2CE
                foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
                {
                    PC.ClientSetViewTarget(EndGameFocus);                    
                }                
            }
        }
        EndMessageCounter++;
        // End:0x2FB
        if(EndMessageCounter == EndMessageWait)
        {
            PlayEndOfMatchMessage();
        }
        //return;        
    }

    function bool NeedPlayers()
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        local AdvPlayerControllerMP PC;

        ResetAllPlayerMuteListsToSpectatorChannel();
        GameReplicationInfo.bStopCountDown = true;
        global.StopAllPawns();
        // End:0x8F
        foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
        {
            PC.SetCinematicMode(true, false, false, true, true, false);            
        }        
        PreEndOfGameTransition();
        //return;        
    }

    function ResetLevel()
    {
        RestartGame();
        //return;        
    }

    function SetupPlayerMuteList(UTPlayerController PC, bool bForceSpectatorChannel)
    {
        super(EvilGame).SetupPlayerMuteList(PC, true);
        //return;        
    }
    stop;    
}

state RoundOver extends MatchOver
{
    event BeginState(name PreviousStateName)
    {
        local AdvPlayerControllerMP PC;
        local int EndRoundMummies, I;

        super.BeginState(PreviousStateName);
        AdvGRI(GameReplicationInfo).bFirstRound = false;
        AdvGRI(GameReplicationInfo).bTeamsInverted = !AdvGRI(GameReplicationInfo).bTeamsInverted;
        EndRoundMummies = MummiesInGame;
        I = 0;
        J0xAE:

        // End:0xDF [Loop If]
        if(I < EndRoundMummies)
        {
            UpdateMummyMusic(false);
            I++;
            // [Loop Continue]
            goto J0xAE;
        }
        ResetCountDown = Max(2, ResetTimeDelay);
        AdvGRI(GameReplicationInfo).ServerShowRoundEndScreen();
        // End:0x1C7
        foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
        {
            // End:0x1A7
            if(PC.IsTimerActive('ClientDisableWallSeeFlag'))
            {
                PC.ClearTimer('ClientDisableWallSeeFlag');
            }
            PC.ClientDisableWallSeeFlag();            
        }        
        //return;        
    }

    function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
    {
        return global.ChangeTeam(Other, Num, bNewTeam);
        //return ReturnValue;        
    }

    function ResetLevel()
    {
        GotoState('None');
        global.ResetLevel();
        GotoState('MatchInProgress');
        ResetCountDown = 0;
        //return;        
    }

    event Timer()
    {
        global.Timer();
        ResetCountDown--;
        // End:0x2E
        if(ResetCountDown == 1)
        {
            ResetLevel();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bTraps=true
    bKillingSpree=true
    bOracle=true
    bAllowDraws=true
    bPlayCloseToEndSounds=true
    RespawnTime=5.0000000
    RoundsToWin=1
    ScoreForWin=100
    XPForWin=300
    ScoreForFlawlessKill=100
    ScoreForFinisher=75
    ScoreForAssist=25
    ScoreForSuicide=50
    BonusScoreForTrapKill=50
    XPForFlawlessKill=100
    XPForFinisher=75
    XPForAssist=25
    XPForFirstKill=200
    XPforLMSRescue=150
    XPforLMSKill=100
    XPforRoundWon=250
    XPforLMSMatchWon=500
    BonusXPForTrapKill=50
    CountdownSounds[0]=SoundCue'a_anno_global01_cue.a_Countdown_01'
    CountdownSounds[1]=SoundCue'a_anno_global01_cue.a_Countdown_02'
    CountdownSounds[2]=SoundCue'a_anno_global01_cue.a_Countdown_03'
    CountdownSounds[3]=SoundCue'a_anno_global01_cue.a_Countdown_04'
    CountdownSounds[4]=SoundCue'a_anno_global01_cue.a_Countdown_05'
    CountdownSounds[5]=SoundCue'a_anno_global01_cue.a_Countdown_06'
    CountdownSounds[6]=SoundCue'a_anno_global01_cue.a_Countdown_07'
    CountdownSounds[7]=SoundCue'a_anno_global01_cue.a_Countdown_08'
    CountdownSounds[8]=SoundCue'a_anno_global01_cue.a_Countdown_09'
    CountdownSounds[9]=SoundCue'a_anno_global01_cue.a_Countdown_10'
    FlawlessKillStr="Flawless Kill!"
    FinisherStr="Finisher!"
    AssistStr="Assist!"
    FirstBloodMsg="First Blood!"
    StartMatchSound[0]=SoundCue'a_anno_global01_cue.ANNO_GLOBAL_002'
    StartMatchStringKey[0]="ANNO_GLOBAL_002"
    EndMatchSoundWin[0]=SoundCue'a_anno_dthtth01_cue.ANNO_DTHTTH_WON_001'
    EndMatchSoundWin[1]=SoundCue'a_anno_dthtth01_cue.ANNO_DTHTTH_WON_002'
    EndMatchWinStringKey[0]="ANNO_DTHTTH_WON_001"
    EndMatchWinStringKey[1]="ANNO_DTHTTH_WON_002"
    EndMatchSoundLose[0]=SoundCue'a_anno_dths01_cue.ANNO_DTHS_END_001'
    EndMatchLoseStringKey[0]="ANNO_DTHS_END_001"
    EndMatchSoundDraw[0]=SoundCue'a_anno_dths01_cue.ANNO_DTHS_END_001'
    EndMatchDrawStringKey[0]="ANNO_DTHS_END_001"
    CloseToEndWinSound[0]=SoundCue'a_anno_dth01_cue.ANNO_DTH_AEND_001'
    CloseToEndWinSound[1]=SoundCue'a_anno_dth01_cue.ANNO_DTH_AEND_002'
    CloseToEndWinStringKey[0]="ANNO_DTH_AEND_001"
    CloseToEndWinStringKey[1]="ANNO_DTH_AEND_002"
    CloseToEndLoseSound[0]=SoundCue'a_anno_dth01_cue.ANNO_DTH_AEND_001'
    CloseToEndLoseSound[1]=SoundCue'a_anno_dth01_cue.ANNO_DTH_AEND_002'
    CloseToEndLoseStringKey[0]="ANNO_DTH_AEND_001"
    CloseToEndLoseStringKey[1]="ANNO_DTH_AEND_002"
    FriendlyMarkerIcon=Texture2D'UI_AdvMultiplayerInGame.t_teammate'
    WaypointIcon=Texture2D'UI_AdvMultiplayerInGame.t_multiarea'
    EndTimeDelay=5.0000000
    NetWait=0
    RestartWait=13
    SpawnProtectionTime=0.0000000
    CountDown=11
    ResetTimeDelay=8
    ConsolePlayerControllerClass=Class'AdvPlayerControllerMP'
    DefaultPawnClass=Class'AdvPlayerPawnMP'
    MaxSpectatorsAllowed=0
    MaxPlayersAllowed=12
    DeathMessageClass=Class'EvilGame.EvilDeathMessage'
    PlayerControllerClass=Class'AdvPlayerControllerMP'
    GameReplicationInfoClass=Class'AdvGRI_MP'
}