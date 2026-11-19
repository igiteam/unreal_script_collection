//=============================================================================
// SASMPGameInfo.
//
//
//=============================================================================
class SASMPGameInfo extends SASGameInfo
	config(user);

var config bool					bTeamScoreRounds;

var float						EndTime;
var globalconfig float			EndTimeDelay;
//var TranslocatorBeacon BeaconList;

// mc - localized PlayInfo descriptions & extra info
var	int							mNumTeams;

var NavigationPoint				LastPlayerStartSpot;    // last place player looking for start spot started from
var NavigationPoint				LastStartSpot;          // last place any player started from

//NetCommunity Stats
var int                         mMapsPlayedCount;  

//
// Return beacon text for serverbeacon.
//
event string GetBeaconText()
{
	local string	serverName, 
					levelName;
	local int		maxPlayers,
					requiresPassword;

	GetBeaconInfo( serverName, levelName, maxPlayers, requiresPassword );
	return serverName$"\\t"$Left(levelName,24)$"\\t"$BeaconName$"\\t"$GetNumPlayers()$"/"$maxPlayers$"\\t"$requiresPassword;
}

          
//::function SpecialEvent(PlayerReplicationInfo Who, string Desc)
//::{
//::	if ( GameStats != None )
//::	{
//::		GameStats.SpecialEvent(Who,Desc);
//::	}
//::}

function KillEvent(string Killtype, PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> Damage)
{
	local TeamPlayerReplicationInfo TPRI;

	if ( (Killer == None) || (Killer == Victim) )
	{
		TeamPlayerReplicationInfo(Victim).Suicides++;
		StatIntOp("suicides", StatOp_set, TeamPlayerReplicationInfo(Victim).Suicides, StatLvl_team, TeamPlayerReplicationInfo(Victim).TeamID);
	}

	TPRI = TeamPlayerReplicationInfo(Killer);

	if ( TPRI != None )
	{
		if ( TPRI != Victim )
		{
			TPRI.AddWeaponKill(Damage);
		}
		TeamPlayerReplicationInfo(Victim).AddWeaponDeath(Damage);
	}

	if ( GameStats != None )
	{
		GameStats.KillEvent(KillType, Killer, Victim, Damage);
	}
}

function GameEvent(string GEvent, string Desc, PlayerReplicationInfo Who)
{
	local TeamPlayerReplicationInfo TPRI;

	if ( GameStats != None )
	{
		GameStats.GameEvent(GEvent, Desc, Who);
	}

	TPRI = TeamPlayerReplicationInfo(Who);

	if ( TPRI == None )
	{
		return;
	}

	if ( (GEvent ~= "flag_taken") || (GEvent ~= "flag_pickup")
		|| (GEvent ~= "bomb_taken") || (GEvent ~= "Bomb_pickup")
		)
	{
		TPRI.FlagTouches++;
		return;
	}

	if ( GEvent ~= "flag_returned" )
	{
		TPRI.FlagReturns++;
		return;
	}
}

function ScoreEvent(PlayerReplicationInfo Who, float Points, string Desc)
{
	if ( GameStats != None )
	{
		GameStats.ScoreEvent(Who,Points,Desc);
	}
}

function TeamScoreEvent(int Team, float Points, string Desc)
{
	if ( GameStats != None )
	{
		GameStats.TeamScoreEvent(Team,Points,Desc);
	}
}

function bool ShouldRespawn(Pickup Other)
{
	return false;
}

//::function float SpawnWait(AIController B)
//::{
//::	if ( B.PlayerReplicationInfo.bOutOfLives )
//::	{
//::		return 999;
//::	}
//::	if ( Level.NetMode == NM_Standalone )
//::	{
//::		return ( 0.5 * FMax(2,NumBots-4) * FRand() );
//::	}
//::	return FRand();
//::}

function ChangeLoadOut(PlayerController P, string LoadoutName);
//function ForceAddBot();

/* only allow pickups if they are in the pawns loadout
*/
/*function bool PickupQuery(Pawn Other, Pickup item)
{
	local byte bAllowPickup;

	if ( (GameRulesModifiers != None) && GameRulesModifiers.OverridePickupQuery(Other, item, bAllowPickup) )
	{
		return (bAllowPickup == 1);
	}

	if ( (UnrealPawn(Other) != None) && !UnrealPawn(Other).IsInLoadout(item.inventorytype) )
	{
		return false;
	}

	if ( Other.Inventory == None )
	{
		return true;
	}
	else
	{
		return !Other.Inventory.HandlePickupQuery(Item);
	}
}
*/

//------------------------------------------------------------------------------
// PostBeginPlay
//
// Initialise the teams
event PostBeginPlay()
{
	GameReplicationInfo.Teams[0] = Spawn ( class'SASTeamSAS' );
	GameReplicationInfo.Teams[1] = Spawn ( class'SASTeamTerrorist' );
	
	GameReplicationInfo.Teams[0].TeamIndex = 0;
	GameReplicationInfo.Teams[1].TeamIndex = 1;

	NewTeam("SAS", 0);
	NewTeam("Terrorist", 1);
//	NewTeam(g1,0, _T("Team number 1"));
//	NewTeam(g1,1, _T("Team number 2"));
	
	Super.PostBeginPlay ();
}

