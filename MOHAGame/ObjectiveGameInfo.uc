class ObjectiveGameInfo extends AirborneTeamGameInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var float SwitchTeamsTimeLimit;
var const float ObjectiveCompleteDist;
var bool bCheckIfTeamEliminated;
var array<MPObjective> m_ObjectiveList;
var array<MPObjective_FLAG> m_ObjectiveFLAGList;
var config float TeamPointsForObjectiveAssist;

function PostBeginPlay()
{
    local MPObjective O;
    local MPObjective_FLAG MPOF;
    local int I;

    super.PostBeginPlay();
    // End:0x50
    foreach DynamicActors(Class'MPObjective', O)
    {
        // End:0x4F
        if(MPObjectiveSpawnPoint(O) == none)
        {
            I = m_ObjectiveList.Length;
            m_ObjectiveList.Insert(I, 1);
            m_ObjectiveList[I] = O;
        }        
    }    
    // End:0xAE
    foreach DynamicActors(Class'MPObjective_FLAG', MPOF)
    {
        I = m_ObjectiveFLAGList.Length;
        m_ObjectiveFLAGList.Insert(I, 1);
        m_ObjectiveFLAGList[I] = MPOF;
        MPOF.SetHidden(false);
        MPOF.stateChanged();        
    }    
    //return;    
}

