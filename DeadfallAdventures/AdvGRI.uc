class AdvGRI extends EvilGameReplicationInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const MAX_KILLSTREAKS = 4;
const MAX_KILLSTREAK_COUNT = 12;

enum EVoteTypes
{
    EVT_NONE,                       // 0
    EVT_KICK,                       // 1
    EVT_MAX                         // 2
};

enum EVoteState
{
    EVS_NONE,                       // 0
    EVS_IN_PROGRESS,                // 1
    EVS_SUCCESS,                    // 2
    EVS_FAIL,                       // 3
    EVS_MAX                         // 4
};

struct WeatherEffectProperties
{
    var MaterialInterface CylinderMaterial;
    var class<EmitterCameraLensEffectBase> CameraLensEffect;
    var float EffectIntensity;
    var float InterpSpeed;
    var ParticleSystem FloorParticleSystem;
    var Vector2D SlantRangePitch;
    var Vector2D SlantRangeRoll;
    var float SlantFixedTime;
    var float SlantRandomTime;
    var float SlantInterpExponent;

    structdefaultproperties
    {
        CylinderMaterial=none
        CameraLensEffect=none
        EffectIntensity=0.0000000
        InterpSpeed=0.0000000
        FloorParticleSystem=none
        SlantRangePitch=(X=0.0000000,Y=0.0000000)
        SlantRangeRoll=(X=0.0000000,Y=0.0000000)
        SlantFixedTime=0.0000000
        SlantRandomTime=0.0000000
        SlantInterpExponent=0.0000000
    }
};

var protected AdvTypes.EPKPartyType CurrentPartyType;
var AdvTypes.ELevelID NextLevelID;
var AdvGRI.EVoteTypes ActiveVoting;
var repnotify AdvGRI.EVoteState LastVotingState;
var bool bKillingSpree;
var bool bRealism;
var bool bOracle;
var bool bTraps;
var bool bTeamDamage;
var bool bRoundWinnerUpdated;
var bool bWinnerUpdated;
var bool bFirstRound;
var bool bTeamsInverted;
var bool Finished;
var bool bCustomTimerRunning;
var bool bTimerToLastMummyRunning;
var bool bIsMultiplayerGame;
var bool bIsTeamMultiplayerGame;
var bool bIsSurvivalGame;
var bool bIsPregameLobbyGame;
var bool bGameplayTimerRunning;
var bool bCanIWriteStats;
var bool bIsArmageddonTime;
var repnotify bool bWeatherEffectEnabled;
var float RespawnTime;
var int RoundsToWin;
var int ScoreForWin;
var int XPForWin;
var string MapsList;
var AdvTeamInfo RoundWinner;
var int MonstersKilled;
var int GoldFound;
var int BonusItems;
var int BonusItemsFromFallenEnemy;
var int HolyItemsFound;
var int AmmoFound;
var int ObjectsDestroyed;
var int SecretsFound;
var int TotalMonsters;
var int TotalGold;
var int TotalHolyItems;
var int TotalAmmo;
var int TotalObjects;
var int TotalSecrets;
var int GameplayTime;
var int CountdownTimer;
var int CustomTimer;
var string CustomTimerTitleLocKey;
var int TimerToLastMummy;
var string TimerToLastMummyTitleLocKey;
var string TimerToLastMummyExpiredLocKey;
var int BuildNumber;
var string BuildString;
var protectedwrite repnotify int PlaylistId;
var int KillStrikeIcons[4];
var int KillStrikeDots[12];
var int KillStrikeIconIndexes[4];
var float ExperienceMultiplier;
var repnotify WeatherEffectProperties WeatherEffectProps;
var class<EvilFamilyInfoBase> MummyCharClassInfo;
var string NextMap;
var array<PlayerReplicationInfo> VotesFor;
var array<PlayerReplicationInfo> VotesAgainst;
var repnotify int VotesForCount;
var repnotify int VotesAgainstCount;
var repnotify int VotesRequired;
var repnotify int VotingTimeLeft;
var UniqueNetId VoteCaller;
var UniqueNetId PlayerToKick;
//var delegate<VoteStateChanged> __VoteStateChanged__Delegate;

