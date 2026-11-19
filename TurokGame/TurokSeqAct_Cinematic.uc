class TurokSeqAct_Cinematic extends SeqAct_Latent
    native
    hidecategories(Object);

enum ECinematicCameraMode
{
    CINEMATICCAMERA_None,           // 0
    CINEMATICCAMERA_First,          // 1
    CINEMATICCAMERA_Third,          // 2
    CINEMATICCAMERA_MAX             // 3
};

enum ECinematicState
{
    CINEMATIC_Positioning,          // 0
    CINEMATIC_PreAnimating,         // 1
    CINEMATIC_Animating,            // 2
    CINEMATIC_PostAnimating,        // 3
    CINEMATIC_Done,                 // 4
    CINEMATIC_MAX                   // 5
};

struct native CinematicPawn
{
    var @NULL mContainer;
    var @NULL mPawn;
    var byte mPhysics;
    var bool mbSpawned;
    var @NULL mStartPosition;
    var @NULL mStartRotation;
    var @NULL mAnimSequence;
    var byte mCurrentState;
    var float mPositionBlendStartTime;
    var @NULL mPositionBlendStartPosition;
    var float mRotationBlendStartTime;
    var @NULL mRotationBlendStartRotation;

    structdefaultproperties
    {
        mContainer=(AnimSet=none,AnimSeqName="None",CastId="None",Mesh=none,HeadMesh=none,HeadMorphSet=none,PhysicsAsset=none,PawnClassName="None",RootPos=(X=0.0000000,Y=0.0000000,Z=0.0000000),RootRot=(Pitch=0,Yaw=0,Roll=0),RootScale=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        mPawn=none
        mPhysics=0
        mbSpawned=false
        mStartPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mStartRotation=(Pitch=0,Yaw=0,Roll=0)
        mAnimSequence=none
        mCurrentState=0
        mPositionBlendStartTime=0.0000000
        mPositionBlendStartPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mRotationBlendStartTime=0.0000000
        mRotationBlendStartRotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct native CinematicMesh
{
    var @NULL mContainer;
    var @NULL mMesh;
    var byte mCurrentState;

    structdefaultproperties
    {
        mContainer=(AnimSet=none,AnimSeqName="None",CastId="None",Mesh=none,HeadMesh=none,HeadMorphSet=none,PhysicsAsset=none,PawnClassName="None",RootPos=(X=0.0000000,Y=0.0000000,Z=0.0000000),RootRot=(Pitch=0,Yaw=0,Roll=0),RootScale=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        mMesh=none
        mCurrentState=0
    }
};

struct native CinematicCamera
{
    var @NULL mPlayerController;
    var @NULL mPlayerPawn;
    var @NULL mPlayerCamera;
    var @NULL mCameraActor;
    var @NULL mCameraAnimSequence;
    var @NULL mStartPosition;
    var @NULL mStartRotation;
    var byte mCurrentState;
    var float mPositionBlendStartTime;
    var float mPositionBlendBlendTime;
    var @NULL mPositionBlendStartPosition;
    var @NULL mPositionBlendEndPosition;
    var float mRotationBlendStartTime;
    var float mRotationBlendBlendTime;
    var @NULL mRotationBlendStartRotation;
    var @NULL mRotationBlendEndRotation;

    structdefaultproperties
    {
        mPlayerController=none
        mPlayerPawn=none
        mPlayerCamera=none
        mCameraActor=none
        mCameraAnimSequence=none
        mStartPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mStartRotation=(Pitch=0,Yaw=0,Roll=0)
        mCurrentState=0
        mPositionBlendStartTime=0.0000000
        mPositionBlendBlendTime=0.0000000
        mPositionBlendStartPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mPositionBlendEndPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mRotationBlendStartTime=0.0000000
        mRotationBlendBlendTime=0.0000000
        mRotationBlendStartRotation=(Pitch=0,Yaw=0,Roll=0)
        mRotationBlendEndRotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

var @NULL mCinematicAnchor;
var @NULL mCinematicAsset;
var byte mCameraMode;
var byte mCurrentState;
var float mCurrentTime;
var array mCinematicPawns;
var array mCinematicMeshes;
var @NULL mCinematicCamera;
var @NULL mPositionSpline;
var(Splines) array mPositionSplinePoints;
var @NULL mRotationSpline;
var(Splines) array mRotationSplinePoints;
var @NULL mVelocitySpline;
var(Splines) array mVelocitySplinePoints;
var(PawnBlend) bool mbPawnTeleport;
var(CameraBlend) bool mbCameraTeleport;
var() bool mbLoopAnimation;
var(PawnBlend) float mPawnPositionBlendStartDistance;
var(PawnBlend) float mPawnPositionBlendBlendTime;
var(PawnBlend) float mPawnRotationBlendStartDistance;
var(PawnBlend) float mPawnRotationBlendBlendTime;
var(PawnBlend) float mPawnVelocityBlendStartDistance;
var(CameraBlend) float mCameraPositionBlendStartDistance;
var(CameraBlend) float mCameraPositionBlendBlendTime;
var(CameraBlend) float mCameraRotationBlendStartDistance;
var(CameraBlend) float mCameraRotationBlendBlendTime;
var(AnimationBlend) float mAnimationBlendInBlendTime;
var(AnimationBlend) float mAnimationBlendOutBlendTime;

defaultproperties
{
    // Reference: TurokCubicSpline'Default__TurokSeqAct_Cinematic.PositionSpline'
    begin object name=PositionSpline class=Class'TurokEngine.TurokCubicSpline'
    end object
    mPositionSpline=PositionSpline
    mPositionSplinePoints=/* Array type was not detected. */
    // Reference: TurokCubicSpline'Default__TurokSeqAct_Cinematic.RotationSpline'
    begin object name=RotationSpline class=Class'TurokEngine.TurokCubicSpline'
    end object
    mRotationSpline=RotationSpline
    mRotationSplinePoints=/* Array type was not detected. */
    // Reference: TurokCubicSpline'Default__TurokSeqAct_Cinematic.VelocitySpline'
    begin object name=VelocitySpline class=Class'TurokEngine.TurokCubicSpline'
    end object
    mVelocitySpline=VelocitySpline
    mVelocitySplinePoints=/* Array type was not detected. */
    mPawnPositionBlendStartDistance=50.0000000
    mPawnPositionBlendBlendTime=0.5000000
    mPawnRotationBlendStartDistance=100.0000000
    mPawnRotationBlendBlendTime=1.0000000
    mPawnVelocityBlendStartDistance=200.0000000
    mCameraPositionBlendStartDistance=50.0000000
    mCameraPositionBlendBlendTime=0.5000000
    mCameraRotationBlendStartDistance=100.0000000
    mCameraRotationBlendBlendTime=1.0000000
    mAnimationBlendInBlendTime=0.3300000
    mAnimationBlendOutBlendTime=0.3300000
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Data",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Cinematic"
    ObjCategory="Turok Cinema"
}