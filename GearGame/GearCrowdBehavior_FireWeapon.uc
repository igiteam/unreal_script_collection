/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCrowdBehavior_FireWeapon extends GameCrowdBehavior_PlayAnimation
	native
	placeable
	dependsOn(GearCrowdAgent);

/** Offset to fire weapon from. */
var() vector FireOffset;
/** Error when firing - in degrees */
var() float AimError;
/** Delay between each firing of the weapon */
var() float MinWeaponFireDelay;
var() float MaxWeaponFireDelay;
/** Number of shots to fire */
var() int ShotsToFire;

/** Time of last DummyFire() call */
var transient float LastWeaponFireTime;
/** Current weapon fire delay to use */
var transient float WeaponFireDelay;
	
/**
*  Agent's current behavior gets ticked
*/
native function Tick(float DeltaTime);

/**
* Called when Agent activates this behavior
*/
function InitBehavior(GameCrowdAgent Agent)
{
	Super.InitBehavior(Agent);
	WeaponFireDelay = 0.2f;
	LastWeaponFireTime = Agent.WorldInfo.TimeSeconds;
}

/**
* Play the requested animation
*/
event DoWeaponFire()
{
	local GearCrowdAgent GearAgent;
	local Vector FirePos;
	local Rotator FireRot;

	GearAgent = GearCrowdAgent(MyAgent);
	if( GearAgent != None && GearAgent.SpawnedWeapon != None )
	{
		FirePos = GearAgent.Location + (FireOffset >> GearAgent.Rotation);
		FireRot = Rotator(ActionTarget.Location - FirePos);
		GearAgent.SpawnedWeapon.SetRotation(FireRot);
		GearAgent.SpawnedWeapon.SetLocation(FirePos);
		GearAgent.SpawnedWeapon.DummyFire(0, ActionTarget.Location, GearAgent, AimError, ActionTarget);
	}
}

function StopBehavior()
{
	local GearCrowdAgent GearAgent;

	Super.StopBehavior();

	GearAgent = GearCrowdAgent(MyAgent);
	if( GearAgent != None && GearAgent.SpawnedWeapon != None  )
	{
		GearAgent.SpawnedWeapon.WeaponStoppedFiring(0);
	}
}

function string GetBehaviorString()
{
	return "Fire Weapon at "@ActionTarget;
}

defaultproperties
{
	bIsPanicked=true
	bFaceActionTargetFirst=true
	MaxPlayerDistance=20000.0
	FireOffset=(X=30.0,Z=70.0)
	MinWeaponFireDelay=0.5f
	MaxWeaponFireDelay=1.0f
	ShotsToFire=-1
}
