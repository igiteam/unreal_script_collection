class SFRMMultiPlayer extends GameInfo
native;

var class<MPLoadoutMgr> loadoutClass;
var int LoadoutChoice;

var int GameLength;
var int CurGameLength;
var int Respawns;	//-1 => infinite

var float FriendlyFireModifier;

var float MPDamAdjust;

var int CountDown;

var bool bDelayCountdown;
var bool bReadyToStart;

var bool startSent;
var bool bScoreKills;
var bool bScoreTeamElim; // ends the game on team elimination
var bool OverrideTeam;	//overrides the team check in findplayer start, forcing it to use InTeam, and forces RatePlayerStart to treat it like a teamgame

var int TimeUpWinner; // TeamIDx of team who wins when time limit reached

var XBoxLiveMgr XBLiveMgr;

var string SplitScreenCmd;	//NOT localized, this is a cmd to an exec statement
var localized string TimeUpText;   // REASON 0
var localized string SFWinText;    // REASON 1
var localized string TerrWinText;  // REASON 2
var localized string WinText;      // REASON 3 personal win (i.e. "Player3 wins")
var localized string SFElimText;   // REASON 4
var localized string TerrElimText; // REASON 5
var class<ZombieMPMessage> ZombieMessageClass;

var string HostName;

var bool UsesRespawns;

var bool BotMatch;
var int NumBots;
var int ClassLimits[6];

///SOUNDS////
var Sound WinSound;
var Sound LoseSound;

var bool bEnemiesOnRadar;

function bool CanSpectate( PlayerController Viewer, bool bOnlySpectator, actor ViewTarget )
{
	//kkm--removed ViewTarget != Viewer.Pawn checks.
	//ServerViewNextPlayer iterates through the controller list so we will never be passed a pawn.
	//Besides, even if there was there's a bunch of casts to PlayerController on ViewTarget anyway.
	//Added tons of logs to help debug the VIP spectator issue.

	local int sfElim,tElim;
	local Controller other;
	local PlayerController PC;

	other = Controller(ViewTarget);
	if ( other == none )
	{
		log( "VIP: Can't spectate non-Controller" );
		return false;
	}

	log( "VIP: Can" @ Viewer.PlayerReplicationInfo.PlayerName @ "spectate" @ other.PlayerReplicationInfo.PlayerName $ "?" );

	if( Viewer == ViewTarget )
	{
		log( "Can't spectate self" );
		return false;
	}

	PC = PlayerController ( Other );
	if( PC != None && ( PC.IsSpectating() || PC.PlayerReplicationInfo.bIsSpectator ) )
	{
		log( "Can't spectate spectator" );
		return false;
	}

	if ( Other.GetStateName ( ) == 'Dead' )
	{
		log ( "Can't spectate dead people" );
		return false;
	}

	if( other.Pawn == none )
	{
		log( "Can't spectate without a pawn" );
		return false;
	}

	if( GameReplicationInfo.bTeamGame )
	{
		CheckTeamElim(sfElim,tElim);
		if( tElim != 0 )
		{
			log( "Terrorists eliminated; allow anyone to spectate anyone" );
			return true;
		}

		if( Viewer.PlayerReplicationInfo.Team == none )
		{
			log( "Can't spectate player with no team" );
			return false;
		}
		else if( Viewer.PlayerReplicationInfo.Team.TeamIndex == other.PlayerReplicationInfo.Team.TeamIndex )
		{
			log( "Allow spectate on same team" );
			return true;
		}
		else
		{
			log( "Don't allow spectate on opposing team" );
			return false;
		}
	}

	return true;
}

event SetXboxLiveMgr(Player p)
{
//	if( XBLiveMgr == none && CombatProxyMenuManager(p.InteractionMaster.BaseMenu).XBLiveMgr.IsLiveGame )
//	{
//		XBLiveMgr = CombatProxyMenuManager(p.InteractionMaster.BaseMenu).XBLiveMgr;
//	}
}

event bool AtCapacity(bool bSpectator, bool bInvited )
{
	if ( Level.NetMode == NM_Standalone )
	{
//		log("AtCapacity: NM_Standalone");
		return false;
	}

//	log("AtCapacity: " $ MaxPlayers @ NumPlayers);
	return ( (MaxPlayers>0) && (NumPlayers>=MaxPlayers) );
}

function SetDeferredTeamAndClass( Controller aPlayer )
{
	local SFRMPlayerController PC;
	PC = SFRMPlayerController ( aPlayer );

	// player controlled?
	if ( PC != None )
	{
		// special stuff
		PC.ChangeTeam ( int(PC.PlayerReplicationInfo.bNextTerrorist ) );
		PC.SetMPClass( aPlayer.PlayerReplicationInfo.NextClassIdx );
	}
	else if ( aPlayer.PlayerReplicationInfo != None && GameReplicationInfo != None )
	{
		/// otherwise - bot style
		ChangeTeam ( aPlayer, int(aPlayer.PlayerReplicationInfo.bNextTerrorist), true );
	}
}

