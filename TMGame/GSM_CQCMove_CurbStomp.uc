
/**
 * CQC Move (Close Quarter Combat) CurbStomp
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CQCMove_CurbStomp extends GSM_CQC_Killer_Base;

/** Screen Shake play on impact */
//var	ScreenShakeStruct	ImpactScreenShake;

var Array<CameraAnim>	CameraAnims;

function PlayExecution()
{
	// Play execution Camera Animation.
	if( CameraAnims.Length > 0 )
	{
		PlayExecutionCameraAnim(CameraAnims);
	}

	// Play Face FX Emotion
	if( !PawnOwner.IsActorPlayingFaceFXAnim() )
	{
		PawnOwner.PlayActorFaceFXAnim(None, "Emotions", "Strained", None);
	}

	//PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_CurbStompLongExecutionEffort, true);

	Super.PlayExecution();
}

/** Separate function, so other executions can implement their variations. */
function SetVictimRotation()
{
	// Override rotation.
	VictimDesiredYaw = NormalizeRotAxis(Rotator(-DirToVictim).Yaw + 16384);
	Super.SetVictimRotation();
}

/** Called on a timer when doing a curb stomp. */
function KillVictim()
{
	//if( PCOwner != None )
	//{
	//	// Play Force Feed Back effect
	//	PCOwner.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);

	//	// Play Screen Shake effect
	//	//PCOwner.ClientPlayCameraShake(ImpactScreenShake);
	//}

	Super.KillVictim();
}

