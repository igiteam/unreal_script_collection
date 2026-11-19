class R6CoopStoryGame extends R6CooperativeGame
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

event InitGame(string Options, out string ErrorMessage)
{
    InitGame(Options, ErrorMessage);
    m_iTimeLimitSeconds = 0;
    return;
}

event PostLogin(PlayerController NewPlayer)
{
    PostLogin(NewPlayer);
    return;
}

function CreateInitialObjectives()
{
    return;
}

function OnObjectiveSucceeded(R6Objective pObjective)
{
    return;
}

function OnObjectiveFailed(R6Objective pObjective)
{
    local R6GameReplicationInfo r6RepInfo;
    local int iOldNetVersion;

    r6RepInfo = R6GameReplicationInfo(GameReplicationInfo);
    // End:0x1D
    if(r6RepInfo == none)
    {
        return;
    }
    // End:0x2A
    if(pObjective == none)
    {
        return;
    }
    iOldNetVersion = r6RepInfo.m_MissionFailMessage.m_iNetVersion;
    pObjective.GetFailureReason(r6RepInfo.m_MissionFailMessage);
    r6RepInfo.m_MissionFailMessage.m_iNetVersion = ++iOldNetVersion;
    // End:0x9F
    if(!bGameEnded)
    {
        EndGame(none, "missionaborted");
    }
    return;
}

event bool GetMissionFailureInfo(out R6MissionFailedInfo out_FailureInfo)
{
    return true;
    return;
}

event OnMissionFailed(R6MissionFailedInfo FailureInfo)
{
    local R6GameReplicationInfo r6RepInfo;
    local int iOldNetVersion;

    r6RepInfo = R6GameReplicationInfo(GameReplicationInfo);
    // End:0x63
    if(r6RepInfo != none)
    {
        iOldNetVersion = r6RepInfo.m_MissionFailMessage.m_iNetVersion;
        r6RepInfo.m_MissionFailMessage = FailureInfo;
        r6RepInfo.m_MissionFailMessage.m_iNetVersion = ++iOldNetVersion;
    }
    // End:0x86
    if(!bGameEnded)
    {
        EndGame(none, "missionaborted");
    }
    return;
}

state s_MatchInProgress
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        GameReplicationInfo.bStopCountDown = false;
        return;
    }

    function bool TimeHasExpired()
    {
        return false;
        return;
    }
    stop;
}

defaultproperties
{
    GameDescription="SAVE LAS VEGAS FROM THE CHAOS AND DESTRUCTION ENGULFING IT"
    GameName="COOP STORY"
}