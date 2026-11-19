/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_BabyCorpser extends AICommand
	within GearAI;


// CIRCLE VARIABLES
/** Circling left (-1) or right (+1) */
var int CircleDir;
/** Min/Max distance of the arc for circling the enemy */
var Vector2D CircleDistance;
/** Point we are moving to for this circle step */
var transient Vector CirclePoint;

function Pushed()
{
	Super.Pushed();

	// Do melee attack immediately
	GotoState('ChooseAction');
}

state ChooseAction
{
	function Name PickAttackType()
	{
		local float Dist;
`if(`notdefined(FINAL_RELEASE))
		local float Radius;
`endif

		if (IsPawnVisibleViaTrace(Enemy))
		{
			Dist = VSize(Pawn.Location - Enemy.Location);

`if(`notdefined(FINAL_RELEASE))
			Radius = (Pawn.GetCollisionRadius() + Enemy.GetCollisionRadius()) * 1.3f;
			//debug
			`AILog(GetFuncName() @ Dist @ Radius);
`endif

			if (Dist <= EnemyDistance_Melee)
			{
				return 'Melee';
			}
		}

		// Close distance on enemy
		return 'RunToEnemy';
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@GetStateName(), 'State' );

	// Chose which action to take
	Goto(PickAttackType());

// Close the gap
RunToEnemy:
	//debug
	`AILog("RUNTOENEMY TAG"@GetStateName(), 'State');

	SetEnemyMoveGoal(false, EnemyDistance_Melee - 50.0f);
	Goto('Finished');

// Ground swipe attack
Melee:
	//debug
	`AILog("SWIPE TAG"@GetStateName(), 'State');

	class'AICmd_Attack_Melee_BabyCorpser'.static.InitCommand( AIOwner );
	if (FRand() < 0.25f)
	{
		Goto('Circle');
	}
	else
	{
		Goto( 'Finished' );
	}

// Circle around the enemy
Circle:
	//debug
	`AILog("CIRCLE TAG"@GetStateName(), 'State');

	CircleDir = (FRand() < 0.5f) ? -1 : 1;
	PushState('Circle');
	if (FRand() < 0.25f)
	{
		Goto('Circle');
	}
	else
	{
		Goto('Finished');
	}

Finished:
	`AILog("FINISHED TAG"@GetStateName(), 'State');

	// Prevent infinite recursion and pop stack
	Status = 'Success';
	PopCommand(self);
}

function CircleTimer();

/** Abstract state */
state Circle `DEBUGSTATE
{
	function PushedState()
	{
		super.PushedState();

		bWantsLedgeCheck = TRUE;
	}

	function PoppedState()
	{
		super.PoppedState();

		bWantsLedgeCheck = FALSE;
		if( Pawn != None )
		{
			Pawn.ZeroMovementVariables();
		}
	}

	function bool GetCirclePoint()
	{
		local bool bResult;
		local Vector EnemyToPawn;
		local float Dist;

		EnemyToPawn = Pawn.Location - Enemy.Location;
		Dist = VSize(EnemyToPawn);
		if( Dist < CircleDistance.X )
		{
			EnemyToPawn *= (CircleDistance.X / Dist);
		}
		if( Dist > CircleDistance.Y )
		{
			EnemyToPawn *= (CircleDistance.Y / Dist);
		}

		CirclePoint = Enemy.Location + (EnemyToPawn >> (rot(0,8192,0) * CircleDir));

		bResult = PointReachable( CirclePoint );

		//debug
		`AILog( GetFuncName()@CirclePoint@Dist@bResult, 'Combat' );

		return bResult;
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@GetStateName(), 'State' );

	SetTimer( 0.5f + (FRand() * 0.5f), FALSE, nameof(self.CircleTimer), self );
	while( IsTimerActive( 'CircleTimer', self ) )
	{
		if( GetCirclePoint() )
		{
			MoveToDirectNonPathPos( CirclePoint, Enemy,, FALSE );
		}
		else
		{
			break;
		}
	}

	PopState();
}

defaultproperties
{
	CircleDistance=(X=128.f,Y=256.f)
}