replication
{
    // Pos:0x000
    if(bNetDirty
        ActiveVoting, AmmoFound, 
        BonusItems, CountdownTimer, 
        CurrentPartyType, CustomTimer, 
        CustomTimerTitleLocKey, Finished, 
        GameplayTime, GoldFound, 
        HolyItemsFound, KillStrikeDots, 
        KillStrikeIconIndexes, KillStrikeIcons, 
        LastVotingState, MapsList, 
        MonstersKilled, MummyCharClassInfo, 
        NextMap, ObjectsDestroyed, 
        PlayerToKick, PlaylistId, 
        RespawnTime, RoundWinner, 
        RoundsToWin, ScoreForWin, 
        SecretsFound, TimerToLastMummy, 
        TimerToLastMummyExpiredLocKey, TimerToLastMummyTitleLocKey, 
        TotalAmmo, TotalGold, 
        TotalHolyItems, TotalMonsters, 
        TotalObjects, TotalSecrets, 
        VoteCaller, VotesAgainstCount, 
        VotesForCount, VotesRequired, 
        VotingTimeLeft, WeatherEffectProps, 
        XPForWin, bCanIWriteStats, 
        bFirstRound, bIsArmageddonTime, 
        bKillingSpree, bOracle, 
        bRealism, bRoundWinnerUpdated, 
        bTeamDamage, bTeamsInverted, 
        bTraps, bWeatherEffectEnabled, 
        bWinnerUpdated;
}

delegate VoteStateChanged()
{
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local AdvPlayerController PC;

    switch(VarName)
    {
        // End:0x1F
        case 'bWeatherEffectEnabled':
        // End:0x6E
        case 'WeatherEffectProps':
            // End:0x6A
            foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
            {
                PC.UpdateWeatherEffects();                
            }            
            // End:0x107
            break;
        // End:0x90
        case 'PlaylistId':
            SetPlaylist(PlaylistId);
            // End:0x107
            break;
        // End:0x9C
        case 'VotesForCount':
        // End:0xA8
        case 'VotesAgainstCount':
        // End:0xB4
        case 'VotesRequired':
        // End:0xC0
        case 'VotingTimeLeft':
        // End:0xCC
        case 'ActiveVoting':
        // End:0xEE
        case 'LastVotingState':
            VoteStateChanged();
            // End:0x107
            break;
        // End:0xFFFF
        default:
            super(GameReplicationInfo).ReplicatedEvent(VarName);
            // End:0x107
            break;
            break;
    }
    //return;    
}

function bool StartVoting(PlayerReplicationInfo Caller, AdvGRI.EVoteTypes VoteType)
{
    // End:0x97
    if(int(LastVotingState) == int(0))
    {
        ClearVoting();
        LastVotingState = 1;
        VoteCaller = Caller.UniqueId;
        ActiveVoting = VoteType;
        SetTimer(1.0000000, true, 'UpdateVotingCountdown');
        VoteStateChanged();
        ForceNetRelevant();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function UpdateVotingCountdown()
{
    // End:0x21
    if(int(LastVotingState) == int(0))
    {
        ClearVoting();        
    }
    else
    {
        --VotingTimeLeft;
        // End:0x87
        if(int(LastVotingState) == int(1))
        {
            // End:0x84
            if(VotingTimeLeft <= 0)
            {
                CheckVoting();
                // End:0x84
                if(int(LastVotingState) == int(1))
                {
                    VotingTimeLeft = 0;
                    LastVotingState = 3;
                }
            }            
        }
        else
        {
            // End:0xA4
            if(VotingTimeLeft <= -5)
            {
                ClearVoting();
            }
        }
    }
    VoteStateChanged();
    ForceNetRelevant();
    //return;    
}

function CheckVoting()
{
    local AdvPlayerController PC;

    // End:0x105
    if(VotesForCount >= VotesRequired)
    {
        // End:0xEB
        if(int(ActiveVoting) == int(1))
        {
            // End:0xEA
            foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
            {
                // End:0xE9
                if(PC.PlayerReplicationInfo.UniqueId == PlayerToKick)
                {
                    PC.ClientShowKickedByVotingMovie();
                    PC.ClientReturnToMainMenu(false);
                    // End:0xEA
                    break;
                }                
            }            
        }
        VotingTimeLeft = 0;
        LastVotingState = 2;        
    }
    else
    {
        // End:0x164
        if(((PRIArray.Length - VotesRequired) < VotesAgainstCount) || (VotesAgainstCount + VotesForCount) >= PRIArray.Length)
        {
            VotingTimeLeft = 0;
            LastVotingState = 3;
        }
    }
    //return;    
}

function ClearVoting()
{
    local PlayerReplicationInfo PRI;

    LastVotingState = 0;
    ActiveVoting = 0;
    VotingTimeLeft = 30;
    VotesForCount = 0;
    VotesAgainstCount = 0;
    // End:0x7A
    foreach PRIArray(PRI)
    {
        AdvPRI(PRI).ClearVote();        
    }    
    VotesFor.Length = 0;
    VotesAgainst.Length = 0;
    UpdatedRequiredVotes();
    ClearTimer('UpdateVotingCountdown');
    //return;    
}

function SubmitVote(PlayerReplicationInfo PRI, bool bFor)
{
    // End:0xE3
    if(((int(LastVotingState) == int(1)) && VotesFor.Find(PRI) == ) && )
    {
        VotesAgainst.Find(PRI) == ;                
        // End:0x92
        if(bFor)
        {
            VotesFor.AddItem(PRI);            
            VotesForCount = VotesFor.Length;            
        }
        else
        {
            VotesAgainst.AddItem(PRI);            
            VotesAgainstCount = VotesAgainst.Length;
        }
        CheckVoting();
        VoteStateChanged();
        ForceNetRelevant();
    }
    //return;    
}

simulated function bool KickVotingInProgress()
{
    return int(ActiveVoting) == int(1);
    //return ReturnValue;    
}

reliable server function RemoveVote(PlayerReplicationInfo PRI)
{
    VotesFor.RemoveItem(PRI);    
    VotesForCount = VotesFor.Length;
    VotesAgainst.RemoveItem(PRI);    
    VotesAgainstCount = VotesAgainst.Length;
    //return;    
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
    super(GameReplicationInfo).AddPRI(PRI);
    UpdatedRequiredVotes();
    VoteStateChanged();
    ForceNetRelevant();
    //return;    
}

simulated function RemovePRI(PlayerReplicationInfo PRI)
{
    super(GameReplicationInfo).RemovePRI(PRI);
    RemoveVote(PRI);
    UpdatedRequiredVotes();
    // End:0x4E
    if(int(LastVotingState) == int(1))
    {
        CheckVoting();
    }
    VoteStateChanged();
    ForceNetRelevant();
    //return;    
}

simulated function UpdatedRequiredVotes()
{
    VotesRequired = (PRIArray.Length / 2) + 1;
    //return;    
}

simulated function SetPlaylist(int NewPlaylistId)
{
    local AdvOnlinePlaylistProvider Provider;

    PlaylistId = NewPlaylistId;
    // End:0x42
    if(!IsPrivateCustomGame())
    {
        WorldInfo.ToggleHostMigration(true);
    }
    Provider = AdvOnlinePlaylistProvider(Class'IpDrv.UIDataStore_OnlinePlaylists'.static.GetOnlinePlaylistProviderByPlaylistID(PlaylistId));
    ExperienceMultiplier = Provider.ExperienceMultiplier;
    //return;    
}

reliable server function ServerShowRoundEndScreen()
{
    local AdvPlayerControllerMP PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        PC.ClientShowRoundEndScreen();        
    }    
    //return;    
}

reliable server function ServerShowEndScreenMP()
{
    local AdvPlayerControllerMP PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        PC.ClientShowEndScreenMP();        
    }    
    //return;    
}

reliable server function ServerShowSurvivalEndStatisticsScreen()
{
    local AdvPlayerControllerMP PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        PC.ClientShowSurvivalEndStatisticsScreen();        
    }    
    //return;    
}

