/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoMusicManager extends SequenceAction;



var() EMusicEvents MusicEventToFire;

var() SoundCue CustomHitSound;
var() SoundCue CustomTrackSound;




static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

/**
 * Called when this event is activated.
 */
event Activated()
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetMusicManager().HandleMusicEvent( MusicEventToFire, CustomHitSound, CustomTrackSound );
}




defaultproperties
{
	ObjName="Music Manager"
	ObjCategory="Nano Procedural"

	bCallHandler=FALSE

	VariableLinks.Empty()
}