/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
* this is the base class for commands which determine their action via running 
* activation utility functions on their children
*/
class AIcmd_Base_UtilActionSelector extends AICmd_Base_UtilitySelectedCmd;


/** list of commands we could choose to execute as our child actions */
var array<UtilBasedAICmdMetaDataPacket> PossibleCommands;

function Pushed()
{
	Super.Pushed();
	GotoState('PickBestAction');
}

function int PickBestCommand()
{
	local int Idx;
	local float BestRating;
	local float CurRating;
	local int BestIdx;
	
	BestRating = -1.f;
	BestIdx = -1;
	for(Idx=0;Idx<PossibleCommands.length;++Idx)
	{
		CurRating = PossibleCommands[Idx].CommandClass.static.EvaluateActivation(Outer,PossibleCommands[Idx]);
		`AILog("PossibleCommand["$Idx$"] - "$PossibleCommands[Idx].CommandClass$" - Score:"$CurRating);
		if(CurRating > BestRating)
		{
			BestRating = CurRating;
			BestIdx=Idx;
		}
	}
	return BestIdx;
}

/**
 * this function is called just before the best command loop is run.. gives the parent commadn to take action and enforce delays
 * @return - the amount of time we should delay before entering best command loop
 */
function float PrePickBestCommand()
{
	return 0.f;
}

/**
 * this function is called after a command is done executing
 * @return - the amount of time we should pause before executing the next best command
 */
function float PostCommandExecution()
{
	return 0.1f;
}

function bool ExecuteBestCommand()
{
	local int Best;

	Best = PickBestCommand();

	if(Best != -1)
	{
		`AILog(self@"Executing command of class"@PossibleCommands[Best].CommandClass);
		return PossibleCommands[Best].CommandClass.static.InitUtilitySelectedCommand(Outer,PossibleCommands[Best]);
	}

	return false;
}

state PickBestAction
{
	
Begin:
	
	Sleep(PrePickBestCommand());

	while(ExecuteBestCommand())
	{
		Sleep(PostCommandExecution());
	}

	`AILog("Could not get valid command to execute for"@self@"bailing");
	AbortCommand(self);
};