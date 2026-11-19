class PKGameCTF extends PKGameTeamDeathmatch
    abstract
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var PKCTFFlag Flags[2];
var class<LocalMessage> AnnouncerMessageClass;

function PostBeginPlay()
{
    local int I;

    super(PKGame).PostBeginPlay();
    I = 0;
    J0x15:

    // End:0x105 [Loop If]
    if(I < 2)
    {
        Flags[I].Team = Teams[I];
        Teams[I].HomeBase = EvilGameObjective(Flags[I].HomeBase);
        Teams[I].TeamFlag = Flags[I];
        I++;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x2D
    if(bOverTime)
    {
        EndGame(Scorer, "timelimit");
        return true;
    }
    return super.CheckScore(Scorer);
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

function RegisterFlag(PKCTFFlag F, int TeamIndex)
{
    Flags[TeamIndex] = F;
    //return;    
}

function bool NearGoal(Controller C)
{
    local EvilGameObjective B;

    B = PKTeamInfo(C.PlayerReplicationInfo.Team).HomeBase;
    return PKCTFBase(B).myFlag.bHome && VSize(C.Pawn.Location - B.Location) < float(1000);
    //return ReturnValue;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local PKCTFFlag BestFlag;
    local Controller P;
    local bool bLastMan;

    // End:0x22
    if(bOverTime)
    {
        SetEndGameFocus(Winner);
        return true;
    }
    bLastMan = Reason ~= "LastMan";
    // End:0x62
    if(CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    // End:0xAF
    if(bLastMan)
    {
        GameReplicationInfo.Winner = Winner.Team;        
    }
    else
    {
        // End:0x12A
        if(Teams[1].Score == Teams[0].Score)
        {
            // End:0x125
            if(!bOverTimeBroadcast)
            {
                StartupStage = 7;
                PlayStartupMessage();
                bOverTimeBroadcast = true;
            }
            return false;            
        }
        else
        {
            // End:0x19C
            if(Teams[1].Score > Teams[0].Score)
            {
                GameReplicationInfo.Winner = Teams[1];                
            }
            else
            {
                GameReplicationInfo.Winner = Teams[0];
            }
        }
    }
    BestFlag = PKCTFFlag(PKTeamInfo(GameReplicationInfo.Winner).TeamFlag);
    // End:0x26A
    if(Winner != none)
    {
        EndGameFocus = Controller(Winner.Owner).Pawn;
    }
    // End:0x2A1
    if(EndGameFocus == none)
    {
        EndGameFocus = BestFlag.HomeBase;
    }
    EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
    // End:0x3AA
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);        
    }    
    BestFlag.HomeBase.SetHidden(false);
    return true;
    //return ReturnValue;    
}

function ScoreFlag(Controller Scorer, PKCTFFlag theFlag)
{
    local float Dist, oppDist;
    local int I, GoalsScored;
    local float ppp, numtouch;
    local Vector FlagLoc;
    local PainPRI ScorerPRI;
    local PKPlayerController PC, PCRec;

    ScorerPRI = PainPRI(Scorer.PlayerReplicationInfo);
    // End:0x2E9
    if(ScorerPRI.Team == theFlag.Team)
    {
        FlagLoc = theFlag.Position().Location;
        Dist = VSize(FlagLoc - theFlag.HomeBase.Location);
        oppDist = VSize(FlagLoc - Teams[1 - theFlag.Team.TeamIndex].HomeBase.Location);
        BroadcastLocalizedMessage(AnnouncerMessageClass, 1 + (7 * theFlag.Team.TeamIndex), ScorerPRI, none, theFlag.Team);
        ScorerPRI.IncrementEventStat('EVENT_RETURNEDFLAG');
        ScorerPRI.IncrementReturnedFlagStat();
        // End:0x2E7
        if(Dist > float(1024))
        {
            // End:0x28A
            if(Dist <= oppDist)
            {
                ScorerPRI.Score += float(3);                
            }
            else
            {
                ScorerPRI.Score += float(5);
                // End:0x2E7
                if(oppDist <= float(1024))
                {
                    ScorerPRI.Score += float(7);
                }
            }
        }
        return;
    }
    // End:0x3A6
    if(theFlag.FirstTouch != none)
    {
        theFlag.FirstTouch.PlayerReplicationInfo.Score += float(5);
        theFlag.FirstTouch.PlayerReplicationInfo.bForceNetUpdate = true;
    }
    PC = PKPlayerController(Scorer);
    ScorerPRI.bForceNetUpdate = true;
    ScorerPRI.Score += float(5);
    GoalsScored = ScorerPRI.IncrementEventStat('EVENT_SCOREDFLAG');
    ScorerPRI.IncrementCapturedFlagsStat();
    // End:0x4AC
    if(PC != none)
    {
        PC.IncrementGlobalIntStat(141);
        PC.ClientUnlockAchievement(56);
    }
    // End:0x5A9
    if(GoalsScored == 3)
    {
        // End:0x513
        if((PC != none) && ScorerPRI.CharacterSkinIndex == 1)
        {
            PC.ClientUnlockAchievement(48);
        }
        ScorerPRI.IncrementEventStat('EVENT_HATTRICK');
        // End:0x5A5
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PCRec)
        {
            PCRec.ReceiveLocalizedMessage(TeamScoreMessageClass, 6, ScorerPRI);            
        }                
    }
    else
    {
        // End:0x613
        foreach WorldInfo.AllControllers(Class'PKPlayerController', PCRec)
        {
            PCRec.ReceiveLocalizedMessage(TeamScoreMessageClass, 7, ScorerPRI);            
        }        
    }
    // End:0x7E2
    if(theFlag.Assists.Length > 0)
    {
        numtouch = 0.0000000;
        I = 0;
        J0x653:

        // End:0x6D6 [Loop If]
        if(I < theFlag.Assists.Length)
        {
            // End:0x6C8
            if(theFlag.Assists[I] != none)
            {
                numtouch = numtouch + 1.0000000;
            }
            I++;
            // [Loop Continue]
            goto J0x653;
        }
        // End:0x7E2
        if(numtouch > float(0))
        {
            ppp = FClamp(20.0000000 / numtouch, 1.0000000, 5.0000000);
            I = 0;
            J0x718:

            // End:0x7E2 [Loop If]
            if(I < theFlag.Assists.Length)
            {
                // End:0x7D4
                if(theFlag.Assists[I] != none)
                {
                    theFlag.Assists[I].PlayerReplicationInfo.Score += float(int(ppp));
                }
                I++;
                // [Loop Continue]
                goto J0x718;
            }
        }
    }
    ScorerPRI.Team.Score += 1.0000000;
    ScorerPRI.Team.bForceNetUpdate = true;
    CheckScore(ScorerPRI);
    // End:0x893
    if(bOverTime)
    {
        EndGame(ScorerPRI, "timelimit");        
    }
    else
    {
        // End:0x971
        if(PainGRI(GameReplicationInfo).bStoryMode)
        {
            // End:0x91B
            if(ScorerPRI.Team.TeamIndex == 0)
            {
                AdjustedDifficulty = FMin(7.0000000, AdjustedDifficulty + 0.5000000);                
            }
            else
            {
                AdjustedDifficulty = FMax(0.0000000, AdjustedDifficulty - 0.5000000);
            }
            AdjustedDifficulty = FClamp(AdjustedDifficulty, GameDifficulty - 1.2500000, GameDifficulty + 1.2500000);
        }
    }
    AnnounceScore(ScorerPRI.Team.TeamIndex);
    //return;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local PKPlayerController PKPC;

    super(PKGameMP_Base).EndGame(Winner, Reason);
    // End:0x102
    if(((Winner != none) && bGameEnded) && Locs(Reason) != "timelimit")
    {
        // End:0x102
        if(((GameReplicationInfo.TimeLimit * 60) - GameReplicationInfo.RemainingTime) >= 10)
        {
            PKPC = PKPlayerController(Winner.Owner);
            // End:0x102
            if(PKPC != none)
            {
                PKPC.ClientUnlockAchievement(62);
            }
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
        if(PKPlayerController(PC) != none)
        {
            PKPlayerController(PC).ClientSetBehindView(true);
        }        
    }
    else
    {
        A = Flags[0].HomeBase.GetBestViewTarget();
        PC.SetViewTarget(A);
        // End:0x235
        if(PKPlayerController(PC) != none)
        {
            PKPlayerController(PC).ClientSetBehindView(true);
        }
    }
    //return;    
}

function Actor GetAutoObjectiveFor(PlayerController PC)
{
    // End:0x145
    if(PKTeamInfo(PC.PlayerReplicationInfo.Team) != none)
    {
        // End:0xD7
        if(PainPRI(PC.PlayerReplicationInfo).bHasFlag)
        {
            return PKTeamInfo(PC.PlayerReplicationInfo.Team).HomeBase;            
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

state MatchOver
{
    ignores AnnounceScore, ScoreFlag;
    stop;    
}

defaultproperties
{
    bScoreTeamKills=false
    bSpawnInTeamArea=true
    bScoreVictimsTarget=true
    FlagKillMessageName="FLAGKILL"
    bUndrivenVehicleDamage=true
    bScoreDeaths=false
    Acronym="CTF"
    MapPrefixes=/* Array type was not detected. */
    MidgameScorePanelTag="CTFPanel"
    GoalScore=3
    OnlineStatsWriteClass=Class'PKLeaderboardWriteCTF'
    OnlineGameSettingsClass=Class'PKGameCTFSettings'
}