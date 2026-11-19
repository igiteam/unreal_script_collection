/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class NanoVehicleSpline_TrafficLight extends NanoVehicleSpline_TrafficLightBase;
	


defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=MyTrafficLightComp
		StaticMesh=StaticMesh'Nano_TrafficHardware.Meshes.S_Nano_HoverTrafficLamp_01'
		Translation=(Z=700.0)
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
	End Object
	CollisionComponent=MyTrafficLightComp
	TrafficLightMesh=MyTrafficLightComp
	Components.Add(MyTrafficLightComp)

	bCollideActors=TRUE

	LightChangingColors=SoundCue'Gameplay_Audio.TrafficControl.Traffic_LightChange_01Cue'

	PS_AbsorbBeam=ParticleSystem'MET_TechTick.Effects.P_MET_TechTick_Absorb_Beam'
	AbsorbEffectsSocketName="HandForge"

	LightHackedSound=SoundCue'Gameplay_Audio.NanoHack.NanoHack_TrafficLight_Cue'

	TrafficSignalHasBeenHackedSound=SoundCue'Dialog_City_Chatter.Traffic.City_UnauthTrafficSignal_01Cue'

	bSpawnPerchPoint=TRUE
	bShowTrafficLightMesh=TRUE

	RemoteRole=ROLE_SimulatedProxy

	bManageTraffic=FALSE
}