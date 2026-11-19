/**
 * Sniper Rifle
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_SniperRifle extends GearWeapon;

/** sound of shells colliding against ground*/
var() protected const SoundCue			ShellCollisionSound;

/** FOV (in deg) of the zoomed state of this weapon */
var() protected const config float		ZoomFOV;

/** separate fire camera shake for zoomed mode, since the regular camera shake feels enormous when zoomed */
var() protected const GearCameraShake	FireCameraShake_Zoomed;

/** Dot crosshair */
var Texture2D CrosshairDot;

/** The last time we reloaded */
var transient float LastReloadTime;

/** Lens flare to play when zoomed in */
var LensFlareComponent ZoomInFlare;

/** How long to play the zoom in lens flare */
var config float ZoomInFlareDuration;

/** Attach the zoom in lens flare */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SkeletalMeshComponent(Mesh).AttachComponentToSocket(ZoomInFlare, 'Scope_Flare');
}

simulated function float GetWeaponRating()
{
	local float Rating;
	local GearAI AI;

	Rating = Super.GetWeaponRating();

	// AI prefers sniper at long range
	AI = GearAI(GetWeaponController());
	if (AI != None && AI.Enemy != None)
	{
		if (!AI.IsShortRange(AI.Enemy.Location))
		{
			Rating += 0.5;
		}
		// but not against weak enemies
		if (AI.Enemy.HealthMax <= 300)
		{
			Rating -= 0.75;
		}
	}

	return Rating;
}

simulated state MeleeAttacking
{
	simulated function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		SetZoomed(FALSE,TRUE);
	}
}

simulated function bool ShouldAutoReload()
{
	if (Instigator != None && Instigator.IsHumanControlled() && PendingFire(0))
	{
		// don't autoreload while still holding the fire button
		return FALSE;
	}

	return Super.ShouldAutoReload();
}

simulated function PlayWeaponReloading()
{
	Super.PlayWeaponReloading();
	// force the player to remain in the aiming pose after a reload
	if (GearPawn(Instigator) != None)
	{
		GearPawn(Instigator).SetWeaponAlert(8.f);
	}
}

simulated function PlayShellCaseEject()
{
	//SetTimer( 1.70, FALSE, nameof(PlayShellCaseEject_Sniper) );
}


simulated function PlayBoltEject()
{
	Super.PlayShellCaseEject();

	if( !bSuppressAudio )
	{
		Playsound( SoundCue'Weapon_Sniper.Reloads.CogSniperAmmoEjectCue', true );
	}
	SetTimer( 0.750, FALSE, nameof(PlayShellCaseLandImpact) );
}


simulated function PlayShellCaseLandImpact()
{
	if ( (WorldInfo.NetMode != NM_DedicatedServer) && !bSuppressAudio )
	{
		Instigator.PlaySound( ShellCollisionSound, true );
	}
}

/**
 * Overridden to modify locations
 */
simulated function PlayOwnedFireEffects(byte FireModeNum, vector HitLocation)
{
	local vector SpawnLoc;
	local rotator SpawnRot;

	// if we should spawn a tracer effect for the local player, let's do so
	if( WorldInfo.NetMode != NM_DedicatedServer &&
		ShouldSpawnTracerFX() &&
		!IsZero(HitLocation)
		)
	{
		SpawnLoc = GetMuzzleLoc() + vect(0,0,10); // move it up a little particle and socket interaction is a bit off
		if ( UseFirstPersonCamera() )
		{
			SpawnLoc -= vect(0,0,10);
		}

		// if we are on the client when we will not have correct HitLocation so we will calculate an
		// approximate one for our tracer to use.
		if (Role < ROLE_Authority && !bClientSideInstantHit)
		{
			HitLocation = SpawnLoc + vector(GetAdjustedAim(SpawnLoc)) * GetTraceRange();
		}

		SpawnRot = Rotator(HitLocation - SpawnLoc);

		SpawnTracerEffect( Instigator, SpawnLoc, SpawnRot, HitLocation, VSize(HitLocation -SpawnLoc) );
	}

	if (Instigator != None && Instigator.Controller != None)
	{
		// Add weapon recoil effect to player's viewrotation
		SetWeaponRecoil(GetWeaponRecoil());
		PlayFireCameraEffects();
	}
}

