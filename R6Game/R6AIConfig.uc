class R6AIConfig extends R6Config
    native
    hidecategories(Object);

var(Movement) float m_fWalkSpeed;
var(Movement) float m_fWalkFastSpeed;
var(Movement) float m_fJogSpeed;
var(Movement) float m_fRunSpeed;
var(Movement) float m_fCrouchWalkSpeed;
var(Movement) float m_fCrouchJogSpeed;
var(Movement) float m_fLazyWalkSpeed;
var(CollisionRadius) float m_fNPCRadius;
var(NavMesh) float m_fHeightLineTestDepth;
var(NavMesh) float m_fExposedLineTestDepth;
var(NavMesh) float m_fExposedPercent;
var(NavMesh) float m_fMinimumValidBorderLength;
var(NavMesh) float m_fMaximumExtendedPeekBorderLength;
var(NavMesh) /*0x20000000-0x00000000*/ int m_iMinimumBorderAngle;
var(NavMesh) /*0x20000000-0x00000000*/ int m_iMinimumExtendedPeekBorderAngle;
var(NavMesh) /*0x20000000-0x00000000*/ int m_iMinimumStandingPeekBorderAngle;
var(NavMesh) /*0x20000000-0x00000000*/ int m_iMaximumConvexAngle;
var float m_fCosineMinimumBorderAngle;
var float m_fCosineMinimumExtendedPeekBorderAngle;
var float m_fCosineMinimumStandingPeekBorderAngle;
var float m_fCosineMaximumConvexAngle;
var(NavMeshTriangles) float m_fMaximumArea;
var(NavMeshTriangles) /*0x20000000-0x00000000*/ int m_iMinimumAngle;
var(NavMeshTriangles) int m_iSteinerPoints;
var(RiskPoints) float m_fMaxDistanceCheckForCorner;
var(DoorParam) float m_fOpeningDoorRatioToMakeNoise;
var(WindowParam) float m_fOpeningWindowRatioToMakeNoise;
var(Cover) float m_fTakeCoverSpacing;
var(Cover) float m_fMinimumDistanceFromThreat;
var(Cover) float m_fRadiiFromCornerOnCrouchCover;
var(DoorStackDistance) float m_fRainbowStackDistanceBetweenPawn;
var(DoorStackDistance) float m_fAnimationTriggerOffset;
var(Rope) float m_fWindowSafeDistance;
var(Rope) float m_fAtWindowDistance;
var(Ladder) bool m_bStandByOnLadder;
var(Navigation) bool m_bUseEndFacingInMoveTo;
var(GeoLedge) float m_fMaxGeoLedgeTickness;
var(Formation) float m_fFormationDistanceLeash;
var(Formation) float m_fFormationRainbow1Distance;
var(Formation) float m_fFormationRainbow1DistanceWhileMove;
var(Formation) float m_fFormationRainbow2Distance;
var(Formation) float m_fFormationRainbow2DistanceWhileMove;
var(Formation) float m_fFormationLeaderUpdateTimer;
var(Formation) float m_fCatchupStartDistance;
var(Formation) float m_fCatchupStopDistance;
var(Formation) float m_fCatchupBoost;
var(Formation) float m_fMoveInFormationTriggerDist;
var(Formation) float m_fFormationMatchLeaderSpeedDst;
var(Formation) float m_fFormationMinLeaderSpeedToMatch;
var(Navigation) float m_fNavigation_ObstacleOnFireAvoidDist;
var(Navigation) float m_fNavigation_EnemyAvoidDist;
var(Navigation) float m_fDistanceToMoveOnInteractingOrder;
var(Navigation) float m_fPlayerAvoidanceRadiusFromCam;
var(Navigation) float m_fEndFacingDirTriggerDistance;
var(Navigation) float m_fCrouchLeavingCoverDist;
var(Combat) float m_fThreatBoostToTaggedEnemy;
var(Combat) float m_fDistanceWhenCloseToThreat;
var(Combat) float m_fTimeToShootAtLastKnownLocation;
var(Shoot) float m_fCrouchedAccuracyMultiplier;
var(Shoot) float m_fHipAccuracyMultiplier;
var(Shoot) float m_fSprayDamageMultiplier;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeStackLeftEnterLeft;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeStackLeftEnterMid;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeStackLeftEnterRight;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeStackRightEnterLeft;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeStackRightEnterMid;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeStackRightEnterRight;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeTCLeftEnterLeft;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeTCLeftEnterMid;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeTCLeftEnterRight;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeTCRightEnterLeft;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeTCRightEnterMid;
var(DoorAnimAbortTimeJung) float m_fJungAbortTimeTCRightEnterRight;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeStackLeftEnterLeft;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeStackLeftEnterMid;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeStackLeftEnterRight;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeStackRightEnterLeft;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeStackRightEnterMid;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeStackRightEnterRight;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeTCLeftEnterLeft;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeTCLeftEnterMid;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeTCLeftEnterRight;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeTCRightEnterLeft;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeTCRightEnterMid;
var(DoorAnimAbortTimeMike) float m_fMikeAbortTimeTCRightEnterRight;
var(RainbowsCommunication) int m_iDistanceConsideredFar;
var(RainbowsCommunication) float m_fTimeIntervalForSayingTheBlockedLines;
var(RainbowsCommunication) int m_iMaxDistanceToCongratulate;
var(TerroristsCommunication) float m_fTimeIntervalForReportingNothingFound;
var(TerroristsCommunication) int m_iDistanceFromPlayerToStartIdleDialog;
var(TerroristsCommunication) int m_iDistanceFromTeamateOkToStartIdleDialog;
var(TerroristsCommunication) float m_fMinimumTimeBetweenIdleDialogGuardAware;
var(TerroristsCommunication) float m_fMinimumTimeBetweenIdleDialogGuardUnaware;
var(TerroristsCommunication) float m_fMinimumTimeBetweenIdleDialogPatrolAware;
var(TerroristsCommunication) float m_fMinimumTimeBetweenIdleDialogPatrolUnaware;
var(TerroristsCommunication) float m_fMinimumTimeAfterTheyBecomeAwareToStartIdleDial;
var(TerroristsCommunication) float m_fPassiveCommunicationDistance;
var(TerroristsCommunication) float m_fMaxDialogDistance;
var(MusicIntensity) float m_fMinimumTimeForChangingIntensity;
var(VisionMode) float m_fMaximumDistanceToConsiderEffect;
var(IdleDialog) int m_IdleDialogGuardAwareIndex;
var(IdleDialog) int m_IdleDialogGuardUnawareIndex;
var(IdleDialog) int m_IdleDialogPatrolAwareIndex;
var(IdleDialog) int m_IdleDialogPatrolUnawareIndex;
var(Delays) float m_fDelayToStartMoveTo;
var(RainbowVoiceBank) R6VoiceBank m_VBLogan;
var(RainbowVoiceBank) R6VoiceBank m_VBMichael;
var(RainbowVoiceBank) R6VoiceBank m_VBJung;
var(RainbowVoiceBank) R6VoiceBank m_VBKan;
var(RainbowVoiceBank) R6VoiceBank m_VBGabriel;
var(IdleTime) float m_fTimeUntilIdleStart;
var(IdleTime) float m_fBasicIdleTimeBase;
var(IdleTime) float m_fCalmIdleTimeBase;
var(IdleTime) float m_fNervousIdleTimeBase;
var(IdleTime) float m_fGuiltyIdleTimeBase;
var(IdleTime) float m_fActionTimerOffset;
var(IdleTime) float m_fActionLookAtOtherPawn;
var(IdleTime) float m_fActionProbLeader_Calm;
var(IdleTime) float m_fActionProbTeamMates_Calm;
var(IdleTime) float m_fActionProbLookRandom_Calm;
var(IdleTime) float m_fActionProbStimulating_Calm;
var(IdleTime) float m_fActionProbLookFeet_Calm;
var(IdleTime) float m_fActionProbLeader_Nervous;
var(IdleTime) float m_fActionProbTeamMates_Nervous;
var(IdleTime) float m_fActionProbLookRandom_Nervous;
var(IdleTime) float m_fActionProbStimulating_Nervous;
var(IdleTime) float m_fActionProbLookFeet_Nervous;
var(IdleTime) float m_fActionProbLeader_Guilty;
var(IdleTime) float m_fActionProbTeamMates_Guilty;
var(IdleTime) float m_fActionProbLookRandom_Guilty;
var(IdleTime) float m_fActionProbStimulating_Guilty;
var(IdleTime) float m_fActionProbLookFeet_Guilty;
var(IdleTime) float m_fActionProbLeader_Basic;
var(IdleTime) float m_fActionProbTeamMates_Basic;
var(IdleTime) float m_fActionProbLookRandom_Basic;
var(IdleTime) float m_fActionProbStimulating_Basic;
var(IdleTime) float m_fActionProbLookFeet_Basic;
var(AIDeadlock) float m_fMinDistanceForDeadlock;
var(ThreatScore) float m_fThreatDistLvl1;
var(ThreatScore) float m_fThreatDistLvl2;
var(ThreatScore) float m_fThreatDistLvl3;
var(ThreatScore) float m_fThreatDistLvl4;
var(ThreatScore) float m_fThreatDistLvl5;
var(ThreatScore) float m_fThreatTimeDmgLvl1;
var(ThreatScore) float m_fThreatTimeDmgLvl2;
var(ThreatScore) float m_fThreatTimeDmgLvl3;
var(ThreatScore) float m_fThreatTimeDmgLvl4;
var(ThreatScore) float m_fThreatDistToDoor;
var(ThreatScore) float m_fThreatDistToExposeCover;
var(ThreatScore) int m_iThreatScoreNotLost;
var(ThreatScore) int m_iThreatScoreGaveDmg;
var(ThreatScore) int m_iThreatScoreIsTheirEnemy;
var(ThreatScore) int m_iThreatScoreIsInFOV;
var(ThreatScore) int m_iThreatScoreIndirectlyVisible;
var(ThreatScore) int m_iThreatScoreWeaponVisible;
var(ThreatScore) int m_iThreatScoreIsInOffensiveAttack;
var(ThreatScore) int m_iThreatScoreIsCoordTarget;
var(ThreatScore) int m_iThreatScoreDistToMeLvl1;
var(ThreatScore) int m_iThreatScoreDistToMeLvl2;
var(ThreatScore) int m_iThreatScoreDistToMeLvl3;
var(ThreatScore) int m_iThreatScoreDistToMeLvl4;
var(ThreatScore) int m_iThreatScoreDistToMeLvl5;
var(ThreatScore) int m_iThreatScoreDistToLocLvl1;
var(ThreatScore) int m_iThreatScoreDistToLocLvl2;
var(ThreatScore) int m_iThreatScoreDistToLocLvl3;
var(ThreatScore) int m_iThreatScoreDistToLocLvl4;
var(ThreatScore) int m_iThreatScoreDistToLocLvl5;
var(ThreatScore) int m_iThreatScoreDmgLvl1;
var(ThreatScore) int m_iThreatScoreDmgLvl2;
var(ThreatScore) int m_iThreatScoreDmgLvl3;
var(ThreatScore) int m_iThreatScoreDmgLvl4;
var(ThreatScore) int m_iThreatScoreExposedCover;
var(ThreatScore) int m_iThreatScoreTagged;
var(ThreatScore) int m_iThreatScoreDoor;
var(ThreatScore) int m_iThreatScoreVisible;
var(TurnAnim) float m_fMaxTurnAnimRate;
var(FollowingHostage) float m_fDistToLeaderBeforeMoving;
var(FollowingHostage) float m_fDistToLeaderBeforeCatchup;
var(FollowingHostage) float m_fDistLeaderMovedBeforeChangingPosition;
var(TerroHunt) float m_fTHPriorityThreshold;
var(TerroHunt) float m_fTHPriorityIncrease;
var(TerroHunt) float m_fTHPriorityDecrease;
var(TerroHunt) float m_fTimeBeforeHuntingLowBound;
var(TerroHunt) float m_fTimeBeforeHuntingHighBound;

