class TurokProjFirebladeNative extends TurokProjectile
    config(WeapFireblade)
    hidecategories(Navigation);

var float mTimeAlive;
var export editinline @NULL mFlameLight;
var export editinline @NULL mPSComponent;
var(FirebladeProjectile) float mStartSlowDownTime;
var(FirebladeProjectile) float mSlowDownMultiplier;
var(FirebladeProjectile) float mLightRadiusExpandRate;
var(FirebladeProjectile) float mMaxLightRadius;

simulated event Tick(float DeltaTime)
{
    mTimeAlive += DeltaTime;
    // End:0x2D
    if(mTimeAlive > mStartSlowDownTime)
    {
        Velocity = Velocity * mSlowDownMultiplier;
    }
    // End:0x79
    if(mFlameLight != none)
    {
        mFlameLight.Radius += mLightRadiusExpandRate;
        // End:0x79
        if(mFlameLight.Radius > mMaxLightRadius)
        {
            mFlameLight.Radius = mMaxLightRadius;
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

simulated function Explode(@NULL HitLocation, @NULL HitNormal)
{
    //return;    
}

simulated function OnProjectileHit(@NULL HitInfo)
{
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjFirebladeNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokRadialShakeComponent'Default__TurokProjFirebladeNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjFirebladeNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjFirebladeNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}