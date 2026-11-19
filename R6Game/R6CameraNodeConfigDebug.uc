class R6CameraNodeConfigDebug extends R6CameraNodeConfig
    native
    hidecategories(Object,Object,Object);

var() R6GameEnums.EDebugCameraModes m_eType;

defaultproperties
{
    m_ModeClass=Class'R6DebugCameraMode'
}