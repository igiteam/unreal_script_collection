/**
 * Used for linking and synchronizing coop MG data in networked games
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/** Could genericize this class fairly easily for other coop weapons, but will forgo that for now. */

class CoopMGSyncActor extends Actor
	native(Weapon)
	abstract
	dependson(GearDroppedPickup,GearWeaponPickupFactory);

/** Can be a pickup factory, a pawn (holding the actual weapon actor), or a droppedpickup. */
var protectedwrite transient Actor MGActor;

/** Can be a pickup factory, a pawn (holding the actual weapon actor), or a droppedpickup. */
var protectedwrite transient Actor AmmoBoxActor;

var transient int AmmoUsedCount;
var transient int SpareAmmoCount;

/** Whether we're destroying the linked actors currently */
var transient bool bDestroyingLinkedActors;

/** The chain connecting the gun and ammo box */
var SkeletalMeshComponent ChainMesh;

/** Cache of skel control single bones **/
var SkelControlSingleBone RootSkelControl;
var SkelControlSingleBone EndSkelControl;
var SkelControlSingleBone MidSkelControl;

replication
{
	if (Role == ROLE_Authority)
		MGActor, AmmoBoxActor, AmmoUsedCount, SpareAmmoCount;
}

/**
 * Fetch the mesh of the weapon counterpart of A
 *
 * @param A - the weapon we're searching for the counterpart of
 *
 * @return the skeletal mesh of the weapon counterpart
 */
simulated function SkeletalMeshComponent GetCoopWeaponMesh(Actor A)
{
	local GearDroppedPickup DP;
	local GearWeaponPickupFactory PF;
	local GearPawn GP;
	local Actor SyncA;

	SyncA = GetSyncActor(A);

	DP = GearDroppedPickup(SyncA);
	if (DP != None)
	{
		return SkeletalMeshComponent(DP.MyMeshComp);
	}
	else
	{
		PF = GearWeaponPickupFactory(SyncA);
		if (PF != None)
		{
			return SkeletalMeshComponent(PF.PickupMesh);
		}
		else
		{
			GP = GearPawn(SyncA);
			if ( (GP != None) && (GP.MyGearWeapon != None) )
			{
				return SkeletalMeshComponent(GP.MyGearWeapon.Mesh);
			}
		}
	}

	return None;
}

simulated static protected event vector GetCoopWeaponLoc(Actor A)
{
	local GearDroppedPickup DP;
	local GearWeaponPickupFactory PF;
	local GearPawn GP;
	local Actor SyncA;

	SyncA = GetSyncActor(A);

	DP = GearDroppedPickup(SyncA);
	if (DP != None)
	{
		return DP.MyMeshComp.GetPosition();
	}
	else
	{
		PF = GearWeaponPickupFactory(SyncA);
		if (PF != None)
		{
			return PF.PickupMesh.GetPosition();
		}
		else{
			GP = GearPawn(SyncA);
			if ( (GP != None) && (GP.MyGearWeapon != None) )
			{
				return GP.MyGearWeapon.Mesh.GetPosition();
			}
		}
	}

	// fallback
	return (A == None) ? vect(0,0,0) : A.Location;
}

protected function static Actor GetSyncActor(Actor A)
{
	local GearWeapon GW;
	GW = GearWeapon(A);
	if (GW != None)
	{
		return GW.Instigator;
	}

	return A;
}

protected function LinkToSyncActor(Actor A)
{
	local GearDroppedPickup DP;
	local GearWeaponPickupFactory PF;
	local GearPawn GP;

	DP = GearDroppedPickup(A);
	if (DP != None)
	{
		DP.CoopWeaponSyncActor = self;
	}
	else
	{
		PF = GearWeaponPickupFactory(A);
		if (PF != None)
		{
			PF.CoopWeaponSyncActor = self;
		}
		else
		{
			GP = GearPawn(A);
			if (GP != None)
			{
				GP.CoopWeaponSyncActor = self;
			}
		}
	}
}
protected function UnLinkFromSyncActor(Actor A)
{
	local GearDroppedPickup DP;
	local GearWeaponPickupFactory PF;
	local GearPawn GP;

	DP = GearDroppedPickup(A);
	if (DP != None)
	{
		DP.CoopWeaponSyncActor = None;
	}
	else
	{
		PF = GearWeaponPickupFactory(A);
		if (PF != None)
		{
			PF.CoopWeaponSyncActor = None;
		}
		else
		{
			GP = GearPawn(A);
			if (GP != None)
			{
				GP.CoopWeaponSyncActor = None;
			}
		}
	}
}

/** Get rid of stray coop actors */
function DestroyLinkedActors()
{
	if( !bDestroyingLinkedActors )
	{
		bDestroyingLinkedActors = TRUE;

		if (MGActor != None)
		{
			CleanupSyncActor(MGActor);
		}

		if (AmmoBoxActor != None)
		{
			CleanupSyncActor(AmmoBoxActor);
		}

		bDestroyingLinkedActors = FALSE;
	}
}

/**
 * Destroy any orphan dropped pickups, respawn pickup factories, and throw orphan weapons
 *
 * @param A - the coop actor to clean up
 */
protected function CleanupSyncActor(Actor A)
{
	local GearDroppedPickup DP;
	local GearWeaponPickupFactory PF;
	local GearPawn GP;

	DP = GearDroppedPickup(A);
	if (DP != None)
	{
		DP.Destroy();
	}
	else
	{
		PF = GearWeaponPickupFactory(A);
		if (PF != None)
		{
			PF.SetRespawn();
		}
		else
		{
			GP = GearPawn(A);
			if (GP != None && GP.Weapon != None && !GP.Weapon.IsInState('Inactive'))
			{
				GP.ThrowActiveWeapon();
			}
		}
	}
}

