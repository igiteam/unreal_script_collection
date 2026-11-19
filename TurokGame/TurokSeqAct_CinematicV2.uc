class TurokSeqAct_CinematicV2 extends SeqAct_Latent
    native
    hidecategories(Object);

enum ECinematicStateV2
{
    CS_Positioning,                 // 0
    CS_Waiting,                     // 1
    CS_Animating,                   // 2
    CS_Releasing,                   // 3
    CS_Done,                        // 4
    CS_Released,                    // 5
    CS_MAX                          // 6
};

enum ECinematicCameraType
{
    CCT_None,                       // 0
    CCT_First,                      // 1
    CCT_Third,                      // 2
    CCT_MAX                         // 3
};

struct native MeshAnimSetContainer
{
    var() @NULL AnimSet;
    var() name AnimSeqName;
    var() name CastId;
    var() @NULL Mesh;
    var() @NULL HeadMesh;
    var() @NULL HeadMorphSet;
    var() @NULL PhysicsAsset;
    var() name PawnClassName;
    var() @NULL RootPos;
    var() @NULL RootRot;
    var() @NULL RootScale;

    structdefaultproperties
    {
        AnimSet=none
        AnimSeqName="None"
        CastId="None"
        Mesh=none
        HeadMesh=none
        HeadMorphSet=none
        PhysicsAsset=none
        PawnClassName="None"
        RootPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RootRot=(Pitch=0,Yaw=0,Roll=0)
        RootScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    }
};

struct native CinematicActorDefaultSettings
{
    var() bool mbCanPreSpawn;
    var() bool mbGodMode;
    var() bool mbEnableImpactAnims;
    var() bool mbNoPositioning;
    var() bool mbTeleport;
    var() float mDesiredSpeed;
    var() float mRotationBlendDistance;
    var() float mVelocityBlendDistance;
    var() bool mbWaitingHoldFirstFrame;
    var() float mAnimationBlendTime;
    var() bool mbAnimationLooping;
    var() bool mbExitForceToGround;
    var() bool mbExitToLocomotion;
    var() float mLocomotionBlendTime;
    var() float mLocomotionSpeed;
    var() float mLocomotionPhase;
    var() float mLocomotionRelMoveAngle;
    var() bool mbExitToRagDoll;

    structdefaultproperties
    {
        mbCanPreSpawn=false
        mbGodMode=true
        mbEnableImpactAnims=false
        mbNoPositioning=false
        mbTeleport=true
        mDesiredSpeed=1.0000000
        mRotationBlendDistance=100.0000000
        mVelocityBlendDistance=200.0000000
        mbWaitingHoldFirstFrame=false
        mAnimationBlendTime=0.0000000
        mbAnimationLooping=false
        mbExitForceToGround=false
        mbExitToLocomotion=true
        mLocomotionBlendTime=0.3300000
        mLocomotionSpeed=1.0000000
        mLocomotionPhase=0.0000000
        mLocomotionRelMoveAngle=0.0000000
        mbExitToRagDoll=false
    }
};

struct native CinematicActorSettings
{
    var() name mCastId;
    var() bool mbExclude;
    var() bool mbUseCanPreSpawn;
    var() bool mbCanPreSpawn;
    var() bool mbMeshActor;
    var() class<Class> mPawnActorType;
    var() export editinline @NULL mPawnActorFactory;
    var() float mDrawScale;
    var() bool mbDisableShadows;
    var() bool mbUseLowerLOD;
    var() bool mbUseAutoLOD;
    var() bool mbUseGodMode;
    var() bool mbGodMode;
    var() bool mbUseEnableImpactAnims;
    var() bool mbEnableImpactAnims;
    var() bool mbUseNoPositioning;
    var() bool mbNoPositioning;
    var() bool mbUseTeleport;
    var() bool mbTeleport;
    var() bool mbUseDesiredSpeed;
    var() float mDesiredSpeed;
    var() bool mbUseRotationBlendDistance;
    var() float mRotationBlendDistance;
    var() bool mbUseVelocityBlendDistance;
    var() float mVelocityBlendDistance;
    var() bool mbUseWaitingHoldFirstFrame;
    var() bool mbWaitingHoldFirstFrame;
    var() bool mbUseWaitingAnimation;
    var() name mWaitingAnimationName;
    var() @NULL mWaitingAnimationAnimSet;
    var() float mWaitingAnimationBlendTime;
    var() bool mbUseAnimationBlendTime;
    var() float mAnimationBlendTime;
    var() bool mbUseExitForceToGround;
    var() bool mbExitForceToGround;
    var() bool mbUseExitToLocomotion;
    var() bool mbExitToLocomotion;
    var() bool mbUseLocomotionParameters;
    var() float mLocomotionBlendTime;
    var() float mLocomotionSpeed;
    var() float mLocomotionPhase;
    var() float mLocomotionRelMoveAngle;
    var() bool mbExitToTransitionGraph;
    var() @NULL mTransitionGraphSet;
    var() name mTransitionGraphName;
    var() bool mbUseExitToRagDoll;
    var() bool mbExitToRagDoll;

