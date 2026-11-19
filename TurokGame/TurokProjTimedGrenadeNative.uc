class TurokProjTimedGrenadeNative extends TurokProjectile
    native
    config(Projectile)
    hidecategories(Navigation);

var config float mExplosionDelay;
var config float mBeepOffset;
var config float mRestitution;
var config float mProjectileSlowRate;
var() @NULL mMinQuietBounce;
var @NULL mBeepSndCue;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x43
    if(int(Role) == int(ROLE_Authority))
    {
        SetTimer(mExplosionDelay, false, 'ExplodeTimer');
        SetTimer(mExplosionDelay - mBeepOffset, false, 'BeepTimer');
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

simulated function BeepTimer()
{
    mSoundController.TryPlayLocalSound(mBeepSndCue);
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
    HitLocation = Location;
    StartTrace = HitLocation + (HitNormal * 5.0000000);
    EndTrace = StartTrace + (-HitNormal * 20.0000000);
    Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo);
    ImpactEffect = GetImpactEffect(HitInfo.PhysMaterial);
    // End:0xBE
    if(VSizeSq(Velocity) <= (mProjectileSlowRate * mProjectileSlowRate))
    {
        StopAmbience();
    }
    // End:0x15B
    if(((Abs(Velocity.X) >= mMinQuietBounce.X) && Abs(Velocity.Y) >= mMinQuietBounce.Y) && Abs(Velocity.Z) >= mMinQuietBounce.Z)
    {
        PlayImpactSound(ImpactEffect.mBounceSound);
        MakeNoise(mImpactNoiseLevel, 'NOISE_ProjectileImpact');
    }
    //return;    
}

defaultproperties
{
    mBeepSndCue=SoundCue'SndWeapRailGun.GrenadeBeepsSndCue'
    // Reference: TurokSoundController'Default__TurokProjTimedGrenadeNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mExplosionShakeEnable=true
    // Reference: TurokRadialShakeComponent'Default__TurokProjTimedGrenadeNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjTimedGrenadeNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjTimedGrenadeNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}