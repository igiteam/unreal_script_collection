/**
 * Multi Turret base class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Turret_MultiTurretBase extends Turret_TroikaBase
	abstract
	config(Pawn);

/** The names of the sockets that weapons should attach to */
var array<name> GunSockets;

/** The weapons spawned */
var protected array<GearWeapon> Weapons;

enum EMultiTurretStyle
{
	EMTS_Shotgun,
	EMTS_Hammerburst,
	EMTS_Lancer,
	EMTS_Boomshot,
	EMTS_LancerChainsaw,
	EMTS_Boomshot_GasBarge,
};

/** The type of guns used in this Multi Turret */
var() EMultiTurretStyle MultiTurretStyle;

/** The weapon class of the different turret types */
var array< class<GearWeapon> > TurretWeaponClass;

/** How long to stagger firing each weapon in the different turret types, weapons that have looping fire effects and need manual StopFire calls should not be stagger fired, as a percentage of time/shot */
var config array<float> StaggerTimeBetweenWeapons;

/** The reload speed of the different turret types */
var config array<float> ReloadSpeed;

/** The size of the turret's internal magazine */
var float MagazineSize;

/** How many shots have been used from the current magazine */
var int AmmoUsedCount;

/** Replicate the gun in slot 0 */
var repnotify GearWeapon ReplicatedGunSlot0;

/** Replicate the gun in slot 1 */
var repnotify GearWeapon ReplicatedGunSlot1;

/** Replicate the gun in slot 2 */
var repnotify GearWeapon ReplicatedGunSlot2;

/** Replicate the gun in slot 3 */
var repnotify GearWeapon ReplicatedGunSlot3;

/** Where a replicated stagger-fired weapon needs to create fire effects */
var vector SavedFlashLocation;

/** Which stagger-fired weapon is next */
var int WeaponIter;

/** Which stagger-fired weapon should start first */
var int StartingWeaponIter;

/** If the weapons are firing now */
var bool bFiring;

/** Custom fire sounds for enemy */
var array<SoundCue> FireSoundEnemy;

/** Custom fire sounds for squad */
var array<SoundCue> FireSoundSquad;

/** Custom fire sounds for local player */
var array<SoundCue> FireSoundPlayer;

/** Custom fire stop sounds for enemy */
var array<SoundCue> FireStopSoundEnemy;

/** Custom fire stop sounds for squad */
var array<SoundCue> FireStopSoundSquad;

/** Custom fire stop sounds for local player */
var array<SoundCue> FireStopSoundPlayer;

/** Sound of the turret reloading */
var SoundCue ReloadSound;

/** Anim node to play the reload anim on */
var GearAnim_Slot CustomAnimNode;

/** Reload body stance for the driver */
var BodyStance BS_Reload;

/** Tell clients to play the reload animation */
var repnotify bool bReloading;

/** Reference to the reload sound so we can fade it out if the reload is cancelled */
var AudioComponent ReloadSoundComp;

replication
{
	if (bNetDirty)
		ReplicatedGunSlot0, ReplicatedGunSlot1, ReplicatedGunSlot2, ReplicatedGunSlot3, MagazineSize, AmmoUsedCount, StartingWeaponIter, bReloading;
}

/** Find the custom anim node */
simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	CustomAnimNode = GearAnim_Slot(Mesh.FindAnimNode('CustomAnim'));
}

/** Spawn weapons on creation */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( IsBoomShotTurret() )
	{
		Weapons.Add(2);
	}
	else
	{
		Weapons.Add(4);
	}

	SpawnWeapons();
}

simulated function bool IsBoomShotTurret()
{
	return (MultiTurretStyle == EMTS_Boomshot || MultiTurretStyle == EMTS_Boomshot_GasBarge);
}

