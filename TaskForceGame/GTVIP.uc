class GTVIP extends SFRMMultiplayer
native ;

var Sound GameEndSound;
var Sound VIPDiedSound;
var sound VIPRescuedSound;
var bool VipPicked;
var bool bAllTerrDead;
var bool bDenySpawn;
var localized string TerrElimString;
var localized string VIPLeftText;
var localized string WonByText;
var localized string RoundsToText;
var localized string WinningStringTrailerText;
var localized string VIPDiedText;
var localized string KilledVIPText;
var localized string VIPCommittedSuicideText;
var localized string VIPEscapedText;
var localized string TeamKilledVIPText;
var int RoundsLeft;
var int GameRounds;
var bool bRoundEnded;
var bool bInfiniteRounds;
var float RoundEndTimer;
var float RoundEndTime;
var class<ZombieMPMessage> ZombieMPMessageClass;

function bool PlayerCanRestart( PlayerController aPlayer )
{
	//kkm--nobody can respawn in VIP (unless we're waiting for players)
	return bWaitingToStartMatch;
}

native function VIPRoundEnded();
native function VIPGameEnded();
native function StartVIPRound();
native function NativeCheckScore(PlayerReplicationInfo Scorer);
native function PickVIP();
native function MakeControllerVIP(Controller c);
native function ClearVIP();
native function RecordWinner(int round,PlayerReplicationInfo winner,string reason);

event InitGame( string Options, out string Error )
{
	Super.InitGame(Options,Error);

	GameRounds = GetIntOption( Options, "ScoreLimit", 5 );

	if (GameRounds<=0) bInfiniteRounds=true;
	else bInfiniteRounds=false;
	
	RoundsLeft=GameRounds;
	if( GameReplicationInfo != None )
	{
		GameReplicationInfo.ClearServerRoundResults();
		GameReplicationInfo.NumMatchRounds=GameRounds;
		GameReplicationInfo.ExtraWinText="";
	}
	else
	{
		log("My GameReplicationInfo is not ready in InitGame VIP");
	}
	
	//make sure that our respawns can't get altered
	Respawns = 0;
	RoundEndTimer=0;
	bRoundEnded=false;
	bAllTerrDead=false;
	//kkm--MERGEALERT bMatchHasStarted=false;
	bDenySpawn=false;
}

function GetServerDetails( out ServerResponseLine ServerState )
{
	local int i;

	super.GetServerDetails(ServerState);

	i = ServerState.ServerInfo.Length;
	
	ServerState.ServerInfo.Length = i+1;
	ServerState.ServerInfo[i].Key = "GameRounds";
	ServerState.ServerInfo[i++].Value = ""$GameRounds;
}

function Reset()
{
	Super.Reset();
	RoundsLeft=GameRounds;
	Respawns = 0;
	RoundEndTimer=0;
	bRoundEnded=false;
	GameReplicationInfo.ExtraWinText="";
	GameReplicationInfo.ClearServerRoundResults();
	bAllTerrDead=false;
	//kkm--MERGEALERT bMatchHasStarted=false;
	bDenySpawn=false;
}

event ClearStartPoints()
{
	local PlayerStart P;

	log("Calling VIP ClearStartPoints");
	foreach AllActors( class 'PlayerStart', P )
	{
		//P.bEnabled = true;
		P.EnableBasedOnGT();
	}
}

event EndGame( PlayerReplicationInfo Winner, string Reason )
{
	local int ScoreDiff;
	if (bGameEnded || bRoundEnded) return; //protect against doublecalls

	if (bInfiniteRounds)
	{
		GameRounds++;
		RoundsLeft=0;
	}
	
	RecordWinner(GameRounds - RoundsLeft,Winner,Reason);

	//if infinite Rounds is true, RoundsLeft won't be decremented.
	ScoreDiff = abs(GameReplicationInfo.Teams[1].Score - GameReplicationInfo.Teams[0].Score);
	--RoundsLeft;
	if (bInfiniteRounds || RoundsLeft > ScoreDiff )
	{
		VIPRoundEnded();
	}
	else
	{
		//super.EndGame(None,GameReplicationInfo.WinReason );
		VIPGameEnded();
	}

	ClearStartPoints();
}