//------------------------------------------------------------------------------
// ChangeTeam
//
// also used to assign to team
function bool ChangeTeam ( Controller Other, int N, bool bNewTeam )
{
	local TeamInfo	newTeam;

	if ( Other.IsA ('PlayerController' ) && Other.PlayerReplicationInfo.bOnlySpectator )
	{
		Other.PlayerReplicationInfo.Team = None;
		return true;
	}

	newTeam = GameReplicationInfo.Teams[PickTeam ( N, Other )];

	Other.StartSpot = None;

	if ( Other.PlayerReplicationInfo.Team != None )
	{
		Other.PlayerReplicationInfo.Team.RemoveFromTeam ( Other );
	}
	
	newTeam.AddToTeam ( Other );

	return true;
}

//------------------------------------------------------------------------------
// RatePlayerStart
//
// Rate whether player should choose this NavigationPoint as its start
function float RatePlayerStart ( NavigationPoint N, byte Team, Controller Player )
{
	local SASSpawnPoint	P;
	local float			Score,
						NextDist;
	local Controller	OtherPlayer;

	P = SASSpawnPoint ( N );

	if ( (P == None) || !P.bEnabled || P.PhysicsVolume.bWaterVolume )
	{
		return -10000000;
	}

	if ( P.TeamNumber != Team )
	{
		return -10000000;
	}

	//assess candidate
	if ( P.bPrimaryStart )
	{
		Score = 10000000;
	}
	else
	{
		Score = 5000000;
	}
	if ( (N == LastStartSpot) || (N == LastPlayerStartSpot) )
	{
		Score -= 10000.0;
	}
	else
	{
		Score += 3000 * FRand(); //randomize
	}

	if ( Level.TimeSeconds - P.LastSpawnCampTime < 30 )
	{
		Score = Score - (30 - P.LastSpawnCampTime + Level.TimeSeconds) * 1000;
	}

	for ( OtherPlayer=Level.ControllerList; OtherPlayer!=None; OtherPlayer=OtherPlayer.NextController)
	{
		if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) )
		{
			if ( OtherPlayer.Pawn.Region.Zone == N.Region.Zone )
			{
				Score -= 1500;
			}
			NextDist = VSize(OtherPlayer.Pawn.Location - N.Location);
			if ( NextDist < OtherPlayer.Pawn.CollisionRadius + OtherPlayer.Pawn.CollisionHeight )
			{
				Score -= 1000000.0;
			}
			else if ( (NextDist < 3000) && FastTrace(N.Location, OtherPlayer.Pawn.Location) )
			{
				Score -= (10000.0 - NextDist);
			}
			else if ( NumPlayers == 2 )
			{
				Score += 2 * VSize(OtherPlayer.Pawn.Location - N.Location);
				if ( FastTrace(N.Location, OtherPlayer.Pawn.Location) )
				{
					Score -= 10000;
				}
			}
		}
	}
	return FMax(Score, 5);
}

//Net Community Stats
//sudhir
//called from GameInfo.Login()event
function SASMPMapsPlayedCountStats(PlayerController player)
{	
	local string mapname;
		
	//these are for references..
	//can update them later.
	/*local NavigationPoint StartSpot;
	local PlayerController NewPlayer;
	local Pawn            TestPawn;
	local string          InName, InAdminName, InPassword, InChecksum, InClass, InCharacter; 
	local byte            InTeam;
	local bool bSpectator,bAdmin;
	local class<Security> MySecurityClass;*/ 
		
	//NetCommunityLog("Player Logged in "$NewPlayer,'Net Community Stats');	
	
	//add code to the game stats object
	if (GameStats!=None)
	{
		GameStats.NewGame();		
		mapname=GameStats.MapName();
	}
		
	//NetCommunityLog("PLayer Name       :"$Level.PlayerReplicationInfo.PlayerName,'Net Community Stats');
	NetCommunityLog("Player Joined Map :"$mapname,'Net Community Stats');	
	
	//get player controller.playerclass.mapsplayed++;
	mMapsPlayedCount++;
	
	NetCommunityLog("Player MapCount is : "$mMapsPlayedCount,'Net Community Stats');
	NewPlayer(Player.PlayerReplicationInfo.PlayerName, Player.PlayerReplicationInfo.PlayerID);
	
}

function StartMatch ()
{
	local Controller	P;

	Super.StartMatch();

	// Reset level time for each controller.
	for ( P = Level.ControllerList; P != None; P = P.nextController )
	{
		if ( P.IsA( 'SASPlayerController' ) )
		{
			SASPlayerController( P ).ClientRestartLevelTime();
		}
	}
}

// override single player method
function SPInitSquad () {}

//------------------------------------------------------------------------------
//
//

// Decompiled with UE Explorer.
defaultproperties
{
    EndTimeDelay=4.0000000
    mNumTeams=2
    mSquadManagerClassName="SASMPGame.SASMPSquadManager"
    bKeepSamePlayerStart=true
    DeathMessageClass=Class'SASDMDeathMessage'
    PlayerControllerClassName="SASMPGame.SASMPPlayerController"
    GameReplicationInfoClass=Class'SASMPGRI'
}