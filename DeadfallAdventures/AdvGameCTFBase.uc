class AdvGameCTFBase extends AdvGameTeamDeathmatchBase
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var AdvCTFFlagBase Flags[2];
var AdvCTFBasementBase Basements[2];
var int ScoreForFlagCapture;
var SoundCue TeamFlagCapturedSound;
var string TeamFlagCapturedStringKey;
var SoundCue EnemyFlagCapturedSound;
var string EnemyFlagCapturedStringKey;
var class<LocalMessage> AnnouncerMessageClass;

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local AdvCTFFlagBase myFlag;
    local float Rating, Distance;

    Rating = super.RatePlayerStart(P, Team, Player);
    // End:0x1CF
    if(P.TeamIndex != 255)
    {
        // End:0xA3
        if(AdvGRI(GameReplicationInfo).bTeamsInverted)
        {
            Team = ((int(Team) == int(0)) ? 1 : 0);
        }
        // End:0xE3
        if(int(Team) != P.TeamIndex)
        {
            Rating -= float(60);            
        }
        else
        {
            // End:0x140
            if(Flags[0].Team.TeamIndex == int(Team))
            {
                myFlag = Flags[0];                
            }
            else
            {
                myFlag = Flags[1];
            }
            Distance = VSize(myFlag.Location - P.Location);
            // End:0x1CF
            if(Distance > float(1000))
            {
                Rating -= (Distance * 0.0010000);
            }
        }
    }
    return float(Max(1, int(Rating)));
    //return ReturnValue;    
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
    local Controller P;

    // End:0x9F
    if(Winner != none)
    {
        // End:0x75
        if(Winner.Team.TeamIndex == 0)
        {
            EndGameFocus = Flags[0].HomeBase;            
        }
        else
        {
            EndGameFocus = Flags[1].HomeBase;
        }
    }
    // End:0xCF
    if(EndGameFocus != none)
    {
        EndGameFocus.bAlwaysRelevant = true;
    }
    // End:0x1A5
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);        
    }    
    //return;    
}

function int GetHandicapNeed(Pawn Other)
{
    // End:0x61
    if((Other.PlayerReplicationInfo == none) || Other.PlayerReplicationInfo.Team == none)
    {
        return 0;
    }
    return int(Teams[1 - Other.PlayerReplicationInfo.Team.TeamIndex].Score - Other.PlayerReplicationInfo.Team.Score);
    //return ReturnValue;    
}

function bool GetLocationFor(Pawn StatusPawn, out Actor LocationObject, out int MessageIndex, int LocationSpeechOffset)
{
    local UDKGameObjective Best;

    // End:0x16D
    if((Flags[0].HomeBase != none) && Flags[1].HomeBase != none)
    {
        Best = ((VSizeSq(StatusPawn.Location - Flags[0].HomeBase.Location) < VSizeSq(StatusPawn.Location - Flags[1].HomeBase.Location)) ? Flags[0].HomeBase : Flags[1].HomeBase);
        MessageIndex = 0;
        LocationObject = Best;
        return true;
    }
    MessageIndex = 10;
    return true;
    //return ReturnValue;    
}

function RegisterFlag(AdvCTFFlagBase F, int TeamIndex)
{
    Flags[TeamIndex] = F;
    //return;    
}

