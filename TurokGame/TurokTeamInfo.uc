class TurokTeamInfo extends TeamInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

struct native TurokTeamStats
{
    var int mAccScore;
    var int mKills;
    var int mDeaths;
    var int mAssists;
    var int mSuicides;
    var int mFriendly;
    var int mFlagCaps;
    var int mActCount;
    var int mActScore;

    structdefaultproperties
    {
        mAccScore=0
        mKills=0
        mDeaths=0
        mAssists=0
        mSuicides=0
        mFriendly=0
        mFlagCaps=0
        mActCount=0
        mActScore=0
    }
};

var repnotify int mNumLives;
var @NULL mDisconnectedStats;
var protected @NULL mCurrentSpawnTarget;

replication
{
    // Pos:0x000
    if(bNetDirty
        mDisconnectedStats, mNumLives;
}

simulated event ReplicatedEvent(name N)
{
    // End:0x21
    if(N != 'mNumLives')
    {
        super(Actor).ReplicatedEvent(N);        
    }
    else
    {
        // End:0x3A
        if(mNumLives < Size)
        {
            PlayLowTeamLivesSpeech();
        }
    }
    //return;    
}

event PostBeginPlay()
{
    local @NULL TGRI;

    TGRI = TurokTeamGameReplicationInfo(WorldInfo.GRI);
    // DebugMode: 0
    assert(TGRI != none);
    // End:0x4D
    if(TGRI.mMaxTeamLives != 0)
    {
        mNumLives = TGRI.mMaxTeamLives;
    }
    //return;    
}

function Initialize(int InitTeamIndex)
{
    TeamIndex = byte(InitTeamIndex);
    TeamColor = GetTeamColor();
    //return;    
}

event IncrementNumberOfLives(int NumLives)
{
    mNumLives += NumLives;
    //return;    
}

function DecrementNumberOfLives()
{
    --mNumLives;
    // End:0x1C
    if(mNumLives < 0)
    {
        mNumLives = 0;        
    }
    else
    {
        // End:0x35
        if(mNumLives < Size)
        {
            PlayLowTeamLivesSpeech();
        }
    }
    //return;    
}

simulated function PlayLowTeamLivesSpeech()
{
    local @NULL PC, HUD, GRI;

    GRI = TurokTeamGameReplicationInfo(WorldInfo.GRI);
    // End:0x10E
    if((GRI != none) && mNumLives < GRI.mMaxTeamLives)
    {
        // End:0x50
        foreach LocalPlayerControllers(PC)
        {
            // End:0x50
            break;            
        }        
        // End:0x10E
        if((PC != none) && int(PC.GetTeamNum()) == int(TeamIndex))
        {
            HUD = TurokTeamGameHud(PC.myHUD);
            // End:0x10E
            if((HUD != none) && HUD.mTeamLivesSpeechEnabled)
            {
                HUD.mTeamLivesSpeechEnabled = false;
                // End:0x10E
                if(GRI.GetMissionInfo() != none)
                {
                    GRI.GetMissionInfo().PlayLowTeamLivesSpeech(int(TeamIndex), HUD);
                }
            }
        }
    }
    //return;    
}

simulated event bool IsWolfpack()
{
    return int(TeamIndex) == 1;
    //return ReturnValue;    
}

function Reset()
{
    SetDefaultSpawnTarget();
    // DebugMode: 0
    assert(TurokMPGame(WorldInfo.Game) != none);
    // End:0xE3
    if(!TurokMPGame(WorldInfo.Game).IsNextRoundReset())
    {
        mDisconnectedStats.mKills = 0;
        mDisconnectedStats.mDeaths = 0;
        mDisconnectedStats.mAssists = 0;
        mDisconnectedStats.mSuicides = 0;
        mDisconnectedStats.mFriendly = 0;
        mDisconnectedStats.mAccScore = 0;
        mDisconnectedStats.mFlagCaps = 0;
        mDisconnectedStats.mActCount = 0;
        mDisconnectedStats.mActScore = 0;
    }
    super(Actor).Reset();
    //return;    
}

function SetDefaultSpawnTarget()
{
    local @NULL currSpawnTarget;

    // End:0x50
    foreach WorldInfo.AllNavigationPoints(Class'TurokMPTeamSpawnTarget', currSpawnTarget)
    {
        // End:0x4F
        if(int(TeamIndex) == int(currSpawnTarget.GetTeamNum()))
        {
            SetSpawnTarget(currSpawnTarget);
            // End:0x50
            break;
        }        
    }    
    //return;    
}

event @NULL GetSpawnTarget()
{
    return mCurrentSpawnTarget;
    //return ReturnValue;    
}

function SetSpawnTarget(@NULL NewTarget)
{
    mCurrentSpawnTarget = NewTarget;
    //return;    
}

function CacheDisconnectedPlayerStats(@NULL turokPRI)
{
    // DebugMode: 0
    assert(turokPRI != none);
    // DebugMode: 0
    assert(TurokTeamGameReplicationInfo(WorldInfo.GRI) != none);
    // End:0x84
    if((WorldInfo.Game.bGameEnded || WorldInfo.Game.bWaitingToStartMatch) && !TurokTeamGameReplicationInfo(WorldInfo.GRI).mCurrRoundOver)
    {
        return;
    }
    mDisconnectedStats.mKills += turokPRI.Kills;
    mDisconnectedStats.mDeaths += int(turokPRI.Deaths);
    mDisconnectedStats.mAssists += turokPRI.mAssists;
    mDisconnectedStats.mSuicides += turokPRI.mSuicides;
    mDisconnectedStats.mFriendly += turokPRI.mFriendly;
    mDisconnectedStats.mAccScore += int(turokPRI.Score);
    mDisconnectedStats.mFlagCaps += int(turokPRI.mFlagCaps);
    mDisconnectedStats.mActCount += turokPRI.mActCount;
    mDisconnectedStats.mActScore += turokPRI.mActScore;
    //return;    
}

// Export UTurokTeamInfo::execGetHumanReadableNameNative(FFrame&, void* const)
native simulated function string GetHumanReadableNameNative();

simulated function string GetHumanReadableName()
{
    return GetHumanReadableNameNative();
    //return ReturnValue;    
}

simulated event @NULL GetTeamColor()
{
    return Class'TurokTeamGame'.default.TeamColors[int(TeamIndex)];
    //return ReturnValue;    
}
