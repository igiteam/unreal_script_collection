////////////////////////////////////////////////////////////////////////////////
// SASMPGameInfoCommon.uc
//
// Stuff that was duplicated between all game infos
////////////////////////////////////////////////////////////////////////////////

class SASMPGameInfoCommon extends SASMPGameInfo
	config(user);

//#exec OBJ LOAD FILE=TeamSymbols_UT2003.utx

var globalconfig int NetWait;       // time to wait for players in netgames w/ bNetReady (typically team games)
var globalconfig int RestartWait;

var config int				MinStartingHumanPlayers;// minimum number of humans before a match may start.

var globalconfig bool		bTournament;			// number of players must equal maxplayers for game to start
var config bool				bPlayersMustBeReady;	// players must confirm ready for game to start
var config bool				bForceRespawn;
var config int				mRepeatLevel;
var config bool				bAllowTaunts;
var bool					bMustJoinBeforeStart;   // players can only spectate if they join after the game starts
var bool					bFirstBlood;
var bool					bQuickStart;
var bool					bFinalStartup;
var bool					bOverTimeBroadcast;

var byte					StartupStage;			// what startup message to display
var int						RemainingTime,
							ElapsedTime;
var int						CountDown;
var class<LevelGameRules>	LevelRulesClass;
var LevelGameRules			LevelRules;				// level designer overriding of game settings (hook for mod authors)
var config float			SpawnProtectionTime;
var SASTeamInfo				EnemyRoster;
var string					EnemyRosterName;
var string					DefaultEnemyRosterClass;

//var NavigationPoint			LastPlayerStartSpot;    // last place player looking for start spot started from
//var NavigationPoint			LastStartSpot;          // last place any player started from

var int						NameNumber;             // append to ensure unique name if duplicate player name change requested

var int						EndMessageWait;         // wait before playing which team won the match
var transient int			EndMessageCounter;      // end message counter
var Sound					EndGameSound[2];        // end game sounds
var Sound					AltEndGameSound[2];
var int						SinglePlayerWait;       // single-player wait delay before auto-returning to menus

var globalconfig string		NamePrefixes[10];		// for bots with same name
var globalconfig string		NameSuffixes[10];		// for bots with same name

var actor					EndGameFocus;
var PlayerController		StandalonePlayer;

// mc - localized PlayInfo descriptions & extra info
//var private localized string DMPropsDisplayText[10];

var() float ADR_Kill;
var() float ADR_MajorKill;
var() float ADR_MinorError;
var() float ADR_MinorBonus;
var() float ADR_KillTeamMate;

function PostBeginPlay()
{
	local PlayerController		Player;
	local Controller			P;
	NameNumber = rand(10);
	
	// change everyone's team as dictated by their performance
	for ( P = Level.ControllerList; P != None; P = P.NextController )
	{
		Player = PlayerController ( P );
		if ( Player != None )
		{
			// Let's change the player to the correct team based on what happened this turn.
			if ((Player.PlayerReplicationInfo.TeamIndexForNextGame == 0 || Player.PlayerReplicationInfo.TeamIndexForNextGame == 1) &&
				Player.PlayerReplicationInfo.TeamIndexForNextGame != Player.PlayerReplicationInfo.Team.TeamIndex)
			{
				// This player has a new team to change to.
				ChangeTeam(Player, Player.PlayerReplicationInfo.TeamIndexForNextGame, true);
			}
		}
	}	
	
	
	
	Super.PostBeginPlay();
	GameReplicationInfo.RemainingTime = RemainingTime;
//	InitTeamSymbols();
}

event PreLogin
(
	string Options,
	string Address,
	out string Error,
	out string FailCode
)
{
	Super.PreLogin(Options,Address,Error,FailCode);
	
	// any game-mode-specific check
	ExtraPreLoginCheck(Error, FailCode);
}

// nothing at all in the base case.
function ExtraPreLoginCheck(out String Error, out string FailCode)
{
}

function InitSquad()
{
	// no squad in any mp mode
}

event PlayerController Login
(
	string Portal,
	string Options,
	out string Error
)
{
	local PlayerController NewPlayer;

	NewPlayer = Super.Login(Portal,Options,Error);
	if ( bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun )
	{
		NewPlayer.PlayerReplicationInfo.bLatecomer = true;
	}

	if ( Level.NetMode == NM_Standalone )
	{
		if( NewPlayer.PlayerReplicationInfo.bOnlySpectator )
		{
			// Compensate for the space left for the player
			//if ( !bCustomBots )
			//{
			//	InitialBots++;
			//}
		}
		else
		{
			StandalonePlayer = NewPlayer;
		}
	}

	return NewPlayer;
}

