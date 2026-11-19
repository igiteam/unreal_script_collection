class TurokAssaultGame extends TurokFlagGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var protected const config byte InitialDefendingTeam;
var private transient bool mNextRoundResetInProgress;
var private transient float mNextRoundStartTime;

event InitGame(string Options, out string ErrorMessage)
{
    super.InitGame(Options, ErrorMessage);
    // End:0x1E
    if(ErrorMessage != "")
    {
        return;
    }
    // End:0x31
    if(TimeLimit == 0)
    {
        TimeLimit = 5;
    }
    //return;    
}

function InitGameReplicationInfo()
{
    local @NULL currGRI;

    currGRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(currGRI != none);
    // End:0x58
    if(!IsNextRoundReset())
    {
        super.InitGameReplicationInfo();
        currGRI.mCurrRound = 0;
        currGRI.mCurrPrimaryTeamIndex = InitialDefendingTeam;        
    }
    else
    {
        ++currGRI.mCurrRound;
    }
    mFlagIndicators[0].Activate();
    mFlagIndicators[1].Activate();
    //return;    
}

function StartMatch()
{
    super(TurokTeamGame).StartMatch();
    // End:0x23
    if(mNextRoundStartTime != 0.0000000)
    {
        GotoState('RoundOver');
    }
    //return;    
}

