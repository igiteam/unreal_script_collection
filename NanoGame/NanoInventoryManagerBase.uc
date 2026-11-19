/**
* NanoInventoryManagerBase
* Nano inventory definition
*
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoInventoryManagerBase extends InventoryManager
	abstract
	config(Weapon)
	DependsOn(NanoTypes,NanoWeapon);



/** Weapon we had equipped before the current one. */
var transient NanoWeapon PreviousEquippedWeapon;




/**
* Finds out if player is carrying weapon, and adds ammunition if so.
* Returns TRUE if successful
*/
function bool AddAmmoFromWeaponClass(class<NanoWeapon> WeaponClass, int SpecifiedAmount)
{
	return FALSE;
}

/**
* Returns TRUE if Pawn P can pick up ammo of this AmmoType
* bExcludeChecks - TRUE = could you have?
*                - FALSE = you actually can
*/
simulated function bool CanPickUpAmmoType(class<NanoAmmoType> AmmoTypeClass, bool bExcludeChecks)
{
	return FALSE;
}


/**
* If Server in a network game, then replicate CurrentWeapon changes.
* Do this only when we actually switch weapons
* As on local player or server, setting PendingWeapon is no guarantee that the weapon will switch right away.
* So we replicate changes only when the player actually switches to a new weapon.
*/
simulated function ReplicateCurrentWeaponToRemoteClients(Weapon CurrentWeapon, optional bool bHadAPreviousWeapon)
{
	local NanoPawn			P;
	local class<NanoWeapon>	CurrentWeaponClass;

	P = NanoPawn(Owner);
	if( P != None && P.Role == ROLE_Authority )
	{
		if( CurrentWeapon != None )
		{
			CurrentWeaponClass = class<NanoWeapon>(CurrentWeapon.class);
		}

		if( P.RemoteWeaponRepInfo.WeaponClass != CurrentWeaponClass )
		{
			// Set up weapon slave replication to remote clients.
			P.RemoteWeaponRepInfo.WeaponClass				= CurrentWeaponClass;
			P.RemoteWeaponRepInfo.BYTE_bHadAPreviousWeapon	= BYTE(bHadAPreviousWeapon);
			P.bForceNetUpdate = TRUE;

			`LogInv("Weapon Class set for replication to remote clients." @ CurrentWeaponClass @ "bHadAPreviousWeapon:" @ bHadAPreviousWeapon);
		}
	}
}



/**
* Notification called from NanoWeapon when the current weapon is being put down.
*/
simulated function PuttingWeaponDown()
{
	local NanoPawn P;

	P = NanoPawn(Owner);
	// If we're putting our weapon down and we have a PendingWeapon, then replicate this
	// So remote clients can start switching as well.
	// We anticipate the switch, so there is no delay on remote clients.
	// If the switch didn't go as planned, we fix this in ChangedWeapon().
	if( PendingWeapon != None )
	{
		ReplicateCurrentWeaponToRemoteClients(PendingWeapon, (P != None && P.MyNanoWeapon != None));
	}
}

/** Player has equipped a new weapon, make sure all clients are synched */
simulated function WeaponEquipped()
{
	if( Instigator.Weapon != None )
	{
		ReplicateCurrentWeaponToRemoteClients(Instigator.Weapon, FALSE);
	}
}

/** @see InventoryManager::ServerChangedWeapon */
simulated function ChangedWeapon()
{
	local NanoWeapon				CurrentWeapon;
	//local NanoPawn.EAttachSlot	DesiredSlot;
	local Weapon				OldWeapon;
	//local NanoPlayerCamera		GPCam;
	local NanoPC				PC;
	local NanoPawn				P;

	P	= NanoPawn(Owner);
	if(P != none)
	{
		PC	= NanoPC(P.Controller);
	}


	// indicate we should draw the weapon indicator
	if( P != None && PC != None )
	{
		//FIXME PC.SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
	}

	// Save current weapon as old weapon
	OldWeapon = Instigator.Weapon;

	PreviousEquippedWeapon = NanoWeapon(OldWeapon);


	// Equip PendingWeapon
	Super.ChangedWeapon();

	// We have now equipped a new weapon so replicate this change to remote clients, to make sure they're in synch
	ReplicateCurrentWeaponToRemoteClients(Instigator.Weapon, (OldWeapon != None));

	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ "Instigator:" @ Instigator @ "Weapon:" @ Instigator.Weapon @ "OldWeapon:" @ OldWeapon);

	if( Role == ROLE_Authority && P != None )
	{
		// if we're switching to a weapon that wasn't assigned a slot, fix it up
		CurrentWeapon = NanoWeapon(P.Weapon);
		if( CurrentWeapon != None 
			&& CurrentWeapon != OldWeapon 
			//&& CurrentWeapon.CharacterSlot == EASlot_None 
			)
		{
			//`log( GetFuncName() @ "weapon had no slot, fix it up!!" $ " Pawn: " $ Pawn(Owner) $ " CurrentWeapon: " $ CurrentWeapon $ " OldWeapon: " $ OldWeapon );
			//DesiredSlot = FindFreeSlotForInventoryClass(CurrentWeapon.class);
			//CurrentWeapon.AssignToSlot(DesiredSlot);
		}
	}

	//FIXME
	// 	if( PC != None )
	// 	{
	// 		GPCam = NanoPlayerCamera(PC.PlayerCamera);
	// 		if ( (GPCam != None) && (GPCam.CurrentCamera == GPCam.GameplayCam) )
	// 		{
	// 			GearGameplayCameraMode(GPCam.GameplayCam.CurrentCamMode).WeaponChanged(PC, OldWeapon, Instigator.Weapon);
	// 		}
	// 	}
}


/**
 * Called from PlayerController::UpdateRotation() -> PlayerController::ProcessViewRotation() -> Pawn::ProcessViewRotation()
 * to (pre)process player ViewRotation.
 * adds delta rot (player input), applies any limits and post-processing
 * returns the final ViewRotation set on PlayerController
 *
 * @param	DeltaTime, time since last frame
 * @param	ViewRotation, actual PlayerController view rotation
 * @input	out_DeltaRot, delta rotation to be applied on ViewRotation. Represents player's input.
 * @return	processed ViewRotation to be set on PlayerController.
 */

simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local NanoWeaponBase ActiveWeapon;

	if (Pawn(Owner) != None)
	{
		// Give weapon a chance to modify playercontroller's viewrotation
		ActiveWeapon = NanoWeaponBase(Pawn(Owner).Weapon);
		if( ActiveWeapon != None )
		{
			ActiveWeapon.ProcessViewRotation( DeltaTime, out_ViewRotation, out_DeltaRot );
		}
	}
}



defaultproperties
{
	// this needs to match the num FireMode in NanoWeaponBase
	PendingFire.Empty
	PendingFire(0)=0
	PendingFire(1)=0
	PendingFire(2)=0
	PendingFire(3)=0
	PendingFire(4)=0
	PendingFire(5)=0
	PendingFire(6)=0
	PendingFire(7)=0
	PendingFire(8)=0
	PendingFire(9)=0
	PendingFire(10)=0
}