//::function InitTeamSymbols ()
//::{
//::	local int i;
//::
//::	// default team textures (for banners, etc.)
//::	if ( bTeamGame )
//::	{
//::		for ( i = 0; i < mNumTeams; i++ )
//::		{
//::			if ( GameReplicationInfo.Teams[i].TeamIcon == None )
//::			{
//::				GameReplicationInfo.Teams[i].TeamIcon = GetRandomTeamSymbol ( i * 10 );
//::			}
//::		}
//::		GameReplicationInfo.TeamSymbolNotify ();
//::	}
//::}

/* Reset()
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();
	ElapsedTime = NetWait - 3;
	bFinalStartup = false;
	CountDown = Default.Countdown;
	RemainingTime = 60 * TimeLimit;
	GameReplicationInfo.RemainingTime = RemainingTime;
	bOverTimeBroadcast = false;
	GotoState('PendingMatch');
}

/* CheckReady()
If tournament game, make sure that there is a valid game winning criterion
*/
function CheckReady()
{
	if ( (DaggerLimit == 0) && (KillLimit == 0) && (TimeLimit == 0) )
	{
		TimeLimit = 20;
		RemainingTime = 60 * TimeLimit;
	}
}

// Monitor killed messages for fraglimit
function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	local bool bEnemyKill;

	bEnemyKill = ( !bTeamGame || ((Killer != None) && (Killer != Killed) && (Killed != None)
								&& (Killer.PlayerReplicationInfo != None) && (Killed.PlayerReplicationInfo != None)
								&& (Killer.PlayerReplicationInfo.Team != Killed.PlayerReplicationInfo.Team)) );
	if ( SASMPPlayerController(Killer) != None )
	{
		SASMPPlayerController(Killer).LogMultiKills(ADR_MajorKill, bEnemyKill);
	}

	// GP: No sprees in SAS.
	/*if ( (SASPawn(KilledPawn) != None) && (SASPawn(KilledPawn).Spree > 4) )
	{
		EndSpree(Killer, Killed);
	}*/
	if ( (Killer != None) && Killer.bIsPlayer && (Killed != None) && Killed.bIsPlayer )
	{
		DamageType.static.IncrementKills(Killer);

		// GP: No first blood messages in SAS.
		/*
		if ( !bFirstBlood && (Killer != Killed) && bEnemyKill )
		{
			bFirstBlood = True;
			BroadcastLocalizedMessage( class'FirstBloodMessage', 0, Killer.PlayerReplicationInfo );
			SpecialEvent(Killer.PlayerReplicationInfo,"first_blood");
		}
		*/

		// GP: No sprees in SAS.
		/*if ( (Killer != Killed)
			&& (!bTeamGame || (Killed.PlayerReplicationInfo.Team != Killer.PlayerReplicationInfo.Team))
			&& (SASPawn(Killer.Pawn) != None) )
		{
			SASPawn(Killer.Pawn).Spree++;
			if ( SASPawn(Killer.Pawn).Spree > 4 )
			{
				NotifySpree(Killer, SASPawn(Killer.Pawn).Spree);
			}
		}*/
	}
	Super.Killed(Killer, Killed, KilledPawn, damageType);
}

function AddGameSpecificInventory(Pawn p)
{
	Super.AddGameSpecificInventory(p);
}

// Parse options for this game...
event InitGame( string Options, out string Error )
{
	local string InOpt;

	// find Level's LevelGameRules actor if it exists
	ForEach AllActors(class'LevelGameRules', LevelRules)
	{
		break;
	}

	if ( LevelRules != None )
	{
		LevelRules.UpdateGame(self);
	}

	Super.InitGame(Options, Error);

	SetGameSpeed(GameSpeed);
	DaggerLimit = Max(0,GetIntOption( Options, "DaggerLimit", DaggerLimit ));
	KillLimit = Max(0,GetIntOption( Options, "KillLimit", KillLimit ));
	TimeLimit = Max(0,GetIntOption( Options, "TimeLimit", TimeLimit ));
	InOpt = ParseOption( Options, "RepeatLevel");
	if ( InOpt != "" )
	{
		mRepeatLevel = int(InOpt);
		log("Repeat level "$mRepeatLevel);
	}
	InOpt = ParseOption( Options, "PlayersMustBeReady");
	if ( InOpt != "" )
	{
    	log("PlayerMustBeReady: "$Bool(InOpt));
		bPlayersMustBeReady = bool(InOpt);
	}

	EnemyRosterName = ParseOption( Options, "Team");

	RemainingTime = 60 * TimeLimit;

	InOpt = ParseOption( Options, "WeaponStay");
	if ( InOpt != "" )
	{
		log("WeaponStay: "$bool(InOpt));
		bWeaponStay = bool(InOpt);
	}

	bTournament = (GetIntOption( Options, "Tournament", 0 ) > 0);
	if ( bTournament )
	{
		CheckReady();
	}

	InOpt = ParseOption(Options,"QuickStart");
	if ( InOpt != "" )
	{
		bQuickStart = true;
	}
}

