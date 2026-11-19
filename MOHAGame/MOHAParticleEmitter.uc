class MOHAParticleEmitter extends Emitter
    hidecategories(Navigation);

function ActivateParticleSystem(Vector vLocation, Rotator rOrientation, optional bool bForce, optional float CullDistance)
{
    // End:0x32
    if(false == (ShouldActivateSystem(vLocation, bForce, CullDistance, ParticleSystemComponent.Template)))
    {
        return;
    }
    SetLocation(vLocation);
    SetRotation(rOrientation);
    ParticleSystemComponent.ActivateSystem();
    //return;    
}

function bool ShouldActivateSystem(Vector vLocation, optional bool bForce, optional float CullDistance, optional ParticleSystem ParticleSys)
{
    local bool bEffectIsRelevant;

    bEffectIsRelevant = EffectIsRelevant(vLocation, bForce, CullDistance, ParticleSys);
    return bEffectIsRelevant;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__MOHAParticleEmitter.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    // Reference: SpriteComponent'Default__MOHAParticleEmitter.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=ParticleSystemComponent0
    // Reference: ArrowComponent'Default__MOHAParticleEmitter.ArrowComponent0'
    begin object name=ArrowComponent0
    end object
    Components[2]=ArrowComponent0
    CollisionType=0
}