class AlarmSpeaker extends Alarm
    placeable;

var() soundcue AlarmSoundCue;
var AudioComponent AudioComponent;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (AlarmSoundCue != none)
	{
		AudioComponent.SoundCue = AlarmSoundCue;
		AttachComponent(AudioComponent);
	}
}

auto state AlarmWait
{
    event Tick( float DeltaTime )
    {
        if(!bAlarmOn && AudioComponent.bWasPlaying)
        {
            AudioComponent.Stop();
        }
        else if(bAlarmOn && !AudioComponent.bWasPlaying)
        {
            AudioComponent.Play();
        }
    }
}