// called when a running match wants to wait for players.. throws game into stasis
function PauseGame ( )
{
	// allow for spawning since it's waiting for players mode
	bDenySpawn = false;
}

// in vip.. clean up pawns - start the match if needed - start the round
function ResumeGame ( )
{
	local Controller P;
	local Pawn	MyPawn;

	// no spawning allowed now - will enabled when it is
	bDenySpawn = true;

	// loop over all players
	for ( P = Level.ControllerList; P != None; P=P.nextController )
	{
		// verify for verification's sake	
		if ( P.IsA ( 'PlayerController' ) )
		{
			// unposses and destroy if there is a pawn				
			if ( P.Pawn != None )
			{
				// grab the current pawn
				MyPawn = P.Pawn;
				PlayerController ( P ).Unpossess ( );
				MyPawn.Destroy ( );
			}
		}
	}

/*kkm--MERGEALERT
	// if the match hasn't started
	if( !bMatchHasStarted )
	{
		// start match now
		StartMatch ( );
	}
*/

	// start new round
	StartVIPRound ( );
}

event Timer()
{
	Super.Timer();

	// handle end of round stuff
	if ( bRoundEnded )
	{
		RoundEndTimer+=Level.TimeDilation;
		GameReplicationInfo.bStartedCountDown = true;
		GameReplicationInfo.CountDown = int(RoundEndTime-RoundEndTimer+1);
	}
	else
	{
		GameReplicationInfo.bStartedCountDown = false;
	}
	
	// is respawn countdown finished?
	if ( RoundEndTimer > RoundEndTime )
	{	
		// start a new round
		StartVIPRound();
	}	
}

function PlayerReplicationInfo GetTimeUpWinner()
{
	//if time is ever up, VIP loses.  None in the winner is interpreted to be terrorists
	return None;
}

function InitGameReplicationInfo()
{
	super.InitGameReplicationInfo();
	GameReplicationInfo.Teams[0] = spawn(class'ZombieGame.TeamSF');
	GameReplicationInfo.Teams[1] = spawn(class'ZombieGame.TeamTerrorist');
	GameReplicationInfo.VIPRoundNum=1;
	GameReplicationInfo.CountDown=RoundEndTime;
	GameReplicationInfo.ClearServerRoundResults();
	GameReplicationinfo.GoalScore = GameRounds;
}

event PostLogin( PlayerController NewPlayer )
{
	super.PostLogin(NewPlayer);
	NewPlayer.PawnClass = class'ZombieGame.GTVipPawn';
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
    return( class<Pawn>( DynamicLoadObject( DefaultPlayerClassName, class'Class' ) ) );
}

function CheckScore(PlayerReplicationInfo Scorer)
{
	NativeCheckScore(Scorer);
}

event StartMatch()
{
	GameReplicationInfo.NumMatchRounds=GameRounds;

	CurGameLength = 0;
	GameReplicationInfo.RemainingMinute = GameLength;

	ClearVIP();
	PickVIP();

	// don't allow spawning - will turn off when spawning is allowed
	bDenySpawn = true;
	
	super.StartMatch();
}

function SuspendMatch()
{
	if( !bRoundEnded )
	{
		super.SuspendMatch();
	}
}

auto state PendingMatch
{
	function BeginState()
	{
		ClearVIP();
		super.BeginState();
	}
}

event RestartPlayer(Controller aPlayer)
{
	super.RestartPlayer(aPlayer);

	aPlayer.Pawn.Weapon.BringUp();
}

/*kkm--MERGEALERT
event bool GameDeniesPawn ( PlayerController aPlayer )
{
	if ( GameReplicationInfo.IsGameReady ( ) )
	{
		return bDenySpawn;
	}
	else
	{
		return false;
	}
}
*/

