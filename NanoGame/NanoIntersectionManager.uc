/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * Used to manage car and pedestrian crowd traffic at intersections
 */
class NanoIntersectionManager extends Actor
	native(Vehicle)
	placeable;

/** Struct containing pairs of GameCrowdDestinations to be linked and unlinked by the intersection manager */
struct native NanoCrowdDestinationPair
{
	var()   NanoCrosswalkDestination    FirstDestination;
	var()   NanoCrosswalkDestination    SecondDestination;
};

struct native NanoIntersectionState
{
	/** Traffic lights to be activated this state */
	var()   array<NanoVehicleSpline>        ActiveTrafficLights;
	/** List of splines that must be clear of traffic for the intersection to change state */
	var()   array<NanoVehicleSpline>        ActiveSplines;
	/** Destination pairs to be linked this state */
	var()   array<NanoCrowdDestinationPair> ActiveDestinationPairs;
	/** Minimum duration to keep the traffic light in this state */
	var()   float                           StateDuration;
	/** Duration to keep crosswalks active.  Should be smaller than StateDuration */
	var()   float                           CrosswalkActiveDuration;

	structdefaultproperties
	{
		StateDuration=10.f
		CrosswalkActiveDuration=5.f
	}
};

/** The potential states of the intersection.  The NanoIntersectionState pointed to by ActiveState will be activated, and all others will be deactivated */
var()   array<NanoIntersectionState>    IntersectionStates;

/** The NanoInterfaceState that's currently active on this intersection.  This corresponds as an index into the IntersectionStates array */
var   int                               ActiveState;

/** How many agents are currently crossing the intersection.  Traffic changes will wait until this hits zero, so we don't have any unprovoked vehicular homicide */
var transient int                       CrossingAgentCount;

/** Flag set to true when the intersection wants to change state, but is waiting for intersection to be clear of traffic */
var transient bool                      bWantsToChangeState;

/** Set to true if we've shut off traffic to allow the intersection to clear */
var transient bool                      bTrafficShutoff;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
};

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	AdvanceState();
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( bWantsToChangeState && SafeToChangeState() )
	{
		AdvanceState();
	}
}

/***************************************************************************
*   Intersection State Management
***************************************************************************/

simulated function AdvanceState()
{
	local int NewState;

	// If there are still agents crossing the intersection, wait until they're done before changing the state!
	if( !SafeToChangeState() )
	{
		bWantsToChangeState = TRUE;
		return;
	}

	NewState = ActiveState + 1;

	if( NewState >= IntersectionStates.Length )
	{
		NewState = 0;
	}

	if( NewState < IntersectionStates.Length )
	{
		SetIntersectionState(NewState);
	}

	bWantsToChangeState = FALSE;
}

simulated function SetIntersectionState(int NewState)
{
	local int i;

	if( NewState != ActiveState )
	{
		if( bDebug )
		{
			FlushPersistentDebugLines();
		}

		for( i = 0; i < IntersectionStates.Length; i++ )
		{
			// Skip the active state, since we'll set that up below, in case there is any overlap between active / inactive nodes
			if( i == NewState )
			{
				continue;
			}

			SetIntersectionState_Helper(i, FALSE);
		}

		SetIntersectionState_Helper(NewState, TRUE);
		ActiveState = NewState;
		bTrafficShutoff = FALSE;

		SetTimer(IntersectionStates[NewState].StateDuration, FALSE, nameof(AdvanceState));
		SetTimer(IntersectionStates[NewState].CrosswalkActiveDuration, FALSE, nameof(CloseCrosswalks));
	}
}

simulated function SetIntersectionState_Helper( int StateIdx, bool bNewActive )
{
	local NanoIntersectionState NIS;
	local int i;
	local NanoCrosswalkDestination NCD1, NCD2;

	NIS = IntersectionStates[StateIdx];

	// --- Handle traffic lights ---
	for( i = 0; i < NIS.ActiveTrafficLights.Length; i++ )
	{
		if( NIS.ActiveTrafficLights[i] != None )
		{
			NIS.ActiveTrafficLights[i].SetTrafficLightState(bNewActive ? ETLS_Green : ETLS_Red);

			if( bDebug )
			{
				DrawDebugLine(Location, NIS.ActiveTrafficLights[i].Location, ((bNewActive==FALSE)?255:0), ((bNewActive==TRUE)?255:0), 0, TRUE);
			}
		}
	}

	// --- Handle linking destinations ---
	for( i = 0; i < NIS.ActiveDestinationPairs.Length; i++ )
	{
		NCD1 = NIS.ActiveDestinationPairs[i].FirstDestination;
		if( NCD1.IntersectionManager != self )
		{
			NCD1.IntersectionManager = self;
		}
		NCD2 = NIS.ActiveDestinationPairs[i].SecondDestination;
		if( NCD2.IntersectionManager != self )
		{
			NCD2.IntersectionManager = self;
		}
		
		if( bNewActive )
		{
			if( NCD1.NextDestinations.Find(NCD2) == INDEX_NONE )
			{
				NCD1.NextDestinations.AddItem(NCD2);
			}
			if( NCD2.NextDestinations.Find(NCD1) == INDEX_NONE )
			{
				NCD2.NextDestinations.AddItem(NCD1);
			}

			if( bDebug )
			{
				DrawDebugLine(NCD1.Location, NCD2.Location, 0, 255, 0, TRUE);
			}
		}
		else
		{
			NCD1.NextDestinations.RemoveItem(NCD2);
			NCD2.NextDestinations.RemoveItem(NCD1);

			if( bDebug )
			{
				DrawDebugLine(NCD1.Location, NCD2.Location, 255, 0, 0, TRUE);
			}
		}
	}	
}

