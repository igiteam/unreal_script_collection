class SkyGame_DeathMatch extends SkyGame
    config(Game);

var transient bool bAutomatedTest;
var float AutomatedTestTime;

static function PrecacheGameAnnouncements(SkyAnnouncer Announcer)
{
    super.PrecacheGameAnnouncements(Announcer);
    default.TeamScoreMessageClass.static.PrecacheGameAnnouncements(Announcer, default.Class);
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    super.InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "AutomatedTest");
    // End:0x9F
    if(InOpt != "")
    {
        bAutomatedTest = true;
        InOpt = ParseOption(Options, "AutomatedTestTime");
        // End:0x89
        if(InOpt != "")
        {
            AutomatedTestTime = float(InOpt);
        }
        SetTimer(AutomatedTestTime, false, 'ExitAutomatedTest');        
    }
    //return;    
}

function bool TooManyBots(Controller botToRemove)
{
    return true;
    //return ReturnValue;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    local bool bLastMan;

    // End:0x90
    if(bOverTime)
    {
        // End:0x1D
        if((NumBots + NumPlayers) == 0)
        {
            return true;
        }
        bLastMan = true;
        // End:0x84
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0x83
            if((P.PlayerReplicationInfo != none) && !P.PlayerReplicationInfo.bOutOfLives)
            {
                bLastMan = false;
                // End:0x84
                break;
            }            
        }        
        // End:0x90
        if(bLastMan)
        {
            return true;
        }
    }
    bLastMan = Reason ~= "LastMan";
    // End:0xCD
    if(!bLastMan && CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    // End:0x102
    if(bTeamScoreRounds)
    {
        // End:0xFF
        if(Winner != none)
        {
            Winner.Team.Score += float(1);
        }        
    }
    else
    {
        // End:0x15D
        if(!bLastMan && Teams[1].Score == Teams[0].Score)
        {
            // End:0x15B
            if(!bOverTimeBroadcast)
            {
                StartupStage = 7;
                PlayStartupMessage();
                bOverTimeBroadcast = true;
            }
            return false;
        }
    }
    // End:0x188
    if(bLastMan)
    {
        GameReplicationInfo.Winner = Winner.Team;        
    }
    else
    {
        // End:0x1C9
        if(Teams[1].Score > Teams[0].Score)
        {
            GameReplicationInfo.Winner = Teams[1];            
        }
        else
        {
            GameReplicationInfo.Winner = Teams[0];
        }
    }
    // End:0x29F
    if(Winner == none)
    {
        // End:0x29E
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0x29D
            if(((P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner) && (Winner == none) || P.PlayerReplicationInfo.Score > Winner.Score)
            {
                Winner = P.PlayerReplicationInfo;
            }            
        }        
    }
    EndTime = WorldInfo.TimeSeconds + EndTimeDelay;
    SetEndGameFocus(Winner);
    return true;
    //return ReturnValue;    
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
    local Controller P;

    // End:0x2F
    if(Winner != none)
    {
        EndGameFocus = Controller(Winner.Owner).Pawn;
    }
    // End:0x4C
    if(EndGameFocus != none)
    {
        EndGameFocus.bAlwaysRelevant = true;
    }
    // End:0xC4
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner);        
    }    
    //return;    
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    // End:0x22
    if((ViewTarget == none) || ViewTarget.bOnlySpectator)
    {
        return false;
    }
    return Viewer.PlayerReplicationInfo.bOnlySpectator || ViewTarget.Team == Viewer.PlayerReplicationInfo.Team;
    //return ReturnValue;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x17
    if(CheckMaxLives(Scorer))
    {
        return false;        
    }
    else
    {
        // End:0x2C
        if(!super(GameInfo).CheckScore(Scorer))
        {
            return false;            
        }
        else
        {
            // End:0x49
            if(!bOverTime && GoalScore == 0)
            {
                return false;                
            }
            else
            {
                // End:0x7E
                if((Scorer != none) && bOverTime)
                {
                    EndGame(Scorer, "timelimit");
                    return true;                    
                }
                else
                {
                    return false;
                }
            }
        }
    }
    //return ReturnValue;    
}

