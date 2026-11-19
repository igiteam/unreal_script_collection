/**
 * GearVWeap_RocketCannon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearVWeap_SubmarineTurretBase extends GearVehicleWeapon
	abstract
	config(Weapon)
	hidedropdown;


/** Animation to play on weapon */
var() const Name WeaponFireAnimLeft;
var() const Name WeaponFireAnimRight;

/** Muzzle Flash for the second gun */
var GearMuzzleFlash MuzzleFlashRight;

/** True if MuzzleFlashRight should be played instead of MuzzleFlash */
var transient bool bUseRightMuzzle;

/** Whether this weapon is disabled or not (kismet controlled through the submarine */
var repnotify bool bTurretDisabled;

/** Rate of fire when fanning the trigger */
var() config float FanningRateOfFire;
/** Percent of heat to add per shot fired */
var config float HeatPercentPerShot;
/** When gun overheats, how long you must wait until the gun begins to cool down again. */
var() protected const config float OverheatPenaltyTime;
/** True if we are currently overheated */
var protected transient bool bOverheated;
/** How long it takes the barrel to cool down from fully heated, in seconds. */
var() protected const config float CooldownTime;
/** How long it takes the barrel to cool down from fully heated while ActiveCooling(tm) is in effect, in seconds. */
var() protected const config float CooldownTimeActiveCooling;
/** True if player is actively cooling/recharging the weapon */
var protected transient bool bActivelyCooling;


var protected const SoundCue			RotateLoopSound;
var protected transient AudioComponent	RotateLoopAC;
var protected transient bool			bPlayingRotAudio;
var() protected const float				RotAudioStartVelThreshold;
var() protected const float				RotAudioStopVelThreshold;
var protected transient int				LastControllerYaw;
var() protected const vector2d			RotAudioVolumeVelRange;
var() protected const vector2d			RotAudioVolumeRange;

replication
{
	if (bNetDirty)
		bTurretDisabled;
	if (bNetInitial)
		HeatPercentPerShot;
}

/** replicated event */
simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
		case nameof(bTurretDisabled):
			if (bTurretDisabled)
			{
				StopFire(0);
			}
			break;
	}

	Super.ReplicatedEvent(VarName);
}

simulated function PlayShellCaseEject()
{
}

/** Treat sub turret as a heat-limited weapon in the HUD */
simulated function bool IsHeatLimited()
{
	return (HeatPercentPerShot > 0.0);
}

/** Override represent "energy" - full ammo at 0 energy and empty at 1 */
simulated function float GetCurrentBarrelHeat()
{
	return FClamp(1.0 - CurrentBarrelHeat, 0.0, 1.0);
}

/** Internal */
simulated protected function OverheatPenaltyExpired()
{
	bOverheated = FALSE;
}

/** Returns the number of ammo icons this weapon will display in a clip */
simulated function float GetAmmoIconCount()
{
	return 0;
}

/** Tells the server when active cooling has started / stopped */
reliable server function ServerToggleActiveCooling(bool bActive)
{
	if (bActive != bActivelyCooling)
	{
		if (!bActive)
		{
			EndActiveCooling();
		}
		else
		{
			BeginActiveCooling();
		}
	}
}

/** Called when player has started active cooling */
simulated function BeginActiveCooling()
{
	bActivelyCooling = TRUE;
	ServerToggleActiveCooling(TRUE);

	//ActiveCoolingSteamAudioLoop = GearWeaponPlaySoundLocalEx(ActiveCoolingLoopCue,,, ActiveCoolingSteamAudioLoop, 0.3f);
	//WeaponPlaySound(ActiveCoolingStartCue);

	//PSC_ActiveCoolingSteam.ActivateSystem(TRUE);
}

/** Called when active cooling has ended */
simulated function EndActiveCooling()
{
	if (bActivelyCooling)
	{
		bActivelyCooling = FALSE;
		ServerToggleActiveCooling(FALSE);
	}
}

/** Increments CurrentBarrelHeat when a shot is fired */
simulated function Projectile ProjectileFire()
{
	CurrentBarrelHeat += HeatPercentPerShot;
	CurrentBarrelHeat = FMin(CurrentBarrelHeat, 1.f);
	if( (CurrentBarrelHeat >= 1.f) && !bOverheated )
	{
		// overheated!  stop firing and don't allow a restart for some time
		bOverheated = TRUE;
		SetTimer( FMax(OverheatPenaltyTime, 0.01),, nameof(OverheatPenaltyExpired) );
		//WeaponPlaySound(FireStopCue_Overheat);
		StopFire(0);
		//GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_GatlingOverheated, Instigator, None, 0.35f);
	}

	return Super.ProjectileFire();
}

