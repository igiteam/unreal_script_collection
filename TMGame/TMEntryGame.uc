/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMEntryGame extends TMTeamGame;

function bool NeedPlayers()
{
	return false;
}

exec function AddBots(int num) {}

function StartMatch()
{}

// Parse options for this game...
event InitGame( string Options, out string ErrorMessage )
{
	if ( ParseOption( Options, "PerformUnitTests" ) ~= "1" )
	{
		if ( MyAutoTestManager == None )
		{
			MyAutoTestManager = spawn(AutoTestManagerClass);
		}
		MyAutoTestManager.InitializeOptions(Options);
	}
}

auto State PendingMatch
{
	function RestartPlayer(Controller aPlayer)
	{
	}

	function Timer()
    {
    }

    function BeginState(Name PreviousStateName)
    {
		bWaitingToStartMatch = true;
		TMGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
		StartupStage = 0;
		bQuickStart = false;
    }

	function EndState(Name NextStateName)
	{
		TMGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
	}
}

