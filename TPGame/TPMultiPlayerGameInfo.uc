
class TPMultiPlayerGameInfo extends TPGameInfo
	dependson(TPAchievements)
	config(Game);

/** Voice channels used by these game types */
enum EVoiceChannel
{
	VC_SpectatorsDead,
	VC_Team1,
	VC_Team2
};

var NavigationPoint LastPlayerStartSpot;    // last place current player looking for start spot started from
var NavigationPoint LastStartSpot;          // last place any player started from

/** Total number of teams to create */
var byte NumTeams;
/** List of currently active teams */
var array<TPTeamInfo> Teams;

var bool bLoaded;
var bool overtime;							// True if we are in overtime mode ( tie between at least 2 teams(TDM) or players (DM) when time is up )
var int preGameTimer;
var int scoreLimitBackup;
var bool AllowAchievements;

const TIME_IN_PRE_GAME = 5;

enum MultiplayerGameState
{
	MPState_Lobby,
	MPState_PreGame,
	MPState_Game,
	MPState_PostGame,
};

//struct WeaponList
//{
//	var() array<string> WeaponClassList;
//};
//var const array<WeaponList> LoadedWeaponList;

var class<Inventory> Test;

var TPGameReplicationInfo TPGRI;

// Is this a dedicated server?
var bool bIsDedicatedListenServer;

// Minimum number of players before we can start the match
var() config int MinPlayers;
// Minimum number of ranked players before we can start the match
var() config int MinRankedPlayers;

// Tells the game to skip the lobby if we login with ?SkipLobby
var bool bSkipLobby;

var bool bLobbyCountingDown;
var config float LobbyCountDownTime;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	GameReplicationInfo.RemainingTime = TimeLimit * 60;
}

function bool ShowLobby(TPPlayerController LobbyTarget)
{
	return !bSkipLobby;
}

function TurnOffOvertime()
{
	if ( overtime )
	{
		;
		;
		;
		;
		overtime = false;
		GameReplicationInfo.GoalScore = scoreLimitBackup;
		GoalScore = GameReplicationInfo.GoalScore;
		
	}
}
function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	local TPPlayerController PC;

	GetGRI().SetGameStatus(GS_Loading);
	
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.ClientLoadingScreen(true);
	}
	Super.ProcessServerTravel(URL, bAbsolute);
}

function ChangeClientGameState( MultiplayerGameState gameState)
{
	local TPPlayerController PC;

	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.SetMPGameState( gameState );
	}
}

function Reset()
{
	super.Reset();

	GotoState('PendingMatch');
}

function InitGameReplicationInfo()

{
	Super.InitGameReplicationInfo();
	TPGRI = GetGRI();
    GameReplicationInfo.GoalScore = GoalScore;
    GameReplicationInfo.TimeLimit = TimeLimit;

}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	local int i;

	Super.GetSeamlessTravelActorList(bToEntry, ActorList);

	for (i = 0; i < Teams.length; i++)
	{
		ActorList[ActorList.length] = Teams[i];
	}
}

event PostSeamlessTravel()
{
	InitializeTeams();

	Super.PostSeamlessTravel();
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	local TPPlayerController PC;
	local TeamInfo NewTeam;

	if (C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.Team != None && C.PlayerReplicationInfo.Team.TeamIndex < Teams.length)
	{
		// move this player to the new team object with the same team index
		NewTeam = Teams[C.PlayerReplicationInfo.Team.TeamIndex];
		// if the old team would now be empty, we don't need it anymore, so destroy it
		if (C.PlayerReplicationInfo.Team.Size <= 1)
		{
			C.PlayerReplicationInfo.Team.Destroy();
		}
		else
		{
			C.PlayerReplicationInfo.Team.RemoveFromTeam(C);
		}
		NewTeam.AddToTeam(C);
	}

	Super.HandleSeamlessTravelPlayer(C);

	PC = TPPlayerController(C);
	if (PC != none && !bSkipLobby)
	{
		//PC.ClientLoadingScreen(false);
		//`log("PreRound Called");
		//TPGRI.SetGameStatus(GS_Lobby);
		//GotoState('PendingMatch');
		HandleLobby( PC );
	}

	PC.ClientSetScoreboard(bTeamGame);
}

function string GetNextMap()
{
	local PlayerController PC;
	local TPPlayerController TPC;
	local LocalPlayer Player;
	//local string NextMap;

	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		TPC = TPPlayerController(PC);
		if (TPC != None && TPC.ProfileSettings != None)
		{
			Player = LocalPlayer(TPC.Player);
			if (Player != None && Player.GamePlayers.Find(Player) == 0)
			{
				;
				return GameHostURL;
			}
		}
	}

	return "";
}

function KillRemainingPlayers()
{
	local Controller Player;
	local PlayerController PC;
	local Pawn OldPawn;

	// kill any players currently alive
	foreach WorldInfo.AllControllers(class'Controller', Player)
	{
		if (Player.Pawn != None)
		{
			OldPawn = Player.Pawn;

			// stop any weapons fire
			Player.Pawn.StopFiring();
			// detach the pawn from the controller so that they don't stay around until the next match
			Player.UnPossess();
		
			if ( PlayerPawn(OldPawn) != None )
			{
				OldPawn.Destroy();
			}

		}
		
		// send players to waiting state
		PC = PlayerController(Player);
		if (PC != None)
		{
			// Clear out the player's score.
			PC.PlayerReplicationInfo.Reset();

			// If in a team game, make sure to change back to a neutral team as the game is over.
			if ( bTeamGame )
				ChangeTeam(PC, 255, true);

			PC.ClientReset();
			PC.Reset();
			// Allow everyone to talk during map travel
		}
	}

	// Destroy all pawns that may not be attached to controllers.
	foreach WorldInfo.AllPawns(class'Pawn', OldPawn)
	{
		OldPawn.Destroy();
	}
}

function DestroyWeapons()
{
	local TPDroppedPickup pickup;
	local PhysicsGrenade aGrenade;

	foreach AllActors(class'PhysicsGrenade', aGrenade)
	{
		aGrenade.Destroy();	
	}

	foreach AllActors(class'TPDroppedPickup', pickup)
	{
		pickup.Destroy();
	}
}

