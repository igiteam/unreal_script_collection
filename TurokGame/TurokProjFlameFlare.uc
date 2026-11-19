class TurokProjFlameFlare extends TurokProjFlareNative
    native
    config(Projectile)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjFlameFlare.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokRadialShakeComponent'Default__TurokProjFlameFlare.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    MyDamageType=Class'TurokDamageTypeFlare'
    // Reference: CylinderComponent'Default__TurokProjFlameFlare.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjFlameFlare.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    LifeSpan=0.0000000
    CollisionComponent=CollisionCylinder
}