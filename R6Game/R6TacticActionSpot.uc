class R6TacticActionSpot extends R6TacticCombat
    native;

struct sActionSpotMemberInfo
{
    var R6Pawn m_pActionSpotMember;
    var bool m_bIsInActionSpotLocation;
    var Vector m_vActionSpotLocation;

    structdefaultproperties
    {
        m_pActionSpotMember=none
        m_bIsInActionSpotLocation=false
        m_vActionSpotLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var array<sActionSpotMemberInfo> m_aActionSpotMemberInfo;

defaultproperties
{
    m_eType=30
    m_bIsInternalTactic=true
}