
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_DoorKick extends GSM_DoorPush;

var ForceFeedbackWaveform KickFF;
var GearPawn_SilverbackLoaderBase LoaderSilverback;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	if (!IsUsingAnimOverride())
	{
		if (PCOwner != None && PCOwner.IsLocalPlayerController())
		{
			PCOwner.SetTimer(0.7,FALSE,nameof(PlayKickFF),self);
		}
	}
}

function float PlayMyAnim()
{
	local float RetVal;

	LoaderSilverBack = GearPawn_SilverbackLoaderBase(PawnOwner);
	// Silverback has a special animation to use there.
	if( LoaderSilverBack != None )
	{
		BS_Animation.Stance[0].AnimName = 'Loader_Kick_Carrying';
	}
	else if( GearPawn_SilverbackArmedBase(PawnOwner) != None )
	{
		BS_Animation.Stance[0].AnimName = 'SB_Kick';
	}


	RetVal = Super.PlayMyAnim();

	// If on a loader, then also play this animation on the driver.
	if( LoaderSilverback != None && LoaderSilverback.Driver != None )
	{
		LoaderSilverback.Driver.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE, true);
	}

	return RetVal;
}

function PlayKickFF()
{
	PCOwner.ClientPlayForceFeedbackWaveform(KickFF);
}

defaultproperties
{
	SpecialMoveCameraBoneAnims(0)=(AnimName="Camera_Door_Kick")

	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="door_kick")))
	SpecialMoveID=SM_DoorKick

	bDisablePOIs=TRUE

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformKick1
		Samples(0)=(LeftAmplitude=65,RightAmplitude=65,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.2)
	End Object
	KickFF=ForceFeedbackWaveformKick1
}