function bool CriticalPlayer(Controller Other)
{
    // End:0x36
    if((Other.PlayerReplicationInfo != none) && Other.PlayerReplicationInfo.bHasFlag)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pawn FindVictimsTarget(Controller Other)
{
    local Vector Start, X, Y, Z;
    local float Dist, Aim;
    local Actor Target;

    // End:0x45
    if(((Other == none) || Other.Pawn == none) || Other.Pawn.Weapon == none)
    {
        return none;
    }
    GetAxes(Other.Pawn.GetViewRotation(), X, Y, Z);
    Start = Other.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * Other.Pawn.BaseEyeHeight);
    Aim = 0.9700000;
    Target = Other.PickTarget(Class'Engine.Pawn', Aim, Dist, X, Start, 4000.0000000);
    return Pawn(Target);
    //return ReturnValue;    
}

function bool NearGoal(Controller C)
{
    return false;
    //return ReturnValue;    
}

function bool DominatingVictory()
{
    return ((Teams[0].Score == float(0)) || Teams[1].Score == float(0)) && (Teams[0].Score + Teams[1].Score) >= float(3);
    //return ReturnValue;    
}

function bool IsAWinner(PlayerController C)
{
    return C.PlayerReplicationInfo.bOnlySpectator || IsWinningTeam(C.PlayerReplicationInfo.Team);
    //return ReturnValue;    
}

function bool IsWinningTeam(TeamInfo T)
{
    // End:0x39
    if(Teams[0].Score > Teams[1].Score)
    {
        return T == Teams[0];        
    }
    else
    {
        return T == Teams[1];
    }
    //return ReturnValue;    
}

function PlayRegularEndOfMatchMessage()
{
    local SkyPlayerController PC;
    local int Index;

    // End:0x32
    if(Teams[0].Score > Teams[1].Score)
    {
        Index = 4;        
    }
    else
    {
        Index = 5;
    }
    // End:0x79
    foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
    {
        PC.ClientSPlayAnnouncement(VictoryMessageClass, byte(Index));        
    }    
    //return;    
}

function bool AllowClientToTeleport(SkyPlayerReplicationInfo ClientPRI, Actor DestinationActor)
{
    return GameReplicationInfo.OnSameTeam(ClientPRI, DestinationActor);
    //return ReturnValue;    
}

function ShowPathTo(PlayerController P, int TeamNum)
{
    //return;    
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    super(GameInfo).GetSeamlessTravelActorList(bToEntry, ActorList);
    ActorList[ActorList.Length] = WorldInfo.GRI.Teams[0];
    ActorList[ActorList.Length] = WorldInfo.GRI.Teams[1];
    //return;    
}

event HandleSeamlessTravelPlayer(out Controller C)
{
    local TeamInfo NewTeam;

    // End:0x155
    if(C.PlayerReplicationInfo != none)
    {
        // End:0x125
        if((C.PlayerReplicationInfo.Team != none) && C.PlayerReplicationInfo.Team.TeamIndex < 2)
        {
            NewTeam = Teams[C.PlayerReplicationInfo.Team.TeamIndex];
            // End:0xDC
            if(C.PlayerReplicationInfo.Team.Size <= 1)
            {
                C.PlayerReplicationInfo.Team.Destroy();                
            }
            else
            {
                C.PlayerReplicationInfo.Team.RemoveFromTeam(C);
            }
            NewTeam.AddToTeam(C);            
        }
        else
        {
            // End:0x155
            if(!C.PlayerReplicationInfo.bOnlySpectator)
            {
                ChangeTeam(C, 0, false);
            }
        }
    }
    super.HandleSeamlessTravelPlayer(C);
    //return;    
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return default.Class;
    //return ReturnValue;    
}

function ExitAutomatedTest()
{
    ConsoleCommand("EXIT");
    //return;    
}

event AddDefaultInventory(Pawn PlayerPawn)
{
    local int I;
    local bool bActivated;

    bActivated = false;
    // End:0xA0
    if(SkyPawn(PlayerPawn) == none)
    {
        I = 0;
        J0x1F:

        // End:0x9D [Loop If]
        if(I < DefaultInventory.Length)
        {
            // End:0x93
            if(SkyPawn(PlayerPawn).FindInventoryTypeByArch(DefaultInventory[I]) == none)
            {
                PlayerPawn.CreateInventory(DefaultInventory[I].Class, bActivated, DefaultInventory[I]);
                bActivated = true;
            }
            I++;
            // [Loop Continue]
            goto J0x1F;
        }        
    }
    else
    {
        SkyPawn(PlayerPawn).DefaultInventory = DefaultInventory;
    }
    PlayerPawn.AddDefaultInventory();
    SetPlayerDefaults(PlayerPawn);
    //return;    
}

function bool NeedPlayers()
{
    return false;
    //return ReturnValue;    
}
