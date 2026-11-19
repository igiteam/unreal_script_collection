class StreamingSoundTrigger extends Trigger;

var(StreamingSoundTrigger) Sound StreamingSound;
var(StreamingSoundTrigger) localized string Subtitle;
var(StreamingSoundTrigger) bool bPositional;

event TriggerEvent( Name EventName, Actor Other, Pawn EventInstigator )
{
	Super.TriggerEvent(EventName, Other, EventInstigator);

	DoWork();
}

function Trigger( actor Other, pawn EventInstigator )
{
	Super.Trigger(Other,EventInstigator);

	DoWork();
}

function DoWork()
{

	if(StreamingSound != None)
	{
		if(bPositional)
		{
			PlaySound( StreamingSound,SLOT_Misc,SoundVolume,,SoundRadius,SoundPitch / 64.0);
		} 
		else
		{
			PlaySound( StreamingSound,SLOT_Interface);
		}
	}
	
	if(Subtitle != "")
	{
		BroadcastLocalizedMessage(MessageClass, 0, None, None, self);
	}	
}


// Decompiled with UE Explorer.
defaultproperties
{
    bPositional=true
    bTriggerOnceOnly=true
    Texture=Texture'Engine.S_MaterialTrigger'
    MessageClass=Class'SubtitleMessage'
}