class R6WeaponsConfig extends R6Config
    native
    hidecategories(Object);

struct ScopeParams
{
    var() editconst R6EngineEnums.EZoomType m_eZoomType;
    var() float m_fFOVModifier;

    structdefaultproperties
    {
        m_eZoomType=0
        m_fFOVModifier=0.0000000
    }
};

var(Scope) float m_fTakeCoverScopeFOVModifier;
var(Scope) float m_fTakeCover12XScopeFOVModifier;
var(Scope) float m_fScopeTransitionLength;
var(Scope) float m_fScopeTcReadyModLength;
var(Scope) Texture2D m_ScopeAcogEdgeBlurTexture;
var(Scope) Vector2D m_vScopeAcogEdgeBlurOffset;
var(Scope) Vector2D m_vScopeAcogEdgeBlurScale;
var(Scope) float m_fScopeFirstPersonFOV;
var(Scope) float m_fUnZoomStartShoot;
var(Scope) float m_fUnZoomMultiplierShoot;
var(ScopeFirstPerson) float m_fRifleFrontOffset;
var(ScopeFirstPerson) float m_fRifleUpOffset;
var(ScopeFirstPerson) float m_fSniperFrontOffset;
var(ScopeFirstPerson) float m_fSniperUpOffset;
var(ScopeDOF) float m_fScopeDOFBlurKernelSize;
var(ScopeDOF) float m_fScopeDOFMaxNearBlurAmount;
var(ScopeDOF) float m_fScopeDOFMaxFarBlurAmount;
var(ScopeDOF) Color m_ScopeDOFModulateBlurColor;
var(ScopeDOF) float m_fScopeDOFFalloffExponent;
var(ScopeDOF) float m_fScopeDOFRadiusMod;
var(ScopeDOF) float m_fScopeDOFChangeFocusTime;
var(Switch) float m_fSwitchAnimTimePistol;
var(Switch) float m_fSwitchAnimTimeMG;
var(Switch) float m_fSwitchAnimTimeShield;
var(Switch) float m_fSwitchAnimTimeChest;
var(ThrowPickup) float m_fThrowAnimTime;
var(ThrowPickup) float m_fPickupAnimTime;
var(ThrowPickup) float m_fPickupTimeStand;
var(ThrowPickup) float m_fPickupTimeCrouch;
var(ThrowPickup) float m_fThrowTime;
var(HighLowReady) float m_fLowToHighReadyBlendTime;
var(HighLowReady) float m_fForceHighReadyBlendTime;
var(HighLowReady) float m_fHighToLowReadyBlendTime;
var(HighLowReady) float m_fWeaponLengthHysteresis;
var(HighLowReady) float m_fMaxDistanceForLookAtFriendly;
var(HighLowReady) float m_fHighReadyDelay;
var(FPMovement) float m_fMaxYawLookSpeed;
var(FPMovement) float m_fMaxPitchLookSpeed;
var(Turreting) /*0x20000000-0x00000000*/ int m_iMaxTurretLeftRightAimingAngle;
var(Turreting) /*0x20000000-0x00000000*/ int m_iMaxTurretUpAimingAngle;
var(Turreting) /*0x20000000-0x00000000*/ int m_iMaxTurretDownAimingAngle;
var(Turreting) float m_fEnterExitTurretDuration;
var(Turreting) float m_fEnterExitTurretTCDuration;
var(Turreting) float m_fTurretAimingBlendInDuration;
var(Breathing) float m_fBreathMovementIncSpeed;
var(Breathing) float m_fBreathMovementDecSpeed;
var(Shield) float m_fTimeToTc;
var(Shield) float m_fShieldTcRotModifier;
var(FOV) float m_fFirstPersonFOV;
var(MuzzleFlash) export editinline PointLightComponent m_MuzzleFlashLightFP;
var(MuzzleFlash) export editinline PointLightComponent m_MuzzleFlashLightTP;
var(Recoil) SInterpParams m_RecoilInInterParams;
var(BlindFireIK) float m_fBFIKPumpStartUseHoldSocket;
var(BlindFireIK) float m_fBFIKPumpEndUseHoldSocket;
var(BlindFireIK) float m_fBFIKPumpStartUseIK;
var(BlindFireIK) float m_fBFIKPumpStartNoIKInterp;
var(BlindFireIK) float m_fBFIKPumpEndUseIK;
var(BlindFireIK) float m_fBFIKPumpStartUseIKInterp;
var(BlindFireIK) float m_fBFIKPumpStartDefaultIK;
var(BlindFireIK) float m_fBFIKPumpStartDefaultIKInterp;
var(BlindFireIK) float m_fBFIKBoltStartUseHoldSocket;
var(BlindFireIK) float m_fBFIKBoltEndUseHoldSocket;
var(BlindFireIK) float m_fBFIKBoltStartUseIK;
var(BlindFireIK) float m_fBFIKBoltStartNoIKInterp;
var(BlindFireIK) float m_fBFIKBoltEndUseIK;
var(BlindFireIK) float m_fBFIKBoltStartUseIKInterp;
var(BlindFireIK) float m_fBFIKBoltStartDefaultIK;
var(BlindFireIK) float m_fBFIKBoltStartDefaultIKInterp;
var(Optim) float m_fDisableMuzzleFlashLightDelay;
var(Optim) int m_iDisableMakeNoiseNbTicks;

