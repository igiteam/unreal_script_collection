/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_Idle_MoveToUnseenLocationAndDespawn extends NanoAIAction_IdleBase within NanoAI;


var transient vector DespawnLocation;



static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	local ChaosPacifismManager CM;
	local int ChaosLevel;

	CM = NanoGRI(InAI.WorldInfo.GRI).GetCurrentChaosManager();
	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}

	if( ChaosLevel == 0 )
	{
		Retval = default.UtilityStartVal + 460;
	}

	return Retval;  
}


function Pushed()
{
	Super.Pushed();

	NanoPawn(Pawn).HolsterCurrentWeapon();
}


state Idle
{

	event BeginState( name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		DespawnLocation = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NPES.FindLocation_OutOfSightToDespawn( NanoPawn(Pawn) );
	}


Begin:
	`AILog( GetStateName()@"Begin TAG" @ DespawnLocation );

	MoveToLocation( DespawnLocation, 2.f, TRUE );

	`AILog( VSize( DespawnLocation - Pawn.Location ) @ `showvar(DespawnLocation) );

	if( VSize( DespawnLocation - Pawn.Location ) < 256.0f )
	{
		Pawn.Died( None, class'NDT_KilledByProceduralSpawner', Pawn.Location );
	}


	if( VSize(DespawnLocation) == 0 )
	{
		DespawnLocation = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NPES.FindLocation_OutOfSightToDespawn( NanoPawn(Pawn) );
	}



	Sleep(1.f);
	Goto('Begin');
}



defaultproperties
{
	StartingStateName="Idle"
}