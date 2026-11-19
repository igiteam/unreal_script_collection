class R6SkelControlTalk extends SkelControlBase
    native
    hidecategories(Object,Object);

var() float m_fOpenMin;
var() float m_fOpenMax;
var() float m_fClosedMin;
var() float m_fClosedMax;
var() float m_fAmplitudeMax;
var float m_fBarkMouthTimer;
var bool m_bBarkMouthOpen;
var int m_iRotation;

defaultproperties
{
    m_fOpenMin=0.1500000
    m_fOpenMax=0.3000000
    m_fClosedMin=0.0500000
    m_fClosedMax=0.2000000
    m_fAmplitudeMax=500.0000000
}