simulated event bool ShouldShowGore()
{
    return !Class'AdvEngine'.static.IsLowViolence();
    //return ReturnValue;    
}

function ResumeGameplayTimer()
{
    bGameplayTimerRunning = true;
    //return;    
}

function PauseGameplayTimer()
{
    bGameplayTimerRunning = false;
    //return;    
}

function SetCustomTimer(int Seconds, optional string TitleLocKey = "")
{
    CustomTimer = Seconds;
    CustomTimerTitleLocKey = TitleLocKey;
    ResumeCustomTimer();
    //return;    
}

function SetTimerToLastMummy(int Seconds, optional string TitleLocKey = "", optional string ExpiredLocKey = "")
{
    TimerToLastMummy = Seconds;
    TimerToLastMummyTitleLocKey = TitleLocKey;
    TimerToLastMummyExpiredLocKey = ExpiredLocKey;
    ResumeTimerToLastMummy();
    //return;    
}

function ResumeCustomTimer()
{
    bCustomTimerRunning = true;
    //return;    
}

function PauseCustomTimer()
{
    bCustomTimerRunning = false;
    //return;    
}

function ResumeTimerToLastMummy()
{
    bTimerToLastMummyRunning = true;
    //return;    
}

function PauseTimerToLastMummy()
{
    bTimerToLastMummyRunning = false;
    //return;    
}