auto State PendingMatch
{
	function StartMatch()
	{
		if (bUsingArbitration)
		{
			//`log("bUsingArbitration");
			StartArbitrationRegistration();
		}
		else
		{
			Global.StartMatch();
			//TPGRI.SetGameStatus(GS_PreGame);
			//GotoState('PreRound');
		}
	}

	function StartArbitrationRegistration()
	{
		local PlayerController PC;
		local UniqueNetId HostId;

		if (!bHasArbitratedHandshakeBegun)
		{
			// Tell PreLogin() to reject new connections
			bHasArbitratedHandshakeBegun = true;

			// Find the host's net id
			foreach LocalPlayerControllers(class'PlayerController', PC)
			{
				HostId = PC.PlayerReplicationInfo.UniqueId;
				break;
			}

			PendingArbitrationPCs.Length = 0;
			// Iterate the controller list and tell them to register with arbitration
			foreach WorldInfo.AllControllers(class'PlayerController', PC)
			{
				// Skip notifying local PCs as they are handled automatically
				if (!PC.IsLocalPlayerController())
				{
					PC.ClientSetHostUniqueId(HostId);
					PC.ClientRegisterForArbitration();
					// Add to the pending list
					PendingArbitrationPCs[PendingArbitrationPCs.Length] = PC;
				}
				else
				{
					// Add them as having completed arbitration
					ArbitrationPCs[ArbitrationPCs.Length] = PC;
				}
			}
			// Start the kick timer
			SetTimer(ArbitrationHandshakeTimeout,false,'ArbitrationTimeout');
		}
	}

	/**
	 * Does the registration for the server. This must be done last as it
	 * includes all the players info from their registration
	 */
	function RegisterServerForArbitration()
	{
		if (GameInterface != None)
		{
			GameInterface.AddArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
			GameInterface.RegisterForArbitration();
		}
		else
		{
			// Fake as working without subsystem
			ArbitrationRegistrationComplete(true);
		}
	}

	/**
	 * Callback from the server that starts the match if the registration was
	 * successful. If not, it goes back to the menu
	 *
	 * @param bWasSuccessful whether the registration worked or not
	 */
	function ArbitrationRegistrationComplete(bool bWasSuccessful)
	{
		// Clear the delegate so we don't leak with GC
		GameInterface.AddArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
		if (bWasSuccessful)
		{
			// Start the match
			StartArbitratedMatch();
		}
		else
		{
			ConsoleCommand("Disconnect");
		}
	}

	/**
	 * Handles kicking any clients that haven't completed handshaking
	 */
	function ArbitrationTimeout()
	{
		local int Index;

		// Kick any pending players
		for (Index = 0; Index < PendingArbitrationPCs.Length; Index++)
		{
			AccessControl.KickPlayer(PendingArbitrationPCs[Index],GameMessageClass.Default.MaxedOutMessage);
		}
		PendingArbitrationPCs.Length = 0;
		// Do the server registration now that any remaining clients are kicked
		RegisterServerForArbitration();
	}

	function StartArbitratedMatch()
	{
		bNeedsEndGameHandshake = true;
		// Start the match
		Global.StartMatch();
	}

	/**
	 * Removes the player controller from the pending list. Kicks that PC if it
	 * failed to register for arbitration. Starts the match if all clients have
	 * completed their registration
	 *
	 * @param PC the player controller to mark as done
	 * @param bWasSuccessful whether the PC was able to register for arbitration or not
	 */
	function ProcessClientRegistrationCompletion(PlayerController PC,bool bWasSuccessful)
	{
		local int FoundIndex;

		// Search for the specified PC and remove if found
		FoundIndex = PendingArbitrationPCs.Find(PC);
		if (FoundIndex != INDEX_NONE)
		{
			PendingArbitrationPCs.Remove(FoundIndex,1);
			if (bWasSuccessful)
			{
				// Add to the completed list
				ArbitrationPCs[ArbitrationPCs.Length] = PC;
			}
			else
			{
				AccessControl.KickPlayer(PC,GameMessageClass.Default.MaxedOutMessage);
			}
		}
		// Start the match if all clients have responded
		if (PendingArbitrationPCs.Length == 0)
		{
			// Clear the kick timer
			SetTimer(0,false,'ArbitrationTimeout');
			RegisterServerForArbitration();
		}
	}

	function BeginState( Name PreviousStateName )
	{
		// Don't put code in here until we figure out "Out of order" game state issues in MP	
		if (!bSkipLobby)
		{
			KillRemainingPlayers();
			DestroyWeapons();
			TPGRI.SetGameStatus(GS_Lobby);
		}

		SetTimer(WorldInfo.TimeDilation, true);
	}
	function Timer()
	{
		ResetGameplayMuting();
	}
	function EndState( Name NextStateName)
	{
		local TPPlayerController tPC;
		local TPPawn							tPP;
		local TPInventoryManager				tPI;

		//if (!bSkipLobby )
		//	RestartGame();

		ClearTimer();

		SetTimer(0,false,'ArbitrationTimeout');

		if( GameInterface != None )
		{
			GameInterface.ClearArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
		}

		foreach WorldInfo.AllControllers(class'TPPlayerController', tPC)
		{
			// Destroy all of the player's inventory without dropping it in the world
			tPP = TPPawn(tPC.Pawn);
			tPI = TPInventoryManager(tPP.InvManager);
			tPI.noDrop = true;
			tPI.DiscardInventory();
			
			// Respawn the Player
			tPC.Unpossess();
			// tPC.Pawn is no longer valid
			tPP.Destroy();
			RestartPlayer(tPC);		
			InitTeamMuteList(tPC);
		}

	}
	function bool PlayersAreReady()
	{
		local PlayerController PC;
		local TPPlayerReplicationInfo PRI;
		local bool bHostReady, bReady;
		local int ReadyCount;

		bReady = false;
		bHostReady = false;

		foreach WorldInfo.AllControllers(class'PlayerController',PC)
		{
			PRI = TPPlayerReplicationInfo(PC.PlayerReplicationInfo);
			if (PRI.bReadyToPlay)
				ReadyCount++;

			if (PRI.bHostIsReady)
			{
				bHostReady = true;
			}
		}

		if (ReadyCount / NumPlayers > 0.66)
		{
			bReady = true;
		}
		
		return bReady && bHostReady;
	}

	function bool CheckMinPlayersNeeded()
	{
		// if a ranked match
		if ( WorldInfo.Game.bUsingArbitration )
		{
			// check for min players needed for a ranked match
			if ( NumPlayers >= MinRankedPlayers )
			{
				return true;
			}
		}
		// non ranked match
		else
		{
			// check for min players needed for a nonranked match
			if ( NumPlayers >= MinPlayers )
			{
				return true;
			}
		}
		
		return false;
	}

	function CheckStartMatch()
	{
		
		if (bSkipLobby && Role == Role_Authority)
		{
			;
			;
			;

			StartMatch();
			return;
		}

		if ( CheckMinPlayersNeeded() ) // Immediately reject the count-down if not enough players
		{
			TPGRI.bHasEnoughPlayers = true;

			//`log("Min Success");

			if ( bIsDedicatedListenServer || WorldInfo.NetMode != NM_ListenServer )
			{
				// If time has run out, we auto-start

				if ( PlayersAreReady()  )	// If all the players are ready, begin the countdown...
				{
					bLobbyCountingDown = true;
					;
					;
					;

					StartMatch();
					//TPGRI.SetGameStatus(GS_PreGame);
					//GotoState('PreRound');
				}
			}
			else	// Otherwise just check the players
			{
				if ( PlayersAreReady() )
				{
					bLobbyCountingDown = true;
					//`log("Players Are Ready");
					/*`log("========= ERROR =============");
					`log("PendingMatch::CheckStartMatch() - CheckMinPlayersNeeded Secondary Start.  Investigate if this is called.");
					`log("========= ERROR =============");*/

					StartMatch();
					//TPGRI.SetGameStatus(GS_PreGame);
					//GotoState('PreRound');
				}
			}
		}
		else
		{
			TPGRI.bHasEnoughPlayers = false;
		}
	}
Begin:
	CheckStartMatch();
	Sleep(0.2f);	// Up the frequency so it's more responsive since we aren't doing actual timing here
	Goto('Begin');
}

State PreRound
{
	// Cleans up all dead bodies in the level after warmup has completed and the game is about to start.
	function DestroyCorpses()
	{
		local MultiplayerPawn mPP;
		foreach AllActors(class'MultiplayerPawn', mPP)
		{
			// I need to go through the player's inventorys and destory them as well...
			mPP.Destroy();
		}
	}

	function DestroyWeapons()
	{
		local TPDroppedPickup pickup;
		foreach AllActors(class'TPDroppedPickup', pickup)
		{
			pickup.Destroy();
		}
	}
	function ResetPlayerData()
	{
		
	}

	function Timer()
	{
		SyncClientTime();

		if ( GameReplicationInfo.RemainingTime > 0 )
		{
			// Destroy all things in the world ( weapons, corpses, etc. )
			DestroyCorpses();
			StartMatch();
			DestroyWeapons();
		}
		else
			GameReplicationInfo.RemainingTime++;
	}
	
Begin:
		AllowAchievements = true;
		;
		TPGRI.SetGameStatus(GS_PreGame);
		//ChangeClientGameState(MPState_PreGame);
		SetTimer(WorldInfo.TimeDilation, true);
		GameReplicationInfo.RemainingTime = -TIME_IN_PRE_GAME;
		SyncClientTime();
}

State PostGame
{
	// Return to the lobby after completing a game.
	function ReturnToLobby(  )
	{
		local TPPlayerController PC;
		bSkipLobby = false;

		if (!bUsingArbitration)
		{
			;
			;
			;

			Reset();

			//// Allow everyone to talk during map travel
			//ResetGameplayMuting();

			// Each player must migrate to the lobby
			foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
			{
				HandleLobby( PC );
			}
		}
		else
		{
			// Kick everyone to the main menu.
			RestartGame();
		}
	}

	function Timer()
	{
		SyncClientTime();

		if (GameReplicationInfo.RemainingTime <= 0)
		{
			GameReplicationInfo.RemainingTime = 0;
			ClearTimer();
			ReturnToLobby();
			return;
		}
		GameReplicationInfo.RemainingTime--;
	}

	function BeginState( Name PreviousStateName )
	{
		// Allow everyone to talk during map travel
		ResetGameplayMuting();
	}

Begin:
	//KillRemainingPlayers();
	TPGRI.SetGameStatus(GS_PostGame);
	//sleep(10);	// Change this to designer tunable variable for how long we keep the scoreboard up after a game has completed.
	GameReplicationInfo.RemainingTime = MatchResetTime;
	SetTimer(WorldInfo.TimeDilation, true);
	//TPGRI.SetGameStatus(GS_PostGame);

	
}