function ChangeName( Controller Other, coerce string S, bool bNameChange )
{
	if ((XBLiveMgr != none) && (XBLiveMgr.IsLiveGame))
	{
		//no name change if we're in Live...
		return;
	}
	
	super.ChangeName(Other, s, bNameChange);
}

event bool AllowStartJoin()
{
	return true;
}

event BroadcastLocalized( actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if (Message == none)
	{
		return;
	}
	
	super.BroadcastLocalized(Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

event SendMPMessage(EMPMessage messID, optional PlayerReplicationInfo pri_1, optional PlayerReplicationInfo pri_2, optional Object OptionalObject )
{
	BroadcastLocalized(self, ZombieMessageClass, messID, pri_1, pri_2,OptionalObject);
}

//this is called every Game-Time second
//The difference between game time and real time depends on the GameSpeed setting; which we will likely keep at 1.0
function Timer()
{
	super.Timer();
	if ((GameLength > 0) && !bWaitingToStartMatch && !bGameEnded)
	{
		CurGameLength += 1;

		// kkm: update the remaining minute if we've passed the minute boundary
		if( GameLength - CurGameLength < GameReplicationInfo.RemainingMinute )
			GameReplicationInfo.RemainingMinute = GameLength - CurGameLength;
		
		if (CurGameLength >= GameLength)
		//if (CurGameLength >= 20)
		{
			//log("GameLength hit");
			EndGame(GetTimeUpWinner(), TimeUpText);
		}
		
		//log("SFRMMultiPlayer Timer");
	}
}

function PlayerReplicationInfo GetTimeUpWinner()
{
	if (bTeamGame && (TimeUpWinner != -1))
	{
		return GetHighScoreIndividual(TimeUpWinner);
	}
	if (bTeamGame)
	{
		return GetHighScoreTeam();
	}
	
	return GetHighScoreIndividual(-1);
}

function PlayerReplicationInfo GetHighScoreTeam()
{
	local Controller P;
//	local PlayerReplicationInfo tempWin;
	local int sfScore;
	local int tScore;

	sfScore = GameReplicationInfo.Teams[0].Score;
	tScore = GameReplicationInfo.Teams[1].Score;

//	for ( P=Level.ControllerList; P!=None; P=P.NextController )
//	{
//		if (p.PlayerReplicationInfo.Team.TeamIndex == 1)
//		{
//			tScore += p.PlayerReplicationInfo.score;
//		}
//		else
//		{
//			sfScore += p.PlayerReplicationInfo.score;
//		}
//	}
	
	if (sfScore > tScore)
	{
		return GetHighScoreIndividual(0);
	}
	else if( tScore > sfScore )
	{
		return GetHighScoreIndividual(1);
	}

	return none;
}

function PlayerReplicationInfo GetHighScoreIndividual(int teamIdx)
{
	local Controller P;
	local PlayerReplicationInfo tempWin;
	local bool tied;

	//kkm--restructured to return none if there's a tie
	for( P = Level.ControllerList; P != none; P = P.NextController )
	{
		if( P.PlayerReplicationInfo.bOutOfLives || P.PlayerReplicationInfo.bIsSpectator ||
			( teamIdx != -1 && GameReplicationInfo.bTeamGame && P.PlayerReplicationInfo.Team.TeamIndex != teamIdx ) )
		{
			continue;
		}

		if( tempWin == none )
		{
			tempWin = P.PlayerReplicationInfo;
			tied = false;
		}
		else if( P.PlayerReplicationInfo.Score > tempWin.Score )
		{
			if( teamIdx == -1 || P.PlayerReplicationInfo.Team.TeamIndex == teamIdx )
			{
				tempWin = P.PlayerReplicationInfo;
				tied = false;
			}
		}
		else if( P.PlayerReplicationInfo.Score == tempWin.Score &&
			( !GameReplicationInfo.bTeamGame || P.PlayerReplicationInfo.Team != tempWin.Team ) )
		{
			tied = true; // NOT a draw if on the same team
		}
	}

	if( tied && teamIdx == -1 )
	{
		return none;
	}
	else
	{
		return tempWin;
	}
}

function PlayerReplicationInfo GetTeamPRI(int teamIdx)
{
	local Controller P;

	if ((teamIdx < 0) || (teamIdx > 1))
	{
		return none;
	}
		
	for ( P=Level.ControllerList; P!=None; P=P.NextController )
	{
		if (p.PlayerReplicationInfo.Team.TeamIndex == teamIdx)
		{
			return p.PlayerReplicationInfo;
		}
	}
	
	return none;
}


simulated function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	local Controller C;

	for ( C=Level.ControllerList; C!=None; C=C.nextController )
		C.NotifyKilled(Killer, Killed, KilledPawn,damageType);

	if ( Killer == None && Killed != None )
		Killer = Killed;

	if ( Killed == None && Killer != None )
		Killed = Killer;

	SendMPMessage(MPM_PlayerDied, Killed.PlayerReplicationInfo, Killer.PlayerReplicationInfo,damageType);  // "Killed Otherplayer"
}

function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	local SFRMPlayerController pc;
	pc = SFRMPlayerController(Killed);

	if ( pc != None )
	{
		// TODO: Sync this up with the Sleep call in state Dead for SFRMPlayerController
		pc.SetRespawnTime( 5 );

		pc.NumRespawns++;
		pc.PlayerReplicationInfo.NumLives++;
		Killed.PlayerReplicationInfo.ScoringKOH = false;
		pc.PlayerReplicationInfo.bOutOfLives = Respawns != -1 && pc.NumRespawns > Respawns;

		super.Killed( Killer, Killed, KilledPawn, damageType );
	}
	else
	{
        Killed.PlayerReplicationInfo.NumLives++;
        Killed.PlayerReplicationInfo.ScoringKOH = false;

		if ( Respawns != -1 && Killed.PlayerReplicationInfo.NumLives >= Respawns )
		{
			Killed.PlayerReplicationInfo.bOutOfLives = true;
		}
		else
		{
			Killed.PlayerReplicationInfo.bOutOfLives = false;
		}

		Super.Killed ( Killer, Killed, KilledPawn, damageType );
	}
}

