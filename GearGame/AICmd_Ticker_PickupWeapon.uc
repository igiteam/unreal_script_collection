/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Ticker_PickupWeapon extends AICommand_SpecialMove
	within GearAI_NakedTicker;


/** The dropped pickup the AI wants */
var GearDroppedPickup TargetPickup;
/** The pickup factory the AI wants */
var GearWeaponPickupFactory TargetFactory;
/** The grenade the AI wants */
var GearProj_Grenade TargetGrenade;

static function bool PickupWeaponFromPickup(GearAI_NakedTicker AI, GearDroppedPickup InPickup)
{
	local AICmd_Ticker_PickupWeapon Cmd;

	if( AI != None && InPickup != None && InPickup.InventoryClass != None )
	{
		Cmd = new(AI) default.Class;
		Cmd.TargetPickup = InPickup;
		AI.PushCommand(Cmd);
		return true;
	}
	else
	{
		return false;
	}
}

static function bool PickupWeaponFromFactory(GearAI_NakedTicker AI, GearWeaponPickupFactory InFactory)
{
	local AICmd_Ticker_PickupWeapon Cmd;

	if( AI != None && InFactory != None && InFactory.WeaponPickupClass != None )
	{
		Cmd = new(AI) default.Class;
		Cmd.TargetFactory = InFactory;
		AI.PushCommand(Cmd);
		return true;
	}
	else
	{
		return false;
	}
}

static function bool PickupLiveGrenade(GearAI_NakedTicker AI, GearProj_Grenade InGrenade)
{
	local AICmd_Ticker_PickupWeapon Cmd;

	if( AI != None && InGrenade != None )
	{
		Cmd = new(AI) default.Class;
		Cmd.TargetGrenade = InGrenade;
		AI.PushCommand(Cmd);
		return true;
	}
	else
	{
		return false;
	}
}

function Pushed()
{
	Super.Pushed();

	Outer.bSeekingPickup = true;

	bWantsLedgeCheck = true;
	MyGearPawn.GroundSpeed=MyGearPawn.DefaultGroundSpeed*1.15;
	GearPawn_LocustTickerBase(MyGearPawn).PlayChargeSound();
	ReactionManager.SuppressChannel('EnemyCloseEnoughToCharge');

	MoveToGrenade();
}

function Popped()
{
	Super.Popped();

	MyGearPawn.GroundSpeed = MyGearPawn.DefaultGroundSpeed;
	Outer.bSeekingPickup = false;
	bWantsLedgeCheck = false;

	// Allow normal rotation again
	if (Pawn!=none)
	{
		Pawn.LockDesiredRotation(FALSE);
	}
	ReactionManager.UnSuppressChannel('EnemyCloseEnoughToCharge');
}

function Resumed(name OldCommandName)
{
	Super.Resumed(OldCommandName);

	if( ChildStatus != 'Success' )
	{
		// we didn't get there so fail the command
		Status = 'Failure';
		PopCommand(self);
	}
}

function MoveToGrenade()
{
	local vector TickerToPickup;
	local float TickerToPickupSqDist;

	if( TargetGrenade != None && !Pawn.ReachedDestination(TargetGrenade) )
	{
		`AILog("Need to move to grenade first");
		TickerToPickup = TargetGrenade.Location - Pawn.Location;
		SetDesiredRotation(Rotator(TickerToPickup));
		TickerToPickupSqDist = VSizeSq2D(TickerToPickup);

		//MyGearPawn.FlushPersistentDebugLines();
		//MyGearPawn.DrawDebugSphere(MyGearPawn.Location, Outer.PickupLeapRangeMin, 16, 150, 0, 0, TRUE);
		//MyGearPawn.DrawDebugSphere(MyGearPawn.Location, Outer.PickupLeapRangeMid, 16, 200, 0, 0, TRUE);
		//MyGearPawn.DrawDebugSphere(MyGearPawn.Location, Outer.PickupLeapRangeMax, 16, 255, 0, 0, TRUE);

		// Check if we should leap to the grenade
		if( TargetGrenade.Physics != PHYS_None &&
			TickerToPickupSqDist > Outer.PickupLeapRangeMin*Outer.PickupLeapRangeMin &&
			TickerToPickupSqDist < Outer.PickupLeapRangeMax*Outer.PickupLeapRangeMax )
		{
			// Do leap craziness
			if( TickerToPickupSqDist < Outer.PickupLeapRangeMid*Outer.PickupLeapRangeMid )
			{
				SetTimer( 0.75, FALSE, nameof(DisableGrenade), self );
				class'AICmd_Ticker_LeapToPickup'.static.LeapToPickup(Outer, TargetGrenade, 1);
			}
			else
			{
				SetTimer( 0.75, FALSE, nameof(DisableGrenade), self );
				class'AICmd_Ticker_LeapToPickup'.static.LeapToPickup(Outer, TargetGrenade, 0);
			}
		}
		// Move closer to grenade before leaping
		else
		{
			SetMoveGoal(TargetGrenade, TargetGrenade, false, 150.f,,,true, false);
			SetDesiredRotation(Rotator(TickerToPickup));
		}
	}
	else if( TargetPickup != None && !Pawn.ReachedDestination(TargetPickup) )
	{
		`AILog("Need to move to drppped pickup first");
		TickerToPickup = TargetPickup.Location - Pawn.Location;
		SetDesiredRotation(Rotator(TickerToPickup));
		SetMoveGoal(TargetPickup, TargetPickup, false, 50.f,,,true);
	}
	else if( TargetFactory != None && !Pawn.ReachedDestination(TargetFactory) )
	{
		`AILog("Need to move to pickup factory first");
		TickerToPickup = TargetFactory.Location - Pawn.Location;
		SetDesiredRotation(Rotator(TickerToPickup));
		SetMoveGoal(TargetFactory, TargetFactory, false, 50.f,,,true);
	}
}

function DisableGrenade()
{
	if( TargetGrenade != None )
	{
		// Stop the explosion
		TargetGrenade.ClearTimer(nameof(TargetGrenade.ArmGrenade));
		TargetGrenade.ClearTimer(nameof(TargetGrenade.DoExplosion));
		TargetGrenade.ClearTimer(nameof(TargetGrenade.WarnProjExplode));
		TargetGrenade.ClearTimer(nameof(TargetGrenade.PlayBeepSound));
	}
}

auto state StartPickup `DEBUGSTATE
{
Begin:

	// Have to verify pickup's still valid since it might have exploded or been picked up 
	if( Pawn != None )
	{
		if( TargetGrenade != None && !TargetGrenade.bDeleteMe )
		{
			DisableGrenade();
			GearPawn(Pawn).PickupWeapon(TargetGrenade);
		}
		else if( TargetPickup != None && !TargetPickup.bDeleteMe && TargetPickup.CanBePickedUpBy(Pawn) )
		{
			GearPawn(Pawn).PickupWeapon(TargetPickup);
		}
		else if( TargetFactory != None && !TargetFactory.bDeleteMe && TargetFactory.CanBePickedUpBy(Pawn) && TargetFactory.ReadyToPickup(0.0) )
		{
			GearPawn(Pawn).PickupWeapon(TargetFactory);
		}
	}

	Status = 'Failure';
	PopCommand(self);
}