/** Spawn the weapons and attach them to the correct sockets. Host only */
function SpawnWeapons()
{
	local GearWeapon GW;
	local class<GearWeapon> GWClass;
	local int i;
	local int NumGuns;

	GWClass = TurretWeaponClass[MultiTurretStyle];

	if( IsBoomShotTurret() )
	{
		NumGuns = 2;
	}
	else
	{
		NumGuns = 4;
	}

	for (i = 0; i < NumGuns; i++)
	{
		// spawn with self as starting owner so it is spawned in the same streaming level the turret is in
		GW = Spawn(GWClass, self);
		if (GW != None)
		{
			if (InvManager != None)
			{
				InvManager.AddInventory(GW, FALSE);
			}

			// make weapon always replicated so it works on clients automatically
			GW.bAlwaysRelevant = true;
			// don't allow default weapon to be thrown out
			GW.bCanThrow = FALSE;

			GW.Instigator = Self;

			GW.SetInfiniteSpareAmmo();

			if (NumGuns == 2)
			{
				GW.PerformWeaponAttachment(Mesh, GunSockets[i + 4]);
			}
			else
			{
				GW.PerformWeaponAttachment(Mesh, GunSockets[i]);
			}

			Weapons[i] = GW;
		}
	}

	ReplicatedGunSlot0 = Weapons[0];
	ReplicatedGunSlot1 = Weapons[1];

	if (Weapons.Length > 2)
	{
		ReplicatedGunSlot2 = Weapons[2];
		ReplicatedGunSlot3 = Weapons[3];
	}

	MagazineSize = Weapons[0].WeaponMagSize * NumGuns;

	SetActiveWeapon(Weapons[0]);
}

/** All 4 weapons playing their fire loops is extremely loud, try just one custom set on the first weapon */
simulated function SetupCustomFireSounds()
{
	local int i;

	if (MultiTurretStyle == EMTS_Lancer || MultiTurretStyle == EMTS_LancerChainsaw || MultiTurretStyle == EMTS_Hammerburst)
	{
		Weapons[StartingWeaponIter].FireSound = FireSoundEnemy[MultiTurretStyle];
		Weapons[StartingWeaponIter].FireSound_Player = FireSoundPlayer[MultiTurretStyle];
		Weapons[StartingWeaponIter].FireSound_Squad = FireSoundSquad[MultiTurretStyle];

		Weapons[StartingWeaponIter].StopFireSound = FireStopSoundEnemy[MultiTurretStyle];
		Weapons[StartingWeaponIter].StopFireSound_Player = FireStopSoundPlayer[MultiTurretStyle];
		Weapons[StartingWeaponIter].StopFireSound_Squad = FireStopSoundSquad[MultiTurretStyle];

		for (i = 0; i < Weapons.Length; i++)
		{
			if (i != StartingWeaponIter)
			{
				Weapons[i].FireSound = None;
				Weapons[i].FireSound_Player = None;
				Weapons[i].FireSound_Squad = None;
				Weapons[i].StopFireSound =  None;
				Weapons[i].StopFireSound_Player = None;
				Weapons[i].StopFireSound_Squad = None;
			}
		}
	}
}

/**
 * When the guns are replicated over, attach them to the correct socket
 *
 * @param VarName - the variable that has just been replicated
 */
simulated event ReplicatedEvent(name VarName)
{
	local float AnimTime;

	Super.ReplicatedEvent(VarName);

	// Actor references are repeatedly replicated until the server recieves an ack from the client.
	// This can cause ReplicatedEvent to be called multiple times with the same data.
	if (VarName == 'bReloading')
	{
		if (bReloading)
		{
			StopFiring();
			AnimTime = PlayReloadAnims();
			SetTimer(AnimTime, FALSE, nameof(CleanUpReloadAnims));
		}
	}
	else if (VarName == 'ReplicatedGunSlot0')
	{
		if (Weapons[0] != ReplicatedGunSlot0)
		{
			if( IsBoomShotTurret() )
			{
				ReplicatedGunSlot0.PerformWeaponAttachment(Mesh, GunSockets[4]);
			}
			else
			{
				ReplicatedGunSlot0.PerformWeaponAttachment(Mesh, GunSockets[0]);
			}

			ReplicatedGunSlot0.SetMaterialBasedOnTeam(ReplicatedGunSlot0.Mesh, 1);
			Weapons[0] = ReplicatedGunSlot0;
		}
	}
	else if (VarName == 'ReplicatedGunSlot1')
	{
		if (Weapons[1] != ReplicatedGunSlot1)
		{
			if( IsBoomShotTurret() )
			{
				ReplicatedGunSlot1.PerformWeaponAttachment(Mesh, GunSockets[5]);
			}
			else
			{
				ReplicatedGunSlot1.PerformWeaponAttachment(Mesh, GunSockets[1]);
			}

			ReplicatedGunSlot1.SetMaterialBasedOnTeam(ReplicatedGunSlot1.Mesh, 1);
			Weapons[1] = ReplicatedGunSlot1;
		}
	}
	else if (VarName == 'ReplicatedGunSlot2')
	{
		if (Weapons[2] != ReplicatedGunSlot2)
		{
			ReplicatedGunSlot2.PerformWeaponAttachment(Mesh, GunSockets[2]);
			ReplicatedGunSlot2.SetMaterialBasedOnTeam(ReplicatedGunSlot2.Mesh, 1);
			Weapons[2] = ReplicatedGunSlot2;
		}
	}
	else if (VarName == 'ReplicatedGunSlot3')
	{
		if (Weapons[3] != ReplicatedGunSlot3)
		{
			ReplicatedGunSlot3.PerformWeaponAttachment(Mesh, GunSockets[3]);
			ReplicatedGunSlot3.SetMaterialBasedOnTeam(ReplicatedGunSlot3.Mesh, 1);
			Weapons[3] = ReplicatedGunSlot3;
		}
	}
}

