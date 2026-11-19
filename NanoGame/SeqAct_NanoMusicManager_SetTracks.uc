/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoMusicManager_SetTracks extends SequenceAction;


var() EMusicEvents MusicEventToUpdate;

var() SoundCue NewHitSound;
var() SoundCue NewTrackSound;

var() float NewTrackFadeInTime;
var() float NewTrackFadeOutTime;

/** Restores this MusicEventID to the defaults that are are in the .uc file ( .default.property ) **/
var() bool bResetToDefaults;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 5;
}

/**
 * Called when this event is activated.
 */
event Activated()
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetMusicManager().UpdateMusicEvent( MusicEventToUpdate, NewHitSound, NewTrackSound, NewTrackFadeInTime, NewTrackFadeOutTime, bResetToDefaults );
}



defaultproperties
{
	ObjName="Music Manager Set Tracks"
	ObjCategory="Nano Procedural"

	bCallHandler=FALSE

	VariableLinks.Empty()


	NewTrackFadeInTime=2.000f
	NewTrackFadeOutTime=2.000f

}
