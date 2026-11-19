class UTReplicatedEmitter extends UTEmitter
    abstract
    hidecategories(Navigation);

var ParticleSystem EmitterTemplate;
var float ServerLifeSpan;

simulated function PostBeginPlay()
{
    super(Emitter).PostBeginPlay();
    // End:0x49
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        LifeSpan = ServerLifeSpan;        
    }
    else
    {
        SetTemplate(EmitterTemplate, true);
    }
    //return;    
}

defaultproperties
{
    ServerLifeSpan=0.2000000
    // Reference: ParticleSystemComponent'Default__UTReplicatedEmitter.ParticleSystemComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ParticleSystemComponent0'
    // Archetype: ParticleSystemComponent'Default__UTEmitter.ParticleSystemComponent0'
    begin object name="ParticleSystemComponent0"
        ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    Components[0]=ParticleSystemComponent0
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bNetTemporary=true
    bNetInitialRotation=true
}