/* ProcessServerTravel()
 Optional handling of ServerTravel for network games.
*/
native event ProcessServerTravel( string URL, bool bItems );
native function InitNames();

function InitGameReplicationInfo()
{
	local int i;
//	local PlayerStart ps;
//	local int team1[8];
//	local int team2[8];
//	local Actor pawn;

	InitNames();
	super.InitGameReplicationInfo();

	GameReplicationInfo.MaxLives = Respawns+1;
	GameReplicationInfo.TimeLimit = GameLength;
	GameReplicationInfo.RemainingMinute = GameLength;

	GameReplicationInfo.bEnemiesOnRadar = bEnemiesOnRadar;

	for( i = 0; i < 6; ++i )
	{
		GameReplicationInfo.ClassLimits[i] = ClassLimits[i];
	}

	if( BotMatch )
	{
		for( i = 0; i < NumBots; ++i )
		{
			spawn( class'ZombieMPBot' );
		}
	}

    // SPAWN_TEST
//	foreach AllActors( class'PlayerStart', ps )
//	{
//		pawn = spawn( class'ZombieBipedPawn' ,,, ps.Location, ps.Rotation );
//		if( pawn == none )
//		{
//			log( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Failed to spawn at" @ ps );
//		}
//		else
//		{
//			pawn.Destroy();
//		}
//		for( i = 0; i < 8; ++i )
//		{
//			if( ( ps.GameTypeFlags & (1<<(i+2)) ) != 0 )
//			{
//				if( ps.TeamNumber == 0 )
//					team1[i]++;
//				else if( ps.TeamNumber == 1 )
//					team2[i]++;
//			}
//		}
//	}
//
//	for( i = 0; i < 8; ++i )
//	{
//		log( "!!!!!!!!!!!!!!!!!!!!Num spawn points for GT (team1)" @ i @ "is" @ team1[i] );
//		log( "!!!!!!!!!!!!!!!!!!!!Num spawn points for GT (team2)" @ i @ "is" @ team2[i] );
//	}
}


event InitGame( string Options, out string Error )
{
	local int tempFF, i;

	super.InitGame(Options, Error);
	
	tempFF = int(FriendlyFireModifier*100);
	
//	log("InitGame: Options: " $ Options);
	
	GameLength = GetIntOption(Options, "Time", GameLength);
	FriendlyFireModifier = float(GetIntOption(Options, "FF", tempFF))/100.0f;
	//default to infinite respawns
	if (UsesRespawns)
	{
		Respawns = GetIntOption(Options, "Respawns", -1);
	}
	else
	{
		Respawns = -1;
	}
	log("Respawns: " $ Respawns);

	// get class limits
    for( i = 0; i < 6; ++i )
	{
		ClassLimits[i] = GetIntOption( Options, "ClassLimits["$i$"]", -1 );
	}

	bEnemiesOnRadar = bool( GetIntOption( Options, "RadarEnemies", int(bEnemiesOnRadar) ) );
	BotMatch = bool( GetIntOption( Options, "BotMatch", 0 ) );
	NumBots = GetIntOption( Options, "NumBots", 0 );
	GameDifficulty = GetIntOption( Options, "BotSkill", 1 );
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	if ( (GameRulesModifiers != None) && !GameRulesModifiers.CheckEndGame(Winner, Reason) )
		return false;

	return true;
}

