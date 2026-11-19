class TurokPawnRaptorSpittingNative extends TurokPawnRaptorNative
    abstract
    native
    config(Game)
    hidecategories(Navigation);

var(TurokPawnRaptorSpitting) float mSpitRange;
var(TurokPawnRaptorSpitting) float mSafeRange;
var(TurokPawnRaptorSpitting) float mMeleeRange;
var(TurokPawnRaptorSpitting) float kSpitRechargeTime;
var(TurokPawnRaptorSpitting) float mSpitProjPredictionTime;
var(TurokPawnRaptorSpitting) int mMaxSpitters;
var float mLoft;
var name mProjectileStartBone;
var class<Class> mProjectile;
var() bool mNeckSackWeak;
var export editinline @NULL mNeckSackSkeletalMesh;
var const name mNeckSackRegion;
var @NULL mSpitGraphSet;

// Export UTurokPawnRaptorSpittingNative::execIsNeckSackWeak(FFrame&, void* const)
native final function bool IsNeckSackWeak();

simulated event @NULL ProjectileFire(@NULL Enemy)
{
    local @NULL AimDir, RealStartLoc, Target, SpawnedProjectile, turokAI;

    local float dist, Time, loft, d0, V, S,
	    vvss, dotVR, term1, term2, time1,
	    time2;

    local @NULL V0, R0;

    loft = 0.0000000;
    // End:0x2B7
    if((int(Role) == int(ROLE_Authority)) && Enemy != none)
    {
        RealStartLoc = Mesh.GetBoneLocation(mProjectileStartBone);
        turokAI = TurokAIController(Controller);
        Target = turokAI.GetBodyTargetLocation(TurokPawn(Enemy), 1);
        SpawnedProjectile = __NFUN_278__(mProjectile, self, 'Spit', RealStartLoc);
        // End:0x2B1
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
            // End:0x1F9
            if(time1 > 0.0000000)
            {
                Time = time1;                
            }
            else
            {
                // End:0x216
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

event Bump(@NULL Other, @NULL HitNormal)
{
    super(Actor).Bump(Other, HitNormal);
    // End:0x58
    if(TurokDestroyableActor(Other) != none)
    {
        Other.TakeDamage(100, Controller, Other.Location, vect(0.0000000, 0.0000000, 0.0000000), none);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    mImpactSystem.AttachComponentToHitRegion(mNeckSackSkeletalMesh, 7);
    mImpactSystem.DisableHitRegion(7);
    mLocoTemplate.mbEnableIK = false;
    //return;    
}

defaultproperties
{
    // Reference: TurokRadialShakeComponent'Default__TurokPawnRaptorSpittingNative.Shakey'
    begin object name=Shakey
    end object
    mFootStompCamShake=Shakey
    // Reference: TurokAISteer'Default__TurokPawnRaptorSpittingNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
        mSteeringPreset=/* Array type was not detected. */
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnRaptorSpittingNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
        mAIGoal=/* Array type was not detected. */
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnRaptorSpittingNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnRaptorSpittingNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnRaptorSpittingNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnRaptorSpittingNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokAnimLadderController'Default__TurokPawnRaptorSpittingNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnRaptorSpittingNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnRaptorSpittingNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnRaptorSpittingNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnRaptorSpittingNative.Arrow'
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