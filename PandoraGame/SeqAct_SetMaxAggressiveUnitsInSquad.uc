class SeqAct_SetMaxAggressiveUnitsInSquad extends SequenceAction
    native;

/** Type of squad to select name from */
var() export editinline SPSquadSelector SquadType;
var() int MaxAggressiveUnits;
var() bool bUseGameplayDataDefaultValue;

function bool ScriptActivated()
{
    local int Idx;
    local SPTeamInfo SPTeamInfo;
    local name squadName;
    local PandoraGameInfo spGameInfo;

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
    Idx = 0;
    J0x3C:

    // End:0xF6 [Loop If]
    if(Idx < spGameInfo.m_teams.Length)
    {
        SPTeamInfo = spGameInfo.m_teams[Idx];
        // End:0xEC
        if((SPTeamInfo != none) && SquadType.IsAssociatedWithTeam(SPTeamInfo))
        {
            squadName = SPTeamInfo.GetPreDefinedSquadName(SquadType.GetSelectedSquadIdx());
            SPTeamInfo.IssueMaxAggressiveUnitsInSquad(squadName, MaxAggressiveUnits, bUseGameplayDataDefaultValue);
        }
        Idx++;
        // [Loop Continue]
        goto J0x3C;
    }
    return true;
    //return ReturnValue;    
}
