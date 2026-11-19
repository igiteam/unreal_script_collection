class TurokPawnPlantDevilFangNative extends TurokPawnPlant
    abstract
    native
    config(Pawn)
    hidecategories(Navigation);

var(DevilFang) float mHurtRadiusRange;
var(DevilFang) float mHurtRadiusDamage;
var(DevilFang) float mMaxDamageScale;
var(DevilFang) float ProjectUpVectorRatio;
var(DevilFang) @NULL mExplosionTemplate;
var(DevilFang) float mWobbleScale;
var(DevilFang) float mWobbleTime;
var(DevilFang) float mDampScale;
var float mHitCurrentTime;
var float mDamageScaleIncrement;
var float mCurrentScale;
var int mMaxQuillProjectiles;

// Export UTurokPawnPlantDevilFangNative::execCanHurt(FFrame&, void* const)
native function bool CanHurt(@NULL Other, optional class<Class> DamageType);

defaultproperties
{
    // Reference: TurokAISteer'Default__TurokPawnPlantDevilFangNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnPlantDevilFangNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnPlantDevilFangNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnPlantDevilFangNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnPlantDevilFangNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnPlantDevilFangNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnPlantDevilFangNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnPlantDevilFangNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnPlantDevilFangNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnPlantDevilFangNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnPlantDevilFangNative.Arrow'
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