class SPSquadSelectorCivilians extends SPSquadSelector
    editinlinenew
    collapsecategories;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() SPTeamInfoCivilian.eSPSquad_Civilian SquadAssignment;

event int GetSelectedSquadIdx()
{
    local int squadIdx;

    squadIdx = int(SquadAssignment);
    return squadIdx;
    //return ReturnValue;    
}

event bool IsAssociatedWithTeam(SPTeamInfo Team)
{
    local SPTeamInfoCivilian associatedTeam;

    associatedTeam = SPTeamInfoCivilian(Team);
    // End:0x1D
    if(associatedTeam != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}
