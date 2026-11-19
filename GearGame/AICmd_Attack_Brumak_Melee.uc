/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class AICmd_Attack_Brumak_Melee extends AICommand_SpecialMove
	within GearAI_Brumak
	dependson(GearAI_Brumak);

var Actor MeleeTarget;

static function Melee(GearAI_Brumak AI, optional Actor InTarget)
{
	local AICmd_Attack_Brumak_Melee Cmd;

	Cmd = new(AI) default.class;
	Cmd.MeleeTarget = InTarget;
	AI.PushCommand(Cmd);
}

function Pushed()
{
	if (MeleeTarget == None)
	{
		MeleeTarget = Enemy;
	}

	Super.Pushed();

	GotoState('BeginMeleeAttack');
}

state BeginMeleeAttack
{

Begin:
	if (VSize(MeleeTarget.Location - Pawn.Location) > EnemyDistance_Melee)
	{
		`AILog(self@"No enemy within range, moving to enemy"@MeleeTarget);
		if (MeleeTarget == Enemy)
		{
			SetEnemyMoveGoal(true, EnemyDistance_Short);
		}
		else
		{
			SetMoveGoal(MeleeTarget,,, EnemyDistance_Short);
		}
	}

	GotoState('Command_SpecialMove');
};

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		SetDesiredRotation(rotator(MeleeTarget.Location - Pawn.Location));
	}

	function bool ShouldFinishRotation()
	{
		return true;
	}

	function ESpecialMove GetSpecialMove()
	{
		local GearAI_Brumak.BrumakMeleeAttackDef ADef;

		ADef = PickBrumakMeleeAttack();

		`AILog("Using "@ADef.AttackSpecialMove@" for melee attach");
		return ADef.AttackSpecialMove;
	}


}

defaultproperties
{
	bShouldCheckSpecialMove=true
}
