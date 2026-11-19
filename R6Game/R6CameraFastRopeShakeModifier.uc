class R6CameraFastRopeShakeModifier extends R6CameraModifier
    native;

var float m_iShakePitchModifier;
var float m_iShakeYawModifier;
var float m_iShakeRollModifier;
var Vector m_vShakeLocationModifier;
var float m_fPitchShakeOffset;
var float m_fYawShakeOffset;
var float m_fRollShakeOffset;
var float m_fLocXShakeOffset;
var float m_fLocYShakeOffset;
var float m_fLocZShakeOffset;

// Export UR6CameraFastRopeShakeModifier::execResetNoiseParams(FFrame&, void* const)
native function ResetNoiseParams();

function Init()
{
    Init();
    ResetNoiseParams();
    return;
}