    structdefaultproperties
    {
        mCastId="None"
        mbExclude=false
        mbUseCanPreSpawn=false
        mbCanPreSpawn=false
        mbMeshActor=false
        mPawnActorType=none
        mPawnActorFactory=none
        mDrawScale=0.0000000
        mbDisableShadows=false
        mbUseLowerLOD=false
        mbUseAutoLOD=false
        mbUseGodMode=false
        mbGodMode=false
        mbUseEnableImpactAnims=false
        mbEnableImpactAnims=false
        mbUseNoPositioning=false
        mbNoPositioning=false
        mbUseTeleport=false
        mbTeleport=false
        mbUseDesiredSpeed=false
        mDesiredSpeed=0.0000000
        mbUseRotationBlendDistance=false
        mRotationBlendDistance=0.0000000
        mbUseVelocityBlendDistance=false
        mVelocityBlendDistance=0.0000000
        mbUseWaitingHoldFirstFrame=false
        mbWaitingHoldFirstFrame=false
        mbUseWaitingAnimation=false
        mWaitingAnimationName="None"
        mWaitingAnimationAnimSet=none
        mWaitingAnimationBlendTime=0.0000000
        mbUseAnimationBlendTime=false
        mAnimationBlendTime=0.0000000
        mbUseExitForceToGround=false
        mbExitForceToGround=false
        mbUseExitToLocomotion=false
        mbExitToLocomotion=false
        mbUseLocomotionParameters=false
        mLocomotionBlendTime=0.0000000
        mLocomotionSpeed=0.0000000
        mLocomotionPhase=0.0000000
        mLocomotionRelMoveAngle=0.0000000
        mbExitToTransitionGraph=false
        mTransitionGraphSet=none
        mTransitionGraphName="None"
        mbUseExitToRagDoll=false
        mbExitToRagDoll=false
    }
};

struct native CinematicActor
{
    var native @NULL mContainer;
    var native @NULL mSettings;
    var @NULL mActor;
    var bool mbSpawned;
    var bool mbDestroy;
    var byte mCurrentState;
    var byte mPhysics;
    var bool mbEnableImpactAnims;
    var bool mbGodMode;
    var export editinline @NULL mCollisionComponent;
    var @NULL mStartPosition;
    var @NULL mStartRotation;
    var @NULL mAnimSequence;

    structdefaultproperties
    {
        mActor=none
        mbSpawned=false
        mbDestroy=false
        mCurrentState=0
        mPhysics=0
        mbEnableImpactAnims=false
        mbGodMode=false
        mCollisionComponent=none
        mStartPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mStartRotation=(Pitch=0,Yaw=0,Roll=0)
        mAnimSequence=none
    }
};

struct native CinematicCameraFirstSettings
{
    var() bool mbTeleport;
    var() bool mbFixPosition;
    var() float mBlendTime;
    var() float mBlendDistance;
    var() float mDesiredSpeed;

    structdefaultproperties
    {
        mbTeleport=true
        mbFixPosition=false
        mBlendTime=1.0000000
        mBlendDistance=100.0000000
        mDesiredSpeed=1.0000000
    }
};

struct native CinematicCameraThirdSettings
{
    var() bool mbTeleport;
    var() bool mbFixPosition;
    var() float mBlendTime;