/**
 * Block the standard troika's PlayWeaponSwitch function
 *
 * @param OldWeapon - the previous weapon
 *
 * @param NewWeapon - the weapon that was just replicated over
 */
simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon);

/**
 * If we have ammo, start firing and let the server know
 *
 * @param FireModeNum - the fire mode that we're trying to start
 */
simulated function StartFire(byte FireModeNum)
{
	if (FireModeNum == 0)
	{
		if (!Weapons[0].HasAmmo(0))
		{
			AttemptReload();
		}
		else if (!bReloading && !IsStartingWeaponFiring() && !Weapons[0].PendingFire(0))
		{
			if (Role < ROLE_Authority)
			{
				ServerStartFire();
			}

			bFiring = TRUE;

			SetupCustomFireSounds();

			Weapons[0].SetPendingFire(0);

			WeaponIter = StartingWeaponIter;
			FireNextWeapon();
		}
	}
	else
	{
		Super.StartFire(FireModeNum);
	}
}

/**
 * Check if any of our weapons are firing and make sure we've completed any current staggered fire sequence
 *
 * @return TRUE if we're currently firing any weapon
 */
simulated function bool IsStartingWeaponFiring()
{
	if (WeaponIter != 0)
	{
		return TRUE;
	}

	if (!Weapons[StartingWeaponIter].IsInState('Active') && !Weapons[StartingWeaponIter].IsInState('Inactive'))
	{
		return TRUE;
	}	

	return FALSE;
}

/**
 * Tell the server to stop firing and manually clear each of the weapons's FlashLocation
 *
 * @param FireModeNum - the fire mode that we're trying to start
 */
simulated function StopFire(byte FireModeNum)
{
	//`log(GetFuncName() @ `showvar(WeaponIter));

	if (FireModeNum == 0)
	{
		if (Role < ROLE_Authority)
		{
			ServerStopFire();
		}

		StopFiring();
	}
	else
	{
		Super.StopFire(FireModeNum);
	}
}

/**
 * Clear pending fire and ClearFlashLocation on any weapons that don't have to complete the firing cycle
 * 
 * @return TRUE to signify that the stop was successful
 */
simulated function bool StopFiring()
{
	local int i;

	if (bFiring)
	{		
		StartingWeaponIter = WeaponIter % Weapons.Length;
	}

	bFiring = FALSE;
	
	Weapons[0].ClearPendingFire(0);

	// The standard ClearFlashLocation can't be used here since it's written for only one gun.
	for (i = 0; i < Weapons.Length; i++)
	{
		ClearFlashLocation(Weapons[i]);
	}

	WeaponIter = 0;

	ClearTimer(nameof(FireNextWeapon));
	ClearTimer(nameof(RepeatFlashLocationUpdatedWeapon0));
	ClearTimer(nameof(RepeatFlashLocationUpdatedWeapon1));
	ClearTimer(nameof(RepeatFlashLocationUpdatedWeapon2));
	ClearTimer(nameof(RepeatFlashLocationUpdatedWeapon3));

	return TRUE;
}

