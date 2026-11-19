class R6PostProcessManager extends PostProcessManager
    transient
    native;

var bool m_bEnable;
var float m_fVisionParameter1;
var float m_fVisionParameter2;
var R6PostProcessParam m_Final;
var int m_iRetinaImprintSizeX;
var int m_iRetinaImprintSizeY;
var int m_iMotionBlurViewportCount;
var native const Pointer m_MotionBlurPrePassRenderTarget;
var native const Pointer m_RetinaImprint;

defaultproperties
{
    m_bEnable=true
    // Reference: R6PostProcessParam'Default__R6PostProcessManager.R6PostProcessParam0'
    begin object name="R6PostProcessParam0" class=Class'R6PostProcessParam'
    end object
    m_Final=R6PostProcessParam0
}