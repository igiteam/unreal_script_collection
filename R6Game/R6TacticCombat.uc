class R6TacticCombat extends R6Tactic
    native;

var bool m_bIsClipEmpty;
var bool m_bIsBagEmpty;
var bool m_bIsReloadingWeapon;
var bool m_bIsSwitchingWeapon;
var bool m_bIsWeaponInHolster;
var bool m_bIsFixedWeaponAvailable;
var bool m_bIsUsingFixedWeapon;
var bool m_bIsWeaponInTransition;
var bool m_bIsWeaponReadyToFire;
var bool m_bIsPawnMoving;
var bool m_bIsPawnInCoverPrep;
var bool m_bShouldRequestAction;
var bool m_bIsTargetVisible;
var bool m_bIsTargetTooFar;
var bool m_bIsTargetTooClose;
var R6Turret m_pBestAvailableTurret;

defaultproperties
{
    m_eType=8
    m_bIsInternalTactic=false
}