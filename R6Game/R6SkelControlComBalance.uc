class R6SkelControlComBalance extends SkelControlBase
    native
    hidecategories(Object);

var transient Vector m_HipsBalanceOffset;
var transient Vector m_TargetHipsBalanceOffset;
var transient Quat m_HipsBalanceRotation;
var transient Quat m_TargetHipsBalanceRotation;
var transient Vector m_PoseCOM;
var transient Vector m_PoseCOMHighBody;
var(BalanceCorrection) float m_BalanceScale;
var(BalanceCorrection) float m_HipsTranslationToRotationCoeff;
var(BalanceCorrection) float m_DistToTargetPercentReduction;
var(BalanceCorrection) float m_MaxCorrectionDelta;
var(BalanceCorrection) float m_MaxLegExtend;
var(BalanceCorrection) float m_fMaxTranslationSquared;
var(BalanceCorrection) float m_fTakeCoverModifier;
var(BalanceCorrection) float m_fGlobalModifier;
var(HandsMass) bool m_HandsMassOnReferencePose;
var(SpineMass) bool m_SpineMassOnReferencePose;
var(HandsMass) float m_MassOnRightHand;
var(HandsMass) float m_MassOnLeftHand;
var(SpineMass) float m_SpineMass;
var(SpineMass) Vector m_SpineMassLocalPosition;
var array<BoneAtom> m_RefPoseGlobal;

defaultproperties
{
    m_BalanceScale=1.0000000
    m_DistToTargetPercentReduction=0.9800000
    m_MaxCorrectionDelta=1000.0000000
    m_MaxLegExtend=100.0000000
    m_fMaxTranslationSquared=900.0000000
    m_fTakeCoverModifier=0.3333333
    m_fGlobalModifier=0.4000000
    m_HandsMassOnReferencePose=true
    m_MassOnRightHand=40.0000000
    m_SpineMassLocalPosition=(X=0.0000000,Y=5.0000000,Z=0.0000000)
    m_iDisableLOD=2
}