defaultproperties
{
    m_fWalkSpeed=165.0000000
    m_fWalkFastSpeed=250.0000000
    m_fJogSpeed=400.0000000
    m_fRunSpeed=600.0000000
    m_fCrouchWalkSpeed=80.0000000
    m_fCrouchJogSpeed=215.0000000
    m_fLazyWalkSpeed=72.0000000
    m_fNPCRadius=34.0000000
    m_fHeightLineTestDepth=60.0000000
    m_fExposedLineTestDepth=60.0000000
    m_fExposedPercent=0.4000000
    m_fMinimumValidBorderLength=64.0000000
    m_fMaximumExtendedPeekBorderLength=32.0000000
    m_iMinimumBorderAngle=24576
    m_iMinimumExtendedPeekBorderAngle=24576
    m_iMaximumConvexAngle=24576
    m_fCosineMinimumBorderAngle=-0.7071068
    m_fCosineMinimumExtendedPeekBorderAngle=-0.7071068
    m_fCosineMinimumStandingPeekBorderAngle=-0.8660254
    m_fCosineMaximumConvexAngle=-0.7071068
    m_fMaximumArea=-1.0000000
    m_fMaxDistanceCheckForCorner=700.0000000
    m_fOpeningDoorRatioToMakeNoise=0.3000000
    m_fOpeningWindowRatioToMakeNoise=0.3000000
    m_fTakeCoverSpacing=136.0000000
    m_fMinimumDistanceFromThreat=300.0000000
    m_fRadiiFromCornerOnCrouchCover=1.0000000
    m_fRainbowStackDistanceBetweenPawn=102.0000000
    m_fWindowSafeDistance=100.0000000
    m_fAtWindowDistance=35.0000000
    m_bUseEndFacingInMoveTo=true
    m_fMaxGeoLedgeTickness=64.0000000
    m_fFormationDistanceLeash=250.0000000
    m_fFormationRainbow1Distance=150.0000000
    m_fFormationRainbow1DistanceWhileMove=200.0000000
    m_fFormationRainbow2Distance=250.0000000
    m_fFormationRainbow2DistanceWhileMove=400.0000000
    m_fFormationLeaderUpdateTimer=0.5000000
    m_fCatchupStartDistance=800.0000000
    m_fCatchupStopDistance=400.0000000
    m_fCatchupBoost=1.3000000
    m_fMoveInFormationTriggerDist=1000.0000000
    m_fFormationMatchLeaderSpeedDst=300.0000000
    m_fFormationMinLeaderSpeedToMatch=55.0000000
    m_fNavigation_ObstacleOnFireAvoidDist=55.0000000
    m_fNavigation_EnemyAvoidDist=66.0000000
    m_fDistanceToMoveOnInteractingOrder=50.0000000
    m_fPlayerAvoidanceRadiusFromCam=10.0000000
    m_fEndFacingDirTriggerDistance=150.0000000
    m_fCrouchLeavingCoverDist=100.0000000
    m_fThreatBoostToTaggedEnemy=250.0000000
    m_fDistanceWhenCloseToThreat=200.0000000
    m_fTimeToShootAtLastKnownLocation=7.0000000
    m_fCrouchedAccuracyMultiplier=1.3000000
    m_fHipAccuracyMultiplier=0.6000000
    m_fSprayDamageMultiplier=1.0000000
    m_fJungAbortTimeStackLeftEnterLeft=2.0667000
    m_fJungAbortTimeStackLeftEnterMid=1.5667000
    m_fJungAbortTimeStackLeftEnterRight=1.6333000
    m_fJungAbortTimeStackRightEnterLeft=1.5667000
    m_fJungAbortTimeStackRightEnterMid=1.5667000
    m_fJungAbortTimeStackRightEnterRight=1.8000000
    m_fJungAbortTimeTCLeftEnterLeft=2.2667000
    m_fJungAbortTimeTCLeftEnterMid=2.0000000
    m_fJungAbortTimeTCLeftEnterRight=1.7000000
    m_fJungAbortTimeTCRightEnterLeft=1.5667000
    m_fJungAbortTimeTCRightEnterMid=2.0000000
    m_fJungAbortTimeTCRightEnterRight=1.7667000
    m_fMikeAbortTimeStackLeftEnterLeft=2.0667000
    m_fMikeAbortTimeStackLeftEnterMid=1.5667000
    m_fMikeAbortTimeStackLeftEnterRight=1.6333000
    m_fMikeAbortTimeStackRightEnterLeft=1.5667000
    m_fMikeAbortTimeStackRightEnterMid=1.5667000
    m_fMikeAbortTimeStackRightEnterRight=1.8000000
    m_fMikeAbortTimeTCLeftEnterLeft=2.2667000
    m_fMikeAbortTimeTCLeftEnterMid=2.0000000
    m_fMikeAbortTimeTCLeftEnterRight=1.7000000
    m_fMikeAbortTimeTCRightEnterLeft=1.5667000
    m_fMikeAbortTimeTCRightEnterMid=2.0000000
    m_fMikeAbortTimeTCRightEnterRight=1.7667000
    m_iDistanceConsideredFar=2000
    m_fTimeIntervalForSayingTheBlockedLines=6.0000000
    m_iMaxDistanceToCongratulate=1000
    m_fTimeIntervalForReportingNothingFound=8.0000000
    m_iDistanceFromPlayerToStartIdleDialog=1500
    m_iDistanceFromTeamateOkToStartIdleDialog=400
    m_fMinimumTimeBetweenIdleDialogGuardAware=30.0000000
    m_fMinimumTimeBetweenIdleDialogGuardUnaware=30.0000000
    m_fMinimumTimeBetweenIdleDialogPatrolAware=25.0000000
    m_fMinimumTimeBetweenIdleDialogPatrolUnaware=25.0000000
    m_fMinimumTimeAfterTheyBecomeAwareToStartIdleDial=20.0000000
    m_fPassiveCommunicationDistance=500.0000000
    m_fMaxDialogDistance=1500.0000000
    m_fMinimumTimeForChangingIntensity=10.0000000
    m_fMaximumDistanceToConsiderEffect=3000.0000000
    m_IdleDialogGuardUnawareIndex=1
    m_IdleDialogPatrolAwareIndex=2
    m_IdleDialogPatrolUnawareIndex=3
    m_fDelayToStartMoveTo=0.5000000
    m_fTimeUntilIdleStart=2.0000000
    m_fBasicIdleTimeBase=2.5000000
    m_fCalmIdleTimeBase=3.0000000
    m_fNervousIdleTimeBase=1.7000000
    m_fGuiltyIdleTimeBase=2.2000000
    m_fActionTimerOffset=1.2500000
    m_fActionLookAtOtherPawn=0.5000000
    m_fActionProbTeamMates_Calm=0.3000000
    m_fActionProbLookRandom_Calm=0.7000000
    m_fActionProbTeamMates_Nervous=0.3000000
    m_fActionProbLookRandom_Nervous=0.7000000
    m_fActionProbTeamMates_Guilty=0.3000000
    m_fActionProbLookRandom_Guilty=0.7000000
    m_fActionProbTeamMates_Basic=0.3000000
    m_fActionProbLookRandom_Basic=0.7000000
    m_fMinDistanceForDeadlock=1000.0000000
    m_fThreatDistLvl1=3000.0000000
    m_fThreatDistLvl2=2000.0000000
    m_fThreatDistLvl3=1000.0000000
    m_fThreatDistLvl4=500.0000000
    m_fThreatDistLvl5=200.0000000
    m_fThreatTimeDmgLvl1=10.0000000
    m_fThreatTimeDmgLvl2=5.0000000
    m_fThreatTimeDmgLvl3=2.0000000
    m_fThreatTimeDmgLvl4=1.0000000
    m_fThreatDistToDoor=300.0000000
    m_fThreatDistToExposeCover=1200.0000000
    m_iThreatScoreNotLost=1
    m_iThreatScoreGaveDmg=2
    m_iThreatScoreIsTheirEnemy=4
    m_iThreatScoreIsInFOV=8
    m_iThreatScoreIndirectlyVisible=16
    m_iThreatScoreWeaponVisible=64
    m_iThreatScoreIsInOffensiveAttack=32
    m_iThreatScoreIsCoordTarget=128
    m_iThreatScoreDistToMeLvl1=256
    m_iThreatScoreDistToMeLvl2=512
    m_iThreatScoreDistToMeLvl3=1024
    m_iThreatScoreDistToMeLvl4=2048
    m_iThreatScoreDistToMeLvl5=4096
    m_iThreatScoreDistToLocLvl1=8192
    m_iThreatScoreDistToLocLvl2=16384
    m_iThreatScoreDistToLocLvl3=32768
    m_iThreatScoreDistToLocLvl4=65536
    m_iThreatScoreDistToLocLvl5=131072
    m_iThreatScoreDmgLvl1=1048576
    m_iThreatScoreDmgLvl2=2097152
    m_iThreatScoreDmgLvl3=4194304
    m_iThreatScoreDmgLvl4=8388608
    m_iThreatScoreExposedCover=16777216
    m_iThreatScoreTagged=33554432
    m_iThreatScoreDoor=67108864
    m_iThreatScoreVisible=134217728
    m_fMaxTurnAnimRate=1.0000000
    m_fDistToLeaderBeforeMoving=250.0000000
    m_fDistToLeaderBeforeCatchup=500.0000000
    m_fDistLeaderMovedBeforeChangingPosition=150.0000000
    m_fTHPriorityThreshold=0.5000000
    m_fTHPriorityIncrease=0.0050000
    m_fTHPriorityDecrease=0.0500000
    m_fTimeBeforeHuntingLowBound=2.0000000
    m_fTimeBeforeHuntingHighBound=20.0000000
    m_szDescription="AI configuration"
}