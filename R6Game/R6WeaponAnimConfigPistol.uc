class R6WeaponAnimConfigPistol extends R6WeaponAnimConfig
    abstract
    native;

var name m_FPReloadWithShieldEmptyDown;
var name m_FPReloadWithShieldTacticalDown;
var name m_FPReloadWithShieldEmptyUp;
var name m_FPReloadWithShieldTacticalUp;
var name m_FPShieldDownReadyAdd;
var name m_FPShieldDownAimAdd;
var name m_FPShieldDownZoomAdd;
var name m_FPShieldUpReadyAdd;
var name m_FPShieldUpAimAdd;
var name m_FPShieldUpTrans;
var name m_FPShieldDownTrans;
var name m_WFPReloadWithShieldUpAnim;
var name m_WFPReloadWithShieldDownAnim;
var name m_WTPReloadWithShieldAnim;
var bool m_bPlayReloadEmptyWithShield;
var bool m_bNeedsAllAdditivesWithShield;

defaultproperties
{
    m_FPReloadWithShieldEmptyDown="FPReloadShieldDownEmpty"
    m_FPReloadWithShieldTacticalDown="FPReloadShieldDownTactical"
    m_FPReloadWithShieldEmptyUp="FPReloadShieldUpEmpty"
    m_FPReloadWithShieldTacticalUp="FPReloadShieldUpTactical"
    m_FPShieldUpTrans="FPStanceShieldDownAimToShieldUpAim"
    m_FPShieldDownTrans="FPStanceShieldUpAimToShieldDownAim"
    m_bPlayReloadEmptyWithShield=true
    m_FPReloadTacticAnim="FPReloadPistolTactical"
    m_FPReloadEmptyAnim="FPReloadPistolEmpty"
    m_TPReloadTacticAnim="ReadyReloadPistol"
    m_TPReloadEmptyAnim="ReadyReloadPistol"
    m_FPStanceAimAnim="FPStancePistolAim"
    m_FPStanceReadyAnim="FPStancePistolReady"
    m_FPStanceZoomAnim="FPStancePistolZoom"
    m_FPStanceAimAddAnim="FPStancePistolAimAdditive"
    m_FPStanceReadyAddAnim="FPStancePistolReadyAdditive"
    m_FPStanceZoomAddAnim="FPStancePistolZoomAdditive"
    m_FPBreathAnim="FPIdlePistolBreathing"
    m_FPFastBreathAnim="FPIdlePistolFastBreathing"
    m_FPWalkAddAnim="FPSlowWalkPistolAim"
    m_FPWalkZoomAddAnim="FPSlowWalkPistolZoom"
    m_FPFastWalkAddAnim="FPWalkPistolAim"
    m_FPFastWalkZoomAddAnim="FPWalkPistolZoom"
    m_FPJogAddAnim="FPJogPistolAim"
    m_FPJogZoomAddAnim="FPJogPistolZoom"
    m_FPDrawAnim="FPDrawPistol"
    m_FPHolsterAnim="FPHolsterPistol"
    m_FPPickupAnim="FPDrawPistol"
    m_FPNormalSingleMinRec="FPFireSinglePistolMinRec"
    m_FPNormalSingleMedRec="FPFireSinglePistolMedRec"
    m_FPNormalSingleMaxRec="FPFireSinglePistolMaxRec"
    m_FPNormalBurstCycleMinRec="FPFireBurstPistolCycleMinRec"
    m_FPNormalBurstEndMinRec="FPFireBurstPistolEndMinRec"
    m_FPZoomSingleMinRec="FPZoomFireSinglePistolMinRec"
    m_FPZoomSingleMedRec="FPZoomFireSinglePistolMedRec"
    m_FPZoomSingleMaxRec="FPZoomFireSinglePistolMaxRec"
    m_FPZoomBurstCycleMinRec="FPZoomFireBurstPistolCycleMinRec"
    m_FPZoomBurstEndMinRec="FPZoomFireBurstPistolEndMinRec"
    m_TPSuppressorAnim="ReadySuppressorPistolOn"
    m_TCSuppressorAnim="ReadySuppressorPistolOn"
    m_FPZoomIn="FPZoomInPistol"
    m_FPZoomOut="FPZoomOutPistol"
    m_TPLeftIKHoldSocketName="R65_IKM_LH_Hold_TP"
}