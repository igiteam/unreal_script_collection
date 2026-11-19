class TurokPawnDiloNative extends TurokPawnDino
    abstract
    native
    config(Game)
    hidecategories(Navigation);

var @NULL mPOVMeleeGraphSet;
var bool mbPerformCameraCollision;
var bool mbRepositionPlayerKillToSafeLocation;
var bool mbIsCoOpGame;

function EnableMaulSmashDamage()
{
    ActivateSkeletalHurt(8, 0.0000000, 40.0000000, 1.0000000, -1.0000000, false, true, 1.0000000);
    //return;    
}

defaultproperties
{
    // Reference: TurokRadialShakeComponent'Default__TurokPawnDiloNative.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    // Reference: TurokAISteer'Default__TurokPawnDiloNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnDiloNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnDiloNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnDiloNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnDiloNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnDiloNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mRecoveryPlaneJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    mSkeletalHurt=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnDiloNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnDiloNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnDiloNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnDiloNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnDiloNative.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=TurokAISteerComponent
    Components[3]=TurokAIPlannerComponent
    Components[4]=TurokPathControllerComponent
    Components[5]=TurokTargetingSystemComponent
    Components[6]=MyLightEnvironment
    Components[7]=TurokSkeletalMeshComponent
    Components[8]=TurokSoundControllerComponent
    Components[9]=ladderController
    CollisionComponent=CollisionCylinder
}