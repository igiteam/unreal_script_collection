//-----------------------------------------------------------
// HD?????
//-----------------------------------------------------------
class HDDeathmatch extends HDGame
	DependsOn(HDInventoryManager);

//vars we need from TMGame
/** forces the spawn location for the next player spawned */
//var NavigationPoint ScriptedStartSpot;
//var NavigationPoint LastPlayerStartSpot;    // last place current player looking for start spot started from
//var NavigationPoint LastStartSpot;          // last place any player started from

/** Whether scoring is based on enemy deaths */
//var bool bScoreDeaths;

//-----------------------------------------------------------
//???
/** FindPlayerStart()
* Return the 'best' player start for this player to start from.  PlayerStarts are rated by RatePlayerStart().
* @param Player is the controller for whom we are choosing a playerstart
* @param InTeam specifies the Player's team (if the player hasn't joined a team yet)
* @param IncomingName specifies the tag of a teleporter to use as the Playerstart
* @returns NavigationPoint chosen as player start (usually a PlayerStart)
 */
function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local NavigationPoint Best;

	if(ScriptedStartSpot != None)
	{
		Best = ScriptedStartSpot;
		ScriptedStartSpot = None;
	}
	else
	{
		// Save LastPlayerStartSpot for use in RatePlayerStart()
		if( (Player != None) && (Player.StartSpot != None) )
		{
			LastPlayerStartSpot = Player.StartSpot;
		}

		Best = Super.FindPlayerStart(Player, InTeam, incomingName );

		// Save LastStartSpot for use in RatePlayerStart()
		if( Best != None )
		{
			LastStartSpot = Best;
		}
	}

	return Best;
}

/** ChoosePlayerStart()
* Return the 'best' player start for this player to start from.  PlayerStarts are rated by RatePlayerStart().
* @param Player is the controller for whom we are choosing a playerstart
* @param InTeam specifies the Player's team (if the player hasn't joined a team yet)
* @returns NavigationPoint chosen as player start (usually a PlayerStart)
 */

function PlayerStart ChoosePlayerStart( Controller Player, optional byte InTeam )
{
	local PlayerStart P, BestStart;
	local float BestRating, NewRating;
	local array<playerstart> PlayerStarts;
	local int i, RandStart;
	local byte Team;

	// use InTeam if player doesn't have a team yet
	Team = (Player != None && Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.Team != None)
			? byte(Player.PlayerReplicationInfo.Team.TeamIndex)
			: InTeam;

	// make array of enabled playerstarts
	foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P)
	{
		if( P.bEnabled )
			PlayerStarts[PlayerStarts.Length] = P;
	}

	// Avoid randomness for profiling.
	if( bFixedPlayerStart )
	{
		RandStart = 0;
	}
	// start at random point to randomize finding "good enough" playerstart
	else
	{
		RandStart = Rand(PlayerStarts.Length);
		;
	}

	for( i=RandStart; i<PlayerStarts.Length; i++ )
	{
		P = PlayerStarts[i];
		NewRating = RatePlayerStart(P,Team,Player);
		if ( NewRating >= 30)
		{
			;
			// this PlayerStart is good enough
			return P;
		}
		if ( NewRating > BestRating )
		{
			BestRating = NewRating;
			BestStart = P;
		}
	}

	for( i=0; i<RandStart; i++ )
	{
		P = PlayerStarts[i];
		NewRating = RatePlayerStart(P,Team,Player);
		if ( NewRating >= 30)
		{
			;

			// this PlayerStart is good enough
			return P;
		}
		if ( NewRating > BestRating )
		{
			BestRating = NewRating;
			BestStart = P;
		}
	}

    ;
	return BestStart;
}

function AddDefaultInventory( pawn PlayerPawn )
{
	Super.AddDefaultInventory( PlayerPawn );
}