simulated function ClearFlashLocation(Weapon InWeapon)
{
	if (!HasAmmo(0))
	{
		AttemptReload();
	}

	if (InWeapon == Weapons[0] && !IsZero(FlashLocation))
	{
		bForceNetUpdate = TRUE;	// Force replication
		FlashLocation = vect(0,0,0);
	}

	FlashLocationUpdated(InWeapon, vect(0,0,0), FALSE);
}

/** The client is firing, fire as well */
reliable server function ServerStartFire()
{
	StartFire(0);
}

/** The client has stopped firing, stop as well */
reliable server function ServerStopFire()
{
	StopFire(0);
}

/** Fire the next weapon in a stagger-fire setup */
simulated function FireNextWeapon()
{
	local int AdjustedWeaponIter;

//	`log(GetFuncName() @ `showvar(WeaponIter)@`showvar(StartingWeaponIter) );

	AdjustedWeaponIter = WeaponIter % Weapons.Length;

	if (WeaponIter - StartingWeaponIter < Weapons.Length)
	{
		// Replication can leave this out
		Weapons[AdjustedWeaponIter].InvManager = InvManager;

		if (HasAmmo(0))
		{
			Weapons[AdjustedWeaponIter].SendToFiringState(0);
		}

		WeaponIter++;

		if (WeaponIter - StartingWeaponIter < Weapons.Length && HasAmmo(0))
		{
			if (StaggerTimeBetweenWeapons[MultiTurretStyle] == 0)
			{
				FireNextWeapon();
			}
			else
			{
				SetTimer(StaggerTimeBetweenWeapons[MultiTurretStyle] * (60 / Weapons[AdjustedWeaponIter].WeaponRateOfFire), FALSE, nameof(FireNextWeapon));
			}
		}
		else
		{
			WeaponIter = 0;
		}
	}
}

/**
 * Whether we should refire, based on turret's firing state
 */ 
simulated function bool ShouldRefire(GearWeapon CheckWeapon)
{
	local int i;

	// If we've started firing all weapons, or have fired this weapon, let it refire

	if (WeaponIter == 0) return TRUE;

	for (i = StartingWeaponIter; i < WeaponIter; i++ )
	{
		if (CheckWeapon == Weapons[i % Weapons.Length])
		{
			return TRUE;
		}
	}
	return FALSE;
}


/** Start the reload timer */
function AttemptReload()
{
	local float AnimTime;

	if (Driver == None)
	{
		return;
	}

	if (AmmoUsedCount > 0 && !IsTimerActive('ReloadWeapons') && GearWeapon(Weapon).bInfiniteSpareAmmo)
	{
		// make sure we can hold down fire through reload
		InvManager.ClearPendingFire(Weapon, 0);

		if (Role == ROLE_Authority)
		{
			ReloadSoundComp = CreateAudioComponent(ReloadSound, FALSE, TRUE, TRUE);
			if (ReloadSoundComp != None)
			{
				ReloadSoundComp.bAutoDestroy = TRUE;
				ReloadSoundComp.Location = Location;
				AttachComponent(ReloadSoundComp);
				ReloadSoundComp.FadeIn(0.3f, 1.f);
			}

			bReloading = TRUE;

			AnimTime = PlayReloadAnims();
			SetTimer(AnimTime, FALSE, nameof(ReloadWeapons));
		}
	}
}

/** Allow clients to cause a reload */
reliable server function ServerAttemptReload()
{
	AttemptReload();
}

/**
 * Play the reload anims
 * 
 * @return the length of the anims
 */
simulated function float PlayReloadAnims()
{
	local GearPawn GP;

	GP = GearPawn(Driver);
	if (GP != None)
	{
		GP.BS_Play(BS_Reload, 1.0f, 0.2f, 0.2f);
		
		SetDriverHandIKActive(GP, FALSE);
	}

	return CustomAnimNode.PlayCustomAnim('MT_Reload', 1.0f, 0.2f, 0.2f, FALSE);
}

/** Turn IK back on */
simulated function CleanUpReloadAnims()
{	
	local GearPawn GP;

	GP = GearPawn(Driver);
	if (GP != None)
	{
		SetDriverHandIKActive(GP, TRUE);
	}
}

/** Reload timer has elapsed, put more ammo in the guns */
function ReloadWeapons()
{
	AmmoUsedCount = 0;
	bReloading = FALSE;

	UpdateWeaponHUD();

	CleanUpReloadAnims();
}

