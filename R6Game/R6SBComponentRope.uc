class R6SBComponentRope extends R6SBComponent
    native
    editinlinenew
    hidecategories(Object);

var(SBRope) float m_fLength;
var(SBRope) float m_fRadius;
var(SBRope) float m_fScaleU;
var(SBRope) float m_fScaleV;
var(SBRope) int m_iNbSeg;
var(SBRope) int m_iNbSide;
var transient int m_iHitVertex1;
var transient int m_iHitVertex2;

defaultproperties
{
    m_fLength=10.0000000
    m_fRadius=0.7500000
    m_fScaleU=1.0000000
    m_fScaleV=1.0000000
    m_iNbSeg=10
    m_iNbSide=5
    m_iHitVertex1=-1
    m_iHitVertex2=-1
}