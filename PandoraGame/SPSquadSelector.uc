class SPSquadSelector extends Object
    abstract
    native
    editinlinenew
    collapsecategories;

var class<SPTeamInfo> m_associatedTeamInfoClass;

event int GetSelectedSquadIdx()
{
    return -1;
    //return ReturnValue;    
}

event bool IsAssociatedWithTeam(SPTeamInfo Team)
{
    return false;
    //return ReturnValue;    
}
