class R6SkelControlRollBones extends SkelControlBase
    native
    hidecategories(Object);

enum eSide
{
    RBSIDE_Left,                    // 0
    RBSIDE_Right,                   // 1
    RBSIDE_MAX                      // 2
};

enum EBasisAxis
{
    BASISAXIS_XYZ,                  // 0
    BASISAXIS_XZY,                  // 1
    BASISAXIS_MAX                   // 2
};

struct Basis
{
    var() R6SkelControlRollBones.EBasisAxis m_eBasis;
    var() bool m_bInverseUp;

    structdefaultproperties
    {
        m_eBasis=0
        m_bInverseUp=false
    }
};

var() /*0x08000000-0x00000000*/ name m_SourceBone;
var() R6SkelControlRollBones.eSide m_Side;
var() Basis m_Basis;
var() Basis m_SourceBasis;

defaultproperties
{
    m_Basis=(m_eBasis=1,m_bInverseUp=false)
    m_bEvaluateSecondPass=true
    m_iDisableLOD=2
}