/**
 * Prevent any gun but the first changing the replicated FlashLocation
 *
 * @param InWeapon - the weapon changing the flash location
 *
 * @param InFiringMode - the firing mode that the flash is coming from
 *
 * @param NewLoc - the new flash location
 */
simulated function SetFlashLocation(Weapon InWeapon, byte InFiringMode, vector NewLoc)
{
	local bool bForceNetUpdateSaved;
	local vector LastFiringFlashLocationSaved;
	local vector FlashLocationSaved;

	bForceNetUpdateSaved = bForceNetUpdate;
	LastFiringFlashLocationSaved = LastFiringFlashLocation;
	FlashLocationSaved = FlashLocation;

	Super.SetFlashLocation(InWeapon, InFiringMode, NewLoc);

	if (InWeapon != Weapons[StartingWeaponIter])
	{
		bForceNetUpdate = bForceNetUpdateSaved;
		LastFiringFlashLocation = LastFiringFlashLocationSaved;
		FlashLocation = FlashLocationSaved;
	}
}

/**
 * Stop a replicated weapon from firing
 * 
 * @param Index - the weapon index to stop
 */
simulated function StopReplicatedWeaponFiring(int Index)
{
	Weapons[Index].FlashLocationUpdated(0, vect(0,0,0), FALSE);

	switch(Index)
	{
	case 0:
		ClearTimer(nameof(RepeatFlashLocationUpdatedWeapon0));
		break;
	case 1:
		ClearTimer(nameof(RepeatFlashLocationUpdatedWeapon1));
		break;
	case 2:
		ClearTimer(nameof(RepeatFlashLocationUpdatedWeapon2));
		break;
	case 3:
		ClearTimer(nameof(RepeatFlashLocationUpdatedWeapon3));
		break;
	}
}

/** Loop the replicated flash location */
simulated function RepeatFlashLocationUpdatedWeapon0()
{
	Weapons[0].FlashLocationUpdated(0, SavedFlashLocation, TRUE);
}

/** Loop the replicated flash location */
simulated function RepeatFlashLocationUpdatedWeapon1()
{
	Weapons[1].FlashLocationUpdated(0, SavedFlashLocation, TRUE);
}

/** Loop the replicated flash location */
simulated function RepeatFlashLocationUpdatedWeapon2()
{
	Weapons[2].FlashLocationUpdated(0, SavedFlashLocation, TRUE);
}

/** Loop the replicated flash location */
simulated function RepeatFlashLocationUpdatedWeapon3()
{
	Weapons[3].FlashLocationUpdated(0, SavedFlashLocation, TRUE);
}

/**
 * To save network bandwidth, we're only going to replicate one FlashLocation and fake all the other fire effects
 *
 * @param InWeapon - the weapon updating the flash location
 *
 * @param InFlashLocation - the new flash location
 *
 * @param bViaReplication - whether the flash was generated remotely
 */
simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
	local GearWeapon GearWeap;
	local int i;

	//`log(GetFuncName() @ `showvar(InWeapon) @ `showvar(InFlashLocation) @ bViaReplication);

	if (bViaReplication)
	{
		if (IsZero(InFlashLocation))
		{
			bFiring = FALSE;

			if (InvManager != None)
			{
				// make sure we can hold down fire through reload
				InvManager.ClearPendingFire(InWeapon, 0);
			}

			for (i = 0; i < Weapons.Length; i++)
			{
				StopReplicatedWeaponFiring(i);
			}

			ClearTimer('ReplicatedFlashUpdateNextWeapon');

		}
		else if (!Weapons[0].bClientSideInstantHit || !IsLocallyControlled())
		{
			SavedFlashLocation = InFlashLocation;

			if (!bFiring)
			{
				bFiring = TRUE;
				SetupCustomFireSounds();
				WeaponIter = StartingWeaponIter;
				ReplicatedFlashUpdateNextWeapon();
			}
		}
	}
	else
	{
		GearWeap = GearWeapon(InWeapon);
		GearWeap.FlashLocationUpdated(GetWeaponFiringMode(MyWeapon), InFlashLocation, bViaReplication);
	}
}

