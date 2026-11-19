class SPSquadSelectorBadGuys extends SPSquadSelector
    editinlinenew
    collapsecategories;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() SPTeamInfoBadGuy.eSPSquad_BadGuy SquadAssignment;

event int GetSelectedSquadIdx()
{
    local int squadIdx;

    squadIdx = int(SquadAssignment);
    return squadIdx;
    //return ReturnValue;    
}

event bool IsAssociatedWithTeam(SPTeamInfo Team)
{
    local SPTeamInfoBadGuy associatedTeam;

    associatedTeam = SPTeamInfoBadGuy(Team);
    // End:0x1D
    if(associatedTeam != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}
