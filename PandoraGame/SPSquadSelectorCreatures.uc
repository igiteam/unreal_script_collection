class SPSquadSelectorCreatures extends SPSquadSelector
    editinlinenew
    collapsecategories;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;

event int GetSelectedSquadIdx()
{
    local int squadIdx;

    squadIdx = int(SquadAssignment);
    return squadIdx;
    //return ReturnValue;    
}

event bool IsAssociatedWithTeam(SPTeamInfo Team)
{
    local SPTeamInfoCreature associatedTeam;

    associatedTeam = SPTeamInfoCreature(Team);
    // End:0x1D
    if(associatedTeam != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}
