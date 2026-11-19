/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Sentry_Charge extends AICommand
	within GearAI_SecurityBotFlying;

/** Location the Sentry should charge to */
var vector MoveLocation;
/** Air speed before the charge command started */
var float SavedAirSpeed;

static function Charge(GearAI_SecurityBotFlying AI, optional vector NewMoveLocation)
{
	local AICmd_Attack_Sentry_Charge Cmd;
	if (AI != None)
	{
		Cmd = new(AI) class'AICmd_Attack_Sentry_Charge';
		if (Cmd != None)
		{
			Cmd.MoveLocation = NewMoveLocation;
			AI.PushCommand(Cmd);
		}
	}
	//DrawDebugLine(AI.MyGearPawn.Location, NewMoveLocation, 255, 0, 0, true);
}

function Pushed()
{
	Super.Pushed();
	SavedAirSpeed = Pawn.AirSpeed;
	Pawn.AirSpeed = 500;
	GotoState('DoCharge');
}

function Popped()
{
	Super.Popped();
	Pawn.AirSpeed = SavedAirSpeed;
}


state DoCharge
{
	simulated function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
	}

Begin:
	GearPawn_SecurityBotFlyingBase(MyGearPawn).OnCharge();
	SetMovePoint(MoveLocation,Enemy,,64.f,,false, true);

	if(ChildStatus == 'Failure')
	{
		AbortCommand(self);
	}
	else
	{
		CheckInterruptCombatTransitions();
		PopCommand(self);
	}
}


defaultproperties
{
}