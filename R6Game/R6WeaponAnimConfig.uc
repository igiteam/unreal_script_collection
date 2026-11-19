class R6WeaponAnimConfig extends Object
    abstract
    native;

var name m_FPReloadTacticAnim;
var name m_FPReloadEmptyAnim;
var name m_FPReloadEmptyScopeAnim;
var name m_FPStartChamberReloadAnim;
var name m_FPChamberReloadAnim;
var name m_FPEndChamberReloadTacticalAnim;
var name m_FPEndChamberReloadEmptyAnim;
var name m_TPReloadTacticAnim;
var name m_TPReloadEmptyAnim;
var name m_TPStartChamberReloadAnim;
var name m_TPChamberReloadAnim;
var name m_TPEndChamberReloadTacticalAnim;
var name m_TPEndChamberReloadEmptyAnim;
var name m_TurretReloadTacticAnim;
var name m_TurretReloadEmptyAnim;
var name m_WFPReloadTacticAnim;
var name m_WFPReloadEmptyAnim;
var name m_WFPStartChamberReloadAnim;
var name m_WFPChamberReloadAnim;
var name m_WFPEndChamberReloadEmptyAnim;
var name m_WFPEndChamberReloadTacticalAnim;
var name m_WTPReloadTacticAnim;
var name m_WTPReloadEmptyAnim;
var name m_WTPStartChamberReloadAnim;
var name m_WTPChamberReloadAnim;
var name m_WTPEndChamberReloadEmptyAnim;
var name m_WTPEndChamberReloadTacticalAnim;
var bool m_bUseSpecialTPReload;
var bool m_bShootingDontNeedAdditiveStance;
var bool m_bReverseSocketsFiringFP;
var bool m_bReverseSocketsFiringTP;
var bool m_bHideStock;
var name m_FPStanceAimAnim;
var name m_FPStanceReadyAnim;
var name m_FPStanceZoomAnim;
var name m_FPStanceAimAddAnim;
var name m_FPStanceReadyAddAnim;
var name m_FPStanceZoomAddAnim;
var name m_FPStanceAimPistolOverrideAddAnim;
var name m_FPStanceReadyPistolOverrideAddAnim;
var name m_FPStanceZoomPistolOverrideAddAnim;
var name m_FPBreathAnim;
var name m_FPFastBreathAnim;
var name m_FPBreathPauseAnim;
var name m_FPFastBreathPauseAnim;
var name m_FPWalkAddAnim;
var name m_FPWalkZoomAddAnim;
var name m_FPFastWalkAddAnim;
var name m_FPFastWalkZoomAddAnim;
var name m_FPJogAddAnim;
var name m_FPJogZoomAddAnim;
var name m_FPDrawAnim;
var name m_FPHolsterAnim;
var name m_FPThrowAnim;
var name m_FPPickupAnim;
var name m_FPNormalSingleMinRec;
var name m_FPNormalSingleMedRec;
var name m_FPNormalSingleMaxRec;
var name m_FPNormalBurstCycleMinRec;
var name m_FPNormalBurstCycleMedRec;
var name m_FPNormalBurstCycleMaxRec;
var name m_FPNormalBurstEndMinRec;
var name m_FPNormalBurstEndMedRec;
var name m_FPNormalBurstEndMaxRec;
var name m_FPZoomSingleMinRec;
var name m_FPZoomSingleMedRec;
var name m_FPZoomSingleMaxRec;
var name m_FPZoomBurstCycleMinRec;
var name m_FPZoomBurstCycleMedRec;
var name m_FPZoomBurstCycleMaxRec;
var name m_FPZoomBurstEndMinRec;
var name m_FPZoomBurstEndMedRec;
var name m_FPZoomBurstEndMaxRec;
var name m_FPSuppressorAnim;
var name m_FPUnSuppressorAnim;
var name m_TPSuppressorAnim;
var name m_TCSuppressorAnim;
var name m_WFPSuppressorAnim;
var name m_WFPUnSuppressorAnim;
var name m_WTPSuppressorAnim;
var name m_FPZoomIn;
var name m_FPZoomOut;
var name m_WIdleAnim;
var name m_WIdleEmptyAnim;
var name m_WFPFireSingleZoomAnim;
var name m_WFPFireSingleAnim;
var name m_WTPFireSingleAnim;
var name m_WFPFireLastAnim;
var name m_WTPFireLastAnim;
var name m_WFPFireBurstAnim;
var name m_WTPFireBurstAnim;
var name m_WMagReloadAnim;
var name m_WMagStanceAnim;
var name m_WMagFireAnim;
var R6GameEnums.EHandPoseType m_eWeaponHoldType;
var R6GameEnums.EHandPoseType m_eMagHoldType;
var name m_FPLeftIKHoldSocketName;
var name m_TPLeftIKHoldSocketName;

defaultproperties
{
    m_FPBreathAnim="FPIdleBreathing"
    m_FPFastBreathAnim="FPIdleFastBreathing"
    m_FPBreathPauseAnim="FPIdleBreathingPause"
    m_FPFastBreathPauseAnim="FPIdleFastBreathingPause"
    m_FPWalkAddAnim="FPSlowWalkAim"
    m_FPWalkZoomAddAnim="FPSlowWalkZoom"
    m_FPFastWalkAddAnim="FPWalkAim"
    m_FPFastWalkZoomAddAnim="FPWalkZoom"
    m_FPJogAddAnim="FPJogAim"
    m_FPJogZoomAddAnim="FPJogZoom"
    m_FPThrowAnim="FPDropWeapon"
    m_FPPickupAnim="FPPickup"
    m_FPLeftIKHoldSocketName="R65_IKM_LH_Hold"
    m_TPLeftIKHoldSocketName="R65_IKM_LH_Hold"
}