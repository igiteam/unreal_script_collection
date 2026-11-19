/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class SeqAct_GearCrowdSpawner extends SeqAct_GameCrowdSpawner
	native(Sequence);

/** Weapon to use for firing effects */
var transient GearWeapon SpawnedWeapon;

/** Called when agent is spawned - sets agent output and triggers spawned event */
native function SpawnedAgent(GameCrowdAgent NewAgent);

event InitWeapon(GameCrowdAgent Agent)
{
	local GearCrowdAgent GearAgent;

	GearAgent = GearCrowdAgent(Agent);

	if( GearAgent != None && GearAgent.WeaponClass != None && SpawnedWeapon == None )
	{
		SpawnedWeapon = GearAgent.Spawn(GearAgent.WeaponClass);

		if( SpawnedWeapon != None )
		{
			if( SpawnedWeapon.Mesh != None )
			{
				SpawnedWeapon.AttachComponent(SpawnedWeapon.Mesh);
				SpawnedWeapon.Mesh.SetHidden(true);
			}
			SpawnedWeapon.RemoteRole = ROLE_None;
			SpawnedWeapon.bSuppressMuzzleFlash = FALSE;
			SpawnedWeapon.bSuppressTracers = FALSE;
			SpawnedWeapon.bSuppressImpactFX = FALSE;
			SpawnedWeapon.bSuppressAudio = FALSE;
			SpawnedWeapon.bSuppressDamage = TRUE;

			// Give the Agent a refernece to the weapon to use
			GearAgent.SpawnedWeapon = SpawnedWeapon;
		}
	}
	else if( SpawnedWeapon != None )
	{
		// Give the Agent a refernece to the weapon to use
		GearAgent.SpawnedWeapon = SpawnedWeapon;
	}
}

defaultproperties
{
	ObjName="Gear Crowd Spawner"
	ObjCategory="Crowd"
	
	bForceNavMeshPathing=true
}