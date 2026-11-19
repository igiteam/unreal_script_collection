class SPDAction_PlaySound extends SPDAction
    editinlinenew
    collapsecategories;

/** Sound cue to play on the targeted actor(s) */
var() SoundCue PlaySound;
/** Additional dead space to append to SoundDuration */
var() float ExtraDelay;
/** Time taken for sound to fade in when action is activated. */
var() float FadeInTime;
/** Time take for sound to fade out when Stop input is fired. */
var() float FadeOutTime;
/** Time take for sound to fade out when Stop input is fired. */
var() bool AttachToSpawner;

function AttachIt(Actor oldActor, Actor newActor)
{
    newActor.SetHardAttach(true);
    newActor.SetBase(oldActor);
    //return;    
}

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDSoundActor soundActor;
    local Vector pos;

    pos = DamageInfo.Location;
    soundActor = Manager.Spawn(Class'SPDSoundActor',,, pos);
    soundActor.PlaySound = PlaySound;
    soundActor.ExtraDelay = ExtraDelay;
    soundActor.FadeInTime = FadeInTime;
    soundActor.FadeOutTime = FadeOutTime;
    soundActor.ShowDebug = DamageInfo.ShowDebug;
    // End:0xD0
    if(AttachToSpawner)
    {
        AttachIt(Actor, soundActor);
    }
    return 1;
    //return ReturnValue;    
}
