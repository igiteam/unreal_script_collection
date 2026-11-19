class PKGameDeathmatch extends PKGameMP_Base
    config(Game)
    hidecategories(Navigation,Movement,Collision);

function PreBeginPlay()
{
    local int I;

    Teams.Length = ((Teams.Length < 255) ? 255 : Teams.Length);
    super.PreBeginPlay();
    I = 3;
    J0x40:

    // End:0x71 [Loop If]
    if(I < 255)
    {
        CreateTeam(I);
        I++;
        // [Loop Continue]
        goto J0x40;
    }
    //return;    
}

function CreateTeam(int TeamIndex)
{
    // End:0xB3
    if(Teams[TeamIndex] == none)
    {
        Teams[TeamIndex] = Spawn(Class'PKTeamInfo');
        Teams[TeamIndex].Initialize(TeamIndex);
        GameReplicationInfo.SetTeam(TeamIndex, Teams[TeamIndex]);
    }
    //return;    
}

function int GetHandicapNeed(Pawn Other)
{
    local float ScoreDiff;

    // End:0x26
    if(Other.PlayerReplicationInfo == none)
    {
        return 0;
    }
    UTGameReplicationInfo(GameReplicationInfo).SortPRIArray();
    ScoreDiff = GameReplicationInfo.PRIArray[0].Score - Other.PlayerReplicationInfo.Score;
    // End:0xD6
    if(ScoreDiff < float(3))
    {
        return 0;
    }
    return int(ScoreDiff / float(3));
    //return ReturnValue;    
}

function byte PickTeam(byte Num, Controller C)
{
    local int Index;

    // End:0x19
    if(C == none)
    {
        ScriptTrace();
    }
    // End:0xBC
    if((C == none) || !C.IsA('EvilAIController'))
    {
        Index = 0;
        J0x5A:

        // End:0xB0 [Loop If]
        if(Index < MaxPlayers)
        {
            // End:0xA2
            if(Teams[Index].Size == 0)
            {
                // [Explicit Break]
                goto J0xB0;
            }
            ++Index;
            // [Loop Continue]
            goto J0x5A;
        }
        J0xB0:

        return byte(Index);
    }
    return 250;
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
    // End:0xE4
    if(((Num == 255) || Other.IsA('EvilPlayerController') && Teams[Num].Size > 0) || Other.IsA('EvilAIController') && Teams[Num].Size < 1)
    {
        Num = int(PickTeam(byte(Num), Other));
    }
    SetTeam(Other, ((Num < 255) ? Teams[Num] : none), false);
    return true;
    //return ReturnValue;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x1B
    if(CheckMaxLives(Scorer))
    {
        return false;        
    }
    else
    {
        // End:0x51
        if((!bOverTime && GoalScore == 0) || Scorer == none)
        {
            return false;            
        }
        else
        {
            // End:0xA2
            if(Scorer.Score >= float(GoalScore))
            {
                EndGame(Scorer, "fraglimit");
                return true;                
            }
            else
            {
                // End:0xD2
                if(bOverTime)
                {
                    EndGame(Scorer, "timelimit");
                    return true;                    
                }
                else
                {
                    // End:0x431
                    if(bScoreDeaths && GoalScore > 0)
                    {
                        // End:0x20C
                        if(Scorer.Team.Score == float(GoalScore - 10))
                        {
                            // End:0x209
                            if(!bPlayedTenKills && GoalScore > 19)
                            {
                                // End:0x209
                                if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                {
                                    bPlayedTenKills = true;
                                    BroadcastLocalized(self, Class'EvilGame.EvilKillsRemainingMessage', 0);
                                }
                            }                            
                        }
                        else
                        {
                            // End:0x328
                            if(Scorer.Team.Score == float(GoalScore - 5))
                            {
                                // End:0x325
                                if(!bPlayedFiveKills && GoalScore > 9)
                                {
                                    // End:0x325
                                    if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                    {
                                        bPlayedFiveKills = true;
                                        BroadcastLocalized(self, Class'EvilGame.EvilKillsRemainingMessage', 1);
                                    }
                                }                                
                            }
                            else
                            {
                                // End:0x431
                                if((Scorer.Team.Score == float(GoalScore - 1)) && !bPlayedOneKill)
                                {
                                    // End:0x431
                                    if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                    {
                                        bPlayedOneKill = true;
                                        BroadcastLocalized(self, Class'EvilGame.EvilKillsRemainingMessage', 2);
                                    }
                                }
                            }
                        }
                    }
                    return false;
                }
            }
        }
    }
    //return ReturnValue;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    local float maxscore;

    // End:0xFA
    if(Winner == none)
    {
        maxscore = -100000000.0000000;
        // End:0xF9
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0xF8
            if(P.PlayerReplicationInfo.Score > maxscore)
            {
                Winner = P.PlayerReplicationInfo;
                maxscore = P.PlayerReplicationInfo.Score;
            }            
        }        
    }
    GameReplicationInfo.Winner = Winner;
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

function SetControllersWinnerFlag(PlayerReplicationInfo Winner)
{
    local PKPlayerController PKPC;

    // End:0xA4
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PKPC)
    {
        // End:0x83
        if(PKPC.PlayerReplicationInfo == Winner)
        {
            PKPC.ClientSetWinnerOfTheMatch(true);
            // End:0xA3
            continue;
        }
        PKPC.ClientSetWinnerOfTheMatch(false);        
    }    
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local PKPlayerController PKPC;

    super.ScoreKill(Killer, Other);
    // End:0x103
    if(Killer.PlayerReplicationInfo != none)
    {
        // End:0x103
        if((Killer.PlayerReplicationInfo.Kills >= 30) && WorldInfo.GRI.ElapsedTime < 180)
        {
            PKPC = PKPlayerController(Killer);
            // End:0x103
            if(PKPC != none)
            {
                PKPC.ClientUnlockAchievement(50);
            }
        }
    }
    //return;    
}

defaultproperties
{
    bScoreDeaths=true
    bIgnoreTeamForVoiceChat=true
    Acronym="DM"
    SpawnProtectionTime=0.0000000
    MapPrefixes=/* Array type was not detected. */
    GameName="Deathmatch"
    GoalScore=10
    TimeLimit=5
    OnlineStatsWriteClass=Class'PKLeaderboardWriteDM'
    OnlineGameSettingsClass=Class'PKGameDeathMatchSettings'
}