//=============================================================================
// SASGameInfo.uc
//=============================================================================

class SASGameInfo extends GameInfo
	dependson(SASDifficulty)
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.


//-----------------------------------------------------------------------------
// Constants

const MAX_ACTIVE_TERRORISTS	= 6;

enum statOp
{
	statOp_set, 
	statOp_add, 
	statOp_sub, 
	statOp_mult, 
	statOp_div, 
	statOp_concat, 
	statOp_avg
};

enum statLevel
{
	statLvl_server, 
	statLvl_team, 
	statLvl_player
};

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var SASScriptMgr				mScriptManager;			// Levels script manager object
//var SASObjectiveMgr				mObjectiveManager;		// Levels objective manager object
var SASBoobyTrapMgr				mBoobyTrapManager;		// manages booby traps for this level
var SASTerroristMgr				mTerroristManager;		// Terrorist attack arbitration mamanger object.
var const SASPawn				mLevelPawns;			// Head of linked list of SASPawns in the level
var const SASAssaultVolume		mAssaultVolumeList;		// Head of linked list of assault volumes in the level
var const SASEntryPoint			mEntryPointList;		// Head of linked list of entry points in the level
var const SASSecondaryObjective	mSecondaryObjectiveList;	// Head of linked list of secondary object objects in the level.
var float						mLastHostageDontLeaveMeTime;	// GPTEMP: last time a hostage played this speech - move to a hostage manager class.  

// JS transient means "don't stick in savegame because it's allocated on the fly"
var transient SASVoiceManager			mVoiceMgr;
var transient SASPawnVoice				mPawnVoiceList;

var SASSquadManager				mSquadManager;			// points to squad manager
var() String					mSquadManagerClassName;	// name of squad manager class
var() class<SASSquadManager>	mSquadManagerClass;		// class for squad manager, generated from name or can be pre-set

var localized string			mDefaultHostageName;
var localized string			mDefaultTerroristName;

//var UdpBeacon					mBeacon;
//var UdpGameSpyUplink			mGameSpyUplink;
//var UdpGameSpyQuery			mGameSpyQuery;
//var SASGameSpyDriver			mGameSpyDriver;

replication
{
	// no point replicating anything here as this object only exists
	// on the server!
}
//-----------------------------------------------------------------------------
// Native Functions

native final function SetupDifficulty();
native final function StorePasswordResults();
native final function ConnectionFailureToProfile();
// Gamespy stuff

native static function StatStringOp( string Item, StatOp Op, string Data, StatLevel Level, int Index );
native static function StatIntOp( string Item, StatOp Op, int Data, StatLevel Level, int Index );
native static function StatFloatOp( string Item, StatOp Op, float Data, StatLevel Level, int Index );
native static function NewGame();
native static function NewTeam( string TeamName, int Id );
native static function NewPlayer ( string PlayerName, int Id );
native static function StatSnapshot();
native static function StatEndGame();


///////////////////////////////////////////////////////////////////////////////
// AddAssaultVolume
// 
// Add an assault volume to our linked list.
// SASAssaultVolumes call this from their PreBeginPlay function.
native final function AddAssaultVolume (
	SASAssaultVolume	aNewVolume);


///////////////////////////////////////////////////////////////////////////////
// RemoveAssaultVolume
//
// Remove an assault volume from our linked list.
native final function RemoveAssaultVolume (
	SASAssaultVolume	aVolToRemove);


///////////////////////////////////////////////////////////////////////////////
// GetEncompassingAssaultVolume
//
// Get the assault volume encompassing a point. 
native final function SASAssaultVolume GetEncompassingAssaultVolume (
	vector	aPoint);


///////////////////////////////////////////////////////////////////////////////
// AllSASPawns
// 
// Iterate through all SASPawns in the level. 
// To restrict the iteration to objects of subclasses of SASPawn, set the 
// aBaseClass param to the subclass classtype.
native static iterator function AllSASPawns (
	class<SASPawn>		aBaseClass,
	out SASPawn			aPawnOut,
	optional name		aMatchTag);


