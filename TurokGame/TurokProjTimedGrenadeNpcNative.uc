class TurokProjTimedGrenadeNpcNative extends TurokProjectile
    native
    config(Projectile)
    hidecategories(Navigation);

var config float mExplosionDelay;
var config float mProjectileSlowRate;
var config float mRestitution;
var @NULL mMinQuietBounce;
var int mIndex;
var @NULL mInitPosition;
var array mTrajectory;

function BeginFlight(float explodeTime)
{
    mIndex = 0;
    mInitPosition = Location;
    Velocity = mTrajectory[mIndex].mInitVelocity;
    // End:0x57
    if(int(Role) == int(ROLE_Authority))
    {
        SetTimer(explodeTime + mExplosionDelay, false, 'ExplodeTimer');
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x85
    if(((int(Physics) == int(6)) && mIndex < (mTrajectory.Length - 1)) && VSize(Location - mInitPosition) > VSize(mTrajectory[mIndex].mFinalPosition - mInitPosition))
    {
        mIndex++;
        Velocity = mTrajectory[mIndex].mInitVelocity;
    }
    //return;    
}

function ExplodeTimer()
{
    local @NULL HitInfo;

    mbExploded = true;
    HitInfo.Location = Location;
    HitInfo.Normal = vect(0.0000000, 0.0000000, 1.0000000);
    OnProjectileHit(HitInfo);
    //return;    
}

simulated function Explode(@NULL HitLocation, @NULL HitNormal)
{
    //return;    
}

simulated event HitWall(@NULL HitNormal, @NULL Wall)
{
    local @NULL HitInfo, StartTrace, EndTrace, HitLocation, ImpactEffect;

    Velocity = MirrorVectorByNormal(Velocity, HitNormal) * mRestitution;
    Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    SetPhysics(2);
    // End:0x91
    if(((Abs(Velocity.X) <= mProjectileSlowRate) && Abs(Velocity.Y) <= mProjectileSlowRate) && Abs(Velocity.Z) <= mProjectileSlowRate)
    {
        StopAmbience();
    }
    // End:0x1AC
    if(((Abs(Velocity.X) >= mMinQuietBounce.X) && Abs(Velocity.Y) >= mMinQuietBounce.Y) && Abs(Velocity.Z) >= mMinQuietBounce.Z)
    {
        HitLocation = Location;
        StartTrace = HitLocation + (HitNormal * 5.0000000);
        EndTrace = StartTrace + (-HitNormal * 20.0000000);
        Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo);
        ImpactEffect = GetImpactEffect(HitInfo.PhysMaterial);
        PlayImpactSound(ImpactEffect.mBounceSound);
        MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjTimedGrenadeNpcNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mExplosionShakeEnable=true
    // Reference: TurokRadialShakeComponent'Default__TurokProjTimedGrenadeNpcNative.Shakey'
    begin object name=Shakey
        Duration=0.7500000
        Radius=1750.0000000
        mParams=(mRollAmplitude=2.0000000,mRollFrequency=5.0000000,mPitchAmplitude=2.0000000,mPitchFrequency=7.0000000,mYawAmplitude=4.0000000,mYawFrequency=10.0000000,mXAmplitude=0.7500000,mXFrequency=2.0000000,mYAmplitude=0.7500000,mYFrequency=2.0000000,mZAmplitude=3.0000000,mZFrequency=1.0000000)
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjTimedGrenadeNpcNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjTimedGrenadeNpcNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}