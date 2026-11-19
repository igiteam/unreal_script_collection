/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearDroppedPickup_Ammo extends GearDroppedPickup;

//The class of the ammo pickup factory we are duplicating
var repnotify class<GearAmmoPickup_AmmoCase> BackingClass;

replication
{
	if (bNetDirty)
		BackingClass;
}



//Use name of backing class
simulated function String GetDisplayName()
{
	if (BackingClass != None)
	{
		return BackingClass.default.DisplayName;
	}
	return "";
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'BackingClass')
	{
		SetPickupMesh(BackingClass.default.PickupMesh);
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}

/** Init rigid body when setting a new mesh */
simulated function SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
	Super.SetPickupMesh(NewPickupMesh);
	SetPhysics(PHYS_RigidBody);
 	CollisionComponent.InitRBPhys();
	CollisionComponent.WakeRigidBody();
}

/**
 * Give pickup to player
 */
function GiveTo(Pawn P)
{
	local array<class<GearAmmoType> > AmmoTypes;
	local GearInventoryManager InvManager;

	InvManager = GearInventoryManager(P.InvManager);

	if ( BackingClass != None && InvManager != None &&
		BackingClass.static.FindPickupAmmoTypes(P, AmmoTypes,, false) )
	{
		BackingClass.static.GiveAmmoTo(P);
		SetHidden(TRUE);
		Destroy();
	}
}

/**
 * See if we can do something with this weapon pickup.
 * bExcludeChecks - TRUE = could you have?
 *                - FALSE = you actually can
 */
simulated function Name FindInteractionWith(Pawn P, bool bExcludeChecks)
{
	local GearPawn GP;

	GP = GearPawn(P);
	// Don't allow any pickup when carrying crate or when picking something up
	if (BackingClass == None || bHidden || GP == None || GP.IsDoingSpecialMove(SM_WeaponPickup) || !BackingClass.static.FindPickupAmmoTypes(P,,, bExcludeChecks))
	{
		return 'None';
	}
	else
	{
		return 'TakeAmmo';
	}
}

defaultproperties
{
	Begin Object NAME=CollisionCylinder
		BlockZeroExtent=FALSE
	End Object
}