/** RatePlayerStart()
* Return a score representing how desireable a playerstart is.
* @param P is the playerstart being rated
* @param Team is the team of the player choosing the playerstart
* @param Player is the controller choosing the playerstart
* @returns playerstart score
*/
function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	local float Score, NextDist;
	local Controller OtherPlayer;
	local bool bTwoPlayerGame;
	local bool bKiller;

	// Primary starts are more desireable
	Score = P.bPrimaryStart ? 30: 20;

	if( P == LastStartSpot || P == LastPlayerStartSpot )
	{
		// avoid re-using starts
		Score -= 15.0;
	}

	bTwoPlayerGame = ( NumPlayers + NumBots == 2 );

	if( Player != None )
	{
	    //??????????(?????)???
		ForEach WorldInfo.AllControllers(class'Controller', OtherPlayer)
		{
			if( OtherPlayer.bIsPlayer && ( OtherPlayer.Pawn != None ) )
			{
				// check if playerstart overlaps this pawn
				if( (Abs(P.Location.Z - OtherPlayer.Pawn.Location.Z) < P.CylinderComponent.CollisionHeight + OtherPlayer.Pawn.CylinderComponent.CollisionHeight) &&
					(VSize2D(P.Location - OtherPlayer.Pawn.Location) < P.CylinderComponent.CollisionRadius + OtherPlayer.Pawn.CylinderComponent.CollisionRadius) )
				{
					// overlapping - would telefrag
					return -10;
				}

				NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
				bKiller = (OtherPlayer.PlayerReplicationInfo != None) &&
					 	  (TMPlayerReplicationInfo( Player.PlayerReplicationInfo ).LastKillerPRI == OtherPlayer.PlayerReplicationInfo);

				//2000x2=4000cm=40m
				if( NextDist < 2000 &&
					!WorldInfo.GRI.OnSameTeam( Player, OtherPlayer ) )
				{
					// avoid starts close to visible enemy
					if(bKiller)
					{
						// really avoid guy that killed me last
						Score -= 7;
					}

					Score -= (5 - 0.001 * NextDist);
				}
				else if( NextDist < 1000 && bKiller )  //20m
				{
					// really avoid guy that killed me last
					Score -= 7;
				}
				else if( bTwoPlayerGame )  //2?????????
				{
					// in 2 player game, look for any visibility
					Score += FMin(2, 0.001 * NextDist);
					if( FastTrace(P.Location, OtherPlayer.Pawn.Location) )
						Score -= 5;
				}
			}
		}
	}

	return FMax(Score, 0.2);
}

//-----------------------------------------------------------
//????
//function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
function ScoreKill(Controller Killer, Controller Other)
{
	local PlayerReplicationInfo OtherPRI;

	OtherPRI = Other.PlayerReplicationInfo;
    if( OtherPRI != None )
    {
    	//??????????(???0???????)
		OtherPRI.NumLives++;
		if( MaxLives > 0 && OtherPRI.NumLives >=MaxLives )
			OtherPRI.bOutOfLives = true;
    }

	/////////////////////////////////////////////////////////////////////////
	//GameInfo::ScoreKill(Killer,Other);
	if( killer == Other || killer == None ) //???
	{
		if ( Other!=None && Other.PlayerReplicationInfo != None )
		{
			Other.PlayerReplicationInfo.Score -= 1;  //??
			Other.PlayerReplicationInfo.bForceNetUpdate = TRUE;
		}
	}
	else if( killer.PlayerReplicationInfo != None )
	{
		Killer.PlayerReplicationInfo.Score += 2; //??
		Killer.PlayerReplicationInfo.bForceNetUpdate = TRUE;
		//Killer.PlayerReplicationInfo.Kills++;
	}

	ModifyScoreKill(Killer, Other);

	if (Killer != None || MaxLives > 0)
	{
		CheckScore(Killer.PlayerReplicationInfo);
	}
	/////////////////////////////////////////////////////////////////////////
	//TM ??????(??????)
	/*
    if ( (killer == None) || (Other == None) )
		return;

	// adjust bot skills to match player - only for DM, not team games
	GRI = TMGameReplicationInfo(GameReplicationInfo);
	if ( GRI.bStoryMode && !bTeamGame && (killer.IsA('PlayerController') || Other.IsA('PlayerController')) )
    {
		if ( killer.IsA('AIController') )
			AdjustSkill(AIController(killer), PlayerController(Other), false);
		if ( Other.IsA('AIController') )
			AdjustSkill(AIController(Other), PlayerController(Killer), true);
    } */
}

