class PKGameSurvival extends PKGameDeathmatch
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var config float PlayerKillScore;

function ScoreKill(Controller Killer, Controller Other)
{
    // End:0xCE
    if((Killer == Other) || Killer == none)
    {
        // End:0xCB
        if((Other != none) && Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.Score -= float(1);
            Other.PlayerReplicationInfo.bForceNetUpdate = true;
        }        
    }
    else
    {
        // End:0x2E0
        if(Killer.PlayerReplicationInfo != none)
        {
            // End:0x1C0
            if(((Killer.PlayerReplicationInfo != none) && Other.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo != Other.PlayerReplicationInfo)
            {
                Killer.PlayerReplicationInfo.Score += PlayerKillScore;                
            }
            else
            {
                Killer.PlayerReplicationInfo.Score += PKPawn(Other.Pawn).KillScoreSV;
            }
            Killer.PlayerReplicationInfo.bForceNetUpdate = true;
            Killer.PlayerReplicationInfo.Kills++;
            // End:0x2E0
            if(PKPlayerController(Killer) != none)
            {
                PKPlayerController(Killer).IncrementGlobalIntStat(122, 1);
            }
        }
    }
    ModifyScoreKill(Killer, Other);
    // End:0x344
    if((Killer != none) || MaxLives > 0)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    // End:0x3A2
    if((PKPlayerController(Killer) != none) && PKPlayerController(Other) != none)
    {
        PKPlayerController(Killer).IncrementGlobalIntStat(113);
    }
    // End:0x506
    if(((Killer != none) && Killer != Other) && PKPlayerPawn(Killer.Pawn) != none)
    {
        // End:0x4C7
        if(((Killer.PlayerReplicationInfo != none) && Other.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo != Other.PlayerReplicationInfo)
        {
            PKPlayerPawn(Killer.Pawn).CommentKill();            
        }
        else
        {
            PKPlayerPawn(Killer.Pawn).CommentKill(2);
        }
    }
    //return;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    return super.CheckEndGame(Winner, Reason);
    //return ReturnValue;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x53
    if(Scorer.Score >= float(GoalScore))
    {
        EndGame(Scorer, "teamscorelimit");
        return true;
    }
    return super.CheckScore(Scorer);
    //return ReturnValue;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local PlayerController PC;
    local PKPlayerController PKPC;
    local bool has2xmorekills;
    local int PlayersNum;

    super(PKGameMP_Base).EndGame(Winner, Reason);
    // End:0x1F4
    if((Winner != none) && bGameEnded)
    {
        PKPC = PKPlayerController(Winner.Owner);
        // End:0x9C
        if(PKPC != none)
        {
            PKPC.ClientUnlockAchievement(57);
        }
        has2xmorekills = true;
        // End:0x1A4
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
        {
            PlayersNum++;
            // End:0x1A3
            if(((PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo != Winner) && (float(2) * PC.PlayerReplicationInfo.Score) > Winner.Score)
            {
                has2xmorekills = false;
            }            
        }        
        // End:0x1F4
        if(has2xmorekills && PlayersNum > 1)
        {
            // End:0x1F4
            if(PKPC != none)
            {
                PKPC.ClientUnlockAchievement(63);
            }
        }
    }
    //return;    
}

defaultproperties
{
    PlayerKillScore=2.0000000
    Acronym="SV"
    MapPrefixes=/* Array type was not detected. */
    GoalScore=900
    TimeLimit=60
    OnlineStatsWriteClass=Class'PKLeaderboardWriteSV'
    OnlineGameSettingsClass=Class'PKGameSurvivalSettings'
}