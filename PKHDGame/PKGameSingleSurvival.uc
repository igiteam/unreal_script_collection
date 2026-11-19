class PKGameSingleSurvival extends PKGameSurvival
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var int SPSVMapInfoIndex;
var int SVDifficulty;
var int AdditionalScore;
var int DescriptionID;
var int AchievID;

event InitGame(string Options, out string ErrorMessage)
{
    SPSVMapInfoIndex = GetIntOption(Options, "SPSVMapInfoIndex", SPSVMapInfoIndex);
    SVDifficulty = GetIntOption(Options, "SVDifficulty", SVDifficulty);
    AdditionalScore = GetIntOption(Options, "AdditionalScore", AdditionalScore);
    DescriptionID = GetIntOption(Options, "DescriptionID", DescriptionID);
    AchievID = GetIntOption(Options, "AchievID", AchievID);
    super(PKGameMP_Base).InitGame(Options, ErrorMessage);
    //return;    
}

function RestartGame()
{
    //return;    
}

function ShowEndStatisticsScreen(bool bCompleted)
{
    local PKPlayerController P;

    // End:0x167
    foreach WorldInfo.AllControllers(Class'PKPlayerController', P)
    {
        // End:0xF9
        if(bCompleted)
        {
            // End:0xB9
            if(SPSVMapInfoIndex <= 17)
            {
                P.PersistentData.MarkSPSurvivalLevelAsCompleted(SPSVMapInfoIndex);
                P.ClientUnlockAchievement(byte(AchievID), true);
            }
            P.PlayerReplicationInfo.Score += float(AdditionalScore);
        }
        P.ClientWriteSoloSurvivalStats(bCompleted);
        P.ShowSingleSurvivalEndScreen(SPSVMapInfoIndex, bCompleted, AdditionalScore, DescriptionID);        
    }    
    //return;    
}

function PlayStartupMessage()
{
    local PKPlayerController P;

    // End:0x5D
    foreach WorldInfo.AllControllers(Class'PKPlayerController', P)
    {
        P.ShowSingleSurvivalObjective(DescriptionID);        
    }    
    //return;    
}

function PKPlayerController GetPC()
{
    local PKPlayerController P;

    // End:0x38
    foreach WorldInfo.AllControllers(Class'PKPlayerController', P)
    {
        // End:0x38
        break;        
    }    
    return P;
    //return ReturnValue;    
}

