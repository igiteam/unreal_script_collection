class AdvGameSP extends ADVGame
    config(Game)
    hidecategories(Navigation,Movement,Collision);

struct EvilCheckPoint
{
    var bool bValid;
    var Vector pos;
    var Rotator Rot;

    structdefaultproperties
    {
        bValid=false
        pos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rot=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct EvilTeleportInfo
{
    var Vector PawnLocation;
    var Rotator ControllerRotation;

    structdefaultproperties
    {
        PawnLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ControllerRotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

var bool bStartupLoadCheckpoint;
var bool bStartupSaveCheckpoint;
var bool bPlayingBattleMusic;
var bool bSetupSessionProcessComplete;
var bool bLoadingScreenFinished;
var int CurrentChapter;
var array<MusicTrackStruct> BattleMusic;
var array<MusicTrackStruct> AmbientMusic;
var float LastSeenEnemyTime;
var config array<config EvilTeleportInfo> TeleportInfos;
var delegate<OnStartupSessionSetupComplete> StartupSessionSetupCompleteDelegate;

event InitGame(string Options, out string ErrorMessage)
{
    local int ChapterOption;

    super.InitGame(Options, ErrorMessage);
    // End:0x7B
    if((HasOption(Options, "loadcheckpoint")) && (ParseOption(Options, "loadcheckpoint")) != "0")
    {
        bStartupLoadCheckpoint = true;
    }
    ChapterOption = GetIntOption(Options, "chapter", -1);
    // End:0xCB
    if(ChapterOption > 0)
    {
        CurrentChapter = ChapterOption;        
    }
    // End:0x13B
    if((HasOption(Options, "RestoreDefaultWeapons")) && (ParseOption(Options, "RestoreDefaultWeapons")) != "0")
    {
        bRestoreDefaultWeapons = true;        
    }
    else
    {
        bRestoreDefaultWeapons = false;
    }
    //return;    
}

function StartMatch()
{
    local AdvPlayerController PC;

    super.StartMatch();
    // End:0x67
    if(bStartupLoadCheckpoint)
    {
        // End:0x5A
        foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
        {
            PC.LoadCheckpoint();
            // End:0x5A
            break;            
        }        
        bStartupLoadCheckpoint = false;
    }
    //return;    
}

event CheckpointLoadComplete()
{
    local AdvAIController AI;

    bLoadingScreenFinished = false;
    // End:0x103
    foreach WorldInfo.AllControllers(Class'AdvAIController', AI)
    {
        // End:0x102
        if(AI.PendingCheckpointExploreAction != none)
        {
            AI.OnAIExplorePOI(AI.PendingCheckpointExploreAction);
            AI.LatentActions.InsertItem(0, AI.PendingCheckpointExploreAction);            
            AI.PendingCheckpointExploreAction = none;
        }        
    }    
    // End:0x1BB
    foreach WorldInfo.AllControllers(Class'AdvAIController', AI)
    {
        // End:0x1BA
        if(AI.PendingCheckpointForceCoverAction != none)
        {
            AI.OnForceCover2(AI.PendingCheckpointForceCoverAction, true);
            AI.PendingCheckpointForceCoverAction = none;
        }        
    }    
    super(EvilGame).CheckpointLoadComplete();
    PauseAndWaitForKeyPress();
    //return;    
}

function PauseAndWaitForKeyPress()
{
    local AdvPlayerController PC;

    // End:0x51
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        PC.SetPause(true, CanUnpauseAfterKeyPress);        
    }    
    //return;    
}

function bool CanUnpauseAfterKeyPress()
{
    return !AdvEngine(Class'Engine.Engine'.static.GetEngine()).IsPlayingLoadingMovie();
    //return ReturnValue;    
}

function UnpauseAfterKeyPress()
{
    local AdvPlayerController PC;

    // End:0x70
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        PC.SetPause(false, CanUnpauseAfterKeyPress);
        PC.CheckForControllerDisconnection();        
    }    
    //return;    
}

function LoadingScreenFinished()
{
    local AdvPlayerController PC;

    // End:0x62
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientSetButtonFilter(true);
        PC.ClientSetButtonFilter(false);        
    }    
    bLoadingScreenFinished = true;
    //return;    
}

function InitGameReplicationInfo()
{
    super.InitGameReplicationInfo();
    AdvGRI_SP(GameReplicationInfo).ChapterNum = CurrentChapter;
    //return;    
}

event int GetChapterNum()
{
    return CurrentChapter;
    //return ReturnValue;    
}

function ModifyScoreKill(Controller Killer, Controller Other)
{
    local AdvPRI PRI;
    local float ScoreMultiplier;

    super(GameInfo).ModifyScoreKill(Killer, Other);
    // End:0xB4
    if((Killer == Other) || Killer == none)
    {
        // End:0xB1
        if((Other != none) && Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.Score += float(1);
        }        
    }
    else
    {
        // End:0x20C
        if(Killer.PlayerReplicationInfo != none)
        {
            PRI = AdvPRI(Killer.PlayerReplicationInfo);
            PRI.LastComboTime = WorldInfo.TimeSeconds;
            PRI.ElapsedComboTime = 0.0000000;
            ScoreMultiplier = PRI.ScoreMultiplier;
            Killer.PlayerReplicationInfo.Score += ((float(Other.Pawn.HealthMax) * ScoreMultiplier) - float(1));
        }
    }
    //return;    
}

function ScoreHit(Controller HitInstigator, Controller Other, optional float Score = 1.0000000, optional int Priority, optional string ComboName)
{
    local float ScoreMultiplier;

    // End:0x146
    if(((HitInstigator != Other) && HitInstigator != none) && HitInstigator.PlayerReplicationInfo != none)
    {
        ScoreMultiplier = AdvPRI(HitInstigator.PlayerReplicationInfo).ScoreMultiplier;
        HitInstigator.PlayerReplicationInfo.Score += (Score * ScoreMultiplier);
        HitInstigator.PlayerReplicationInfo.bForceNetUpdate = true;
        CheckScore(HitInstigator.PlayerReplicationInfo);
    }
    //return;    
}

function ScoreLevel(PlayerController PC)
{
    // End:0x84
    if(PC != none)
    {
        PC.PlayerReplicationInfo.Score += float(10000 + (PC.Pawn.Health * 100));
    }
    //return;    
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local PlayerController NewPlayer, PC;
    local Controller C;
    local bool bDedicatedServerSpectator;

    // End:0x90
    if(((NumPlayers == 0) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && HasOption(Options, "dedicated"))
    {
        bDedicatedServerSpectator = true;        
        Options $= "?SpectatorOnly=1";
    }
    // End:0x166
    if(MaxLives > 0)
    {
        // End:0x165
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x164
            if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.NumLives > LateEntryLives)
            {
                Options = "?SpectatorOnly=1" $ Options;
                // End:0x165
                break;
            }            
        }        
    }
    NewPlayer = super.Login(Portal, Options, UniqueId, ErrorMessage);
    // End:0x248
    if(UTPlayerController(NewPlayer) != none)
    {
        // End:0x211
        if(bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
        {
            UTPlayerController(NewPlayer).bLateComer = true;
        }
        // End:0x248
        if(bDedicatedServerSpectator)
        {
            UTPlayerController(NewPlayer).bDedicatedServerSpectator = true;
        }
    }
    // End:0x2EC
    if((!bUseClassicHUD && NewPlayer != none) && Class'Engine.Engine'.static.IsSplitScreen())
    {
        // End:0x2EB
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x2EA
            if(PC != NewPlayer)
            {
                PC.ClientSetHUD(HUDType);
            }            
        }        
    }
    return NewPlayer;
    //return ReturnValue;    
}