function bool NearGoal(Controller C)
{
    local EvilGameObjective B;

    B = AdvTeamInfo(C.PlayerReplicationInfo.Team).HomeBase;
    return AdvCTFBasementBase(B).myFlag.bHome && VSize(C.Pawn.Location - B.Location) < float(1000);
    //return ReturnValue;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x2D
    if(bOverTime)
    {
        EndGame(Scorer, "timelimit");
        return true;
    }
    // End:0xEC
    if((AdvTeamInfo(GameReplicationInfo.Teams[0]).CapturedFlags >= GoalScore) || AdvTeamInfo(GameReplicationInfo.Teams[1]).CapturedFlags >= GoalScore)
    {
        EndGame(Scorer, "TeamScoreLimit");
        return true;
    }
    //return ReturnValue;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local AdvCTFFlagBase BestFlag;
    local Controller P;
    local bool bLastMan;

    bLastMan = Reason ~= "LastMan";
    // End:0x40
    if(CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    // End:0x27D
    if(Reason != "NotEnoughPlayers")
    {
        // End:0xD7
        if(bLastMan)
        {
            GameReplicationInfo.Winner = Winner.Team;
            AdvGRI(GameReplicationInfo).bWinnerUpdated = true;            
        }
        else
        {
            // End:0x17B
            if(AdvTeamInfo(Teams[0]).CapturedFlags == AdvTeamInfo(Teams[1]).CapturedFlags)
            {
                GameReplicationInfo.Winner = none;
                AdvGRI(GameReplicationInfo).bWinnerUpdated = true;                
            }
            else
            {
                // End:0x229
                if(AdvTeamInfo(Teams[0]).CapturedFlags > AdvTeamInfo(Teams[1]).CapturedFlags)
                {
                    GameReplicationInfo.Winner = Teams[0];
                    AdvGRI(GameReplicationInfo).bWinnerUpdated = true;                    
                }
                else
                {
                    GameReplicationInfo.Winner = Teams[1];
                    AdvGRI(GameReplicationInfo).bWinnerUpdated = true;
                }
            }
        }
    }
    // End:0x321
    if(Winner != none)
    {
        BestFlag = AdvCTFFlagBase(AdvTeamInfo(GameReplicationInfo.Winner).TeamFlag);
        EndGameFocus = Controller(Winner.Owner).Pawn;
    }
    // End:0x358
    if(EndGameFocus == none)
    {
        EndGameFocus = BestFlag.HomeBase;
    }
    EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
    // End:0x461
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);        
    }    
    BestFlag.HomeBase.SetHidden(false);
    return true;
    //return ReturnValue;    
}

function ScoreFlag(Controller Scorer, AdvCTFFlagBase theFlag)
{
    local AdvPRI ScorerPRI;
    local AdvPlayerControllerMP PC;

    ScorerPRI = AdvPRI(Scorer.PlayerReplicationInfo);
    PC = AdvPlayerControllerMP(Scorer);
    // End:0x2BA
    if(ScorerPRI.Team == theFlag.Team)
    {
        BroadcastLocalizedMessage(AnnouncerMessageClass, 1 + (7 * theFlag.Team.TeamIndex), ScorerPRI, none, theFlag.Team);
        ScorerPRI.IncrementReturnedFlagStat();
        // End:0x185
        if(AdvGRI(WorldInfo.GRI).CanWriteStats())
        {
            PC.IncrementGlobalIntStat(120);
        }
        // End:0x2B6
        foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
        {
            // End:0x263
            if(theFlag.Team == PC.PlayerReplicationInfo.Team)
            {
                PC.SetCTFMessage(ConvertToLocalizedString("CTFMessages", "TeamFlagReturned", "ADVGame"));
                // End:0x2B5
                continue;
            }
            PC.SetCTFMessage(ConvertToLocalizedString("CTFMessages", "EnemyFlagReturned", "ADVGame"));            
        }                
    }
    else
    {
        ScorerPRI.Score += float(ScoreForFlagCapture);
        ScorerPRI.bForceNetUpdate = true;
        ScorerPRI.Team.Score += float(1);
        AdvTeamInfo(ScorerPRI.Team).CapturedFlags += 1;
        ScorerPRI.Team.bForceNetUpdate = true;
        ScorerPRI.IncrementCapturedFlagsStat();
        // End:0x435
        if(AdvGRI(WorldInfo.GRI).CanWriteStats())
        {
            PC.IncrementGlobalIntStat(119);
        }
        // End:0x592
        if(!CheckScore(ScorerPRI))
        {
            // End:0x591
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
            {
                // End:0x535
                if(theFlag.Team == PC.PlayerReplicationInfo.Team)
                {
                    PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", TeamFlagCapturedStringKey, "AdvGame"), TeamFlagCapturedSound);
                    // End:0x590
                    continue;
                }
                PC.SetAnnouncerMessage(ConvertToLocalizedString("MultiplayerAnnouncer", EnemyFlagCapturedStringKey, "AdvGame"), EnemyFlagCapturedSound);                
            }            
        }
        // End:0x5BD
        if(bOverTime)
        {
            EndGame(ScorerPRI, "timelimit");
        }
    }
    //return;    
}