exec function CheatGameSpeed(float T)
{
	Super.SetGameSpeed(T);
}

function SetGameSpeed( Float T )
{
    SetTimer(WorldInfo.TimeDilation, true);
}

// Parse options for this game...
event InitGame( string Options, out string ErrorMessage )
{
    Super.InitGame(Options, ErrorMessage);
}

function RegisterServer()
{
	// Test
	;
}

event PlayerController Login
(
	string Portal,
	string Options,
	out string ErrorMessage
)
{
	local TPPlayerController NewPlayer;
	local string InOpt;

	// if this is the first player, and he has the dedicated server option, mark him as such and force to be spectator
	if (HasOption(Options, "dedicated"))
	{
		bIsDedicatedListenServer = true;
		Options $= "?SpectatorOnly=1";
	}

	if (HasOption(Options, "GoalScore"))
	{
		GoalScore = GetIntOption( Options, "GoalScore", GoalScore );
		TPGRI.GoalScore = GoalScore;
		TimeLimit = GetIntOption( Options, "TimeLimit", TimeLimit );
		TPGRI.TimeLimit = TimeLimit;
	}

	if (HasOption(Options, "failed") )
	{
		;
	}
	if (HasOption(Options, "closed") )
	{
		;
	}

	// Check for skipping lobby
	if (HasOption(Options, "SkipLobby") )
	{
		bSkipLobby = true;
	}

	// Check to see if we have an open slot
	if (GameSettings != None)
	{
		if (HasOption(Options, "bIsFromInvite") || GameSettings.NumPublicConnections == 0)
		{
			// Can take either private or public slots
			if (GameSettings.NumOpenPrivateConnections == 0 && GameSettings.NumOpenPublicConnections == 0)
			{
				ErrorMessage = GameMessageClass.Default.MaxedOutMessage;
				return None;
			}
			else
			{
				if (GameSettings.NumOpenPrivateConnections > 0)
				{
					GameSettings.NumOpenPrivateConnections--;
				}
				else
				{
					GameSettings.NumOpenPublicConnections--;
				}
			}
		}
		else
		{
			// Check public slots
			if (GameSettings.NumOpenPublicConnections == 0)
			{
				ErrorMessage = GameMessageClass.Default.MaxedOutMessage;
				return None;
			}
			else
			{
				GameSettings.NumOpenPublicConnections--;
			}
		}
	}

	NewPlayer = TPPlayerController( super.Login(Portal, Options, ErrorMessage) );

	if ( NewPlayer == None )
		GameSettings.NumOpenPublicConnections++;

	InOpt = ParseOption( Options, "Character");
	if ( InOpt != "" )
	{
		TPPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).CharacterInfo.CharacterClass = InOpt;
	}

	// In Deathmatch, simply assign the player's team ID to his player ID on login.  Team DM will handle team selection via lobby.
	if ( !bTeamGame )
	{
		NewPlayer.PlayerReplicationInfo.TeamID = NewPlayer.PlayerReplicationInfo.PlayerID;
	}
	else
	{
		if ( TPGRI.GameStatus >= GS_PreGame )
		{
			BalanceOutTeam(NewPlayer);
		}
	}
	
	if (HasOption(Options, "MapCycle"))
	{
		GameHostURL = ParseOption( Options, "MapCycle");
		/*if (TPGRI != none)
		{
			TPGRI.SetGameStatus(GS_PreGame);
		}*/
	}

	;
	// Parse out the player's settings
	//NewPlayer.connectInfo.AxisMesh	= GetIntOption(Options, "AxisMesh", 0);
	//NewPlayer.connectInfo.AxisWeap	= GetIntOption(Options, "AxisWeap", 0);
	//NewPlayer.connectInfo.AllyMesh	= GetIntOption(Options, "AllyMesh", 0);
	//NewPlayer.connectInfo.AllyWeap	= GetIntOption(Options, "AllyWeap", 0);
	//NewPlayer.connectInfo.DMMesh	= GetIntOption(Options, "DMMesh", 0);
	//NewPlayer.connectInfo.DMWeap	= GetIntOption(Options, "DMWeap", 0);

	//// Send them back to the client so that he starts off with the correct settings if he chooses to modify them in the lobby
	//NewPlayer.ClientUpdateConnectionInfo(	NewPlayer.connectInfo.AxisMesh, NewPlayer.connectInfo.AxisWeap, 
	//										NewPlayer.connectInfo.AllyMesh, NewPlayer.connectInfo.AllyWeap, 
	//										NewPlayer.connectInfo.DMMesh,	NewPlayer.connectInfo.DMWeap	);

	/*if (NewPlayer.ProfileSettings.PlayedAllMPMaps())
		NewPlayer.ClientUnlockAchievement(TA_WORLDTOUR);*/

	return NewPlayer;
}

function Logout( Controller Exiting )
{
	super.LogOut(Exiting);
	//BroadcastLocalized(self, GameMessageClass, 4, Exiting.PlayerReplicationInfo);
	;
}

event PostLogin( PlayerController NewPlayer )
{
	Super.PostLogin(NewPlayer);

	;

	//BroadcastLocalized(self, GameMessageClass, 1, NewPlayer.PlayerReplicationInfo);

	// Check to see if we can communicate
	/*if (!bRequiresPushToTalk)
		NewPlayer.ClientStartNetworkedVoice();	*/

	TPPlayerController(NewPlayer).ClientSetScoreboard(bTeamGame);
}

function BalanceOutTeam(PlayerController PC)
{
	local int i, NumPartisans, NumNazis;
	local TPPlayerReplicationInfo PRI;
	
	if ( TPGRI != None )
	{
		// calculate how many players are logged in
		for ( i = 0; i < TPGRI.PRIArray.Length; i++ )
		{
			PRI = TPPlayerReplicationInfo( TPGRI.PRIArray[i] );
			if ( PRI != None )
			{
				if ( PRI.Team.TeamIndex == 0 )
				{
					NumPartisans++;
				}
				else if ( PRI.Team.TeamIndex == 1 )
				{
					NumNazis++;
				}
			}
		}
	}

	if (NumPartisans > NumNazis) 
		ChangeTeam(PC, 1, false);
	else
		ChangeTeam(PC, 0, false);
}

final function InitializeTeams()
{
	local int idx;
	// initialize all the teams
	for (idx = 0; idx < NumTeams; idx++)
	{
		Teams[idx] = Spawn(class'TPTeamInfo',self);
		Teams[idx].TeamIndex = idx;
	}
}

/**
 * Handles moving players from one team to another, or for the initial
 * team assignment.
 * 
 * @return	true if the team change was successful
 */
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local class<TPPawn> PClass;

	// check to see if we need to initialize teams
	if (Teams.Length < NumTeams)
	{
		InitializeTeams();
	}
	if (Other != None)
	{
		// if not already on that team
		if (N == 255 || Other.PlayerReplicationInfo.Team == None ||
			Other.PlayerReplicationInfo.Team != Teams[N])
		{
			// remove from their current team
			if (Other.PlayerReplicationInfo.Team != None)
			{
				Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
			}

			if ( bNewTeam )
				RestartPlayer(Other);
			else
			{
				PClass = class<TPPawn>(FindObject("TPGame."$TPPlayerReplicationInfo(Other.PlayerReplicationInfo).CharacterInfo.CharacterClass, class'class'));
				if (PClass == none)
					PClass = class<TPPawn>(FindObject("TPGameContent."$TPPlayerReplicationInfo(Other.PlayerReplicationInfo).CharacterInfo.CharacterClass, class'class'));

				TPPlayerController(Other).SetSkeletalMesh(PClass);
			}

			if (N < 255)
			{
				if (Teams[N].AddToTeam(Other))
					return true;
				
				return false;

			}
			else
			{
				Other.PlayerReplicationInfo.Team = none;
			}
			// and attempt to add them to their new team
			return true;
		}
		else
		{
			return true;
		}
	}
	return false;
}

