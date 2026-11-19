/**
 * Flamethrower!
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_FlameThrowerBase extends GearWeapon
	abstract
	native(Weapon);


/** Emitter to play when firing stops. */
var() const ParticleSystemComponent PSC_EndSpray;

/** Internal.  TRUE if fire is spewing, false otherwise. */
var private transient bool			bFireSpraying;


/** The spray actor we are associated with, if currently firing. */
var transient protected FlameThrowerSprayBase	ActiveFlameSpray;

/** How long it takes for the muzzle to fully heat up. */
var() protected const float					MuzzleHeatFadeInTime;
/** How long it takes for the muzzle to fully cool down. */
var() protected const float					MuzzleHeatFadeOutTime;
/** Controls the curve of the heat up/down ramping. */
var() protected const float					MuzzleHeatPow;


/** Looping sound to play for pilot light. */
var() protected const SoundCue			PilotLightLoopSound;
/** AudioComponent for looping sound played while the pilot light is lit. */
var transient protected	AudioComponent	AC_PilotLoop;
/** Sound to play when pilot light ignites. */
var() protected const SoundCue			PilotLightIgniteSound;
/** Sound to play when pilot light turns off. */
var() protected const SoundCue			PilotLightExtinguishSound;


/** Effect for the pilot light. */
var protected ParticleSystemComponent	PSC_PilotLight;
/** Effect for the unignited fuel between the muzzle and the pilot. */
var protected ParticleSystemComponent	PSC_UnignitedFuel;

/** How to adjust the turn/lookup controls when the weapon is firing. */
var() protected const config float		FiringLookRightScale;
var() protected const config float		FiringLookUpScale;

/** rate of fire when we start firing */
var config float InitialRateOfFire;
/** time to get to normal rate of fire */
var config float SpinUpTime;
/** how much more time we've spent firing than not firing (controls rate of fire) */
var float SpinUpProgress;

var protected const class<FlameThrowerSprayBase>	FlameSprayClass;

var SkeletalMeshComponent WeaponMesh;

var name PilotLightSocketName;

var() protected float MinFireDuration;

var() protected Rotator AimOffsetAdjusment;

var() protected const float BurstDelay;

var protected transient int						NextFlamePoolIdx;
var protected transient FlameThrowerSprayBase	FlamePool[2];

/** Whether TurnOnPilot has already been called */
var protected bool bPilotLightOn;

/** Flamethrowers don't have a muzzle flash archetype object so need to manually set this */
var protected name MuzzleSocketName;

simulated protected function TurnOnPilot()
{
	local vector MuzzleLoc;
	local rotator Aim;

	if (bPilotLightOn)
		return;

	if (PilotLightIgniteSound != None)
	{
		WeaponPlaySound(PilotLightIgniteSound);
	}

	// start looping sound
	if (PilotLightLoopSound != None)
	{
		AC_PilotLoop = GearWeaponPlaySoundLocalEx(PilotLightLoopSound,,, AC_PilotLoop, 0.5f);
	}

	if( PSC_PilotLight != None )
	{
		PSC_PilotLight.ActivateSystem();
	}

	GetMuzzleLocAndRot(MuzzleLoc, Aim);
	if( FlamePool[0] == None )
	{
		FlamePool[0] = Spawn(FlameSprayClass, Instigator,, MuzzleLoc, Aim,, TRUE);
	}
	if( FlamePool[1] == None )
	{
		FlamePool[1] = Spawn(FlameSprayClass, Instigator,, MuzzleLoc, Aim,, TRUE);
	}

	// attach flamesprays here too, so they are hooked up before firing
	FlamePool[0].AttachToWeapon(self, MuzzleSocketName);
	FlamePool[1].AttachToWeapon(self, MuzzleSocketName);

	bPilotLightOn = TRUE;
}

simulated function GetMuzzleLocAndRot(out Vector out_Loc, out Rotator out_Rot)
{
	if( WeaponMesh != none && MuzzleSocketName != '' )
	{
		WeaponMesh.GetSocketWorldLocationAndRotation(MuzzleSocketName, out_Loc, out_Rot);
	}
	else
	{
		out_Loc = Instigator.Location;
		out_Rot = Instigator.Rotation;
	}
}

