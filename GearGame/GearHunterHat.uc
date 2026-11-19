/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHunterHat extends DroppedPickup
	abstract;

var StaticMeshComponent HatComponent;

simulated event PostBeginPlay()
{
	local GearPC PC;
	local GearHUDHunter HUD;

	Super.PostBeginPlay();

	// tell the HUD for all local players to add a locator for us
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		HUD = GearHUDHunter(PC.myHUD);
		if (HUD != None)
		{
			HUD.AddHUDLocator(class'GearHUDLocator_HunterHat', self);
		}
	}
}

function GiveTo(Pawn P)
{
	GearHunterPRI(P.PlayerReplicationInfo).NumHats++;
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		GearHunterPRI(P.PlayerReplicationInfo).UpdateHatAttachments();
	}
	GearGameHunter(WorldInfo.Game).NotifyHatPickup(P);

	Super.GiveTo(P);
}

// ignore encroachment
event EncroachedBy(Actor Other);

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
	local GearHunterPRI PRI, BestPRI;
	local int i;

	if (Role == ROLE_Authority)
	{
		// "return" the hat to a player with the lowest number of them
		for (i = 0; i < WorldInfo.GRI.PRIArray.length; i++)
		{
			PRI = GearHunterPRI(WorldInfo.GRI.PRIArray[i]);
			// prioritize lowest number of hats; if there's a tie, prefer the player that's dead
			if ( PRI != None &&
				(BestPRI == None || PRI.NumHats < BestPRI.NumHats || (PRI.NumHats == BestPRI.NumHats && Controller(PRI.Owner).IsDead())) )
			{
				BestPRI = PRI;
			}
		}

		if (BestPRI != None)
		{
			BestPRI.NumHats++;
			if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				BestPRI.UpdateHatAttachments();
			}
		}
		else
		{
			// failsafe - completely remove the hat from play
			GearGameHunter(WorldInfo.Game).TotalHatsInPlay--;
		}
		Destroy();
	}
	else
	{
		SetPhysics(PHYS_None);
	}
}
simulated event OutsideWorldBounds()
{
	FellOutOfWorld(class'DamageType');
}

auto state Pickup
{
	function bool ValidTouch(Pawn Other)
	{
		// make sure its a live player that can pick up hats
		if (Other == None || !Other.bCanPickupInventory || (Other.DrivenVehicle == None && Other.Controller == None) ||
			GearHunterPRI(Other.PlayerReplicationInfo) == None )
		{
			return false;
		}
		// make sure thrower doesn't run over own hat
		else if (Physics == PHYS_Falling && Other == Instigator && Velocity.Z > 0.0)
		{
			return false;
		}
		// make sure game will let player pick me up
		else
		{
			return WorldInfo.Game.PickupQuery(Other, Inventory.class, self);
		}
	}

	event BeginState(name PreviousStateName)
	{
		AddToNavigation();
	}
}

defaultproperties
{
	LifeSpan=0.0
	Physics=PHYS_Falling
	bAlwaysRelevant=true
}
