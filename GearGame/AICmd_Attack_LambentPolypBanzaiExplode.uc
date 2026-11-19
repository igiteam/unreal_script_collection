/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_LambentPolypBanzaiExplode extends AICommand
	within GearAI_LambentPolyp;

/** Reference to our polyp pawn */
var transient GearPawn_LambentPolypBase Polyp;
/** Target to charge and explode near */
var Actor ExplodeTarget;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool BanzaiExplode( GearAI_LambentPolyp AI, optional Actor InTarget )
{
	local AICmd_Attack_LambentPolypBanzaiExplode Cmd;

	if( AI != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			if(InTarget != none)
			{
				Cmd.ExplodeTarget = InTarget;
			}
			else
			{
				Cmd.ExplodeTarget = AI.Enemy;
			}
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	Polyp = GearPawn_LambentPolypBase(MyGearPawn);

	bWantsLedgeCheck = true;

	ReactionManager.SuppressAll();

	// Move to the target first
	if( VSizeSq( MyGearPawn.Location - ExplodeTarget.Location ) < (Polyp.DeathExplosionDamageRadius * Polyp.DeathExplosionDamageRadius * 0.25) )
	{	
		GotoState('WaitForDeath');
	}
	else if( ExplodeTarget == Enemy )
	{
		SetEnemyMoveGoal(true, Polyp.DeathExplosionDamageRadius * 0.5,, false);
	}
	else
	{
		SetMovePoint(ExplodeTarget.Location, ExplodeTarget, false, Polyp.DeathExplosionDamageRadius, false, false, true, true);
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// If we reached the target successfully
	if( ChildStatus != 'Failure' && ExplodeTarget != None )
	{	
		if( VSizeSq( MyGearPawn.Location - ExplodeTarget.Location ) < 
			(Polyp.DeathExplosionDamageRadius+MyGearPawn.CylinderComponent.CollisionRadius)*(Polyp.DeathExplosionDamageRadius+MyGearPawn.CylinderComponent.CollisionRadius)*0.25 )
		{
			GotoState('WaitForDeath');
		}
		else if( ExplodeTarget == Enemy )
		{
			SetEnemyMoveGoal(true, Polyp.DeathExplosionDamageRadius * 0.5,, false);
		}
		else
		{
			SetMoveGoal(ExplodeTarget, ExplodeTarget, false,,,,,false);
		}
	}
	else
	{
		// Otherwise, didn't get there so fail the command
		Status = 'Failure';
		GotoState('WaitForDeath');
	}
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand )
{
	return FALSE;
}
function bool ShouldIgnoreTimeTransitions()
{
	return TRUE;
}

state WaitForDeath
{
Begin:
	Sleep(0.1f);
	Pawn.Died(Outer, class'GDT_LambentExplosion', Pawn.Location);
}

defaultproperties
{
	bAllowedToFireWeapon=false
}