///////////////////////////////////////////////////////////////////////////////
// RadiusSASPawns
// 
// Iterate through all SASPawns in the level within aRadius distance of 
// aFromLocation. 
// To restrict the iteration to objects of subclasses of SASPawn, set the 
// aBaseClass param to the subclass class type.
native static iterator function RadiusSASPawns (
	class<SASPawn>		aBaseClass,
	out SASPawn			aPawnOut,
	vector				aFromLocation,
	float				aRadius,
	optional name		aMatchTag);


///////////////////////////////////////////////////////////////////////////////
// LineOfSightSASPawns
// 
// Iterate through all SASPawns in the level with which there is a line of 
// sight from the aFromActor location and within aMaxRange distance.
// To restrict the iteration to objects of subclasses of SASPawn, set the 
// aBaseClass param to the subclass class type.
native static iterator function LineOfSightSASPawns (
	class<SASPawn>		aBaseClass,
	out SASPawn			aPawnOut,
	Actor				aFromActor,
	float				aMaxRange,
	optional name		aMatchTag);


///////////////////////////////////////////////////////////////////////////////
// AssaultVolumeSASPawns
// 
// Iterate through all SASPawns in assault volume 'aMatchAssaultVolume'.
// To restrict the iteration to objects of subclasses of SASPawn, set the 
// aBaseClass param to the subclass class type.
native static iterator function AssaultVolumeSASPawns (
	class<SASPawn>		aBaseClass,
	out SASPawn			aPawnOut,
	SASAssaultVolume	aMatchAssaultVolume);


CleanNative function InitStatLogging(); //single player

native final function int GetBeaconInfo( out string ServerName, out string LevelName, out int MaxPlayers, out int RequiresPassword );

//-----------------------------------------------------------------------------
// Functions
//

//-----------------------------------------------------------------------------
// InitGame
//
// Initialize the game.
// The GameInfo's InitGame() function is called before any other scripts (including 
// PreBeginPlay() ), and is used by the GameInfo to initialize parameters and spawn 
// its helper classes.
// Warning: this is called before actors' PreBeginPlay.
event InitGame ( String sOptions, out String aError )
{
	local string	InOpt;

	Super.InitGame ( sOptions, aError );

	StorePasswordResults();

	// Detect if this is a new map change as a result of a client connection failure.
	InOpt = ParseOption( sOptions, "Failure" );
    if ( InOpt == "Connection" )
	{
    	ConnectionFailureToProfile();
	}

	InitSquadManager ();
}

///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
// 
event PreBeginPlay ()
{
	Super.PreBeginPlay();

	SetupDifficulty();
	InitBoobyTrapManager ();
	InitObjectiveManager ();
	InitScriptManager ();
	InitTerroristSupport ();
}


//------------------------------------------------------------------------------
//
//
function InitObjectiveManager ()
{
	local SASGRI	gri;

	gri = SASGRI ( GameReplicationInfo );

	// Find objective manager (one should be placed in the level
	foreach AllActors ( class'SASObjectiveMgr', gri.mObjectiveManager )
	{
		break;
	}

	if ( gri.mObjectiveManager == None )
	{
		Warn ( self $".InitObjectiveManager: No objective manager exists in level." ); 
	}
}

//------------------------------------------------------------------------------
//
//
function InitBoobyTrapManager ()
{
	local SASGRI	gri;

	gri = SASGRI ( GameReplicationInfo );

	// Spawn booby trap manager
	gri.mBoobyTrapManager = Spawn ( class'SASBoobyTrapMgr' );

	if ( gri.mBoobyTrapManager == None )
	{
		Warn ( "SASGameInfo: Failed to spawn booby trap manager object." );
	}
	else
	{
		mBoobyTrapManager = gri.mBoobyTrapManager;
	}
}

//------------------------------------------------------------------------------
//
//
function InitScriptManager ()
{
	// Spawn script manager
	mScriptManager = Spawn ( class'SASScriptMgr' );

	if ( mScriptManager == None )
	{
		Warn ( "SASGameInfo: Failed to spawn script manager object." );
	}
}

//------------------------------------------------------------------------------
//
//
//------------------------------------------------------------------------------
// SPInitSquad
//
// init squad in sigle player, called on PostLogin
function SPInitSquad ()
{
	InitSquad ();
}

