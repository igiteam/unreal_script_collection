/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearVehicleBase extends SVehicle
	abstract
	native(Vehicle);

cpptext
{
	virtual UBOOL ReachedDesiredRotation();
}


/** Ref to AI controller */
var GearAI MyGearAI;

var bool bKickDriverOnTeleport;

simulated function PostBeginPlay()
{
	local GearPC PC;

	Super.PostBeginPlay();

	ForEach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.bCheckVehicles = TRUE;
	}
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C,bVehicleTransition);

	MyGearAI = GearAI(Controller);
}

simulated function Tick(float DeltaTime)
{
`if(`notdefined(FINAL_RELEASE))
	local PlayerController PC;
`endif

	Super.Tick(DeltaTime);

	if (AIController(Controller) != None && Weapon != None)
	{
		if (Controller.bFire != 0)
		{
			if (!Weapon.IsFiring())
			{
				Weapon.StartFire(0);
			}
		}
		else if (Weapon.IsFiring())
		{
			Weapon.StopFire(0);
		}
	}

`if(`notdefined(FINAL_RELEASE))
	if (class'GearGRI'.default.bDebugShowDamage)
	{
		// Doing this with non-local PlayerControllers seems to hose initial replication in our debug configuration
		foreach WorldInfo.LocalPlayerControllers(class'PlayerController',PC)
		{
			PC.AddDebugText(string(Health), self, 1.0, vect(0,0,64), vect(0,0,32), class'HUD'.default.WhiteColor, false);
		}
	}
`endif
}

/**
request change to adjacent vehicle seat
*/
reliable server function ServerAdjacentSeat(int Direction, Controller C);

/** Called when a client presses X while in the vehicle. */
reliable server function ServerPressedX();

/** server only */
function PassengerBecomeDriver(Controller C);

/** server only */
function PassengerSentTwoFloats(float A, float B);

/**
 * When this pawn suicides (via the controller) it needs to kill the driver
 */
function Suicide()
{
	// in Siege we don't want exiting players to leave Pawns around, vehicle or not
	if (GearGameSiege_Base(WorldInfo.Game) != None && IsHumanControlled())
	{
		KilledBy(self);
	}
	else if (Driver != None)
	{
		HandleDeadVehicleDriver();
	}
	else
	{
		KilledBy(self);
	}
}

/**
* @Returns the scale factor to apply to damage affecting this vehicle
*/
function float GetDamageScaling()
{
	if (Driver != None)
	{
		return (Driver.GetDamageScaling() * Super.GetDamageScaling());
	}
	else
	{
		return Super.GetDamageScaling();
	}
}

/**
* @Returns true if the AI needs to turn towards a target
*/
function bool NeedToTurn(vector Targ)
{
	local GearVehicleWeapon VWeapon;

	// vehicles can have weapons that rotate independently of the vehicle, so check with the weapon instead
	VWeapon = GearVehicleWeapon(Weapon);
	if (VWeapon != None)
	{
		return !VWeapon.IsAimCorrect();
	}
	else
	{
		return Super.NeedToTurn(Targ);
	}
}

simulated function DrivingStatusChanged()
{
	Super.DrivingStatusChanged();

	if (!bDriving)
	{
		StopFiringWeapon();
	}
}

function bool DriverEnter(Pawn P)
{
	local AIController C;

	if (Super.DriverEnter(P))
	{
		// update AI enemy
		foreach WorldInfo.AllControllers(class'AIController', C)
		{
			if (C.Enemy == P)
			{
				C.Enemy = self;
			}
		}

		return true;
	}
	else
	{
		return false;
	}
}

/**
* Called on both the server an owning client when the player leaves the vehicle.  We want to make sure
* any active weapon is shut down
*/
function DriverLeft()
{
	local AIController C;

	// update AI enemy
	foreach WorldInfo.AllControllers(class'AIController', C)
	{
		if (C.Enemy == self)
		{
			C.Enemy = Driver;
		}
	}

	Super.DriverLeft();
}

/**
* Shut down the weapon
*/
simulated function StopFiringWeapon()
{
	if (Weapon != none)
	{
		Weapon.ForceEndFire();
	}
}

/** handles the driver pawn of the dead vehicle (decide whether to ragdoll it, etc) */
function HandleDeadVehicleDriver()
{
	local Pawn OldDriver;
	local GearVehicle VehicleBase;

	if (Driver != None)
	{
		VehicleBase = GearVehicle(self);
		if ( VehicleBase == None )
			VehicleBase = GearVehicle(GetVehicleBase());

		// if Driver wasn't visible in vehicle, destroy it
		if (VehicleBase != None && VehicleBase.bEjectKilledBodies && (WorldInfo.TimeSeconds - LastRenderTime < 1.0) && (bDriverIsVisible || ((WorldInfo.GetDetailMode() != DM_Low) && !WorldInfo.bDropDetail)) )
		{
			// otherwise spawn dead physics body
			if (!bDriverIsVisible && PlaceExitingDriver())
			{
				Driver.StopDriving(self);
				Driver.DrivenVehicle = self;
			}
			Driver.TearOffMomentum = Velocity * 0.25;
			Driver.SetOwner(None);
			Driver.Died(None, (VehicleBase != None) ? VehicleBase.RanOverDamageType : class'DamageType', Driver.Location);
		}
		else
		{
			OldDriver = Driver;
			Driver = None;
			OldDriver.DrivenVehicle = None;
			OldDriver.Destroy();
		}
	}
}

/**
 * Called when the controller stops controlling this pawn.  At this point, we want to force all Weapons to
 * stop firing
 */

function UnPossessed()
{
	super.UnPossessed();

	if (Weapon!=none)
	{
		Weapon.StopFire(0);
		Weapon.StopFire(1);
	}
}

/** GearVehicles still use the separate camera system */
simulated function bool CalcCamera(float DeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
	return false;
}

simulated function bool AllowTargetting()
{
	return true;
}

simulated function name GetRiderState(Pawn P)
{
	return P.LandMovementState;
}

/** Forces a pawn out of the vehicle */
function KickPawn(GearPawn GP)
{
	if (Driver == GP)
	{
		DriverLeave(true);
	}
}

/** Kismet hook for kicking a pawn out of a vehicle */
simulated function OnGearExitVehicle( SeqAct_GearExitVehicle inAction )
{
	local GearPawn GP;
	
	// reset default command
	if( MyGearAI != None )
	{
		MyGearAI.DefaultCommand = MyGearAI.Default.DefaultCommand;
	}

	GP = GearPawn(Driver);
	if (GP != None)
	{
		KickPawn(GP);
	}
}

/** Attach any components that should only happen locally on the client */
simulated function AttachLocalComponents(GearPC PC);

/** Detach any components that should only happen locally on the client */
simulated function DetachLocalComponents(GearPC PC);

defaultproperties
{
}
