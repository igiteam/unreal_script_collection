class R6AITemplate extends Object
    native
    editinlinenew
    hidecategories(Object);

var() int m_iHealth;
var() StaticMesh m_Helmet;
var() float m_fLockFOV;
var(Shoot) float m_fTakeCoverPeekFOV;
var(Shoot) Rotator m_rAimRotationRate;
var(Shoot) Rotator m_rAimRotationRateSlow;
var(Shoot) Rotator m_rAimRotationRateModerate;
var(Shoot) int m_iAimRotationRateSlowLimit;
var(Shoot) int m_iAimRotationRateModerateLimit;
var(Shoot) float m_fLockTime;
var(Shoot) float m_fLockTimeMultiplierForMovingTarget;
var(Shoot) float m_fCirclingTime;
var(Shoot) float m_fCirclingJerkFactor;
var(Shoot) float m_fCirclingMagnetFactor;
var(Shoot) float m_fSprayingFOV;
var(Shoot) float m_fSprayingJerkFactor;
var(Shoot) float m_fSprayingMagnetFactor;
var(Shoot) float m_fShortBurstPreference;
var(Shoot) float m_fMediumBurstPreference;
var(Shoot) float m_fLongBurstPreference;
var(Shoot) float m_fDeadShootTime;
var(Shoot) float m_fMaxFiringTime;
var(Shoot) float m_fStopBurstProbability;
var(Abilities) float m_fIntuitionTime;
var(Abilities) float m_fLostTimeMinGuard;
var(Abilities) float m_fLostTimeMaxGuard;
var(Abilities) float m_fLostTimeMinPatroller;
var(Abilities) float m_fLostTimeMaxPatroller;
var(Abilities) float m_fSustainedVisionTime;
var(Abilities) float m_fCoverThreatTime;
var(Abilities) float m_fDistanceToConsiderSafeForGrenade;
var(Abilities) float m_fDistanceToMoveWhenChoked;
var(Abilities) float m_fDistanceToSeeNearbyGrenade;
var(Abilities) float m_fMinimumBrightnessFactor;
var(Abilities) float m_fDistanceToCoordinate;
var(Vision_Focus) /*0x20000000-0x00000000*/ int m_iAwareFocusVisionAngleHorizontal;
var(Vision_Focus) /*0x20000000-0x00000000*/ int m_iAwareFocusVisionAngleVertical;
var(Vision_Focus) float m_fAwareFocusVisionMaximumDistance;
var(Vision_Focus) /*0x20000000-0x00000000*/ int m_iUnAwareFocusVisionAngleHorizontal;
var(Vision_Focus) /*0x20000000-0x00000000*/ int m_iUnAwareFocusVisionAngleVertical;
var(Vision_Focus) float m_fUnAwareFocusVisionMaximumDistance;
var(Vision_Focus) float m_fPeripheralVisionBlendDistance;
var(Vision_Peripheral) /*0x20000000-0x00000000*/ int m_iAwarePeripheralVisionAngleHorizontal;
var(Vision_Peripheral) /*0x20000000-0x00000000*/ int m_iAwarePeripheralVisionAngleVertical;
var(Vision_Peripheral) float m_fAwarePeripheralVisionMaximumDistance;
var(Vision_Peripheral) /*0x20000000-0x00000000*/ int m_iUnAwarePeripheralVisionAngleHorizontal;
var(Vision_Peripheral) /*0x20000000-0x00000000*/ int m_iUnAwarePeripheralVisionAngleVertical;
var(Vision_Peripheral) float m_fUnAwarePeripheralVisionMaximumDistance;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_GrenadeBounceRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_BulletRicochetRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_BulletPassNearbyRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_DoorMoveRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_WindowMoveRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_WindowBreakRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_HeavyFootstepRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_LightFootstepRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_PawnRadioRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_PawnTalkRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_PawnShoutRadius;
var(NoiseEventRadiusDistance) float m_fNoiseEvent_PawnScreamRadius;
var(CombatFeeling) float m_fCombatFeeling_FirstTimeAwareAndSeenByHuman;
var(CombatFeeling) float m_fCombatFeeling_BulletPassNearby;
var(CombatFeeling) float m_fCombatFeeling_BulletRicochet;
var(CombatFeeling) float m_fCombatFeeling_BulletPassByBlindFire;
var(CombatFeeling) float m_fCombatFeeling_SeeGrenadeLandNear;
var(CombatFeeling) float m_fCombatFeeling_ReactToBeingDamaged;
var(CombatFeeling) float m_fCombatFeeling_ReactToBeingGassed;
var(CombatFeeling) float m_fCombatFeeling_ReactToBeingFlashed;
var(CombatFeeling) float m_fCombatFeeling_ReactToBeingStunned;
var(CombatFeeling) float m_fCombatFeeling_ReactToExplosion;
var(CombatFeeling) float m_fCombatFeeling_ReactToFriendDying;
var(CombatFeeling) float m_fCombatFeeling_ReactToLeaderDying;
var(CombatFeeling) float m_fCombatFeeling_MaxOffense;
var(CombatFeeling) float m_fCombatFeeling_MaxDefense;
var(ReloadReaction) float m_fReloadReaction_ChanceToGoForCoverToReload;
var(ReloadReaction) float m_fReloadReaction_ChanceToCrouch;
var(Reactions) float m_fBulletMediumReactionMin;
var(Reactions) float m_fBulletMediumReactionMax;
var(Reactions) float m_fBulletFastReactionMin;
var(Reactions) float m_fBulletFastReactionMax;
var(MovementSmoothing) float m_fDistanceFromStartToWalk;
var(MovementSmoothing) float m_fDistanceFromStartToFastWalk;
var(MovementSmoothing) float m_fDistanceFromDestinationToFastWalk;
var(MovementSmoothing) float m_fDistanceFromDestinationToWalk;
var(MovementSmoothing) float m_fDMaxDistanceBackward;
var(RiskPoints) float m_fFOVToAcquirePOIWhenMoving;
var(RiskPoints) float m_fFOVToDiscardPOIWhenMoving;
var(RiskPoints) float m_fIdealPOIDistance;
var(RiskPoints) float m_fTolerablePOIDistanceRatio;
var(RiskPoints) float m_fMaxDistancePenalty;
var(RiskPoints) float m_fBaseEnemyThreatValue;
var(RiskPoints) float m_fBaseObjectThreatValue;
var(RiskPoints) float m_fBaseCornerThreatValue;
var(RiskPoints) float m_fEntryObjectThreatDiscount;
var(RiskPoints) float m_fTimeToFocusOnDangerBeforeLookAtPOI;
var(RiskPoints) float m_fMinTimeToFocusOnDanger;
var(RiskPoints) float m_fAngleToDropDanger;
var(RiskPoints) float m_fMinTimeToFocusOnAPOI;
var(RiskPoints) float m_fMaxTimeToFocusOnAPOI;
var(RiskPoints) float m_fHighThreatLimit;
var(RiskPoints) float m_fAngleToGroupPOI;
var(RiskPoints) float m_fBodyFOV;
var(RiskPoints) float m_fPropensityToLookAtTeammate;
var(RiskPoints) float m_fVerticalAngleLimit;
var(Advance) float m_fMaxAdvanceStepDistance;
var(Advance) float m_fMinAdvanceStepDistance;
var(SlicingThePie) bool m_bSlicingThePie_AllowedToUse;
var(SlicingThePie) float m_fSlicingThePie_StartRadiusRatio;
var(SlicingThePie) float m_fSlicingThePie_MaxRadius;
var(SlicingThePie) float m_fSlicingThePie_MinRadius;
var(SlicingThePie) float m_fSlicingThePie_SpeedRatio;
var(Behavior) float m_fGroupDistance;
var(Behavior) float m_fThreatLevel;
var(Combat) float m_fMinTimeToStayInCover;
var(Combat) float m_fMinTimeToPeekFromCover;
var(Combat) float m_fMaxTimeToPeekFromCover;
var(Combat) float m_fConsecutivePeekTime;
var(Combat) float m_fMaxTimeToAimShoot;
var(Combat) float m_fMaxPreCombatMoveDistance;
var(Combat) float m_fCloseQuarterShootoutDistance;
var(Combat) float m_fInfiltrationShootoutDistance;
var(TakeCoverSafeZone) float m_fMaxSafetyDistance;
var(TakeCoverSafeZone) float m_fZeroSafetyDistance;
var(TakeCoverSafeZone) /*0x20000000-0x00000000*/ int m_iZeroSafetyHAngle;
var(TakeCoverSafeZone) /*0x20000000-0x00000000*/ int m_iZeroSafetyVAngle;
var(Grenades) float m_fMaximumThrowDistance;
var(Grenades) float m_fMaximumUsefulSmokeDistance;
var(Grenades) float m_fMaximumDistanceToMoveToThrow;
var(Grenades) float m_fSafeDistanceFactor;
var(Grenades) float m_fConsecutiveGrenadeTime;
var(LeaderEffect) float m_fLeaderEffect_DefensiveInputPercentReduction;
var(LeaderEffect) float m_fLeaderEffect_HealthValuePercentIncrease;
var(LeaderEffect) float m_fLeaderEffect_LockTimePercentReduction;
var(LeaderEffect) float m_fLeaderEffect_LeaderOrderOffensiveBoost;
var(LeaderEffect) float m_fLeaderEffect_LeaderDeathDefensiveBoost;
var(LeaderEffect) float m_fLeaderEffect_PercentChanceToRetreat;
var(TeamTakeCover) float m_fMaxRunToCoverDist;
var(TeamTakeCover) float m_fMaxStayInCoverDist;
var(TeamTakeCover) float m_fFormationIdleTime;
var(TeamTakeCover) float m_fMaxXYDistFromDestForTakeCover;
var(TeamTakeCover) float m_fMaxZDistFromDestForTakeCover;
var(Threats) array<Actor.AIEventType> m_aeThreatEvent;