//------------------------------------------------------------------------------
// InitSquad
//
// generic squad init
function InitSquad ()
{
	mSquadManager.InitSquad ();
}

//------------------------------------------------------------------------------
// InitSquadManager
//
// spawn the squad manager on the server, to be replicated to clients
function InitSquadManager ()
{
	if ( mSquadManagerClass == None )
	{
		mSquadManagerClass = class<SASSquadManager> ( DynamicLoadObject ( mSquadManagerClassName, class'Class' ) );
	}

	If ( Level.NetMode != NM_Client )
	{
		mSquadManager = Spawn ( mSquadManagerClass );

		if ( mSquadManager == None )
		{
			warn ( self $".InitSquadManager: Failed to spawn squad manager object." );
		}
//		else
//		{
////			SASGRI ( GameReplicationInfo ).mSquadManager = mSquadManager;
//			Log ( self $".InitSquadManager: " @mSquadManager );
//		}
	}
}


function SASVoiceManager GetVoiceManager()
{
	if ( mVoiceMgr == None )
	{
		mVoiceMgr = Spawn( class'SASVoiceManager' );
	}

	return mVoiceMgr;
}


function SASPawnVoice GetPawnVoice(
	class<SASPawnVoice>	aVoiceClass )
{
	local SASPawnVoice	voice;

	if ( aVoiceClass == None )
	{
		return None;
	}

	// Search in already created voice objects for one with matching class.
	voice = mPawnVoiceList;
	while ( voice != None )
	{
		if ( voice.Class == aVoiceClass )
		{
			return voice;
		}

		voice = voice.mNextVoiceInList;
	}

	// Voice has yet to be created - do it now.
	voice = Spawn( aVoiceClass );
	if ( voice != None )
	{
		// Add to head of voice list.
		voice.mNextVoiceInList = mPawnVoiceList;
		mPawnVoiceList = voice;
	}
	else
	{
		Warn( "GetPawnVoice(): Failed to create pawn voice object of class "$aVoiceClass );
	}

	return voice;
}


//------------------------------------------------------------------------------
// GetTerroristManager
//
// Get ptr to the level's terrorist mamager. Spawn it if one doesn't yet exist.
function SASTerroristMgr GetTerroristManager()
{
	if ( mTerroristManager == None )
	{
		mTerroristManager = Spawn( class'SASTerroristMgr' );
	}

	return mTerroristManager;
}


//------------------------------------------------------------------------------
//
//
function InitTerroristSupport ()
{
	local class<SASTerroristGlobalAI>	globTerrAIClass;

	// TEMP HACK
	// Init terrorist AI editable global params.
	globTerrAIClass = Class<SASTerroristGlobalAI>( DynamicLoadObject( "SASChars.SASTerroristGlobalAIEdit", class'Class' ) );
	if ( globTerrAIClass != None )
	{
		class'SASTerroristController'.Static.InitGlobalCoverParams( globTerrAIClass );
	}
}

//------------------------------------------------------------------------------
// PostLogin
//
// for single player game set up squad after player logs in
event PostLogin ( PlayerController aPlayer )
{
	Super.PostLogin ( aPlayer );

	if ( aPlayer == Level.GetLocalPlayerController () )
	{
		SPInitSquad ();
	}
}

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
event PostBeginPlay()
{
	local NavigationPoint	navPt;
	//local SASSpawnPoint		sp;
	//local SASSpawnPoint		playersp;
	//local float				dist;
	//local float				prevdist;
	//local SASPawn			player;

	Super.PostBeginPlay();

	// Check if all nav points are in an assault volume - if not, need to turn off hierarchical
	// pathfinding.
	for ( navPt = Level.NavigationPointList; navPt != None; navPt = navPt.NextNavigationPoint)
	{
		if ( navPt.AssaultVolPtr == None )
		{
			Warn( "*** Navigation point "$navPt.Name$" is not in an assault volume. ***" );
			Level.mbUseHierarchicalPathfinding = false;
		}
	}

	//playersp = None;
	//dist = 100000.0;
	//player = SASPawn ( GetSASPlayerController ().Pawn );
	//foreach AllActors ( class'SASSpawnPoint', sp )
	//{
	//	dist = VSize ( sp.Location - player.Location );
	//	if ( dist < prevdist )
	//	{
	//		dist = prevdist;
	//		playersp = sp;
	//	}
	//}
	//if ( playersp != None )
	//{
	//	GetSASPlayerController ().SetRotation ( playersp.Rotation );
	//}
}


