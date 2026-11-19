class TurokProjNapalmGrenadeNative extends TurokProjectile
    native
    config(Projectile)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjNapalmGrenadeNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokRadialShakeComponent'Default__TurokProjNapalmGrenadeNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjNapalmGrenadeNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjNapalmGrenadeNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}