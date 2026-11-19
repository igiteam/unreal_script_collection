/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Sentry_Explode extends AICommand_SpecialMove
	within GearAI_SecurityBotFlying;

function Pushed()
{
	Super.Pushed();
	MoveToTarget();
}

function Popped()
{
	super.Popped();
}
function Resumed( Name OldCommandName )
{
	// if we were resumed, cancel the 'splosion
	super.Resumed(OldCommandName);
	AbortCommand(self);
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand )
{
	return FALSE;
}

function bool ShouldIgnoreTimeTransitions()
{
	return TRUE;
}

function MoveToTarget()
{
	local GearPawn_SecurityBotFlyingBase BotPawn;
	local GearPawn Target, ClosestTarget;
	local float SqDist, ClosestTargetSqDist;
	local vector ToEnemy;

	BotPawn = GearPawn_SecurityBotFlyingBase(MyGearPawn);
	if( BotPawn != None )
	{
		foreach VisibleCollidingActors(class'GearPawn', Target, BotPawn.KamikazeCheckRadius)
		{
			SqDist = VSizeSq2D(Target.Location - MyGearPawn.Location);
			if( Target != MyGearPawn && ( ClosestTarget == None || SqDist < ClosestTargetSqDist ) )
			{
				ClosestTargetSqDist = SqDist;
				ClosestTarget = Target;
			}
		}

		if( ClosestTarget != None )
		{
			ToEnemy = ClosestTarget.Location - MyGearPawn.Location;
			ToEnemy.Z = 0.f;
		}

		BotPawn.FallAccel = BotPawn.KamikazeAirAccel * Normal(ToEnemy);
		BotPawn.AirSpeed = BotPawn.KamikazeMaxSpeed;
	}
}

auto state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_DeathAnim;
	}
}


defaultproperties
{
	bIgnoreNotifies=true
}
