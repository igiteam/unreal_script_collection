class R6CameraNodeConfig extends R6CameraNode
    native
    hidecategories(Object,Object);

var class<R6CameraMode> m_ModeClass;
var R6CameraMode m_pCameraMode;
var() R6CameraModeConfig m_pConfig;

defaultproperties
{
    m_ModeClass=Class'R6CameraMode'
}