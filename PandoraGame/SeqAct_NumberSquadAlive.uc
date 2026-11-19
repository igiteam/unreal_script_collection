class SeqAct_NumberSquadAlive extends SequenceAction
    native;

/** Type of squad to select name from */
var() export editinline SPSquadSelector SquadType;
var int NumberAliveMembers;

function bool ScriptActivated()
{
    local int Idx;
    local SPTeamInfo SPTeamInfo;
    local name squadName;
    local PandoraGameInfo spGameInfo;
    local SPSquad SPSquad;
    local int Count;

    // End:0x0D
    if(SquadType == none)
    {
        return true;
    }
    spGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    // End:0x35
    if(spGameInfo == none)
    {
        return true;
    }
    Count = 0;
    Idx = 0;
    J0x43:

    // End:0x120 [Loop If]
    if(Idx < spGameInfo.m_teams.Length)
    {
        SPTeamInfo = spGameInfo.m_teams[Idx];
        // End:0x116
        if((SPTeamInfo != none) && SquadType.IsAssociatedWithTeam(SPTeamInfo))
        {
            squadName = SPTeamInfo.GetPreDefinedSquadName(SquadType.GetSelectedSquadIdx());
            SPSquad = SPTeamInfo.GetSquadByName(squadName);
            // End:0x116
            if(SPSquad != none)
            {
                Count += SPSquad.NumMembers();
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x43;
    }
    NumberAliveMembers = Count;
    return true;
    //return ReturnValue;    
}