simulated protected function TurnOffPilot()
{
	if (AC_PilotLoop != None)
	{
		AC_PilotLoop.FadeOut(0.2f, 0.f);
		AC_PilotLoop = None;

		if (PilotLightExtinguishSound != None)
		{
			WeaponPlaySound(PilotLightExtinguishSound);
		}
	}

	if( PSC_PilotLight != None )
	{
		PSC_PilotLight.DeActivateSystem();
	}

	bPilotLightOn = FALSE;
}


simulated protected function FlameThrowerSprayBase GetFlameSprayFromPool()
{
	local FlameThrowerSprayBase Ret;
	Ret = FlamePool[NextFlamePoolIdx];

	NextFlamePoolIdx++;
	if (NextFlamePoolIdx >= ArrayCount(FlamePool))
	{
		NextFlamePoolIdx = 0;
	}

	return Ret;
}

simulated protected function TurnOnFireSpray()
{
	local GearGRI GRI;

	if (!bFireSpraying)
	{
		// spawn flame actor
		ActiveFlameSpray = GetFlameSprayFromPool();
		if (ActiveFlameSpray != None)
		{
			ActiveFlameSpray.BeginSpray();
		}
		else
		{
			`Warn(GetFuncName() @ "ActiveFlameSpray is NONE!!!");
		}

		if( PSC_UnignitedFuel != None )
		{
			PSC_UnignitedFuel.ActivateSystem();
		}

		GRI = GearGRI(WorldInfo.GRI);
		if( Instigator != None && GRI != None && Instigator.EffectIsRelevant(Instigator.Location, false, 2000) )
		{
			GRI.LeaveADecal(ScorchDecalTraceFuncMain, ScorchDecalChoiceFuncMain);
		}

		bFireSpraying = TRUE;
	}
}

simulated function ScorchDecalTraceFuncMain( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	local vector				Loc;
	local rotator				Rot;

	GetMuzzleLocAndRot(Loc, Rot);

	//`log( "BloodDecalTrace_TraceFromEndOfChainsaw" );
	out_TraceStart = Loc;
	out_TraceDest =  out_TraceStart + (Vector(Rot) * 512.0f);
//	`log("tracefunc called!"@out_TraceStart@out_TraceDest);
}


simulated function ScorchDecalChoiceFuncMain( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_FlameThrower_StartFlameBlast, WorldInfo );
	//`log("choicefunc called!"@out_DecalRotation@Hitinfo.PhysMaterial@out_DecalData.DecalMaterial);

	if( out_DecalData.bRandomizeRotation == TRUE )
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}



simulated protected function TurnOffFireSpray()
{
	// play end-of-firing poof.  will stop itself.
	if( PSC_EndSpray != None )
	{
		PSC_EndSpray.ActivateSystem();
	}

	if (ActiveFlameSpray != None)
	{
		ActiveFlameSpray.DetachAndFinish();
	}

	if( PSC_UnignitedFuel != None )
	{
		PSC_UnignitedFuel.DeactivateSystem();
	}

	bFireSpraying = FALSE;
}

simulated function FlashLocationUpdated(byte FiringMode, vector FlashLocation, bool bViaReplication)
{
	if ((bSlaveWeapon || WorldInfo.IsPlayingDemo() || !bNetOwner) && bViaReplication)
	{
		if (IsZero(FlashLocation))
		{
			TurnOffFireSpray();
		}
		else if ( FiringMode == 0 )
		{
			if ( !bFireSpraying )
			{
				TurnOnFireSpray();
			}
		}
	}

	super.FlashLocationUpdated(FiringMode, FlashLocation, bViaReplication);
}

simulated function float GetWeaponRating()
{
	// AI doesn't pull it out till enemy is in range
	if ( !Instigator.IsHumanControlled() && Instigator.Controller.Enemy != None &&
		(VSize(Instigator.Location - Instigator.Controller.Enemy.Location) > 1024.0 || Abs(Instigator.Location.Z - Instigator.Controller.Enemy.Location.Z) > 256.0) )
	{
		return 0.1;
	}
	else
	{
		return Super.GetWeaponRating();
	}
}

simulated function float GetRateOfFire()
{
	return Lerp(InitialRateOfFire, Super.GetRateOfFire(), FClamp(SpinUpProgress / SpinUpTime, 0.0, 1.0));
}

simulated function DoDelayedEndFire()
{
	EndFire(0);
}

simulated state SprayingFire extends WeaponFiring
{
	simulated function BeginState( Name PreviousStateName )
	{
		TurnOnFireSpray();
		super.BeginState(PreviousStateName);
	}

	/** Leaving state, shut everything down. */
	simulated function EndState(Name NextStateName)
	{
		if (bFireSpraying)
		{
			TurnOffFireSpray();
		}
		ClearFlashLocation();
		ClearTimer('RefireCheckTimer');
		ClearPendingFire(0);

		super.EndState(NextStateName);
	}

	/** Done firing! */
	simulated function EndFire(byte FireModeNum)
	{
		if( ActiveFlameSpray != None && ActiveFlameSpray.CurrentAge < MinFireDuration )
		{
			SetTimer(MinFireDuration - ActiveFlameSpray.CurrentAge, FALSE, nameof(DoDelayedEndFire));
		}
		else
		{
			super.EndFire(FireModeNum);

			if ( bWeaponPutDown )
			{
				// if switched to another weapon, put down right away
				GotoState('WeaponPuttingDown');
				return;
			}
			else
			{
				// force wait before refiring
				GotoState('BurstDelaying');
			}
		}
	}

	simulated function bool IsFiring()
	{
		return TRUE;
	}

	simulated function bool ShouldRefire()
	{
		if( bDummyFireWeapon )
		{
			return TRUE;
		}
		return Super.ShouldRefire();
	}

	simulated function bool TryPutDown()
	{
		bWeaponPutDown = TRUE;
		return FALSE;
	}

	simulated function RefireCheckTimer()
	{
		local float SavedMinFireDuration;
		local GearPawn GP;

		//@hack: workaround for issue where you can fire while DBNO/RR in some cases
		GP = GearPawn(Instigator);
		if (GP != None && (GP.SpecialMove != SM_None && !GP.SpecialMoves[GP.SpecialMove].bCanFireWeapon))
		{
			SavedMinFireDuration = MinFireDuration;
			MinFireDuration = 0.0;
			ForceEndFire();
			MinFireDuration = SavedMinFireDuration;
		}

		// reset the timer in case we are in the 'spin-up' phase
		SetTimer( GetFireInterval(CurrentFireMode), true, nameof(RefireCheckTimer) );

		Super.RefireCheckTimer();
	}
};

function int GetBurstFireCount()
{
	return -1;
}
function int GetBurstsToFire()
{
	return -1;
}

/** overloaded as a hack to properly adjust weapon rot.  real mesh shouldn't need this function at all. */
simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	local GearPawn InstigatorGP;
	local Rotator TmpRot;
	local name BoneName;

	SetWeaponMesh();
	// attach the particle systems to the muzzle
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		AttachComponentsToWeaponMesh();
	}

	super.AttachWeaponTo(MeshCpnt, SocketName);

	BoneName = MeshCpnt.GetSocketBoneName(SocketName);
	if( Mesh != None && !MeshCpnt.IsComponentAttached(Mesh,BoneName) )
	{
		// hack for weapon alignment to make temp weapon mesh work in cover
		InstigatorGP = GearPawn(Instigator);
		if( ShouldWeaponBeMirrored(InstigatorGP) )
		{
			TmpRot = Mesh.default.Rotation;
			TmpRot.Yaw = -TmpRot.Yaw;
			Mesh.SetRotation(TmpRot);

			// the PSCs don't like that the mesh is scaled, so apply inverse scaling to get back to normal
			if( PSC_EndSpray != None )
			{
				PSC_EndSpray.SetScale3D(vect(1,-1,1));
			}
			if( PSC_UnignitedFuel != None )
			{
				PSC_UnignitedFuel.SetScale3D(vect(1,-1,1));
			}
			if( PSC_PilotLight != None )
			{
				PSC_PilotLight.SetScale3D(vect(1,-1,1));
			}
		}
		else
		{
			Mesh.SetRotation(Mesh.default.Rotation);

			// back to normal scaling
			if( PSC_EndSpray != None )
			{
				PSC_EndSpray.SetScale3D(vect(1,1,1));
			}
			if( PSC_UnignitedFuel != None )
			{
				PSC_UnignitedFuel.SetScale3D(vect(1,1,1));
			}
			if( PSC_PilotLight != None )
			{
				PSC_PilotLight.SetScale3D(vect(1,1,1));
			}
		}
	}
}

