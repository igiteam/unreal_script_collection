/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoTargetPoint_CityScan extends NanoTargetPoint_CityScanBase;


defaultproperties
{
	SupportedEvents.Add(class'SeqEvt_CityScanAudioComplete')

	TargetMaterial=Material'Nano_WeaponFX.Missile.Materials.M_Missile_IncomingReticle'

	Begin Object Class=StaticMeshComponent Name=TargetMesh0
		StaticMesh=StaticMesh'Nano_FX_Enviro.Meshes.S_Sheet'
		Rotation=(Yaw=16384)
		Scale=3.f
		DepthPriorityGroup=SDPG_Foreground
	End Object
	TargetMesh=TargetMesh0
	Components.Add(TargetMesh0)

	bHidden=FALSE

	// Default scrambled loop
	ScanScrambledAudio=SoundCue'Gameplay_Audio.AudioScan.AudioScan_RadioTunedOutLP_01Cue'

	TuningDistance=0.1
	ScanAudioMaxSpeed=0.05

	ActiveTargetColor=(B=3.f,A=1.f)
	InactiveTargetColor=(G=3.f,A=1.f)
}