event EndGame( PlayerReplicationInfo Winner, string Reason )
{
	if( Winner != none ) log( "GAME ENDED:" @ Winner.PlayerName @ Reason );
	super.EndGame(Winner, Reason);

	if (bGameEnded)
	{
		DoEndGame(Winner, Reason);
	}
}

event DoEndGame( PlayerReplicationInfo Winner, string Reason )
{
	local Controller P, NextController;
	local Pawn EndGameFocus;
	local PlayerController pc;
	

	EndGameFocus = Controller(Winner.Owner).Pawn;
	if ( EndGameFocus != None )
		EndGameFocus.bAlwaysRelevant = true;
	for ( P=Level.ControllerList; P!=None; P=NextController )
	{
		PC = PlayerController(P);
		if ( PC != None )
		{
			if (PC.PlayerReplicationInfo.Team == Winner.Team)
			{
				PC.ClientPlaySound(WinSound);
			}
			else
			{
				PC.ClientPlaySound(LoseSound);
			}

			PC.ClientSetBehindView( true );
			if ( EndGameFocus != None )
			{
				PC.ClientSetViewTarget(EndGameFocus);
				PC.SetViewTarget(EndGameFocus);
			}
			PC.ClientGameEnded();
		}
		NextController = P.NextController;
		P.GameHasEnded();
	}

	GotoState( 'MatchOver' );
}

event PlayerController Login(string Portal,	string Options,	out string Error)
{
	local PlayerController NewPlayer;
	
	NewPlayer = Super.Login(Portal,Options,Error);

	if( GameReplicationInfo.bGameEnded )
		NewPlayer.GotoState( 'GameEnded' );

	return NewPlayer;
}

event PostLogin( PlayerController NewPlayer )
{
	local bool oldDelayedStart;
	local Controller C;
	
	oldDelayedStart = bDelayedStart;
	bDelayedStart = true;
	Super.PostLogin( NewPlayer );
	bDelayedStart = oldDelayedStart;

	SendMPMessage(MPM_PlayerEntered, NewPlayer.PlayerReplicationInfo);

	log("SFRMMultiplayer: startSent: " $ startSent);
	if (!startSent)
	{
		startSent = true;
		
		HostName = NewPlayer.PlayerReplicationInfo.PlayerName;
		
		log("Sending " $ SplitScreenCmd);
		ConsoleCommand(SplitScreenCmd);
	}

	if ((XBLiveMgr != none) && (XBLiveMgr.IsLiveGame))
	{
		log("PostLogin: NewPlayer.PRI: " $ NewPlayer.PlayerReplicationInfo @ NewPlayer.PlayerReplicationInfo.xuid);
		//XBLiveMgr.ChangeNumPlayers(1);
		for( C=Level.ControllerList;C!=None;C=C.NextController )
		{
			SFRMPlayerController(C).PlayerEntered(NewPlayer.PlayerReplicationInfo.xuid);
		}
		
		if ((Level.NetMode == NM_DedicatedServer) && (XBLiveMgr != None))
		{
//			log("Calling ChangeNumPlayers directly for ded. Server");
			XBLiveMgr.ChangeNumPlayers(1);
		}
	}

	NewPlayer.ClientPostLogin(true);

	if ((NewPlayer.Pawn != none) && (NewPlayer.Pawn.Weapon != none))
	{
		ZombieWeapon(NewPlayer.Pawn.Weapon).InitializeWeapon();
	}
	
}

function bool PlayerCanRestart( PlayerController aPlayer )
{
	return aPlayer.WaitDelay <= Level.TimeSeconds;
}

event RestartPlayer(Controller aPlayer)
{
	local SFRMPlayerController pc;
	pc = SFRMPlayerController(aPlayer);

	SetDeferredTeamAndClass( aPlayer );
	if (aPlayer.PlayerReplicationInfo.ClassIDx == 0)
	{
		log("Not (re)starting player with 0 class idx: " $ aPlayer);
		return;
	}
	Super.RestartPlayer(aPlayer);

	Log("DefaultMapInfo is set to "$Level.DefaultMapInfo); 
	Level.DefaultMapInfo.RestartPlayer(aPlayer.Pawn);

	if (pc != none && ZombiePlayerPawn(pc.Pawn) != None)
	{
		pc.bSnapLevel = 0;
		
		ZombiePlayerPawn(pc.Pawn).UpdateMPPawnClass();
		pc.PlayerReplicationInfo.bWasTerrorist = pc.PlayerReplicationInfo.bTerrorist;
		pc.PlayerReplicationInfo.OldClassIdx = pc.PlayerReplicationInfo.ClassIdx;
		pc.ClientSetMusic(Level.Song, MTRAN_Fade );
	}
	aPlayer.bDuck=0;

}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local PlayerController PC;
	local bool actuallyChanged;

	//kkm--seems like bNewTeam doesn't correspond to whether the team is actually changing
	actuallyChanged = (N==0||N==1) && Other.PlayerReplicationInfo.Team != GameReplicationInfo.Teams[N];

	if (Other!=None && Other.PlayerReplicationInfo!= None && Other.PlayerReplicationInfo.Team !=None)
		Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);

	Other.PlayerReplicationInfo.bTerrorist = N==1;
	Other.PlayerReplicationInfo.bNextTerrorist = Other.PlayerReplicationInfo.bTerrorist;

	if ((N == 1) && bTeamGame)
	{
		//log("ChangeTeam T: " $ GameReplicationInfo @ GameReplicationInfo.Teams[1]);
		GameReplicationInfo.Teams[1].AddToTeam(Other);
	}
	else if (n != 255 && bTeamGame)
	{
		//log("ChangeTeam SF: " $ GameReplicationInfo @ GameReplicationInfo.Teams[0] @ N @ bNewTeam);
		GameReplicationInfo.Teams[0].AddToTeam(Other);
	}

	//kkm--don't send superfluous team changed messages
	if( bTeamGame && actuallyChanged )
	{
		ForEach DynamicActors(class'PlayerController', PC)
		{
			PC.ReceiveLocalizedMessage( class'ZombieMPMessage', 
			                            14, 
			                            Other.PlayerReplicationInfo,
			                            None,
			                            Other.PlayerReplicationInfo.Team );
		}
	}

	return true;
}

