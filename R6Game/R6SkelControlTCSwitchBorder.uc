class R6SkelControlTCSwitchBorder extends SkelControlBase
    native
    hidecategories(Object);

var transient int m_iNeck;
var transient int m_iSpine1;
var transient int m_iSpine2;
var transient int m_iNeckTarget;
var transient int m_iSpine1Target;
var transient int m_iSpine2Target;
var(BoneNeck) /*0x20000000-0x00000000*/ int m_iNeckTurn;
var(BoneNeck) /*0x20000000-0x00000000*/ int m_iNeckStartDecrease;
var(BoneSpine2) /*0x20000000-0x00000000*/ int m_iSpine2Start;
var(BoneSpine2) /*0x20000000-0x00000000*/ int m_iSpine2Turn;
var(BoneSpine2) /*0x20000000-0x00000000*/ int m_iSpine2StartDecrease;
var(BoneSpine1) /*0x20000000-0x00000000*/ int m_iSpine1Start;
var(BoneSpine1) /*0x20000000-0x00000000*/ int m_iSpine1Turn;
var(BoneSpine1) /*0x20000000-0x00000000*/ int m_iSpine1StartDecrease;
var() /*0x20000000-0x00000000*/ int m_iRotationRate;

defaultproperties
{
    m_iNeckTurn=4192
    m_iNeckStartDecrease=5000
    m_iSpine2Start=15500
    m_iSpine2Turn=4192
    m_iSpine2StartDecrease=5000
    m_iSpine1Start=12500
    m_iSpine1Turn=2192
    m_iSpine1StartDecrease=5000
    m_iRotationRate=65000
    bActive=false
}