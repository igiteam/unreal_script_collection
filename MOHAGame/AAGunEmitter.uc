class AAGunEmitter extends Emitter
    hidecategories(Navigation);

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__AAGunEmitter.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    bDestroyOnSystemFinish=true
    // Reference: SpriteComponent'Default__AAGunEmitter.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=ParticleSystemComponent0
    // Reference: ArrowComponent'Default__AAGunEmitter.ArrowComponent0'
    begin object name=ArrowComponent0
    end object
    Components[2]=ArrowComponent0
    bNoDelete=false
    LifeSpan=10.0000000
    CollisionType=0
}