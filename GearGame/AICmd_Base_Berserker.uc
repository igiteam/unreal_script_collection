/**
 * Base class for behavior of Berserker
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_Berserker extends AIcmd_Base_UtilActionSelector
	within GearAI_BerserkerBase;


/** Before picking a command we want to select an enemy and sleep if we didn't find one */
function float PrePickBestCommand()
{
	local bool bFoundEnemy;

	// Select an enemy and make sure it's valid
	bFoundEnemy = SelectEnemy() && HasValidEnemy();
	FireTarget = Enemy;

	// Return a sleep value
	return bFoundEnemy ? 0.0f : 1.0f;
}

function float PostCommandExecution()
{
	// after each action, evaluate our enemies again
	return PrePickBestCommand();
}

defaultproperties
{
	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=Kamikaze
		CommandClass=class'AICmd_Berserker_Kamikaze'
	End Object

	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=AlertSearch
		CommandClass=class'AICmd_Berserker_AlertSearch'
	End Object

	Begin Object Class=UtilBasedAICmdMetaDataPacket Name=ExecutePawn
		CommandClass=class'AICmd_Berserker_Execute'
	End Object

	PossibleCommands.Add(Kamikaze)
	PossibleCommands.Add(AlertSearch)
	PossibleCommands.Add(ExecutePawn)
}
