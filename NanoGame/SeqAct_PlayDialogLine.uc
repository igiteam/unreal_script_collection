/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqAct_PlayDialogLine extends SequenceAction
	native(Sequence);

/** If true, force this line to play, even if the player is trying to cancel the briefing */
var()   bool    bForcePlayWhenBriefingCancelled;

/** Number of tracks to display output links for */
var()   int     OutputTrackLinks;

/** Track index...chosen based on the pawn's status. 0 is the default track */
var editconst   int     TrackIndex;

//--------------------------------------------------------
// Dialog track independent variables
//--------------------------------------------------------
/** The pawn to play this dialog line */
var()   NanoPawn        Speaker;
/** The player's pawn.  If none is specified, the action will attempt to find one */
var()   NanoPawn        PlayerPawn;
/** The mission giver's pawn.  If none is specified, the action will attempt to find one */
var()   NanoPawn_Rebels_QuestGiverBase MissionGiverPawn;
/** Sound cue containing the lines and subtitles to play */
var()   SoundCue        DialogToPlay;
/** Corresponding FaceFX animation name */
var()   string          FaceFXAnim;
/** Anim set that the above FaceFX anim is in */
var()   FaceFXAnimSet   FaceFXAnimSet;
/** Group that the above FaceFX anim is in */
var()   string          FaceFXGroup;

//--------------------------------------------------------
// Dialog track dependent variables
// Note:    If no entry for the current track index is
//          specified, assume the default track value of 0
//--------------------------------------------------------
/** If set, the camera will swap to this camera actor */
var()   array<CameraActor>  PerTrack_OverrideCamera;
/** If set, the camera will swap to this camera actor */
var()   array<Actor>        PerTrack_CameraTarget;
/** Camera animation to play on the player's pawn, if any */
var()   array<CameraAnim>   PerTrack_CameraAnim;
/** If set, play this full body animation on the speaker */
var()   array<Name>         PerTrack_MissionGiverAnimToPlay;
/** If set, play this full body animation on the player */
var()   array<Name>         PerTrack_PlayerAnimToPlay;

// Temporary audio component to play the dialog if there isn't a FaceFX asset
var transient AudioComponent DialogAudioComponent;

// Used to pass the duration of the sound cue out to other nodes that may need it (e.g. CameraCutByDuration).  Gets decremented in UpdateOp() to track approximate time left for the line
var transient float LineDuration;

cpptext
{
	void PostLoad();
	void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	UBOOL FixupMissingVarLinks(FString VariableDesc);

	void Activated();
	UBOOL UpdateOp(FLOAT deltaTime);
	void PublishLinkedVariableValues();
	void DeActivated();
};

simulated function OnAudioFinished(AudioComponent AC)
{
	// Fire off the "line finished" output link
	ActivateOutputLink(1);
}

simulated function OnQueueSubtitles(array<SubtitleCue> Subtitles, float CueDuration)
{
	local NanoPC NPC;
	local float Duration;
	local int i;

	if( PlayerPawn != None )
	{
		NPC = NanoPC(PlayerPawn.Controller);

		if( NPC != None )
		{
			// Queue up the subtitles for display as mission briefing text, with the pawn's name as the speaker
			for( i = 0; i < Subtitles.Length; i++ )
			{
				Duration = (Subtitles.Length > i+1 ? Subtitles[i+1].Time : CueDuration) - Subtitles[i].Time;
				NPC.SetMissionBriefingText(Speaker.GetHumanReadableName() $ ":", Subtitles[i].Text, Duration);
			}
		}
	}
}

simulated function OnCancelBriefing()
{
	if( !bForcePlayWhenBriefingCancelled )
	{
		// When cancelled, fade out the audio briefing, which will cause the action to end
		if( DialogAudioComponent != None )
		{
			DialogAudioComponent.FadeOut(0.1f, 0.f);
		}

		// Similarly, stop the FaceFX anim, if there is one playing
		if( (Speaker != None) && Speaker.IsPlayingFaceFXAnim() )
		{
			Speaker.StopActorFaceFXAnim();
		}

		if( PlayerPawn != None )
		{
			NanoPC(PlayerPawn.Controller).ClearMissionBriefingText();
		}
	}
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
	return Super.GetObjClassVersion() + 6;
}

defaultproperties
{
	ObjName="Play Briefing Dialog Line"
	ObjCategory="Nano Briefing"

	bLatentExecution=true
	bAutoActivateOutputLinks=false

	OutputLinks(1)=(LinkDesc="Line Finished")
	OutputLinks(2)=(LinkDesc="Idle")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Speaker",bWriteable=false,PropertyName=Speaker,MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Track",bWriteable=false,PropertyName=TrackIndex,MaxVars=1)
	VariableLinks(2)=(ExpectedType=Class'SeqVar_Float',LinkDesc="Duration",bWriteable=true,PropertyName=LineDuration,bHidden=true)
}
