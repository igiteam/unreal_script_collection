class SPDAction_SpawnParticleSystem extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(SPDAction) ParticleSystem ParticleSystem;
var(SPDAction) bool DestroyOnFinish;
var(SPDAction) bool CastShadows;

simulated event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local EmitterSpawnable Emitter;
    local editinline ParticleSystemComponent psComp;

    Emitter = EmitterSpawnable(CreateActor(Manager, Actor, DamageInfo));
    psComp = Emitter.ParticleSystemComponent;
    psComp.SetScale(Scale);
    psComp.CastShadow = CastShadows;
    // End:0x136
    if(Emitter != none)
    {
        Emitter.LifeSpan = LifeSpanLimit;
        Emitter.bDestroyOnSystemFinish = DestroyOnFinish;
        Emitter.SetTemplate(ParticleSystem, DestroyOnFinish);
        Emitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
        Emitter.ParticleSystemComponent.ActivateSystem();
        FindBestSpotForSpawnLocation(Emitter);
        // End:0x136
        if(SPLifeForceHolder(Actor) != none)
        {
            SPLifeForceHolder(Actor).NotifyParentOfCreation(Emitter);
        }
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    DestroyOnFinish=true
    LifeSpanLimit=5.0000000
    bCollideActors=false
    bBlockActors=false
    bCheckForSpawnCollision=false
    NewActorClass=Class'Engine.EmitterSpawnable'
    NewActorClassMP=Class'Engine.EmitterSpawnable'
    Action="Spawn Particle System"
}