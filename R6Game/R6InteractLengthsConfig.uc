class R6InteractLengthsConfig extends R6Config
    native
    hidecategories(Object);

var(Climb) float m_fClimbOver;
var(Climb) float m_fClimbOverUpTcLeft;
var(Climb) float m_fClimbOverUpTcRight;
var(Climb) float m_fClimbOverUpLeft;
var(Climb) float m_fClimbOverUpRight;
var(Climb) float m_fClimbOverUpFront;
var(Climb) float m_fClimbOverDownLeft;
var(Climb) float m_fClimbOverDownRight;
var(Climb) float m_fClimbOverDownFront;
var(Climb) float m_fClimbFPSkelControlActivation;
var(Climb) float m_fClimbBlendOutAnimFP;
var(Climb) float m_fClimbBlendOutAnimTP;
var(Climb) float m_fClimbTimerEnableBarrelIKFP;
var(Rappel) float m_fAttachTopRappel;
var(Rappel) float m_fAttachBottomRappel;
var(Rappel) float m_fAttachWindowRappel;
var(Rappel) float m_fDettachTopRappel;
var(Rappel) float m_fDettachBottomRappel;
var(Rappel) float m_fInvertingRappel;
var(Rappel) float m_fDeinvertingRappel;
var(Rappel) float m_fKickdownStartRappel;
var(Rappel) float m_fBreachStartRappel;
var(Rappel) float m_fKickdownFinishRappel;
var(Rappel) float m_fBreachFinishRappel;
var(Rappel) float m_fDropWeaponDetachTopRappel;
var(Rappel) float m_fDropWeaponDetachBottomRappel;
var(Rappel) float m_fDropWeaponBreachRappel;
var(Rappel) float m_fEquipWeaponBreachRappel;
var(Rappel) float m_fEquipWeaponDettachTopRappel;
var(Rappel) float m_fEquipWeaponDettachBottomRappel;
var(Rappel) float m_fEquipWeaponAttachTopRappel;
var(Rappel) float m_fEquipWeaponAttachBottomRappel;
var(Rappel) float m_fEquipWeaponAttachWindowRappel;
var(Rappel) float m_fReadyToTcRappel;
var(Rappel) float m_fTcToReadyRappel;
var(Rappel) float m_fTcToDownRappel;
var(Rappel) float m_fTcToBfRappel;
var(Rappel) float m_fTcBfWait;
var(FastRope) float m_fAttachFastRope;
var(FastRope) float m_fAttachRappelToFastRope;
var(FastRope) float m_fAttachChopperLikeFastRope;
var(FastRope) float m_fDettachFastRope;
var(FastRope) float m_fStopFastRope;
var(FastRope) float m_fEquipWeaponDettachFastRope;
var(FastRope) float m_fDropWeaponRappelToFastRope;
var(Helicopter) float m_fAttachHelicopterFastRopeHacker;
var(Helicopter) float m_fAttachHelicopterFastRopeDemoGuy;
var(Helicopter) float m_fAttachHelicopterFastRopeLogan;
var(Helicopter) float m_fHelicopterEntryTime1;
var(Helicopter) float m_fHelicopterEntryTime2;
var(Helicopter) float m_fHelicopterEntryTime3;
var(Helicopter) float m_fHelicopterEntryTime4;
var(Helicopter) float m_fHelicopterLoganOnlyEntryTime;
var(Ladder) float m_fAttachTopLadder;
var(Ladder) float m_fAttachBottomLadder;
var(Ladder) float m_fDettachTopLadder;
var(Ladder) float m_fDettachBottomLadder;
var(Ladder) float m_fDettachTopEquipWeaponLadder;
var(Ladder) float m_fDettachBottomEquipWeaponLadder;
var(Ladder) float m_fDettachSlideLadder;
var(Ladder) float m_fStartSlideLadder;
var(Door) float m_fTcOpenDoor;
var(Door) float m_fTcOpenDoorClose;
var(Door) float m_fTcOpenDoorFar;
var(Door) float m_fDoorEntryTimes[16];
var(Door) float m_fDoorPickLockSendProtect;
var(Door) float m_fProtectTc;
var(Door) float m_fUnProtectTc;
var(Door) float m_fProtect;
var(Door) float m_fUnProtect;
var(Door) /*0x20000000-0x00000000*/ int m_iDefaultDoorOpeningDegree;
var(Door) float m_fDefaultDoorOpeningLength;
var(AIPeek) float m_fAIPeekTime;
var(AIPeek) float m_fAILookTime;
var(AIPeek) float m_fAIQuickLookTime;
var(AIPeek) float m_fMichaelPeekTime;
var(AIPeek) float m_fMichaelLookTime;
var(AIPeek) float m_fMichaelQuickLookTime;
var(Revive) float m_fRevive;
var(Windows) float m_fWindowTimerOpen;
var(Windows) float m_fWindowOpenLength;
var(Windows) float m_fWindowBreakLength;
var(Windows) float m_fWindowBreakTimer;
var(Windows) float m_fWindowBreakUnderLength;
var(Windows) float m_fWindowBreakUnderTimer;
var(AIGesture) float m_fAIGestureHold;
var(AIGesture) float m_fAIGestureNod;
var(AIGesture) float m_fAIGestureDeclineFwd;
var(AIGesture) float m_fAIGestureDeclineLeftRight;
var(AIGesture) float m_fAIGestureHeadDirFwd;
var(AIGesture) float m_fAIGestureHeadDirLeftRight;
var(AIGesture) float m_fAIGestureTapShoulderFwdRight;
var(AIGesture) float m_fAIGestureTapShoulderLeft;
var(AIGesture) float m_fAIGesturePointLeftRight;
var(AIGesture) float m_fAIGesturePointFwd;
var(AIGesture) float m_fAIGestureWave;
var(AIGesture) float m_fAIGestureArmBlendInPos;
var(AIGesture) float m_fAIGestureArmBlendOutPos;
var(AIGesture) float m_fAIGestureCharge;
var(AIGesture) float m_fAIGestureFlankLeft;
var(AIGesture) float m_fAIGestureFlankRight;
var(AIGesture) float m_fAIGestureHoldTerro;
var(AIGesture) float m_fAIGestureMoveLeft;
var(AIGesture) float m_fAIGestureMoveRight;
var(AIGesture) float m_fAIGesturePincer;
var(AIGesture) float m_fAIGestureRegroup;
var(AIGesture) float m_fAIGestureTerroPointFwd;
var(AIGesture) float m_fAIGestureTerroPointBwd;
var(AIGesture) float m_fAIGestureTerroPointRight;
var(AIGesture) float m_fAIGestureTerroPointLeft;
var(Replenish) float m_fReplenishCrateOpenLength;
var(Replenish) float m_fReplenishAnimLength;
var(Replenish) float m_fReplenishLeaveLength;
var(Replenish) float m_fReplenishStartLength;
var(Replenish) float m_fReplenishShowMenu;
var(Replenish) float m_fReplenishOpenShowMenu;
var(Refit) float m_fRefitStartUse;
var(Refit) float m_fRefitEndUse;
var(Incapacitate) float m_fIncapacitateLengthMikeFwd;
var(Incapacitate) float m_fIncapacitateLengthMikeLeft;
var(Incapacitate) float m_fIncapacitateLengthMikeRight;
var(Incapacitate) float m_fIncapacitateLengthMikeBwd;
var(Incapacitate) float m_fIncapacitateLengthMikeCrouchFwd;
var(Incapacitate) float m_fIncapacitateLengthMikeCrouchLeft;
var(Incapacitate) float m_fIncapacitateLengthMikeCrouchRight;
var(Incapacitate) float m_fIncapacitateLengthMikeCrouchBwd;
var(Incapacitate) float m_fRevivedLengthMikeFwd;
var(Incapacitate) float m_fRevivedLengthMikeLeft;
var(Incapacitate) float m_fRevivedLengthMikeRight;
var(Incapacitate) float m_fRevivedLengthMikeBwd;
var(Incapacitate) float m_fIncapacitateLengthJungFwd;
var(Incapacitate) float m_fIncapacitateLengthJungLeft;
var(Incapacitate) float m_fIncapacitateLengthJungRight;
var(Incapacitate) float m_fIncapacitateLengthJungBwd;
var(Incapacitate) float m_fIncapacitateLengthJungCrouchFwd;
var(Incapacitate) float m_fIncapacitateLengthJungCrouchLeft;
var(Incapacitate) float m_fIncapacitateLengthJungCrouchRight;
var(Incapacitate) float m_fIncapacitateLengthJungCrouchBwd;
var(Incapacitate) float m_fRevivedLengthJungFwd;
var(Incapacitate) float m_fRevivedLengthJungLeft;
var(Incapacitate) float m_fRevivedLengthJungRight;
var(Incapacitate) float m_fRevivedLengthJungBwd;
var(Incapacitate) float m_fReviveLength;
var(Incapacitate) float m_fIncapacitatedRandomInterval;
var(Incapacitate) float m_fIncapacitateLengthLoganFP;
var(Incapacitate) float m_fReviveLengthLoganFP;
var(Civilians) float m_fCivilRunFromDangerFront;
var(Civilians) float m_fCivilRunFromDangerBack;
var(Civilians) float m_fCivilRunFromDangerLeft;
var(Civilians) float m_fCivilRunFromDangerRight;
var(Civilians) float m_fCivilRunFromGunShotFront;
var(Civilians) float m_fCivilRunFromGunShotBack;
var(Civilians) float m_fCivilRunFromGunShotLeft;
var(Civilians) float m_fCivilRunFromGunShotRight;
var(Civilians) float m_fCivilReactToGunStand;
var(Civilians) float m_fCivilReactToGunCrouch;
var(Civilians) float m_fCivilReactToGunCower;
var(Civilians) float m_fCivilReactToGunKneel;
var(Civilians) float m_fCivilNormalToFear;
var(Civilians) float m_fCivilNormalToPanic;
var(Civilians) float m_fCivilNormalToHideWalkA;
var(Civilians) float m_fCivilNormalToHideRunA;
var(Civilians) float m_fCivilNormalToHideWalkB;
var(Civilians) float m_fCivilNormalToHideRunB;
var(Civilians) float m_fCivilFearToPanic;
var(Civilians) float m_fCivilPanicHideAToPanic;
var(Civilians) float m_fCivilPanicHideBToPanic;
var(Hostage) float m_fHostageCowerToKneel;
var(Hostage) float m_fHostageCowerToStand;
var(Hostage) float m_fHostageKneelToCower;
var(Hostage) float m_fHostageKneelToStand;
var(Hostage) float m_fHostageStandToCower;
var(Hostage) float m_fHostageStandToKneel;
var(Hostage) float m_fHostagePanicRunFwd;
var(Hostage) float m_fHostagePanicRunBack;
var(Hostage) float m_fHostagePanicRunLeft;
var(Hostage) float m_fHostagePanicRunRight;

