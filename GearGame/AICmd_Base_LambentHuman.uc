/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_LambentHuman extends AICommand_Base_Combat
	within GearAI_LambentHuman;

auto state InCombat
{
Begin:
	//debug
	`AILog( "BEGIN TAG"@GetStateName(), 'State' );

	// check for any interrupt transitions
	CheckInterruptCombatTransitions();

	if( !SelectEnemy() )
	{
		//debug
		`AILog( "Unable to acquire an enemy" );

		Sleep( 1.f );
		Goto( 'End' );
	}
	FireTarget = Enemy;

	if( CanEngageMelee() )
	{
		DoMeleeAttack();
	}
	else if( !CheckInterruptCombatTransitions() )
	{
		Sleep( 0.5f );
	}

End:
	Goto('Begin');
};


defaultproperties
{

}