/** Overridden to handle decrementing CurrentBarrelHeat over time */
simulated function Tick(float DeltaTime)
{
	local float AimRotVel, RotAudioPct;
	local bool bPlayRotAudio;

	if (bActivelyCooling)
	{
		CurrentBarrelHeat -= DeltaTime / CooldownTimeActiveCooling;

		if (CurrentBarrelHeat <= 0.f)
		{
			EndActiveCooling();
		}
	}
	else
	{
		CurrentBarrelHeat -= DeltaTime / CooldownTime;
	}
	CurrentBarrelHeat = FMax(CurrentBarrelHeat, 0.f);

	Super.Tick(DeltaTime);

	// rotation audio
	if ( Instigator != None && Instigator.Controller != None && RotateLoopSound != None )
	{
		AimRotVel = Abs(float(Instigator.Controller.Rotation.Yaw - LastControllerYaw) / DeltaTime);
		if ( (!bPlayingRotAudio && (AimRotVel > RotAudioStartVelThreshold)) ||
			(bPlayingRotAudio && (AimRotVel > RotAudioStopVelThreshold)) )
		{
			bPlayRotAudio = TRUE;
		}

		// start/stop audio as necessary
		if (bPlayRotAudio)
		{
			if (!bPlayingRotAudio)
			{
				// local players only
				RotateLoopAC = GearWeaponPlaySoundLocalEx(None, RotateLoopSound,, RotateLoopAC, 0.15f);
				RotateLoopAC.bAutoDestroy = FALSE;
				bPlayingRotAudio = (RotateLoopAC != None);
			}
		}
		else
		{
			if (bPlayingRotAudio)
			{
				RotateLoopAC.FadeOut(0.15f, 0.f);
				bPlayingRotAudio = FALSE;
			}
		}

		if (bPlayingRotAudio)
		{
			RotAudioPct = FClamp(GetRangePctByValue(RotAudioVolumeVelRange, AimRotVel), 0.f, 1.f);
			RotateLoopAC.VolumeMultiplier = FInterpTo(RotateLoopAC.VolumeMultiplier, GetRangeValueByPct(RotAudioVolumeRange, RotAudioPct), DeltaTime, 8.f);
		}

		LastControllerYaw = Instigator.Controller.Rotation.Yaw;
	}
}

/** Disallows firing if we are overheated */
simulated function BeginFire(byte FireModeNum)
{
	if( !bOverheated )
	{
		Super.BeginFire(FireModeNum);
	}
}

