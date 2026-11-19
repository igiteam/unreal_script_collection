
/**
 * Torque Bow content class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_Bow extends GearWeap_BowBase
	config(Weapon);

defaultproperties
{
	LaunchSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_FireCue'

	WeaponProjectiles(0)=class'GearProj_Arrow'

	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'Locust_Torquebow.TorqueBow'
		PhysicsAsset=PhysicsAsset'Locust_Torquebow.TorqueBow_Physics'
		AnimTreeTemplate=AnimTree'Locust_Torquebow.AT_TorqueBow'
		AnimSets(0)=AnimSet'Locust_Torquebow.TorqueBowAnims'
	End Object

	Begin Object Name=MagazineMesh0
		StaticMesh=StaticMesh'Locust_Torquebow.Locust_Torquebow_Rocket'
	End Object

	Begin Object Name=ArrowMesh0
		StaticMesh=StaticMesh'Locust_Torquebow.Locust_Torquebow_Rocket'
	End Object

	// Max charge trail beam
	Begin Object Name=TBParticleSystemComponent0
		Template=ParticleSystem'Locust_Torquebow.Effects.COG_Beam_Full_Charge'
	End Object

	//PS_StartPoint=ParticleSystem'Locust_Torquebow.EffectS.PS_Torquebow_aim_start'
	PS_TrailCOG=ParticleSystem'Locust_Torquebow.EffectS.PS_Locust_Torquebow_aim_Beam'
	PS_TrailLocust=ParticleSystem'Locust_Torquebow.Effects.PS_Locust_Torquebow_aim_Beam_Red'

 	PS_EndPointCOG=ParticleSystem'Locust_Torquebow.Effects.PS_Locust_Torquebow_Endpoint_Blue'
 	PS_EndPointLocust=ParticleSystem'Locust_Torquebow.Effects.PS_Locust_Torquebow_Endpoint_Red'

	PS_EndPointFullCharge=ParticleSystem'Locust_Torquebow.Effects.P_Torque_FULL_Charge_New'
//	PS_EndPointFail=ParticleSystem'Locust_Torquebow.EffectS.P_Torquebow_Fail'

	WeaponIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_WeaponIcons',U=0,V=241,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=183,UL=128,VL=48)
	HUDDrawData			= (DisplayCount=1,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=273,UL=106,VL=7),ULPerAmmo=106)
	HUDDrawDataSuper	= (DisplayCount=1,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=273,UL=106,VL=7),ULPerAmmo=106)

	// Weapon anim set
	CustomAnimSets(0)=AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_Torquebow'

	Begin Object Class=ForceFeedbackWaveform Name=MaxChargeWaveform0
		Samples(0)=(LeftAmplitude=32,RightAmplitude=32,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.15)
	End Object
	MaxChargeWaveform=MaxChargeWaveform0

	WeaponDeEquipSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_UnstowCue'
	WeaponEquipSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_StowCue'

	AimLoop=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_BuildCue'
	AlmostOutOfAmmoSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_FireEmptyCue'

	MeleeImpactSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_HitCue'

	PS_TorqueBowChargeUp=ParticleSystem'Locust_Torquebow.Effects.P_Torquebow_MF_ChargeUP'

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.5f
		RotOscillation={(Pitch=(Amplitude=25.f,Frequency=100.f),
						Yaw=(Amplitude=25.f,Frequency=100.f),
						Roll=(Amplitude=12.f,Frequency=250.f))}
		bOverrideTargetingDampening=TRUE
		TargetingDampening=1.f
	End Object
	FireCameraShake=FireCameraShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
	    Samples(0)=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.400)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	// CQC Long Executions
	LongExecutions(3)={(CQC_Long_KillerAnim="CTRL_torquebow",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="DBNO_torquebow",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=1.6f,
						CQC_Long_VictimRotStartTime=0.f,
						CQC_Long_VictimRotInterpSpeed=0.f,
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_torquebow_Cam01',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_torquebow_Cam02',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_torquebow_Cam03'),
						CQC_Long_DamageType=class'GDT_LongExecution_Bow',
						CQC_Long_EffortID=GearEffort_TorquebowLongExecutionEffort,
						MarkerRelOffset=(X=84.570,Y=27.190,Z=0),
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_TorqueBow',
						AwardRequired="TorquebowExecution")}

	BowMeleeSwingSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_MeleeCue'

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_Bow_MuzFlash'
}