function bool PickupQuery( Pawn Other, Pickup item )
{
	local bool PickupQueryRetVal; 
	if ((HealthPickup(item) != none) && (other.Health>=100))
	{
		return false;
	}
	
	PickupQueryRetVal = Super.PickupQuery(Other, item); 
	if (!PickupQueryRetVal) // ??
		item.Destroy(); 
		
	return PickupQueryRetVal; 

}
function Logout(Controller Exiting)
{
	local Controller C;
	local PlayerReplicationInfo PRI;
	local int sfElim;
	local int tElim;
	
	SendMPMessage(MPM_PlayerLeft, Exiting.PlayerReplicationInfo);

	Super.Logout(Exiting);
	
	log("Logout: " $ Exiting @ XBLiveMgr @ XBLiveMgr.IsLiveGame);
		
	if ((XBLiveMgr != none) && (XBLiveMgr.IsLiveGame))
	{
		if (PlayerController(Exiting) != none)
		{
			for( C=Level.ControllerList;C!=None;C=C.NextController )
			{
				PRI = C.PlayerReplicationInfo;
				if(PRI != None)
				{
					SFRMPlayerController(C).PlayerLeft(PlayerController(Exiting).PlayerReplicationInfo);
				}
			}
			
			if (Level.NetMode == NM_DedicatedServer)
			{
	//			log("Calling ChangeNumPlayers directly for ded. Server");
				XBLiveMgr.ChangeNumPlayers(-1);
			}
		}
		else
		{
			XBLiveMgr.ChangeNumPlayers(-1);
		}
	}

	if( bScoreTeamElim )
	{
		CheckTeamElim(sfElim, tElim);

		if ( sfElim != 0 )
			EndGame( GetHighScoreIndividual(1), SFElimText );
		else if( tElim != 0 )
			EndGame( GetHighScoreIndividual(0), TerrElimText );
	}
}

function AddDefaultInventory( pawn PlayerPawn )
{
	Super.AddDefaultInventory(PlayerPawn);
}

/* Return the 'best' player start for this player to start from.
 */
function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string incomingName )
{
	local NavigationPoint N, BestStart;
	local Teleporter Tel;
	local float BestRating, NewRating;
	local byte Team;

//	log("In find player start");

/*	// always pick StartSpot at start of match
    if ( (Player != None) && (Player.StartSpot != None) && (Level.NetMode == NM_Standalone)
		&& (bWaitingToStartMatch || ((Player.PlayerReplicationInfo != None) && Player.PlayerReplicationInfo.bWaitingPlayer))  )
	{
		log("would have picked StartSpot");
		//return Player.StartSpot;
	}	
*/
	if ( GameRulesModifiers != None )
	{
		N = GameRulesModifiers.FindPlayerStart(Player,InTeam,incomingName);
		if ( N != None )
		    return N;
	}

	// if incoming start is specified, then just use it
	if( incomingName!="" )
		foreach AllActors( class 'Teleporter', Tel )
			if( string(Tel.Tag)~=incomingName )
				return Tel;

	// use InTeam if player doesn't have a team yet
	if ( (Player != None) && (Player.PlayerReplicationInfo != None) && !OverrideTeam)
	{
		if ( Player.PlayerReplicationInfo.Team != None )
			Team = Player.PlayerReplicationInfo.Team.TeamIndex;
		else
			Team = 0;
	}
	else
		Team = InTeam;

	for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		NewRating = RatePlayerStart(N,InTeam,Player);
		if ( NewRating > BestRating )
		{
			BestRating = NewRating;
			BestStart = N;
		}
	}
	
	if ( BestStart == None )
	{
		log("Warning - PATHS NOT DEFINED or NO PLAYERSTART");			
		foreach AllActors( class 'NavigationPoint', N )
		{
			NewRating = RatePlayerStart(N,0,Player);
			if ( NewRating > BestRating )
			{
				BestRating = NewRating;
				BestStart = N;	
			}
		}
	}

	return BestStart;
}