simulated function AttachComponentsToWeaponMesh()
{
	if( WeaponMesh != none && MuzzleSocketName != '' )
	{
		if( PSC_EndSpray != None )
		{
			WeaponMesh.AttachComponentToSocket( PSC_EndSpray, MuzzleSocketName );
		}
		if( PSC_PilotLight != None )
		{
			WeaponMesh.AttachComponentToSocket( PSC_PilotLight, PilotLightSocketName );
		}
		if( PSC_UnignitedFuel != None )
		{
			WeaponMesh.AttachComponentToSocket( PSC_UnignitedFuel, MuzzleSocketName );
		}
	}
	else
	{
		if( PSC_EndSpray != None )
		{
			Instigator.AttachComponent(PSC_EndSpray);
		}
		if( PSC_PilotLight != None )
		{
			Instigator.AttachComponent(PSC_PilotLight);
		}
		if( PSC_UnignitedFuel != None )
		{
			Instigator.AttachComponent(PSC_UnignitedFuel);
		}
	}
}

simulated function SetWeaponMesh()
{
	WeaponMesh = SkeletalMeshComponent(Mesh);
}

/**
* Update the beam and handle the effects
*/
simulated function Tick(float DeltaTime)
{
	if (bFireSpraying)
	{
		// hitlocation doesn't actually matter here, just so it's not zero.  this will
		// notify clients that we're still firing
		SetFlashLocation(vect(1,1,1));

		// muzzle getting hotter
		CurrentBarrelHeat = FMin(CurrentBarrelHeat + DeltaTime / MuzzleHeatFadeInTime, 1.f);
		SpinUpProgress = FMin(SpinUpProgress + DeltaTime, SpinUpTime);
	}
	else
	{
		// muzzle getting cooler
		CurrentBarrelHeat = FMax(CurrentBarrelHeat - DeltaTime / MuzzleHeatFadeOutTime, 0.f);
		SpinUpProgress = FMax(SpinUpProgress - DeltaTime, 0.0);
	}

	super.Tick(DeltaTime);
}


