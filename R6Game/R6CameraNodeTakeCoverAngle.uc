class R6CameraNodeTakeCoverAngle extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() array<R6EngineEnums.ETakeCoverAngle> m_Angles;
var() R6EngineEnums.ETakeCoverMode m_eTakeCoverMode;

defaultproperties
{
    m_aChildren[0]=(m_Name="None",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
}