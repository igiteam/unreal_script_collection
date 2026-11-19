/**
 * Base class for behavior of Berserker
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_BerserkerLambent extends AIcmd_Base_UtilActionSelector
	within GearAI_BerserkerBase;

function bool ExecuteBestCommand()
{
	local int Best;
	local bool bFoundEnemy;

	// Select an enemy and make sure it's valid
	bFoundEnemy = SelectEnemy() && HasValidEnemy();
	FireTarget = Enemy;

	if( bFoundEnemy )
	{
		Best = PickBestCommand();

		if(Best != -1)
		{
			`AILog(self@"Executing command of class"@PossibleCommands[Best].CommandClass);
			return PossibleCommands[Best].CommandClass.static.InitUtilitySelectedCommand(Outer,PossibleCommands[Best]);
		}
	}

	return FALSE;
}

function AdjustEnemyRating(out float out_Rating, Pawn EnemyPawn)
{
	if( CachedGearChildCommand != None )
	{
		CachedGearChildCommand.AdjustEnemyRating(out_Rating, EnemyPawn);
		return;
	}

	if( out_Rating > 0.f && MyGearPawn != None )
	{
		if( EnemyPawn == LastKamikazeTarget )
		{
			out_Rating *= FRand();
		}
	}

	Super.AdjustEnemyRating(out_Rating, EnemyPawn);
}


defaultproperties
{
	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=Kamikaze
		CommandClass=class'AICmd_Berserker_Kamikaze'
	End Object

	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=AlertSearch
		CommandClass=class'AICmd_Berserker_AlertSearch'
	End Object

	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=JumpAttack
		CommandClass=class'AICmd_Berserker_JumpAttack'
	End Object

	PossibleCommands.Add(Kamikaze)
	PossibleCommands.Add(AlertSearch)
	PossibleCommands.Add(JumpAttack)
}
