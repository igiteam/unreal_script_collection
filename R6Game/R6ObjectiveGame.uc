class R6ObjectiveGame extends R6CooperativeGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

function ScoreKill(Controller Killer, Controller other)
{
    local Pawn pVictimPawn, pKillerPawn;

    // End:0xF2
    if((((Killer != none) && Killer.bIsPlayer) && other != none) && !other.bIsPlayer)
    {
        pKillerPawn = Killer.Pawn;
        pVictimPawn = other.Pawn;
        // End:0xF2
        if((pKillerPawn != none) && pVictimPawn != none)
        {
            // End:0xF2
            if(int(R6Pawn(pVictimPawn).CheckAlliance(R6Pawn(pKillerPawn))) == int(2))
            {
                // End:0xF2
                if(Killer.PlayerReplicationInfo != none)
                {
                    Killer.PlayerReplicationInfo.Kills++;
                    ModifyPlayerScore(Killer.PlayerReplicationInfo, 1.0000000);
                }
            }
        }
    }
    // End:0x155
    if((other != none) && other.bIsPlayer)
    {
        // End:0x155
        if((Killer != none) && !Killer.bIsPlayer)
        {
            // End:0x155
            if(!bGameEnded)
            {
                EndGame(none, "missionaborted");
            }
        }
    }
    CheckLives(none);
    return;
}

function RestartPlayer(Controller NewPlayer, optional Pawn ForcedPawn)
{
    RestartPlayer(NewPlayer, ForcedPawn);
    // End:0x37
    if(NewPlayer.Pawn != none)
    {
        SendObjective(PlayerController(NewPlayer));
    }
    return;
}

function OnObjectiveRegistered(R6Objective pObjective)
{
    BroadcastObjective();
    return;
}

function OnObjectiveFailed(R6Objective pObjective)
{
    // End:0x23
    if(!bGameEnded)
    {
        EndGame(none, "missionaborted");
    }
    return;
}

function OnObjectiveSucceeded(R6Objective pObjective)
{
    // End:0x25
    if(!bGameEnded)
    {
        EndGame(none, "missioncompleted");
    }
    return;
}

function BroadcastObjective()
{
    local R6Objective pFirstObjective;

    // End:0x22
    if(m_ObjectiveManager != none)
    {
        pFirstObjective = m_ObjectiveManager.GetObjective(0);
    }
    // End:0x42
    if(pFirstObjective != none)
    {
        BroadcastGameMessage(GameMessageClass, 43, none, none, pFirstObjective);
    }
    return;
}

function SendObjective(PlayerController pPlayer)
{
    local R6Objective pFirstObjective;

    // End:0x22
    if(m_ObjectiveManager != none)
    {
        pFirstObjective = m_ObjectiveManager.GetObjective(0);
    }
    // End:0x47
    if(pFirstObjective != none)
    {
        SendGameMessage(GameMessageClass, pPlayer, 43, none, none, pFirstObjective);
    }
    return;
}

state s_MatchInProgress
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        BroadcastObjective();
        return;
    }
    stop;
}

defaultproperties
{
    m_iTimeBetweenRound=10
    GameDescription="COMPLETE OBJECTIVE"
    GameName="OBJECTIVE"
}