/* Rate whether player should choose this NavigationPoint as its start
default implementation is for single player game
*/
function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
	local PlayerStart P;
	local int ret;
	local Pawn a;

	P = PlayerStart(N);
	if ( P != None )
	{
//		log("RatePlayerStart: " $ player @ Team @ P.TeamNumber @ bTeamGame);
		
		if ((bTeamGame || OverrideTeam) && (Team != P.TeamNumber))
		{
			return 0;
		}
		
		if ( P.bEnabled )
		{
			ret = 900+rand(100);	//rand so that all will not be rated equally
			
			foreach CollidingActors(class'Pawn', a, 80, N.Location)
			{
				if (ret >= 300)
				{
					//log("Decreasing StartPoint Rating due to encroachment");
					ret -= 200;
				}
			}
			
//			log("StartPointRating: " $ self @ ret);
			return ret;
		}
		return 20;
	}
	return 0;
}

native event CheckTeamElim(out int sfElim, out int tElim);

function CheckScore(PlayerReplicationInfo Scorer)
{
	local int sfElim;
	local int tElim;

	if( bScoreTeamElim )
	{
		CheckTeamElim( sfElim, tElim) ;

		if ( sfElim != 0 )
			EndGame( GetHighScoreIndividual(1), SFElimText );
		else if( tElim != 0 )
			EndGame( GetHighScoreIndividual(0), TerrElimText );
	}
}

function ScoreKill(Controller Killer, Controller Other)
{
	log("SFRMMP: ScoreKill"@Other@Killer);
	if( (killer == Other) || (killer == None) )
	{
		if (bScoreKills)
		{
			Other.PlayerReplicationInfo.Score -= 1;
		}
		if (GameStats!=None)
			GameStats.ScoreEvent(Other.PlayerReplicationInfo,-1,"self_frag");
	}
	else if ( killer.PlayerReplicationInfo != None )
	{
		if (bScoreKills)
		{
			Killer.PlayerReplicationInfo.Score += 1;
		}
		Killer.PlayerReplicationInfo.Kills++;
		if (GameStats!=None)
			GameStats.ScoreEvent(Killer.PlayerReplicationInfo,1,"frag");
	}

	if ( GameRulesModifiers != None )
		GameRulesModifiers.ScoreKill(Killer, Other);

    //if ( (Killer != None) || (MaxLives > 0) )
	CheckScore(Killer.PlayerReplicationInfo);
}

function SuspendMatch()
{
	if( !IsInState('MatchOver') )
	{
		GotoState( 'PendingMatch' );
	}
}

event StartMatch()
{
	local Controller P;
//SysLinkSPAM	log("Starting Match");

	// get out of PendingMatch
	GotoState( 'MatchInProgress' );

	// kill all dummy pawns
	for( P = Level.ControllerList; P != none; P = P.NextController )
	{
		if( P.Pawn != none )
		{
			P.Pawn.Destroy();
			P.Pawn = none;
		}
	}

	super.StartMatch();
	
//	Log("SFRMMultiPlayer.StartMatch   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
	for ( P = Level.ControllerList; P!=None; P=P.nextController )
	{
		if ( P.IsA('PlayerController') )
		{
			if( P.Pawn != None )
			{
//				Log("SFRMMultiPlayer.StartMatch   P.Pawn slot 3:"$ ZombiePlayerPawn(P.Pawn).Weapons[3].class $" state:"$ ZombiePlayerPawn(P.Pawn).Weapons[3].GetStateName() );
//				Log("SFRMMultiPlayer.StartMatch   P.Pawn slot 1:"$ ZombiePlayerPawn(P.Pawn).Weapons[1].class $" state:"$ ZombiePlayerPawn(P.Pawn).Weapons[1].GetStateName() );
//				Log("SFRMMultiPlayer.StartMatch   P.Pawn slot 0:"$ ZombiePlayerPawn(P.Pawn).Weapons[0].class $" state:"$ ZombiePlayerPawn(P.Pawn).Weapons[0].GetStateName() );
//				SFRMPlayerController(P).loginv();
				if( ZombiePlayerPawn(P.Pawn).Weapons[1] != None )
					SFRMPlayerController(P).EquipSlot(1);
				else if( ZombiePlayerPawn(P.Pawn).Weapons[0] != None )
					SFRMPlayerController(P).EquipSlot(0);
			}

			//JAYFIX: Pass real value here
			PlayerController(P).ClientGameStarted(true);
		}
	}
}

