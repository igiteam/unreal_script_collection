/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoProceduralMissionManager extends Actor
	config(Game);






//// the above vars are all of the data for the things we spawn

/** The procedural spawning gets turned on by a kismet action.  So we are not spawning all the time in every map. **/
var transient bool bActive;

/** Whether to do debug logging or not **/
var config bool bNPMMLogging;



/** When to update so we are not constantly updating which will probably get expensive **/
var config float TimeBetweenProceduralMissionManagerTicks;
var transient float TimeToDoProceduralMissionManager;


/** Number of total missions that can be active at once **/
var config int NumActiveAtOnce;


var transient array<NanoProceduralMissionBase> ActiveMissions;


/**
 * The set of available missions that we can choose from.  
 * 
 * TODO:  MEH this needs to auto find new types instead of us manually adding them
 **/
var array<String> AvailMissions;





function PostBeginPlay()
{
	Super.PostBeginPlay();
}



function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// only do this every N seconds
	if( ( bActive == TRUE )
		&& ( TimeToDoProceduralMissionManager < WorldInfo.TimeSeconds )
		)
	{
		DoDoProceduralMissionManager( DeltaTime );
		TimeToDoProceduralMissionManager = WorldInfo.TimeSeconds + TimeBetweenProceduralMissionManagerTicks;
	}
}


function DoDoProceduralMissionManager( float DeltaTime )
{
	local NanoProceduralMissionBase NPM;

	foreach ActiveMissions( NPM )
	{
		NPM.Tick( DeltaTime );
	}
}


function bool IsMissionTypeActive( class<NanoProceduralMissionBase> MissionType )
{
	local NanoProceduralMissionBase NPM;

	// need to check count of how many can be active at once
	// both total missions and per type
	//

	foreach ActiveMissions( NPM )
	{
		if( NPM.default.class == MissionType )
		{
			return TRUE;
		}
	}

	return FALSE;
}




function AddMissionToBeSpawned( class<NanoProceduralMissionBase> MissionType, NanoProceduralMissionHint InHint )
{
	local NanoProceduralMissionBase NPM;


	if( IsMissionTypeActive( MissionType ) == TRUE )
	{
		`NPMMLog( "Already have a mission of that type active:" @ MissionType );
		return;
	}


	`NPMMLog( "Attempting to add Mission:" @ MissionType );

	NPM = MissionType.static.SpawnMission( self );

	if( NPM != none )
	{
		InHint.bProcMissionActive = TRUE;
		NPM.HintsWeSpawnedFrom.AddItem( InHint );

		NPM.MissionLocation = InHint.Location;

		NPM.StartMission();
	    ActiveMissions.AddItem( NPM );
	}
}


/** 
 *  So we need to be notified when an AI actually spawns and then we update our internal tracking structures.
 **/
function NotifyANewAIHasSpawned( const NanoAIBase InAI )
{
	local NanoProceduralMissionBase NPM;

	foreach ActiveMissions( NPM )
	{
		NPM.NotifyANewAIHasSpawned( InAI );
	}
}


/** 
 *  So we need to be notified when an AI actually dies and then we update our internal tracking structures.
 **/
function NotifyANewAIHasDied( const NanoAIBase InAI, class<DamageType> DamageType )
{
	local NanoProceduralMissionBase NPM;

	foreach ActiveMissions( NPM )
	{
		NPM.NotifyANewAIHasDied( InAI, DamageType );
	}
}



/** This will update the Mission Manager to have the objectives from this procedural mission **/
function AddMissionManagerObjectives( const NanoInterface_Objective Objective )
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).TheMissionManager.AdditionalRadarObjectives.AddItem( Objective );
}

function RemoveMissionManagerObjectives( const NanoInterface_Objective Objective )
{
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).TheMissionManager.AdditionalRadarObjectives.RemoveItem( Objective );
}





defaultproperties
{
	AvailMissions.Add("NPM_AnarchistAttack")
	AvailMissions.Add("NPM_BattalionMarchingSomewhere")
	AvailMissions.Add("NPM_BullRamMarchingSomewhere")
	AvailMissions.Add("NPM_BurningBus")
	AvailMissions.Add("NPM_CarAccident")
	AvailMissions.Add("NPM_CivilianBeingChased")
	AvailMissions.Add("NPM_CopCarFlyingSomewhere")
	AvailMissions.Add("NPM_DeadBodies")
	AvailMissions.Add("NPM_DropShipFlyingOverHead")
	AvailMissions.Add("NPM_FiringSquad")	
	AvailMissions.Add("NPM_IllegalGathering")
	//AvailMissions.Add("NPM_Messenger")
	AvailMissions.Add("NPM_MetaCorpLimo")
	AvailMissions.Add("NPM_MetaCorpShowOfForceParade")
	AvailMissions.Add("NPM_PoliceBrutality")
	AvailMissions.Add("NPM_PoliceLine")
	//AvailMissions.Add("NPM_RabbleRousers")
	AvailMissions.Add("NPM_StreetClosedOff")
	AvailMissions.Add("NPM_SupplyPile")
	AvailMissions.Add("NPM_SuspectBeingArrested")
	AvailMissions.Add("NPM_SuspectBeingHeld")
	AvailMissions.Add("NPM_AssuranceGame")	

}