simulated function CustomFire()
{
	if( bDummyFireWeapon || Instigator.IsLocallyControlled() )
	{
		// local player simulates firing locally, to give instant response.
		// FlashLocation will only replicate the exact impact location, and play impact effects.
		WeaponFired(CurrentFireMode);
	}

	super.CustomFire();
}

simulated function Destroyed()
{
	local int Idx;

	if (bFireSpraying)
	{
		// make sure to clean up spray effects
		TurnOffFireSpray();
	}

	for (Idx=0; Idx<ArrayCount(FlamePool); ++Idx)
	{
		FlamePool[Idx].Destroy();
		FlamePool[Idx] = None;
	}

	super.Destroyed();
}


simulated state WeaponEquipping
{
	simulated function WeaponEquipped()
	{
		super.WeaponEquipped();
		TurnOnPilot();
	}
}

simulated state WeaponPuttingDown
{
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		TurnOffPilot();
	}
}

simulated function Rotator GetHumanAimRotationAdjustment()
{
	local Rotator Adj;
	local GearPawn GP;

	Adj = AimOffsetAdjusment;

	GP = GearPawn(Instigator);
	if( GP != None && GP.bIsMirrored )
	{
		Adj.Yaw = -Adj.Yaw;
	}

	return Adj;
}

simulated function PreProcessInput(GearPlayerInput TheInput)
{
	if (IsFiring())
	{
		TheInput.aTurn *= FiringLookRightScale;
		TheInput.aLookUp *= FiringLookUpScale;
	}
}

