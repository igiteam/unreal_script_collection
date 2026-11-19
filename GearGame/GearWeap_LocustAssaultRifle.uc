/**
 * Locust Assault Rifle: Hammerburst
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_LocustAssaultRifle extends GearWeapon;

/** How much extra recoil to add each time the weapon is fired. */
var() protected const config float	ExtraRecoilPerShot;
/** How much extra recoil to add each time the weapon is fired for AR-bonus shots. */
var() protected const config float	ExtraRecoilPerShotAR;

/** the aim error when zoomed */
var() protected const config vector2d WeaponZoomedAimError;

/** How much extra recoil there is currently (this diminishes over time) */
var protected transient float		CurrentExtraRecoil;

/** FOV (in deg) of the zoomed state of this weapon */
var() protected const config float	ZoomFOV;

/** number of shots remaining in AI quick fire */
var int BotFannedShots;

/** delay between button release and becoming able to fire again */
var config float ControlledEndFireDelay;

/** Crosshair dot */
var Texture2D CrosshairDot;
var Texture2D CrosshairDotZoomed;

/** Zoomed Muzzle Flash archetype */
var const GearMuzzleFlash ZoomedMuzzleFlashArchetype;

/** Zoomed muzzle flash */
var GearMuzzleFlash ZoomedMuzzleFlash;

/**
* Returns FOV, in deg, of this weapon when it is in targeting mode.
*/
simulated function float GetTargetingFOV( float BaseFOV )
{
	if( GearPawn(Instigator).bIsZoomed == TRUE )
	{
		return ZoomFOV;
	}
	else
	{
		return Super.GetTargetingFOV( BaseFOV );
	}
}

/** Overridden to add extra recoil to subsequent shots. */
simulated function PlayOwnedFireEffects( byte FireModeNum, vector HitLocation  )
{
	local GearPawn GP;

	super.PlayOwnedFireEffects(FireModeNum, HitLocation);

	GP = GearPawn(Instigator);
	if ((GP != None) && (GP.bActiveReloadBonusActive))
	{
		CurrentExtraRecoil += ExtraRecoilPerShotAR;
	}
	else
	{
		CurrentExtraRecoil += ExtraRecoilPerShot;
	}

}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	// ExtraRecoil diminishes such that it is zero at the default fire rate (only if we are not a GearAIController)
	if( (GearAIController == none) && (CurrentExtraRecoil > 0.f) )
	{
		CurrentExtraRecoil -= DeltaTime * ExtraRecoilPerShot / GetFireInterval(0);
		CurrentExtraRecoil = FMax(0.f, CurrentExtraRecoil);
	}
}

/**
 * Allow for a separate set of aim error values when zoomed
 *
 * @return the aim error
 */
simulated function float GetPlayerAimError()
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	if (GP != None && GP.bIsZoomed)
	{
		return Lerp(WeaponZoomedAimError.X, WeaponZoomedAimError.Y, GearInventoryManager(InvManager).Accuracy);
	}

	return Super.GetPlayerAimError();
}

simulated function StartFire(byte FireModeNum)
{
	local Actor Target;

	// don't bother firing if the enemy is really far away
	if (GearAIController != None && FireModeNum == 0)
	{
		Target = (GearAIController.FireTarget != None) ? GearAIController.FireTarget : GearAIController.Enemy;
		if (Target != None && VSize(Target.Location - GearAIController.Pawn.Location) > Range_Long * 1.5)
		{
			return;
		}
	}

	Super.StartFire(FireModeNum);
}

function SetupWeaponFire(byte FireModeNum)
{
	local GearAI_TDM Bot;

	Super.SetupWeaponFire(FireModeNum);

	// high level bots sometimes do the hammer on the button to fire faster thing
	Bot = GearAI_TDM(GetWeaponController());
	if ( Bot != None && Bot.GetDifficultyLevel() > DL_Normal && Bot.MyGearPawn != None &&
		(Bot.MyGearPawn.IsInCover() || Bot.MyGearPawn.bIsTargeting) &&
		FRand() < Bot.GetDifficultyLevel() * 0.25 )
	{
		BotFannedShots = 3 + Rand(4);
	}
	else
	{
		BotFannedShots = 0;
	}
}