/** Stagger-fire weapons use a cached flash location for their fire effects */
simulated function ReplicatedFlashUpdateNextWeapon()
{
	local int AdjustedWeaponIter;

	if (!bFiring)
	{
		return;
	}

	AdjustedWeaponIter = WeaponIter % Weapons.Length;

	if (WeaponIter - StartingWeaponIter < Weapons.Length)
	{
		if (HasAmmo(0))
		{
			Weapons[AdjustedWeaponIter].FlashLocationUpdated(GetWeaponFiringMode(Weapons[AdjustedWeaponIter]), SavedFlashLocation, TRUE);
		}
		
		if (bFiring)
		{
			// start the proper weapon loop firing
			switch(AdjustedWeaponIter)
			{
			case 0:
				SetTimer(Weapons[AdjustedWeaponIter].GetFireInterval(0), TRUE, nameof(RepeatFlashLocationUpdatedWeapon0));
				break;
			case 1:
				SetTimer(Weapons[AdjustedWeaponIter].GetFireInterval(0), TRUE, nameof(RepeatFlashLocationUpdatedWeapon1));
				break;
			case 2:
				SetTimer(Weapons[AdjustedWeaponIter].GetFireInterval(0), TRUE, nameof(RepeatFlashLocationUpdatedWeapon2));
				break;
			case 3:
				SetTimer(Weapons[AdjustedWeaponIter].GetFireInterval(0), TRUE, nameof(RepeatFlashLocationUpdatedWeapon3));
				break;
			}
		}

		WeaponIter++;

		if (WeaponIter - StartingWeaponIter < Weapons.Length && HasAmmo(0))
		{
			if (StaggerTimeBetweenWeapons[MultiTurretStyle] == 0)
			{
				ReplicatedFlashUpdateNextWeapon();
			}
			else
			{
				SetTimer(StaggerTimeBetweenWeapons[MultiTurretStyle]  * (60 / Weapons[AdjustedWeaponIter].WeaponRateOfFire), FALSE, nameof(ReplicatedFlashUpdateNextWeapon));
			}
		}
		else
		{
			WeaponIter = 0;
		}
	}
}

/**
 * Forward FlashCount updates to weapon.
 * 
 * @param InWeapon - the weapon the flash count is updating
 * 
 * @param InFlashCount - the new flash count
 * 
 * @param bViaReplication - whether this was caused by replication or not
 */
simulated function FlashCountUpdated(Weapon InWeapon, Byte InFlashCount, bool bViaReplication)
{
	local GearWeapon GearWeap;

	// make sure we can hold down fire through reload
	if (InFlashCount == 0 && InvManager != None)
	{
		InvManager.ClearPendingFire(InWeapon, 0);
	}

	GearWeap = GearWeapon(InWeapon);
	if (GearWeap != None)
	{
		GearWeap.FlashCountUpdated(InFlashCount, GetWeaponFiringMode(InWeapon), bViaReplication);
	}
}

/**
 * Keep track of all the ammo for all weapons
 *
 * @param FireModeNum - the current fire mode
 */
simulated function ConsumeAmmo(byte FireModeNum)
{
	AmmoUsedCount++;

	UpdateWeaponHUD();
}

/**
 * Whether there's still ammo to consume
 *
 * @param FireModeNum - the current fire mode
 *
 * @param Amount - the amount requested to consume
 *
 * @return TRUE if there's enough ammo to satisfy the request
 */
simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	// we can always reload
	if (FireModeNum == class'GearWeapon'.const.RELOAD_FIREMODE)
	{
		return TRUE;
	}

	// Assume we ask for at least 1 bullet to be there.
	if (Amount == 0)
	{
		Amount = 1;
	}

	// If we have fired more than Magazine capacity, then we need to reload
	if (MagazineSize > 0 && AmmoUsedCount + Amount > MagazineSize)
	{
		return FALSE;
	}

	return TRUE;
}

simulated function UpdateWeaponHUD()
{
	// HUD display only
	Weapons[0].AmmoUsedCount = AmmoUsedCount / Weapons.Length;

	// Make sure that there's no straggler icons
	if (MagazineSize - AmmoUsedCount == 0)
	{
		Weapons[0].AmmoUsedCount = Weapons[0].WeaponMagSize;
	}

	Weapons[0].SpareAmmoCount = (MagazineSize - AmmoUsedCount) - (Weapons[0].WeaponMagSize - Weapons[0].AmmoUsedCount);
}