/** Returns the value to scale the cross hair by */
simulated function float GetCrossHairScale()
{
	if( GearPawn(Instigator).bActiveReloadBonusActive )
	{
		return 0.5f;
	}
	else
	{
		return 0.7f;
	}
}

simulated state Inactive
{
	simulated function BeginState( Name PreviousStateName )
	{
		TurnOffPilot();

		if (FlamePool[0] != None)
		{
			FlamePool[0].SetHidden(TRUE);
			FlamePool[0].SetTickIsDisabled(true);
			FlamePool[0].ParticleSystemCleanUp();
		}

		if (FlamePool[1] != None)
		{
			FlamePool[1].SetHidden(TRUE);
			FlamePool[1].SetTickIsDisabled(true);
			FlamePool[1].ParticleSystemCleanUp();
		}

		super.BeginState(PreviousStateName);
	};
}

/** Returns the number of ammo icons this weapon will display in a clip */
simulated function float GetAmmoIconCount()
{
	return WeaponMagSize;
}

/** Returns the pixel width of a single ammo for the HUD */
simulated function float GetPixelWidthOfAmmo()
{
	return HUDDrawData.DisplayCount / WeaponMagSize;
}

function bool IsActiveReloadActive(GearPawn GP)
{
	return GP.bActiveReloadBonusActive;
}

simulated function float GetWeaponDistanceForEnemyTrace()
{
	return class'FlameThrowerSprayBase'.default.FlameDamageScaleDistRange.Y;
}

simulated function bool CanDoSpecialMeleeAttack()
{
	return !bFireSpraying;
}

simulated function EndOfBurstDelay();


simulated state BurstDelaying
{
	simulated function BeginState(Name PreviousStateName)
	{
		if( !HasAmmo(CurrentFireMode) )
		{
			// end prematurely so we can reload
			EndOfBurstDelay();
		}
		else
		{
			SetTimer( BurstDelay, FALSE, nameof(EndOfBurstDelay) );
		}
	}

	simulated function EndState(Name NextStateName)
	{
		ClearTimer('EndOfBurstDelay');
	}

	simulated function EndOfBurstDelay()
	{
		GotoState('Active');
	}

	simulated function StartFire(byte FireModeNum)
	{
		if (FireModeNum != 0)
		{
			// end prematurely so we can reload
			EndOfBurstDelay();
			Super.StartFire(FireModeNum);
		}
	}
}

/** Supporting DummyFire for HOD. */
simulated event DummyFire(byte FireModeNum, vector TargetLoc, optional Actor AttachedTo, optional float AimErrorDeg, optional Actor TargetActor)
{
	local vector StartLoc;
	local rotator AimRot;
	local float AimErrorUnr;

	DummyFireParent = AttachedTo;
	bDummyFireWeapon = TRUE;

	// Reset AmmoUsedCount, since DummyWeaponFire shound not have to worry about reloading
	AmmoUsedCount = 0;

	StartLoc = GetPhysicalFireStartLoc();
	AimRot = rotator(TargetLoc - StartLoc);

	// modify Aim to add player aim error
	// and convert aim error from degrees to Unreal Units ( * 65536 / 360 )
	if (AimErrorDeg != 0.f)
	{
		AimErrorUnr = AimErrorDeg * 182.044;
		AimRot.Pitch += AimErrorUnr * (0.5 - FRand());
		AimRot.Yaw	 += AimErrorUnr * (0.5 - FRand());
	}

	if( PSC_EndSpray != None )
	{
		DummyFireParent.AttachComponent(PSC_EndSpray);
	}
	if( FlamePool[0] == None )
	{
		FlamePool[0] = Spawn(FlameSprayClass, DummyFireParent,, AttachedTo.Location, AimRot,, TRUE);
		FlamePool[0].SetupDummyFire(DummyFireParent);
	}
	else
	{
		FlamePool[0].SetLocation(AttachedTo.Location);
		FlamePool[0].SetRotation(AimRot);
	}
	if( FlamePool[1] == None )
	{
		FlamePool[1] = Spawn(FlameSprayClass, DummyFireParent,, AttachedTo.Location, AimRot,, TRUE);
		FlamePool[1].SetupDummyFire(DummyFireParent);
	}
	else
	{
		FlamePool[1].SetLocation(AttachedTo.Location);
		FlamePool[1].SetRotation(AimRot);
	}

	if( !IsInState('SprayingFire') )
	{
		GotoState('SprayingFire');
	}
}

