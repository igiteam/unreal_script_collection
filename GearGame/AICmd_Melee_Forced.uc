/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Melee_Forced extends AICmd_Base_Melee
	within GearAI;

var Actor MeleeTarget;
/** if true, pop after a single melee attack move (default is to continue until target dies, becomes invalid, or another command interrupts) */
var bool bSingleAttack;

static function bool ForceMelee(GearAI AI, Actor InMeleeTarget, optional bool bInSingleAttack)
{
	local AICmd_Melee_Forced Cmd;

	if (AI != None && AI.bCanMelee && InMeleeTarget != None)
	{
		Cmd = new(AI) class'AICmd_Melee_Forced';
		Cmd.MeleeTarget = InMeleeTarget;
		Cmd.bSingleAttack = bInSingleAttack;
		AI.PushCommand(Cmd);
		return TRUE;
	}

	return FALSE;
}

state InCombat
{
Begin:
	//debug
	`AILog( "BEGIN TAG"@Pawn.Weapon@Enemy, 'State' );

	if(MeleeTarget==none)
	{
		MeleeTarget = Enemy;
	}

	if(MeleeTarget == none)
	{
		`AILog("Aborting because we have no melee target!");
		GotoState('DelayFailure');
	}

	// if we have a lancer, start the saw early
	if(MyGearPawn != none && MyGearPawn.Weapon != none &&
		(MyGearPawn.Weapon.IsA('GearWeap_LocustAssaultRifle') || MyGearPawn.Weapon.IsA('GearWeap_AssaultRifle')) )
	{
		`AILog("Starting melee");
		bAllowedToFireWeapon = TRUE;
		StartMeleeAttack();
	}

	if (MyGearPawn != None && VSize(MyGearPawn.Location - MeleeTarget.Location) > MyGearPawn.GetAIMeleeAttackRange() && !MyGearPawn.ReachedDestination(MeleeTarget))
	{
		`AILog("Not in weapon's melee range, move to MeleeTarget..."@VSize(MyGearPawn.Location - MeleeTarget.Location)@MyGearPawn.GetAIMeleeAttackRange(), 'Combat');
		SetMoveGoal(MeleeTarget,,false,75.f);
		if (ChildStatus == 'Aborted' || ChildStatus == 'Failure')
		{
			`AILog("Failed to move to target... trying again");
			Sleep(1.0);
			Goto('Begin');
		}
	}
	// If no LOS to enemy
	else if (!CanSeeByPoints(Pawn.GetPawnViewLocation(), MeleeTarget.Location, Rotator(MeleeTarget.Location - Pawn.GetPawnViewLocation())))
	{
		//debug
		`AILog( "No LOS, move to enemy...", 'Combat' );

		// Move to him first
		SetMoveGoal(MeleeTarget,,false);
		if (ChildStatus == 'Aborted' || ChildStatus == 'Failure')
		{
			`AILog("Failed to move to target... trying again");
			Sleep(1.0);
			Goto('Begin');
		}
	}

	StopFiring();
	if (Pawn(MeleeTarget) != none)
	{
		DoMeleeAttack( Pawn(MeleeTarget) );
	}
	else
	{
		DoMeleeAttack(None, MeleeTarget);
	}
	Sleep(0.0); // failsafe in case DoMeleeAttack() does nothing (AI will still get stuck in a loop here, though - inability to melee should have been checked earlier)

	// if we killed the target or we only want to do a single attack move, then we're done
	if ( bSingleAttack || MeleeTarget == None || MeleeTarget.bDeleteMe || !MeleeTarget.bCollideActors ||
		(MeleeTarget.IsA('GearFortification') && MeleeTarget.IsInState('Crippled')) ||
		(MeleeTarget.IsA('Pawn') && MeleeTarget.IsInState('Dying')) )
	{
		PopCommand(self);
	}

	// Check combat transitions
	if (HasAnyEnemies())
	{
		CheckCombatTransition();
	}
	Goto('Begin');
}

defaultproperties
{
}