simulated function GetTotalStatisticsFromMapInfo()
{
    //return;    
}

simulated function ReceivedGameClass()
{
    super(GameReplicationInfo).ReceivedGameClass();
    bIsMultiplayerGame = ClassIsChildOf(GameClass, Class'AdvGameMP_Base');
    bIsTeamMultiplayerGame = ClassIsChildOf(GameClass, Class'AdvGameTeamDeathmatchBase');
    bIsSurvivalGame = ClassIsChildOf(GameClass, Class'AdvGameSurvivalBase');
    bIsPregameLobbyGame = ClassIsChildOf(GameClass, Class'AdvPreGameLobbyGame_Base');
    //return;    
}

simulated function bool IsMultiplayerGame()
{
    return bIsMultiplayerGame;
    //return ReturnValue;    
}

simulated function bool IsTeamMultiPlayerGame()
{
    return bIsTeamMultiplayerGame;
    //return ReturnValue;    
}

simulated function bool IsSurvivalGame()
{
    return bIsSurvivalGame;
    //return ReturnValue;    
}

simulated function bool IsInPregameLobby()
{
    return bIsPregameLobbyGame;
    //return ReturnValue;    
}

simulated function bool IsPrivateCustomGame()
{
    return PlaylistId <= -1;
    //return ReturnValue;    
}

simulated function bool IsCommunityGame()
{
    return PlaylistId == -2;
    //return ReturnValue;    
}

simulated function bool CanWriteStats()
{
    return bCanIWriteStats && !IsPrivateCustomGame();
    //return ReturnValue;    
}

simulated function bool IsPureSinglePlayerGame()
{
    return !IsMultiplayerGame() && !IsTeamMultiPlayerGame();
    //return ReturnValue;    
}

function ScoreGold(int Amount)
{
    GoldFound += Amount;
    //return;    
}

function ScoreMonsterKilled()
{
    MonstersKilled++;
    //return;    
}

function ScoreAmmoTaken()
{
    AmmoFound++;
    //return;    
}

function ScoreDestroyedObject()
{
    ObjectsDestroyed++;
    //return;    
}

function ScoreBonusItemTaken(int val)
{
    BonusItems += val;
    //return;    
}

function ScoreBonusItemFromFallenEnemy(int val)
{
    BonusItemsFromFallenEnemy += val;
    //return;    
}

function ScoreHolyItemTaken()
{
    HolyItemsFound++;
    //return;    
}

function ScoreSecretFound()
{
    SecretsFound++;
    //return;    
}

function ClearGlobalLevelStatistics()
{
    MonstersKilled = 0;
    GoldFound = 0;
    BonusItems = 0;
    HolyItemsFound = 0;
    AmmoFound = 0;
    ObjectsDestroyed = 0;
    SecretsFound = 0;
    Finished = false;
    //return;    
}

simulated function CopyLevelStatisticsToGlobalStatistics(const out LevelStatistics ls)
{
    AmmoFound = ls.AmmoFound;
    BonusItems = ls.BonusItems;
    GameplayTime = ls.GameplayTime;
    GoldFound = ls.GoldFound;
    MonstersKilled = ls.MonstersKilled;
    ObjectsDestroyed = ls.ObjectsDestroyed;
    SecretsFound = ls.SecretsFound;
    TotalAmmo = ls.TotalAmmo;
    TotalMonsters = ls.TotalMonsters;
    TotalObjects = ls.TotalObjects;
    TotalSecrets = ls.TotalSecrets;
    //return;    
}

