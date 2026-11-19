/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * pickup that drops from the sky after certain events in Horde (bonus completion, etc)
 * contains one of several random rewards
 */
class GearHordeAirDrop extends GearDroppedPickup
	config(Game);

/** the list of potential pickup options */
var array< delegate<PickupHandler> > PickupTypes;

/** parameters for the various handlers */
var class<GearWeapon> MinigunClass;
var class<GearShield> ShieldClass;
var class<GearWeap_BoomshotBase> BoomshotClass;
var class<GearWeap_BowBase> TorqueBowClass;

/** sound played when we are opened/picked up */
var SoundCue PickupSound;

/** handles what happens when we are picked up */
delegate PickupHandler(Pawn User);

simulated event PostBeginPlay()
{
	local GearPC PC;

	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		PickupHandler = PickupTypes[Rand(PickupTypes.length)];
	}
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		if (PC.MyGearHud != None)
		{
			PC.MyGearHud.AddHUDLocator(class'GearHUDLocator_AirDrop', self);
		}
	}
}

function GiveTo(Pawn P)
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		PC.ClientPlaySound(PickupSound);
	}
	PickupHandler(P);
	Destroy();
}

simulated function name FindInteractionWith(Pawn P, bool bExcludeChecks)
{
	return 'PickUp';
}

final function SpawnDroppedPickup(class<Inventory> InvClass)
{
	local DroppedPickup NewPickup;

	NewPickup = Spawn(InvClass.default.DroppedPickupClass,,, Location);
	if (NewPickup != None)
	{
		NewPickup.InventoryClass = InvClass;
		if (ClassIsChildOf(InvClass, class'GearWeapon'))
		{
			NewPickup.Inventory = Spawn(InvClass);
			NewPickup.Inventory.GotoState('Inactive');
		}
		NewPickup.Velocity = VRand() * 200.0;
		NewPickup.Velocity.Z += 200.0;
		NewPickup.SetPickupMesh(InvClass.default.DroppedPickupMesh);
	}
}

/// PICKUP TYPES

/** award ammo to entire team */
function Pickup_TeamAmmo(Pawn User)
{
	local byte Team;
	local GearGame Game;
	local Controller C;
	local GearWeapon W;
	local int Amount;

	Team = User.GetTeamNum();
	Game = GearGame(WorldInfo.Game);
	if (Team < Game.Teams.length)
	{
		foreach Game.Teams[Team].TeamMembers(C)
		{
			if (C.Pawn != None)
			{
				foreach C.Pawn.InvManager.InventoryActors(class'GearWeapon', W)
				{
					if (!W.IsA('GearWeap_HeavyBase'))
					{
						Amount = W.AddAmmo(W.WeaponMaxSpareAmmo - W.SpareAmmoCount);
						W.AddAmmoMessage(Amount);
					}
				}
			}
		}
	}
}

/** spawn miniguns and boomshields */
function Pickup_MinigunAndShield(Pawn User)
{
	local int i;

	for (i = 0; i < 2; i++)
	{
		SpawnDroppedPickup(MinigunClass);
	}
	Instigator = User; // so shield touch allows collision with the player activating us
	for (i = 0; i < 2; i++)
	{
		SpawnDroppedPickup(ShieldClass);
	}
}

/** spawns boomshots for everyone */
function Pickup_Boomshots(Pawn User)
{
	local int i;

	for (i = 0; i < 5; i++)
	{
		SpawnDroppedPickup(BoomshotClass);
	}
}

/** spawn sniper rifle, torque bow, and ripper */
function Pickup_SnipersAndBows(Pawn User)
{
	SpawnDroppedPickup(class'GearWeap_SniperRifle');
	SpawnDroppedPickup(TorqueBowClass);
}

defaultproperties
{
	bBlockActors=false
	Physics=PHYS_Falling

	Begin Object Name=CollisionCylinder
		CollisionRadius=100.0
	End Object
	MyCylinderComp=CollisionCylinder

	PickupTypes[0]=Pickup_TeamAmmo
	PickupTypes[1]=Pickup_MinigunAndShield
	PickupTypes[2]=Pickup_Boomshots
	PickupTypes[3]=Pickup_SnipersAndBows
}
