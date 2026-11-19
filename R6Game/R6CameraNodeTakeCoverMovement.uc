class R6CameraNodeTakeCoverMovement extends R6CameraNodeBlendBase
    native
    hidecategories(Object,Object,Object);

enum ETakeCoverCamMove
{
    TCCAMMOVE_Left,                 // 0
    TCCAMMOVE_Idle,                 // 1
    TCCAMMOVE_Right,                // 2
    TCCAMMOVE_MAX                   // 3
};

var() float m_fInterpSpeed;
var transient float m_fPosition;

defaultproperties
{
    m_fInterpSpeed=0.5000000
    m_aChildren[0]=(m_Name="MoveLeft",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Idle",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="MoveRight",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}