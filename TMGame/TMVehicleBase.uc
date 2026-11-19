/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */

class TMVehicleBase extends SVehicle
	abstract
	native
	notplaceable;

/** if true the driver will be ejected if he leaves*/
var bool bShouldEject;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/**
  * Attach GameObject to mesh.
  * @param 	GameObj 	Game object to hold
  */
simulated event HoldGameObject(TMCarriedObject GameObj);

/**
  *  Use the SwitchWeapon binding (number keys bound on keyboard by default)
  *  to switch seats when in a multi-seat vehicle.
  */
simulated function SwitchWeapon(byte NewGroup)
{
	ServerChangeSeat(NewGroup-1);
}

/**
  * Request change to adjacent vehicle seat
  */
simulated function AdjacentSeat(int Direction, Controller C)
{
	ServerAdjacentSeat(Direction, C);
}

/**
request change to adjacent vehicle seat
*/
reliable server function ServerAdjacentSeat(int Direction, Controller C);

/**
 * Called when a client is requesting a seat change
 *
 * @network	Server-Side
 */
reliable server function ServerChangeSeat(int RequestedSeat);

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
//	local TMWeapon VWeapon;

	// vehicles can have weapons that rotate independently of the vehicle, so check with the weapon instead
//	VWeapon = TMWeapon(Weapon);
//	if (VWeapon != None)
//	{
//		return !VWeapon.IsAimCorrect();
//	}
//	else
//	{
//		return Super.NeedToTurn(Targ);
//	}
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

/** Stub:  applies weapon effects based on the passed in bitfield */
simulated function ApplyWeaponEffects(int OverlayFlags, optional int SeatIndex);

/**
 *   Statistics gathering
 */
function name GetVehicleDrivingStatName()
{
	local name VehicleStatName;

	VehicleStatName = name('DRIVING_'$Class.name);
	return VehicleStatName;
}

/**
EjectDriver() throws the driver out at high velocity
*/
function EjectDriver()
{
	local float Speed;
	local rotator ExitRotation;

	if ( Driver == None )
	{
		return;
	}
	if ( PlayerController(Driver.Controller) != None )
	{
		ExitRotation = Rotation; //rotator(Velocity); <-- this resulted in weirdness if ejecting from a stop.
		ExitRotation.Pitch = -8192;
		ExitRotation.Roll = 0.0;
		Driver.Controller.SetRotation(ExitRotation);
		Driver.Controller.ClientSetRotation(ExitRotation);
	}
	Speed = VSize(Velocity);
	if (Speed < 2600 && Speed > 0)
	{
		Driver.Velocity = -0.6 * (2600 - Speed) * Velocity/Speed;
		Driver.Velocity.Z = 600;
	}
	else
	{
		Driver.Velocity = vect(0,0,600);
	}

	if ( TMPawn(Driver) != None )
	{
		TMPawn(Driver).CustomGravityScaling = 0.5;
		TMPawn(Driver).bNotifyStopFalling = true;
		TMPawn(Driver).MultiJumpRemaining = 0;
	}
}

simulated function DetachDriver(Pawn P)
{
	local TMPawn TMP;

	Super.DetachDriver(P);

	TMP = TMPawn(P);
	if (TMP != None)
	{
		// Turn on cloth again
		TMP.Mesh.UpdateRBBonesFromSpaceBases(TRUE,TRUE);
		if (TMP.Mesh.PhysicsAssetInstance != None)
		{
			TMP.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(TRUE);
			TMP.Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, TMP.Mesh);
		}
		TMP.Mesh.bUpdateKinematicBonesFromAnimation = TMP.default.Mesh.bUpdateKinematicBonesFromAnimation;

		TMP.SetWeaponAttachmentVisibility(true);
		TMP.SetHandIKEnabled(true);
	}
}

/**
 * AI - Returns the best firing mode for this weapon
 */
function byte ChooseFireMode()
{
	if (TMWeapon(Weapon) != None)
	{
		return TMWeapon(Weapon).BestMode();
	}
	return 0;
}

/**
 * AI - An AI controller wants to fire
 *
 * @Param 	bFinished	unused
 */

function bool BotFire(bool bFinished)
{
	local TMBot Bot;

	Bot = TMBot(Controller);
	if (Bot != None && Bot.ScriptedFireMode != 255)
	{
		StartFire(Bot.ScriptedFireMode);
	}
	else
	{
		StartFire(ChooseFireMode());
	}
	return true;
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

/**
 * Called on both the server and owning client when the player leaves the vehicle.  We want to make sure
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
	if (bShouldEject)
	{
		EjectDriver();
		bShouldEject = false; // so next driver doesn't get ejected.
	}

	Super.DriverLeft();
}

/** handles the driver pawn of the dead vehicle (decide whether to ragdoll it, etc) */
function HandleDeadVehicleDriver()
{
	local Pawn OldDriver;
	local TMVehicle VehicleBase;

	if (Driver != None)
	{
		VehicleBase = TMVehicle(self);
		if ( VehicleBase == None )
			VehicleBase = TMVehicle(GetVehicleBase());

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
			Driver.Died(None, VehicleBase.GetRanOverDamageType(), Driver.Location);
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