simulated state Active
{
	simulated function BeginState( Name PreviousStateName )
	{
		super.BeginState(PreviousStateName);

		if (PreviousStateName != FiringStatesArray[0])
		{
			CurrentExtraRecoil = 0.f;
		}
	}
}

/** Attach the muzzle flash for use while in zoomed mode */
simulated function SetupScopeLighting()
{
	local SkeletalMeshComponent SkelMesh;

	Super.SetupScopeLighting();

	// Attach muzzle flash related effects
	if (Scope != None && Scope.Mesh != None && ZoomedMuzzleFlash != None && ZoomedMuzzleFlash.MuzzleSocketName != '')
	{
		SkelMesh = SkeletalMeshComponent(Scope.Mesh);

		// if we are pending kill then don't attach things
		if (SkelMesh.IsPendingKill())
		{
			return;
		}

		// attach muzzle flash emitter, and position to fire offset
		if (ZoomedMuzzleFlash.MuzFlashEmitter != None && !SkelMesh.IsComponentAttached(ZoomedMuzzleFlash.MuzFlashEmitter))
		{
			SkelMesh.AttachComponentToSocket(ZoomedMuzzleFlash.MuzFlashEmitter, ZoomedMuzzleFlash.MuzzleSocketName);
			HideMuzzleFlashEmitter();
		}
	}
}

/** Create the zoomed muzzle flash */
simulated protected function SetupMuzzleFlash()
{
	Super.SetupMuzzleFlash();

	if (ZoomedMuzzleFlash == None && ZoomedMuzzleFlashArchetype != None)
	{
		// Instance the muzzle flash archetype
		ZoomedMuzzleFlash = new(self) ZoomedMuzzleFlashArchetype.Class(ZoomedMuzzleFlashArchetype);
	}

	if (ZoomedMuzzleFlash != None)
	{
		if (ZoomedMuzzleFlash.MuzFlashEmitter != None)
		{
			if (ZoomedMuzzleFlash.MuzFlashParticleSystem != None)
			{
				ZoomedMuzzleFlash.MuzFlashEmitter.SetTemplate(ZoomedMuzzleFlash.MuzFlashParticleSystem);
				ZoomedMuzzleFlash.MuzFlashEmitter.SetTickGroup(TG_EffectsUpdateWork);
			}
			if (WorldInfo.GRI != None)
			{
				ZoomedMuzzleFlash.MuzFlashEmitter.SetLODLevel(GearGRI(WorldInfo.GRI).GetLODLevelToUse(ZoomedMuzzleFlash.MuzFlashParticleSystem, GetMuzzleLoc()));
			}
		}
	}
}

/** Play the special muzzle flash if zoomed */
simulated function PlayMuzzleFlashEffect()
{
	if (GearPawn(Instigator) != None && Instigator.IsLocallyControlled() && GearPawn(Instigator).bIsZoomed)
	{
		if (MuzzleFlash.MuzFlashEmitter != None)
		{
			MuzzleFlash.MuzFlashEmitter.SetOwnerNoSee(TRUE);
		}

		// activate muzzle flash particle system
		if (ZoomedMuzzleFlash.MuzFlashEmitter != None)
		{
			ZoomedMuzzleFlash.MuzFlashEmitter.SetHidden(FALSE);
			ZoomedMuzzleFlash.MuzFlashEmitter.SetOnlyOwnerSee(TRUE);

			ZoomedMuzzleFlash.MuzFlashEmitter.SetLODLevel(GearGRI(WorldInfo.GRI).GetLODLevelToUse(ZoomedMuzzleFlash.MuzFlashEmitter.Template, GetMuzzleLoc()));
			if (ZoomedMuzzleFlash.bMuzFlashEmitterIsLooping)
			{
				ZoomedMuzzleFlash.MuzFlashEmitter.SetActive(TRUE);
			}
			else
			{
				ZoomedMuzzleFlash.MuzFlashEmitter.ActivateSystem(true);
			}
		}
	}
	else if (MuzzleFlash.MuzFlashEmitter != None)
	{
		MuzzleFlash.MuzFlashEmitter.SetOwnerNoSee(FALSE);
	}

	Super.PlayMuzzleFlashEffect();
}

