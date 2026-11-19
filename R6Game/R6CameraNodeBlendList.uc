class R6CameraNodeBlendList extends R6CameraNodeBlendBase
    abstract
    native
    hidecategories(Object,Object,Object);

var() SInterpParams m_InterpParams;
var() bool m_bUseInterpParams;
var() bool m_bCannotChangeChildWhileBlending;
var int m_iActiveChild;
var float m_fBlendTimeToGo;
var float m_fBlendTimeTotal;
var array<float> m_aChildPrevWeights;

defaultproperties
{
    m_InterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
    m_iActiveChild=-1
    m_DebugIcon=Texture2D'EngineResources.AnimBlendListIcon'
}