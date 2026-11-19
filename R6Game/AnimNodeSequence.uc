class AnimNodeSequence extends AnimNode
    native
    hidecategories(Object,Object);

var(Display) bool bShowTimeLineSlider;
var(AnimLeaf) AnimLeaf m_AnimLeaf;
var transient bool m_bPostEditChangeCalled;

// Export UAnimNodeSequence::execSetAnim(FFrame&, void* const)
native function SetAnim(name Sequence, optional bool bIsScripted);

// Export UAnimNodeSequence::execPlayAnim(FFrame&, void* const)
native function PlayAnim(optional bool bLoop, optional float inRate, optional float StartTime);

// Export UAnimNodeSequence::execStartAnim(FFrame&, void* const)
native function StartAnim(optional float fStartTime, optional bool bAbsoluteTime);

// Export UAnimNodeSequence::execStopAnim(FFrame&, void* const)
native function StopAnim();

// Export UAnimNodeSequence::execIsPlaying(FFrame&, void* const)
native function bool IsPlaying();

// Export UAnimNodeSequence::execSetPosition(FFrame&, void* const)
native function SetPosition(float NewTime, bool bFireNotifies, optional bool bSendInTick);

// Export UAnimNodeSequence::execSetRootMotion(FFrame&, void* const)
native function SetRootMotion(int iAxis, R6EngineEnums.ERootMotion ERootMotion);

// Export UAnimNodeSequence::execSetNoFailCollision(FFrame&, void* const)
native function SetNoFailCollision(bool bVal);

defaultproperties
{
    m_AnimLeaf=(m_pVTable=none,m_AnimSeqName="None",m_AnimSeq=none,m_AnimSeqCrouch=none,m_u8AnimLinkupIndex=0,m_u8AnimLinkupIndexCrouch=0,m_fNodeTotalWeight=0.0000000,m_iNodeTickStatus=0,m_fCurrentTime=0.0000000,m_fRate=1.0000000,m_bPlaying=false,m_bLooping=false,m_bReverse=false,m_bNoInterpolate=false,m_bIsIssuingNotifies=false,m_bHalfCycleDelay=false,m_bSlaveLeaf=false,m_bCOMReference=false,m_bUseCrouchAnimWhenCrouched=false,m_bIsAdditiveAnimation=false,m_bRotateYawFromRoot=false,m_bDiscardRootYaw=false,m_bConstrainRootMotion=false,m_bAllowRootBlendWithAllAnim=false,m_bNoCollisionFail=false,m_bStartRootAtZeroAlways=false,m_eRootMotion=0,m_eRootMotion[1]=0,m_eRootMotion[2]=0,m_vOldRootLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_vFirstFrameRootLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_rFirstFrameRootRot=(Pitch=0,Yaw=0,Roll=0),m_mOriginalLocalToWorld=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),m_iOldRootYaw=0,m_iLastOldRootTranslateTick=0,m_iLastOldRootRotateTick=0,m_iPlayRootMotionTicks=0,m_bNeedsRootMotionReset=false,m_bInitialReverse=false,m_bFirstInit=false,m_bShowDebugTick=false,m_fDebugHeight=0.0000000,m_eAnimSyncType=0,m_fNotifyWeightThreshold=0.0001000,m_NotifiesToIssue=none)
    m_bIsAnimNodeSequence=true
}