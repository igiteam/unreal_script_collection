class SPSquadSelectorAllies extends SPSquadSelector
    editinlinenew
    collapsecategories;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() SPTeamInfoAlly.eSPSquad_Allies SquadAssignment;

event int GetSelectedSquadIdx()
{
    local int squadIdx;

    squadIdx = int(SquadAssignment);
    return squadIdx;
    //return ReturnValue;    
}

event bool IsAssociatedWithTeam(SPTeamInfo Team)
{
    local SPTeamInfoAlly associatedTeam;

    associatedTeam = SPTeamInfoAlly(Team);
    // End:0x1D
    if(associatedTeam != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}
