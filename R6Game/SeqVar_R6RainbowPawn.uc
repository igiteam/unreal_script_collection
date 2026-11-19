class SeqVar_R6RainbowPawn extends SeqVar_R6Pawn
    native
    hidecategories(Object);

var() R6EngineEnums.ERainbowMembers m_eRainbowMember;
var() int m_iTeamMember;

event string GetValueName()
{
    return string(m_eRainbowMember);
    return;
}

defaultproperties
{
    m_iTeamMember=-1
    ObjName="Rainbow Team Pawn"
}