function RestartPlayer(Controller NewPlayer)
{
	local class<TPPawn>				PClass;						// Turning Point Classname for Pawn
	local TPPlayerController		tPC;						// Turning Point Controller
	local TPPlayerReplicationInfo	tPRI;						// Turning Point Player Replication Info (PRI)
	local string					tPCharInfoClass;			// Turning Point Character Info Class		

	super.RestartPlayer(NewPlayer);

	tPC		= TPPlayerController(NewPlayer);
	tPRI	= TPPlayerReplicationInfo(tPC.PlayerReplicationInfo);

	if (bTeamGame)
	{
		if ( tPC.Pawn.PlayerReplicationInfo.Team.TeamIndex == T_PARTISAN)
		{
			// Extract this player's default allied character
			tPRI.CharacterInfo = tPC.PartisanList[tPC.connectInfo.AllyMesh];	// make sure i don't have to reupdate the characterIndex on TPC
		}
		else
		{
			// Extract this player's default axis character
			tPRI.CharacterInfo = tPC.NaziList[tPC.connectInfo.AxisMesh];
		}
	}
	else
	{
		// Extract this player's default DM character
		if ( tPC.connectInfo.DMMesh > tPC.PartisanList.Length - 1)
		{
			tPRI.CharacterInfo = tPC.NaziList[tPC.connectInfo.DMMesh - tPC.PartisanList.Length ];

		}
		else
		{
			tPRI.CharacterInfo = tPC.PartisanList[tPC.connectInfo.DMMesh];
		}
		
	}

	tPCharInfoClass = tPRI.CharacterInfo.CharacterClass;
	;
	
	if ( Len( tPCharInfoClass ) > 0 )
	{
		PClass = class<TPPawn>(FindObject("TPGame." $ tPCharInfoClass, class'class'));
		if (PClass == none)
			PClass = class<TPPawn>(FindObject("TPGameContent." $ tPCharInfoClass, class'class'));
		if (PClass != none)
			tPC.SetSkeletalMesh(PClass);
	}
	
	InitTeamMuteList(tPC);

	// need to reset the damage post here yo
	PlayerPawn(NewPlayer.Pawn).UpdateDamagePostEffect();
}

// Player Can be restarted ?
function bool PlayerCanRestart( PlayerController aPlayer )
{
	return true;
}

function PlayerDeath(Controller C)
{
	// Investigate this.
	C.Pawn = none;
}

function AddDefaultInventory( Pawn P )
{
	if ( p.InvManager == none )
	{
		// Set up the pawn for adding default inventory.
		P.AddDefaultInventory();
		// Give him the inventory
		SetPlayerDefaults(P);
	}
	
}

function RecalculateSkillRating()
{
	local int Index;
	local array<UniqueNetId> Players;
	local UniqueNetId ZeroId;

	if (WorldInfo.NetMode != NM_Standalone &&
		OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		//Players.Insert(0, GameReplicationInfo.PRIArray.Length);

		// Iterate through the players adding their unique id for skill calculation
		for (Index = 0; Index < GameReplicationInfo.PRIArray.Length; Index++)
		{
			if (ZeroId != GameReplicationInfo.PRIArray[Index].UniqueId)
			{
				//Players[Players.Length] = GameReplicationInfo.PRIArray[Index].UniqueId;
				Players.AddItem(GameReplicationInfo.PRIArray[Index].UniqueId);
			}
		}
		// Update the skill rating with the list of players
		OnlineSub.GameInterface.RecalculateSkillRating(Players);
	}
}

function bool ProcessServerLogin()
{
	;
	//if (OnlineSub != None)
	//{
	//	if (OnlineSub.PlayerInterface != None)
	//	{
	//		OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
	//		OnlineSub.PlayerInterface.AddLoginFailedDelegate(0,OnLoginFailed);
	//		// Check the command line for login information and login async
	//		if (OnlineSub.PlayerInterface.AutoLogin() == false)
	//		{
	//			ClearAutoLoginDelegates();
	//			return false;
	//		}
	//		return true;
	//	}
	//}
	return false;
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	local int playerWeapID;




	local TPWeapon				lastWeapon;
	local TPPlayerController	tPC;
	local MultiplayerPawn		mPP;

	super.SetPlayerDefaults(PlayerPawn);
	tPC			= TPPlayerController(PlayerPawn.Controller);

	if (bTeamGame)
	{
		if (PlayerPawn.PlayerReplicationInfo.Team.TeamIndex == 0)
		{
			playerWeapID = tPC.connectInfo.AllyWeap;




		}
		else
		{
			playerWeapID = tPC.connectInfo.AxisWeap;




		}
	}
	else
	{
		playerWeapID = tPC.connectInfo.DMWeap;




	}




























	// Instigator is sometimes not set correctly on Client.  This is somewhat of a hack, as we should look into the real cause of the 
	// instigator being set to none after PlayerRestart on a new netPawn.
	PlayerPawn.InvManager.Instigator = PlayerPawn;
	PlayerPawn(PlayerPawn).ClientSetInstigator();

	// Give this player each of his new weapons
	if (bLoaded && (playerWeapID < WeaponList.Length && playerWeapID >= 0) )
	{
		mPP = MultiplayerPawn(PlayerPawn);

		TPInventoryManager(mPP.InvManager).CurrWeapons = 2;
		TPInventoryManager(mPP.InvManager).SetNumWeaponsInInventory(2);

		if (bTeamGame)
		{
			if ( mPP.PlayerReplicationInfo.Team.TeamIndex == T_PARTISAN)
			{
				lastWeapon = TPWeapon( GiveWeapon(PlayerPawn, "TPGameContent.Colt45_MP", true) );
				mPP.ClientAddAnimSets( lastWeapon );
			}
			else
			{
				lastWeapon = TPWeapon( GiveWeapon(PlayerPawn, "TPGameContent.Pistol_MP", true) );
				mPP.ClientAddAnimSets( lastWeapon );
			}
		}
		else
		{
			// Extract this player's default DM character
			if ( tPC.connectInfo.DMMesh > tPC.PartisanList.Length - 1)
			{
				lastWeapon = TPWeapon( GiveWeapon(PlayerPawn, "TPGameContent.Pistol_MP", true) );
				mPP.ClientAddAnimSets( lastWeapon );
			}
			else
			{
				lastWeapon = TPWeapon( GiveWeapon(PlayerPawn, "TPGameContent.Colt45_MP", true) );
				mPP.ClientAddAnimSets( lastWeapon );
			}
			
		}
		/*lastWeapon = TPWeapon( GiveWeapon(PlayerPawn, "TPGameContent.Pistol_MP") );
		mPP.ClientAddAnimSets( lastWeapon );*/
				
		lastWeapon = TPWeapon( GiveWeapon(PlayerPawn, "TPGameContent.Grenade_MP", true) );
		mPP.ClientAddAnimSets( lastWeapon );

		lastWeapon = TPWeapon( GiveWeapon(PlayerPawn, WeaponList[playerWeapID]) );
		mPP.ClientAddAnimSets( lastWeapon );
	}

	// If the player was in a FOV transition when dying due to Aim Down Site, we should reset their Fov back to default values
	tPC.ClientSetFOV();

	// Set the final weapon (usually most powerful) as the current weapon of this newly spawned player
	PlayerPawn.InvManager.SetCurrentWeapon( lastWeapon );  	
}

/**
 * Give a specified weapon to the Pawn.
 * If weapon is not carried by player, then it is created.
 * Weapon given is returned as the function's return parmater.
 */
function Weapon GiveWeapon( Pawn PlayerPawn, String WeaponClassStr, optional bool bDoNotActivate)
{
	local Weapon		Weap;
	local class<Weapon> WeaponClass;

	WeaponClass = class<Weapon>(FindObject(WeaponClassStr, class'Class'));
	Weap		= Weapon(PlayerPawn.FindInventoryType(WeaponClass));

	if( Weap != None )
	{
		return Weap;
	}
	return Weapon(PlayerPawn.CreateInventory( WeaponClass, bDoNotActivate ));
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
    local NavigationPoint Best;

	// Save LastPlayerStartSpot for use in RatePlayerStart()
    if ( (Player != None) && (Player.StartSpot != None) )
		LastPlayerStartSpot = Player.StartSpot;

    Best = Super.FindPlayerStart(Player, InTeam, incomingName );

	// Save LastStartSpot for use in RatePlayerStart()
    if ( Best != None )
		LastStartSpot = Best;
    return Best;
}

function PopulatePlayerStart(out array<PlayerStart> PlayerStarts, byte Team )
{
	local TPPlayerStart P;

	foreach WorldInfo.AllNavigationPoints(class'TPPlayerStart', P)
	{
		if ( P.bEnabled )
			PlayerStarts[PlayerStarts.Length] = P;
	}

}


