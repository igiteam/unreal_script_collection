/**
 * Box "Weapon"
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_BoxBase extends GearWeap_HeavyBase
	abstract;


//The ammo class this will become when dropped
var class<GearAmmoPickup_AmmoCase> DroppedPickupBackingClass;

var AIReactCond_EnemyVisibleForThresh DropCommand;

var SoundCue SeeEnemySound;

simulated function PlayFireEffects(byte FireModeNum, optional vector HitLocation)
{
}

simulated function PlayFireCameraEffects()
{
}

simulated state Active
{

	simulated function ForceReload()
	{
	}
	
	//Never allow firing :P
	simulated function BeginFire(byte FireModeNum)
	{
	}
};

/* Stuff to do when the weapon is first acquired */
function GivenTo(Pawn NewOwner, optional bool bDoNotActivate)
{
	local GearAI GAI;
	
	Super.GivenTo(NewOwner,bDoNotActivate);
	
	GAI = GearAI(NewOwner.Controller);
	if (GAI != none)
	{
		DropCommand = new(GAI) class'AIReactCond_EnemyVisibleForThresh';
		DropCommand.OutputFunction = DropBoxOnSeeingEnemy;
		DropCommand.bOneTimeOnly = true;
		DropCommand.Initialize();
	}
}

/* Function to call upon seeing an enemy */
function DropBoxOnSeeingEnemy(Actor EventInstigator, AIReactChannel OrigChannel)
{
	local GearPawn GP;
	GP = GearPawn(Instigator);

	// special move - send to play drop ammobox
	if (GP!=none && GP.SpecialMove != SM_AmmoBoxDrop)
	{
		GP.DoSpecialMove(SM_AmmoBoxDrop, TRUE);
	}
}

/**
 * Drop this item out in to the world
 *
 * @param	StartLocation 		- The World Location to drop this item from
 * @param	StartVelocity		- The initial velocity for the item when dropped
 */
function DropFrom(vector StartLocation, vector StartVelocity)
{
	local GearDroppedPickup_Ammo P;

	// Detach weapon components from instigator
	DetachWeapon();

	if( Instigator != None && Instigator.InvManager != None )
	{
		Instigator.InvManager.RemoveFromInventory(Self);
	}

	// if cannot spawn a pickup, then destroy and quit
	if( DroppedPickupBackingClass == None || DroppedPickupBackingClass.default.PickupMesh == None )
	{
		if (DropCommand != None)
		{
			DropCommand.UnsubscribeAll();
		}
		Destroy();
		return;
	}

	P = Spawn(class'GearDroppedPickup_Ammo',,, StartLocation);
	if( P != None )
	{
		P.BackingClass=DroppedPickupBackingClass;
		P.SetPickupMesh(DroppedPickupBackingClass.default.PickupMesh);
		
		// Static mesh pickups don't generally get rigid body physics, just force it on here to avoid the possible artifacts of PHYS_Falling
 		P.CollisionComponent.SetRBLinearVelocity(StartVelocity);
	}

	if (DropCommand != None)
	{
		DropCommand.UnsubscribeAll();
	}
	Destroy();
	return;
}

defaultproperties
{
	bIsSuppressive=FALSE
	bSniping=false
	bInstantHit=true
	bCanNegateMeatShield=false
	bIgnoresExecutionRules=false

	bWeaponCanBeReloaded=false
	bAutoSwitchWhenOutOfAmmo=FALSE

	// Weapon Mesh
	Begin Object Name=WeaponMesh
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh
	bKillDuringLevelTransition=TRUE


	LC_EmisDefaultCOG=(R=1.0,G=3.0,B=10.0,A=1.0)
	LC_EmisDefaultLocust=(R=16.0,G=0.8,B=0.2,A=1.0)

	AIRating=1000.0f

	WeaponID=WC_Box

	bUseHeavySkelControl = FALSE;
}

