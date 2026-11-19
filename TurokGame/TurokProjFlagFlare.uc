class TurokProjFlagFlare extends TurokProjFlareNative
    config(Projectile)
    hidecategories(Navigation);

defaultproperties
{
    mExplodeOnce=true
    mAttractAll=true
    // Reference: TurokSoundController'Default__TurokProjFlagFlare.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mbExploded=true
    // Reference: TurokRadialShakeComponent'Default__TurokProjFlagFlare.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjFlagFlare.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    bReplicateMovement=false
    bHardAttach=false
    bCollideActors=false
    bCollideWorld=false
    // Reference: SpriteComponent'Default__TurokProjFlagFlare.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    Physics=0
    RemoteRole=0
    LifeSpan=0.0000000
    CollisionComponent=CollisionCylinder
}