simulated state Active
{
	/** Override BeginFire so we can stop it from firing if unpossessed */
	simulated function BeginFire(byte FireModeNum)
	{
		if ( (GetWeaponController() != None) && !bOverheated && `TimeSince(LastShotTime) > (60.f / FanningRateOfFire) )
		{
			Super.BeginFire(FireModeNum);
		}
	}

	simulated function Tick(float DeltaTime)
	{
		local GearPC GPC;
		local GearPlayerInput GPI;
		local bool bR1Pressed;

		GPC = GearPC(GetWeaponController());
		GPI = (GPC != None) ? GearPlayerInput(GPC.PlayerInput) : None;

		bR1Pressed = (GPI != None && GPI.IsButtonActive(GB_RightBumper)) || (GearAIController != None && GearAIController.bPerformActiveCooling);
		if (bActivelyCooling && !bR1Pressed)
		{
			EndActiveCooling();
		}
		else if ( !bActivelyCooling && bR1Pressed && (CurrentBarrelHeat > 0.f) )
		{
			BeginActiveCooling();
		}

		Global.Tick(DeltaTime);
	}
}


/** Don't allow the player to shoot if the pod has no health */
simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	local Vehicle_Submarine_Base Submarine;
	local int SeatIdx;
	local AnimNodeSequence AnimSeq;

	// Get the submarine
	Submarine = Vehicle_Submarine_Base(MyVehicle);
	if (Submarine != None)
	{
		// Loop through the seats
		for (SeatIdx = 1; SeatIdx < Submarine.Seats.Length; SeatIdx++)
		{
			// Find the seat where our weapon is
			if (Submarine.Seats[SeatIdx].Gun == self)
			{
				// Don't fire if the emerge anim is playing
				AnimSeq = GetWeaponAnimNodeSeq();
				if (AnimSeq != None &&
					AnimSeq.bPlaying &&
					AnimSeq.AnimSeqName == 'Pod_Emerge')
				{
					return FALSE;
				}
				// Only fire the weapon if the pod has health
				else
				{
					return (Submarine.PodHealth[SeatIdx-1] > 0);
				}
			}
		}
	}
	return FALSE;
}

/** Return TRUE to prevent targeting */
simulated function bool ShouldPreventTargeting()
{
	local Vehicle_Submarine_Base Submarine;
	local int SeatIdx;

	// Get the submarine
	Submarine = Vehicle_Submarine_Base(MyVehicle);
	if (Submarine != None)
	{
		// Loop through the seats
		for (SeatIdx = 1; SeatIdx < Submarine.Seats.Length; SeatIdx++)
		{
			// Find the seat where our weapon is
			if (Submarine.Seats[SeatIdx].Gun == self)
			{
				// Only target the weapon if the pod has health
				return (Submarine.PodHealth[SeatIdx-1] <= 0) ? TRUE : bPreventTargeting;
			}
		}
	}
	return TRUE;
}

simulated function float GetWeaponDistanceForEnemyTrace()
{
	return 30000.0f;
}

simulated state WeaponFiring
{
	simulated function EndFire(byte FireModeNum)
	{
		Global.EndFire(FireModeNum);
		SetTimer(0.1,FALSE,nameof(DelayedReturnToActive));
	}
}

simulated function DelayedReturnToActive()
{
	if (IsInState('WeaponFiring'))
	{
		GotoState('Active');
	}
}

/**
 * Returns the AnimNodeSequence the weapon is using to play animations.
 *
 */
simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
	local AnimTree Tree;
	local AnimNodeSequence AnimSeq;
	local SkeletalMeshComponent SkelMesh;

	if (CustomAnimNode != None)
	{
		//`DLog("SeqNode:" @ CustomAnimNode.GetCustomAnimNodeSeq());
		return CustomAnimNode.GetCustomAnimNodeSeq();
	}

	SkelMesh = MyVehicle.GetSeatMesh(SeatIndex);
	if (SkelMesh != None)
	{
		//Try getting an animtree first
		Tree = AnimTree(SkelMesh.Animations);
		if (Tree != None)
		{
			AnimSeq = AnimNodeSequence(Tree.Children[0].Anim);
		}
		else
		{
			//Old legacy way without an animtree
			AnimSeq = AnimNodeSequence(SkelMesh.Animations);
		}

		return AnimSeq;
	}

	return None;
}

/** Overloaded so we can disable the firing of the weapon */
simulated function StartFire(byte FireModeNum)
{
	if( bOverheated )
	{
		PlayNoAmmoFireSound();
	}

	if( !bTurretDisabled && !bActivelyCooling)
	{
		Super.StartFire(FireModeNum);
	}
}

/** Tells the weapon to disable/enble its' ability to fire */
function ToggleWeaponFire(bool bDisabled)
{
	bTurretDisabled = bDisabled;
	if (bDisabled)
	{
		StopFire(0);
	}
}


defaultproperties
{
	bWeaponCanBeReloaded=true
	bIsSuppressive=true
	bInfiniteSpareAmmo=true

	// Additional aim error for AI using the turret
//test
	AdditionalAimError=500

	WeaponFireTypes(0)=EWFT_Projectile
	InstantHitDamageTypes(0)=class'GDT_SubHarpoon'
	AmmoTypeClass=class'GearAmmoType_Boomer'
	WeaponStatName="SubmarineTurret"

	WeaponFireAnimLeft="Pod_L_Fire"
	WeaponFireAnimRight="Pod_R_Fire"

	FireOffset=(X=68,Y=0,Z=9)

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.600)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	WeaponID=WC_Boomshot

	MaxFinalAimAdjustment=0.25

	bOverrideDistanceForEnemyTrace=TRUE

	OverheatHUDColor=(R=10, G=160, B=250)

	RotAudioStartVelThreshold=2500.f
	RotAudioStopVelThreshold=1000.f
	RotAudioVolumeVelRange=(X=5000.f,Y=15000.f)
	RotAudioVolumeRange=(X=0.1f,Y=1.f)
}
