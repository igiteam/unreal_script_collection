class R6PCVisualEffect extends Object
    native;

var bool m_bActive;
var bool m_bFullStrengthReached;
var float m_fTargetStrength;
var float m_fCurrentStrength;
var float m_fSpeed;
var float m_fFullStrengthDuration;
var float m_fFadeDuration;
var float m_fCurrentTime;

// Export UR6PCVisualEffect::execUpdate(FFrame&, void* const)
native function Update(float fDeltaTime);

// Export UR6PCVisualEffect::execSetParams(FFrame&, void* const)
native function SetParams(float fTargetStrength, float fSpeed, float fFullStrengthDuration, float fFadeDuration);

// Export UR6PCVisualEffect::execStop(FFrame&, void* const)
native function Stop();