function RestartPlayer(Controller aPlayer)
{
    local EvilVehicle_Base V, Best;
    local Vector ViewDir;
    local float bestDist, Dist;
    local EvilPlayerController PC;

    PC = EvilPlayerController(aPlayer);
    // End:0x6F
    if(PC != none)
    {
        // End:0x6F
        if((bMustJoinBeforeStart && PC != none) && PC.bLateComer)
        {
            return;
        }
    }
    // End:0xCE
    if((aPlayer.PlayerReplicationInfo != none) && aPlayer.PlayerReplicationInfo.bOutOfLives)
    {
        return;
    }
    // End:0x15E
    if((aPlayer.PlayerReplicationInfo != none) && AdvPRI(aPlayer.PlayerReplicationInfo) != none)
    {
        AdvPRI(aPlayer.PlayerReplicationInfo).ChoosePlayerSkin();
    }
    super.RestartPlayer(aPlayer);
    // End:0x197
    if(aPlayer.Pawn == none)
    {
        return;
    }
    AssignHoverboard(UTPawn(aPlayer.Pawn));
    // End:0x4CA
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) && PlayerController(aPlayer) != none)
    {
        bestDist = 2000.0000000;
        ViewDir = Vector(aPlayer.Pawn.Rotation);
        V = VehicleList;
        J0x26C:

        // End:0x478 [Loop If]
        if(V != none)
        {
            // End:0x2CF
            if(!bTeamGame && V.bTeamLocked)
            {
                V.bTeamLocked = false;
            }
            // End:0x44D
            if(V.bTeamLocked && WorldInfo.GRI.OnSameTeam(aPlayer, V))
            {
                Dist = VSize(V.Location - aPlayer.Pawn.Location);
                // End:0x410
                if((ViewDir Dot (V.Location - aPlayer.Pawn.Location)) < float(0))
                {
                    Dist *= float(2);
                }
                // End:0x44D
                if(Dist < bestDist)
                {
                    Best = V;
                    bestDist = Dist;
                }
            }
            V = V.NextVehicle;
            // [Loop Continue]
            goto J0x26C;
        }
        // End:0x4CA
        if(Best != none)
        {
            Best.PlayerStartTime = WorldInfo.TimeSeconds + float(8);
        }
    }
    // End:0x4ED
    if(PC != none)
    {
        SetupPlayerMuteList(PC, false);
    }
    //return;    
}

