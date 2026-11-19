/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_PoliceCar extends NanoPawn_MetaCorp_PoliceCarBase;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// The second slot controls the lightbar
	MIC_Lightbar = Mesh.CreateAndSetMaterialInstanceConstant(1);
}


defaultproperties
{
	ControllerClass=class'NanoAI_PoliceCar'
	WeaponClass=class'NanoWeap_PoliceCarMiniGun'

	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent_0
		SkeletalMesh=SkeletalMesh'MET_CopCar.Meshes.SK_MET_CopCar_Flying'
		PhysicsAsset=PhysicsAsset'MET_CopCar.Meshes.SK_MET_CopCar_Flying_Physics'
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE,Untitled2=TRUE,Untitled3=TRUE)
	    BlockRigidBody=TRUE
		bNotifyRigidBodyCollision=TRUE
		Translation=(Z=-80)
	End Object
	Mesh=SkeletalMeshComponent_0
	Components.Add(SkeletalMeshComponent_0)

	Begin Object Name=CollisionCylinder
	    CollisionRadius=+0120.000000
		CollisionHeight=+0060.000000
	End Object
	CollisionComponent=CollisionCylinder

	Begin Object Class=AudioComponent Name=AudioComponent_0
	End Object
	EngineAC=AudioComponent_0
	Components.Add(AudioComponent_0)

	SearchlightLensFlareTemplate=LensFlare'Nano_LensFlares.Flares.LF_SearchLight'
	SearchlightLightConeMesh=StaticMesh'EngineVolumetrics.LightBeam.Mesh.S_EV_SimpleLightBeam_01'

	DeadSkelMesh=SkeletalMesh'MET_CopCar.Meshes.SK_MET_CopCar_Crushed'

	PreDeathEffect=ParticleSystem'Nano_Effects_Cine.CHL_P_End.P_Car_Explosion'
	DeathEffect=ParticleSystem'MET_FlyingCar01.Effects.P_Nano_FlyingCar_Destruction'
	DeathEffectGlass=ParticleSystem'Nano_Effects_Cine.CHL_End.P_Car_Window_Shatter'
	DeathTrailEffect=ParticleSystem'Nano_Effects_Cine.CHL_P_End.P_Fire_Trail_1'
	PostDeathBurningFlames=ParticleSystem'Nano_Effects_Cine.CHL_P_End.P_Fire_Large'

	DeathSoundCue=SoundCue'Vehicle_PoliceAirCar.PoliceAirCar_Engine.PoliceAirCar_Crash_Stereo_01_Cue'
	CrashSoundCue=SoundCue'Vehicle_AirCar.Impacts.CarImpact_Mix_Cue'

	NormalEngineCue=SoundCue'Vehicle_PoliceAirCar.PoliceAirCar_Engine.PoliceAirCar_RunningLoop_01_Cue'
	FastEngineCue=SoundCue'Vehicle_PoliceAirCar.PoliceAirCar_Engine.PoliceAirCar_RunningHighLoop_01_Cue'
	RevvingEngineCue=SoundCue'Vehicle_PoliceAirCar.PoliceAirCar_Engine.PoliceAirCar_RunningRev_01_Cue'


	YelperSound=SoundCue'Vehicle_PoliceAirCar.Sirens.PoliceCar_SirenChirp_Cue'

	SearchlightSocketName=Searchlight

	//Texture2D'UI_HUD.Minimap.MetaCorpPoliceCar'
	//Texture2D'UI_HUD.Minimap.MetaCorpPoliceCarL'
	//Texture2D'UI_HUD.Minimap.MetaCorpPoliceCarR'

	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=FALSE,DistancesToDrawIcon=(X=0,Y=0),Icon=Texture2D'UI_HUD.Minimap.MetaCorpPoliceCar',IconScale=0.10f,IconColor=(R=255,G=64,B=64,A=255),bAlternateAboveBelowIcon=FALSE,AboveBelowIconScale=0.08f,TextName="",TextDescription="",TextVerticalOffset=0.0f)
	End Object
	UIComponent=UIIconComponent0


	DroppedOrbClasses.Add(class'NanoAbsorbOrb_PoliceCar')
	DroppedOrbClasses.Add(class'NanoAbsorbOrb_PoliceCar')
	DroppedOrbClasses.Add(class'NanoAbsorbOrb_CurrencySmall')
}