//------------------------------------------------------------------------------
//
//
function bool IsPointBlockedByAPawn( 
	Vector	aTestPoint,
	SASPawn	aCheckingPawn )
{
	local SASPawn	testPawn;

	for ( testPawn = mLevelPawns; testPawn != None; testPawn = testPawn.mNextPawn )
	{
		if ( testPawn == aCheckingPawn )
		{
			continue;
		}

		if ( VSizeHorizSq( aTestPoint - testPawn.Location ) > Square( testPawn.CollisionRadius + aCheckingPawn.CollisionRadius ) )
		{
			continue;
		}
	
		if ( Abs( testPawn.Location.Z - aTestPoint.Z ) < testPawn.CollisionHeight + aCheckingPawn.CollisionHeight )
		{
			return true;
		}
	}

	return false;
}


//------------------------------------------------------------------------------
//
//
function AddDefaultInventory( 
	Pawn PlayerPawn )
{
	if ( SASPawn(PlayerPawn) != None )
	{
		SASPawn(PlayerPawn).AddDefaultInventory();
	}
	SetPlayerDefaults(PlayerPawn);
}

//------------------------------------------------------------------------------
// 
//
function SetPlayerDefaults ( Pawn PlayerPawn )
{
	Super.SetPlayerDefaults ( PlayerPawn );

	// select first primary weapon available to me
	SASPawn ( PlayerPawn ).SelectPrimaryWeapon ();
}


