class R6WeaponAnimConfigShotgun extends R6WeaponAnimConfigSMG
    abstract;

defaultproperties
{
    m_FPStartChamberReloadAnim="FPReloadShotgunBegin"
    m_FPChamberReloadAnim="FPReloadShotgunCycle"
    m_FPEndChamberReloadTacticalAnim="FPReloadShotgunEndTactical"
    m_FPEndChamberReloadEmptyAnim="FPReloadShotgunEndEmpty"
    m_TPStartChamberReloadAnim="ReadyReloadShotgunBegin"
    m_TPChamberReloadAnim="ReadyReloadShotgunCycle"
    m_TPEndChamberReloadTacticalAnim="ReadyReloadShotgunEnd"
    m_TPEndChamberReloadEmptyAnim="ReadyReloadShotgunEnd"
    m_WTPStartChamberReloadAnim="ReadyReloadShotgunEmptyBegin"
    m_WTPChamberReloadAnim="ReadyReloadShotgunTacticalCycle"
    m_bShootingDontNeedAdditiveStance=true
    m_FPStanceAimAddAnim="FPStanceShotgunAim"
    m_FPStanceReadyAddAnim="FPStanceShotgunReady"
    m_FPStanceZoomAddAnim="FPStanceShotgunZoom"
    m_FPNormalSingleMinRec="FPFireSingleShotgunMinRec"
    m_FPZoomSingleMinRec="FPZoomFireSingleShotgunMinRec"
}