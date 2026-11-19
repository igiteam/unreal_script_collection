class MOHAExplodeEmitter extends MOHAParticleEmitter
    hidecategories(Navigation);

var() export editinline PointLightComponent ExplosionLight;
var() float FalloffSpeed;
var float ExplosionLightLife;

simulated function SetLight(PointLightComponent Light, float LightLife, optional float LightCreationDelay)
{
    ExplosionLight = Light;
    AttachComponent(ExplosionLight);
    ExplosionLightLife = LightLife;
    // End:0x3E
    if(0.0000000 == LightCreationDelay)
    {
        StartLight();        
    }
    else
    {
        SetTimer(LightCreationDelay, false, 'StartLight');
    }
    //return;    
}

simulated function StartLight()
{
    ExplosionLight.SetEnabled(true);
    SetTimer(ExplosionLightLife, false, 'StopLight');
    //return;    
}

simulated function StopLight()
{
    ExplosionLight.SetEnabled(false);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x3B
    if((ExplosionLight != none) && ExplosionLight.bEnabled)
    {
        ExplosionLight.FalloffExponent *= (FalloffSpeed ** DeltaTime);
    }
    //return;    
}

defaultproperties
{
    FalloffSpeed=1.0000000
    // Reference: ParticleSystemComponent'Default__MOHAExplodeEmitter.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    bDestroyOnSystemFinish=true
    // Reference: SpriteComponent'Default__MOHAExplodeEmitter.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=ParticleSystemComponent0
    // Reference: ArrowComponent'Default__MOHAExplodeEmitter.ArrowComponent0'
    begin object name=ArrowComponent0
    end object
    Components[2]=ArrowComponent0
    bNoDelete=false
    LifeSpan=3.0000000
}