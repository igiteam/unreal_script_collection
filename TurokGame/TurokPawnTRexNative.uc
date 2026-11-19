class TurokPawnTRexNative extends TurokPawnDino
    abstract
    native
    config(Pawn)
    hidecategories(Navigation);

const mNumPursuitAttacks = 3;

var @NULL mPOVMeleeGraphSet;
var @NULL mPursuitAttackGraphSet;
var @NULL mPursuitAttackAsset[3];
var name mPursuitAttackControllerName[3];
var bool mRoarAndAttack;
var bool mbUseStationaryAttack;
var bool mbCanLoseLOS;
var bool mbCanBeStunned;
var bool mbRepositionPlayerKillToSafeLocation;
var float mNormalPeripheral;
var float mInvestigatePeripheral;
var() config float mStunHealth;
var array mPlayerKillSafeLocation;
var array mPlayerKillSafePlayerLocation;
var array mPlayerKillSafeYaw;

function EnableSmashDamage()
{
    ActivateSkeletalHurt(5, 25.0000000, 130.0000000, Mass, -1.0000000, true, true, 0.5000000);
    //return;    
}

function EnableSmashDamageNoKnockdown()
{
    ActivateSkeletalHurt(5, 0.0000000, 120.0000000, Mass, -1.0000000, false, true, 0.5000000);
    //return;    
}

simulated function RevealDamageTexture(int Damage, class<Class> DamageType)
{
    local float MaterialDamage;
    local int MaterialInstanceIndex;

    MaterialInstanceIndex = 0;
    J0x07:

    // End:0x99 [Loop If]
    if(MaterialInstanceIndex < mMaterialInstances.Length)
    {
        // End:0x8F
        if((mMaterialInstances[MaterialInstanceIndex] != none) && mMaterialInstances[MaterialInstanceIndex].GetScalarParameterValue('DmgdReveal', MaterialDamage))
        {
            // End:0x8F
            if(Mesh.SkeletalMesh == mGoreSkeletalMesh)
            {
                mMaterialInstances[MaterialInstanceIndex].SetScalarParameterValue('DmgdReveal', mGibDamageRevealLevel);
            }
        }
        ++MaterialInstanceIndex;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super(TurokPawn).PostBeginPlay();
    mFootStompCamShake.mParams.mRollAmplitude = 1.0000000;
    mFootStompCamShake.mParams.mRollFrequency = 5.0000000;
    mFootStompCamShake.mParams.mPitchAmplitude = 1.0000000;
    mFootStompCamShake.mParams.mPitchFrequency = 7.0000000;
    mFootStompCamShake.mParams.mYawAmplitude = 1.0000000;
    mFootStompCamShake.mParams.mYawFrequency = 10.0000000;
    mFootStompCamShake.mParams.mXAmplitude = 2.0000000;
    mFootStompCamShake.mParams.mXFrequency = 2.0000000;
    mFootStompCamShake.mParams.mYAmplitude = 2.0000000;
    mFootStompCamShake.mParams.mYFrequency = 2.0000000;
    mFootStompCamShake.mParams.mZAmplitude = 5.0000000;
    mFootStompCamShake.mParams.mZFrequency = 1.0000000;
    EnableSmashDamage();
    //return;    
}

// Export UTurokPawnTRexNative::execCheckActionValidEndLocation(FFrame&, void* const)
native function bool CheckActionValidEndLocation();

event Bump(@NULL Other, @NULL HitNormal)
{
    super(Actor).Bump(Other, HitNormal);
    // End:0x5B
    if(TurokDestroyableActor(Other) != none)
    {
        Other.TakeDamage(100, Controller, Other.Location, vect(0.0000000, 0.0000000, 0.0000000), none);        
    }
    else
    {
        // End:0xB4
        if(TurokPawnMiniGunAutoTurretNative(Other) != none)
        {
            Other.TakeDamage(Pawn(Other).Health, Controller, Other.Location, vect(0.0000000, 0.0000000, 0.0000000), none);
        }
    }
    //return;    
}

// Export UTurokPawnTRexNative::execCanHurt(FFrame&, void* const)
native function bool CanHurt(@NULL Other, optional class<Class> DamageType);

state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        DeActivateSkeletalHurt(5);
        //return;        
    }
    stop;    
}

defaultproperties
{
    mbUseStationaryAttack=true
    mbCanLoseLOS=true
    mNormalPeripheral=0.4200000
    mFootStompCamShakeEnable=true
    // Reference: TurokRadialShakeComponent'Default__TurokPawnTRexNative.Shakey'
    begin object name=Shakey
        Duration=0.6000000
        Radius=2500.0000000
        mParams=(mRollAmplitude=0.0000000,mRollFrequency=0.0000000,mPitchAmplitude=1.0000000,mYawAmplitude=1.0000000,mXAmplitude=1.0000000,mXFrequency=1.0000000,mYAmplitude=1.0000000,mYFrequency=1.0000000,mZAmplitude=1.0000000,mZFrequency=1.0000000)
    end object
    mFootStompCamShake=Shakey
    mFlareTargetDist=400.0000000
    // Reference: TurokAISteer'Default__TurokPawnTRexNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnTRexNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnTRexNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mbDoFullPathSkipCheck=true
    mbSkelHurtTraceAllComponents=true
    // Reference: TurokPathController'Default__TurokPawnTRexNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnTRexNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnTRexNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    mSkeletalHurt=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnTRexNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnTRexNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnTRexNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnTRexNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnTRexNative.Arrow'
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