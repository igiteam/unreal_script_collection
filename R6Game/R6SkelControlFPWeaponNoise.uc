class R6SkelControlFPWeaponNoise extends SkelControlBase
    native
    hidecategories(Object);

var(Breath) bool m_bUseNonLinearInterp;
var(SlowBreath) float m_fMinSlowBreathAmplitude;
var(SlowBreath) float m_fMaxSlowBreathAmplitude;
var(SlowBreath) float m_fMinSlowBreathHalfCycleTime;
var(SlowBreath) float m_fMaxSlowBreathHalfCycleTime;
var(FastBreath) float m_fMinFastBreathAmplitude;
var(FastBreath) float m_fMaxFastBreathAmplitude;
var(FastBreath) float m_fMinFastBreathHalfCycleTime;
var(FastBreath) float m_fMaxFastBreathHalfCycleTime;
var(ZoomSlowBreath) float m_fMinZoomSlowBreathAmplitude;
var(ZoomSlowBreath) float m_fMaxZoomSlowBreathAmplitude;
var(ZoomSlowBreath) float m_fMinZoomSlowBreathHalfCycleTime;
var(ZoomSlowBreath) float m_fMaxZoomSlowBreathHalfCycleTime;
var(ZoomFastBreath) float m_fMinZoomFastBreathAmplitude;
var(ZoomFastBreath) float m_fMaxZoomFastBreathAmplitude;
var(ZoomFastBreath) float m_fMinZoomFastBreathHalfCycleTime;
var(ZoomFastBreath) float m_fMaxZoomFastBreathHalfCycleTime;
var float m_fHalfCycleTime;
var float m_fCurrentTime;
var Vector m_vTargetOffset;
var Vector m_vCurrentOffset;

defaultproperties
{
    m_bUseNonLinearInterp=true
    m_fMinSlowBreathAmplitude=0.0900000
    m_fMaxSlowBreathAmplitude=0.1500000
    m_fMinSlowBreathHalfCycleTime=1.0000000
    m_fMaxSlowBreathHalfCycleTime=1.5000000
    m_fMinFastBreathAmplitude=0.1300000
    m_fMaxFastBreathAmplitude=0.2000000
    m_fMinFastBreathHalfCycleTime=0.8000000
    m_fMaxFastBreathHalfCycleTime=1.2000000
    m_fMinZoomSlowBreathAmplitude=0.0300000
    m_fMaxZoomSlowBreathAmplitude=0.0500000
    m_fMinZoomSlowBreathHalfCycleTime=1.0000000
    m_fMaxZoomSlowBreathHalfCycleTime=1.5000000
    m_fMinZoomFastBreathAmplitude=0.0500000
    m_fMaxZoomFastBreathAmplitude=0.0800000
    m_fMinZoomFastBreathHalfCycleTime=0.5000000
    m_fMaxZoomFastBreathHalfCycleTime=1.0000000
    BlendInTime=0.1500000
    BlendOutTime=0.1500000
    bActive=false
}