function Pawn SpawnDefaultPawn(Controller NewPlayer, EvilCheckPoint StartSpot)
{
    local class<Pawn> DefaultPlayerClass;
    local Rotator StartRotation;
    local Pawn ResultPawn;

    DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);
    StartRotation.Yaw = StartSpot.Rot.Yaw;
    ResultPawn = Spawn(DefaultPlayerClass,,, StartSpot.pos, StartRotation,, true);
    // End:0xBE
    if(ResultPawn == none)
    {
    }
    return ResultPawn;
    //return ReturnValue;    
}

function bool ShouldSpawnAtStartSpot(Controller Player)
{
    return (((int(WorldInfo.NetMode) == int(NM_Standalone)) && Player != none) && Player.StartSpot != none) && bWaitingToStartMatch || (Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.bWaitingPlayer;
    //return ReturnValue;    
}

function byte PickTeam(byte Num, Controller C)
{
    // End:0x12
    if(C == none)
    {
        return 255;
    }
    // End:0xC7
    if(C.IsA('EvilPlayerController') || ((EvilAIController(C) != none) && EvilAIController(C).Master != none) && EvilAIController(C).Master.IsA('EvilPlayerController'))
    {
        return 0;        
    }
    else
    {
        return 1;
    }
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
    // End:0x61
    if((Num == 255) || !Other.IsA('EvilAIController'))
    {
        Num = int(PickTeam(byte(Num), Other));
    }
    SetTeam(Other, Teams[Num], false);
    return true;
    //return ReturnValue;    
}

function bool IsMusicControllerEnabled()
{
    return IsTimerActive('TryChangingMusic_T');
    //return ReturnValue;    
}

function SetMusicController(bool bEnabled, optional bool bForce = false)
{
    local MusicTrackStruct FakeEmptyMusicStruct;

    // End:0xCA
    if(bEnabled)
    {
        // End:0xC7
        if(!IsMusicControllerEnabled() || bForce)
        {
            // End:0xBD
            if((AmbientMusic.Length > 0) && AmbientMusic[0].TheSoundCue != none)
            {
                SetTimer(1.0000000, true, 'TryChangingMusic_T');
                bPlayingBattleMusic = false;
                WorldInfo.UpdateMusicTrack(AmbientMusic[Rand(AmbientMusic.Length)]);                
            }
            else
            {
                ScriptTrace();
            }
        }        
    }
    else
    {
        // End:0x11F
        if(IsMusicControllerEnabled())
        {
            ClearTimer('TryChangingMusic_T');
            bPlayingBattleMusic = false;
            WorldInfo.UpdateMusicTrack(FakeEmptyMusicStruct);
        }
    }
    //return;    
}

simulated function bool IsPlayingMusic()
{
    return IsTimerActive('TryChangingMusic_T');
    //return ReturnValue;    
}

protected function TryChangingMusic_T()
{
    //return;    
}

function UpdateRichPresence()
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(AdvEngine(Class'AdvEngine'.static.GetEngine()).GamePlayers[0].Actor);
    // End:0xD2
    if(PC != none)
    {
        PC.ClientSetCampaignRichPresence(0, AdvGRI_SP(WorldInfo.GRI).ChapterNum);
    }
    //return;    
}

