/**
 * AI DBNO logic - mostly just sit around and wait for help or bleedout, may try to crawl around
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/

class AICmd_DBNO extends AICommand_Base_Combat
	within GearAI;

/** GoW global macros */

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool GotoDBNO( GearAI AI )
{
	local AICmd_DBNO Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_DBNO';
		if( Cmd != None )
		{
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	local float LocRevDel;
	Super.Pushed();

	StopFiring();
	Focus = None;

	// Prevent Pawn for turning, keep the same rotation.
	SetDesiredRotation(Pawn.Rotation);

	// Notify squad that I need to be revived

	if(IsInKantusSquad(MyGearPawn))
	{
		LocRevDel = 1.f;
	}
	else
	{
		LocRevDel = ReviveDelay;
	}
	//`AILog(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Setting timer for"@LocRevDel);
	SetTimer( LocRevDel, FALSE, nameof(NotifySquadDBNO) );

	GotoState( 'InDBNO' );
}

function Popped()
{
	Super.Popped();

	// Remove any cover claims only *after* we get up
	// (stops other AI from wanting to claim cover that we go down ontop of)
	InvalidateCover();

	// Clear notification
	ClearTimer('NotifySquadDBNO');

	ClearTimer('DropGrenade', self);

	// Reset bAllowDBNOCrawl
	bAllowDBNOCrawl = true;

	if (Pawn != None)
	{
		Pawn.ZeroMovementVariables();
		// choose a weapon since the situation has likely changed since we went DBNO
		if (!HasEnemyWithinDistance(EnemyDistance_Melee))
		{
			SelectWeapon();
		}
	}
}

/** called when our Pawn gets revived (@see GearPawn::DoRevival()) */
final function PawnWasRevived()
{
	// we pop any crawl move command and let the state code handle popping this one
	if (ChildCommand != None)
	{
		AbortCommand(ChildCommand);
	}
	ClearTimer('DropGrenade', self);
}

function DropGrenade()
{
	if (MyGearPawn.MyGearWeapon != None)
	{
		MyGearPawn.MyGearWeapon.DoMartyrFire();
	}
}

final function bool IsDBNO()
{
	return MyGearPawn != None && MyGearPawn.IsDBNO();
}

function bool AllowTransitionTo( class<GameAICommand> AttemptCommand )
{
	return !IsDBNO();
}

function bool IgnoreNotifies()
{
	return IsDBNO();
}

state InDBNO `DEBUGSTATE
{
	final function TryCrawlToFriendly()
	{
		local Controller C;
		local Actor Best;
		local float Dist, BestDist;
		local Actor ObjectiveActor;
		local Pawn ClosestEnemy;

		if (Squad != None && bAllowDBNOCrawl)
		{
			BestDist = 5000.0;
			foreach Squad.AllMembers(class'Controller', C)
			{
				if (C != Outer && C.Pawn != None && C.Pawn.Health > 0)
				{
					Dist = VSize(C.Pawn.Location - Pawn.Location);
					if (Dist < BestDist)
					{
						Best = C.Pawn;
						BestDist = Dist;
					}
				}
			}

			// MP bots also check if there is an objective to crawl to instead (e.g. to break annex ring)
			if (GearAI_TDM(Outer) != None && (Best == None || GetDifficultyLevel() > DL_Normal))
			{
				ObjectiveActor = GearGameMP_Base(WorldInfo.Game).GetObjectivePointForAI(Outer);
				if (ObjectiveActor != None && GearGameMP_Base(WorldInfo.Game).MustStandOnObjective(Outer))
				{
					Dist = VSize(ObjectiveActor.Location - Pawn.Location);
					if (Dist < 768.0 && Dist < BestDist)
					{
						Best = ObjectiveActor;
					}
				}
			}

			if( Best != None )
			{
				`AILog("Try to crawl to" @ Best);
				SetMoveGoal( Best,,,,,,,, TRUE );
			}
			else
			{
				// just try to get away from the enemy
				GetNearEnemyDistance(Pawn.Location, ClosestEnemy);
				if (ClosestEnemy != None)
				{
					class'NavMeshPath_AlongLine'.static.AlongLine(NavigationHandle, Normal(Pawn.Location - ClosestEnemy.Location));
					//class'Path_AvoidanceVolumes'.static.AvoidThoseVolumes(Pawn);
					class'NavMeshGoal_AwayFromPosition'.static.FleeFrom(NavigationHandle, ClosestEnemy.Location, 500);
					if (NavigationHandle.FindPath())
					{
						`AILog("Crawling away from enemy, to" @ NavigationHandle.PathCache_GetGoalPoint());
						SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),, true,, true, false,, false);
					}
				}
			}
		}
	}

	event BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		if (GearWeap_GrenadeBase(Pawn.Weapon) != None && FRand() < GrenadeMartyrChance)
		{
			`AILog("- Grenade martyr");
			SetTimer( 1.0 + FRand(), false, nameof(self.DropGrenade), self );
		}
	}

Begin:
	//debug
	`AIlog( "BEGIN TAG" @ MyGearPawn.IsDBNO(), 'State' );

CrawlLoop:
	if (!IsDBNO())
	{
		Pawn.ZeroMovementVariables();

		//debug
		`AILog("No longer needing revival... transitioning to default state"@MyGearPawn.Velocity@"--"@MyGearPawn.Acceleration);

		BeginCombatCommand(None, "No longer DBNO");
	}
	TryCrawlToFriendly();
	Sleep(0.5);
	Goto('CrawlLoop');
}

defaultproperties
{
	bAllowedToFireWeapon=false
}
