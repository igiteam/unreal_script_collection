class TurokProjRocketNative extends TurokProjectile
    native
    config(Projectile)
    hidecategories(Navigation);

var(rocket) float mAccelerationScalar;
var(rocket) float mBlowUpDelayTime;
var(LockOn) float mLockOnTrackingRadius;
var(LockOn) float mLockOnGroundClearance;
var bool mbLockOnAdjustGroundClearance;
var(LockOn) private bool mbDebugDraw;
var(MGPawn) float mMGAccelerationScalar;
var(MGPawn) float mMGMaxSpeed;
var config int mMGMultiplayerDamage;
var config int mMGDamage;
var config float mMGSpeed;
var private @NULL mLockOnTarget;
var private export editinline @NULL mRocketMesh;
var export editinline @NULL mSmokeParticles;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x33
    if(mSmokeParticles != none)
    {
        mSmokeParticles.DeactivateSystem();
        SetTimer(0.0200000, false, 'ActivatePSTimer');
    }
    //return;    
}

simulated function ActivatePSTimer()
{
    // End:0x1A
    if(mSmokeParticles != none)
    {
        mSmokeParticles.ActivateSystem();
    }
    //return;    
}

simulated function ProcessTouch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
{
    // End:0x62
    if(mbIsMultiPlayer || !Other.IsA('TurokPawnHumanWc') && !Instigator.IsA('TurokPawnHumanWc'))
    {
        // End:0x62
        if(Other != Instigator)
        {
            Explode(HitLocation, HitNormal);
        }
    }
    //return;    
}

function @NULL GetLockOnTarget()
{
    return mLockOnTarget;
    //return ReturnValue;    
}

function SetLockOnTarget(@NULL TargetActor, optional bool adjustGroundClearance = true)
{
    mLockOnTarget = TargetActor;
    mbLockOnAdjustGroundClearance = adjustGroundClearance;
    //return;    
}