function bool CheckMaxLives(PlayerReplicationInfo Scorer)
{
    local PKPlayerController PC;
    local bool bNoneLeft;

    // End:0xE0
    if(MaxLives > 0)
    {
        bNoneLeft = false;
        // End:0xBC
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
        {
            // End:0xBB
            if((PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.bOutOfLives)
            {
                bNoneLeft = true;
                // End:0xBC
                break;
            }            
        }        
        // End:0xE0
        if(bNoneLeft)
        {
            EndGame(none, "LastMan");
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local PlayerReplicationInfo OtherPRI;

    OtherPRI = Other.PlayerReplicationInfo;
    // End:0xB5
    if(OtherPRI != none)
    {
        OtherPRI.NumLives++;
        // End:0xB5
        if((MaxLives > 0) && OtherPRI.NumLives >= MaxLives)
        {
            OtherPRI.bOutOfLives = true;
        }
    }
    // End:0x183
    if((Killer == Other) || Killer == none)
    {
        // End:0x180
        if((Other != none) && Other.PlayerReplicationInfo != none)
        {
            Other.PlayerReplicationInfo.Score -= float(1);
            Other.PlayerReplicationInfo.bForceNetUpdate = true;
        }        
    }
    else
    {
        // End:0x356
        if(Killer.PlayerReplicationInfo != none)
        {
            // End:0x26F
            if(((Killer.PlayerReplicationInfo != none) && Other.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo != Other.PlayerReplicationInfo)
            {
                Killer.PlayerReplicationInfo.Score += float(1);                
            }
            else
            {
                Killer.PlayerReplicationInfo.Score += float(1);
            }
            Killer.PlayerReplicationInfo.bForceNetUpdate = true;
            Killer.PlayerReplicationInfo.Kills++;
            // End:0x356
            if(PKPlayerController(Killer) != none)
            {
                PKPlayerController(Killer).IncrementGlobalIntStat(122, 1);
            }
        }
    }
    ModifyScoreKill(Killer, Other);
    // End:0x3BA
    if((Killer != none) || MaxLives > 0)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    // End:0x418
    if((PKPlayerController(Killer) != none) && PKPlayerController(Other) != none)
    {
        PKPlayerController(Killer).IncrementGlobalIntStat(113);
    }
    // End:0x57C
    if(((Killer != none) && Killer != Other) && PKPlayerPawn(Killer.Pawn) != none)
    {
        // End:0x53D
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

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    super.EndGame(Winner, Reason);
    // End:0x39
    if(Winner != none)
    {
        ShowEndStatisticsScreen(true);        
    }
    else
    {
        ShowEndStatisticsScreen(false);
    }
    //return;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x64
    if((GoalScore != 0) && Scorer.Score >= float(GoalScore))
    {
        EndGame(Scorer, "teamscorelimit");
        return true;
    }
    return super(PKGameDeathmatch).CheckScore(Scorer);
    //return ReturnValue;    
}

auto state PendingMatch
{
    ignores CheckLives, CheckScore, ScoreKill;

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
        local PlayerController P;
        local bool bReady;

        global.Timer();
        bReady = true;
        // End:0x180
        if(PainGRI(GameReplicationInfo).IsTeamMultiPlayerGame())
        {
            // End:0x17F
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
            {
                // End:0x17E
                if(((P.PlayerReplicationInfo != none) && P.bIsPlayer) && !P.PlayerReplicationInfo.bReadyToPlay)
                {
                    // End:0x13D
                    if(!P.PlayerReplicationInfo.bOnlySpectator)
                    {
                        bReady = false;
                    }
                    // End:0x17E
                    if(PKPlayerController_MP(P) != none)
                    {
                        PKPlayerController_MP(P).ShowTeamPanel(true);
                    }
                }                
            }            
        }
        // End:0x227
        if(bReady)
        {
            // End:0x1D1
            if(PainGRI(GameReplicationInfo).CountdownTimer == 0)
            {
                PlayStartupMessage();
                StartMatch();                
            }
            else
            {
                // End:0x227
                if(PainGRI(GameReplicationInfo).CountdownTimer > 0)
                {
                    PainGRI(GameReplicationInfo).CountdownTimer--;
                }
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        PainGRI(GameReplicationInfo).CountdownTimer = InitialCountdown;
        bWaitingToStartMatch = true;
        StartupStage = 0;
        //return;        
    }

    function EndState(name NextStateName)
    {
        local PlayerController P;

        // End:0x76
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
        {
            // End:0x75
            if(PKPlayerController_MP(P) != none)
            {
                PKPlayerController_MP(P).ShowTeamPanel(false);
            }            
        }        
        //return;        
    }
Begin:

    // End:0x6D
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_ListenServer)) && !IsConsoleDedicatedServer())
    {
        Sleep(0.0000000);
    }
    stop;            
}

state MatchInProgress
{
    ignores PlayStartupMessage;

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
        // End:0x146
        if(bOverTime)
        {
            EndGame(none, "TimeLimit");            
        }
        else
        {
            // End:0x1F9
            if(TimeLimit > 0)
            {
                GameReplicationInfo.bStopCountDown = false;
                // End:0x1F6
                if(GameReplicationInfo.RemainingTime <= 0)
                {
                    // End:0x1E0
                    if(GoalScore == 0)
                    {
                        EndGame(GetPC().PlayerReplicationInfo, "TimeLimit");                        
                    }
                    else
                    {
                        EndGame(none, "TimeLimit");
                    }
                }                
            }
            else
            {
                // End:0x22F
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

        // End:0xA0
        if(PreviousStateName != 'RoundOver')
        {
            // End:0x51
            foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
            {
                PRI.StartTime = 0;                
            }            
            GameReplicationInfo.ElapsedTime = 0;
            bWaitingToStartMatch = false;
            StartupStage = 5;
            PlayStartupMessage();
            StartupStage = 6;
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    InitialCountdown=5
    OnlineStatsWriteClass=Class'PKLeaderboardWriteSingleSV'
}