/** Stop the zoomed muzzle flash */
simulated function StopMuzzleFlashEffect()
{
	if (ZoomedMuzzleFlash != None && ZoomedMuzzleFlash.MuzFlashEmitter != None)
	{
		ZoomedMuzzleFlash.MuzFlashEmitter.SetActive(FALSE);
	}

	Super.StopMuzzleFlashEffect();
}

/** Hide the zoomed muzzle flash */
simulated function HideMuzzleFlashEmitter()
{
	if (ZoomedMuzzleFlash != None && ZoomedMuzzleFlash.MuzFlashEmitter != None)
	{
		ZoomedMuzzleFlash.MuzFlashEmitter.SetHidden(TRUE);
	}
}

simulated function float GetFireInterval(byte FireModeNum)
{
	local float Result;

	Result = Super.GetFireInterval(FireModeNum);
	// reduce fire interval directly instead of doing the human player path to make sure
	// all the usual AI notifications are called
	if (GearAIController != None && BotFannedShots > 0)
	{
		Result = FMax(Result * (0.7 - 0.2 * FRand()), ControlledEndFireDelay);
	}
	return Result;
}

/* FIXME:
function GetAIAccuracyCone(out vector2D AccCone_Min, out vector2D AccCone_Max)
{
	Super.GetAIAccuracyCone(AccCone_Min, AccCone_Max);

	// pitch accuracy penalty while fanning to mimic recoil
	if (BotFannedShots > 0)
	{
		AccCone_Min.X += 1.0;
	}
}
*/
simulated state WeaponFiring
{
	simulated function RefireCheckTimer()
	{
		if (BotFannedShots > 0)
		{
			BotFannedShots--;
		}

		Super.RefireCheckTimer();
	}

	simulated function EndFire(byte FireModeNum)
	{
		Global.EndFire(FireModeNum);
		SetTimer(ControlledEndFireDelay, false, nameof(DelayedReturnToActive));
	}
}

simulated function DelayedReturnToActive()
{
	if (IsInState('WeaponFiring'))
	{
		GotoState('Active');
	}
}

/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Hide Ammo part on weapon mesh
	SetWeaponAmmoBoneDisplay( FALSE );

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE);
}


/** notification fired from Pawn animation when player throws ammo */
simulated function Notify_AmmoThrow()
{
	local Vector	MagLoc;
	local Rotator	MagRot;

	if (Instigator != None)
	{
		// Detach magazine mesh from instigator's left
		SetPawnAmmoAttachment(FALSE);
		// Spawn physics Magazine from pawn's hand
		Instigator.Mesh.GetSocketWorldLocationAndRotation(GearPawn(Instigator).GetLeftHandSocketName(), MagLoc, MagRot);
		SpawnPhysicsMagazine(MagLoc, MagRot);
	}
}


/** notification fired from Pawn animation when player grabs another magazine. */
simulated function Notify_AmmoGrab()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE);
}


/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Detach magazine mesh from instigator's left
	SetPawnAmmoAttachment(FALSE);

	// Show Ammo part on weapon mesh.
	SetWeaponAmmoBoneDisplay(TRUE);
}

/*
simulated function LinearColor GetWeaponEmisColor_COG()
{
	return WorldInfo.Gears_COGWeapons.Hammerburst;
}

simulated function LinearColor GetWeaponEmisColor_Locust()
{
	return WorldInfo.Gears_LocustWeapons.Hammerburst;
}
*/

