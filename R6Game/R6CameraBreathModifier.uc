class R6CameraBreathModifier extends R6CameraModifier
    native;

var float m_fShakePitchModifier;
var float m_fShakeYawModifier;
var float m_fSpeed;
var float m_fYawRange;
var float m_fPitchRange;
var int m_iYawOffset;

defaultproperties
{
    bDisabled=true
}