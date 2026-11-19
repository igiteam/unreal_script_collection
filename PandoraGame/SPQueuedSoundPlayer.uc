class SPQueuedSoundPlayer extends Actor
    notplaceable;

struct SoundEntry
{
    var export editinline AudioComponent theComponent;
    var bool hasStarted;

    structdefaultproperties
    {
        theComponent=none
        hasStarted=false
    }
};

var array<SoundEntry> QueuedSounds;

function PlayNextSoundIfNecessary()
{
    // End:0x0E
    if(QueuedSounds.Length == 0)
    {
        return;
    }
    // End:0x90
    if(QueuedSounds[0].theComponent.IsPlaying() == false)
    {
        // End:0x52
        if(QueuedSounds[0].hasStarted == true)
        {
            QueuedSounds.Remove(0, 1);
        }
        // End:0x90
        if(QueuedSounds.Length > 0)
        {
            QueuedSounds[0].theComponent.Play();
            QueuedSounds[0].hasStarted = true;
        }
    }
    //return;    
}

function AddSound(SoundCue theSound)
{
    local SoundEntry theSoundEntry;

    theSoundEntry.theComponent = CreateAudioComponent(theSound, false, true, false);
    theSoundEntry.theComponent.bAutoDestroy = true;
    QueuedSounds.AddItem(theSoundEntry);
    //return;    
}