simulated function bool SafeToChangeState()
{
	local NanoIntersectionState NIS;
	local int i;

	// Check for pedestrians still in transit.
	if( CrossingAgentCount != 0 )
	{
		return FALSE;
	}

	// Check to see if any of the ActiveSplines still have traffic on them.  If so, bail.
	NIS = IntersectionStates[ActiveState];
	for( i = 0; i < NIS.ActiveSplines.Length; i++ )
	{
		if( ( NIS.ActiveSplines[i] != None ) && ( NIS.ActiveSplines[i].VehiclesOnSpline.Length != 0 ) )
		{
			if( !bTrafficShutoff )
			{
				ShutoffTraffic();
			}
			
			// Attempt to clear up the jam!
			NIS.ActiveSplines[i].VehiclesOnSpline[0].TryToClearJam(4);
			return FALSE;
		}
	}

	// Check to see if any of the traffic light splines still have traffic on them.  If so, bail.
	for( i = 0; i < NIS.ActiveTrafficLights.Length; i++ )
	{
		if( NIS.ActiveTrafficLights[i] != None && NIS.ActiveTrafficLights[i].VehiclesOnSpline.Length != 0 )
		{
			if( !bTrafficShutoff )
			{
				ShutoffTraffic();
			}
			return FALSE;
		}
	}

	// All clear, safe to change lanes!
	return TRUE;
}

/***************************************************************************
*   Pedestrian Management
***************************************************************************/
simulated function IncrementCrossingAgentCount()
{
	CrossingAgentCount++;
}

simulated function DecrementCrossingAgentCount()
{
	CrossingAgentCount--;
}

simulated function CloseCrosswalks()
{
	local NanoIntersectionState NIS;
	local int i;
	local NanoCrosswalkDestination NCD1, NCD2;

	NIS = IntersectionStates[ActiveState];
	for( i = 0; i < NIS.ActiveDestinationPairs.Length; i++ )
	{
		NCD1 = NIS.ActiveDestinationPairs[i].FirstDestination;
		NCD2 = NIS.ActiveDestinationPairs[i].SecondDestination;

		NCD1.NextDestinations.RemoveItem(NCD2);
		NCD2.NextDestinations.RemoveItem(NCD1);

		if( bDebug )
		{
			DrawDebugLine(NCD1.Location + vect(0,0,16), NCD2.Location + vect(0,0,16), 255, 255, 0, TRUE);
		}
	}
}

/***************************************************************************
*   Traffic management
***************************************************************************/
simulated function ShutoffTraffic()
{
	local NanoIntersectionState NIS;
	local int i;

	NIS = IntersectionStates[ActiveState];
	for( i = 0; i < NIS.ActiveTrafficLights.Length; i++ )
	{
		NIS.ActiveTrafficLights[i].SetTrafficLightState( ETLS_Red );

		if( bDebug )
		{
			DrawDebugLine(Location + vect(0,0,16), NIS.ActiveTrafficLights[i].Location + vect(0,0,16), 255, 0, 0, TRUE);
		}
	}

	bTrafficShutoff = TRUE;
}

/***************************************************************************
*   Kismet / LD interfaces
***************************************************************************/
simulated event OnManageIntersection( SeqAct_ManageIntersection inAction )
{
	local int i;

	// Clear previous state change timers
	ClearTimer( nameof(AdvanceState) );

	if( inAction.InputLinks[0].bHasImpulse )
	{
		// First Line:  Activate a specific intersection state
		SetIntersectionState(inAction.NewState);
	}
	else if( inAction.InputLinks[1].bHasImpulse )
	{
		// Second Line: Advance the state by one
		AdvanceState();
	}
	else if( inAction.InputLinks[2].bHasImpulse )
	{
		// Third Line:  Disable all traffic
		for( i = 0; i < IntersectionStates.Length; i++ )
		{
			SetIntersectionState_Helper(i, FALSE);
		}
	}
}

defaultproperties
{
	bNoDelete=TRUE

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.Crowd.T_Crowd_TrafficLight'
		HiddenGame=TRUE
		HiddenEditor=FALSE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
		Scale=0.5f
	End Object
	Components.Add(Sprite)

	ActiveState=-1

	// Enable this to see debugging lines showing traffic and crosswalk state
	bDebug=FALSE
}