defaultproperties
{
    m_fClimbOver=1.5667000
    m_fClimbOverUpTcLeft=0.9667000
    m_fClimbOverUpTcRight=0.9667000
    m_fClimbOverUpLeft=0.9667000
    m_fClimbOverUpRight=0.9667000
    m_fClimbOverUpFront=0.8000000
    m_fClimbOverDownLeft=1.0667000
    m_fClimbOverDownRight=1.2000000
    m_fClimbOverDownFront=1.0000000
    m_fClimbFPSkelControlActivation=0.5000000
    m_fClimbBlendOutAnimFP=0.5000000
    m_fClimbBlendOutAnimTP=0.5000000
    m_fClimbTimerEnableBarrelIKFP=0.5000000
    m_fAttachTopRappel=2.5000000
    m_fAttachBottomRappel=1.4300000
    m_fAttachWindowRappel=3.2000000
    m_fDettachTopRappel=3.5000000
    m_fDettachBottomRappel=1.0667000
    m_fInvertingRappel=1.4000000
    m_fDeinvertingRappel=1.6300000
    m_fKickdownStartRappel=0.4000000
    m_fBreachStartRappel=0.4000000
    m_fKickdownFinishRappel=1.3300000
    m_fBreachFinishRappel=1.8000000
    m_fDropWeaponDetachTopRappel=0.2500000
    m_fDropWeaponDetachBottomRappel=0.2000000
    m_fDropWeaponBreachRappel=0.2000000
    m_fEquipWeaponBreachRappel=0.5400000
    m_fEquipWeaponDettachTopRappel=2.3000000
    m_fEquipWeaponDettachBottomRappel=0.3000000
    m_fEquipWeaponAttachTopRappel=2.0000000
    m_fEquipWeaponAttachBottomRappel=1.0000000
    m_fEquipWeaponAttachWindowRappel=2.0000000
    m_fReadyToTcRappel=0.7000000
    m_fTcToReadyRappel=0.6700000
    m_fTcToDownRappel=0.7300000
    m_fTcToBfRappel=0.2000000
    m_fTcBfWait=1.0000000
    m_fAttachFastRope=1.8300000
    m_fAttachRappelToFastRope=1.8300000
    m_fAttachChopperLikeFastRope=1.1300000
    m_fDettachFastRope=1.7000000
    m_fStopFastRope=1.2000000
    m_fEquipWeaponDettachFastRope=1.2000000
    m_fDropWeaponRappelToFastRope=0.4000000
    m_fAttachHelicopterFastRopeHacker=1.7333000
    m_fAttachHelicopterFastRopeDemoGuy=2.0000000
    m_fAttachHelicopterFastRopeLogan=1.8667000
    m_fHelicopterEntryTime1=5.3000000
    m_fHelicopterEntryTime2=5.3000000
    m_fHelicopterEntryTime3=5.3000000
    m_fHelicopterEntryTime4=5.3000000
    m_fHelicopterLoganOnlyEntryTime=3.0000000
    m_fAttachTopLadder=2.1000000
    m_fAttachBottomLadder=1.3333300
    m_fDettachTopLadder=1.5333330
    m_fDettachBottomLadder=0.8000000
    m_fDettachTopEquipWeaponLadder=1.0000000
    m_fDettachBottomEquipWeaponLadder=0.3000000
    m_fDettachSlideLadder=0.8000000
    m_fStartSlideLadder=0.5300000
    m_fTcOpenDoor=1.5000000
    m_fTcOpenDoorClose=0.5666000
    m_fTcOpenDoorFar=0.5666000
    m_fDoorEntryTimes[0]=1.0000000
    m_fDoorEntryTimes[1]=2.2667000
    m_fDoorEntryTimes[2]=2.0000000
    m_fDoorEntryTimes[3]=1.7000000
    m_fDoorEntryTimes[4]=1.5667000
    m_fDoorEntryTimes[5]=2.0000000
    m_fDoorEntryTimes[6]=1.7667000
    m_fDoorEntryTimes[7]=2.0667000
    m_fDoorEntryTimes[8]=1.5667000
    m_fDoorEntryTimes[9]=1.6333000
    m_fDoorEntryTimes[10]=1.5667000
    m_fDoorEntryTimes[11]=1.5667000
    m_fDoorEntryTimes[12]=1.8000000
    m_fDoorEntryTimes[13]=1.0000000
    m_fDoorEntryTimes[14]=1.0000000
    m_fDoorEntryTimes[15]=1.0000000
    m_fDoorPickLockSendProtect=1.0000000
    m_fProtectTc=1.8333000
    m_fUnProtectTc=1.4667000
    m_fProtect=1.4667000
    m_fUnProtect=1.4667000
    m_iDefaultDoorOpeningDegree=31857
    m_fDefaultDoorOpeningLength=2.0000000
    m_fAIPeekTime=1.1667000
    m_fAILookTime=0.7000000
    m_fAIQuickLookTime=1.2000000
    m_fMichaelPeekTime=1.3000000
    m_fMichaelLookTime=0.9000000
    m_fMichaelQuickLookTime=1.4500000
    m_fRevive=3.0000000
    m_fWindowTimerOpen=0.4000000
    m_fWindowOpenLength=1.3000000
    m_fWindowBreakLength=1.0667000
    m_fWindowBreakTimer=0.4470000
    m_fAIGestureHold=1.4000000
    m_fAIGestureNod=1.2300000
    m_fAIGestureDeclineFwd=0.7000000
    m_fAIGestureDeclineLeftRight=1.0667000
    m_fAIGestureHeadDirFwd=0.9333000
    m_fAIGestureHeadDirLeftRight=0.8000000
    m_fAIGestureTapShoulderFwdRight=1.3000000
    m_fAIGestureTapShoulderLeft=1.4667000
    m_fAIGesturePointLeftRight=1.4300000
    m_fAIGesturePointFwd=1.2300000
    m_fAIGestureWave=1.3000000
    m_fAIGestureArmBlendInPos=0.2000000
    m_fAIGestureArmBlendOutPos=0.5000000
    m_fAIGestureCharge=2.2667000
    m_fAIGestureFlankLeft=1.8667000
    m_fAIGestureFlankRight=1.9333000
    m_fAIGestureHoldTerro=2.0000000
    m_fAIGestureMoveLeft=1.8000000
    m_fAIGestureMoveRight=1.7333000
    m_fAIGesturePincer=2.3330000
    m_fAIGestureRegroup=1.9333000
    m_fAIGestureTerroPointFwd=2.2000000
    m_fAIGestureTerroPointBwd=1.4000000
    m_fAIGestureTerroPointRight=2.0667000
    m_fAIGestureTerroPointLeft=1.6000000
    m_fReplenishCrateOpenLength=4.1333000
    m_fReplenishAnimLength=1.2667000
    m_fReplenishLeaveLength=2.2333000
    m_fReplenishStartLength=3.5333000
    m_fReplenishShowMenu=3.0000000
    m_fReplenishOpenShowMenu=1.0000000
    m_fRefitStartUse=1.0000000
    m_fRefitEndUse=1.0000000
    m_fIncapacitateLengthMikeFwd=1.3330000
    m_fIncapacitateLengthMikeLeft=1.1667000
    m_fIncapacitateLengthMikeRight=2.5000000
    m_fIncapacitateLengthMikeBwd=1.4000000
    m_fIncapacitateLengthMikeCrouchFwd=0.8333000
    m_fIncapacitateLengthMikeCrouchLeft=0.8667000
    m_fIncapacitateLengthMikeCrouchRight=2.2667000
    m_fIncapacitateLengthMikeCrouchBwd=1.0667000
    m_fRevivedLengthMikeFwd=2.9333000
    m_fRevivedLengthMikeLeft=2.8000000
    m_fRevivedLengthMikeRight=3.0667000
    m_fRevivedLengthMikeBwd=3.0000000
    m_fIncapacitateLengthJungFwd=2.4333000
    m_fIncapacitateLengthJungLeft=1.9000000
    m_fIncapacitateLengthJungRight=3.4000000
    m_fIncapacitateLengthJungBwd=2.2667000
    m_fIncapacitateLengthJungCrouchFwd=1.1333000
    m_fIncapacitateLengthJungCrouchLeft=0.8333000
    m_fIncapacitateLengthJungCrouchRight=2.0333000
    m_fIncapacitateLengthJungCrouchBwd=1.0333000
    m_fRevivedLengthJungFwd=2.9333000
    m_fRevivedLengthJungLeft=2.8000000
    m_fRevivedLengthJungRight=3.0667000
    m_fRevivedLengthJungBwd=3.0000000
    m_fReviveLength=3.8333000
    m_fIncapacitatedRandomInterval=5.0000000
    m_fIncapacitateLengthLoganFP=2.3330000
    m_fReviveLengthLoganFP=6.0000000
    m_fCivilRunFromDangerFront=2.4333000
    m_fCivilRunFromDangerBack=2.4667000
    m_fCivilRunFromDangerLeft=2.3667000
    m_fCivilRunFromDangerRight=3.0333000
    m_fCivilRunFromGunShotFront=1.3667000
    m_fCivilRunFromGunShotBack=1.3000000
    m_fCivilRunFromGunShotLeft=1.9667000
    m_fCivilRunFromGunShotRight=1.2667000
    m_fCivilReactToGunStand=2.1333000
    m_fCivilReactToGunCrouch=2.1333000
    m_fCivilReactToGunCower=2.1333000
    m_fCivilReactToGunKneel=2.1333000
    m_fCivilNormalToFear=2.2333000
    m_fCivilNormalToPanic=1.2667000
    m_fCivilNormalToHideWalkA=1.6333000
    m_fCivilNormalToHideRunA=1.3330000
    m_fCivilNormalToHideWalkB=1.9333000
    m_fCivilNormalToHideRunB=1.3330000
    m_fCivilFearToPanic=1.2000000
    m_fCivilPanicHideAToPanic=1.9000000
    m_fCivilPanicHideBToPanic=1.9000000
    m_fHostageCowerToKneel=3.6667000
    m_fHostageCowerToStand=3.5667000
    m_fHostageKneelToCower=1.1333000
    m_fHostageKneelToStand=2.8667000
    m_fHostageStandToCower=2.1333000
    m_fHostageStandToKneel=2.4000000
    m_fHostagePanicRunFwd=1.3333000
    m_fHostagePanicRunBack=1.6333000
    m_fHostagePanicRunLeft=1.6000000
    m_fHostagePanicRunRight=1.5333000
}