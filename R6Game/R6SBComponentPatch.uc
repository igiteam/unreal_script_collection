class R6SBComponentPatch extends R6SBComponent
    native
    editinlinenew
    hidecategories(Object);

var(SBPatch) float m_fScaleU;
var(SBPatch) float m_fScaleV;
var(SBPatch) int m_iNbU;
var(SBPatch) int m_iNbV;
var(SBPatch) float m_fULength;
var(SBPatch) float m_fVLength;
var(SBPatch) bool m_bTopLeftFixed;
var(SBPatch) bool m_bTopRightFixed;
var(SBPatch) bool m_bBottomLeftFixed;
var(SBPatch) bool m_bBottomRightFixed;
var(SBPatch) bool m_bTopFixed;
var(SBPatch) bool m_bBottomFixed;
var(SBPatch) bool m_bLeftFixed;
var(SBPatch) bool m_bRightFixed;
var transient int m_iHitVertex[4];

defaultproperties
{
    m_fScaleU=1.0000000
    m_fScaleV=1.0000000
    m_iNbU=3
    m_iNbV=3
    m_fULength=10.0000000
    m_fVLength=10.0000000
    m_bTopFixed=true
    m_fCollRepulse=0.1000000
    m_iNbIter=3
    m_iNbNormalizeIter=2
    m_bCollSubDiv=1
}