/**
 * Set the maximum ammo a turret has
 *
 * @param AmmoCount - the maximum ammo count
 */
function SetMaxAmmo(float AmmoCount)
{
	// No longer infinite ammo
	GearWeapon(Weapon).bInfiniteSpareAmmo = false;

	MagazineSize = AmmoCount;
	Weapons[0].WeaponMagSize = MagazineSize / Weapons.Length;
	AmmoUsedCount = 0;

	UpdateWeaponHUD();
}

/**
 * @return the current ammo used count
 */
simulated function int GetAmmoUsedCount()
{
	return AmmoUsedCount;
}

/** sets how much ammo has been used already */
function SetAmmoUsedCount(int NewUsedCount)
{
	AmmoUsedCount = NewUsedCount;
}

/**
 * Resupply the turret with ammo
 *
 * @param AmmoCount - how much ammo to add to the turret
 */
function GiveAmmo(int AmmoCount)
{
	AmmoUsedCount = Max(0, AmmoUsedCount - AmmoCount);

	UpdateWeaponHUD();
}

/**
 * Start a reload if needed
 * 
 * @param P - the Pawn attaching
 */
simulated function AttachDriver(Pawn P)
{
	Super.AttachDriver(P);

	if (!HasAmmo(0))
	{
		AttemptReload();
	}
}

/**
 * Clients can get stuck firing effects if they race the server ClearFlashLocation
 * 
 * @param P - the Pawn detaching
 */
simulated function DetachDriver(Pawn P)
{
	Super.DetachDriver(P);
	StopFiring();

	GearPawn(P).BS_Stop(BS_Reload);

	if (IsTimerActive(nameof(ReloadWeapons)))
	{
		bReloading = FALSE;

		ClearTimer(nameof(ReloadWeapons));

		CustomAnimNode.StopCustomAnim(0.2f);

		if (ReloadSoundComp != None)
		{
			ReloadSoundComp.FadeOut(0.2f, 0);
		}
	}
}

/**
 * Turn off IK if reloading
 * 
 * @param GP - the pawn that just got on
 */
simulated function TurretManned(GearPawn GP)
{
	if (bReloading && GP != None)
	{
		SetDriverHandIKActive(GP, FALSE);
	}
}

/**
 * Enable or disable hand IK for the driver
 * 
 * @param GP - the driver
 * 
 * @param bActive - whether to enable or disable IK
 */
simulated function SetDriverHandIKActive(GearPawn GP, bool bActive)
{	
	if (GP != None)
	{
		if (GP.IKCtrl_RightHand != None)
		{
			GP.IKCtrl_RightHand.SetSkelControlActive(bActive);
		}
		if (GP.IKCtrl_LeftHand != None)
		{
			GP.IKCtrl_LeftHand.SetSkelControlActive(bActive);
		}
		if (GP.IKRotCtrl_RightHand != None)
		{
			GP.IKRotCtrl_RightHand.SetSkelControlActive(bActive);
		}
		if (GP.IKRotCtrl_LeftHand != None)
		{
			GP.IKRotCtrl_LeftHand.SetSkelControlActive(bActive);
		}
	}
}

/**
 * Never draw the crosshair on the multiturret
 * 
 * @param PC - the controller using the weapon
 * 
 * @return FALSE to block crosshair drawing
 */
simulated function bool WantsCrosshair(PlayerController PC)
{
	return FALSE;
}

/** @return if we should be using the targeting camera */
simulated function bool ShouldTargetingModeZoomCamera()
{
	if (bReloading)
	{
		return FALSE;
	}

	return Super.ShouldTargetingModeZoomCamera();
}

defaultproperties
{
	DefaultInventory.Empty

	GunSockets(0)=Gun_Slot_1
	GunSockets(1)=Gun_Slot_2
	GunSockets(2)=Gun_Slot_4
	GunSockets(3)=Gun_Slot_3
	GunSockets(4)=Gun_Slot_5
	GunSockets(5)=Gun_Slot_6

	MultiTurretStyle=EMTS_Lancer

	BS_Reload=(Stance=((Slot=BS_FullBody,AnimName="MultiTurret_Reload")))
}
