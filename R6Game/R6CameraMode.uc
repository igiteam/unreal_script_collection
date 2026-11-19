class R6CameraMode extends CameraMode
    native;

var R6Camera m_R6Camera;
var R6CameraModeConfig m_CameraModeConfig;
var R6GameEnums.ECameraMode m_eCamModeConfigIndex;
var float m_fLastSpringPos;
var float m_fSpringVel;
var int m_iLastUpdate;
var SR6CameraCache m_CameraModeCache;

event Init(R6Camera OwnerCam, R6CameraModeConfig pConfig)
{
    m_R6Camera = OwnerCam;
    m_CameraModeConfig = pConfig;
    return;
}

event SetCameraModeConfig(R6CameraModeConfig pConfig)
{
    m_CameraModeConfig = pConfig;
    return;
}
