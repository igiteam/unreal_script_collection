/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeaponPickupFactory_LockerBase extends GearWeaponPickupFactory
	abstract
	showcategories(Display,Collision)
	native;

cpptext
{
	/** override to do nothing */
	virtual void SetPickupMesh(UClass* NewInventoryType) {};

	/** override to not create pickupmesh */
	virtual void PostLoad();
};

/** Stop GearWeaponPickupFactory from modifying the collision cylinder */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// revert any changes to the cylinder component by GearWeaponPickupFactory
	CylinderComponent.SetCylinderSize(default.CylinderComponent.CollisionRadius, default.CylinderComponent.CollisionHeight);
	CylinderComponent.SetTranslation(default.CylinderComponent.Translation);

	// always give full ammo
	ExtraAmmoCount = 999999;
}

simulated protected function bool IsReadyForPickup()
{
	return !bHidden;
}

function SetRespawn()
{
	Reset();
}

state Disabled
{
	/**
	 * Hide the pickup mesh
	 *
	 * @param PreviousStateName - the name of the previous state
	 */
	simulated event BeginState(Name PreviousStateName)
	{
		SetPickupHidden();
	}

	/** Show the pickup mesh */
	function Reset()
	{
		SetPickupVisible();
		Global.Reset();
	}
}

/** Center the pickup mesh for now */
simulated function SetPickupMesh()
{
	// no "pickup mesh" for lockers!
	// has regular meshes though
}

function bool PickUpAmmoFromWeaponClass(Pawn P, class<GearWeapon> WeaponClass, optional int ExtraAmmo)
{
	// add full ammo
	return Super.PickUpAmmoFromWeaponClass(P, WeaponClass, 9999999);
}

/**	Handling Toggle event from Kismet. */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if( Action.InputLinks[0].bHasImpulse )
	{
		if( WeaponPickupClass != None && IsInState('Disabled') )
		{
			GotoState('Auto');
		}
	}
	// Turn OFF
	else if( Action.InputLinks[1].bHasImpulse )
	{
		if( !IsInState( 'Disabled' ) )
		{
			GotoState( 'Disabled' );
		}
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		if( WeaponPickupClass != None && IsInState('Disabled') )
		{
			GotoState('Auto');
		}
		else if( !IsInState( 'Disabled' ) )
		{
			GotoState( 'Disabled' );
		}
	}
}



defaultproperties
{
	bBlockActors=TRUE
	bCollideWorld=TRUE
	bWorldGeometry=TRUE
}
