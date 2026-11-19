/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ChooseCameraByDuration extends SequenceAction
	native(Sequence);

/** Desired duration of the camera cuts to play.  Action will try to create a series of cuts close to this total time */
var float   DesiredDuration;

/** Cached durations of the matinee track length connected to each corresponding output link */
var() array<float> CameraTrackDurations;

/** List of CameraTracks to play to achieve the desired duration */
var transient array<int> TrackStack;

/** Store the currently playing matinee sequence, so we can hook when it stops */
var transient SeqAct_Interp CurrentPlayingInterpAction;

cpptext
{
	void Activated();
	UBOOL UpdateOp(FLOAT deltaTime);

	/** Checks to see if there's another track to play, and plays it if so.  Returns true if there is another track to play */
	UBOOL PlayNextTrack();
}

/**
* Return the version number for this class.  Child classes should increment this method by calling Super then adding
* a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
* link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
* Super.GetObjClassVersion() should be incremented by 1.
*
* @return	the version number for this specific class.
*/
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Choose Camera Cuts by Duration"
	ObjCategory="Nano Briefing"

 	bLatentExecution=true
 	bAutoActivateOutputLinks=false

	OutputLinks.Empty()
	OutputLinks(0)=(LinkDesc="Camera 0",bHidden=false);
	OutputLinks(1)=(LinkDesc="Camera 1",bHidden=false);
	OutputLinks(2)=(LinkDesc="Camera 2",bHidden=true);
	OutputLinks(3)=(LinkDesc="Camera 3",bHidden=true);
	OutputLinks(4)=(LinkDesc="Camera 4",bHidden=true);
	OutputLinks(5)=(LinkDesc="Camera 5",bHidden=true);

	VariableLinks(0)=(ExpectedType=class'SeqVar_Float',LinkDesc="DesiredDuration",bWriteable=false,PropertyName=DesiredDuration)
}
