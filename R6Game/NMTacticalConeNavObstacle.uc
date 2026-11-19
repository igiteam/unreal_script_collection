class NMTacticalConeNavObstacle extends Actor
    native
    notplaceable
    hidecategories(lighting);

var int m_iTeamId;
var int m_iMemberId;
var Vector m_aCachedConeTip;
var Vector m_aCachedConeTopLeft;
var Vector m_aCachedConeTopRight;
var array<ConvexShape> m_aConvexShape;

defaultproperties
{
    m_iTeamId=-1
    m_iMemberId=-1
    TickGroup=1
}