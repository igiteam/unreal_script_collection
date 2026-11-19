/**
 * We make a base class so the class we do iterating on is not native.
 * 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProceduralEnemySpawnerBase extends Actor
	implements( Interface_NavigationHandle )
    native(AI);


/** Temp variables for the Interface_NavigationHandle **/

var transient vector NavHandle_CurrEnemySearchExtent;

var transient vector NavHandle_CurrSearchStart;

var transient float NavHandle_MaxDropHeight;



cpptext
{
	// ++ Interface_NavigationHandle implementation 
	virtual UBOOL	CanCoverSlip(ACoverLink* Link, INT SlotIdx);
	virtual FVector GetEdgeZAdjust(FNavMeshEdgeBase* Edge);	
	virtual void SetupPathfindingParams( FNavMeshPathParams& out_ParamCache );
	virtual void InitForPathfinding() {}
}

// Interface_navigationhandle stub - called when path edge is deleted that this controller is using
event NotifyPathChanged();


simulated event vector GetPlayerLocation()
{
	local NanoPC PC;

	//FIXMEMP:  Assumes there is only one player!
	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
		if( PC.Pawn != none )
		{
			return PC.Pawn.Location;
		}
	}

	`warn( "Oh!! no valid player pawn!!" );
	return vect(0,0,0);
}


simulated function rotator GetPlayerRotation()
{
	local NanoPC PC;

	//FIXMEMP:  Assumes there is only one player!
	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
		if( PC.Pawn != none )
		{
			return PC.Pawn.Rotation;
		}
	}

	`warn( "Oh!! no valid player pawn!!" );
	return rot(0,0,0);
}


simulated function Pawn GetPlayerPawn()
{
	local NanoPC PC;

	//FIXMEMP:  Assumes there is only one player!
	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
        return PC.Pawn;
	}

	`warn( "Oh!! no valid player pawn!!" );
	return none;
}


simulated event vector GetPlayerLocationInFront()
{
	local NanoPC PC;

	//FIXMEMP:  Assumes there is only one player!
	foreach LocalPlayerControllers( class'NanoPC', PC )
	{
		if( PC.Pawn != none )
		{
			return GetPlayerLocation()+ ( vector(PC.Pawn.Rotation) * 512.0f );
		}
	}

	`warn( "Oh!! no valid player pawn!!" );
	return vect(0,0,0);
}



final function class<NanoPawnBase> CreateNanoPawnClass( const name InClassName )
{
	local class<NanoPawnBase> PawnClass;

	PawnClass = class<NanoPawnBase>(DynamicLoadObject( "NanoGameContent." $ InClassName, class'Class', TRUE ));
	if( PawnClass == None )
	{
		PawnClass = class<NanoPawnBase>(DynamicLoadObject( "NanoGame." $ InClassName, class'Class' ));	
	}

	//`log( `showvar(PawnClass) );
	return PawnClass;
}

final function class<NanoAI> CreateNanoAIClass( const name InClassName )
{
	local class<NanoAI> AIClass;

	AIClass = class<NanoAI>(DynamicLoadObject( "NanoGameContent." $ InClassName, class'Class', TRUE ));

	if( AIClass == None )
	{
		AIClass = class<NanoAI>(DynamicLoadObject( "NanoGame." $ InClassName, class'Class' ));
	}

	//`log( `showvar(AIClass) );
	return AIClass;
}






defaultproperties
{
}