//::function Texture GetRandomTeamSymbol(int base)
//::{
//::	local string SymbolName;
//::	local int SymbolIndex;
//::
//::	SymbolIndex = base + Rand(9);
//::
//::	if (SymbolIndex < 9)
//::	{
//::		SymbolName = "TeamSymbols_UT2003.Sym0" $ SymbolIndex+1;
//::	}
//::	else
//::	{
//::		SymbolName = "TeamSymbols_UT2003.Sym" $ SymbolIndex+1;
//::	}
//::
//::	return Texture(DynamicLoadObject(SymbolName, class'Texture'));
//::}

/* AcceptInventory()
Examine the passed player's inventory, and accept or discard each item
* AcceptInventory needs to gracefully handle the case of some inventory
being accepted but other inventory not being accepted (such as the default
weapon).  There are several things that can go wrong: A weapon's
AmmoType not being accepted but the weapon being accepted -- the weapon
should be killed off. Or the player's selected inventory item, active
weapon, etc. not being accepted, leaving the player weaponless or leaving
the HUD inventory rendering messed up (AcceptInventory should pick another
applicable weapon/item as current).
*/
function AcceptInventory(pawn PlayerPawn)
{
	while ( PlayerPawn.Inventory != None )
	{
		PlayerPawn.Inventory.Destroy();
	}

	PlayerPawn.Weapon = None;
	PlayerPawn.SelectedItem = None;
	AddDefaultInventory( PlayerPawn );
}

function PlayWinMessage(PlayerController Player, bool bWinner)
{
	if ( SASMPPlayerController(Player) != None )
	{
		SASMPPlayerController(Player).PlayWinMessage(bWinner);
	}
}

function bool AtCapacity ( bool bSpectator )
{
	if ( Level.NetMode == NM_Standalone )
	{
		return false;
	}

	return ( NumPlayers + NumSpectators >= MaxPlayers + MaxSpectators );
}

event PostLogin ( playercontroller NewPlayer )
{
	Super.PostLogin ( NewPlayer );
	SASMPPlayerController ( NewPlayer ).PlayStartUpMessage ( StartupStage );
}

function ChangeLoadOut ( PlayerController P, string LoadoutName )
{
	local class<SASPawn> NewLoadout;

	NewLoadout = class<SASPawn>(DynamicLoadObject(LoadoutName,class'Class'));
	if ( (NewLoadout != None) &&
			((SASTeamInfo(P.PlayerReplicationInfo.Team) == None) ||
			SASTeamInfo(P.PlayerReplicationInfo.Team).BelongsOnTeam(NewLoadout)) )
	{
		P.PawnClass = NewLoadout;
		if (P.Pawn!=None)
		{
			P.ClientMessage("Your next class is "$P.PawnClass.Default.MenuName);
		}
	}
}

function bool CanSpectate( PlayerController Viewer, bool bOnlySpectator, actor ViewTarget )
{
	local Controller	C;

	if ( ViewTarget == None )
	{
		return false;
	}

	// Only view player pawns (PAWN_Soldier - even Sabre squad terrorists are this type) which 
	// are active in game (non-spectating).
	C = Controller(ViewTarget);
	if (	C != None && 
			C.Pawn != None && 
			C.Pawn.mPawnType == PAWN_Soldier &&
			C.Pawn.Health > 0 &&
			C.PlayerReplicationInfo != None &&
			!C.PlayerReplicationInfo.bOnlySpectator )
	{
		return true;
	}
	return ( Level.NetMode == NM_Standalone );
}

