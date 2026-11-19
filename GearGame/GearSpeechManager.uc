/**
 * Class: GearSpeechManager
 * Globally monitors and arbitrates character speech.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearSpeechManager extends Actor
	native(Sound);

var transient protected float	LastUpdateTime;
var() protected const float		TimeBetweenUpdates;

enum DialogueSoundClass
{
	DSC_Normal,
	DSC_Medium,
	DSC_MediumNoDSP,
	DSC_Loud,
	DSC_Deafening,
	DSC_DeafeningSloMo,
};

var() protected const array<Name> DialogueSoundClassNames;
var() protected const array<Name> DialogueSoundClassModesMap;

struct native ActiveDialogueLine
{
	/** Who is speaking */
	var Actor						Speaker;

	/** Who is being spoken to */
	var Actor						Addressee;

	/** Audio data */
	var	SoundCue					Audio;

	/** speech priority */
	var ESpeechPriority				Priority;

	/** Timestamp the dialogue should finish. Used for audio with no speaker. */
	var float                       FinishTime;
};

/** Stack of active dialogue lines. */
var transient array<ActiveDialogueLine>	DialogueStack;

cpptext
{
	virtual void TickSpecial(FLOAT DeltaTime);
}

/** Call to notify the speech manager that this bit of dialogue is starting */
final native function NotifyDialogueStart(Actor Speaker, Actor Addressee, SoundCue Audio, ESpeechPriority Pri);

/** Call to notify the speech manager that this bit of dialogue is finished */
final native function NotifyDialogueFinish(Actor Speaker, SoundCue Audio);

/** Returns true if there is any speech active at the given priority.  If PriFilter is None, it will return true for any priority. */
simulated native final function bool IsSpeechActive(ESpeechPriority PriFilter) const;

/** Returns appropriate dialogue soundmode name */
simulated native function Name GetDialogueSoundMode(GearPC PC) const;

defaultproperties
{
	TickGroup=TG_DuringAsyncWork
	TimeBetweenUpdates=1.f

	DialogueSoundClassModesMap(DSC_Normal)="DialogVolumeDucking"
	DialogueSoundClassModesMap(DSC_Medium)="DialogVolumeDuckingMedium"
	DialogueSoundClassModesMap(DSC_MediumNoDSP)="DialogVolumeDuckingMedium"
	DialogueSoundClassModesMap(DSC_Loud)="DialogVolumeDuckingLoud"
	DialogueSoundClassModesMap(DSC_Deafening)="DialogVolumeDuckingDeafening"
	DialogueSoundClassModesMap(DSC_DeafeningSloMo)="DialogVolumeDuckingDeafeningSloMo"

	DialogueSoundClassNames(DSC_Normal)="DialogSoft"
	DialogueSoundClassNames(DSC_Medium)="DialogMedium"
	DialogueSoundClassNames(DSC_MediumNoDSP)="DialogNoDSP"
	DialogueSoundClassNames(DSC_Loud)="DialogLoud"
	DialogueSoundClassNames(DSC_Deafening)="DialogDeafening"
	DialogueSoundClassNames(DSC_DeafeningSloMo)="DialogDeafeningSloMo"

}