function SetDeferredTeamAndClass( Controller aPlayer )
{
	// we do this elsewhere at the start of the round
	local SFRMPlayerController PC;

	if( IsInState('PendingMatch') )
	{
		super.SetDeferredTeamAndClass( aPlayer );
	}
	else
	{
		PC = SFRMPlayerController ( aPlayer );

		//kinda hacky... force players who joined late into spectating mode
		if( aPlayer.PlayerReplicationInfo.ClassIdx == 0 )
		{		
			if ( PC != None && !PC.IsInState( 'Spectating' ) )
			{
				PC.ChangeTeam ( int(PC.PlayerReplicationInfo.bNextTerrorist) );
				PC.GotoState ('Spectating');
				PC.PlayerReplicationInfo.bIsSpectator = true;
				PC.ShowSpectating();
			}
			else
			{
				ChangeTeam ( aPlayer, int ( aPlayer.PlayerReplicationInfo.bNextTerrorist ), true );
			}
		}
	}
}

function Logout( Controller Exiting )
{
	local bool bIsVIP;
	bIsVIP = Exiting.IsA('GTVIPPlayerController') && GTVIPPlayerController(Exiting).IsVIP();
	
	super.Logout(Exiting);

	if( bIsVIP )
	{
		SuspendMatch();
		ClearVIP();
	}
}

/* Return the 'best' player start for this player to start from.
 */
function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string incomingName )
{
	local NavigationPoint N, BestStart;
	local float BestRating, NewRating;
	local byte Team;

	log("In find VIP player start");

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
		foreach AllActors( class 'NavigationPoint', N )
		{
			NewRating = RateBackupPlayerStart(N,0,Player);
			if ( NewRating > BestRating )
			{
				BestRating = NewRating;
				BestStart = N;	
			}
		}
	}
	else
	{
		if( PlayerStart(BestStart) != None )
		{
			log("I chose a start point");
			log(BestStart);
			PlayerStart(BestStart).bEnabled = false;
		}
	}

	return BestStart;
}

/* Rate whether player should choose this NavigationPoint as its start
default implementation is for single player game
*/
function float RateBackupPlayerStart(NavigationPoint N, byte Team, Controller Player)
{
	local PlayerStart P;
	local int ret;
	local Pawn a;

	P = PlayerStart(N);
	if ( P != None )
	{
		//log("RatePlayerStart: " $ player @ Team @ P.TeamNumber @ bTeamGame);
		
		if ((bTeamGame || OverrideTeam) && (Team != P.TeamNumber))
		{
			return 0;
		}
		
		if ( P.bEnabled )
		{
			ret = 900+rand(100);	//rand so that all will not be rated equally
			
			foreach CollidingActors(class'Pawn', a, 150, N.Location)
			{
				if (ret >= 300)
				{
					//log("Decreasing StartPoint Rating due to encroachment");
					ret -= 200;
				}
			}
			
			//log("StartPointRating: " $ self @ ret);
			return ret;
		}
		return 20;
	}
	else
	{
		ret = 500+rand(100);	//rand so that all will not be rated equally
		
		foreach CollidingActors(class'Pawn', a, 150, N.Location)
		{
			if (ret >= 300)
			{
				//log("Decreasing StartPoint Rating due to encroachment");
				ret -= 200;
			}
		}
		
		//log("StartPointRating: " $ self @ ret);
		return ret;
	}

	return 0;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    VIPDiedSound=Sound'CBW_DYN_interface.mp.mp_lose'
    VIPRescuedSound=Sound'CBW_DYN_interface.mp.mp_win'
    TerrElimString="OPFOR Self Destructed"
    VIPLeftText="VIP Left"
    WonByText="won  ("
    RoundsToText="-"
    WinningStringTrailerText=")"
    VIPDiedText="VIP Died"
    KilledVIPText="killed the VIP"
    VIPCommittedSuicideText="VIP Committed Suicide"
    VIPEscapedText="VIP Escaped"
    TeamKilledVIPText="team-killed the VIP"
    RoundsLeft=5
    RoundEndTime=10.0000000
    ZombieMPMessageClass=Class'ZombieMPMessage'
    Respawns=0
    bScoreTeamElim=false
    TimeUpWinner=1
    bTeamGame=true
    DefaultPlayerClassName="ZombieGame.GTVipPawn"
    ScoreBoardType="ZombieGame.VIPScoreBoard"
    GameName="VIP"
    PlayerControllerClassName="ZombieGame.GTVipPlayerController"
    GameTypeID=7
}