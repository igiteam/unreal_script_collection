/**s
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoSentryTurret extends NanoSentryTurretBase
	placeable;

defaultproperties
{
	Begin Object Class=SkeletalMeshComponent Name=TurretMesh0
		SkeletalMesh=SkeletalMesh'TurretAssembleTest_02.Turret_Test'
		//PhysicsAsset=PhysicsAsset'TurretAssembleTest_01.Meshes.SK_AssembleTurret_Physics'
		AnimTreeTemplate=AnimTree'TurretAssembleTest_02.Meshes.Turret_AnimTree'
		AnimSets(0)=AnimSet'TurretAssembleTest_01.Meshes.TurretAssembleAnimset'
		Scale=5.f
		Translation=(X=0,Z=-80)
	End Object
	Mesh=TurretMesh0
	Components.Add(TurretMesh0)

	// define here as lot of sub classes which have moving parts will utilize this
	Begin Object Class=DynamicLightEnvironmentComponent Name=TurretLightEnvironment
	    bDynamic=FALSE
		bCastShadows=FALSE
		AmbientGlow=(R=0.3f,G=0.3f,B=0.3f,A=1.0f)
		TickGroup=TG_DuringAsyncWork
	End Object
//	MyLightEnvironment=TurretLightEnvironment
	Components.Add(TurretLightEnvironment)

	Begin Object Name=CollisionCylinder
		CollisionRadius=110
		CollisionHeight=80
	End Object

	Begin Object class=ParticleSystemComponent Name=ForgeFX0
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_CoalesceEffect_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_ForgeEffect0=ForgeFX0

	Begin Object class=ParticleSystemComponent Name=ForgeFX1
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_NanoBoom_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_ForgeEffect1=ForgeFX1


	Begin Object class=ParticleSystemComponent Name=ForgeTrail0
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail1
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail2
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail3
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail4
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail5
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail6
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail7
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail8
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	Begin Object class=ParticleSystemComponent Name=ForgeTrail9
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_Coalesce_SmallPiece_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	
	PSC_ForgeTrails.Add(ForgeTrail0)
	PSC_ForgeTrails.Add(ForgeTrail1)
	PSC_ForgeTrails.Add(ForgeTrail2)
	PSC_ForgeTrails.Add(ForgeTrail3)
	PSC_ForgeTrails.Add(ForgeTrail4)
	PSC_ForgeTrails.Add(ForgeTrail5)
	PSC_ForgeTrails.Add(ForgeTrail6)
	PSC_ForgeTrails.Add(ForgeTrail7)
	PSC_ForgeTrails.Add(ForgeTrail8)
	PSC_ForgeTrails.Add(ForgeTrail9)
	PSC_ForgeTrailSockets.Add("Effect_Tag_01")
	PSC_ForgeTrailSockets.Add("Effect_Tag_02")
	PSC_ForgeTrailSockets.Add("Effect_Tag_03")
	PSC_ForgeTrailSockets.Add("Effect_Tag_04")
	PSC_ForgeTrailSockets.Add("Effect_Tag_05")
	PSC_ForgeTrailSockets.Add("Effect_Tag_06")
	PSC_ForgeTrailSockets.Add("Effect_Tag_07")
	PSC_ForgeTrailSockets.Add("Effect_Tag_08")
	PSC_ForgeTrailSockets.Add("Effect_Tag_09")
	PSC_ForgeTrailSockets.Add("Effect_Tag_10")

	Begin Object class=ParticleSystemComponent Name=FinalPopFX
		Template=ParticleSystem'TurretAssembleTest_01.Effects.P_NanoFinalPop_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_ForgeEffect2=FinalPopFX

	ForgeSound=SoundCue'Gameplay_Audio.Forging.Player_ForgeSmg_Stereo_Cue'

	WeaponClass=class'NanoWeap_SentryTurret'
	ControllerClass=class'NanoAI_SentryTurret'

	PS_TookHit=ParticleSystem'Nano_Effects_Sentry_Turret.Impact.sparks'

	PS_Damaged_Small=ParticleSystem'AA_Test.Effects.PS_Fire_11'
	PS_Damaged_Alot=ParticleSystem'AA_Test.Effects.PS_Fire_13'

	PS_DeathExplosionEffect=ParticleSystem'BP_ExplosionAssets.Effects.P_BP_Explosion_Debris'


	DeathSound=SoundCue'Foley_Crashes.Explosions.G3_ExplosionGenericC_Stereo03_Cue'

	ScanningSound=SoundCue'Weapon_SentryTurret.BeamBeep_Cue'

	AboutToFireSound=SoundCue'Vehicle_SecurityBot.SecurityBot.SecurityBot_AlarmLoop03_Cue'

	DoneFiringSound=SoundCue'Weapon_HeavyMiniGun.Gatling.GatlingHeatSteamVentOpenCue'

	ImpactedByWeaponSound=SoundCue'Weapon_AssaultRifle.Impacts.CogRifleImpactMetalSolidCue'

	DamagedAndOnFireSound=SoundCue'Ambient_Loops.Fires.fire_small04Cue'

}