function bool InJoinOrChangeTime()
{
    // End:0x1C
    if(SwitchTeamsTimeLimit > float(GameReplicationInfo.ElapsedTime))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CanRespawn(MOHAPlayerController C)
{
    // End:0x12
    if(InJoinOrChangeTime())
    {
        return true;        
    }
    else
    {
        C.PlayerReplicationInfo.bOutOfLives = true;
        return false;
    }
    //return ReturnValue;    
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    // End:0x5D
    if((Viewer.PlayerReplicationInfo.Team.TeamIndex != ViewTarget.Team.TeamIndex) || !MOHAMultiplayerController(Viewer).CanBeSpectated())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function byte PickTeam(byte Current, Controller C)
{
    return super(TeamGameInfo).PickTeam(Current, C);
    //return ReturnValue;    
}

event PostLogin(PlayerController NewPlayer)
{
    super(GameInfo).PostLogin(NewPlayer);
    //return;    
}

function RestartPlayer(Controller NewPlayer)
{
    super.RestartPlayer(NewPlayer);
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local MOHAPlayerReplicationInfo KillerPRI;

    KillerPRI = MOHAPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    MOHAPlayerController(Other).PlayerReplicationInfo.bOutOfLives = true;
    super(TeamGameInfo).ScoreKill(Killer, Other);
    CheckScore(KillerPRI);
    //return;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x12
    if(!super(GameInfo).CheckScore(Scorer))
    {
        return false;
    }
    // End:0x40
    if(CheckIfTeamEliminated())
    {
        EndGame(Scorer, "TeamEliminated");
        return true;
    }
    return false;
    //return ReturnValue;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local SeqEvent_MPRoundOverByTimeOut RoundOverEventTimeOut;
    local SeqEvent_MPRoundOverByObjectivesDestroyed RoundOverEventObjectives;
    local SeqEvent_MPRoundOverByTeamEliminated RoundOverEventTeam;
    local int idx;
    local array<SequenceObject> Events;
    local MOHAMultiplayerController C;

    super(MOHAMultiplayerGameInfo).EndGame(Winner, Reason);
    GameReplicationInfo.Teams[ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam].Score = GameReplicationInfo.Teams[ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam].Score + float(1);
    // End:0xD1
    if(Class'Engine.WorldInfo'.static.IsDedicatedServer() && Winner != none)
    {
        Class'Engine.Engine'.static.DSLog(MOHAGameReplicationInfo(GameReplicationInfo).GetTeamName(ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam) @ "win.");
    }
    // End:0x2B3
    if(WorldInfo.GetGameSequence() != none)
    {
        // End:0x17C
        if(Reason == "TimeLimit")
        {
            WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_MPRoundOverByTimeOut', true, Events);
            idx = 0;
            J0x126:

            // End:0x179 [Loop If]
            if(idx < Events.Length)
            {
                RoundOverEventTimeOut = SeqEvent_MPRoundOverByTimeOut(Events[idx]);
                // End:0x16F
                if(RoundOverEventTimeOut != none)
                {
                    RoundOverEventTimeOut.CheckActivate(WorldInfo, none);
                }
                idx++;
                // [Loop Continue]
                goto J0x126;
            }            
        }
        else
        {
            // End:0x21B
            if(Reason == "ObjectivesComplete")
            {
                WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_MPRoundOverByObjectivesDestroyed', true, Events);
                idx = 0;
                J0x1C5:

                // End:0x218 [Loop If]
                if(idx < Events.Length)
                {
                    RoundOverEventObjectives = SeqEvent_MPRoundOverByObjectivesDestroyed(Events[idx]);
                    // End:0x20E
                    if(RoundOverEventObjectives != none)
                    {
                        RoundOverEventObjectives.CheckActivate(WorldInfo, none);
                    }
                    idx++;
                    // [Loop Continue]
                    goto J0x1C5;
                }                
            }
            else
            {
                // End:0x2B3
                if(Reason == "TeamEliminated")
                {
                    WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_MPRoundOverByTeamEliminated', true, Events);
                    idx = 0;
                    J0x260:

                    // End:0x2B3 [Loop If]
                    if(idx < Events.Length)
                    {
                        RoundOverEventTeam = SeqEvent_MPRoundOverByTeamEliminated(Events[idx]);
                        // End:0x2A9
                        if(RoundOverEventTeam != none)
                        {
                            RoundOverEventTeam.CheckActivate(WorldInfo, none);
                        }
                        idx++;
                        // [Loop Continue]
                        goto J0x260;
                    }
                }
            }
        }
    }
    // End:0x2EA
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
    {
        C.ClientSetSpawnText("", 0.0000000);        
    }    
    //return;    
}

function bool CheckIfTeamEliminated()
{
    local Controller P;
    local array<int> TeamLives;
    local int Team, TeamOut;

    TeamLives[0] = 0;
    TeamLives[1] = 1;
    // End:0xC6
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        // End:0xC5
        if(P.bIsPlayer && !P.PlayerReplicationInfo.bOutOfLives)
        {
            Team = P.PlayerReplicationInfo.Team.TeamIndex;
            // End:0xC5
            if((P.Pawn != none) && P.Pawn.Health > 0)
            {
                TeamLives[Team]++;
            }
        }        
    }    
    // End:0x149
    if((TeamLives[0] == 0) || TeamLives[1] == 1)
    {
        // End:0x10F
        if(TeamLives[0] == 0)
        {
            ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 1;
            TeamOut = 0;            
        }
        else
        {
            ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 0;
            TeamOut = 1;
        }
        // End:0x147
        if(ObjectiveActiveForTeam(TeamOut))
        {
            bCheckIfTeamEliminated = true;
            return false;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ObjectiveActiveForTeam(int TeamIndex)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x7C [Loop If]
    if(I < m_ObjectiveList.Length)
    {
        // End:0x72
        if(((int(m_ObjectiveList[I].ObjectiveState) == int(1)) && m_ObjectiveList[I].bDelayRoundEnd) && m_ObjectiveList[I].Team != TeamIndex)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function bool ObjectiveActive()
{
    local int I, ObjectivesInjeopardy, ObjectivesAlive;

    ObjectivesInjeopardy = 0;
    ObjectivesAlive = 0;
    I = 0;
    J0x15:

    // End:0xAF [Loop If]
    if(I < m_ObjectiveList.Length)
    {
        // End:0x65
        if((int(m_ObjectiveList[I].ObjectiveState) != int(2)) && m_ObjectiveList[I].bDelayRoundEnd)
        {
            ObjectivesAlive++;
        }
        // End:0xA5
        if((int(m_ObjectiveList[I].ObjectiveState) == int(1)) && m_ObjectiveList[I].bDelayRoundEnd)
        {
            ObjectivesInjeopardy++;
        }
        I++;
        // [Loop Continue]
        goto J0x15;
    }
    // End:0xC0
    if(ObjectivesAlive == ObjectivesInjeopardy)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function RemoveControllerFromFlags(MOHAMultiplayerController C)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < m_ObjectiveFLAGList.Length)
    {
        m_ObjectiveFLAGList[I].UnTouchedBy(C);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function ProcessTimeRules()
{
    local int AxisFlags, AlliedFlags, I;
    local MOHAMultiplayerController C;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x97
    if((((P != none) && P.isRanked()) && MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus != 4) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x97
        if(ShouldEndDueToTeamQuit())
        {
            EndGame(none, "TeamQuit");
            return;
        }
    }
    // End:0x10E
    if(((bDisplayedTimeRunningOut == false) && GameReplicationInfo.RemainingTime <= 30) && MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus == 0)
    {
        // End:0x105
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            C.ClientShowTimeRunningOutMessage();            
        }        
        bDisplayedTimeRunningOut = true;
    }
    // End:0x2EB
    if((GameReplicationInfo.RemainingTime <= 0) && MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus == 0)
    {
        I = 0;
        J0x144:

        // End:0x1EF [Loop If]
        if(I < m_ObjectiveFLAGList.Length)
        {
            // End:0x19E
            if((int(m_ObjectiveFLAGList[I].m_State) == int(3)) || int(m_ObjectiveFLAGList[I].m_State) == int(2))
            {
                AxisFlags++;
                // [Explicit Continue]
                goto J0x1E5;
            }
            // End:0x1E5
            if((int(m_ObjectiveFLAGList[I].m_State) == int(6)) || int(m_ObjectiveFLAGList[I].m_State) == int(5))
            {
                AlliedFlags++;
            }
            J0x1E5:

            I++;
            // [Loop Continue]
            goto J0x144;
        }
        // End:0x216
        if(AxisFlags > AlliedFlags)
        {
            ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 1;            
        }
        else
        {
            // End:0x23D
            if(AlliedFlags > AxisFlags)
            {
                ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 0;                
            }
            else
            {
                GameReplicationInfo.RemainingTime = 0;
                // End:0x28A
                if(bSuddenDeath == false)
                {
                    // End:0x289
                    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
                    {
                        C.ClientShowSuddenDeathMessage();                        
                    }                    
                }
                bSuddenDeath = true;
                return;
            }
        }
        // End:0x2C4
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            C.ClientClearGameMessage();            
        }        
        bDisplayedTimeRunningOut = false;
        bSuddenDeath = false;
        EndGame(none, "TimeLimit");
    }
    //return;    
}

function Timer()
{
    super.Timer();
    //return;    
}

function CheckObjectivesStatus()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x8C [Loop If]
    if(I < m_ObjectiveList.Length)
    {
        // End:0x3B
        if(int(m_ObjectiveList[I].ObjectiveState) != int(2))
        {
            return;
            // [Explicit Continue]
            goto J0x82;
        }
        // End:0x6D
        if(m_ObjectiveList[I].Team == 0)
        {
            ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 1;
            // [Explicit Continue]
            goto J0x82;
        }
        ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 0;
        J0x82:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x9A
    if(m_ObjectiveList.Length == 0)
    {
        return;
    }
    EndGame(none, "ObjectivesComplete");
    //return;    
}

function CheckFlagObjectivesStatus()
{
    local int I;
    local MPObjective_FLAG MPOF;

    MPOF = m_ObjectiveFLAGList[0];
    // End:0x5E
    if(((int(MPOF.m_State) == int(0)) || int(MPOF.m_State) == int(1)) || int(MPOF.m_State) == int(4))
    {
        return;
    }
    // End:0x10F
    if((int(MPOF.m_State) == int(3)) || int(MPOF.m_State) == int(2))
    {
        I = 1;
        J0x99:

        // End:0xFA [Loop If]
        if(I < m_ObjectiveFLAGList.Length)
        {
            MPOF = m_ObjectiveFLAGList[I];
            // End:0xF0
            if((int(MPOF.m_State) != int(3)) && int(MPOF.m_State) != int(2))
            {
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x99;
        }
        ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 1;
    }
    // End:0x1C0
    if((int(MPOF.m_State) == int(6)) || int(MPOF.m_State) == int(5))
    {
        I = 1;
        J0x14A:

        // End:0x1AB [Loop If]
        if(I < m_ObjectiveFLAGList.Length)
        {
            MPOF = m_ObjectiveFLAGList[I];
            // End:0x1A1
            if((int(MPOF.m_State) != int(6)) && int(MPOF.m_State) != int(5))
            {
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x14A;
        }
        ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 0;
    }
    EndGame(none, "ObjectivesComplete");
    //return;    
}

function TriggerWin(int winningTeam)
{
    ObjectiveGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = winningTeam;
    EndGame(none, "ObjectivesComplete");
    //return;    
}

function ScoreObjectiveFlagPoints(int Points, Controller CreditedActivater)
{
    AddObjectivePoints(CreditedActivater, Points);
    //return;    
}

function ScoreTeamFlagPoints(int Points, Controller CreditedActivater)
{
    AddTeamPoints(CreditedActivater, Points);
    //return;    
}

function ScoreKillObjectiveCompletePoints(int Points, Controller ObjtiveCompleter, bool bGiveTeamPoints, array<Controller> LastKnownActivaterTeammates)
{
    local int I;

    // End:0x0D
    if(ObjtiveCompleter == none)
    {
        return;
    }
    // End:0x53
    if(bGiveTeamPoints)
    {
        I = 0;
        J0x1D:

        // End:0x53 [Loop If]
        if(I < LastKnownActivaterTeammates.Length)
        {
            AddTeamPoints(LastKnownActivaterTeammates[I], int(TeamPointsForObjectiveAssist));
            I++;
            // [Loop Continue]
            goto J0x1D;
        }
    }
    AddObjectivePoints(ObjtiveCompleter, Points);
    //return;    
}

function Reset()
{
    bCheckIfTeamEliminated = false;
    super.Reset();
    //return;    
}

function ResetScore()
{
    //return;    
}

function AddTeamPointsForKill(int TeamIndex)
{
    //return;    
}

function RemoveTeamPointsForSuicide(int TeamIndex)
{
    //return;    
}

state RoundOver
{
    function bool CanRespawn(MOHAPlayerController C)
    {
        return false;
        //return ReturnValue;        
    }

    function RestartRound()
    {
        local Controller P;
        local MPObjective O;
        local MPObjective_FLAG MPOF;

        // End:0x56
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            MOHAPlayerReplicationInfo(P.PlayerReplicationInfo).m_bHasSwitchedTeams = false;
            P.PlayerReplicationInfo.bOutOfLives = false;            
        }        
        // End:0x7B
        foreach DynamicActors(Class'MPObjective', O)
        {
            O.ResetToDefualtState();            
        }        
        // End:0xA0
        foreach DynamicActors(Class'MPObjective_FLAG', MPOF)
        {
            MPOF.ResetToDefaultState();            
        }        
        super.RestartRound();
        //return;        
    }
    stop;    
}

defaultproperties
{
    SwitchTeamsTimeLimit=30.0000000
    ObjectiveCompleteDist=2000.0000000
    TeamPointsForObjectiveAssist=1.0000000
    HUDType=Class'HUDObjective'
    TimeLimit=10
    GameReplicationInfoClass=Class'ObjectiveGameReplicationInfo'
}