defaultproperties
{
	WeaponStatName="Scorcher"

	// ----------------------------------
	// GearWeap_FlamethrowerBase parameters
	// ----------------------------------

	BurstDelay=0.5f

	MinBlindFireUpAimPitch=-256
	MinBlindFireSideYaw=-600

	FiringStatesArray(0)=SprayingFire
	WeaponFireTypes(0)=EWFT_Custom

	Begin Object Class=ParticleSystemComponent Name=FlameEndSpray0
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_EndSpray=FlameEndSpray0

	MuzzleHeatPow=2.f
	MuzzleHeatFadeInTime=3.f
	MuzzleHeatFadeOutTime=3.f

	Begin Object Class=ParticleSystemComponent Name=PilotLight0
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_PilotLight=PilotLight0

	Begin Object Class=ParticleSystemComponent Name=UnignitedFuel0
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_UnignitedFuel=UnignitedFuel0


	// --------------------------------
	// GearWeapon parameters
	// --------------------------------

	// no recoil for now
	Recoil_Hand={(
					TimeDuration=0.f,
					RotAmplitude=(X=0,Y=0,Z=0),
					LocAmplitude=(X=0,Y=0,Z=0),
					)}
	Recoil_Spine={(
					TimeDuration=0.f,
					RotAmplitude=(X=0,Y=0,Z=0),
					RotFrequency=(X=0,Y=0,Z=0),
					)}

	bWeaponCanBeReloaded=TRUE
	AmmoTypeClass=class'GearAmmoType_FlameThrower'

	AIRating=1.5f

	WeaponFireAnim=""
	WeaponReloadAnim="Reload"
	WeaponReloadAnimFail="Reload_Fail"

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_Scorcher_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Scorcher_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Scorcher_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_Scorcher_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Scorcher_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Scorcher_Cov_Std_Reload_Fail"))
		)}

	bOverrideDistanceForEnemyTrace=TRUE

	// Weapon Mesh

	Begin Object Class=AnimNodeSequence Name=WeaponAnimNode
		AnimSeqName=""
	End Object

	Begin Object Name=WeaponMesh
		Animations=WeaponAnimNode
    End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	FireOffset=(X=105,Y=-2,Z=11)

	DamageTypeClassForUI=class'GDT_Fire'

	bInstantHit=FALSE
	bHose=TRUE
	NeedReloadNotifyThreshold=2

	WeaponID=WC_Scorcher

	LC_EmisDefaultCOG=(R=1.5,G=1.5,B=1.5,A=1.0)
	LC_EmisDefaultLocust=(R=60.0,G=1.0,B=0.1,A=1.0)

	bSupportsBarrelHeat=TRUE
	BarrelHeatMaterialParameterName="ScorcherHeatIntensity"
	PilotLightSocketName="Flame Tip"

	MinFireDuration=0.3f

	AimOffsetAdjusment=(Pitch=600,Yaw=455,Roll=0)

	MuzzleSocketName="Muzzle"

	bMustBeInRangeToFire=TRUE
}

