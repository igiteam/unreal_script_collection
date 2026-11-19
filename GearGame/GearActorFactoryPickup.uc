/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearActorFactoryPickup extends ActorFactory;

var() class<Inventory> InventoryClass;

simulated event PostCreateActor(Actor NewActor)
{
	local DroppedPickup Pickup;
	local Inventory NewInventory;

	// spawn the inventory actor
	Pickup = DroppedPickup(NewActor);

	if (Pickup != None)
	{
		NewInventory = NewActor.Spawn(InventoryClass);
	}
	if (NewInventory != None)
	{
		Pickup.Inventory = NewInventory;
		Pickup.InventoryClass = InventoryClass;
		Pickup.SetPickupMesh(Pickup.Inventory.DroppedPickupMesh);
	}
	else
	{
		NewActor.Destroy();
	}
}

defaultproperties
{
	NewActorClass=class'GearDroppedPickup'
	bPlaceable=false
}
