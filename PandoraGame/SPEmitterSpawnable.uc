class SPEmitterSpawnable extends SPEmitter
    native;

var Actor PathTarget;
var Actor PathSource;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(2.0000000, false, 'DestroyIfInvalid');
    //return;    
}

function DestroyIfInvalid()
{
    // End:0x0E
    if(ParticleSystemComponent == none)
    {
        Destroy();
    }
    // End:0x26
    if(ParticleSystemComponent.Template == none)
    {
        Destroy();
    }
    ClearTimer('DestroyIfInvalid');
    //return;    
}

function CreateObjectPool_Worker(ParticleSystem PSTemplate)
{
    local int Jdx;

    LifeSpan = 0.0000000;
    HideSelf();
    ParticleSystemComponent.bAutoActivate = false;
    SetTemplate(PSTemplate, false);
    ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
    ParticleSystemComponent.LODMethod = 1;
    Jdx = 0;
    J0x65:

    // End:0xD2 [Loop If]
    if(Jdx < ParticleSystemComponent.EmitterInstances.Length)
    {
        ParticleSystemComponent.SetKillOnDeactivate(Jdx, false);
        ParticleSystemComponent.SetKillOnCompleted(Jdx, false);
        ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
        Jdx++;
        // [Loop Continue]
        goto J0x65;
    }
    //return;    
}
