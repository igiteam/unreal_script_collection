class R6AnimNodeBlendPawnReaction extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

struct PawnReactAnim
{
    var AnimLeaf m_Anim;
    var float m_fWeight;
    var float m_fWeightLower;
    var float m_fScale;

    structdefaultproperties
    {
        m_Anim=(m_pVTable=none,m_AnimSeqName="None",m_AnimSeq=none,m_AnimSeqCrouch=none,m_u8AnimLinkupIndex=0,m_u8AnimLinkupIndexCrouch=0,m_fNodeTotalWeight=0.0000000,m_iNodeTickStatus=0,m_fCurrentTime=0.0000000,m_fRate=0.0000000,m_bPlaying=false,m_bLooping=false,m_bReverse=false,m_bNoInterpolate=false,m_bIsIssuingNotifies=false,m_bHalfCycleDelay=false,m_bSlaveLeaf=false,m_bCOMReference=false,m_bUseCrouchAnimWhenCrouched=false,m_bIsAdditiveAnimation=false,m_bRotateYawFromRoot=false,m_bDiscardRootYaw=false,m_bConstrainRootMotion=false,m_bAllowRootBlendWithAllAnim=false,m_bNoCollisionFail=false,m_bStartRootAtZeroAlways=false,m_eRootMotion=0,m_eRootMotion[1]=0,m_eRootMotion[2]=0,m_vOldRootLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_vFirstFrameRootLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000),m_rFirstFrameRootRot=(Pitch=0,Yaw=0,Roll=0),m_mOriginalLocalToWorld=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),m_iOldRootYaw=0,m_iLastOldRootTranslateTick=0,m_iLastOldRootRotateTick=0,m_iPlayRootMotionTicks=0,m_bNeedsRootMotionReset=false,m_bInitialReverse=false,m_bFirstInit=false,m_bShowDebugTick=false,m_fDebugHeight=0.0000000,m_eAnimSyncType=0,m_fNotifyWeightThreshold=0.0000000,m_NotifiesToIssue=none)
        m_fWeight=0.0000000
        m_fWeightLower=0.0000000
        m_fScale=0.0000000
    }
};

var transient array<PawnReactAnim> m_Reactions;
var transient array<PawnReactAnim> m_ReactionsAdd;
var transient float m_fOutWeight;
var transient float m_fOutWeightLower;
var transient float m_fBlendTime;
var transient float m_fBlendTimeLower;
var transient bool m_bOutActive;
var transient bool m_bReactionOnLower;

defaultproperties
{
    m_fOutWeight=1.0000000
    m_fOutWeightLower=1.0000000
    m_bOutActive=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}