simulated function int GetWeaponRecoil()
{
	return super.GetWeaponRecoil() + CurrentExtraRecoil;
}

/**
 * Draw the center dot
 *
 * @param HUD - the HUD to draw on
 */
simulated function DrawAdditionalCrosshair(GearHUD_Base HUD)
{
	local float XL, YL;
	local Texture2D DotTex;
	local GearPawn GP;

	GP = GearPawn(Instigator);

	DotTex = (GP != None && GP.bIsZoomed) ? CrosshairDotZoomed : CrosshairDot;

	if (DotTex != None)
	{
		XL = DotTex.GetSurfaceWidth();
		YL = DotTex.GetSurfaceHeight();

		HUD.Canvas.SetPos(0.5f * (HUD.Canvas.ClipX - XL), 0.5f * (HUD.Canvas.ClipY - YL));
		HUD.Canvas.DrawTile(DotTex, XL, YL, 0, 0, XL, YL);
	}
}

/**
 * Don't draw the CrosshairIcon while zoomed, still want the additional crosshair drawing though
 *
 * @param PC - the controller using the crosshair
 *
 * @param XOffset - allow this function to modify where the crosshair is drawn
 *
 * @param YOffset - allow this function to modify where the crosshair is drawn
 *
 * @return a texture to draw for the crosshair
 */
simulated function Texture2D GetCrosshairIcon(GearPC PC, out float XOffset, out float YOffset)
{
	if (GearPawn(Instigator) == None || !GearPawn(Instigator).bIsZoomed)
	{
		return Super.GetCrosshairIcon(PC, XOffset, YOffset);
	}

	return None;
}

/** @return the value to scale the crosshair by */
simulated function float GetCrossHairScale()
{
	if (GearPawn(Instigator).bIsZoomed)
	{
		return 1.0f;
	}

	return Super.GetCrossHairScale();
}

/**
 * When zoomed the tracers need to start on the scope mesh's muzzle
 *
 * @return where the tracer should start
 */
simulated function vector GetTracerStartLoc()
{
	local vector TracerStart;

	if (!bSlaveWeapon && Scope != None && GearPawn(Instigator) != None && GearPawn(Instigator).bIsZoomed)
	{
		SkeletalMeshComponent(Scope.Mesh).GetSocketWorldLocationAndRotation('Muzzle', TracerStart);
		return TracerStart;
	}

	return GetMuzzleLoc();
}

