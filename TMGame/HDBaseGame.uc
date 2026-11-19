//-----------------------------------------------------------
//  ????????????GameInfo?????
//-----------------------------------------------------------
class HDBaseGame extends GameInfo
    native;

var bool                bKismetWaitToStartMatch;

var bool                bMatchingWeaponSwitch;       // add by WK: in sp game, it will be 'false' for switching weapon no limited, and in mp game, 'true' for switching weapon matching with EHDWeaponType

var int                 ConventionalWeaponCount; // add by WK: 1 in trainning mode, 2 in mp mode, 3 in sp mode
var int                 SpecialWeaponCount;
var int                 GrenadeTypeCount;

var transient   bool    bPendingMatch;  // add by WK: in sp game, while pending match, using this flag for disable weapon sounds

/** If true, look for nearby weaponlocker weapons */
var bool bStartWithLockerWeaps;

//[TJJ ADD: Implement LAN game.

/** Store the game settings for function CreateLanGame */
var TMGameSettingsCommon 	LanGameSettings;

/** Store the search result for function SearchLanGame */
var OnlineGameSearch		LanGameSearch;

/** Default session name used to create, join and search online games. */
var const Name				DefaultSessionName;

/** Delegate for notifying UI to refresh LAN game list */
delegate OnLanGameSearchEnded( OnlineGameSearch InGameSearch, bool InIsSucceeded );


function ActivateVehicleFactory(TMVehicleFactory VF)
{
	local TMGameObjective O, Best;
	local float BestDist, NewDist;

	if ( !bTeamGame )
		VF.bStartNeutral = true;
	if ( VF.bStartNeutral )
	{
		VF.Activate(255);
	}
	else
	{
		ForEach WorldInfo.AllNavigationPoints(class'TMGameObjective',O)
		{
			NewDist = VSize(VF.Location - O.Location);
			if ( (Best == None) || (NewDist < BestDist) )
			{
				Best = O;
				BestDist = NewDist;
			}
		}

		if ( Best != None )
			VF.Activate(Best.DefenderTeamIndex);
		else
			VF.Activate(255);
	}
}
//TJJ]


/**
  * Allows overriding of which gameinfo class to use.
  * Called on the DefaultGameType from the ini, or the one specified on the command line (?game=xxx)
  */
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
  	local string ThisMapPrefix;
	local int pos;
	local string GameOption;

    //Main Menue
	if(Left(MapName, 9) ~= "EnvyEntry" || Left(MapName, 10) ~= "TMFrontEnd")
	{
		return class'HDEntryGame';
	}

	// allow commandline to override game type setting
	GameOption = ParseOption(Options, "Game");
	if(GameOption != "" && GameOption != " ")
	{
	    ;

	    if(GameOption ~= "TGGameSP_Sniper")
	        return class'TGGameSP_Sniper';

		return Default.class;
	}

	// strip the UEDPIE_ from the filename, if it exists (meaning this is a Play in Editor game)
	if( Left(MapName, 6) ~= "UEDPIE" )
	{
		MapName = Right(MapName, Len(MapName) - 6);
	}
	else if( Left(MapName, 5) ~= "UEDPC" )
	{
		MapName = Right(MapName, Len(MapName) - 5);
	}

	// replace self with appropriate gametype if no game specified
	pos = InStr(MapName, "-");
	ThisMapPrefix = left(MapName, pos);

	if(ThisMapPrefix ~= "TMSP")
        return class'TGGameSP_Base';
	else if(ThisMapPrefix ~= "HDFLY")
        return class'PlayerCollectorGame';
    else if(ThisMapPrefix ~= "TMTP")
        return class'TGGameSP_Train';


    return class'HDDeathmatch';
}

function AddDefaultInventory( pawn PlayerPawn )
{
	super.AddDefaultInventory(PlayerPawn);
}


//
//[TJJ ADD: Implement LAN game.
//

/**
 * Create a LAN game.
 *
 */