//-----------------------------------------------------------
//????
/* CheckScore()
see if this score means the game ends
*/
function bool CheckScore(PlayerReplicationInfo Scorer)
{
	local controller C;

	if ( CheckMaxLives(Scorer) )
	{
		return false;
	}

	if ( Scorer != None )
	{
	    /*
		if ( bScoreDeaths && (GoalScore > 0) )
		{
			if ( Scorer.Score == GoalScore - 10 )
			{
				if ( !bPlayedTenKills && (GoalScore > 19) )
				{
					TMGameReplicationInfo(GameReplicationInfo).SortPRIArray();
					if ( Scorer == GameReplicationInfo.PRIArray[0] )
					{
						bPlayedTenKills = true;
						BroadcastLocalized(self,class'TMKillsRemainingMessage', 0);
					}
				}
			}
			else if ( Scorer.Score == GoalScore - 5 )
			{
				if ( !bPlayedFiveKills && (GoalScore > 9) )
				{
					TMGameReplicationInfo(GameReplicationInfo).SortPRIArray();
					if ( Scorer == GameReplicationInfo.PRIArray[0] )
					{
						bPlayedFiveKills = true;
						BroadcastLocalized(self,class'TMKillsRemainingMessage', 1);
					}
				}
			}
			else if ( (Scorer.Score == GoalScore - 1) && !bPlayedOneKill )
			{
				TMGameReplicationInfo(GameReplicationInfo).SortPRIArray();
				if ( Scorer == GameReplicationInfo.PRIArray[0] )
				{
					bPlayedOneKill = true;
					BroadcastLocalized(self,class'TMKillsRemainingMessage', 2);
				}
			}
		}*/

		if ( (GoalScore > 0) && (Scorer.Score >= GoalScore) )  //????
		{
			EndGame(Scorer,"fraglimit");
		}
		else if ( bOverTime )   //???GameInfo::EndGame????True
		{
			// end game only if scorer has highest score
			foreach WorldInfo.AllControllers(class'Controller', C)
			{
				if ( (C.PlayerReplicationInfo != None)
					&& (C.PlayerReplicationInfo != Scorer)
					&& (C.PlayerReplicationInfo.Score >= Scorer.Score) )
				{
					return false;
				}
			}
			EndGame(Scorer,"fraglimit");
		}
	}

	return true;
}

// check if all other players are out
//function bool CheckMaxLives(PlayerReplicationInfo Scorer);

// End of game.
//function EndGame(PlayerReplicationInfo Winner, string Reason );

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Controller P;
	local bool bLastMan;

	if ( bOverTime )
	{
		if ( Numbots + NumPlayers == 0 )
			return true;
		bLastMan = true;
		foreach WorldInfo.AllControllers(class'Controller', P)
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

	if ( !bLastMan && CheckModifiedEndGame(Winner, Reason) )
		return false;

	if ( Winner == None )
	{
		// find winner
		foreach WorldInfo.AllControllers(class'Controller', P)
		{
			if ( P.bIsPlayer && !P.PlayerReplicationInfo.bOutOfLives
				&& ((Winner == None) || (P.PlayerReplicationInfo.Score >= Winner.Score)) )
			{
				Winner = P.PlayerReplicationInfo;
			}
		}
	}

	// check for tie
	if ( !bLastMan )
	{
		foreach WorldInfo.AllControllers(class'Controller', P)
		{
			if ( P.bIsPlayer &&
				(Winner != P.PlayerReplicationInfo) &&
				(P.PlayerReplicationInfo.Score == Winner.Score)
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

	EndTime = WorldInfo.TimeSeconds + EndTimeDelay;
	GameReplicationInfo.Winner = Winner;

	SetEndGameFocus(Winner);
	return true;
}