function bool ShouldReset(@NULL ActorToReset)
{
    // End:0x1F
    if(IsNextRoundReset())
    {
        // End:0x1F
        if(TurokAssaultBase(ActorToReset) != none)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function Reset()
{
    local @NULL currGRI, spawnSwapper, assBase;

    currGRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(currGRI != none);
    // End:0x7A
    if(IsNextRoundReset())
    {
        // End:0x53
        if(int(currGRI.mCurrPrimaryTeamIndex) == 0)
        {
            currGRI.mCurrPrimaryTeamIndex = 1;            
        }
        else
        {
            // End:0x7A
            if(int(currGRI.mCurrPrimaryTeamIndex) == 1)
            {
                currGRI.mCurrPrimaryTeamIndex = 0;
            }
        }
    }
    // End:0xAD
    foreach WorldInfo.AllNavigationPoints(Class'TurokAssaultSpawnSwapper', spawnSwapper)
    {
        spawnSwapper.PerformSpawnSwap();
        // End:0xAD
        break;        
    }    
    // End:0xDE
    foreach WorldInfo.AllNavigationPoints(Class'TurokAssaultBase', assBase)
    {
        assBase.Reset();        
    }    
    super.Reset();
    //return;    
}

function bool CheckModifiedEndGame(@NULL Winner, string Reason)
{
    // End:0x27
    if(Reason ~= "RoundOver")
    {
        NotifyRoundEnded(false, Winner);
        return false;
    }
    return super(TurokMPGame).CheckModifiedEndGame(Winner, Reason);
    //return ReturnValue;    
}

protected function bool PickupBaseFlag(class<Class> FlagClass, @NULL PlayerPawn, @NULL invMan, @NULL FlagBase)
{
    local @NULL CarriedFlag;

    // End:0x125
    if(GameReplicationInfo.OnSameTeam(PlayerPawn, FlagBase))
    {
        CarriedFlag = TurokMPTeamFlag(invMan.FindInventoryType(Class'TurokMPTeamFlag', true));
        // End:0x122
        if(CarriedFlag != none)
        {
            // End:0xA7
            if(GameReplicationInfo.OnSameTeam(FlagBase, CarriedFlag))
            {
                FlagBase.FlagReturned(PlayerPawn);
                ScoreFlagReturn(TurokPlayerController(PlayerPawn.Controller));                
            }
            else
            {
                FlagBase.FlagCaptured(PlayerPawn);
                ScoreFlagCapture(TurokPlayerController(PlayerPawn.Controller));
            }
            invMan.DropFromInventory(CarriedFlag);
            CarriedFlag.GetFlagBase().UpdateFlagStatus(true);
            CarriedFlag.Destroy();
        }        
    }
    else
    {
        // End:0x193
        if((invMan.FindInventoryType(Class'TurokMPTeamFlag', true) == none) && FlagBase.IsPickupEnabled())
        {
            FlagBase.FlagStolen(PlayerPawn);
            ScoreFlagSteal(TurokPlayerController(PlayerPawn.Controller));
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

protected function bool ScoreFlagCapture(@NULL Player)
{
    // End:0x10
    if(super.ScoreFlagCapture(Player))
    {
        return true;
    }
    EndRound();
    return false;
    //return ReturnValue;    
}

function UpdateFlagState(int flagTeamIndex, byte FlagState, @NULL Target)
{
    super.UpdateFlagState(flagTeamIndex, FlagState, Target);
    // End:0x188
    if(int(GetDefendingTeam()) == flagTeamIndex)
    {
        switch(FlagState)
        {
            // End:0x6E
            case 3:
                // DebugMode: 0
                assert(Target.IsA('TurokDroppedFlagPickup'));
                UpdateFlagIndicator(Target, true, 0);
                UpdateFlagIndicator(Target, true, 1);
                // End:0x188
                break;
            // End:0xCB
            case 1:
                // DebugMode: 0
                assert(Target.IsA('TurokAssaultBase') && int(Target.GetTeamNum()) == flagTeamIndex);
                UpdateFlagIndicator(Target, false, 0);
                UpdateFlagIndicator(Target, false, 1);
                // End:0x188
                break;
            // End:0x128
            case 2:
                // DebugMode: 0
                assert(Target.IsA('TurokAssaultBase') && int(Target.GetTeamNum()) != flagTeamIndex);
                UpdateFlagIndicator(Target, false, 0);
                UpdateFlagIndicator(Target, false, 1);
                // End:0x188
                break;
            // End:0x185
            case 0:
                // DebugMode: 0
                assert(Target.IsA('TurokAssaultBase') && int(Target.GetTeamNum()) == flagTeamIndex);
                UpdateFlagIndicator(Target, false, 0);
                UpdateFlagIndicator(Target, false, 1);
                // End:0x188
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

function byte GetDefendingTeam()
{
    local @NULL GRI;

    GRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(GRI != none);
    return GRI.mCurrPrimaryTeamIndex;
    //return ReturnValue;    
}

function bool IsNextRoundReset()
{
    return mNextRoundResetInProgress;
    //return ReturnValue;    
}

protected function OnTimeOut()
{
    local @NULL currGRI;

    currGRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(currGRI != none);
    // DebugMode: 0
    assert((int(currGRI.mCurrPrimaryTeamIndex) >= 0) && int(currGRI.mCurrPrimaryTeamIndex) < 2);
    currGRI.Teams[int(currGRI.mCurrPrimaryTeamIndex)].Score += 1.0000000;
    // End:0x92
    if(!CheckScore(none))
    {
        EndRound();
    }
    //return;    
}

private final function EndRound(optional @NULL BestPlayerStillAlive)
{
    TurokFlagGameReplicationInfo(GameReplicationInfo).ForceStatsRecalc();
    EndGame(BestPlayerStillAlive, "RoundOver");
    GotoState('RoundOver');
    //return;    
}

private final function BeginNextRound()
{
    mNextRoundResetInProgress = true;
    ResetLevel();
    mNextRoundResetInProgress = false;
    //return;    
}

protected function OnNoLivesLeft(@NULL BestRemainingPlayer)
{
    local @NULL GRI;

    GRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(GRI != none);
    // DebugMode: 0
    assert((int(GRI.mCurrPrimaryTeamIndex) >= 0) && int(GRI.mCurrPrimaryTeamIndex) < 2);
    // End:0x86
    if(BestRemainingPlayer != none)
    {
        GRI.Teams[int(BestRemainingPlayer.TeamIndex)].Score += 1.0000000;
    }
    EndRound(BestRemainingPlayer);
    //return;    
}

state RoundOver
{
    function Timer()
    {
        global.Timer();
        // End:0x28
        if(WorldInfo.TimeSeconds >= mNextRoundStartTime)
        {
            BeginNextRound();
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local @NULL TGRI;

        TGRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
        // DebugMode: 0
        assert(TGRI != none);
        TGRI.mCurrRoundOver = true;
        mNextRoundStartTime = WorldInfo.TimeSeconds + GameEndTimeout;
        //return;        
    }

    function EndState(name NextStateName)
    {
        local @NULL TGRI;

        TGRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
        // DebugMode: 0
        assert(TGRI != none);
        TGRI.mCurrRoundOver = false;
        mNextRoundStartTime = 0.0000000;
        //return;        
    }
    stop;    
}

defaultproperties
{
    HUDType=Class'TurokAssaultCTFHud'
}