/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoMusicManager_StopTrackAndDisable extends SequenceAction;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

/**
 * Called when this event is activated.
 */
event Activated()
{
	// we want to END the combat so just force the nullsound as teh track here.
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetMusicManager().HandleMusicEvent( EME_CombatEnds, , SoundCue'Music_Temp2.NullSoundCue' );

	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC().SetSoundMode( 'Default' );

	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).WorldStateSettings.bMusicManagerEnabled = FALSE;
}



defaultproperties
{
	ObjName="Music Manager Stop Track And Disable"
	ObjCategory="Nano Procedural"

	bCallHandler=FALSE

	VariableLinks.Empty()
}
