/**
 * Base class for behavior of Gunners mounted to another pawn
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_MountedGunner extends AICommand_Base_Combat;

/** GoW global macros */

var Pawn Mount;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool InitCommand( GameAIController GameAI )
{
	local AICmd_Base_MountedGunner Cmd;
	local GearAI AI;

	AI = GearAI(GameAI);
	if (AI != None)
	{
		Cmd = new(AI) class'AICmd_Base_MountedGunner';
		if (Cmd != None)
		{
			Cmd.Mount = Pawn(AI.MyGearPawn.Base);
			AI.PushCommand(Cmd);
			return true;
		}
	}
	return false;
}

function Pushed()
{
	Super.Pushed();
	ReactionManager.SuppressAllChannels();
	MyGearPawn.bRespondToExplosions=FALSE;
	GotoState('InCombat');
}

function Popped()
{
	Super.Popped();
	ReactionManager.UnSuppressAllChannels();
	MyGearPawn.bRespondToExplosions = MyGearPawn.default.bRespondToExplosions;
	if (GetTetherActor() == Mount)
	{
		ClearTether();
	}
}
function Resumed( Name OldCommandName )
{
	if(Mount != Pawn.Base)
	{
		CheckCombatTransition();
	}
	Super.Resumed(OldCommandName);
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand )
{
	if(Mount == Pawn.Base)
	{
		return false;
	}

	return Super.AllowTransitionTo(AttemptCommand);
}

function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	local vector FireDir2D;
	local GearPawn GP;

	if (CachedGearChildCommand != None)
	{
		CachedGearChildCommand.AdjustEnemyRating(out_Rating, EnemyPawn);
	}
	else if (out_Rating > 0.0)
	{
		FireDir2D = EnemyPawn.Location - Pawn.Location;
		FireDir2D.Z = 0.0;
		if (Normal(FireDir2D) dot vector(Pawn.Rotation) < 0.0)
		{
			//debug
			`AILog("- can't fire at (facing wrong way):" @ EnemyPawn, 'Enemy');

			out_Rating = -1.0;
		}
		// if human is driving us around, force our target to anything valid they have spotted
		else if (Mount != None && Mount.IsHumanControlled())
		{
			GP = GearPawn(EnemyPawn);
			if (GP != None && GP.SpottedBy[GetTeamNum()] == Mount.PlayerReplicationInfo)
			{
				out_Rating = 100.0;
			}
		}
	}

	Super.AdjustEnemyRating(out_Rating, EnemyPawn);
}

state InCombat
{
	function BeginState(Name previousStateName)
	{
		Super.BeginState(previousStateName);
		bIgnoreStepAside=true;
	}

	function EndState(Name nextStateName)
	{
		Super.EndState(nextStateName);
		bIgnoreStepAside=false;
	}

Begin:
	//debug
	`AILog( "BEGIN TAG", 'State' );

	if (!bAllowCombatTransitions)
	{
		Sleep(1.0);
		Goto('Begin');
	}
	if (Mount != Pawn.Base)
	{
		`AILog("Mount:"$Mount$" != Pawn.Base:"$Pawn.Base$", Checking for combat transitions...");
		AbortCommand(self);
		CheckCombatTransition();
	}
	if (SelectTarget() && CanFireAt(FireTarget, Pawn.GetWeaponStartTraceLocation(), true))
	{
		// If burst fire successful (fire line not blocked)
		StartFiring();

		// wait for the weapon to finish firing
		do
		{
			if (!bAllowCombatTransitions)
			{
				Sleep(1.0);
				Goto('Begin');
			}

			Sleep(0.25);

			//debug
			`AILog( "Firing weapon..."/*, 'Loop' */);
		} until (!HasAnyEnemies() || !HasValidTarget() || (!IsFiringWeapon() && !IsReloading()));
		StopFiring();
	}
	else
	{
		//debug
		`AILog("HasAnyEnemies?"@HasAnyEnemies());
	}

	Sleep(0.5);

	Goto('Begin');
}


defaultproperties
{
}
