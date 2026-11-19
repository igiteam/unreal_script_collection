/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_GearUseCommLink extends SeqAct_Latent
	native(Sequence);

cpptext
{
	void Activated();
	UBOOL UpdateOp(FLOAT DeltaTime);
	void DeActivated();
};

/** true if this action was stopped via the stop input */
var protected bool bStopped;

/** true if the target actually started the commlink stance */
var protected bool bStarted;

/** True is the SingleLineSound has begun to play. */
var protected bool bSingleLineSoundIsPlaying;

/** true if the SingleLineSound finished*/
var protected bool bFinished;


/**
 * If this is None, the Target will be put into commlink mode until
 * the Stop input is activated.
 * If a valid cue is provided, the Target will be put into commlink mode
 * only for the duration of that sound.
 */
var() SoundCue SingleLineSound;

/** time remaining on the playing SingleLineSound, if specified */
var	float SoundDuration;

/** if true, target will go into commlink mode, with the hand-to-ear headset anim */
var() bool bUseCommLink;

var() protected const bool	bPlayerCanAbort;

var protected transient bool bAbortedByPlayer;

/** How long to wait before action is abortable. */
var() protected const float AbortabilityDelay;
var protected transient float AbortabilityDelayRemaining;

/** Aborts within this time window will be considered valid for aborting this action */
var protected const float AbortabilityWindow;



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
	return Super.GetObjClassVersion() + 4;
}

defaultproperties
{
	bCallHandler=FALSE
	bUseCommLink=TRUE
	bPlayerCanAbort=TRUE
	AbortabilityDelay=0.1f
	AbortabilityWindow=0.5f

	ObjName="Use CommLink"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Start")
	InputLinks(1)=(LinkDesc="Stop")

	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Started")
	OutputLinks(2)=(LinkDesc="Stopped")
	OutputLinks(3)=(LinkDesc="SLS Finished")
	OutputLinks(4)=(LinkDesc="Player Aborted")
}
