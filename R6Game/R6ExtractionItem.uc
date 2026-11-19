class R6ExtractionItem extends R6CarriedObject
    abstract
    native
    hidecategories(lighting);

var() R6GameEnums.ETEAMIDENTITY m_eAllowedTeam;

simulated function byte GetTeamNum()
{
    return m_eAllowedTeam;
    return;
}

defaultproperties
{
    m_eAllowedTeam=2
}