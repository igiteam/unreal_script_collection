class EvilEmitter extends Emitter
    native
    hidecategories(Navigation);

var() SoundCue Sound;
var() ParticleSystem ParticleSystem;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x86
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x5F
        if(ParticleSystem != none)
        {
            SetTemplate(ParticleSystem, bDestroyOnSystemFinish);
        }
        // End:0x86
        if(Sound != none)
        {
            PlaySound(Sound);
        }
    }
    //return;    
}

simulated function HideSelf()
{
    ParticleSystemComponent.DeactivateSystem();
    SetBase(none);
    SetHidden(true);
    ClearTimer('HideSelf');
    //return;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__EvilEmitter.ParticleSystemComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ParticleSystemComponent0'
    // Archetype: ParticleSystemComponent'Engine.Default__Emitter.ParticleSystemComponent0'
    begin object name="ParticleSystemComponent0"
        ReplacementPrimitive=none
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    bDestroyOnSystemFinish=true
    Components[0]=none
    Components[1]=ParticleSystemComponent0
    Components[2]=none
    bNoDelete=false
    bNetInitialRotation=true
}