function bool ShouldRespawn(Pickup Other)
{
	return ( Other.ReSpawnTime!=0.0 );
}

function ChangeName(Controller Other, string S, bool bNameChange)
{
	local Controller APlayer,C;

	if ( S == "" )
	{
		return;
	}

	if (Other.PlayerReplicationInfo.playername~=S)
	{
		return;
	}

	S = Left(S,20);
	ReplaceText(S, " ", "_");

	for( APlayer = Level.ControllerList; APlayer != None; APlayer = APlayer.nextController )
	{
		if ( APlayer.bIsPlayer && ( APlayer.PlayerReplicationInfo.playername ~= S ) )
		{
			if ( Other.IsA('PlayerController') )
			{
				PlayerController(Other).ReceiveLocalizedMessage( GameMessageClass, 8 );
				return;
			}
			else
			{
				S = NamePrefixes[NameNumber%10]$S$NameSuffixes[NameNumber%10];
				NameNumber++;
				break;
			}
		}
	}

	if( bNameChange )
	{
		GameEvent ( "NameChange", S, Other.PlayerReplicationInfo );
	}

	Other.PlayerReplicationInfo.SetPlayerName(S);
	// notify local players
	if  ( bNameChange )
	{
		for ( C=Level.ControllerList; C!=None; C=C.NextController )
		{
			if ( (PlayerController(C) != None) && (Viewport(PlayerController(C).Player) != None) )
			{
				PlayerController(C).ReceiveLocalizedMessage( class'GameMessage', 2, Other.PlayerReplicationInfo );
			}
		}
	}
}

function Logout(controller Exiting)
{
	Super.Logout(Exiting);

	CheckLevelEndConditions();
}

function CheckLevelEndConditions();

//------------------------------------------------------------------------------
// Game Querying.

function GetServerDetails( out ServerResponseLine ServerState )
{
	local int i;

	Super.GetServerDetails( ServerState );

	i = ServerState.ServerInfo.Length;

	// Gamespy Stats & Trackin
	if (mGameTypeId == 1)
	{
		// Only need these in death match
		StatIntOp("daggerlimit", StatOp_set, DaggerLimit, StatLvl_server, 0);
		StatIntOp("killlimit", StatOp_set, KillLimit, StatLvl_server, 0);
		StatIntOp("timelimit", StatOp_set, TimeLimit, StatLvl_server, 0);
	}

	// DaggerLimit
	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "daggerlimit";
	ServerState.ServerInfo[i++].Value = string(DaggerLimit);
	
	// KillLimit
	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "killlimit";
	ServerState.ServerInfo[i++].Value = string(KillLimit);

	// timelimit
	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "timelimit";
	ServerState.ServerInfo[i++].Value = string(TimeLimit);

	// weaponstay
	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "weaponstay";
	if( bWeaponStay )
	{
		ServerState.ServerInfo[i++].Value = "true";
	}
	else
	{
		ServerState.ServerInfo[i++].Value = "false";
	}
}

function InitGameReplicationInfo()
{
	Super.InitGameReplicationInfo();
	GameReplicationInfo.DaggerLimit = KillLimit;
	GameReplicationInfo.KillLimit = KillLimit;
	GameReplicationInfo.TimeLimit = TimeLimit;
}

function PlayEndOfMatchMessage()
{
	local controller C;

	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{
		if ( C.IsA('PlayerController') && !C.PlayerReplicationInfo.bOnlySpectator )
		{
			if (C.PlayerReplicationInfo == GameReplicationInfo.Winner)
			{
				PlayerController(C).PlayAnnouncement(EndGameSound[0],1,true);
			}
			else
			{
				PlayerController(C).PlayAnnouncement(EndGameSound[1],1,true);
			}
		}
	}
}

function PlayStartupMessage ()
{
	local Controller P;

	// keep message displayed for waiting players
	for ( P = Level.ControllerList; P != None; P = P.NextController )
	{
		if ( SASMPPlayerController ( P ) != None )
		{
			SASMPPlayerController ( P ).PlayStartUpMessage ( StartupStage );
		}
	}
}

function HumanPlayerStartMatch()
{
	// in multiplayer, the human players aren't actually placed on the start of the match, but at the
	// start of the countdown.
}

