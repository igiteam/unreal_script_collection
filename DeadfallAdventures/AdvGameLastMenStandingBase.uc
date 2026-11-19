class AdvGameLastMenStandingBase extends AdvGameTeamDeathmatchBase
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var bool bCheckScore;

function GenericPlayerInitialization(Controller C)
{
    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'AdvGFxHudWrapperMP_Last';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    CommonForGenericPlayerInitialization(C);
    //return;    
}

function IncrementEndGameStatistics(AdvPlayerControllerMP Winner)
{
    Winner.IncrementGlobalIntStat(134);
    //return;    
}

function RestartPlayer(Controller aPlayer)
{
    // End:0x55
    if(!AdvPlayerControllerMP(aPlayer).bFirstSpawn)
    {
        AdvPlayerControllerMP(aPlayer).ResetKillInfoMessage();
    }
    super(AdvGameMP_Base).RestartPlayer(aPlayer);
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    bCheckScore = true;
    super.ScoreKill(Killer, Other);
    // End:0x129
    if((Other != none) && Other.PlayerReplicationInfo != none)
    {
        // End:0xA1
        if(MaxLives > 0)
        {
            Other.PlayerReplicationInfo.NumLives++;
        }
        // End:0x129
        if((MaxLives > 0) && Other.PlayerReplicationInfo.NumLives >= MaxLives)
        {
            Other.PlayerReplicationInfo.bOutOfLives = true;
        }
    }
    //return;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Rating;

    Rating = super(AdvGameMP_Base).RatePlayerStart(P, Team, Player);
    // End:0x46
    if(Rating == float(0))
    {
        return 0.0000000;
    }
    // End:0xEE
    if(P.TeamIndex != 255)
    {
        // End:0xBA
        if(AdvGRI(GameReplicationInfo).bTeamsInverted)
        {
            Team = ((int(Team) == int(0)) ? 1 : 0);
        }
        // End:0xEE
        if(int(Team) != P.TeamIndex)
        {
            return 1.0000000;
        }
    }
    return Rating;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    super(AdvGameMP_Base).Tick(DeltaTime);
    // End:0x39
    if(bCheckScore && MatchIsInProgress())
    {
        LMSCheckScore();
    }
    //return;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return false;
    //return ReturnValue;    
}

function bool LMSCheckScore()
{
    local AdvPlayerControllerMP PC;
    local PlayerReplicationInfo RedLivingPlayer, BlueLivingPlayer;
    local bool bRedTeamKilled, bBlueTeamKilled;

    bCheckScore = false;
    bRedTeamKilled = true;
    bBlueTeamKilled = true;
    // End:0x1B4
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0x1B3
        if(((!PC.IsInState('Dead') && !PC.IsInState('Spectating')) && !PC.IsInState('Wounded')) && !PC.IsInState('SurvivalWounded'))
        {
            // End:0x17F
            if(PC.PlayerReplicationInfo.Team.TeamIndex == 0)
            {
                bRedTeamKilled = false;
                RedLivingPlayer = PC.PlayerReplicationInfo;
                // End:0x1B3
                continue;
            }
            bBlueTeamKilled = false;
            BlueLivingPlayer = PC.PlayerReplicationInfo;
        }        
    }    
    // End:0x1E7
    if(bRedTeamKilled && bBlueTeamKilled)
    {
        EndGame(none, "LastMan");
        return true;
    }
    // End:0x215
    if(bRedTeamKilled)
    {
        EndGame(BlueLivingPlayer, "LastMan");
        return true;        
    }
    else
    {
        // End:0x240
        if(bBlueTeamKilled)
        {
            EndGame(RedLivingPlayer, "LastMan");
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    MaxLives=1
    OnlineStatsWriteClass=Class'AdvLeaderboard_Write_LMS'
}