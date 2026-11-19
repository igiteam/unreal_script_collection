class TurokProjShredderNative extends TurokProjectile
    config(Projectile)
    hidecategories(Navigation);

var export editinline @NULL mPrimaryFxPS;

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjShredderNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokRadialShakeComponent'Default__TurokProjShredderNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjShredderNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjShredderNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}