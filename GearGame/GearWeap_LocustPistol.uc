/**
 * Locust Boltock pistol
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_LocustPistol extends GearWeap_PistolBase;

simulated function float GetWeaponRating()
{
	local GearAI_TDM AI;

	// always equip pistol when kidnapping
	if (GearAIController != None && GearAIController.MyGearPawn != None && GearAIController.MyGearPawn.IsAKidnapper())
	{
		return 10.0;
	}

	// more desireable around medium range
	AI = GearAI_TDM(GetWeaponController());
	if ( AI != None && AI.Enemy != None && VSize(AI.GetEnemyLocation() - AI.Pawn.Location) < AI.EnemyDistance_Medium * 1.5 &&
		!AI.IsShortRange(AI.GetEnemyLocation()) )
	{
		return 1.0 + 0.3 * FRand();
	}

	return Super.GetWeaponRating();
}

simulated function EjectClip()
{
	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolClipEjectCue');
}
simulated function CockOpen()
{
	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolCockOpenCue');
}
simulated function CockClose()
{
	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolCockCloseCue');
}

simulated function InsertClip()
{
	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolClipReloadInsertCue');
}

simulated function Jammed()
{
	WeaponPlaySound(SoundCue'Weapon_Pistol.Actions.CogPistolDropCue');
}

simulated function HandSlam()
{
	WeaponPlaySound(SoundCue'Weapon_AssaultRifle.Reloads.CogRifleJammedHandCue');
}
simulated function ClipImpact()
{
	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolClipEjectImpactCue');
}

defaultproperties
{
	WeaponStatName="Boltok"
	
	AIRating=0.5

	FireAnimRateScale=2.5

	bWeaponCanBeReloaded=TRUE

	InstantHitDamageTypes(0)=class'GDT_LocustPistol'
	AmmoTypeClass=class'GearAmmoType_PistolHighPowered'

	FireSound=SoundCue'Weapon_Pistol.Boltok.BoltokPistolFireEnemyCue'
	FireSound_Player=SoundCue'Weapon_Pistol.Boltok.BoltokPistolFirePlayerCue'
	FireSound_Squad=SoundCue'Weapon_Pistol.Boltok.BoltokPistolFireSquadCue'
	FireNoAmmoSound=SoundCue'Weapon_Pistol.Firing.LocustPistolFireEmptyCue'	

	BulletWhipArchetype=GearBulletWhip'GearSoundGroupArchetypes.BulletWhips.LocustPistol'

	WeaponReloadSound=None
	TracerType=WTT_Boltok
	TracerTypeAR=WTT_Boltok_AR

	WeaponEquipSound=SoundCue'Weapon_Pistol.Actions.LocustPistolRaiseCue'
	WeaponDeEquipSound=SoundCue'Weapon_Pistol.Actions.LocustPistolLowerCue'
	PickupSound=SoundCue'Weapon_Pistol.Actions.LocustPistolPickupCue'
	WeaponDropSound=SoundCue'Weapon_Pistol.Actions.LocustPistolDropCue'

	// Weapon Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'Locust_Pistol.Boltock_Pistol'
		PhysicsAsset=PhysicsAsset'Locust_Pistol.Boltock_Pistol_Physics'
		AnimSets(0)=AnimSet'Locust_Pistol.animset_Boltock_Pistol'
		Animations=WeaponAnimNode
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	WeaponFireAnim=""
	WeaponReloadAnim="Reload"
	WeaponReloadAnimFail="Reload_Fail"

	CustomAnimSets.Add(AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_Boltok')

	PSC_ShellEject=none // locust pistol doesn't eject shells!

	// reload barrel smoke
	Begin Object Name=PSC_WeaponReloadBarrelSmokeComp
		Template=ParticleSystem'Locust_Pistol.Effects.P_Geist_Pistol_Smoke'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	Recoil_Hand={(
		LocAmplitude=(X=-15,Y=2,Z=9),
		LocFrequency=(X=8,Y=20,Z=15),
		LocParams=(X=ERS_Zero,Y=ERS_Random,Y=ERS_Zero),
		RotAmplitude=(X=10000,Y=500,Z=500),
		RotFrequency=(X=8,Y=20,Z=8),
		RotParams=(X=ERS_Zero,Y=ERS_Random,Y=ERS_Random),
		TimeDuration=0.45f,
	)}

	Recoil_Spine={(
		RotAmplitude=(X=1000,Y=000,Z=0),
		RotFrequency=(X=13,Y=10,Z=0),
		RotParams=(X=ERS_Zero,Y=ERS_Random,Y=ERS_Zero),
		TimeDuration=0.9f,
	)}

	bInstantHit=true
	bIsSuppressive=FALSE

	NeedReloadNotifyThreshold=2

	DamageTypeClassForUI=class'GDT_LocustPistol'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=367,V=99,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=79,UL=128,VL=40)
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Snub'
	HUDDrawData			= (DisplayCount=6,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=281,UL=106,VL=7),ULPerAmmo=17)
	HUDDrawDataSuper	= (DisplayCount=6,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=281,UL=106,VL=7),ULPerAmmo=17)

	MeleeImpactSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_HitCue';

	LC_EmisDefaultCOG=(R=0.0,G=2.0,B=25.0,A=1.0)
	LC_EmisDefaultLocust=(R=15.0,G=2.0,B=0.0,A=1.0)

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.5f
		RotOscillation={(Pitch=(Amplitude=500.f,Frequency=10.f,InitialOffset=EOO_OffsetZero),
						Yaw=(Amplitude=-200.f,Frequency=5.f),
						Roll=(Amplitude=250.f,Frequency=25.f))}
		LocOscillation={(X=(Amplitude=-5.f,Frequency=10.f,InitialOffset=EOO_OffsetZero),
						Z=(Amplitude=2.5f,Frequency=10.f))}
		FOVOscillation=(Amplitude=1.f,Frequency=1.f,InitialOffset=EOO_OffsetZero)
		bOverrideTargetingDampening=TRUE
		TargetingDampening=0.8
	End Object
	FireCameraShake=FireCameraShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=50,RightAmplitude=80,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.600)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	WeaponID=WC_Boltock

	// CQC Long Executions
	LongExecutions(3)={( CQC_Long_KillerAnim="CTRL_Handgun_A",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="DBNO_Handgun_A",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Handgun_A_Cam01',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Handgun_A_Cam02',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Handgun_A_Cam03'),
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=1.36f,
						CQC_Long_VictimRotStartTime=0.f,
						CQC_Long_VictimRotInterpSpeed=0.f,
						MarkerRelOffset=(X=84.570,Y=27.190,Z=0),
						CQC_Long_EffortID=GearEffort_BoltokLongExecutionEffort,
						CQC_Long_DamageType=class'GDT_LongExecution_Boltok',
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_Handgun_A',
						AwardRequired="BoltokExecution")}

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_Boltok_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Boltok_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Boltok_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_Boltok_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Boltok_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Boltok_Cov_Std_Reload_Fail"))
		)}

	bCanDoIronSights=false		// enable with "ironsights" console command
	IronSightsCameraOffset=(x=20,z=-14.6)
	IronSightsCameraRotOffset=(Pitch=182)

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_LocustPistol_MuzFlash'
}