/* Use reduce damage for teamplay modifications, etc.
*/
event int ReduceDamage( int Damage, pawn injured, pawn instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	local int OriginalDamage;

	// no damage while game suspended
	if( bWaitingToStartMatch )
	{
		// always kill them for falling damage so they don't get into places where they shouldn't be.
		// feels like a hack. maybe i should make the artists fix this.
		if( DamageType == class'Fell' || DamageType == class'Crushed' )
		{
			// call explicitly since we ignore Killed in this state
			NotifyKilled( none, injured.Controller, injured, DamageType );
			injured.Died( none, DamageType, HitLocation );
		}

		return 0;
	}

	OriginalDamage = Damage;

	if (((injured.Level.TimeSeconds - injured.LastStartTime) < 2) && !injured.bShotFired)
	{
		return 0;
	}

	if ( injured.InGodMode() ) // God mode
		return 0;

//	Log("SFRMMultiplayer.ReduceDamage    DamageType:"$ DamageType $" sfDT:"$ sfDT $"  FriendlyFireModifier:"$ FriendlyFireModifier );

	if (bTeamGame && (FriendlyFireModifier < 1))
	{
	//	sfDT = class<SFRMDamageType>(DamageType);
		
		if (	(injured.controller.PlayerReplicationInfo.Team == instigatedBy.GetKillerController().PlayerReplicationInfo.Team) &&
				((DamageType == none) || !DamageType.default.bIgnoreFriendlyFire) &&
				(injured != instigatedBy)
			)
		{
			//apply friendly fire modifier
			Damage *= FriendlyFireModifier;
		}
	}

	return Damage*MPDamAdjust;
}

//
// Return whether an item should respawn.
//
function bool ShouldRespawn( Pickup Other )
{
	return Other.ReSpawnTime!=0.0;
}

simulated function PlayerDied(PlayerController pc)
{
	local SFRMPlayerController sfPC;

	log("SFRMMP: PlayerDied");

	if (bGameended)
	{
		log("SFRMMP: Not sending PlayerDied; game is over");
		return;		
	}
			
	sfPC = SFRMPlayerController(pc);
	
	if (sfPC == none)
	{
		log("Non-SFRMPlayerController died!");
		return;
	}
	
	log("SFRMMP: Respawns: " $ sfPC.NumRespawns @ Respawns);
	
	if( Respawns == -1 || sfPC.NumRespawns <= Respawns || bWaitingToStartMatch )
	{
		sfPC.ShowRespawnScreen();
	}
	else
	{
		//go spectate
		pc.GotoState('Spectating');
		pc.PlayerReplicationInfo.bIsSpectator = true;
		sfPC.ShowSpectating();
		sfPC.AdvanceMySpectators();
	}
}

event string GetBeaconText()
{	
	local String levelName;
	local string isLive;

	if ((XBLiveMgr != none) && (XBLiveMgr.IsLiveGame))
	{
		isLive = "1";
	}
	else
	{
		isLive = "0";
	}
	
	levelName = string(Level);
	levelName = Left(levelName, InStr(levelName, "."));
	
	return GameName $ "\\t" $ levelName $ "\\t" $ GetNumPlayers() $ "\\t" $ MaxPlayers $ "\\t" $ isLive $ "\\t" $ Level.ComputerName;
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
    return( class<Pawn>( DynamicLoadObject( DefaultPlayerClassName, class'Class' ) ) );
}

static event int StringReasonToIntReason( string Reason )
{
	// WinReason localization hack
	if( Reason ~= default.TimeUpText )
        return 0;
	else if( Reason ~= default.SFWinText )
		return 1;
	else if( Reason ~= default.TerrWinText )
		return 2;
	else if( Reason ~= default.WinText )
		return 3;
	else if( Reason ~= default.SFElimText )
		return 4;
	else if( Reason ~= default.TerrElimText )
		return 5;
	else if( Reason ~= class'GTVIP'.default.KilledVIPText )
		return 6;
	else if( Reason ~= class'GTVIP'.default.TeamKilledVIPText )
		return 7;
	else if( Reason ~= class'GTVIP'.default.VIPLeftText )
		return 8;
	else if( Reason ~= class'GTVIP'.default.VIPEscapedText )
		return 9;
	else if( Reason ~= class'GTVIP'.default.VIPCommittedSuicideText )
		return 10;
	else if( Reason ~= class'GTVIP'.default.VIPDiedText )
		return 11;
	else // SHOULD NEVER HAPPEN
		return 12;
}

