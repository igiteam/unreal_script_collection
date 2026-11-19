/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_Speak extends SeqAct_PlaySound
	native(TGSequence);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var   protected transient   SoundCue            PlayingSound;
var() array<SoundCue>                           RandPlaySound;
var() protected const ESpeechPriority	        Priority;
var() protected const ESpeechInterruptCondition	InterruptCondition;

/** True if you want the speaker to head track towards the SpeakingTo character.  Default TRUE. */
var() protected const bool					bTurnHeadTowardsAddressee;
/** amount of time to keep looking at addressee after line is finished (unless overridden by something else) */
var() protected const float					ExtraHeadTurnTowardTime;

/** True if you want the speaker to turn and face the SpeakingTo character.  Supercedes bTurnHeadTowardsAddressee if TRUE. */
var() protected const bool					bTurnBodyTowardsAddressee;

/** Animation name to play as a "gesture" during the speech. */
var() protected const name					GestureAnimName;

/** Set to true to speak SpokenText using TTS */
var()	protected const bool				bUseTTS;
/** Speaker to use for TTS */
var()	protected const ETTSSpeaker			TTSSpeaker;
/** A localized version of the text that is actually spoken in the audio. */
var()	protected const localized string	TTSSpokenText<ToolTip=The phonetic version of the dialog>;

/** Temporary sound cue used to hold the TTS data */
var	protected transient SoundCue			TTSSoundCue;
/** Set to true when the PCM data has been generated. Synonymous with !bDirty. */
var	protected transient bool				bPCMGenerated;

/** AC for the actively playing line. */
var protected transient AudioComponent		SpokenLineAC;
var protected transient bool				bSpokenLineACHasStartedPlaying;

/** Keeps track of how much ExtraDelay remains. */
var protected transient float				ExtraDelayStartTime;

var protected transient TGPawn			    DBNOSpeakerToWaitFor;

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
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


