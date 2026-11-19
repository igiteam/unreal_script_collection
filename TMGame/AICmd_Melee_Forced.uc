/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Melee_Forced extends AICmd_Base_Melee
	within TGAI;

var actor MeleeTarget;
static function bool ForceMelee(TGAI AI, Actor InMeleeTarget)
{
	local AICmd_Melee_Forced Cmd;

	if(AI != none && InMeleeTarget != none)
	{
		Cmd = new(AI) class'AICmd_Melee_Forced';
		Cmd.MeleeTarget = InMeleeTarget;
		AI.PushCommand(Cmd);
		return TRUE;
	}

	return FALSE;
}

state InCombat
{
Begin:
	//debug
	;

	if(MeleeTarget==none)
	{
		MeleeTarget = Enemy;
	}

	if(MeleeTarget == none)
	{
		;
		GotoState('DelayFailure');
	}

	// if we have a lancer, start the saw early
	if(MyTGPawn != none && MyTGPawn.Weapon != none &&
		(MyTGPawn.Weapon.IsA('TGWeap_LocustAssaultRifle') || MyTGPawn.Weapon.IsA('TGWeap_AssaultRifle')) )
	{
		;
		bAllowedToFireWeapon = TRUE;
		StartMeleeAttack();
	}

	if (MyTGPawn != None && VSize(MyTGPawn.Location - MeleeTarget.Location) > MyTGPawn.GetAIMeleeAttackRange() && !MyTGPawn.ReachedDestination(MeleeTarget))
	{
		;
		SetMoveGoal(MeleeTarget,,false,75.f);
	}
	// If no LOS to enemy
	else if( !CanSeeByPoints( Pawn.GetPawnViewLocation(), MeleeTarget.Location, Rotator(MeleeTarget.Location - Pawn.GetPawnViewLocation()) ) )
	{
		//debug
		;

		// Move to him first
		SetMoveGoal(MeleeTarget,,false);
	}

	if( ChildStatus != 'Aborted' && ChildStatus != 'Failure')
	{
		if(Pawn(MeleeTarget) != none)
		{
			DoMeleeAttack( Pawn(MeleeTarget) );
		}
		else
		{
			class'AICmd_Attack_Melee'.static.Melee(Outer,MeleeTarget);
		}
	}
	else
	{
		;
		Sleep(1.0f);
		Goto('Begin');
	}

	// Check combat transitions
	CheckCombatTransition();
	Goto('Begin');
}