function PlayerStart ChoosePlayerStart( Controller Player, optional byte InTeam )
{
	local TPPlayerStart P, BestStart;
	local float BestRating, NewRating;
	
	//local array<TPPlayerstart> PlayerStarts; //SPARK MAY CODEDROP
	local array<Playerstart> PlayerStarts;
	
	local int i, RandStart, BestSpawn;
	local byte Team;

	// use InTeam if player doesn't have a team yet
	Team = ( (Player != None) && (Player.PlayerReplicationInfo != None) && (Player.PlayerReplicationInfo.Team != None) )
			? byte(Player.PlayerReplicationInfo.Team.TeamIndex)
			: InTeam;

	// make array of enabled playerstarts
	PopulatePlayerStart(PlayerStarts, Team);

	if ( Player == None )
		return P;

	TPPlayerController(Player).spawnHolder.Remove(0,TPPlayerController(Player).spawnHolder.Length);
	TPPlayerController(Player).spawnHolder.Insert(0,PlayerStarts.Length);

	if ( TPPlayerController(Player).bSpawnTest )
	{
		for ( i = 0; i < TPPlayerController(Player).spawnHolder.Length; i++ )
		{	
			TPPlayerController(Player).spawnHolder[i].score = -999;
			TPPlayerController(Player).spawnHolder[i].location.x = -999;
			TPPlayerController(Player).spawnHolder[i].location.y = -999;
			TPPlayerController(Player).spawnHolder[i].location.z = -999;
			TPPlayerController(Player).spawnHolder[i].isSpawned = false;
		}
	}
	

	// start at random point to randomize finding "good enough" playerstart
	RandStart = Rand(PlayerStarts.Length);
	for ( i=RandStart; i<PlayerStarts.Length; i++ )
	{
		//P = PlayerStarts[i]; //SPARK MAY CODEDROP
		P = TPPlayerStart(PlayerStarts[i]);
		
		NewRating = RatePlayerStart(P,Team,Player);

		TPPlayerController(Player).spawnHolder[i].score = NewRating;
		TPPlayerController(Player).spawnHolder[i].location = P.location;

		if ( NewRating >= 30 )
		{
			// this PlayerStart is good enough
			TPPlayerController(Player).spawnHolder[i].isSpawned = true;
			return P;
		}
		if ( NewRating > BestRating )
		{
			BestRating = NewRating;
			BestStart = P;
			BestSpawn = i;
		}
	}
	for ( i=0; i<RandStart; i++ )
	{
		//P = PlayerStarts[i]; //SPARK MAY CODEDROP
		P = TPPlayerStart(PlayerStarts[i]);
		
		NewRating = RatePlayerStart(P,Team,Player);
		TPPlayerController(Player).spawnHolder[i].score = NewRating;
		TPPlayerController(Player).spawnHolder[i].location = P.location;

		if ( NewRating >= 30 )
		{
			// this PlayerStart is good enough
			TPPlayerController(Player).spawnHolder[i].isSpawned = true;
			return P;
		}
		if ( NewRating > BestRating )
		{
			BestRating = NewRating;
			BestStart = P;
			BestSpawn = i;
		}
	}
	
	
	TPPlayerController(Player).spawnHolder[BestSpawn].isSpawned = true;


	return BestStart;
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	local float Score, NextDist;
	local Controller OtherPlayer;
	local PlayerPawn OtherPawn;

	// Primary starts are more desireable
	Score = P.bPrimaryStart ? 30 : 20;

	if ( (P == LastStartSpot) || (P == LastPlayerStartSpot) )
	{
		// avoid re-using starts
		Score -= 15.0;
	}

	if ( TPPlayerController(Player).bSpawnTest == false )
	{
		if (Player != None)
		{
			ForEach WorldInfo.AllControllers(class'Controller', OtherPlayer)
			{
				if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) )
				{
					// check if playerstart overlaps this pawn
					if ( (Abs(P.Location.Z - OtherPlayer.Pawn.Location.Z) < P.CylinderComponent.CollisionHeight + OtherPlayer.Pawn.CylinderComponent.CollisionHeight)
						&& (VSize2D(P.Location - OtherPlayer.Pawn.Location) < P.CylinderComponent.CollisionRadius + OtherPlayer.Pawn.CylinderComponent.CollisionRadius) )
					{
						// overlapping - would telefrag
						return -10;
					}

					NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
					if ( (NextDist < 3000) && !WorldInfo.GRI.OnSameTeam(Player,OtherPlayer) && FastTrace(P.Location, OtherPlayer.Pawn.Location+vect(0,0,1)*OtherPlayer.Pawn.CylinderComponent.CollisionHeight) )
					{
						Score -= (5 - 0.001*NextDist);
					}
				}
			}
		}
	}
	
	else 
	{
		if ( Player != None )
		{
			ForEach WorldInfo.AllPawns(class'PlayerPawn', OtherPawn)
			{
				//if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) )
				if ( OtherPawn.health > 0 )
				{
					// check if playerstart overlaps this pawn
					if ( (Abs(P.Location.Z - OtherPawn.Location.Z) < P.CylinderComponent.CollisionHeight + OtherPawn.CylinderComponent.CollisionHeight)
						&& (VSize2D(P.Location - OtherPawn.Location) < P.CylinderComponent.CollisionRadius + OtherPawn.CylinderComponent.CollisionRadius) )
					{
						// overlapping - would telefrag
						return -10;
					}

					NextDist = VSize(OtherPawn.Location - P.Location);
					if ( (NextDist < 3000) && /*!WorldInfo.GRI.OnSameTeam(Player,OtherPlayer) &&*/ FastTrace(P.Location, OtherPawn.Location+vect(0,0,1)*OtherPawn.CylinderComponent.CollisionHeight) )
					{
						Score -= (5 - 0.001*NextDist);
					}
				}
			}
		}
	}
		
	return FMax(Score, 0.2);
}

function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
{
	local TPPlayerReplicationInfo KillerPRI, KilledPRI;
	
	if ( Killer != None )
		KillerPRI = TPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( KilledPlayer != None )
		KilledPRI = TPPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);
	
	// Uncomment for logged kill messages
	// `log( KillerPRI.PlayerName @ "killed" @ KilledPRI.PlayerName @ "via" @ damageType ); 

	// If this player was killed via Changing Team, or quitting the game, its damagetype is of type base damagetype.
	// Do not treat this as a scored kill, and simply destroy the pawn.
	if ( damagetype == class'DamageType' )
	{
		DiscardInventory(KilledPawn);
		NotifyKilled(Killer, KilledPlayer, KilledPawn);
		return;

	}
	else if ( damagetype == class'DmgType_Fell' )
	{
		TPPlayerController(KilledPlayer).ClientUnlockAchievement(TA_NEXTTIMETAKETHESTAIRS);
	}

	// Unlock "One in the Chamber Acheviement"
	if (Killer.Pawn != none && TPWeapon(Killer.Pawn.Weapon) != none && TPWeapon(Killer.Pawn.Weapon).WeapCategory == WeaponCategory_Pistol)
	{
		// If we killed him with one bullet left in a ranked match
		if (bUsingArbitration && (TPWeapon(Killer.Pawn.Weapon).IsInState('Reloading') || TPWeapon(Killer.Pawn.Weapon).AmmoInMagazine == 0))
			TPPlayerController(Killer).ClientUnlockAchievement(TA_ONEINTHECHAMBER);
	}
		
	// Score the kill
    if( KilledPlayer != None && KilledPlayer.bIsPlayer )
	{
		KilledPRI.Deaths += 1;

		//SPARK OCT CODEDROP
		//KilledPRI.NetUpdateTime = FMin(KilledPRI.NetUpdateTime, WorldInfo.TimeSeconds + 0.3 * FRand());
		

		if( Killer == KilledPlayer || Killer == None )
		{
			/* 
			if( Killer == None )
			{
				KillEvent("K", None, KilledPRI, DamageType);	//"Kill"
			}
			else
			{
				KillEvent("K", KillerPRI, KilledPRI, DamageType);	//"Kill"
			}
			*/
		}
		else if( bTeamGame &&
				KillerPRI != None &&
				KillerPRI.Team == KilledPRI.Team )
		{

		}
		else
		{
			KillerPRI.LogMultiKills(true);
			KillerPRI.IncrementKillsThisRound();
			//TPPlayerController(Killer).IncrementKill();
		}

		BroadcastDeathMessage(Killer, KilledPlayer, damageType);
	}

    if( KilledPlayer != None && IsInState('MatchInProgress') )
	{
		ScoreKill(Killer, KilledPlayer);
	}

	DiscardInventory(KilledPawn);
    NotifyKilled(Killer, KilledPlayer, KilledPawn);
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn )
{
	local TPPlayerController KilledPC;

	Super.NotifyKilled( Killer, Killed, KilledPawn );

	// If a player, move them to the "dead man talking" channel
	KilledPC = TPPlayerController(Killed);
	if (KilledPC != None)
	{
		InitSpectateMuteList(KilledPC);
	}
}