defaultproperties
{
    m_fLockFOV=25.0000000
    m_fTakeCoverPeekFOV=90.0000000
    m_rAimRotationRate=(Pitch=16384,Yaw=16384,Roll=0)
    m_rAimRotationRateSlow=(Pitch=6000,Yaw=6000,Roll=0)
    m_rAimRotationRateModerate=(Pitch=10000,Yaw=10000,Roll=0)
    m_iAimRotationRateSlowLimit=5421
    m_iAimRotationRateModerateLimit=16384
    m_fLockTime=1.0000000
    m_fLockTimeMultiplierForMovingTarget=1.5000000
    m_fCirclingTime=3.0000000
    m_fCirclingJerkFactor=2.5000000
    m_fCirclingMagnetFactor=2.0000000
    m_fSprayingFOV=35.0000000
    m_fSprayingJerkFactor=1.0000000
    m_fSprayingMagnetFactor=0.5000000
    m_fShortBurstPreference=0.2000000
    m_fMediumBurstPreference=0.6000000
    m_fLongBurstPreference=0.2000000
    m_fDeadShootTime=0.7000000
    m_fMaxFiringTime=3.0000000
    m_fStopBurstProbability=0.3330000
    m_fIntuitionTime=3.0000000
    m_fLostTimeMinGuard=40.0000000
    m_fLostTimeMaxGuard=55.0000000
    m_fLostTimeMinPatroller=20.0000000
    m_fLostTimeMaxPatroller=30.0000000
    m_fSustainedVisionTime=0.5000000
    m_fCoverThreatTime=5.0000000
    m_fDistanceToConsiderSafeForGrenade=800.0000000
    m_fDistanceToMoveWhenChoked=900.0000000
    m_fDistanceToSeeNearbyGrenade=200.0000000
    m_fMinimumBrightnessFactor=0.2000000
    m_fDistanceToCoordinate=1500.0000000
    m_iAwareFocusVisionAngleHorizontal=10920
    m_iAwareFocusVisionAngleVertical=9100
    m_fAwareFocusVisionMaximumDistance=10000.0000000
    m_iUnAwareFocusVisionAngleHorizontal=10920
    m_iUnAwareFocusVisionAngleVertical=9100
    m_fUnAwareFocusVisionMaximumDistance=10000.0000000
    m_fPeripheralVisionBlendDistance=1000.0000000
    m_iAwarePeripheralVisionAngleHorizontal=15474
    m_iAwarePeripheralVisionAngleVertical=10920
    m_fAwarePeripheralVisionMaximumDistance=5000.0000000
    m_iUnAwarePeripheralVisionAngleHorizontal=15474
    m_iUnAwarePeripheralVisionAngleVertical=10920
    m_fUnAwarePeripheralVisionMaximumDistance=5000.0000000
    m_fNoiseEvent_GrenadeBounceRadius=1500.0000000
    m_fNoiseEvent_BulletRicochetRadius=200.0000000
    m_fNoiseEvent_BulletPassNearbyRadius=500.0000000
    m_fNoiseEvent_DoorMoveRadius=1200.0000000
    m_fNoiseEvent_WindowMoveRadius=500.0000000
    m_fNoiseEvent_WindowBreakRadius=2000.0000000
    m_fNoiseEvent_HeavyFootstepRadius=800.0000000
    m_fNoiseEvent_LightFootstepRadius=400.0000000
    m_fNoiseEvent_PawnRadioRadius=2000.0000000
    m_fNoiseEvent_PawnTalkRadius=1000.0000000
    m_fNoiseEvent_PawnShoutRadius=6000.0000000
    m_fNoiseEvent_PawnScreamRadius=2000.0000000
    m_fCombatFeeling_FirstTimeAwareAndSeenByHuman=4.0000000
    m_fCombatFeeling_BulletPassNearby=1.0000000
    m_fCombatFeeling_BulletRicochet=0.5000000
    m_fCombatFeeling_BulletPassByBlindFire=0.5000000
    m_fCombatFeeling_SeeGrenadeLandNear=5.0000000
    m_fCombatFeeling_ReactToBeingDamaged=10.0000000
    m_fCombatFeeling_ReactToBeingGassed=15.0000000
    m_fCombatFeeling_ReactToBeingFlashed=10.0000000
    m_fCombatFeeling_ReactToBeingStunned=15.0000000
    m_fCombatFeeling_ReactToExplosion=5.0000000
    m_fCombatFeeling_ReactToFriendDying=3.0000000
    m_fCombatFeeling_ReactToLeaderDying=3.0000000
    m_fCombatFeeling_MaxOffense=-5.0000000
    m_fCombatFeeling_MaxDefense=15.0000000
    m_fBulletMediumReactionMin=0.7000000
    m_fBulletMediumReactionMax=0.7000000
    m_fBulletFastReactionMin=0.5000000
    m_fBulletFastReactionMax=1.2000000
    m_fDistanceFromStartToWalk=100.0000000
    m_fDistanceFromStartToFastWalk=250.0000000
    m_fDistanceFromDestinationToFastWalk=250.0000000
    m_fDistanceFromDestinationToWalk=100.0000000
    m_fDMaxDistanceBackward=300.0000000
    m_fFOVToAcquirePOIWhenMoving=80.0000000
    m_fFOVToDiscardPOIWhenMoving=130.0000000
    m_fIdealPOIDistance=1000.0000000
    m_fTolerablePOIDistanceRatio=2.5000000
    m_fMaxDistancePenalty=0.4000000
    m_fBaseEnemyThreatValue=1.0000000
    m_fBaseObjectThreatValue=0.6000000
    m_fBaseCornerThreatValue=0.3000000
    m_fEntryObjectThreatDiscount=0.3000000
    m_fTimeToFocusOnDangerBeforeLookAtPOI=4.0000000
    m_fMinTimeToFocusOnDanger=2.0000000
    m_fAngleToDropDanger=110.0000000
    m_fMinTimeToFocusOnAPOI=0.8000000
    m_fMaxTimeToFocusOnAPOI=1.5000000
    m_fHighThreatLimit=0.4000000
    m_fAngleToGroupPOI=15.0000000
    m_fBodyFOV=85.0000000
    m_fPropensityToLookAtTeammate=0.5000000
    m_fVerticalAngleLimit=30.0000000
    m_fMaxAdvanceStepDistance=1000.0000000
    m_fMinAdvanceStepDistance=350.0000000
    m_bSlicingThePie_AllowedToUse=true
    m_fSlicingThePie_StartRadiusRatio=3.0000000
    m_fSlicingThePie_MaxRadius=60.0000000
    m_fSlicingThePie_MinRadius=30.0000000
    m_fSlicingThePie_SpeedRatio=0.8000000
    m_fGroupDistance=1000.0000000
    m_fThreatLevel=1.0000000
    m_fMinTimeToStayInCover=2.5000000
    m_fMinTimeToPeekFromCover=1.2000000
    m_fMaxTimeToPeekFromCover=2.0000000
    m_fConsecutivePeekTime=6.0000000
    m_fMaxTimeToAimShoot=5.0000000
    m_fMaxPreCombatMoveDistance=1000.0000000
    m_fCloseQuarterShootoutDistance=400.0000000
    m_fMaxSafetyDistance=2000.0000000
    m_fZeroSafetyDistance=400.0000000
    m_iZeroSafetyHAngle=8192
    m_iZeroSafetyVAngle=4096
    m_fMaximumThrowDistance=2000.0000000
    m_fMaximumUsefulSmokeDistance=1000.0000000
    m_fMaximumDistanceToMoveToThrow=500.0000000
    m_fSafeDistanceFactor=1.2000000
    m_fConsecutiveGrenadeTime=8.0000000
    m_fLeaderEffect_DefensiveInputPercentReduction=0.7500000
    m_fLeaderEffect_HealthValuePercentIncrease=0.5000000
    m_fLeaderEffect_LockTimePercentReduction=0.2500000
    m_fLeaderEffect_LeaderOrderOffensiveBoost=2.0000000
    m_fLeaderEffect_LeaderDeathDefensiveBoost=5.0000000
    m_fLeaderEffect_PercentChanceToRetreat=0.2500000
    m_fMaxRunToCoverDist=500.0000000
    m_fMaxStayInCoverDist=1000.0000000
    m_fFormationIdleTime=5.0000000
    m_fMaxXYDistFromDestForTakeCover=200.0000000
    m_fMaxZDistFromDestForTakeCover=200.0000000
}