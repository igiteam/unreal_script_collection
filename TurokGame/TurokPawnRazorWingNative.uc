class TurokPawnRazorWingNative extends TurokPawn
    abstract
    native
    config(Pawn)
    hidecategories(Navigation);

var @NULL mMotionGraphSet;
var @NULL mAttackGraphSet;
var(RazorWingAttack) config float mAttackRange;
var(RazorWingAttack) config float mMeleeAttackPercent;
var(RazorWingAttack) config float mSingleAttackPercent;
var(RazorWingAttack) config float mPlayerThreatTweak;
var(RazorWingHover) config int mIdleHoverPoints;
var(RazorWingHover) config int mAttackHoverPoints;
var(RazorWingHover) config float mHoverDelay;
var(RazorWingHover) config float mHoverPause;
var(ParticleEffects) @NULL mDeadParticleSystem;
var @NULL mHairController;
var class<Class> mProjectileClass;
var @NULL mBuzzSndCue;

// Export UTurokPawnRazorWingNative::execGetNearByRandomNode(FFrame&, void* const)
native function @NULL GetNearByRandomNode(@NULL Nav);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    mHairController = TurokSkelControlHair(Mesh.FindSkelControl('RazorWingHairController'));
    PlayAmbientSound();
    //return;    
}

simulated function bool ArrowCanStickInto()
{
    return false;
    //return ReturnValue;    
}

simulated event @NULL ProjectileFire(@NULL Enemy)
{
    local @NULL AimDir, RealStartLoc, Target, SpawnedProjectile;
    local float dist, Time, loft, d0, V, S,
	    vvss, dotVR, term1, term2, time1,
	    time2;

    local @NULL V0, R0;

    loft = 0.0000000;
    // End:0x2AE
    if((int(Role) == int(ROLE_Authority)) && Enemy != none)
    {
        RealStartLoc = Mesh.GetBoneLocation('jt_Aux1_C');
        Target = Enemy.Mesh.GetBoneLocation('jt_Cog_C');
        SpawnedProjectile = __NFUN_278__(mProjectileClass, self, 'RWFire', RealStartLoc);
        // End:0x2A8
        if(((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe) && SpawnedProjectile.Speed > 0.0000000)
        {
            d0 = VSize(RealStartLoc - Target);
            V = VSize(Enemy.Velocity);
            S = SpawnedProjectile.Speed;
            V0 = Enemy.Velocity;
            R0 = Target - RealStartLoc;
            dotVR = V0 Dot R0;
            vvss = (V * V) - (S * S);
            term1 = dotVR / d0;
            term2 = (term1 * term1) - vvss;
            time1 = (d0 / vvss) * (-term1 + Sqrt(term2));
            time2 = (d0 / vvss) * (-term1 - Sqrt(term2));
            // End:0x1F0
            if(time1 > 0.0000000)
            {
                Time = time1;                
            }
            else
            {
                // End:0x20D
                if(time2 > 0.0000000)
                {
                    Time = time2;                    
                }
                else
                {
                    dist = VSize(RealStartLoc - Target);
                    Time = dist / SpawnedProjectile.Speed;
                }
            }
            Target += (Enemy.Velocity * Time);
            AimDir = ((1.0000000 - loft) * Normal(Target - RealStartLoc)) + (loft * vect(0.0000000, 0.0000000, 1.0000000));
            SpawnedProjectile.Init(AimDir);
        }
        return SpawnedProjectile;
    }
    return none;
    //return ReturnValue;    
}

simulated function PlayBuzzSound()
{
    mSoundController.TryPlayLocalSound(mBuzzSndCue);
    //return;    
}

simulated event bool CanAutoAimTo()
{
    return true;
    //return ReturnValue;    
}

state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        local @NULL impactEmitter, emitterPool;

        super.BeginState(PreviousStateName);
        // End:0x86
        if(mDeadParticleSystem != none)
        {
            emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
            impactEmitter = TurokEmitter(emitterPool.GetEmitter(mDeadParticleSystem, self, Location));
            impactEmitter.mSoundController.TryPlayLocalSound(mDeathSndCue);
        }
        Destroy();
        //return;        
    }
    stop;    
}

defaultproperties
{
    mDeadParticleSystem=ParticleSystem'FXCreatureInteraction.ParticleSystems.RazorWingGoreExplosionPS'
    // Reference: TurokAISteer'Default__TurokPawnRazorWingNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnRazorWingNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnRazorWingNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnRazorWingNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnRazorWingNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnRazorWingNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    mSkeletalHurt=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnRazorWingNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnRazorWingNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnRazorWingNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnRazorWingNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnRazorWingNative.Arrow'
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