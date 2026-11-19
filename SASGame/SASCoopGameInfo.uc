////////////////////////////////////////////////////////////////////////////////
// SASCoopGameInfo.uc
//
// SAS Cooperative game info
////////////////////////////////////////////////////////////////////////////////

class SASCoopGameInfo extends SASMPGameInfoCommon
	config(user);


function byte PickTeam ( byte Current, Controller C )
{
	// we're always the good guys.
	return 0;
}

function PlayerDied(PlayerController which)
{
	// If there's no-one left, it's the end of the round
	local Controller P;
	local SASPlayerController Player;

	which.PlayerReplicationInfo.bOutOfLives = true;;
		
	for ( P = Level.ControllerList; P != None; P = P.nextController )
	{
		Player = SASPlayerController(P);
		
		if (Player == None)	
			continue;
			
		if (Player.Pawn != None && !Player.Pawn.IsDead())
		{
			// Aha, this player is still alive. So do no more.
			return;
		}
	}
	
	// If we've got here, there's no live humans any more.
	MissionFailed();
}


function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> damageType)
{
	// Onyl broadcast player death messages in co-op.
	if ( PlayerController( Other ) != None )
	{
		if ( (Killer == Other) || (Killer == None) )
		{
			BroadcastLocalized(self,DeathMessageClass, 1, None, Other.PlayerReplicationInfo, damageType);
		}
		else 
		{
			// Only broadcast who killed other if it was another player. 
			if ( PlayerController( Killer ) != None )
			{
				BroadcastLocalized(self,DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, damageType);
			}
			else
			{
				BroadcastLocalized(self,DeathMessageClass, 2, None, Other.PlayerReplicationInfo, damageType);
			}
		}
	}
}


function ExtraPreLoginCheck(out String Error, out string FailCode)
{
	if ( ( mSquadManager.mNumPlayers + mSquadManager.mNumAISquadMembers ) == 4 )
	{
		Error = "Cooperative Team game already in progress";
		FailCode = "GAMESTARTED";
	}
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Controller P, NextController;
	local PlayerController Player;
	local bool bLastMan;

	if ( bOverTime )
	{
		if ( NumPlayers == 0 )
		{
			return true;
		}
		bLastMan = true;
		for ( P = Level.ControllerList; P != None; P = P.nextController )
		{
			if ( (P.PlayerReplicationInfo != None) && !P.PlayerReplicationInfo.bOutOfLives )
			{
				bLastMan = false;
				break;
			}
		}
		if ( bLastMan )
		{
			return true;
		}
	}			
		
	bLastMan = ( Reason ~= "LastMan" );

	if ( !bLastMan && (GameRulesModifiers != None) && !GameRulesModifiers.CheckEndGame(Winner, Reason) )
	{
		return false;
	}

	if ( Winner == None )
	{
		// find winner
		for ( P = Level.ControllerList; P != None; P = P.nextController )
		{
			if ( P.bIsPlayer && !P.PlayerReplicationInfo.bOutOfLives
				&& ( ( Winner == None ) || ( P.PlayerReplicationInfo.ScoreDaggers >= Winner.ScoreDaggers ) ) )
			{
				Winner = P.PlayerReplicationInfo;
			}
		}
	}

	// check for tie
	if ( !bLastMan )
	{
		for ( P = Level.ControllerList; P != None; P = P.nextController )
		{
			if ( P.bIsPlayer &&
				(Winner != P.PlayerReplicationInfo) &&
				(P.PlayerReplicationInfo.ScoreDaggers == Winner.ScoreDaggers)
				&& !P.PlayerReplicationInfo.bOutOfLives )
			{
				if ( !bOverTimeBroadcast )
				{
					StartupStage = 7;
					PlayStartupMessage();
					bOverTimeBroadcast = true;
				}
				return false;
			}
		}
	}

	EndTime = Level.TimeSeconds + EndTimeDelay;
	GameReplicationInfo.Winner = Winner;

	EndGameFocus = Controller(Winner.Owner).Pawn;
	if ( EndGameFocus != None )
	{
		EndGameFocus.bAlwaysRelevant = true;
	}
	for ( P=Level.ControllerList; P!=None; P=NextController )
	{
		Player = PlayerController(P);
		if ( Player != None )
		{
			PlayWinMessage(Player, (Player.PlayerReplicationInfo == Winner));
			Player.ClientSetBehindView(true);
			if ( EndGameFocus != None )
			{
				Player.ClientSetViewTarget(EndGameFocus);
				Player.SetViewTarget(EndGameFocus);
			}
		}
		NextController = P.NextController;
		P.ClientGameHasEnded();
	}
	return true;
}