exec function kmsk()
{
	local TPPlayerController tPC;
	foreach WorldInfo.AllControllers(class'TPPlayerController', tPC)
	{
		if (tPC.IsLocalPlayerController())
		{
			tPC.Say("KMSK - Developer Overtime");
		}
	}

	OvertimeInit(999);
}

// Change the game's setting to overtime mode.  This should only be called during a tie-game situation when time has expired.
// Win Condition is now when one person reaches the current top score + 1, with no time limit
simulated function OvertimeInit(int leaderScore)
{
	local TPPlayerController TPC;

	// Show the Overtime Text for all players
	foreach WorldInfo.AllControllers(class'TPPlayerController', TPC)
	{
		TPC.ClientShowOverTime();
	}

	// Set overtime mode;
	overtime = true;
	scoreLimitBackup = GameReplicationInfo.GoalScore;

	// Frag Limit raised by tied leader's score + 1
	GameReplicationInfo.GoalScore = leaderScore + 1;

	// You need at least 1 point to win.
	if ( GameReplicationInfo.GoalScore <= 0 )
		GameReplicationInfo.GoalScore = 1;

	GoalScore = GameReplicationInfo.GoalScore;
}

/*
	Find out who the leader in a Deathmatch game when time has expired.
	If there is no sole victor, set overtime mode to guarentee one.
*/
simulated function int GetDMLeader()
{
	local	int								playerID;
	local	GameReplicationInfo				GRI;
	local	bool							tie;
	local	int								LeaderID;
	local	int								LeaderScore;
	local	int								playerScore;

	// Impossibly negative score that could never win the game.
	LeaderScore = -99999;
	tie = false;

	// Get the Game Replication Info
	GRI = WorldInfo.GRI;
	if (GRI==none)
	{
		return -1;
	}

	// Iterate through all players, finding the sole leader, or tied winners
	for ( playerID=0; playerID<GRI.PRIArray.Length; playerID++ )
	{
		// Extract this player's score
		playerScore = int(GRI.PRIArray[playerID].Score);

		// Is this score not as high as the leaders?
		if ( LeaderScore > playerScore )
		{
			// Do nothing
		}
		// Is there a tie for the lead?
		else if ( LeaderScore == playerScore )
		{
			leaderID = playerID;
			tie = true;
		}
		// This player is the leader, without ties.
		else // ( LeaderScore < playerScore )
		{
			leaderID = playerID;
			tie = false;
			LeaderScore = playerScore;
		
		}

	}

	// If a tie, make sure we notify CheckTime so that we go into OT	
	if ( tie )
	{
		OvertimeInit(LeaderScore);
		return -1;
	}

	return LeaderID;

}

// Check to see if time has expired for the game.  End it if it has, and if there is a sole victor
function bool CheckTime()
{
	local int WinnerID;

	// Don't check time expiration in Overtime.  Time has expired if there is no RemainingTime left
	if ( TimeLimit > 0 && GameReplicationInfo.RemainingTime <= 0  && !overtime )
	{
		WinnerID = GetDMLeader();

		// If there is a true leader
		if ( WinnerID != -1 )
		{
			// End the game and declare our winner.
			EndGame( WorldInfo.GRI.PRIArray[WinnerID],"TimeExpired" );
			return true;
		}	

		// There is a tie for the lead, GetDMLeader() has set overtime mode and we must inform our caller that the game is not over yet.
		return false;
	}

	return false;

}

/* CheckScore()
see if this score means the game ends
*/

function bool CheckScore(PlayerReplicationInfo Scorer)
{
	// This will always be a false statement, as we use rules differently than Unreal ( mutators, etc.)
	if ( !Super.CheckScore(Scorer) )
	{
		return false;
	}

	// Make sure we know who scored this point
	if ( Scorer != None )
	{
		// Did he achieve the goal score by scoring this point?  If so end the game as he is the winner
		if ( (GameReplicationInfo.GoalScore > 0) && (Scorer.Score >= GameReplicationInfo.GoalScore) )
		{
			// Was it achieved during overtime, or regulation?
			if ( overtime )
				EndGame(Scorer,"Overtime");
			else
				EndGame(Scorer,"KilledEnough");
		}
	}
	return true;
}

// Ends a Multiplayer game, after someone has achieved victory through frags or by leading the game when time expired
function EndGame(PlayerReplicationInfo Winner, string Reason )
{
	local int Index;
	local TPPlayerController		PC;
	local TPPlayerReplicationInfo	myPRI;

	// Win Conditions + Overtime Explanation
	// =================================================================================================================
	// "KilledEnough" - Player achieved the goal score
	// "TimeExpired" - Time has expired and the winner is the person in the lead    OR 
	// "Overtime" - Time has expired, there was a tie, overtime has occured, One person is now in the lead
	// This could be someone who was not originally tied for the lead.  Ie.
	// Deathmatch Scores:   K = 9, R = 9, D = 8, Goal = 15, 
	// Time has expired.  OT is set, therefore new Goal = 10 ( Tied lead + 1)
	// If K or R get a point ( K||R == 10 ), they will win.  If D scores two before that, he will win.
	// If K disconnects, R and D still must achieve 10.
	if (Reason ~= "KilledEnough" || Reason ~= "TimeExpired" || Reason ~= "Overtime")
	{
		// If a higher level gametype has not already declared a winner (Team DM), declare the winner
		if ( GameReplicationInfo.Winner == none )
		{
			GameReplicationInfo.Winner = Winner;

			;
			;
			;
			;
			;
			;
			;
			;
		}

		// End the game properly through the engine's GameInfo
		//Super.EndGame(Winner,Reason);

		// don't end game if not really ready
		if ( !CheckEndGame(Winner, Reason) )
		{
			bOverTime = true;
			return;
		}

		// The non-arbitrated route, the server writes all stats
		if (!bUsingArbitration)
		{
			if (AllowAchievements)
			{
				// Check for TA_R0XX0RMC0WN4G3 achievement for Deathmatch
				CheckHighestKillCount();
			}
		}
		// Arbitrated matches require all participants to report stats
		// This is handled in the end game handshaking process
		else
		{
			GameReplicationInfo.bMatchIsOver = true;
			if (bNeedsEndGameHandshake)
			{
				// Iterate through the inactive list and send them to the clients
				for (Index = 0; Index < InactivePRIArray.Length; Index++)
				{
					InactivePRIArray[Index].bIsInactive = true;
					InactivePRIArray[Index].RemoteRole = InactivePRIArray[Index].default.RemoteRole;
				}
				// Delay a bit so that replication can happen before processing
				SetTimer(2.0,false,'ProcessEndGameHandshake');
				bNeedsEndGameHandshake = false;
				bIsEndGameHandshakeComplete = false;
			}
		}

		bGameEnded = true;
		EndLogging(Reason);
		// If we ended the game
		if ( bGameEnded )
		{
			// Tell all of the clients we ended the game.
			foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
			{
				myPRI = TPPlayerReplicationInfo(PC.PlayerReplicationInfo);
				if (myPRI == TPPlayerReplicationInfo(Winner) && !bTeamGame)
					myPRI.SetGameWinner();

				// If this player didnt die, then unlock the achievement for staying alive.
				if (AllowAchievements)
				{
					PC.ClientUnlockAchievement(TA_FIRSTTIMEFOREVERYTHING);

					// Checks to see if we need to unlock the world tour
					PC.ClientCheckWorldTourAchievement();
				}

				//PC.MPRoundOver(myPRI.BulletsFiredThisRound, myPRI.BulletsHitThisRound, myPRI.Kills);
			
				myPRI.ResetThisRoundStats();

				TurnOffOvertime();
			}

			// And change our game mode on the server to allow smooth transition back to the lobby
			GotoState('PostGame');
		}
	}
}

