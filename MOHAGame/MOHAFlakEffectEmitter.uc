class MOHAFlakEffectEmitter extends Emitter
    hidecategories(Navigation);

function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
    // End:0x14
    if(bDestroyOnSystemFinish)
    {
        LifeSpan = 0.0001000;
    }
    Destroy();
    //return;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__MOHAFlakEffectEmitter.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    bDestroyOnSystemFinish=true
    // Reference: SpriteComponent'Default__MOHAFlakEffectEmitter.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=ParticleSystemComponent0
    // Reference: ArrowComponent'Default__MOHAFlakEffectEmitter.ArrowComponent0'
    begin object name=ArrowComponent0
    end object
    Components[2]=ArrowComponent0
    bNoDelete=false
    CollisionType=0
}