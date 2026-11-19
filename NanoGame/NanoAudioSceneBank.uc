/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAudioSceneBank extends Object
	hidecategories(Object)
	placeable; // needed to show up in the Actor Classes list;



struct SoundCueMetaDataDatum
{
	/** Delay to wait before playing. **/
	var() vector2d DelayBeforePlayingRange; 

	/** Volume Multiplier **/
	var() vector2d VolumeMultiplierRange; 

	/** Distance range: float world-units; if set to 0, don't choose a random point to play the sound from instead play it directly on the pawn **/
	var() vector2d DistanceToPlayRange; 

	structdefaultproperties
	{
		DelayBeforePlayingRange=(X=1.0f,Y=1.0f)
		VolumeMultiplierRange=(X=1.0f,Y=1.0f)
		DistanceToPlayRange=(X=200,Y=200)
	}
};


struct NonLoopingSoundDatum
{
	var() SoundCue TheSound;
	var() SoundCueMetaDataDatum MetaData;

	/** Time for the the non looping sound to finish**/
	var transient float TimeToFinish;
};


struct NanoAudioSceneBankDatum
{
	/**  float seconds, it should fade both the volume of the looping sound and the non-looping sounds playing **/
	var() float AudioScene_FadeInTime; 

	/** float seconds, it should fade both the volume of the looping sound and the non-looping sounds playing **/
	var() float AudioScene_FadeOutTime; 

	/**  **/
	var() SoundCue Looping_SoundCue;


	var(NonLooping) SoundCueMetaDataDatum DefaultMetaData;

	var(NonLooping) array<NonLoopingSoundDatum> NonLoopingSounds;

};



var() NanoAudioSceneBankDatum Normal;
var() NanoAudioSceneBankDatum Danger;
var() NanoAudioSceneBankDatum Chaos;



defaultproperties
{

}
