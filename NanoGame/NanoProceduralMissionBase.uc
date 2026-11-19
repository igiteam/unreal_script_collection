/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoProceduralMissionBase extends Actor
	abstract
	config(Game);


/** Whether to do debug logging or not **/
var config bool bNPMMLogging;

/** Number of this type of mission that can be active at once **/
var config int NumActiveAtOnce;


/** Number of seconds this Mission will last before it cleans itself up. **/
var config float NumSecondsBeforeSelfCleanup;


/** This is the reward type that this Mission will give out **/
var class<NanoProceduralMissionRewardBase> RewardType;


var transient vector MissionLocation;


var array<class<NanoProceduralMissionPartBase> > MissionParts_Rebels;

var array<class<NanoProceduralMissionPartBase> > MissionParts_MetaCorp;

var array<class<NanoProceduralMissionPartBase> > MissionParts_Neutrals;


var transient array<NanoProceduralMissionPartBase> Spawned_MissionParts;


var transient array<NanoAI> Spawned_Rebels;

var transient array<NanoAI> Spawned_MetaCorp;

var transient array<NanoAI> Spawned_Neutrals;


/** The texture for this mission.  We are going to use for placeholder mesh and probably can use this for on the map and such **/
var Texture2D ProcMissionTexture;


/** We need to keep track of the hint we spawned from.  As they get tagged with being ProcMission used so we don't keep using them **/
var transient array<NanoProceduralMissionHint> HintsWeSpawnedFrom;


var SoundCue ProcMissionStartSound;

static function NanoProceduralMissionBase SpawnMission( NanoProceduralMissionManager NPMM )
{
	local NanoProceduralMissionBase Retval;
	//local bool bFoundStartingPoint;

	Retval = NPMM.Spawn( default.class, NPMM );

	NanoGRI(NPMM.WorldInfo.GRI).GetNanoPC().PlaySound( default.ProcMissionStartSound );
	

	Retval.SetTimer( default.NumSecondsBeforeSelfCleanup, FALSE, nameof(CleanUpMission), Retval );

// 	bFoundStartingPoint = Retval.FindMissionLocation( default.class );
// 
// 	if( bFoundStartingPoint == FALSE )
// 	{
// 		Retval = none;
// 	}

	return Retval;
}


function bool FindMissionLocation( class<NanoProceduralMissionBase> MissionClass )
{
	local WorldInfo WI;
	local NanoGRI NGRI;
	local NanoProceduralMissionHint NMH;
	local class<NanoProceduralMissionBase> NPMB;
	local Vector PossibleSpawnLoc;

	`NPMMLog( " FindStartingPoint" @ self );

	WI = class'WorldInfo'.static.GetWorldInfo();
	NGRI = NanoGRI(WI.GRI);

	// lets find a starting spot that works for us
	foreach WI.AllActors( class'NanoProceduralMissionHint', NMH )
	{
		foreach NMH.WhichMissionsCanSpawnNearHere( NPMB )
		{
			if( NPMB == MissionClass )
			{
				PossibleSpawnLoc = NMH.Location;

				// so now we need to check that the player can see us
				if( NGRI.CanPlayerSeeThisLocation( PossibleSpawnLoc ) == TRUE )
				{
					`NPMMLog( " FindStartingPoint SUCCESS" @ PossibleSpawnLoc );
					MissionLocation = PossibleSpawnLoc;
					return TRUE;
				}
			}
		}
	}

	`NPMMLog( " FindStartingPoint FAILED Perhaps no valid NanoProceduralMissionHint?" );
	return FALSE;
}


function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
}




function StartMission();


/** Looks at all of the InteractableComponent and checks to see if anyone is interacting! **/
private function bool AnyPartsBeingInteractedWith()
{
	local bool Retval;
	local NanoProceduralMissionPartBase SpawnedPart;
	local InteractableComponent InteractComp;

	// look at all of the mission parts
	foreach Spawned_MissionParts( SpawnedPart )
	{
		// then look at all of the mission part's Components
		foreach SpawnedPart.AllOwnedComponents( class'InteractableComponent', InteractComp )
		{
			//`log( "looking at" @ `showvar(InteractComp) @ `showvar(InteractComp.BeingAbsorbedBy) );
			// check to see if it is being "interacted with"
			if( InteractComp.BeingAbsorbedBy != None )
			{
				Retval = TRUE;
				break;
			}
		}
	}

	return Retval;
}