simulated function BlowUpTimer()
{
    local @NULL RPG;

    MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
    SpawnDecalImpactEffects(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal);
    // End:0xA7
    if(MyDamageType.default.DamageRadius > 0.0000000)
    {
        BlowUp(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal);
        // End:0xA7
        if(mbDebugDraw)
        {
            DrawDebugSphere(mReplicatedHitInfo.Location, 25.0000000, 10, byte(255), 0, 0, true);
        }
    }
    RPG = TurokWeapRpgNative(Owner);
    // End:0xD6
    if(RPG != none)
    {
        RPG.RocketExplodedCallback(self);
    }
    // End:0x111
    if((int(Role) == int(ROLE_Authority)) && !bNetTemporary || NetUpdateTime == 0.0000000)
    {
        SetPendingDestroy();        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function OnProjectileHit(@NULL HitInfo)
{
    mReplicatedHitInfo = HitInfo;
    SetCollision(false, false, true);
    SetPhysics(0);
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    mLockOnTarget = none;
    SpawnExplosionEffects(mReplicatedHitInfo.Location, mReplicatedHitInfo.Normal, false);
    // End:0x74
    if(mSmokeParticles != none)
    {
        mSmokeParticles.DeactivateSystem();
    }
    mRocketMesh.SetHidden(true);
    SetTimer(mBlowUpDelayTime, false, 'BlowUpTimer');
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local @NULL collisionTraceVector, TargetLocation;
    local float Alpha;
    local @NULL finalRot, HitLoc, HitNorm, DesiredLoc, HitActor;

    local float distToTarget;
    local @NULL targetDirection;

    super.Tick(DeltaTime);
    // End:0x1D
    if(int(Role) != int(ROLE_Authority))
    {
        return;
    }
    // End:0x38
    if((mLockOnTarget == none) || mbExploded == true)
    {
        return;
    }
    // End:0x77
    if(TurokPawnCinematicDamageable(mLockOnTarget) != none)
    {
        TargetLocation = Pawn(mLockOnTarget).Mesh.Bounds.Origin;        
    }
    else
    {
        TargetLocation = mLockOnTarget.Location;
    }
    // End:0x110
    if(mbDebugDraw == true)
    {
        targetDirection = Normal(TargetLocation - Location);
        targetDirection *= 50.0000000;
        DrawDebugLine(Location, Location + targetDirection, byte(255), 0, 0, true);
        targetDirection = Normal(Velocity);
        targetDirection *= 50.0000000;
        DrawDebugLine(Location, Location + targetDirection, 0, byte(255), 0, true);
    }
    HitActor = Trace(HitLoc, HitNorm, mLockOnTarget.Location, Location, true);
    // End:0x1CA
    if(HitActor != none)
    {
        // End:0x1C7
        if(HitActor != mLockOnTarget)
        {
            // End:0x1C7
            if(((TurokPawnHuman(mLockOnTarget) != none) && TurokPawnCinematic(mLockOnTarget) == none) && TurokPawnHelicopterNative(mLockOnTarget) == none)
            {
                TargetLocation.Z += (Pawn(mLockOnTarget).Mesh.Bounds.SphereRadius / 4.0000000);
            }
        }        
    }
    else
    {
        // End:0x23C
        if(((TurokPawnHuman(mLockOnTarget) != none) && TurokPawnCinematic(mLockOnTarget) == none) && TurokPawnHelicopterNative(mLockOnTarget) == none)
        {
            TargetLocation.Z -= (Pawn(mLockOnTarget).Mesh.Bounds.SphereRadius / 2.0000000);
        }
    }
    targetDirection = TargetLocation - Location;
    distToTarget = VSize(targetDirection);
    targetDirection /= distToTarget;
    // End:0x328
    if(distToTarget < mLockOnTrackingRadius)
    {
        // End:0x29D
        if(mbDebugDraw == true)
        {
            DrawDebugSphere(Location, 5.0000000, 4, 0, byte(255), 0, true);
        }
        // End:0x2E3
        if(distToTarget < float(160))
        {
            // End:0x2E3
            if((Velocity Dot targetDirection) <= float(0))
            {
                ImpactedActor = mLockOnTarget;
                ProcessTouch(mLockOnTarget, Location, targetDirection);
            }
        }
        Alpha = (mLockOnTrackingRadius - distToTarget) / mLockOnTrackingRadius;
        finalRot = Rotator(targetDirection);
        finalRot = RLerp(Rotation, finalRot, Alpha, true);        
    }
    else
    {
        finalRot = Rotator(targetDirection);
        // End:0x46E
        if(mbLockOnAdjustGroundClearance)
        {
            // End:0x365
            if(mbDebugDraw == true)
            {
                DrawDebugSphere(Location, 5.0000000, 4, byte(255), 0, 0, true);
            }
            collisionTraceVector = 1000.0000000 * Vector(Rotation);
            HitActor = Trace(HitLoc, HitNorm, (Location + collisionTraceVector) + vect(0.0000000, 0.0000000, -1000.0000000), Location + collisionTraceVector, true);
            // End:0x46E
            if(HitActor != none)
            {
                DesiredLoc = HitLoc;
                DesiredLoc.Z += mLockOnGroundClearance;
                // End:0x42D
                if(TargetLocation.Z > DesiredLoc.Z)
                {
                    DesiredLoc.Z = TargetLocation.Z + 100.0000000;
                }
                HitActor = Trace(HitLoc, HitNorm, DesiredLoc, Location, true);
                // End:0x46E
                if(HitActor == none)
                {
                    finalRot = Rotator(DesiredLoc - Location);
                }
            }
        }
    }
    Velocity.X = VSize(Velocity);
    Velocity.Y = 0.0000000;
    Velocity.Z = 0.0000000;
    Velocity = Velocity >> finalRot;
    SetRotation(finalRot);
    //return;    
}

defaultproperties
{
    mLockOnTrackingRadius=1000.0000000
    mLockOnGroundClearance=200.0000000
    mbLockOnAdjustGroundClearance=true
    // Reference: TurokSoundController'Default__TurokProjRocketNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mExplosionShakeEnable=true
    // Reference: TurokRadialShakeComponent'Default__TurokProjRocketNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjRocketNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjRocketNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}