exec function CreateLanGame(
								string 	InMapName,
								string 	InServerName,
								string	InGame,
					optional	int		InGoalScore = 20,
					optional	int		InTimeLimit = 2,
					optional 	int 	InNumPlayersInEachTeam = 1,
					optional	int		InRespawnTime = 5,
					optional	bool	InBalanceTeams = true,
					optional 	int 	InTeam = 0,
					optional	int		InCharacter = 0,
					optional	int		InSpectatorOnly = 0 )
{
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();
	if (OS != None)
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if (GI != None)
		{
			if( LanGameSettings == None )
			{
				LanGameSettings = new class'TMGameSettingsCommon';
			}

			LanGameSettings.NumPrivateConnections = 0;
			LanGameSettings.NumPublicConnections = InNumPlayersInEachTeam * 2;
			LanGameSettings.MinNetPlayers = 1; //InNumPlayersInEachTeam * 2;
			LanGameSettings.bIsLanMatch = true;
			LanGameSettings.bShouldAdvertise = true;
			LanGameSettings.bAllowJoinInProgress = !( InGame ~= "TMGame.HDFightToDeath" );
			LanGameSettings.bIsDedicated = false;
			LanGameSettings.MapName = Len( InMapName ) > 0 ? InMapName : "MP_TestMap";
			LanGameSettings.Game = Len( InGame ) > 0 ? InGame : "TMGame.HDTeamDeathMatch";

			LanGameSettings.OwningPlayerName = InServerName;
			LanGameSettings.Team = InTeam;
			LanGameSettings.Character = InCharacter;
			LanGameSettings.SpectatorOnly = InSpectatorOnly;
			LanGameSettings.TimeLimit = InTimeLimit;
			LanGameSettings.GoalScore = InGoalScore;
			LanGameSettings.RespawnTime = InRespawnTime;
			LanGameSettings.BalanceTeams = InBalanceTeams;

       		;

			// Start the async task
			GI.AddCreateOnlineGameCompleteDelegate(OnLanGameCreated);
			GI.CreateOnlineGame( 0, DefaultSessionName, LanGameSettings );
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}

/**
 * Callback when LAN game created. This function will start to travel to new map.
 *
 */
function OnLanGameCreated( name SessionName, bool bWasSuccessful )
{
	local string TravelURL;
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;
    local LoginPlayerInfo 		PlayerInfo;
	local LoginPlayerManager 	PlayerManager;

	PlayerManager = class'GameEngine'.static.GetPlayerManager();

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();
	if (OS != None)
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if (GI != None)
		{
			// Clear the delegate we set.
			GI.ClearCreateOnlineGameCompleteDelegate( OnLanGameCreated );

			// If we were successful, then travel.
			if( bWasSuccessful )
			{
				playerInfo = PlayerManager.getPlayer( PlayerManager.currentPlayerName );

				// append options from the OnlineGameSettings class
				LanGameSettings.BuildURL(TravelURL);

				TravelURL = "open " $ LanGameSettings.MapName $ TravelURL
					$ "?Name=" $ PlayerManager.currentPlayerName
					$ "?Rank=" $ playerInfo.RankLevel
					$ "?ForceRespawn=true?listen";

				;

				// Do the server travel.
				ConsoleCommand(TravelURL);
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}


/**
 * Search LAN games.
 *
 */
exec function SearchLanGame()
{
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();
	if (OS != None)
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if (GI != None)
		{
			if( LanGameSearch == none )
			{
				LanGameSearch = new class'OnlineGameSearch';
			}

			if( LanGameSearch.bIsSearchInProgress )
			{
				;
				return;
			}

			LanGameSearch.MaxSearchResults = 20;
			LanGameSearch.bIsLanQuery = true;

			// Start the async task
			GI.AddFindOnlineGamesCompleteDelegate(OnSearchComplete);
			GI.FindOnlineGames( 0, LanGameSearch );
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}

/**
 * Called by the online subsystem when the game search has completed
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnSearchComplete( bool bWasSuccessful )
{
	local OnlineGameSearchResult result;
	local int index;
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();

	if( OS != None )
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if( GI != None )
		{
			GI.ClearFindOnlineGamesCompleteDelegate( OnSearchComplete );

			if (bWasSuccessful == true)
			{
				OnLanGameSearchEnded( LanGameSearch, true );

				foreach LanGameSearch.Results( result, index )
				{
		   			;
				}

				if( LanGameSearch.Results.Length == 0 )
				{
					;
				}

				return;
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}

	OnLanGameSearchEnded( none, false );
}


/**
 * Query LAN game info from a specified IP.
 *
 */
exec function bool QueryLanGame( string InGameIP )
{
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();
	if (OS != None)
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if (GI != None)
		{
			if( LanGameSearch == none )
			{
				LanGameSearch = new class'OnlineGameSearch';
			}

			if( LanGameSearch.bIsSearchInProgress )
			{
				;
				return false;
			}

			LanGameSearch.MaxSearchResults = 1;
			LanGameSearch.bIsLanQuery = true;

			// Start the async task
			GI.AddFindOnlineGamesCompleteDelegate( OnSearchComplete );
			if( GI.FindSpecifiedOnlineGame( InGameIP, LanGameSearch ) == true )
			{
				return true;
			}
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}

	return false;
}

/**
 * Join a LAN game base on the index in variable LanGameSearch.
 *
 */
exec function JoinLanGame(
								int InSessionId,
					optional 	int InTeam = 0,
					optional 	int InCharacter = 0,
					optional 	int InSpectatorOnly = 0 )
{
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;
	local OnlineGameSearchResult GameToJoin;

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();

	if( OS != None )
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if( GI != None )
		{
			if( LanGameSearch == none || InSessionId < 0 || InSessionId >= LanGameSearch.Results.Length )
			{
				;
				return;
			}

			GameToJoin = LanGameSearch.Results[ InSessionId ];
			GameToJoin.GameSettings.Team = InTeam;
			GameToJoin.GameSettings.Character = InCharacter;
			GameToJoin.GameSettings.SpectatorOnly = InSpectatorOnly;

			;

			// Start the async task
			GI.AddJoinOnlineGameCompleteDelegate( OnJoinLanGameComplete );
			GI.JoinOnlineGame( 0, DefaultSessionName, GameToJoin );
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}


/** Callback for when the join completes. */
function OnJoinLanGameComplete(name SessionName,bool bSuccessful)
{
	local string URL;
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;
	local LoginPlayerManager 	PlayerManager;
	local LoginPlayerInfo		PlayerInfo;

	PlayerManager = class'GameEngine'.static.GetPlayerManager();

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();

	if( OS != None )
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if( GI != None )
		{
		 	// Remove the delegate from the list
			GI.ClearJoinOnlineGameCompleteDelegate( OnJoinLanGameComplete );

			if (bSuccessful)
			{
				// Get the platform specific information
				if( GI.GetResolvedConnectString( 'Game', URL ) )
				{
					playerInfo = PlayerManager.getPlayer( PlayerManager.currentPlayerName );

					URL = "open " $ URL
						$ "?Name=" $ playerManager.currentPlayerName
						$ "?Rank=" $ playerInfo.RankLevel;

					;

					// Get the resolved URL and build the part to start it
					ConsoleCommand( URL );
				}
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}


/**
 * Destroy current hosted LAN game.
 *
 */
exec function DestroyCurrentLanGame()
{
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();

	if( OS != None )
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if( GI != None )
		{
			;

			// Start the async task
			GI.AddDestroyOnlineGameCompleteDelegate( OnDestroyCurrentLanGameComplete );
			GI.DestroyOnlineGame( DefaultSessionName );
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}


/** Callback for when the join completes. */
function OnDestroyCurrentLanGameComplete(name SessionName,bool bSuccessful)
{
	//local string URL;
	local OnlineSubsystem OS;
	local OnlineGameInterface GI;

	// Figure out if we have an online subsystem registered
	OS = class'GameEngine'.static.GetOnlineSubsystem();

	if( OS != None )
	{
		// Grab the game interface to verify the subsystem supports it
		GI = OS.GameInterface;
		if( GI != None )
		{
		 	// Remove the delegate from the list
			GI.ClearDestroyOnlineGameCompleteDelegate( OnDestroyCurrentLanGameComplete );

			if (bSuccessful)
			{
				;
			}
			else
			{
				;
			}
		}
		else
		{
			;
		}
	}
	else
	{
		;
	}
}

//
//TJJ]
//