event PlayerController Login
(
	string Portal,
	string Options,
	out string Error
)
{
	if ( ( mSquadManager.mNumPlayers + mSquadManager.mNumAISquadMembers ) == 4 )
	{
		Options = Options $"?SpectatorOnly=true";
	}
	
	return Super.Login(Portal, Options, Error);
}


function EndGame(PlayerReplicationInfo Winner, string Reason )
{
	if ( (Reason ~= "triggered") ||
		(Reason ~= "LastMan")   ||
		(Reason ~= "TimeLimit") ||
		(Reason ~= "FragLimit") ||
		(Reason ~= "TeamScoreLimit") )
	{
		Super.EndGame(Winner,Reason);
		if ( bGameEnded )
		{
			GotoState('MatchOver');
		}
	}
}

function RestartGame ()
{
	if ( mRepeatLevel != 0 )
	{
		// trick Super level function into believing that level already chosen
		bAlreadyChanged = true;
	}

	Super.RestartGame ();
}

State MatchOver
{
	function Timer()
	{
		local Controller C;

		Global.Timer();

		if ( EndGameFocus != None )
		{
			EndGameFocus.bAlwaysRelevant = true;
			for ( C = Level.ControllerList; C != None; C = C.NextController )
			{
				if ( PlayerController(C) != None )
				{
					PlayerController(C).ClientSetViewtarget(EndGameFocus);
				}
			}
		}

		// play end-of-match message for winner/losers (for single and muli-player)
		EndMessageCounter++;
		if ( EndMessageCounter == EndMessageWait )
		{
			PlayEndOfMatchMessage();
		}
	}

	function BeginState()
	{
		GameReplicationInfo.bStopCountDown = true;
	}
}

////////////////////////////////////////////////////////////////////////////////
// RatePlayerStart
//
// Rate whether player should choose this NavigationPoint as its start
function float RatePlayerStart ( NavigationPoint N, byte Team, Controller Player )
{
	if ( ( N == None ) || ( SASSpawnPoint ( N ) == None ) || !SASSpawnPoint ( N ).bCoopStart )
	{
		return -10000000;
	}

	return Super.RatePlayerStart ( N, Team, Player );
}

////////////////////////////////////////////////////////////////////////////////
// 
//
// check if all other players are out
function GoToNextLevel()
{
	// If we've won, advance to next map, otherwise repeat the current one.
	if ( !Level.Game.GameReplicationInfo.mbMissionFailed )
	{
		// we've won!
		
		// Go to the next map as defined in the frontend
		Level.GetLocalPlayerController().SwitchLevel(SASPlayerController(Level.GetLocalPlayerController()).CycleMPMapList());
	}
	else
	{
		// We've lost, let's try this map again.
		Level.GetLocalPlayerController().SwitchLevel("?restart");
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    NetWait=2
    RestartWait=30
    MinStartingHumanPlayers=1
    bPlayersMustBeReady=true
    mNumTeams=1
    mSquadManagerClassName="SASMPGame.SASCoopSquadManager"
    mGameTypeId=2
    ScoreBoardType="SASMPGame.SASCoopScoreboard"
    HUDType="SASMPGame.SASCoopHUD"
    MapPrefix="Coop"
    BeaconName="0"
    MaxSpectators=0
    MaxPlayers=4
    GameName="CooperativeTeam"
    DeathMessageClass=none
    PlayerControllerClassName="SASMPGame.SASCoopPlayerController"
}