defaultproperties
{
	WeaponStatName="Hammerburst"

	bWeaponCanBeReloaded=TRUE

	InstantHitDamageTypes(0)=class'GDT_LocustAssaultRifle'
	AmmoTypeClass=class'GearAmmoType_LocustAssaultRifle'

	FireSound=SoundCue'Weapon_AssaultRifle.LocustAssault.LocustARifleFireEnemyCue'
	FireSound_Player=SoundCue'Weapon_AssaultRifle.LocustAssault.LocustARifleFirePlayerCue'
	FireSound_Squad=SoundCue'Weapon_AssaultRifle.LocustAssault.LocustARifleFireSquadCue'
	FireNoAmmoSound=SoundCue'Weapon_AssaultRifle.Firing.LocustRifleFireEmptyCue'

	WeaponReloadSound=None

	BulletWhipArchetype=GearBulletWhip'GearSoundGroupArchetypes.BulletWhips.LocustAssaultRifle'

	WeaponEquipSound=SoundCue'Weapon_AssaultRifle.Actions.LocustRifleRaiseCue'
	WeaponDeEquipSound=SoundCue'Weapon_AssaultRifle.Actions.LocustRifleLowerCue'

	PickupSound=SoundCue'Weapon_AssaultRifle.Actions.LocustRiflePickupCue'
	WeaponDropSound=SoundCue'Weapon_AssaultRifle.Actions.LocustRifleDropCue'

	AIRating=1.f

	FireOffset=(X=44,Y=-1,Z=11)

	// Weapon Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'Locust_Hammerburst.Locust_Hammerburst'
		PhysicsAsset=PhysicsAsset'Locust_Hammerburst.Locust_Hammerburst_Physics'
		AnimTreeTemplate=AnimTree'Locust_Hammerburst.AT_HammerBurst'
		AnimSets(0)=AnimSet'Locust_Hammerburst.Locust_Hammerburst_Anims'
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	// shell case ejection emitter
	Begin Object Name=PSC_WeaponShellCaseComp
		Template=ParticleSystem'Locust_Hammerburst.EffectS.P_Locust_Hammerburst_Shells'
		Translation=(X=16,Z=6)
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp

	// reload barrel smoke
	Begin Object Name=PSC_WeaponReloadBarrelSmokeComp
		Template=ParticleSystem'Locust_Hammerburst.Effects.P_Locust_Hammerburst_Smoke'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	Begin Object Class=StaticMeshComponent Name=MagazineMesh0
		StaticMesh=StaticMesh'Locust_Hammerburst.Hammerburst_Magazine'
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
	End Object
	MagazineMesh=MagazineMesh0

	bCanDisplayReloadTutorial=TRUE
	DamageTypeClassForUI=class'GDT_LocustAssaultRifle'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=192,V=6,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=0,UL=128,VL=40)
	HUDDrawData=(DisplayCount=20,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=240,UL=80,VL=7),ULPerAmmo=4)
	HUDDrawDataSuper=(DisplayCount=20,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=240,UL=80,VL=7),ULPerAmmo=4)

	bInstantHit=true

	TracerType=WTT_Hammerburst
	TracerTypeAR=WTT_HammerburstAR

	bCrosshairExpanding=TRUE
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_Locust_Hammerburst'
	CrosshairDot=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Dot'
	CrosshairDotZoomed=Texture2D'Warfare_HUD.HUD.HUD_Xhair_Hammerburst_Dot'

	NeedReloadNotifyThreshold=3

	// Weapon anim set
	CustomAnimSets(0)=AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_Hammerburst'

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_Hammerburst_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Hammerburst_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Hammerburst_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_Hammerburst_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Hammerburst_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Hammerburst_Cov_Std_Reload_Fail"))
		)}

	// Weapon Animation
	WeaponReloadAnim="HB_Reload"
	WeaponReloadAnimFail="HB_Reload_Fail"

	MeleeImpactSound=SoundCue'Weapon_AssaultRifle.Reloads.CogRifleHitCue'
	ZoomActivatedSound=SoundCue'Interface_Audio.Interface.WeaponZoomIn_Cue'
	ZoomDeActivatedSound=SoundCue'Interface_Audio.Interface.WeaponZoomOut_Cue'

	LC_EmisDefaultCOG=(R=0.5,G=8.0,B=50.0,A=1.0)
	LC_EmisDefaultLocust=(R=40.0,G=1.4,B=0.0,A=1.0)


	Recoil_Hand={(
				LocAmplitude=(X=-8,Y=0,Z=0),
				LocFrequency=(X=10,Y=0,Z=0),
				LocParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				RotAmplitude=(X=4000,Y=250,Z=0),
				RotFrequency=(X=5,Y=20,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.2f
				)}

	Recoil_Spine={(
				RotAmplitude=(X=2500,Y=500,Z=0),
				RotFrequency=(X=5,Y=5,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.25f
				)}

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.5f
		RotOscillation={(Pitch=(Amplitude=25.f,Frequency=80.f),
						Yaw=(Amplitude=25.f,Frequency=80.f),
						Roll=(Amplitude=12.f,Frequency=200.f))}
		bOverrideTargetingDampening=TRUE
		TargetingDampening=0.6
	End Object
	FireCameraShake=FireCameraShake0
	FireCameraShakeScale=1.3

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=50,RightAmplitude=90,LeftFunction=WF_LinearDecreasing,RightFunction=WF_Sin90to180,Duration=0.18)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	WeaponID=WC_Hammerburst

	bAllowTracers=TRUE
	bAlwaysSpawnTracerSmoke=true

	bSupportsBarrelHeat=TRUE
	BarrelHeatInterpSpeed=6.f
	BarrelHeatPerShot=0.3f
	BarrelHeatCooldownTime=1.25f
	MaxBarrelHeat=2.f
	BarrelHeatMaterialParameterName="Hammerburst_Heat"

	bCanDoIronSights=false		// enable with "ironsights" console command
	IronSightsCameraOffset=(x=50,z=-23)
	IronSightsCameraRotOffset=(Pitch=182)

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlash_Arch.Weapon.LocustAssaultRifle.LocustAssaultRifle_MuzFlash'
	ZoomedMuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlash_Arch.Weapon.LocustAssaultRifle.LocustAssaultRifle_MuzFlash_Zoomed'


	// CQC Long Executions
	LongExecutions(3)={(CQC_Long_KillerAnim="CTRL_Hammerburst",
	CQC_Long_KillerAnim_Loop="",
	CQC_Long_KillerAnim_End="",
	CQC_Long_VictimAnim="DBNO_Hammerburst",
	CQC_Long_VictimAnim_Loop="",
	CQC_Long_VictimAnim_End="",
	CQC_Long_bHolsterWeapon=FALSE,
	CQC_Long_VictimDeathTime=3.0f,
	CQC_Long_VictimRotStartTime=0.0f,
	CQC_Long_VictimRotInterpSpeed=8.f,
	CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Hammerburst_Cam01', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Hammerburst_Cam02', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Hammerburst_Cam03'),
	CQC_Long_DamageType=class'GDT_LongExecution_Lancer',
	CQC_Long_EffortID=GearEffort_None,
	MarkerRelOffset=(X=84.570,Y=27.190,Z=0),
	CameraLensEffect=class'Emit_CameraBlood_LongExecution_HammerBurst',
	AwardRequired="HammerburstExecution")}

	bIsScopeWeapon=TRUE
	ScopeClass=class'GearScope_Hammerburst'

	FPSOffset_NoCover=(X=53,Y=20,Z=60)
	FPSOffset_LeanLeft_MidLevel=(X=51,Y=-71,Z=11)
	FPSOffset_LeanLeft_Standing=(X=45,Y=-83,Z=58)
	FPSOffset_LeanRight_MidLevel=(X=51,Y=71,Z=11)
	FPSOffset_LeanRight_Standing=(X=45,Y=83,Z=58)
	FPSOffset_360Aim_MidLevel=(X=-30,Y=-24,Z=16)
	FPSOffset_360Aim_Standing=(X=-20,Y=23,Z=67)
	FPSOffset_Popup_Mirrored=(X=71,Y=-21,Z=61)
	FPSOffset_Popup_NotMirrored=(X=71,Y=16,Z=62)

	// These are the player's bling skin options
	WeaponSkins(0)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_Gold'
	WeaponSkins(1)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_CHROME'
	WeaponSkins(2)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_OMEN'
	WeaponSkins(3)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_TRIBALMASKED'
	WeaponSkins(4)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_CAMO'
	WeaponSkins(5)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_DIGITAL'
	WeaponSkins(6)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_PINK'
	WeaponSkins(7)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_GARISH'
	WeaponSkins(8)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_BLOOD'
	WeaponSkins(9)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_CRACKLE'
	WeaponSkins(10)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_FLOWER'
	WeaponSkins(11)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_PAISLEY'
	WeaponSkins(12)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_TRIBAL'
	WeaponSkins(13)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_URBAN'
	WeaponSkins(14)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Hammerburst.COG_WeaponShader_Hammerburst_XBOX'
}
