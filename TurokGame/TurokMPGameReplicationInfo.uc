class TurokMPGameReplicationInfo extends TurokGameReplicationInfo
    native
    nativereplication
    hidecategories(Navigation,Movement,Collision);

enum WinningReason
{
    WINNINGREASON_None,             // 0
    WINNINGREASON_PrimaryScore,     // 1
    WINNINGREASON_Annihilation,     // 2
    WINNINGREASON_Tiebreaker,       // 3
    WINNINGREASON_Logout,           // 4
    WINNINGREASON_MAX               // 5
};

var private bool mIsRankedGame;
var private bool mIsPrivateGame;
var private @NULL mRemoteEvents[8];
var private repnotify transient int mRemoteEventNotify;
var private transient int mRemoteEventCount;
var private transient @NULL mMissionInfo;
var protected transient bool mRecalcScores;
var protected transient bool mWinnerIsValid;
var @NULL mIndicators[8];
var int mIndicatorsNum;
var protected transient byte mWinningReason;
var protected transient byte mWinningTeam;
var protected transient @NULL mWinningPlayer;

replication
{
    // Pos:0x000
    if(bNetDirty
        mIndicators, mIndicatorsNum, 
        mRemoteEventNotify, mRemoteEvents;
}

// Export UTurokMPGameReplicationInfo::execGetLocalizedTeamName(FFrame&, void* const)
native function string GetLocalizedTeamName(byte TeamID);

// Export UTurokMPGameReplicationInfo::execIsFriendlyFireAllowed(FFrame&, void* const)
native function bool IsFriendlyFireAllowed();

// Export UTurokMPGameReplicationInfo::execIsRankedGame(FFrame&, void* const)
native function bool IsRankedGame();

// Export UTurokMPGameReplicationInfo::execIsPrivateGame(FFrame&, void* const)
native function bool IsPrivateGame();

// Export UTurokMPGameReplicationInfo::execSortTurokPRIs(FFrame&, void* const)
native function SortTurokPRIs();

simulated event ReplicatedEvent(name VarName)
{
    local int currIndex;

    // End:0x51
    if(VarName == 'mRemoteEventNotify')
    {
        currIndex = 0;
        J0x1A:

        // End:0x4E [Loop If]
        if(mRemoteEvents[currIndex] != none)
        {
            mRemoteEvents[currIndex].RemoteActivated();
            ++currIndex;
            // [Loop Continue]
            goto J0x1A;
        }        
    }
    else
    {
        super(GameReplicationInfo).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local @NULL MPGame, net, Lobby, LobbyGameSettings;

    super.PostBeginPlay();
    MPGame = TurokMPGame(WorldInfo.Game);
    // End:0x40
    if(MPGame != none)
    {
        mInventoryMovementPenalty = MPGame.InventoryMovementPenalty;
    }
    // End:0x54
    foreach AllActors(Class'TurokMPMissionInfo', mMissionInfo)
    {
        // End:0x54
        break;        
    }    
    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0xD6
    if(net != none)
    {
        Lobby = net.GetLobby();
        // End:0xD6
        if(Lobby != none)
        {
            LobbyGameSettings = Lobby.GetGameSettings();
            mIsRankedGame = LobbyGameSettings.IsRanked();
            mIsPrivateGame = LobbyGameSettings.IsPrivate();
        }
    }
    //return;    
}

simulated event @NULL GetMissionInfo()
{
    return mMissionInfo;
    //return ReturnValue;    
}

simulated event Tick(float DeltaTime)
{
    mRemoteEventCount = 0;
    super(GameReplicationInfo).Tick(DeltaTime);
    //return;    
}

simulated function PlayTimeWarning()
{
    local @NULL HUD, PC;

    // End:0x1B1
    if((RemainingTime < 61) && mMissionInfo != none)
    {
        // End:0x2B
        foreach LocalPlayerControllers(PC)
        {
            // End:0x2B
            break;            
        }        
        // End:0x1B1
        if(PC != none)
        {
            HUD = TurokMultiplayerHud(PC.myHUD);
            // End:0x1B1
            if(HUD != none)
            {
                // End:0xB9
                if(HUD.m60SecsSpeechEnabled && RemainingTime > 56)
                {
                    HUD.m60SecsSpeechEnabled = false;
                    mMissionInfo.Play60SecsSpeech(int(PC.GetTeamNum()), HUD);
                }
                // End:0x1B1
                if(RemainingTime < 31)
                {
                    // End:0x134
                    if(HUD.m30SecsSpeechEnabled && RemainingTime > 26)
                    {
                        HUD.m30SecsSpeechEnabled = false;
                        HUD.m60SecsSpeechEnabled = false;
                        mMissionInfo.Play30SecsSpeech(int(PC.GetTeamNum()), HUD);
                    }
                    // End:0x1B1
                    if((HUD.mLowSecSpeechEnabled && RemainingTime > 5) && RemainingTime < 15)
                    {
                        HUD.mLowSecSpeechEnabled = false;
                        HUD.mMedSecSpeechEnabled = false;
                        mMissionInfo.PlayLowSecSpeech(int(PC.GetTeamNum()), HUD);
                    }
                }
            }
        }
    }
    //return;    
}

function AddIndicator(@NULL indicator)
{
    // DebugMode: 0
    assert(indicator.mAttachIndex < 0);
    // DebugMode: 0
    assert(mIndicatorsNum < 8);
    mIndicators[mIndicatorsNum] = indicator;
    indicator.mAttachIndex = mIndicatorsNum;
    ++mIndicatorsNum;
    //return;    
}

function RemoveIndicator(@NULL indicator)
{
    local @NULL lastIndicator;
    local int removedIndex;

    removedIndex = indicator.mAttachIndex;
    // DebugMode: 0
    assert((removedIndex >= 0) && removedIndex < mIndicatorsNum);
    // DebugMode: 0
    assert(indicator == mIndicators[removedIndex]);
    --mIndicatorsNum;
    indicator.mAttachIndex = -1;
    // End:0x73
    if(removedIndex == mIndicatorsNum)
    {
        return;
    }
    lastIndicator = mIndicators[mIndicatorsNum];
    mIndicators[removedIndex] = lastIndicator;
    lastIndicator.mAttachIndex = removedIndex;
    //return;    
}

function BroadcastKismetEvent(@NULL eventReplicator)
{
    // DebugMode: 0
    assert(mRemoteEventCount < 8);
    // End:0x2E
    if(mRemoteEventCount <= 0)
    {
        ++mRemoteEventNotify;
        mRemoteEventNotify = mRemoteEventNotify & 15;
    }
    mRemoteEvents[mRemoteEventCount] = eventReplicator;
    ++mRemoteEventCount;
    mRemoteEvents[mRemoteEventCount] = none;
    //return;    
}

simulated event ForceStatsRecalc()
{
    mRecalcScores = true;
    //return;    
}

function bool IsTieBreaker()
{
    // End:0x33
    if(PRIArray.Length > 1)
    {
        return int(PRIArray[0].Score) == int(PRIArray[1].Score);
    }
    return false;
    //return ReturnValue;    
}

simulated event @NULL GetBestPlayer(@NULL bestPlayerStillStanding)
{
    // End:0x4D
    if(PRIArray.Length > 0)
    {
        // End:0x27
        if(mRecalcScores)
        {
            mRecalcScores = false;
            SortTurokPRIs();
        }
        // End:0x42
        if(bestPlayerStillStanding == none)
        {
            return TurokMPPlayerReplicationInfo(PRIArray[0]);            
        }
        else
        {
            return TurokMPPlayerReplicationInfo(bestPlayerStillStanding);
        }
    }
    return none;
    //return ReturnValue;    
}

simulated event @NULL GetBestTeam(@NULL Unused)
{
    return none;
    //return ReturnValue;    
}

simulated event SetWinningPlayer(@NULL unid)
{
    mWinnerIsValid = true;
    mWinningPlayer = unid;
    //return;    
}

simulated event @NULL GetWinningPlayer()
{
    // DebugMode: 0
    assert(mWinnerIsValid);
    return mWinningPlayer;
    //return ReturnValue;    
}

simulated event bool GetWinnerIsValid()
{
    return mWinnerIsValid;
    //return ReturnValue;    
}

simulated event ResetWinningPlayer()
{
    mWinnerIsValid = false;
    //return;    
}

simulated event SetWinningTeam(byte TeamID)
{
    mWinningTeam = TeamID;
    //return;    
}

simulated event byte GetWinningTeam()
{
    return byte(255);
    //return ReturnValue;    
}

simulated event ResetWinningTeam()
{
    mWinningTeam = byte(255);
    //return;    
}

simulated function SetWinningReason(byte R)
{
    mWinningReason = R;
    //return;    
}

simulated function byte GetWinningReason()
{
    return mWinningReason;
    //return ReturnValue;    
}

defaultproperties
{
    mRecalcScores=true
    mWinningTeam=255
}