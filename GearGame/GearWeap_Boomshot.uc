/**
 * Boomshot
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_Boomshot extends GearWeap_BoomshotBase
	config(Weapon);

defaultproperties
{
	AIProjectileClass=class'GearProj_BoomshotAI'

	MinBlindFireUpAimPitch=-256
	MinBlindFireSideYaw=-600

	WeaponProjectiles(0)=class'GearProj_Boomshot'
	WeaponFireTypes(0)=EWFT_Projectile
	InstantHitDamageTypes(0)=class'GDT_Boomshot'
	AmmoTypeClass=class'GearAmmoType_Boomer'

	// Weapon anim set
	CustomAnimSets(0)=AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_Boomshot'

	FireSound=SoundCue'Weapon_Boomer.Firing.BoomerFireCue'
	FireSound_Player=SoundCue'Weapon_Boomer.Firing.BoomerFirePlayerCue'
	FireSound_Squad=SoundCue'Weapon_Boomer.Firing.BoomerFireSquadCue'

	WeaponDeEquipSound=SoundCue'Weapon_Shotgun.Actions.ShotgunRaiseCue'
	WeaponEquipSound=SoundCue'Weapon_Shotgun.Actions.ShotgunLowerCue'

	PickupSound=SoundCue'Weapon_Shotgun.Actions.ShotgunPickupCue'
	WeaponDropSound=SoundCue'Weapon_Sniper.Actions.CogSniperDropCue'

	AlmostOutOfAmmoSound=SoundCue'Weapon_Boomer.Weapons.BoomerFirePlayerEmptyCue'

	// Weapon Mesh Transform
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'Locust_Boomshot.Mesh.Locust_Boomshot'
		AnimTreeTemplate=AnimTree'Locust_Boomshot.AT_Boomshot'
		PhysicsAsset=PhysicsAsset'Locust_Boomshot.Mesh.Locust_Boomshot_Physics'
		AnimSets(0)=AnimSet'Locust_Boomshot.Animation.Animset_Locust_Boomshot'
		Rotation=(Pitch=1092)	//+6d
		Translation=(X=+8)
		Scale=0.75f
	End Object

	Begin Object Class=StaticMeshComponent Name=MagazineMesh0
		StaticMesh=StaticMesh'Locust_Boomshot.Mesh.Locust_Boomshot_Magazine'
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
	End Object
	MagazineMesh=MagazineMesh0

	DamageTypeClassForUI=class'GDT_Boomshot'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=367,V=146,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=144,UL=128,VL=39)
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Boomshot'

	HUDDrawData			= (DisplayCount=1,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=257,UL=36,VL=8),ULPerAmmo=36)
	HUDDrawDataSuper	= (DisplayCount=1,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=257,UL=36,VL=8),ULPerAmmo=36)

	MeleeImpactSound=SoundCue'Weapon_Boomer.Reloads.BoomerHitCue';


	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.5f
		RotOscillation={(Pitch=(Amplitude=300.f,Frequency=25.f,InitialOffset=EOO_OffsetZero),
						Yaw=(Amplitude=75.f,Frequency=25.f),
						Roll=(Amplitude=150.f,Frequency=50.f))}
		LocOscillation=(X=(Amplitude=-50.f,Frequency=1.f,InitialOffset=EOO_OffsetZero))
		bOverrideTargetingDampening=TRUE
		TargetingDampening=1.f
	End Object
	FireCameraShake=FireCameraShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.600)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_Boomshot_MuzFlash'

	// CQC Long Executions
	LongExecutions(3)={(CQC_Long_KillerAnim="CTRL_Boomshot",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="DBNO_Boomshot",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=2.6f,
						CQC_Long_VictimRotStartTime=0.0f,
						CQC_Long_VictimRotInterpSpeed=8.f,
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Boomshot_Cam01', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Boomshot_Cam02', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Boomshot_Cam03'),
						CQC_Long_DamageType=class'GDT_LongExecution_Boomshot',
						CQC_Long_EffortID=GearEffort_None,
						MarkerRelOffset=(X=84.570,Y=27.19,Z=0),
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_Boomshot',
						AwardRequired="BoomshotExecution")}
}