//function ProcessEndGameHandshake()
//{
//	local int Index;
////	local int i;
//
//	bHasEndGameHandshakeBegun = true;
//	// Iterate the controller list and tell them to register with arbitration
//	for (Index = 0; Index < ArbitrationPCs.Length; Index++)
//	{
//		if (!ArbitrationPCs[Index].bDeleteMe && !ArbitrationPCs[Index].IsLocalPlayerController())
//		{
//			// Tell the client to write stats out
//			ArbitrationPCs[Index].ClientWriteArbitrationEndGameData(OnlineStatsWriteClass);
//			// Add to the pending list
//			//i = PendingArbitrationPCs.Length;
//			//PendingArbitrationPCs.Insert(i, 1);
//			PendingArbitrationPCs.AddItem(ArbitrationPCs[Index]);
//			`log("Process End Game Handshake for client: Adding Pending Controller "$ArbitrationPCs[Index]);
//		}
//	}
//	// If we aren't waiting for any clients to process data, do our processing now
//	if (PendingArbitrationPCs.Length == 0)
//	{
//		ServerWriteArbitrationEndGameData();
//	}
//	else
//	{
//		SetTimer(5.0,false,'ServerWriteArbitrationEndGameData');
//	}
//}

function UnlockMVP()
{
	local TPPlayerController HighestPlayerController, PC;
	local int HighestScore, TempScore, playerCount;

	if (bTeamGame)
	{
		foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
		{
			playerCount++;

			TempScore = PC.PlayerReplicationInfo.Score;
			if (TempScore > HighestScore)
			{
				HighestScore = TempScore;
				HighestPlayerController = PC;
			}
		}
		;
		;
		// Write out the MVP of a team dm match
		if (HighestPlayerController != none && playercount >= 8 && TeamInfo(GameReplicationInfo.Winner).TeamIndex == HighestPlayerController.PlayerReplicationInfo.Team.TeamIndex )
			HighestPlayerController.ClientUnlockAchievement(TA_MVP);
	}
}

function CheckHighestKillCount()
{
	local TPPlayerController PC, WinningPC;
	local int CurrentKills, HighestKills, playercount;

	//`log(GetFuncName());
	if (!bTeamGame)
	{
		//`log("Checking to see if we ROXXORED");
		foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
		{
			playercount++;
			CurrentKills = PC.PlayerReplicationInfo.Kills;
			if (CurrentKills > HighestKills)
			{
				WinningPC = PC;
				HighestKills = CurrentKills;
			}
			
			//`log("WinningPC: "$WinningPC$"CurrentKills: "$CurrentKills$", HighestKills: "$HighestKills);
		}
		if (WinningPC != none && playercount >= 8)
			WinningPC.ClientUnlockAchievement(TA_R0XX0RMC0WN4G3);
	}
}

function ReduceDamage( out int Damage, pawn injured, Controller instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local int idx;

	// If Team DM or other future game modes call the super version, ignore DM logic.
	if ( bTeamGame )
	{
		Super.ReduceDamage(Damage,injured,instigatedBy,HitLocation,Momentum,damageType);
		return;
	}
	

	for (idx = 0; idx < Teams.Length; idx++)
	{
		Teams[idx].NotifyTakeDamage(injured.Controller,instigatedBy);
	}

	Super.ReduceDamage(Damage,injured,instigatedBy,HitLocation,Momentum,damageType);
}

function StartMatch()
{
	local TPTeamInfo tInfo;
	local	int								playerID;
	local	GameReplicationInfo				GRI;
	local TPPlayerController				tPC;
	local TPPawn							tPP;
	local TPInventoryManager				tPI;
	local Actor A;

	// tell all actors the game is starting
	ForEach AllActors(class'Actor', A)
	{
		A.MatchStarting();
	}

	bWaitingToStartMatch = false;

	StartOnlineGame();

	// fire off any level startup events
	WorldInfo.NotifyMatchStarted();

	//super.StartMatch();

	foreach AllActors(class'TPTeamInfo', tInfo)
	{
		tInfo.Score = 0;
	}

	GRI = WorldInfo.GRI;
	if (GRI==none)
	{
		return;
	}

	GameReplicationInfo.RemainingTime = TimeLimit * 60;
	// Iterate through all playerreplicationInfo
	for ( playerID=0; playerID<GRI.PRIArray.Length; playerID++ )
	{
		GRI.PRIArray[playerID].Score = 0;
		GRI.PRIArray[playerID].Kills = 0;
		GRI.PRIArray[playerID].Deaths = 0;
	}

	// for all players
	foreach WorldInfo.AllControllers(class'TPPlayerController', tPC)
	{
		;
		// Force them upon next spawn to respawn
		// need to delete/unsummon the pawn
		
		// Destroy all of the player's inventory without dropping it in the world
		tPP = TPPawn(tPC.Pawn);
		if (tPP != none)
		{
			tPI = TPInventoryManager(tPP.InvManager);
			if (tPI != none)
			{
				tPI.noDrop = true;
				tPI.DiscardInventory();
			}
			
			// Respawn the Player
			tPC.Unpossess();
			// tPC.Pawn is no longer valid
			tPP.Destroy();
		}
		//if (!UIScene_TPNonWeaponHUD(tPC.myNonWeaponUIScene).bAcceptingInput)
		//	RestartPlayer(tPC);	
		
		InitTeamMuteList(tPC);
	}
		
	GotoState('MatchInProgress');
}

function SyncClientTime()
{
	local TPPlayerController PC;

	// for all players
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.SyncWithServerTime(GameReplicationInfo.ElapsedTime, GameReplicationInfo.RemainingTime);
	}

}

state MatchInProgress
{
	function BeginState( Name PreviousStateName )
	{
		// Don't put code in here until we figure out "Out of order" game state issues in MP	
		TPGRI.SetGameStatus(GS_GameInProgress);
	}
	function bool MatchIsInProgress()
	{
		return true;
	}

    function Timer()
    {
		if ( TimeLimit > 0 )
		{
			GameReplicationInfo.RemainingTime--;
		}
		else
		{
			GameReplicationInfo.RemainingTime = 0;
		}
		
		GameReplicationInfo.ElapsedTime++;

		SyncClientTime();

		CheckTime();
	}

begin:
	AllowAchievements = true;
	;
	SetTimer(WorldInfo.TimeDilation, true);
	SetGameSpeed(GameSpeed);
	//ChangeClientGameState(MPState_Game);	
	TPGRI.SetGameStatus(GS_GameInProgress);
}

function ScoreKill(Controller Killer, Controller Other)
{
	if( (killer == Other) || (killer == None) )
	{
    	if ( (Other!=None) && (Other.PlayerReplicationInfo != None) )
		{
			Other.PlayerReplicationInfo.Score -= 1;
			//SPARK OCT CODEDROP
			//Other.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - 1;
		}
	}
	else if ( killer.PlayerReplicationInfo != None )
	{
		Killer.PlayerReplicationInfo.Score += 1;
		//SPARK OCT CODEDROP
		//Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - 1;
		Killer.PlayerReplicationInfo.Kills++;
		if (bUsingArbitration)
			TPPlayerController(Killer).ClientIncrementMultiplayerKillCount();
	}

    if ( (Killer != None) || (MaxLives > 0) )
	{
		CheckScore(Killer.PlayerReplicationInfo);
	}
}

function StatsWriteComplete()
{
	;
	OnlineSub.StatsInterface.FlushOnlineStats();
	//GameReplicationInfo.EndGame();
}

