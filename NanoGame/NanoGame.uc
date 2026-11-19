/**
 * NanoGame
 * Nano Game Info
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoGame extends GameInfo
	config(Game)
	native
	abstract;


/** manager object for GUDS */
// will be promoted to gameframework so then we can use it also
//var GUDManager			UnscriptedDialogueManager;


/** Spectator Camera Points */
//var transient protected array<NanoSpectatorPoint> SpectatorPoints;

// to get to compile
var bool bAllowFriendlyFire;
/** Generic weapons disappear after x secs - 0 means they don't disappear */
var() config float WeaponFadeTimeGeneric;
/** Special weapons disappear after x secs - 0 means they don't disappear */
var() config float WeaponFadeTimeSpecial;


var array<NanoTeamInfo> Teams;
var class<NanoTeamInfo> TeamClass;
var config int NumTeams;


/** gamewide monitor object for battle status */
var BattleStatusMonitor BattleMonitor;

var array<FlightVolume>	FlightVolumes;

struct native PointClaim
{
	var NanoAI Claimer;
	var Actor Point;
};
var array<PointClaim> PointClaims;


cpptext
{
	virtual UBOOL Tick( FLOAT DeltaSeconds, ELevelTick TickType );
}

final function bool ClaimPoint(Actor Point, NanoAI Claimer)
{
	local int Idx;
	Idx = PointClaims.Find('Point',Point);
	if (Idx != INDEX_None)
	{
		if (PointClaims[Idx].Claimer == Claimer)
		{
			return TRUE;
		}
		if (PointClaims[Idx].Claimer == None || PointClaims[Idx].Claimer.bDeleteMe || PointClaims[Idx].Claimer.WillGiveUpClaim(Point,Claimer))
		{
			//`log(`showvar(Claimer)@"re-claimed"@`showvar(Point));
			return TRUE;
		}
		return FALSE;
	}
	//`log(`showvar(Claimer)@"claimed"@`showvar(Point));
	Idx = PointClaims.Add(1);
	PointClaims[Idx].Point = Point;
	PointClaims[Idx].Claimer = Claimer;
	return TRUE;
}

function InitializeTeams()
{
	local int Idx;
	// initialize all the teams
	for (Idx = 0; Idx < NumTeams; Idx++)
	{
		Teams[Idx] = Spawn(TeamClass,self);
		Teams[Idx].TeamIndex = Idx;
		GameReplicationInfo.SetTeam(Idx, Teams[Idx]);
	}
}

event PostBeginPlay()
{
	local FlightVolume FV;

	InitializeTeams();
	Super.PostBeginPlay();

	BattleMonitor = Spawn( class'BattleStatusMonitor' );

	// Grab all flight volumes in the level
	foreach AllActors( class'FlightVolume', FV )
	{
		if( FV.Pivots.Length > 0 )
		{
			FlightVolumes[FlightVolumes.Length] = FV;
		}
	}
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local PlayerReplicationInfo PRI;
	PRI = Other.PlayerReplicationInfo;
	if (PRI != None)
	{
		if (PRI.Team != None && N != PRI.Team.TeamIndex)
		{
			PRI.Team.RemoveFromTeam(Other);
		}
		if (PRI.Team == None)
		{
			Teams[N].AddToTeam(Other);
		}
	}
	return true;
}

/* Return a picked team number if none was specified
*/
function byte PickTeam(byte Current, Controller C)
{
	return 0;
}

function byte PickSmallestTeam()
{
	local int Idx, SmallestTeam;
	SmallestTeam = 0;
	for ( Idx = 1; Idx < NumTeams; Idx++ )
	{
		if ( Teams[Idx].Size < Teams[SmallestTeam].Size )
		{
			SmallestTeam = Idx;
		}
	}
	return SmallestTeam;
}

auto State PendingMatch
{
Begin:
	StartMatch();
}


/** This is our overridden StartMatch() function **/
function StartMatch()
{
	if( CheckForSentinelRun() )
	{
		return;
	}

	`log("Starting match...");
	Super.StartMatch();


	// BugIt functionality
	// need to delay here as in MP maps there is a delay in starting the match even with QuickStart on
	SetTimer( 5.0f, FALSE, nameof(CheckForBugItCommand) );
}


/** This will check to see if there is a BugIt command active and then call the BugItGo function **/
function CheckForBugItCommand()
{
	local NanoPC PC;

	foreach WorldInfo.AllControllers(class'NanoPC', PC)
	{
		break;
	}

	if( BugLocString != "" || BugRotString != "" )
	{
		if( PC.CheatManager != none )
		{
			//`log( "BugLocString:" @ BugLocString );
			//`log( "BugRotString:" @ BugRotString );
			PC.BugItGoString( BugLocString, BugRotString );
		}
	}
}

/** Called from AI factories when a spawner had been disabled */
event AIFactoryDisabled( int NumUnspawnedPawns, SeqAct_AIFactory AIFactory );

/** Called from AI factories when a spawn is killed */
event SpawnFromAIFactoryHasDied(Pawn KilledSpawn, SeqAct_AIFactory AIFactory);

/**
  *  Use 'ShowGameDebug' console command to show this debug info
  *  Useful to show general debug info not tied to a particular actor physically in the level.
  */
simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas	Canvas;
	local NanoGRI NGRI;

	Canvas = HUD.Canvas;
	
	NGRI = NanoGRI(WorldInfo.GRI);

	Super.DisplayDebug(HUD, out_YL, out_YPos);

	if( NGRI.AirVehiclePopMgr != None )
	{
		Canvas.SetDrawColor(255,0,0);
		out_YPos += out_YL;
		Canvas.SetPos(4,out_YPos);
		Canvas.DrawText("--- Air Vehicle Population Manager ---");

		NGRI.AirVehiclePopMgr.DisplayDebug(HUD, out_YL, out_YPos);
	}

	if( NGRI.GroundVehiclePopMgr != None )
	{
		Canvas.SetDrawColor(0,255,0);
		out_YPos += out_YL;
		Canvas.SetPos(4,out_YPos);
		Canvas.DrawText("--- Ground Vehicle Population Manager ---");

		NGRI.GroundVehiclePopMgr.DisplayDebug(HUD, out_YL, out_YPos);
	}
}

defaultproperties
{
	MaxPlayersAllowed=10

	PlayerReplicationInfoClass=class'NanoGame.NanoPRI'
	PlayerControllerClass=class'NanoGame.NanoPC'
	DefaultPawnClass=class'NanoGame.NanoPawn_Rebels_Lyrik'
	GameReplicationInfoClass=class'NanoGame.NanoGRI'
	HUDType=class'NanoHUD_Base'
	TeamClass=class'NanoTeamInfo'

	bRestartLevel=FALSE
	bDelayedStart=FALSE

}