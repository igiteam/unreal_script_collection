class SPDSoundActor extends Actor
    native
    notplaceable;

var export editinline RB_RadialImpulseComponent ImpulseComponent;
var float delay;
var int Damage;
var float DamageRadius;
var class<DamageType> DamageType;
var export editinline transient AudioComponent AudioComp;
var SoundCue PlaySound;
var float ExtraDelay;
var transient float SoundDuration;
var float FadeInTime;
var float FadeOutTime;
var export editinline DrawSphereComponent RenderComponent;
var bool ShowDebug;

// Export USPDSoundActor::execInit(FFrame&, void* const)
native function Init();

auto state StartUp
{Begin:

    Init();
    GotoState('Finished');
    stop;                
}

state Finished
{Begin:

    Sleep(SoundDuration);
    Destroy();
    stop;                    
}