function SessionStartupFinished(bool bWasSuccessful)
{
    bSetupSessionProcessComplete = true;
    // End:0x38
    if(StartupSessionSetupCompleteDelegate != none)
    {
        OnStartupSessionSetupComplete(bWasSuccessful);
    }
    StartupSessionSetupCompleteDelegate = None;
    //return;    
}

function SetStartupSessionSetupCompleteDelegate(delegate<OnStartupSessionSetupComplete> dlg)
{
    StartupSessionSetupCompleteDelegate = dlg;
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    local OnlineGameSettings GameSettings;

    super.PostLogin(NewPlayer);
    // End:0x222
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x21F
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
            // End:0x11D
            if((GameSettings != none) && int(GameSettings.GameState) == int(3))
            {
                UpdateRichPresence();
                bSetupSessionProcessComplete = true;                
            }
            else
            {
                // End:0x21F
                if((NewPlayer.IsPrimaryPlayer() && !AdvLocalPlayer(NewPlayer.Player).bIsInSessionStartupProcess) && (GameSettings == none) || ((int(GameSettings.GameState) == int(0)) || int(GameSettings.GameState) == int(5)) || int(GameSettings.GameState) == int(4))
                {
                    SetupGameSession();
                }
            }
        }        
    }
    else
    {
        UpdateRichPresence();
    }
    //return;    
}

function SetupGameSession()
{
    AdvLocalPlayer(Class'Engine.Engine'.static.GetEngine().GamePlayers[0]).SetupGameSession();
    //return;    
}

function bool ShouldWaitForStartupSession()
{
    // End:0x52
    if((int(WorldInfo.NetMode) != int(NM_Standalone)) || !WorldInfo.IsConsoleBuild())
    {
        return false;
    }
    // End:0x63
    if(!bSetupSessionProcessComplete)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(Killer);
    // End:0x80
    if(PC != none)
    {
        // End:0x80
        if(ClassIsChildOf(DamageType, Class'AdvDmgType_Trap_Base') || ClassIsChildOf(DamageType, Class'AdvDmgType_MeleeTrap'))
        {
            PC.IncrementGlobalIntStat(148);
        }
    }
    super(GameInfo).NotifyKilled(Killer, Killed, KilledPawn, DamageType);
    //return;    
}

defaultproperties
{
    Acronym="SP"
    SpawnProtectionTime=0.0000000
    MapPrefixes=/* Array type was not detected. */
    ConsolePlayerControllerClass=Class'AdvPlayerControllerSP'
    PlayerControllerClass=Class'AdvPlayerControllerSP'
    PlayerReplicationInfoClass=Class'AdvPRI_SP'
    GameReplicationInfoClass=Class'AdvGRI_SP'
}