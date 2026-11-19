/**
 * GearAnimNotify_PlayFoleySound
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAnimNotify_PlayFoleySound extends AnimNotify_Scripted
	native(Anim);

/** The foley sound that we want to play */
var() GearFoleyID FoleyToPlay;

/** If no bone specified, if the sound should play where the owner is */
var() bool bFollowActor;

/** If specified, the sound origin will be located where the bone is */
var() Name BoneName;

/** Whether to play the sound even if the actor is hidden */
var() bool bIgnoreIfActorHidden;

/** This is the percent to play this Sound.  Defaults to 100% (aka 1.0f) **/
var() float PercentToPlay;

/** How much to multiply the volume by */
var() float	VolumeMultiplier;

/** How much to multiply the pitch by */
var() float	PitchMultiplier;

cpptext
{
	/**
	 * Find the foley sound from the GSG and play it
	 *
	 * @param NodeSeq - the anim node sequence that triggered this notify
	 */
	virtual void Notify(class UAnimNodeSequence* NodeSeq);

	/** @return the comment string to use in the editor */
	virtual FString GetEditorComment() { return TEXT("FoleySnd"); }
}

defaultproperties
{
	PercentToPlay=1.0f
	VolumeMultiplier=1.f
	PitchMultiplier=1.f
	bFollowActor=TRUE

	NotifyColor=(R=200,G=200,B=255)
}