///////////////////////////////////////////////////////////////////////////////
// EventTriggered
// 
// Called when a general level event is triggered. Pass the event onto the 
// script/objective managers.
function EventTriggered (
	name	aEventName)
{
	local SASSecondaryObjective	SO;

	if ( mScriptManager != None )
	{
		mScriptManager.EventTriggered ( aEventName );
	}
	if ( mBoobyTrapManager != None )
	{
		mBoobyTrapManager.EventTriggered ( aEventName );
	}

	// Secondary objectives need triggering here as the TriggerEvent fn only triggers dynamic actors.
	for ( SO = mSecondaryObjectiveList; SO != None; SO = SO.mNextSecondaryObjective )
	{
		if ( SO.Tag != '' && SO.Tag == aEventName )
		{
			SO.Trigger( None, None );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// EventUntriggered
// 
// Called when a general level event is untriggered. Pass the event onto the 
// script/objective managers.
function EventUntriggered (
	name	aEventName)
{
	if ( mScriptManager != None )
	{
		mScriptManager.EventUntriggered ( aEventName );
	}
}


///////////////////////////////////////////////////////////////////////////////
// PawnSpawned
// 
// Called by a pawn when it is spawned in the level.
// Notify scripts of event.
event PawnSpawned (
	SASPawn	aSpawned)
{
	if (mScriptManager != None)
	{
		mScriptManager.PawnSpawned (aSpawned);
	}
}


///////////////////////////////////////////////////////////////////////////////
// PawnDamaged
// 
// Called by an SASPawn when it gets damaged. Only called by pawn's which
// have a 'damaged' script condition relating to them.
function PawnDamaged (
	SASPawn	aDamaged)
{
	if (mScriptManager != None)
	{
		mScriptManager.PawnDamaged (aDamaged);
	}
}

//------------------------------------------------------------------------------
//
//
function PawnKilled ( SASPawn aKilled, SASPawn aKiller )
{
	// Inform scripts of kill event
	if ( mScriptManager != None )
	{
		mScriptManager.PawnKilled ( aKilled , aKiller );
	}
}

//------------------------------------------------------------------------------
//
//
function PawnCaptured ( SASPawn aCaptured )
{
	if ( mScriptManager != None )
	{
		mScriptManager.PawnCaptured ( aCaptured );
	}
}

//------------------------------------------------------------------------------
//
//
function PawnEvacuated ( SASPawn aEvacuated )
{
	// Inform scripts of evacuation event
	if ( mScriptManager != None )
	{
		mScriptManager.PawnEvacuated ( aEvacuated );
	}
}

//------------------------------------------------------------------------------
//
//
function VolumeCleared ( SASAssaultVolume aCleared )
{
	// Inform scripts of cleared volume event
	if ( mScriptManager != None )
	{
		mScriptManager.VolumeCleared ( aCleared );
	}
}

///////////////////////////////////////////////////////////////////////////////
// Killed
// 
// Called by a pawn when it dies.
// Notify controllers, scripts and objectives of event.
// Update kill stats.
function Killed ( 
	Controller			aKiller, 
	Controller			aKilled, 
	Pawn				aKilledPawn, 
	class<DamageType>	aDamageType)
{
	local SASSoldier	soldier;
	//local SASPRI		killerPRI;		// Doesn't seem to be used - AF

	Super.Killed ( aKiller, aKilled, aKilledPawn, aDamageType );

	if ( aKilledPawn == None )
	{
		return;
	}

	//killerPRI = SASPRI ( PlayerController ( aKiller ).PlayerReplicationInfo );

	switch ( aKilledPawn.mPawnType )
	{
		case PAWN_Soldier:
			// TODO: Need to ensure we're working with the right player here....  And that this all works in multiplayer

			// Temp Remove "Would Everyone stop getting fucking shot" as it occurs when booby trap goes off
			// All of this should be rethought with new samples.
			// At the very least nothing should be said if all SAS team members are dead
			// and better would be if a single living SAS guy (who saw the death) was told to say 
			// his own version of the phrase.
			// Ok What I will do is....
			// Choose a random trooper (including the player & get them to shout mandown)
			soldier = mSquadManager.SquadCanSeePawn (aKilledPawn);
			if (soldier != None && soldier != aKilledPawn)
			{
				soldier.PlaySpeech( SPEECH_SquadManDown );
			} // if
			break;

		case PAWN_Terrorist:
			if ( SASPawn (aKilledPawn) == None || !SASPawn (aKilledPawn).mbIsIncapacitated )
			{
				// Assuming I saw him go down, send message to all team members.
				if ( aKiller != None && aKiller.Pawn.mPawnType == PAWN_Soldier)
				{
					soldier = SASSoldier ( aKiller.Pawn );
					if (soldier != None && soldier.PawnIsVisible (aKilledPawn))
					{
						soldier.PlaySpeech ( SPEECH_SquadTerroristDown );
					}
				}
			}
			break;

		case PAWN_Hostage:
			// If player killed hostage, someone from the squad should shout at him
			if (aKiller != None && aKiller.mType == CONTROLLER_Player)
			{
				soldier = mSquadManager.SquadCanSeePawn (aKilledPawn);
				if (soldier != None)
				{
					soldier.PlaySpeech (SPEECH_SquadShootHostage);
				} // if
			} // if

			// If soldier killed hostage, player shouts at him if he can see, otherwise any
			// other soldier should shout at him. If no-one else shouts, soldier who killed
			// just shouts hostage down
			else if (aKiller != None && aKiller.mType == CONTROLLER_AISoldier)
			{
				soldier = mSquadManager.GetClosestPlayerToOther (aKiller.Pawn);
				if (soldier != None && soldier.PawnIsVisible (aKilledPawn))
				{
					soldier.PlaySpeech (SPEECH_SquadShootHostage);
				} // if
				else
				{
					soldier = mSquadManager.SquadCanSeePawn (aKilledPawn);
					if (soldier == SASSoldier (aKiller.Pawn))
					{
						soldier.PlaySpeech (SPEECH_SquadHostageKilled);
					} // if
					else if (soldier != None)
					{
						soldier.PlaySpeech (SPEECH_SquadShootHostage);
					} 
				} // else
			} // else if

			// Any other killer, squad just shouts hostage down
			else
			{
				soldier = mSquadManager.SquadCanSeePawn (aKilledPawn);
				if (soldier != None)
				{
					soldier.PlaySpeech (SPEECH_SquadHostageKilled);
				} 
			} // else
			break;
	}
}

//------------------------------------------------------------------------------
// EndMission
//
// end the mission, whether completed or not ...
exec function EndMission ()
{
	local SASGRI		gri;
	local int i;
	local Controller	C;
	local SASPlayerController sasPlayer;

	LOG("EndMission");

	// kill off any demo recording
	Level.GetLocalPlayerController().StopDemo();
	
	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );
	gri.mObjectiveManager.EndMission ();
	gri.EndMission();

	SendAIsToSleep ();

	// Now end the mission for every player in the game
	for ( C = Level.ControllerList; C != None; C = C.nextController )
	{
		if ( C.mType == CONTROLLER_Player )
		{
			sasPlayer = SASPlayerController( C );

			sasPlayer.ClientEndMission();

			// add fade
			// TODO: Put this in ClientEndMission().
			sasPlayer.ClientStartMissionEndEffect();
		}
	}
	
	// Let's stop all timers apart from the main one
	for (i = 1; i < 10; i++)
	{
		Level.Game.GameReplicationInfo.StartLevelTimer ( i, false );
	}
}

function MissionFailed()
{
	local SASGRI			gri;
	
	gri = SASGRI( GameReplicationInfo );
	if ( gri != None )
	{
		gri.mbMissionFailed	= true;
	}

	EndMission();
}

cleannative function String GetNextMap();

function MissionEndSequenceDone()
{
	// Pause if not already
	if ( Level.Pauser == None )
	{
		Level.GetLocalPlayerController().SetPause ( true );
	}
	Level.GetLocalPlayerController().StopForceFeedback ();  // jdf - no way to pause feedback
}

event GoToNextLevel()
{
	// in single player we return to the frontend.
	ConsoleCommand ( "start frontend" );
}

function PlayerDied(PlayerController which)
{
	// in single player, if you die, the mission's over.
	if( Level.Title != "Frontend" )
	{
		MissionFailed();
	}
}

//------------------------------------------------------------------------------
// SendAIsToSleep
//
// stop everybody from doing anything
function SendAIsToSleep ()
{
	local AIController	aic;

	// no other participants please
	foreach AllActors ( class'AIController', aic )
	{
		aic.GotoState ( 'PermanentSleep' );
	}
}


function MenuEndLevel ()
{
	local SASPlayerController sasPlayer;

	EndMission ();

	ForEach DynamicActors ( class'SASPlayerController', sasPlayer )
	{
		sasPlayer.ClientEndLevel ();
	}
}

//::function MenuRestart ()
//::{
//::	local SASPlayerController sasPlayer;
//::
//::	ForEach DynamicActors ( class'SASPlayerController', sasPlayer )
//::	{
//::		sasPlayer.DoRestart ();
//::	}
//::}

//------------------------------------------------------------------------------
//
//
// Broadcast text message to all SASPlayerController HUDs
event BroadcastShowMessage(
	String aMessage,
	Name aPawnClass,
	optional float aFlashTime)
{
	//local Controller			c;
	//local SASPlayerController	pc;
	local SASGRI				gri;

	gri = SASGRI ( GameReplicationInfo );
	if ( gri != None )
	{
		gri.AddMessageToRadioLog ( aMessage );
	}
/*
	for ( c = Level.ControllerList; c != None; c = c.NextController )
	{
		pc = SASPlayerController ( c );
		if ( ( pc != None ) && ( c.Pawn != None ) )
		{
			if ( c.Pawn.IsA ( aPawnClass ) )
			{
				SASHUD ( pc.myHUD ).ShowMessage ( aMessage, aFlashTime );
			}
		}
	}
*/
}

//-----------------------------------------------------------------------------
// Default Properties



// Decompiled with UE Explorer.
defaultproperties
{
    mSquadManagerClassName="SASGame.SASSquadManager"
    mDefaultHostageName="Hostage"
    mDefaultTerroristName="Terrorist"
    bDelayedStart=false
    HUDType="SASGame.SASHUD"
    PlayerControllerClassName="SASGame.SASPlayerController"
    GameReplicationInfoClass=Class'SASGRI'
}