function StartMatch()
{
	local controller C;

	GotoState ( 'MatchInProgress' );

	GameReplicationInfo.RemainingMinute = RemainingTime;


	// and therefore, we have to do some extra stuff at the start of the match that we would
	// have normally done earlier.
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{
		if ( C.IsA('PlayerController') )
		{
			PlayerController(C).EnterStartState();
		}
	}
	
	// and then do whatever else.
	Super.StartMatch();
	
	// setup squad
	InitSquad ();

	log ( "START MATCH" );
}
	

auto State PendingMatch
{
	// This function gets called once a second from when the server begins the level.
	function Timer()
	{
		Global.Timer();

		// If there are no players at all, keep on waiting.
		if ( NumPlayers < MinStartingHumanPlayers )
		{
			StartupStage = -1;
			return;
		}

		StartupStage = 0;

		// So we've got some players. We'll begin as soon as the server player is ready.
		if ( Level.GetLocalPlayerController().PlayerReplicationInfo.bReadyToPlay )
		{
			if (CountDown == Default.Countdown)
			{
				// We've just set off. Let's stick our players somewhere nice.
				ResetHumanPlayers();
			}				
			
			CountDown--;
			
			if ( CountDown <= 0 )
			{
				StartMatch ();
			}
			
			StartupStage = 4 - CountDown;
		}
		
		PlayStartupMessage ();
	}

	function BeginState ()
	{
		bWaitingToStartMatch = true;
		StartupStage = 0;
	}

Begin:
	if ( bQuickStart )
	{
		StartMatch();
	}
}

State MatchInProgress
{
	function Timer ()
	{
		local Controller P;
		local SASMPPlayerController Mp;

		Global.Timer ();
		if ( !bFinalStartup )
		{
			bFinalStartup = true;
			PlayStartupMessage();
		}

		for ( P = Level.ControllerList; P != None; P = P.NextController )
		{
			if ( P.IsA ( 'SASMPPlayerController' )
				&& !P.PlayerReplicationInfo.bOnlySpectator )
			{
				Mp = SASMPPlayerController(P);
				Mp.UpdateMPStats();
			}
		}


		if ( bForceRespawn )
		{
			for ( P = Level.ControllerList; P != None; P = P.NextController )
			{
				if ( ( P.Pawn == None )
					&& P.IsA ( 'PlayerController' )
					&& !P.PlayerReplicationInfo.bOnlySpectator )
				{
					PlayerController ( P ).ServerReStartPlayer ();
				}
			}
		}

		if ( bOverTime )
		{
			 EndGame ( None, "TimeLimit" );
		}
		else if ( TimeLimit > 0 )
		{
			GameReplicationInfo.bStopCountDown = false;
			RemainingTime--;
			GameReplicationInfo.RemainingTime = RemainingTime;
			if ( RemainingTime % 60 == 0 )
			{
				GameReplicationInfo.RemainingMinute = RemainingTime;
			}
			if ( RemainingTime <= 0 )
			{
				EndGame ( None, "TimeLimit" );
			}
		}
		
		CheckLevelEndConditions();

		ElapsedTime++;
		GameReplicationInfo.ElapsedTime = ElapsedTime;
	}

	function BeginState ()
	{
		local PlayerReplicationInfo PRI;

		ForEach DynamicActors ( class'PlayerReplicationInfo', PRI )
		{
			PRI.StartTime = 0;
		}
		ElapsedTime = 0;
		bWaitingToStartMatch = false;
		StartupStage = 5;
		PlayStartupMessage ();
		StartupStage = 6;

		SASGRI ( GameReplicationInfo ).TimeRestart ();
	}
}

function EndGame(PlayerReplicationInfo Winner, string Reason )
{
	Super.EndGame(Winner,Reason);
}

State MatchOver
{

	function BeginState()
	{
		StatSnapshot();		
	}
		
	function ScoreKill(Controller Killer, Controller Other) {}
	function int ReduceDamage( int Damage, pawn injured, pawn instigatedBy, vector HitLocation, class<DamageType> DamageType )
	{
		return 0;
	}
/*

	function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
	{
		return false;
	}
*/
}