simulated function CopyGlobalStatisticsToLevelStatisticsStruct(out LevelStatistics ls)
{
    ls.AmmoFound = AmmoFound;
    ls.BonusItems = BonusItems;
    ls.GameplayTime = GameplayTime;
    ls.GoldFound = GoldFound;
    ls.MonstersKilled = MonstersKilled;
    ls.ObjectsDestroyed = ObjectsDestroyed;
    ls.SecretsFound = SecretsFound;
    ls.TotalAmmo = TotalAmmo;
    ls.TotalMonsters = TotalMonsters;
    ls.TotalObjects = TotalObjects;
    ls.TotalSecrets = TotalSecrets;
    //return;    
}

simulated function Timer()
{
    super(UTGameReplicationInfo).Timer();
    // End:0x81
    if(((WorldInfo.Game == none) || WorldInfo.Game.MatchIsInProgress()) && bGameplayTimerRunning)
    {
        GameplayTime++;
    }
    // End:0xAA
    if((CustomTimer > 0) && bCustomTimerRunning)
    {
        CustomTimer--;
    }
    // End:0xD3
    if((TimerToLastMummy > 0) && bTimerToLastMummyRunning)
    {
        TimerToLastMummy--;
    }
    //return;    
}

static simulated function AdvTypes.EMultiGameMode GetMultiGameMode(class<GameInfo> InGameClass)
{
    // End:0x1B
    if(ClassIsChildOf(InGameClass, Class'AdvGameSurvivalBase'))
    {
        return 3;
    }
    // End:0x36
    if(ClassIsChildOf(InGameClass, Class'AdvGameLastMenStandingBase'))
    {
        return 5;
    }
    // End:0x51
    if(ClassIsChildOf(InGameClass, Class'AdvGameTreasureHuntBase'))
    {
        return 4;
    }
    // End:0x6C
    if(ClassIsChildOf(InGameClass, Class'AdvGameTeamTreasureHuntBase'))
    {
        return 6;
    }
    // End:0x87
    if(ClassIsChildOf(InGameClass, Class'AdvGameCTFBase'))
    {
        return 2;
    }
    // End:0xA2
    if(ClassIsChildOf(InGameClass, Class'AdvGameTeamDeathmatchBase'))
    {
        return 1;
    }
    // End:0xBD
    if(ClassIsChildOf(InGameClass, Class'AdvGameDeathmatchBase'))
    {
        return 0;
    }
    return 7;
    //return ReturnValue;    
}

simulated function AdvTypes.EPKPartyType GetCurrentPartyType()
{
    return CurrentPartyType;
    //return ReturnValue;    
}

simulated function SetCurrentPartyType(AdvTypes.EPKPartyType NewPartyType, optional AdvPlayerController ProfileOwner = none)
{
    // End:0x2F
    if(int(NewPartyType) != int(2))
    {
        CurrentPartyType = NewPartyType;        
    }
    else
    {
        CurrentPartyType = 1;
    }
    // End:0xAB
    if(ProfileOwner != none)
    {
        // End:0xAB
        if(ProfileOwner.ProfileSettings != none)
        {
            ProfileOwner.ProfileSettings.SetPartyType(NewPartyType);
        }
    }
    //return;    
}

simulated function LoadPartyTypeFromProfile(AdvPlayerController ProfileOwner)
{
    // End:0x65
    if(ProfileOwner.ProfileSettings != none)
    {
        CurrentPartyType = ProfileOwner.ProfileSettings.GetPartyType();        
    }
    else
    {
        ScriptTrace();
    }
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x39
    if(!IsPrivateCustomGame())
    {
        WorldInfo.ToggleHostMigration(true);
    }
    //return;    
}

simulated function MaterialInstanceTimeVarying GetRandomDecalMaterialsFromMapInfo()
{
    local AdvMapInfo FallusMapInfo;

    FallusMapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0x98
    if(FallusMapInfo != none)
    {
        return FallusMapInfo.BloodDecalMaterials[Rand(FallusMapInfo.BloodDecalMaterials.Length)];
    }
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    CurrentPartyType=EPKPartyType.EPPT_Public
    bFirstRound=true
    bCanIWriteStats=true
    RoundsToWin=1
    ScoreForWin=100
    XPForWin=300
    BuildNumber=3
    BuildString="2014-02-26"
    PlaylistId=-1
    ExperienceMultiplier=1.0000000
}