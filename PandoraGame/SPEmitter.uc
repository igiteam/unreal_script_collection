class SPEmitter extends Emitter
    native;

/** Sound to play when spawned */
var() SoundCue Sound;
/** Particle System to use */
var() ParticleSystem ParticleSystem;

// Export USPEmitter::execSPSpawn(FFrame&, void* const)
native static final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor Template);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x5B
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x40
        if(ParticleSystem != none)
        {
            SetTemplate(ParticleSystem, bDestroyOnSystemFinish);
        }
        // End:0x5B
        if(Sound != none)
        {
            PlaySound(Sound);
        }
    }
    //return;    
}

event ParticleCollision(ImpactInfo Impact)
{
    // End:0x3B
    if((Owner != none) && SPWeapon(Owner) != none)
    {
        SPWeapon(Owner).ParticleCollision(Impact);
    }
    // End:0x76
    if((Owner != none) && SPFireDrakePawnPersistent(Owner) != none)
    {
        SPFireDrakePawnPersistent(Owner).ParticleCollision(Impact);
    }
    //return;    
}

event ParticleMoved(Vector oldPos, Vector NewPos, float DeltaTime)
{
    // End:0x45
    if((Owner != none) && SPWeapon(Owner) != none)
    {
        SPWeapon(Owner).ParticleMoved(oldPos, NewPos, DeltaTime);
    }
    //return;    
}

function HideSelf()
{
    ParticleSystemComponent.DeactivateSystem();
    SetHidden(true);
    bStasis = true;
    //return;    
}