/* CheckScore()
see if this score means the game ends
*/
function CheckScore(PlayerReplicationInfo Scorer)
{
	//JS currently nothing like this ends the game
	return;

/*	
	local controller C;

	if ( CheckMaxLives(Scorer) )
	{
		return;
	}

	if ( (GameRulesModifiers != None) && GameRulesModifiers.CheckScore(Scorer) )
	{
		return;
	}

	if ( Scorer != None )
	{
		if ( (KillLimit > 0) && (Scorer.KillScore >= KillLimit) )
		{
			EndGame(Scorer,"killlimit");
		}
		if ( (DaggerLimit > 0) && (Scorer.DaggerScore >= DaggerLimit) )
		{
			EndGame(Scorer,"daggerlimit");
		}
		else if ( bOverTime )
		{
			// end game only if scorer has highest score
			for ( C=Level.ControllerList; C!=None; C=C.NextController )
				if ( (C.PlayerReplicationInfo != None)
					&& (C.PlayerReplicationInfo != Scorer)
					&& (C.PlayerReplicationInfo.Score >= Scorer.Score) )
					return;
        	EndGame(Scorer,"fraglimit");
		}
	}*/
}

function ScoreKill(Controller Killer, Controller Other)
{
	local PlayerReplicationInfo OtherPRI;

	OtherPRI = Other.PlayerReplicationInfo;
	if ( OtherPRI != None )
	{
		OtherPRI.NumLives++;
	}

	if ( bAllowTaunts && (Killer != None) && (Killer != Other) && Killer.AutoTaunt() && (Killer.PlayerReplicationInfo.VoiceType != None) )
	{
		if( Killer.IsA('PlayerController') )
		{
			Killer.SendMessage(OtherPRI, 'AUTOTAUNT', Killer.PlayerReplicationInfo.VoiceType.static.PickRandomTauntFor(Killer, false, false), 10, 'GLOBAL');
		}
		else
		{
			Killer.SendMessage(OtherPRI, 'AUTOTAUNT', Killer.PlayerReplicationInfo.VoiceType.static.PickRandomTauntFor(Killer, false, true), 10, 'GLOBAL');
		}
	}
	Super.ScoreKill(Killer,Other);

	if ( (killer == None) || (Other == None) )
	{
		return;
	}
}

// No Spree stuff in SAS.
/*
function NotifySpree(Controller Other, int num)
{
	local Controller C;

	if ( num == 5 )
		num = 0;
	else if ( num == 10 )
		num = 1;
	else if ( num == 15 )
		num = 2;
	else if ( num == 20 )
		num = 3;
	else if ( num == 25 )
		num = 4;
	else if ( num == 30 )
		num = 5;
	else
		return;

	SpecialEvent(Other.PlayerReplicationInfo,"spree_"$(num+1));

	for ( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		if ( PlayerController(C) != None )
		{
			PlayerController(C).ReceiveLocalizedMessage( class'KillingSpreeMessage', Num, Other.PlayerReplicationInfo );
		}
	}
}

function EndSpree(Controller Killer, Controller Other)
{
	local Controller C;

	if ( (Other == None) || !Other.bIsPlayer )
	{
		return;
	}
	for ( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		if ( PlayerController(C) != None )
		{
			if ( (Killer == Other) || (Killer == None) || !Killer.bIsPlayer )
			{
				PlayerController(C).ReceiveLocalizedMessage( class'KillingSpreeMessage', 1, None, Other.PlayerReplicationInfo );
			}
			else
			{
				PlayerController(C).ReceiveLocalizedMessage( class'KillingSpreeMessage', 0, Other.PlayerReplicationInfo, Killer.PlayerReplicationInfo );
			}
		}
	}
}
*/

// Decompiled with UE Explorer.
defaultproperties
{
    bAllowTaunts=true
    bMustJoinBeforeStart=true
    CountDown=4
    SpawnProtectionTime=2.0000000
    EndMessageWait=5
    NamePrefixes[0]="Mr_"
    NamePrefixes[2]="The_Real_"
    NamePrefixes[3]="Evil_"
    NamePrefixes[5]="Owns_"
    NamePrefixes[7]="Evil_"
    NamePrefixes[9]="Johnny_"
    NameSuffixes[1]="_is_lame"
    NameSuffixes[4]="_sucks"
    NameSuffixes[6]="_OwnsYou"
    NameSuffixes[8]="_jr"
    NameSuffixes[9]="'s_clone"
    ADR_Kill=5.0000000
    ADR_MajorKill=10.0000000
    ADR_MinorError=-2.0000000
    ADR_MinorBonus=5.0000000
    ADR_KillTeamMate=-5.0000000
    bRestartLevel=false
    bPauseable=false
    bTeamGame=true
    bDelayedStart=true
    bWaitingToStartMatch=true
    AutoAim=1.0000000
    DefaultPlayerClassName="SASChars.SASTrooperA"
    KillLimit=255
    DaggerLimit=255
}