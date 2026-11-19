
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustBloodmount extends GearPawn_LocustBloodmountBase
	config(Pawn)
	abstract;

var AIAvoidanceCylinder AvoidanceCylinder;

simulated protected function GearPawn SpawnAndSetupDriver()
{
	local GearAI DriverController;
	local GearPawn NewDriver;
	local GearWeapon DriverWeapon;

	// Spawn Driver
	if( DriverClass != none )
	{
		NewDriver = Spawn(DriverClass,,,,,, TRUE); // ignore encroach on spawn
		if( NewDriver != None )
		{
			DriverController = GearAI(Spawn(NewDriver.ControllerClass));
			DriverController.SetTeam(1);
			DriverController.SetSquadName('Alpha');
			DriverController.Possess(NewDriver, false);

			SetDriver(NewDriver);
			// default driver is a separate entity, so revert Owner change
			NewDriver.SetOwner(DriverController);

			Driver.NetPriority -= 0.1; // try to get us replicated first to minimize ordering issues

			Driver.AddDefaultInventory();
			Driver.PeripheralVision = -0.4f;
			if (HeadScale != default.HeadScale)
			{
				Driver.SetHeadScale(HeadScale);
			}

			// we don't have reload anims for the driver so give it infinite clip size to avoid it looking dumb
			foreach Driver.InvManager.InventoryActors(class'GearWeapon', DriverWeapon)
			{
				DriverWeapon.WeaponMagSize = 0;
			}

			SetTimer(0.1f,, nameof(PushDriverCommand));
		}
	}

	return NewDriver;
}

simulated function PostBeginPlay()
{
	SetupAvoidanceCylinder();

	Super.PostBeginPlay();

	if( Role == ROLE_Authority )
	{
		SpawnAndSetupDriver();
	}
}

// no one can ride us besides the driver we spawned initially
function bool TryToDrive(Pawn P)
{
	return false;
}
simulated function bool CanEnterRidablePawn(GearPawn P, optional bool bIgnoreRange)
{
	return false;
}
event bool DriverLeave(bool bForceLeave)
{
	return (bForceLeave && Super.DriverLeave(bForceLeave));
}

event Detach(Actor Detachee)
{
	Super.Detach(Detachee);

	if (Detachee == Driver)
	{
		GearAI_Bloodmount(MyGearAI).NotifyDriverDetached();
	}
}

simulated function StartMeleeAttack()
{
	if (CanDoSpecialMove(GSM_BloodMount_Melee))
	{
		if (IsHumanControlled())
		{
			GearPC(Controller).DoSpecialMove(GSM_BloodMount_Melee);
		}
		else
		{
			DoSpecialMove(GSM_BloodMount_Melee);
		}
	}
}

simulated function Destroyed()
{
	Super.Destroyed();

	if(AvoidanceCylinder != none)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = none;
	}
}

/** Overridden to throw driver off. */
function bool Died(Controller Killer, class<DamageType> GearDamageType, vector HitLocation)
{
	local bool bResult;

	bResult = Super.Died( Killer, GearDamageType, HitLocation );

	if(AvoidanceCylinder != none)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = none;
	}
	return bResult;
}

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

function SetupAvoidanceCylinder()
{
// 	local float AvoidRadius;
//
// 	if( !bDeleteMe && AvoidanceCylinder == None )
// 	{
// 		AvoidRadius = GetCollisionRadius() * 2f;
// 		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
//
// 		if(AvoidanceCylinder!=none)
// 		{
//
// 			AvoidanceCylinder.SetBase(self);
// 			AvoidanceCylinder.SetRelativeLocation(vect(75.f,0.f,0.f));
// 			AvoidanceCylinder.SetCylinderSize(AvoidRadius,AvoidRadius*2.0f);
// 			AvoidanceCylinder.SetAvoidanceTeam(TEAM_COG);
// 			AvoidanceCylinder.SetEnabled(true);
// 		}
// 		//DrawDebugSphere(Location,AvoidRadius,16,255,0,0,TRUE);
// 	}
//
}

function PushDriverCommand()
{
	local GearAI GAI;

	GAI = GearAI(Driver.Controller);
	// abort current combat command if there is one
	GAI.AbortCommand(None, GAI.DefaultCommand);
	// switch to mounted gunner
	class'AICmd_Base_MountedGunner'.static.InitCommand(GearAI(Driver.Controller));
}

simulated function bool ShouldPreventTargeting()
{
	return !IsHumanControlled();
}

function AdjustDriverDamage(out int Damage, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	// when human controlled with AI gunner, said gunner is invulnerable as long as we are alive
	if (IsHumanControlled() && Driver != None && Driver.Controller != None)
	{
		Damage = 0;
	}
	else
	{
		Super.AdjustDriverDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	}
}

defaultproperties
{
	BaseEyeHeight=140

	MPHeadRadius=30
	MPHeadOffset=(X=22,Y=2,Z=0)
}