function CleanUpMission()
{
	local NanoProceduralMissionHint Hint;
	local NanoProceduralMissionPartBase SpawnedPart;
	local NanoAI AI;
	

	// check to see if the proc mission is currently being interacted with
	// if it is then don't clean it up
	if( AnyPartsBeingInteractedWith() == TRUE )
	{
		// so if it was being interacted with then let's not kill it now
		// but instead try again in a second
		SetTimer( 1.0f, FALSE, nameof(CleanUpMission) );
		return;
	}

	// if it is not then do clean it up

	`NPMMLog( self @ GetFuncName() );

	foreach HintsWeSpawnedFrom( Hint )
	{
		Hint.bProcMissionActive = FALSE;
	}

	foreach Spawned_MissionParts( SpawnedPart )
	{
		SpawnedPart.Destroy();
	}

	foreach Spawned_Rebels( AI )
	{
		AI.Pawn.Destroy();
		AI.Destroy();
	}

	foreach Spawned_MetaCorp( AI )
	{
		AI.Pawn.Destroy();
		AI.Destroy();
	}

	foreach Spawned_Neutrals( AI )
	{
		AI.Pawn.Destroy();
		AI.Destroy();
	}

	NanoGRI(WorldInfo.GRI).NED.bProcMissionActive = FALSE;
	NanoGRI(WorldInfo.GRI).NED.LastProcMissionTime = WorldInfo.TimeSeconds;

	Destroy();
}



/** 
 *  So we need to be notified when an AI actually spawns and then we update our internal tracking structures.
 **/
function NotifyANewAIHasSpawned( const NanoAIBase InAI )
{

}


/** 
 *  So we need to be notified when an AI actually dies and then we update our internal tracking structures.
 **/
function NotifyANewAIHasDied( const NanoAIBase InAI, class<DamageType> DamageType )
{

}




function StartUpMissionParts( array< class<NanoProceduralMissionPartBase> > InParts )
{
	local class<NanoProceduralMissionPartBase> MissionPart;
	local NanoProceduralMissionPartBase Part;

	foreach InParts( MissionPart )
	{
		Part = MissionPart.static.SpawnMissionPart( self, MissionLocation );
		Spawned_MissionParts.AddItem( Part );
	}
}


defaultproperties
{
	RewardType=class'NPMR_Small'

	ProcMissionStartSound=SoundCue'Interface_Audio.Objectives.PointOfInterestAdded'
}




// so we want to do something like this:
//
// each mission consists of each of the following groups doing something
//  -Rebels 
//  -MetaCorp 
//  -Neutrals (journalists?)
//
// Doing it this way allows us to do things like:
// RabbleRouser
//    -Rebels Protesting
//    -3 Cops Response
//
//    -Rebels Protesting
//    -BULLRAMS Response
//
//    -Rebels Protesting x2!!!! 
//    -BULLRAMS Response

// so we can have even better composition of indiv cool behaviors
// also lots of these have time / spawning issues to contend with.  So we need to be able to break them
// apart and then monitor each on their own
// also we can cause the indiv parts to disperse (e.g. journalists)





// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_AnarchistAttack'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_BurningBus'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_DeadBodies'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_FiringSquad'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_IllegalGathering'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_PoliceBrutality'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_PoliceLine'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_StreetClosedOff'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_SupplyPile'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_SuspectBeingArrested'
// Texture2D'LD_DC_Events_Placeholder.Event_Placeholder_SuspectBeingHeld'


// SkeletalMesh'NPC_CivilianProto.SK_NPC_Civilian_Proto'  could be a photographers

// StaticMesh'LD_DC_Events_Placeholder.Event_Placeholder_Mesh'