// Export UR6WeaponsConfig::execGetScopeFOVModifier(FFrame&, void* const)
native function float GetScopeFOVModifier(R6EngineEnums.EZoomType EZoomType, R6EngineEnums.EMagmaScopeType eTheMagmaScopeType);

defaultproperties
{
    m_fTakeCoverScopeFOVModifier=0.9000000
    m_fTakeCover12XScopeFOVModifier=0.8000000
    m_fScopeTransitionLength=0.3000000
    m_fScopeTcReadyModLength=0.5000000
    m_vScopeAcogEdgeBlurScale=(X=0.0000000,Y=0.0000000)
    m_fScopeFirstPersonFOV=0.0400000
    m_fUnZoomStartShoot=0.2000000
    m_fUnZoomMultiplierShoot=0.4000000
    m_fRifleFrontOffset=-110.0000000
    m_fRifleUpOffset=-3.8500000
    m_fSniperFrontOffset=-90.0000000
    m_fSniperUpOffset=-3.4800000
    m_fScopeDOFBlurKernelSize=5.0000000
    m_fScopeDOFMaxNearBlurAmount=0.9000000
    m_fScopeDOFMaxFarBlurAmount=1.0000000
    m_ScopeDOFModulateBlurColor=(R=255,G=255,B=255,A=255)
    m_fScopeDOFFalloffExponent=4.0000000
    m_fScopeDOFRadiusMod=0.7500000
    m_fScopeDOFChangeFocusTime=0.5000000
    m_fSwitchAnimTimePistol=0.6660000
    m_fSwitchAnimTimeMG=0.9330000
    m_fSwitchAnimTimeShield=1.4660000
    m_fSwitchAnimTimeChest=0.5000000
    m_fThrowAnimTime=0.5667000
    m_fPickupAnimTime=0.9333000
    m_fPickupTimeStand=0.1400000
    m_fPickupTimeCrouch=0.0700000
    m_fThrowTime=0.3800000
    m_fLowToHighReadyBlendTime=0.2500000
    m_fForceHighReadyBlendTime=0.1000000
    m_fHighToLowReadyBlendTime=0.2500000
    m_fWeaponLengthHysteresis=35.0000000
    m_fMaxDistanceForLookAtFriendly=500.0000000
    m_fHighReadyDelay=0.5000000
    m_fMaxYawLookSpeed=25000.0000000
    m_fMaxPitchLookSpeed=10000.0000000
    m_iMaxTurretLeftRightAimingAngle=10012
    m_iMaxTurretUpAimingAngle=7281
    m_iMaxTurretDownAimingAngle=5461
    m_fEnterExitTurretDuration=0.9300000
    m_fEnterExitTurretTCDuration=1.0000000
    m_fTurretAimingBlendInDuration=0.5000000
    m_fBreathMovementIncSpeed=0.2500000
    m_fBreathMovementDecSpeed=0.0500000
    m_fTimeToTc=0.6000000
    m_fShieldTcRotModifier=0.8000000
    m_fFirstPersonFOV=1.0000000
    // Reference: PointLightComponent'Default__R6WeaponsConfig.MuzzleFlashLightComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MuzzleFlashLightComponentFP" class=Class'PointLightComponent'
        Radius=256.0000000
        FallOff=128.0000000
        Brightness=0.0000000
        LightColor=(R=192,G=180,B=144,A=255)
        bEnabled=false
        AffectPawns=true
        m_fAmbientValue=0.2500000
        m_eComponentVisibility=1
        m_bIsVisibleInScope=true
    end object
    m_MuzzleFlashLightFP=MuzzleFlashLightComponentFP
    // Reference: PointLightComponent'Default__R6WeaponsConfig.MuzzleFlashLightComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="MuzzleFlashLightComponentTP" class=Class'PointLightComponent'
        Radius=256.0000000
        FallOff=128.0000000
        Brightness=0.0000000
        LightColor=(R=192,G=180,B=144,A=255)
        bEnabled=false
        AffectPawns=true
        m_fAmbientValue=0.2500000
        m_eComponentVisibility=2
        m_bIsVisibleInScope=true
    end object
    m_MuzzleFlashLightTP=MuzzleFlashLightComponentTP
    m_RecoilInInterParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
    m_fBFIKPumpStartUseHoldSocket=0.5000000
    m_fBFIKPumpEndUseHoldSocket=0.3000000
    m_fBFIKPumpStartUseIK=0.5000000
    m_fBFIKPumpStartNoIKInterp=0.2000000
    m_fBFIKPumpEndUseIK=0.5000000
    m_fBFIKPumpStartUseIKInterp=0.4000000
    m_fBFIKPumpStartDefaultIK=0.3000000
    m_fBFIKPumpStartDefaultIKInterp=0.2000000
    m_fBFIKBoltStartUseHoldSocket=0.5000000
    m_fBFIKBoltEndUseHoldSocket=0.3000000
    m_fBFIKBoltStartUseIK=0.5000000
    m_fBFIKBoltStartNoIKInterp=0.2000000
    m_fBFIKBoltEndUseIK=0.5000000
    m_fBFIKBoltStartUseIKInterp=0.4000000
    m_fBFIKBoltStartDefaultIK=0.3000000
    m_fBFIKBoltStartDefaultIKInterp=0.2000000
    m_fDisableMuzzleFlashLightDelay=1.5000000
    m_iDisableMakeNoiseNbTicks=10
    m_szDescription="Weapons config"
}