function bool ReadyToStartMatch()
{
	local Controller C;
	local PlayerController P;
	local bool bReady0, bReady1, bLocalPlayerReady;

	// We're ready to start IFF:
	// 1) This is a team game and each side has at least 1 ready player
	// 2) This is not a team game and there are at least 2 ready players
	for( C = Level.ControllerList; C != none; C = C.NextController )
	{
		P = PlayerController(C);

		if( P == none && ZombieBot(C) != none )
		{
			// bots are always ready
			if( bReady0 ) bReady1 = true;
			else          bReady0 = true;
		}
		else if( P != none && P.PlayerReplicationInfo != none
			     && P.bIsPlayer && P.PlayerReplicationInfo.bReadyToPlay )
		{
			if( !bTeamGame )
			{
				// we really need a ?: operator for script...
				if( bReady0 ) bReady1 = true;
				else          bReady0 = true;
			}
			else if( P.PlayerReplicationInfo.bTerrorist )
			{
				bReady1 = true;
			}
			else
			{
				bReady0 = true;
			}

			// never start the game unless at least 1 local player is ready
			if( !bLocalPlayerReady )
			{
				bLocalPlayerReady = Viewport(P.Player) != none;
			}
		}
	}

	return bReady0 && bReady1 && ( Level.NetMode == NM_DedicatedServer || bLocalPlayerReady );
}

auto state PendingMatch
{
ignores Killed, ScoreObjective, EndGame;

	function Timer()
	{
		global.Timer();

		// check if players are ready
		bReadyToStart = ReadyToStartMatch();

		if( bReadyToStart && !bDelayCountdown )
		{
			GameReplicationInfo.bStartedCountDown = true;
			GameReplicationInfo.CountDown = CountDown;
			if( CountDown-- <= 0 )
			{
				StartMatch();
			}
		}
		else
		{
			GameReplicationInfo.bStartedCountDown = false;
			CountDown = default.CountDown;

			if( Level.NetMode == NM_DedicatedServer )
			{
				// kkm--add a little extra time for everybody to roll over
				CountDown += 5;
			}
		}
	}

	function EndState()
	{
		local Projectile proj;

		// nerf all projectiles
		foreach DynamicActors( class'Projectile', proj )
		{
			proj.Damage = 0;
			proj.BotDamage = 0;
			proj.Destroy();
		}

		GameReplicationInfo.bMatchPending = false;
	}

	function BeginState()
	{
		local Controller C;
		local PlayerController P;

		GameReplicationInfo.bStartedCountDown = false;
		CountDown = default.CountDown;
		bWaitingToStartMatch = true;

		// restart spectators
		for( C = Level.ControllerList; C != none; C = C.NextController )
		{
			P = PlayerController(C);
			if( P != none && P.IsInState('Spectating') )
			{
				P.ClientSetBehindView(false);
				P.SetViewTarget(none);
				P.ClientSetViewTarget(none);
				RestartPlayer(P);
			}
		}

		GameReplicationInfo.bMatchPending = true;
	}
}

state MatchInProgress
{
	function Timer()
	{
		global.Timer();

		if( !ReadyToStartMatch() )
		{
			SuspendMatch();
		}
	}

	function Logout( Controller Exiting )
	{
		global.Logout( Exiting );

		if( !ReadyToStartMatch() )
		{
			SuspendMatch();
		}
	}
}

state MatchOver
{
	function BeginState()
	{
		CountDown = default.Countdown;
	}

	function Timer()
	{
		local MapList ml;

		global.Timer();
		if( --CountDown <= 0 && Level.NetMode == NM_DedicatedServer )
		{
			// next map!
			ml = spawn( class'MapList' );
			Level.ServerTravel( ml.GetNextMap(), false );
		}
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    LoadoutClass=Class'MPLoadoutMgr'
    Respawns=-1
    MPDamAdjust=1.0000000
    CountDown=10
    bScoreTeamElim=true
    TimeUpWinner=-1
    SplitScreenCmd="STARTSPLITSCREEN"
    TimeUpText="Time up"
    SFWinText="TF121 Win"
    TerrWinText="OPFOR Win"
    WinText="Wins"
    SFElimText="TF121 Eliminated"
    TerrElimText="OPFOR Eliminated"
    ZombieMessageClass=Class'ZombieMPMessage'
    ClassLimits[0]=-1
    ClassLimits[1]=-1
    ClassLimits[2]=-1
    ClassLimits[3]=-1
    ClassLimits[4]=-1
    ClassLimits[5]=-1
    WinSound=Sound'CBW_DYN_interface.mp.mp_win'
    LoseSound=Sound'CBW_DYN_interface.mp.mp_lose'
    bEnemiesOnRadar=true
    bRestartLevel=false
    bWaitingToStartMatch=true
    bIsMultiplayer=true
    GameDifficulty=2
    DefaultPlayerClassName="ZombieGame.ZombiePlayerPawn"
    ScoreBoardType="ZombieGame.ZombieScoreBoard"
    HUDType="ZombieGame.MPHUD"
    MaxSpectators=8
    DefaultPlayerName="SFRMPlayer"
    GameMessageClass=Class'ZombieNullMessage'
    PlayerControllerClassName="ZombieGame.SFRMPlayerController"
}