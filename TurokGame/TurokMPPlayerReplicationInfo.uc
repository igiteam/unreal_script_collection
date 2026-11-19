class TurokMPPlayerReplicationInfo extends TurokPlayerReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

var byte mRank;
var byte mFlagTeamIndex;
var byte mFlagCaps;
var int mAssists;
var int mSuicides;
var int mFriendly;
var int mActCount;
var int mActScore;
var int mShotsFired;
var int mShotsHit;
var int mHeadshotKills;
var int mStealthKills;
var int mFragKills;
var private repnotify float mRespawnInterval;
var private float mRespawnTime;
var private float mHUDRespawnTime;
var private bool mPlayerIsDead;
var private @NULL mLastDeadLocation;
var @NULL mKillRecords[16];
var transient bool mLoggedOut;

replication
{
    // Pos:0x000
    if(bNetDirty
        mActCount, mActScore, 
        mAssists, mFlagCaps, 
        mFlagTeamIndex, mFragKills, 
        mFriendly, mHeadshotKills, 
        mKillRecords, mRank, 
        mRespawnInterval, mShotsFired, 
        mShotsHit, mStealthKills, 
        mSuicides;
}

// Export UTurokMPPlayerReplicationInfo::execIsPlayerDead(FFrame&, void* const)
native final function bool IsPlayerDead();

// Export UTurokMPPlayerReplicationInfo::execGetLastPlayerDeadLocation(FFrame&, void* const)
native final function @NULL GetLastPlayerDeadLocation();

simulated event ReplicatedEvent(name VarName)
{
    // End:0x15
    if(VarName == 'mRespawnInterval')
    {
        return;
    }
    super(PlayerReplicationInfo).ReplicatedEvent(VarName);
    //return;    
}

simulated event PostBeginPlay()
{
    super(PlayerReplicationInfo).PostBeginPlay();
    // End:0x33
    if(int(Role) == int(ROLE_Authority))
    {
        NumLives = WorldInfo.GRI.MaxLives;
    }
    //return;    
}

simulated event Destroyed()
{
    local @NULL net, Lobby, GameResults;

    // End:0x87
    if(IsValidUniqueNetId(UniqueId))
    {
        net = Class'Engine.Engine'.static.GetTurokNet();
        // End:0x87
        if(net != none)
        {
            Lobby = net.GetLobby();
            // End:0x87
            if(Lobby != none)
            {
                GameResults = Lobby.GetGameResults();
                // End:0x87
                if(GameResults != none)
                {
                    GameResults.UpdatePlayerResults(GetResults());
                }
            }
        }
    }
    super(PlayerReplicationInfo).Destroyed();
    //return;    
}

simulated function bool ShouldBroadCastWelcomeMessage()
{
    local @NULL net, Lobby;

    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0x94
    if(net != none)
    {
        Lobby = net.GetLobby();
        // End:0x94
        if(Lobby != none)
        {
            // End:0x7A
            if(int(Lobby.GetGameState()) != int(0))
            {
                // End:0x7A
                if(!Lobby.GetGameSettings().IsPrivate())
                {
                    return false;
                }
            }
            // End:0x94
            if(PlayerName == Class'Engine.GameInfo'.default.DefaultPlayerName)
            {
                return false;
            }
        }
    }
    return super(PlayerReplicationInfo).ShouldBroadCastWelcomeMessage();
    //return ReturnValue;    
}

simulated function bool ShouldBroadCastDisconnectMessage()
{
    local @NULL net, Lobby, GRI;

    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0xD1
    if(net != none)
    {
        Lobby = net.GetLobby();
        // End:0xD1
        if(Lobby != none)
        {
            // End:0x5A
            if(PlayerName == Class'Engine.GameInfo'.default.DefaultPlayerName)
            {
                return false;
            }
            GRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
            // End:0xD1
            if(GRI != none)
            {
                // End:0xD1
                if((GRI.IsPrivateGame() == false) && (int(Lobby.GetGameState()) == int(3)) || int(Lobby.GetGameState()) == int(4))
                {
                    return false;
                }
            }
        }
    }
    return ShouldBroadCastWelcomeMessage();
    //return ReturnValue;    
}

event PostSaveGameRestore()
{
    local @NULL TPC, GI;

    GI = TurokGameInfo(WorldInfo.Game);
    // DebugMode: 0
    assert(GI != none);
    TPC = TurokPlayerController(Owner);
    // DebugMode: 0
    assert(TPC != none);
    GI.ChangeTeam(TPC, int(TeamIndex), false);
    // End:0x7B
    if(bHasFlag)
    {
        AttachFlag(int(mFlagTeamIndex));
    }
    //return;    
}

function SetUniqueId(@NULL InUniqueId)
{
    local @NULL net, Lobby, LobbyPlayer;

    super(PlayerReplicationInfo).SetUniqueId(InUniqueId);
    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0xB2
    if(net != none)
    {
        Lobby = net.GetLobby();
        // End:0xB2
        if(Lobby != none)
        {
            // End:0xB2
            if(Lobby.GetOnlinePlayerByUniqueID(InUniqueId, LobbyPlayer))
            {
                WorldInfo.Game.ChangeName(Controller(Owner), LobbyPlayer.NickName, false);
                mRank = LobbyPlayer.Rating;
            }
        }
    }
    //return;    
}

function AddRespawnInterval(float AddedTime)
{
    mRespawnInterval = float(Clamp(int(mRespawnInterval + AddedTime), 3, int(float(3) + 60.0000000)));
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    //return;    
}

simulated function float GetRespawnInterval()
{
    return mRespawnInterval;
    //return ReturnValue;    
}

function CalculateRespawnTime()
{
    mRespawnTime = WorldInfo.TimeSeconds + mRespawnInterval;
    //return;    
}

function float GetRespawnTime()
{
    return mRespawnTime;
    //return ReturnValue;    
}

function ClearRespawnTime()
{
    mRespawnInterval = 3.0000000;
    mRespawnTime = 0.0000000;
    //return;    
}

simulated function CalculateHUDRespawnTime()
{
    mHUDRespawnTime = (WorldInfo.TimeSeconds + mRespawnInterval) - 3.0000000;
    //return;    
}

simulated function float GetHUDRespawnTime()
{
    return mHUDRespawnTime;
    //return ReturnValue;    
}

function SetPlayerDead(@NULL Loc)
{
    mPlayerIsDead = true;
    mLastDeadLocation = Loc;
    //return;    
}

function ClearPlayerdead()
{
    mPlayerIsDead = false;
    //return;    
}

// Export UTurokMPPlayerReplicationInfo::execUpdateKillCount(FFrame&, void* const)
native function UpdateKillCount(@NULL Killed, class<Class> DamageType);

// Export UTurokMPPlayerReplicationInfo::execUpdateDeathCount(FFrame&, void* const)
native function UpdateDeathCount(@NULL Killer, class<Class> DamageType);

function Reset()
{
    local int I;
    local float scoreCached, deathsCached;
    local int killsCached, assistsCached, suicidesCached, friendlyCached, shotsFiredCached, shotsHitCached;

    local @NULL killRecordsCached[16];
    local int flagCapsCached, actCountCached, actScoreCached, headShotKillsCached, stealthKillsCached, fragKillsCached;

    // DebugMode: 0
    assert(TurokMPGame(WorldInfo.Game) != none);
    // End:0x4C
    if(!TurokMPGame(WorldInfo.Game).IsNextRoundReset())
    {
        DoReset();
        return;
    }
    scoreCached = Score;
    killsCached = Kills;
    shotsFiredCached = mShotsFired;
    shotsHitCached = mShotsHit;
    deathsCached = Deaths;
    assistsCached = mAssists;
    suicidesCached = mSuicides;
    friendlyCached = mFriendly;
    flagCapsCached = int(mFlagCaps);
    actCountCached = mActCount;
    actScoreCached = mActScore;
    headShotKillsCached = mHeadshotKills;
    stealthKillsCached = mStealthKills;
    fragKillsCached = mFragKills;
    I = 0;
    J0xEF:

    // End:0x11C [Loop If]
    if(I < 16)
    {
        killRecordsCached[I] = mKillRecords[I];
        I++;
        // [Loop Continue]
        goto J0xEF;
    }
    DoReset();
    Score = scoreCached;
    Kills = killsCached;
    mShotsFired = shotsFiredCached;
    mShotsHit = shotsHitCached;
    Deaths = deathsCached;
    mAssists = assistsCached;
    mSuicides = suicidesCached;
    mFriendly = friendlyCached;
    mFlagCaps = byte(flagCapsCached);
    mActCount = actCountCached;
    mActScore = actScoreCached;
    mHeadshotKills = headShotKillsCached;
    mStealthKills = stealthKillsCached;
    mFragKills = fragKillsCached;
    I = 0;
    J0x1C9:

    // End:0x1F6 [Loop If]
    if(I < 16)
    {
        mKillRecords[I] = killRecordsCached[I];
        I++;
        // [Loop Continue]
        goto J0x1C9;
    }
    //return;    
}

function DoReset()
{
    local int I;

    Score = 0.0000000;
    Kills = 0;
    Deaths = 0.0000000;
    mShotsFired = 0;
    mShotsHit = 0;
    mAssists = 0;
    mSuicides = 0;
    mFriendly = 0;
    mFlagCaps = 0;
    mActCount = 0;
    mActScore = 0;
    mHeadshotKills = 0;
    mStealthKills = 0;
    mFragKills = 0;
    I = 0;
    J0x72:

    // End:0x9F [Loop If]
    if(I < 16)
    {
        mKillRecords[I] = default.mKillRecords[I];
        I++;
        // [Loop Continue]
        goto J0x72;
    }
    NumLives = WorldInfo.GRI.MaxLives;
    bOutOfLives = false;
    bHasFlag = default.bHasFlag;
    mFlagTeamIndex = default.mFlagTeamIndex;
    mRespawnTime = default.mRespawnTime;
    mRespawnInterval = default.mRespawnInterval;
    bReadyToPlay = true;
    bWaitingPlayer = true;
    bIsSpectator = false;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    //return;    
}

function AttachFlag(int flagTeamIndex)
{
    local @NULL TFG;

    TFG = TurokFlagGame(WorldInfo.Game);
    mFlagTeamIndex = byte(flagTeamIndex);
    bHasFlag = true;
    // End:0xAB
    if(int(Team.TeamIndex) == flagTeamIndex)
    {
        // End:0x7F
        if(flagTeamIndex == 0)
        {
            TFG.UpdateFlagState(flagTeamIndex, 1, TFG.GetFlagBaseTeam0());            
        }
        else
        {
            TFG.UpdateFlagState(flagTeamIndex, 1, TFG.GetFlagBaseTeam1());
        }        
    }
    else
    {
        // End:0xE2
        if(flagTeamIndex == 0)
        {
            TFG.UpdateFlagState(flagTeamIndex, 2, TFG.GetFlagBaseTeam1());            
        }
        else
        {
            TFG.UpdateFlagState(flagTeamIndex, 2, TFG.GetFlagBaseTeam0());
        }
    }
    //return;    
}

function DetachFlag()
{
    bHasFlag = false;
    mFlagTeamIndex = byte(255);
    //return;    
}

simulated event @NULL GetResults()
{
    local int I;
    local @NULL Results;

    Results = super(PlayerReplicationInfo).GetResults();
    Results.mRank = int(mRank);
    Results.mShotsFired = mShotsFired;
    Results.mShotsHit = mShotsHit;
    Results.mAssists = mAssists;
    Results.mSuicides = mSuicides;
    Results.mFriendly = mFriendly;
    I = 0;
    J0x8D:

    // End:0xC3 [Loop If]
    if(I < 16)
    {
        Results.mKillRecords[I] = mKillRecords[I];
        I++;
        // [Loop Continue]
        goto J0x8D;
    }
    Results.mFlagCaps = int(mFlagCaps);
    Results.mActCount = mActCount;
    Results.mActScore = mActScore;
    Results.mHeadshotKills = mHeadshotKills;
    Results.mStealthKills = mStealthKills;
    Results.mFragKills = mFragKills;
    return Results;
    //return ReturnValue;    
}

simulated function string ToString()
{
    local string PlayerString;

    PlayerString = string(PlayerID) @ PlayerName;
    // End:0x44
    if(Team != none)
    {        
        PlayerString @= ("Team" $ string(Team.TeamIndex));
    }    
    PlayerString @= ((((((((((((((((("- K:" $ string(Kills)) @ "D:") $ string(Deaths)) @ "S:") $ string(Score)) @ "L:") $ string(NumLives)) @ "Friendly:") $ string(mFriendly)) @ "A:") $ string(mAssists)) @ "HSK:") $ string(mHeadshotKills)) @ "SK:") $ string(mStealthKills)) @ "FK:") @ string(mFragKills));
    return PlayerString;
    //return ReturnValue;    
}

simulated function DisplayDebug(@NULL HUD, out float YL, out float YPos)
{
    super(PlayerReplicationInfo).DisplayDebug(HUD, YL, YPos);
    //return;    
}

defaultproperties
{
    mFlagTeamIndex=255
    mRespawnInterval=3.0000000
    GameMessageClass=Class'TurokAdminMessage'
}