/** Server only, clients will get this via replication. */
function bool LinkCoopWeapons(Actor MGPart, Actor AmmoBoxPart)
{
	MGActor = GetSyncActor(MGPart);
	LinkToSyncActor(MGActor);

	AmmoBoxActor = GetSyncActor(AmmoBoxPart);
	LinkToSyncActor(AmmoBoxActor);

	return true;
}

function UpdateLink(Actor OldActor, Actor NewActor)
{
	local Actor OldSyncActor;

	OldSyncActor = GetSyncActor(OldActor);

	if (OldSyncActor == MGActor)
	{
		UnLinkFromSyncActor(MGActor);
		MGActor = GetSyncActor(NewActor);
		LinkToSyncActor(MGActor);
	}
	else if (OldSyncActor == AmmoBoxActor)
	{
		UnLinkFromSyncActor(AmmoBoxActor);
		AmmoBoxActor = GetSyncActor(NewActor);
		LinkToSyncActor(AmmoBoxActor);
	}
}

simulated event Actor GetCounterpart(Actor A)
{
	local Actor SyncA;

	SyncA = GetSyncActor(A);

	if (SyncA == MGActor)
	{
		return AmmoBoxActor;
	}
	else if (SyncA == AmmoBoxActor)
	{
		return MGActor;
	}

	return None;
}

simulated function Tick( float DeltaTime )
{
	local vector StartLoc, EndLoc, HitLocation, HitNormal;
	super.Tick(DeltaTime);

//	FlushPersistentDebugLines();

	if (MGActor == None && AmmoBoxActor == None)
	{
		UnlinkAllAndDestroy();
	}

	if (ChainMesh != None && MGActor != None && AmmoBoxActor != None)
	{
		if (RootSkelControl != None)
		{
 			GetCoopWeaponMesh(MGActor).GetSocketWorldLocationAndRotation('Chain_Attach_Gun', StartLoc);//RootSkelControl.BoneTranslation, RootSkelControl.BoneRotation);
		}
		else
		{
			RootSkelControl = SkelControlSingleBone(ChainMesh.FindSkelControl('RootLocation'));
		}

		if (EndSkelControl != None)
		{
			GetCoopWeaponMesh(AmmoBoxActor).GetSocketWorldLocationAndRotation('Chain_Attach_Box', EndLoc);//EndSkelControl.BoneTranslation, EndSkelControl.BoneRotation);
		}
		else
		{
			EndSkelControl = SkelControlSingleBone(ChainMesh.FindSkelControl('EndLocation'));
		}

		// first frame, you might not have valid info here
		RootSkelControl.BoneTranslation = StartLoc;
		RootSkelControl.BoneRotation = rotator(EndLoc-StartLoc);

//		DrawDebugCoordinateSystem(RootSkelControl.BoneTranslation, RootSkelControl.BoneRotation, 50, TRUE);

		EndSkelControl.BoneTranslation = EndLoc;
		EndSkelControl.BoneRotation = RootSkelControl.BoneRotation;

//		DrawDebugCoordinateSystem(EndSkelControl.BoneTranslation, EndSkelControl.BoneRotation, 50, TRUE);
  		if (MidSkelControl != None)
  		{
   			MidSkelControl.BoneTranslation = VLerp(EndSkelControl.BoneTranslation, RootSkelControl.BoneTranslation, 0.5f);
  			MidSkelControl.BoneRotation = RSmerp(EndSkelControl.BoneRotation, RootSkelControl.BoneRotation, 0.5f, TRUE);
 			// pick higher point of both ends
			MidSkelControl.BoneTranslation.Z = Max(RootSkelControl.BoneTranslation.Z, EndSkelControl.BoneTranslation.Z);

			// trace to ground and leave it there
			if (Trace(HitLocation, HitNormal, MidSkelControl.BoneTranslation-vect(0, 0, 100), MidSkelControl.BoneTranslation) != none)
			{
 				MidSkelControl.BoneTranslation = HitLocation;
				MidSkelControl.BoneTranslation.Z += 10;
			}
			else
			{
				// otherwise, just make U
				MidSkelControl.BoneTranslation.Z -=100;
			}

//			DrawDebugCoordinateSystem(MidSkelControl.BoneTranslation, MidSkelControl.BoneRotation, 50, TRUE);

 		}
 		else
 		{
 			MidSkelControl = SkelControlSingleBone(ChainMesh.FindSkelControl('MidLocation'));
 		}
	}
}

simulated function UnlinkAllAndDestroy()
{
	UnLinkFromSyncActor(MGActor);
	MGActor = None;

	UnLinkFromSyncActor(AmmoBoxActor);
	AmmoBoxActor = None;

	LifeSpan = 0.01f;
}

/**
 * Check if the counterpart to A is a dropped pickup
 *
 * @param A - one of the coop weapon actors
 *
 * @return TRUE if the counterpart is a GearDroppedPickup
 */
function bool HasDroppedPickupCounterpart(Actor A)
{
	local Actor CounterpartActor;

	CounterpartActor = GetCounterpart(A);
	if (GearDroppedPickup(CounterpartActor) != None)
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * Check if the counterpart to A is a weapon pickup factory
 *
 * @param A - one of the coop weapon actors
 *
 * @return TRUE if the counterpart is a GearWeaponPickupFactory
 */
function bool HasWeaponPickupFactoryCounterpart(Actor A)
{
	local Actor CounterpartActor;

	CounterpartActor = GetCounterpart(A);
	if (GearWeaponPickupFactory(CounterpartActor) != None)
	{
		return TRUE;
	}

	return FALSE;
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy

	bMovable=false
	bCanBeDamaged=false
	bReplicateMovement=false
	bAlwaysRelevant=true
}