function WriteOnlineStats()
{
	local TPGameStatsWrite Stats;
	local TPPlayerController PC;
	local TPPlayerReplicationInfo PRI;
	//local UniqueNetId PlayerId;
	local int PlayerScore;
	local int NumInactives;
	local int i;
	
	// Only calc this if the subsystem can write stats
	if (OnlineSub != None && OnlineSub.StatsInterface != None)
	{
		if (AllowAchievements)
		{
			UnlockMVP();
			CheckHighestKillCount();
		}

		Stats = TPGameStatsWrite(new OnlineStatsWriteClass);
		//Stats.OnStatsWriteComplete = StatsWriteComplete;
		foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
		{
			if (AllowAchievements)
			{
				PC.ClientUnlockAchievement(TA_FIRSTTIMEFOREVERYTHING);

				// Checks to see if we need to unlock the world tour
				PC.ClientCheckWorldTourAchievement();
			}

			PRI = TPPlayerReplicationInfo(PC.PlayerReplicationInfo);
			if (PRI != None)
			{
				;
				
				Stats.IncrementKill(PRI.Kills);
				Stats.IncrementDeaths(PRI.Deaths);

				if (bTeamGame)
					PlayerScore = PRI.Team.Score;
				else
					PlayerScore = PRI.Score;
				
				Stats.IncrementScore(PlayerScore);
				
				if (PRI.GameWinner)
				{
					Stats.IncrementGamesWon(1);
					Stats.IncrementGamesLost(0);
					PC.ClientIncrementGamesWon(bTeamGame);
				}
				else
				{
					Stats.IncrementGamesWon(0);
					Stats.IncrementGamesLost(1);
				}
				
				if (PRI.Deaths == 0 && AllowAchievements)
					PC.ClientUnlockAchievement(TA_STAYINALIVE);
				
				//	PC.ClientSetEndOnlineGame();

				//PC.WriteProfile(true);
				//Stats.IncrementGamesWon(
				// This will copy them into the online subsystem where they will be
				// sent via the network in EndOnlineGame()
				//OnlineSub.PlayerInterface.GetUniquePlayerId(0,PlayerId);
				OnlineSub.StatsInterface.WriteOnlineStats(PC.PlayerReplicationInfo.UniqueId,Stats);
			}
		}

		//Write out stats of players who left the game
		NumInactives = InactivePRIArray.length;
		for (i=0; i<NumInactives; i++)
		{
			PRI = TPPlayerReplicationInfo(InactivePRIArray[i]);
			if (PRI != None)
			{
				;
				
				Stats.IncrementKill(PRI.Kills);
				Stats.IncrementDeaths(PRI.Deaths);

				if (bTeamGame)
					PlayerScore = PRI.Team.Score;
				else
					PlayerScore = PRI.Score;
				
				Stats.IncrementScore(PlayerScore);
				
				if (PRI.GameWinner)
				{
					Stats.IncrementGamesWon(1);
					Stats.IncrementGamesLost(0);
				}
				else
				{
					Stats.IncrementGamesWon(0);
					Stats.IncrementGamesLost(1);
				}
				
				OnlineSub.StatsInterface.WriteOnlineStats(PRI.UniqueId,Stats);
			}
            else
            {
                ;
            } 
		}
	}
}

/**
 * This is called once the client has sent the server their unique net id.
 * It is now possible to set up their mute list.
 *
 * @param PC the playercontroller that is ready for updates
 */
function UpdateGameplayMuteList(PlayerController PC)
{
	local TPPlayerController TPC;

	TPC = TPPlayerController(PC);
	if (TPC != None)
	{
		// Since they just sent this information it means they are spectators
		InitSpectateMuteList(TPC);
	}
}

/**
 * Make this player only talk to other spectators.
 */
function InitSpectateMuteList(TPPlayerController PC)
{
	local TPPlayerController OtherPC;
	
	PC.VoiceChannel = VC_SpectatorsDead;

	foreach WorldInfo.AllControllers(class'TPPlayerController',OtherPC)
	{
		if (OtherPC != PC)
		{
				if (OtherPC.VoiceChannel != PC.VoiceChannel)
				{
					PC.GameplayMutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
					OtherPC.GameplayMutePlayer(PC.PlayerReplicationInfo.UniqueId);
				}
				else
				{
					PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
					OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
				}

				//// Update the mute lists for priviledge purposes.
				//PC.ClientUpdateMuteList(OtherPC.PlayerReplicationInfo.UniqueId);
				//OtherPC.ClientUpdateMuteList(PC.PlayerReplicationInfo.UniqueId);
		}
	}
}

/**
 * Reset everyone's channel to the same thing and then rebuild the gameplay
 * mute lists for each player
 */
function ResetGameplayMuting()
{
	local TPPlayerController PC;

	// Do a pass through resetting everyones voice channels
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		PC.VoiceChannel = VC_SpectatorsDead;
	}
	// Do a second pass through rebuilding the mute list
	foreach WorldInfo.AllControllers(class'TPPlayerController', PC)
	{
		// Clear the gameplay mute list so everyone can talk to each other while traveling
		InitSpectateMuteList(PC);
	}
}

function UpdateGameSettingsCounts()
{
	if (GameSettings != None)
	{
		// Update the number of open slots available
		GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - GetNumPlayers();
		if (GameSettings.NumOpenPublicConnections < 0)
		{
			GameSettings.NumOpenPublicConnections = 0;
		}
		// List Play needs the QoS packet rebuilt
		//if (GameSettings.bIsListPlay)
		//{
		if ( GameSettings != None && !WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) )
		{
			;
			OnlineSub.GameInterface.UpdateOnlineGame(GameSettings);
		}
		//}
	}
}

function FlushOnlineStatsDone(bool bWasSuccessful)
{
	;
	OnlineSub.StatsInterface.ClearFlushOnlineStatsCompleteDelegate(FlushOnlineStatsDone);

	//OnlineSub.GameInterface.EndOnlineGame();
}

/**
 * Commits arbitration data for the server and restarts the match
 */
function ServerWriteArbitrationEndGameData()
{
	//local PlayerController PC;

	;
	SetTimer(0.0,false,'ServerWriteArbitrationEndGameData');
	// Write all of the game stats
	WriteOnlineStats();
	// Write out any player scoring data
	WriteOnlinePlayerScores();
	//// Now finalize the data before closing the session down
	//if (GameInterface != None)
	//{
	//	//if (OnlineSub != None)
	//	//{
	//		//OnlineSub.StatsInterface.AddFlushOnlineStatsCompleteDelegate(FlushOnlineStatsDone);
	//		//OnlineSub.StatsInterface.FlushOnlineStats();
	//	//}
	//	// Force the flush of the stats
	//  //GameInterface.EndOnlineGame();
	//	//GameReplicationInfo.EndGame();
	//}
	// Iterate through local controllers telling them to write their data
	// since the clients all have
	/*foreach WorldInfo.AllControllers(class'PlayerController',PC)
	{
		if (PC.IsLocalPlayerController())
		{
			PC.ClientWriteArbitrationEndGameData(OnlineStatsWriteClass);
		}
	}*/
	// Clean up handshaking state
	bIsEndGameHandshakeComplete = true;
	PendingArbitrationPCs.Length = 0;
	ArbitrationPCs.Length = 0;
	// Start the next match
	//RestartGame();
}

function WriteOnlinePlayerScores()
{
	local int Index;
	local array<OnlinePlayerScore> PlayerScores;

	if (OnlineSub != None && OnlineSub.StatsInterface != None)
	{
		// Allocate an entry for all players
		PlayerScores.Length = GameReplicationInfo.PRIArray.Length;
		// Iterate through the players building their score data
		for (Index = 0; Index < GameReplicationInfo.PRIArray.Length; Index++)
		{
			// Build the skill data for this player
			PlayerScores[Index].PlayerId = GameReplicationInfo.PRIArray[Index].UniqueId;
			if (bTeamGame)
			{
				PlayerScores[Index].TeamId = GameReplicationInfo.PRIArray[Index].Team.TeamIndex;
				PlayerScores[Index].Score = GameReplicationInfo.PRIArray[Index].Team.Score;
			}
			else
			{
				PlayerScores[Index].TeamId = Index;
				PlayerScores[Index].Score = GameReplicationInfo.PRIArray[Index].Score;
			}
		}
		// Now write out the scores
		OnlineSub.StatsInterface.WriteOnlinePlayerScores(PlayerScores);
	}
}

function NotifyArbitratedMatchEnd()
{
	super.NotifyArbitratedMatchEnd();
	;
}

// If a player has disconnected, are there still enough players so that a winner is possible?
function HandleDisconnect( int disconnectID )
{
	local PlayerReplicationInfo winnerPRI, PRI;
	local int i;

	if ( TPGRI.GameStatus == GS_Lobby || TPGRI.GameStatus == GS_PostGame)
	{
		return;
	}

	// Determine if there are enough elliglbe players to win the match to continue.
	// For this game mode [ Deathmatch ] , having more than 1 player is simply enough to keep the match going.
	for ( i = 0; i < TPGRI.PRIArray.Length; i++ )
	{
		PRI = TPPlayerReplicationInfo( TPGRI.PRIArray[i] );
		if ( PRI != None && disconnectID != PRI.PlayerID )
		{
			if ( winnerPRI != none )
				return;	

			winnerPRI = PRI;	
		}
	}

	AllowAchievements = false;
	EndGame( winnerPRI, "TimeExpired" );

}

/**
 * Sets up the voice mute list based upon this player's team. Opponents are
 * added the specified player's mute list and vice versa.
 *
 * @param PC the player controller to initialize muting for
 */
function InitTeamMuteList(TPPlayerController PC);