simulated function float GetPlayerAimError()
{
	local GearPawn GP;
	GP = GearPawn(Instigator);
	if (GP != None && WorldInfo.GRI.IsMultiplayerGame() && (!GP.bIsTargeting || `TimeSince(TimeSinceTargeting) < 0.4f))
	{
		return WeaponAimError.Y;
	}
	else
	{
		return Super.GetPlayerAimError();
	}
}

simulated event WeaponStoppedFiring(byte FiringMode)
{
	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ "FiringMode:" @ FiringMode );
	if (Instigator != None)
	{
		Instigator.WeaponStoppedFiring(Self, FALSE);
	}

	StopFireEffects(FiringMode);

	/*
	// if we're not currently reloading our weapon, play idle animation
	if( FiringMode != RELOAD_FIREMODE )
	{
	GearPawn(Instigator).PlayWeaponStanceIdle();
	}
	*/

	// turn off shell eject particle system
	if( PSC_ShellEject != None )
	{
		PSC_ShellEject.DeActivateSystem();
		SetTimer( 3.0f, FALSE, nameof(HidePSC_ShellEject) );
	}
}


simulated function PlayMuzzleFlashEffect()
{
	// do not play the muzzle flash effect if you are zoomed and the local player
	if (Instigator == None || !Instigator.IsLocallyControlled() || !GearPawn(Instigator).bIsZoomed)
	{
		Super.PlayMuzzleFlashEffect();
	}
}


/**
 * Returns FOV, in deg, of this weapon when it is in targeting mode.
 */
simulated function float GetTargetingFOV(float BaseFOV)
{
	if (GearPawn(Instigator).bIsZoomed)
	{
		return ZoomFOV;
	}
	else
	{
		return Super.GetTargetingFOV(BaseFOV);
	}
}

simulated protected function GearCameraShake GetFireViewShake()
{
	return (GearPawn(Instigator).bIsZoomed && FireCameraShake_Zoomed != None) ? FireCameraShake_Zoomed : FireCameraShake;
}

/**
 * Notification from pawn that it has been unpossessed.
 */
function NotifyUnpossessed()
{
	SetZoomed(FALSE,TRUE);
}

/**
 * Hide/show the scope based on zoom level
 *
 * @param bNewZoomed - the new zoom value
 *
 * @param bToggleOwnerNoSee - whether the owner see the weapon
 */
simulated function SetZoomed(bool bNewZoomed, optional bool bToggleOwnerNoSee)
{
	if (GearPawn(Instigator) == None)
	{
		return;
	}

	Super.SetZoomed(bNewZoomed, bToggleOwnerNoSee);
	
	// Local pawns don't get the bIsZoomed replicated variable
	if (bNewZoomed)
	{
		EnableZoomInFlare();
	}
	else
	{
		DisableZoomInFlare();
	}	
}

/**
 * Enable or disable the zoom in lens flare
 * 
 * @param bIsZoomed - whether it was zoomed in or out
 */
simulated function RemoteZoomLevelChanged(bool bIsZoomed)
{
	if (bIsZoomed)
	{
		EnableZoomInFlare();
	}
	else
	{
		DisableZoomInFlare();
	}	
}

/** Turn on the zoom in lens flare */
simulated function EnableZoomInFlare()
{
	ZoomInFlare.SetIsActive(TRUE);
	SetTimer(ZoomInFlareDuration, FALSE, nameof(DisableZoomInFlare));
}

/** Turn off the lens flare associated with a zoomed scope */
simulated function DisableZoomInFlare()
{
	ClearTimer(nameof(DisableZoomInFlare));
	ZoomInFlare.SetIsActive(FALSE);
}

simulated state Active
{
	simulated function Tick(float DeltaTime)
	{
		if( ShouldAutoReload() )
		{
			ForceReload();
		}

		Super.Tick(DeltaTime);
	}

	simulated function ForceReload()
	{
		// don't make it actually force for the sniper so we can stay zoomed as long as we want
		if (ShouldAutoReload())
		{
			Super.ForceReload();
		}
	}
}

/*
simulated function LinearColor GetWeaponEmisColor_COG()
{
	return WorldInfo.Gears_COGWeapons.SniperRifle;
}

simulated function LinearColor GetWeaponEmisColor_Locust()
{
	return WorldInfo.Gears_LocustWeapons.SniperRifle;
}
*/

simulated function bool ShouldUseMuzzleFlashSocketForShellEjectAttach()
{
	return TRUE;
}

/**
 * Dot when zoomed, big reticle when not
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
	return GearPawn(Instigator).bIsZoomed ? CrosshairDot : CrosshairIcon;
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

/** Record the last time we reloaded */
simulated function PerformReload()
{
	Super.PerformReload();

	LastReloadTime = WorldInfo.TimeSeconds;
}

/**
 * Avoid the case where the client reloads before the server and fires too early
 * 300 msec should be enough and not be noticeable by players
 * Lagswitching could still probably generate the issue
 *
 * @param FireModeNum - the current fire mode
 */
simulated function StartFire(byte FireModeNum)
{
	if (FireModeNum == 0 && `TimeSince(LastReloadTime) < 0.3)
	{
		return;
	}

	Super.StartFire(FireModeNum);
}

defaultproperties
{
	WeaponStatName="Longshot"

	bWeaponCanBeReloaded=TRUE
	bAutoSwitchWhenOutOfAmmo=FALSE
	bSuperSteadyCamWhileTargeting=TRUE

	FireSound=SoundCue'Weapon_Sniper.Sniper.CogSniperRifleFireEnemyCue'
	FireSound_Player=SoundCue'Weapon_Sniper.Sniper.CogSniperRifleFirePlayerCue'
	FireSound_Squad=SoundCue'Weapon_Sniper.Sniper.CogSniperRifleFireSquadCue'
	FireNoAmmoSound=SoundCue'Weapon_Sniper.Firing.CogSniperFireEmptyCue'
	AlmostOutOfAmmoSound=SoundCue'Weapon_Sniper.Sniper.CogSniperRifleFirePlayerEmptyCue'

	WeaponReloadSound=SoundCue'Weapon_Sniper.Reloads.CogSniperAmmoInsertCue'
	ShellCollisionSound=SoundCue'Weapon_Sniper.Reloads.CogSniperAmmoBounceBigCue'

	WeaponEquipSound=SoundCue'Weapon_Sniper.Actions.CogSniperRaiseCue'
	WeaponDeEquipSound=SoundCue'Weapon_Sniper.Actions.CogSniperLowerCue'

	PickupSound=SoundCue'Weapon_Sniper.Actions.CogSniperPickupCue'

	BulletWhipArchetype=GearBulletWhip'GearSoundGroupArchetypes.BulletWhips.SniperRifle'

	AIRating=1.f

	InstantHitDamageTypes(0)=class'GDT_SniperRifle'
	AmmoTypeClass=class'GearAmmoType_SniperRifle'

	// Weapon Animation
	Begin Object Class=AnimNodeSequence Name=WeaponAnimNode
	End Object

	// Weapon Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'COG_SniperRifle.LongShot'
		PhysicsAsset=PhysicsAsset'COG_SniperRifle.LongShot_Physics'
		AnimSets(0)=AnimSet'COG_SniperRifle.LongShot'
		Animations=WeaponAnimNode
    End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	FireOffset=(X=105,Y=-2,Z=11)

	// shell case ejection emitter
	Begin Object Name=PSC_WeaponShellCaseComp
		Template=ParticleSystem'COG_SniperRifle.P_COG_Sniper_shell'
		Translation=(X=-100,Y=0,Z=0)
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp

	// make the sniper rifle's damage duration longer due to how it is used
//	ActiveReload_BonusDurationTier=(0.0f,4.0f,4.0f,4.0f);

	DamageTypeClassForUI=class'GDT_SniperRifle'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=337,V=4,UL=173,VL=46)
	AnnexWeaponIcon=(U=0,V=119,UL=128,VL=25)

	bCrosshairExpanding=FALSE
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Longshot'
	CrosshairDot=Texture2D'Warfare_HUD.HUD_Xhair_COG_Sniper'

	bIsSuppressive=FALSE
	bSniping=true
	bInstantHit=true
	bCanNegateMeatShield=true
	bIgnoresExecutionRules=true

	bAllowTracers=true
	bAlwaysSpawnTracerSmoke=true
	TracerType=WTT_Longshot
	TracerTypeAR=WTT_Longshot

	// easy on the autoaim, sniper is a precision weapon, esp when zoomed
	AimAssistScale=0.5f
	AimAssistScaleWhileTargeting=0.f

	HUDDrawData			= (DisplayCount=1, AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=296,UL=106,VL=7),ULPerAmmo=43)
	HUDDrawDataSuper	= (DisplayCount=1, AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=296,UL=106,VL=7),ULPerAmmo=43)

	ZoomActivatedSound=SoundCue'Weapon_Sniper.Reloads.CogSniperEyeActivateCue'
	ZoomDeActivatedSound=SoundCue'Weapon_Sniper.Reloads.CogSniperEyeDeActivateCue'

	// Weapon anim set
	CustomAnimSets(0)=AnimSet'COG_MarcusFenix.AnimSetMarcus_CamSkel_LongShot'
	WeaponAnimType=EWAT_SniperRifle

	WeaponFireAnim=""
	WeaponReloadAnim="LS_Reload"
	WeaponReloadAnimFail="LS_Reload_Fail"

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_LS_Idle_Ready_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_LS_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_LS_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_LS_Idle_Ready_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_LS_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_LS_Cov_Std_Reload_Fail"))
		)}

	MeleeImpactSound=SoundCue'Weapon_Sniper.Actions.CogSniperDropCue'

	LC_EmisDefaultCOG=(R=1.0,G=3.0,B=10.0,A=1.0)
	LC_EmisDefaultLocust=(R=16.0,G=0.8,B=0.2,A=1.0)

	Recoil_Hand={(
				LocAmplitude=(X=-6,Y=0,Z=0),
				LocFrequency=(X=15,Y=0,Z=0),
				LocParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				RotAmplitude=(X=3000,Y=0,Z=0),
				RotFrequency=(X=5,Y=0,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.33f
				)}

	Recoil_Spine={(
				RotAmplitude=(X=750,Y=0,Z=0),
				RotFrequency=(X=12,Y=0,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.67f
				)}


	// camera shakes
	Begin Object Class=GearCameraShake Name=FireCameraShake_Zoomed0
		OscillationDuration=0.33f
		RotOscillation={(Pitch=(Amplitude=250.f,Frequency=15.f,InitialOffset=EOO_OffsetZero),
						Yaw=(Amplitude=100.f,Frequency=15.f),
						Roll=(Amplitude=25.f,Frequency=5.f))}
		LocOscillation={(X=(Amplitude=-5.f,Frequency=25.f,InitialOffset=EOO_OffsetZero))}
	End Object
	FireCameraShake_Zoomed=FireCameraShake_Zoomed0

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.33f
		RotOscillation={(Pitch=(Amplitude=1000.f,Frequency=15.f,InitialOffset=EOO_OffsetZero),
						Roll=(Amplitude=500.f,Frequency=8.f))}
		LocOscillation={(X=(Amplitude=-20.f,Frequency=25.f,InitialOffset=EOO_OffsetZero),
						Z=(Amplitude=10.f,Frequency=10.f))}
		bOverrideTargetingDampening=TRUE
		TargetingDampening=0.6
	End Object
	FireCameraShake=FireCameraShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.500)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

    WeaponID=WC_Longshot

	// CQC Long Executions
	LongExecutions(3)={( CQC_Long_KillerAnim="CTRL_LongShot",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="DBNO_LongShot",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_LongShot_Cam01',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_LongShot_Cam02',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_LongShot_Cam03'),
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=1.97f,
						CQC_Long_VictimRotStartTime=0.f,
						CQC_Long_VictimRotInterpSpeed=0.f,
						MarkerRelOffset=(X=84.570,Y=27.190,Z=0),
						CQC_Long_EffortID=GearEffort_SniperLongExecutionEffort,
						CQC_Long_DamageType=class'GDT_LongExecution_Sniper',
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_LongShot',
						AwardRequired="LongshotExecution")}


	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_SniperRifle_MuzFlash'

	Begin Object Class=LensFlareComponent Name=ZoomInFlare0
		Template=LensFlare'COG_SniperRifle.Effects.Sniper_Lensflare'
		bAutoActivate=FALSE
		bOwnerNoSee=TRUE
	End Object
	ZoomInFlare=ZoomInFlare0

	bIsScopeWeapon=TRUE
	ScopeClass=class'GearScope_Sniper'

	FPSOffset_NoCover=(X=53,Y=20,Z=60)
	FPSOffset_LeanLeft_MidLevel=(X=51,Y=-71,Z=11)
	FPSOffset_LeanLeft_Standing=(X=45,Y=-83,Z=58)
	FPSOffset_LeanRight_MidLevel=(X=51,Y=71,Z=11)
	FPSOffset_LeanRight_Standing=(X=45,Y=83,Z=58)
	FPSOffset_360Aim_MidLevel=(X=-30,Y=-24,Z=16)
	FPSOffset_360Aim_Standing=(X=-20,Y=23,Z=67)
	FPSOffset_Popup_Mirrored=(X=71,Y=-21,Z=61)
	FPSOffset_Popup_NotMirrored=(X=71,Y=16,Z=62)
}
