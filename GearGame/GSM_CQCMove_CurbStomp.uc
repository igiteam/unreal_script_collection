
/**
 * CQC Move (Close Quarter Combat) CurbStomp
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CQCMove_CurbStomp extends GSM_CQC_Killer_Base;

/** Screen Shake play on impact */
var	protected const GearCameraShake    ImpactScreenShake;

var protected const Array<CameraAnim>	    CameraAnims;

function PlayExecution()
{
	// Play execution Camera Animation.
	if( CameraAnims.Length > 0 )
	{
		PlayExecutionCameraAnim(CameraAnims);
	}

	PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_CurbStompLongExecutionEffort, true);
	SplashBloodOnScreen(class'Emit_CameraBlood_CurbStomp');

	Super.PlayExecution();
}

/** Called on a timer when doing a curb stomp. */
function KillVictim()
{
	if( PCOwner != None )
	{
		// Play Force Feed Back effect
		PCOwner.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);

		// Play Screen Shake effect
		if (ImpactScreenShake != None)
		{
			PCOwner.ClientPlayCameraShake(ImpactScreenShake);
		}
	}

	Super.KillVictim();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	PawnOwner.BS_StopAll(0.25f);
}

defaultproperties
{
	BS_KillerAnim=(Stance=((Slot=BS_FullBody,AnimName="CTRL_SmashFace")))
	BS_VictimAnim=(Stance=((Slot=BS_FullBody,AnimName="DBNO_SmashFace")))
	VictimDeathTime=1.31f
	VictimRotStartTime=0.42f
	VictimRotInterpSpeed=8.f
	MarkerRelOffset=(X=84.57,Y=27.19,Z=0.0)

	CameraAnims(0)=CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_SmashFace_Cam01'
	CameraAnims(1)=CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_SmashFace_Cam02'
	CameraAnims(2)=CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_SmashFace_Cam03'
	CameraAnims(3)=CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_SmashFace_Cam04'
 
// 	// camera shake
// 	Begin Object Class=GearCameraShake Name=ImpactScreenShake0
// 		OscillationDuration=0.f
// 		RotOscillation={(Pitch=(Amplitude=1500.f,Frequency=10.f),
// 						Yaw=(Amplitude=500.f,Frequency=10.f),
// 						Roll=(Amplitude=250.f,Frequency=10.f))}
// 		LocOscillation={(X=(Amplitude=-10.f,Frequency=10.f,InitialOffset=EOO_OffsetZero),
// 						Y=(Amplitude=2.f,Frequency=10.f),
// 						Z=(Amplitude=2.f,Frequency=10.f))}
// 		FOVOscillation=(Amplitude=2.f,Frequency=5.f)
// 	End Object
// 	ImpactScreenShake=ImpactScreenShake0

	
	Action={(
		ActionName=CurbStomp,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))), // Y Button
							(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=284,V=346,UL=104,VL=91)))	),
	)}
}