function ViewObjective(PlayerController PC)
{
    local Actor A;

    // End:0x18B
    if((PC.ViewTarget != none) && ((PC.ViewTarget == Flags[0]) || PC.ViewTarget == Flags[0].Holder) || PC.ViewTarget == Flags[0].HomeBase)
    {
        A = Flags[1].HomeBase.GetBestViewTarget();
        PC.SetViewTarget(A);
        // End:0x188
        if(AdvPlayerController(PC) != none)
        {
            AdvPlayerController(PC).ClientSetBehindView(true);
        }        
    }
    else
    {
        A = Flags[0].HomeBase.GetBestViewTarget();
        PC.SetViewTarget(A);
        // End:0x235
        if(AdvPlayerController(PC) != none)
        {
            AdvPlayerController(PC).ClientSetBehindView(true);
        }
    }
    //return;    
}

function Actor GetAutoObjectiveFor(PlayerController PC)
{
    // End:0x145
    if(AdvTeamInfo(PC.PlayerReplicationInfo.Team) != none)
    {
        // End:0xD7
        if(AdvPRI(PC.PlayerReplicationInfo).bHasFlag)
        {
            return AdvTeamInfo(PC.PlayerReplicationInfo.Team).HomeBase;            
        }
        else
        {
            return Teams[1 - PC.PlayerReplicationInfo.Team.TeamIndex].HomeBase;
        }        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

function IncrementEndGameStatistics(AdvPlayerControllerMP Winner)
{
    Winner.IncrementGlobalIntStat(133);
    //return;    
}

state MatchInProgress
{
    function BeginState(name PreviousStateName)
    {
        local int I;
        local AdvPlayerControllerMP PC;

        // End:0x98
        if(AdvGRI(GameReplicationInfo).bFirstRound)
        {
            Basements[0] = AdvCTFBasementBase(Flags[0].HomeBase);
            Basements[1] = AdvCTFBasementBase(Flags[1].HomeBase);            
        }
        else
        {
            Basements[0].Restart();
            Basements[1].Restart();
            // End:0x12E
            foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
            {
                PC.SetCTFParticles();                
            }            
        }
        I = 0;
        J0x13A:

        // End:0x22A [Loop If]
        if(I < 2)
        {
            Flags[I].Team = Teams[I];
            Teams[I].HomeBase = EvilGameObjective(Flags[I].HomeBase);
            Teams[I].TeamFlag = Flags[I];
            I++;
            // [Loop Continue]
            goto J0x13A;
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state MatchOver
{
    ignores AnnounceScore, ScoreFlag;
    stop;    
}

defaultproperties
{
    ScoreForFlagCapture=1000
    TeamFlagCapturedSound=SoundCue'a_anno_ctf01_cue.ANNO_CTF_ETCA_001'
    TeamFlagCapturedStringKey="ANNO_CTF_ETCA_001"
    EnemyFlagCapturedSound=SoundCue'a_anno_ctf01_cue.ANNO_CTF_PTCA_001'
    EnemyFlagCapturedStringKey="ANNO_CTF_PTCA_001"
    bScoreTeamKills=false
    bUndrivenVehicleDamage=true
    bScoreDeaths=false
    Acronym="CTF"
    MapPrefixes=/* Array type was not detected. */
    MidgameScorePanelTag="CTFPanel"
    OnlineStatsWriteClass=Class'AdvLeaderboard_Write_CTF'
}