    structdefaultproperties
    {
        mbTeleport=true
        mbFixPosition=false
        mBlendTime=1.0000000
    }
};

struct native CinematicCameraV2
{
    var byte mType;
    var bool mbTeleport;
    var bool mbFixPosition;
    var float mBlendTime;
    var float mBlendDistance;
    var float mDesiredSpeed;
    var @NULL mPlayerController;
    var bool mbGodMode;
    var @NULL mPlayerPawn;
    var @NULL mPlayerCamera;
    var @NULL mActor;
    var @NULL mAnimSequence;
    var float mBlendStartTime;
    var @NULL mBlendStartPosition;
    var @NULL mBlendEndPosition;
    var @NULL mBlendStartRotation;
    var @NULL mBlendEndRotation;
    var float mBlendStartFov;
    var float mBlendEndFov;
    var byte mCurrentState;
    var @NULL mBlendPosition;
    var @NULL mBlendRotation;
    var float mBlendFov;

    structdefaultproperties
    {
        mType=0
        mbTeleport=false
        mbFixPosition=false
        mBlendTime=0.0000000
        mBlendDistance=0.0000000
        mDesiredSpeed=0.0000000
        mPlayerController=none
        mbGodMode=false
        mPlayerPawn=none
        mPlayerCamera=none
        mActor=none
        mAnimSequence=none
        mBlendStartTime=0.0000000
        mBlendStartPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBlendEndPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBlendStartRotation=(Pitch=0,Yaw=0,Roll=0)
        mBlendEndRotation=(Pitch=0,Yaw=0,Roll=0)
        mBlendStartFov=0.0000000
        mBlendEndFov=0.0000000
        mCurrentState=0
        mBlendPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBlendRotation=(Pitch=0,Yaw=0,Roll=0)
        mBlendFov=0.0000000
    }
};

var() @NULL mCinematicAsset;
var() @NULL mDefaultActorSettings;
var() array mPerActorSettings;
var() byte mCameraType;
var byte mCurrentState;
var() @NULL mCameraFirstSettings;
var() @NULL mCameraThirdSettings;
var() bool mbHideWeapons;
var() bool mbHideHud;
var() bool mbClearHitReactionFX;
var() bool mbKillSoundOnExit;
var() bool mbSuspendGarbageCollection;
var() bool mbReactivateWeaponsWhenFinished;
var bool mbActivated;
var bool mbPreSpawning;
var bool mbSkippable;
var bool mbSkipped;
var bool mbTurokInScene;
var @NULL mCinematicAnchorPosition;
var @NULL mCinematicAnchorRotation;
var array mCinematicActors;
var @NULL mCinematicCamera;
var @NULL mHud;
var export editinline @NULL mHitReactionManager;
var float mCurrentTime;
var float mDeltaTime;

defaultproperties
{
    mDefaultActorSettings=(mbCanPreSpawn=false,mbGodMode=true,mbEnableImpactAnims=false,mbNoPositioning=false,mbTeleport=true,mDesiredSpeed=1.0000000,mRotationBlendDistance=100.0000000,mVelocityBlendDistance=200.0000000,mbWaitingHoldFirstFrame=false,mAnimationBlendTime=0.0000000,mbAnimationLooping=false,mbExitForceToGround=false,mbExitToLocomotion=true,mLocomotionBlendTime=0.3300000,mLocomotionSpeed=1.0000000,mLocomotionPhase=0.0000000,mLocomotionRelMoveAngle=0.0000000,mbExitToRagDoll=false)
    mCameraFirstSettings=(mbTeleport=true,mbFixPosition=false,mBlendTime=1.0000000,mBlendDistance=100.0000000,mDesiredSpeed=1.0000000)
    mCameraThirdSettings=(mbTeleport=true,mbFixPosition=false,mBlendTime=1.0000000)
    mbHideWeapons=true
    mbClearHitReactionFX=true
    mbReactivateWeaponsWhenFinished=true
    InputLinks[0]=(LinkDesc="Pre-Spawn",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Abort",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Skipped",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Anchor",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Lights",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="Skippable",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjClassVersion=3
    ObjName="Cinematic V2"
    ObjCategory="Turok Cinema"
}