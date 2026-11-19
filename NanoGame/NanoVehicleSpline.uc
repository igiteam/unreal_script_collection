/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class NanoVehicleSpline extends SplineLoftActor
	placeable
	hidecategories(SplineLoftActor)
	native(Vehicle);

/** Whether or not this spline is limited to flying vehicles only */
var bool                        bFlyingVehiclesOnly;

/** If TRUE, allow the NanoVehiclePopulationManager to consider this spline for spawning and path visibility.  Cars will only be spawned by the pop manager if bAllowPopManagerSpawningOnSpline is TRUE */
var() bool                      bManageTraffic;
/** Whether or not to allow the NanoVehiclePopulationManager to spawn traffic on this spline (if FALSE, and bManageTraffic is TRUE, the spline will still be included for path visibility calculations) */
var() bool                      bAllowPopManagerSpawningOnSpline;

/** Sets the maximum vehicle density on the spline (Number of Vehicles on Spline / (Total Spline Length * Number of Lanes) */
var() float                     MaximumTrafficDensity;
/** Total area of the spline, used for calculating traffic density */
var protected transient float   TotalSplineArea;
/** Current traffic density on this spline */
var protected transient float   CurrentTrafficDensity;

var() float                     ReserveDistance;
var() float                     DepartReserveDistance;

var() bool                      bDrawDebugInfo;

/** Vehicle trying to reserve this lane for merging, indexed by lane */
var transient array<NanoVehicleAgent>  ReservedByVehicle;

/** How many splines are connected _to_ this node */
var transient int               NumArrivingSplines;

var transient array<NanoVehicleAgent>   VehiclesOnSpline;

/** Pointer to the last vehicle in each lane, to speed up lane availability queries */
var transient array<NanoVehicleAgent>   LastVehicleInLane;

/**
 * This is the suggested speed for cars on this spline.  This is then modified by the specific car that is driving on this spline.
 * The idea here is that we want to have straight portions of the road network and then curves (which are slower than the straight aways).
 *
 * So basically we have:  Min( MaxCarSpeed, (SuggestedSpeed * SplineSuggestedSpeedModifier ) ) as the car's speed
 **/
var() float SuggestedSpeed;

/** Width of the road.  Number of lanes will be determined by Floor(RoadWidth / NANO_VEHICLE_LANE_WIDTH) */
var() float RoadWidth;

/** Number of lanes on this spline.  Calculated automatically in SizeRoadMesh() */
var const int   NumLanes;

/** Space that must be available in the best lane in order to accept new cars being spawned on to this spline */
var() float     MinSpaceForSpawnedVehicles;

/** Vector offsets from the center of the spline for each lane of the road, in spline space */
var array<vector>   LaneOffsets;

/** Width of traffic lanes, in units */
var() editconst float LaneWidth;

/** Meshes to put on the right and left of the road as road boundaries */
var StaticMesh BoundaryMesh;

/** Stores references to all the boundary meshes on the spline (two for each connection) */
var array<SplineMeshComponent> BoundaryMeshComps;

/** Materials to put on the boundary meshes */
var array<MaterialInterface> BoundaryMeshMaterials;

/** Material instance of the road meshes, for blending color */
var transient array<MaterialInstance> RoadMaterialInst;

/** Distance from spline to the player */
var transient float DistanceFromPlayer;

/** If the player can currently see the spline directly */
var transient bool  bPlayerHasLineOfSight;

/** Priority of this spline, set by the NanoVehiclePopulationManager.  See NanoVehiclePopulationManager::UpdateSplinePriority */
var transient float SpawnerPriority;

/** The last time we updated the spline distance from the player */
var transient float LastUpdateDistanceFromPlayerTime;

/* Current stat of traffic light for this spline.  All splines can now function as traffic lights, being turned on and off to the flow of traffic */
var()   ETrafficLightState          CurrentState;

cpptext
{
	// AActor interface
	void PostLoad();
	void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
#if WITH_EDITOR
	virtual void CheckForErrors();
#endif

	/** Fills out LaneOffsets array based on number of lanes and road width */
	void CalculateLaneOffsets();

	/** Creates boundary mesh components ("curbs") for this road */
	void UpdateCurbBoundaries();
}

simulated native function vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc) const;


simulated function PostBeginPlay()
{
	local int i;
	local NanoVehicleSpline VSpline;
	local NanoGRI NGRI;
	local SplineComponent SplineComp;
	local float TotalSplineLength;

	Super.PostBeginPlay();
	
	// Increment count on all nodes that we connect to.
	for(i=0; i<Connections.Length; i++)
	{
		VSpline = NanoVehicleSpline(Connections[i].ConnectTo);
		if(VSpline != none)
		{
			VSpline.NumArrivingSplines++;
		}
	}

	InitializeRoadMeshes();

	// Tell the GRI that we exist, so that we can be turned on / off
 	NGRI = NanoGRI(WorldInfo.GRI);
 	if( NGRI != None )
 	{
 		NGRI.NRM.RegisterVehicleSpline(self);
 	}

	// Get a material instance for the road meshes
	for(i=0; i<SplineMeshComps.Length; ++i)
	{
		if( SplineMeshComps[i] != None )
		{
			RoadMaterialInst.AddItem( SplineMeshComps[i].CreateAndSetMaterialInstanceConstant(0) );
		}
	}

	// Get material instances for boundary meshes
	for(i=0; i<BoundaryMeshComps.Length; ++i)
	{
		RoadMaterialInst.AddItem( BoundaryMeshComps[i].CreateAndSetMaterialInstanceConstant(0) );
	}

	// Determine the area of the road
	if( Connections.Length > 0 )
	{
		for(i = 0; i < Connections.Length; ++i)
		{
			if( Connections[i].ConnectTo != None )
			{
				SplineComp = FindSplineComponentTo(Connections[i].ConnectTo);
				TotalSplineLength += SplineComp.GetSplineLength();
			}
		}

		TotalSplineArea = TotalSplineLength * NumLanes;
		
		UpdateTrafficDensity();
	}

	// Add NULL references for each lane to initialize lane tracking
	LastVehicleInLane.Add(NumLanes);
}

/** Updates the color of the road mesh shader, called from NanoRoadManager::TickSpecial() */
native function UpdateRoadColor( LinearColor NewRoadColor );

simulated event UpdateDistanceFromPlayer()
{
	local PlayerController PC;
	local NanoVehiclePopulationManager NPM;
	local vector CamLoc;
	local rotator CamRot;
	local float Dist, MaxLOSCheckDist;
	local bool bOldSkipExtraLOSChecks;

	DistanceFromPlayer = 999999.f;
	
	// Determine the max distance to perform LOS checks for, based on the spline's population manager
	NPM = bFlyingVehiclesOnly ? NanoGRI(WorldInfo.GRI).AirVehiclePopMgr : NanoGRI(WorldInfo.GRI).GroundVehiclePopMgr;
	MaxLOSCheckDist = (NPM != None) ? NPM.MaxSplineSpawnDistance : 6000.f;

	foreach WorldInfo.AllControllers(class'PlayerController',PC)
	{
		PC.GetPlayerViewPoint(CamLoc,CamRot);
		Dist = VSize(CamLoc - Location);
		if (Dist < DistanceFromPlayer)
		{
			DistanceFromPlayer = Dist;
		}

		if( DistanceFromPlayer <= MaxLOSCheckDist )
		{
			// Do a simpler line check for visibility to cut down the cost
			bOldSkipExtraLOSChecks = PC.bSkipExtraLOSChecks;
			PC.bSkipExtraLOSChecks = TRUE;
			bPlayerHasLineOfSight = PC.LineOfSightTo(self, CamLoc);
			PC.bSkipExtraLOSChecks = bOldSkipExtraLOSChecks;
		}
		else
		{
			bPlayerHasLineOfSight = FALSE;
		}
		break;
	}

	// Save the update time, so the NanoRoadManager knows when to update this again
	LastUpdateDistanceFromPlayerTime = WorldInfo.TimeSeconds;
}

simulated function InitializeRoadMeshes()
{
	local SplineMeshComponent SMC;

	// Scale the deform mesh to accommodate desired road width
	SizeRoadMesh();

 	foreach SplineMeshComps(SMC)
 	{
 		// Make sure the spline meshes are initially hidden in-game
 		SMC.SetHidden(TRUE);
 
 		// Make sure the meshes don't interfere with cars on the track
 		SMC.SetTraceBlocking(FALSE, FALSE);
 		SMC.SetActorCollision(FALSE, FALSE, FALSE);
 	}

	foreach BoundaryMeshComps(SMC)
	{
		// Make sure the spline meshes are initially hidden in-game
 		SMC.SetHidden(TRUE);
 
 		// Make sure the meshes don't interfere with cars on the track
 		SMC.SetTraceBlocking(FALSE, FALSE);
 		SMC.SetActorCollision(FALSE, FALSE, FALSE);
	}
}

simulated event Destroyed()
{
	local NanoGRI NGRI;

	// Remove this from the registry of roads...in case it gets streamed off
 	NGRI = NanoGRI(WorldInfo.GRI);
 	if( NGRI != None )
 	{
 		NGRI.NRM.UnregisterVehicleSpline(self);
 	}

	Super.Destroyed();
}

/** Called when something changes the width of the road (e.g. PostEditChange()) */
native function SizeRoadMesh();

/** Called to hide or reveal the actual road mesh */
simulated function HideRoadMesh(bool bNewHidden)
{
	local SplineMeshComponent SMC;

	// Show / hide all the road mesh components
 	foreach SplineMeshComps(SMC)
 	{
 		SMC.SetHidden(bNewHidden);
 	}

	// Show / hide all the boundary mesh components (kept in a separate array, so that the editor callbacks don't mess with the customized offsets)
	foreach BoundaryMeshComps(SMC)
	{
		SMC.SetHidden(bNewHidden);
	}
}

/** Function to return if */
simulated native final function bool IsMergePoint() const;


/** Vehicle call this to see if they can approach. This can result in the vehicle 'reserving' this merge point if TestLane is NOT specified */
simulated native function bool CanApproach(NanoVehicleAgent Vehicle, optional int TestLane = INDEX_None);

simulated event bool IsValidSplineForVehicle(NanoVehicleAgent Vehicle)
{
	if( Vehicle != None )
	{
		switch(Vehicle.VehicleType)
		{
		case ENVT_Ground:
			return !bFlyingVehiclesOnly;
		case ENVT_Flying:
			return bFlyingVehiclesOnly;
		case ENVT_Both:
			return TRUE;
		}
	}
	else
	{
		return FALSE;
	}
}

/** Can this spline have new vehicles spawned on to it? */
simulated function bool CanAcceptNewSpawnedVehicles()
{
	return (GetBestLaneForVehicle(TRUE) != INDEX_NONE) && (CurrentTrafficDensity < MaximumTrafficDensity);
}

function UpdateTrafficDensity()
{
	if( TotalSplineArea > 0.f )
	{
		// Update the traffic density
		CurrentTrafficDensity = VehiclesOnSpline.Length / TotalSplineArea;
	}
	else
	{
		CurrentTrafficDensity = VehiclesOnSpline.Length > 0 ? 1.f : 0.f;
	}
}

simulated event AddVehicleToSpline(NanoVehicleAgent Vehicle, optional int Lane)
{
	if( IsValidSplineForVehicle(Vehicle) )
	{
		// First, remove from current spline if its on one
		if(Vehicle.CurrentSpline != none)
		{
			Vehicle.CurrentSpline.RemoveVehicleFromSpline(Vehicle);
		}

		// Should now not be on any spline, so certainly should not be on this one
		assert(VehiclesOnSpline.Find(Vehicle) == INDEX_NONE);
		// Add to this ones list
		VehiclesOnSpline.AddItem(Vehicle);
		// And set pointer on vehicle
		Vehicle.CurrentSpline = self;
		Vehicle.CurrentSplineLane = Lane;

		if( Vehicle.CurrentSplineLane >= NumLanes || Vehicle.DesiredSplineLane >= NumLanes )
		{
			Vehicle.KillAgent();
		}

		UpdateTrafficDensity();

		// Fire crowd event for reaching this actor
		TriggerEventClass( class'SeqEvent_CrowdAgentReachedDestination', Vehicle );

		if( Lane != INDEX_NONE )
		{
			LastVehicleInLane[Lane] = Vehicle;
		}
	}
	else
	{
		`warn("Trying to add invalid vehicle (" $ Vehicle $ ") to spline " $ self);
	}
}

simulated function int GetBestLaneForVehicle(optional bool bTestForMinDistance)
{
	local int i;

	for( i = 0; i < LastVehicleInLane.Length; ++i )
 	{
 		if( LastVehicleInLane[i] == None || (LastVehicleInLane[i].CurrentSplinePos > MinSpaceForSpawnedVehicles) )
 		{
 			return i;
 		}
 	}
 
 	return INDEX_NONE;

//  === OLD CODE === IN CASE WE NEED TO ROLL BACK 
//	local NanoVehicleAgent NVA;
//	local array<float>  LaneMinDistances;
//	local float BestLaneDistance, CurrentDistance;
//	local int i, BestLane;
// 	// Keep track of which lanes have vehicles in them, and at what distances
// 	for(i = 0; i < NumLanes; i++ )
// 	{
// 		LaneMinDistances[i] = -1.f;
// 	}
// 
// 	// Iterate over all vehicles on this spline, and find the lane with the most distance at the beginning of the spline
// 	foreach VehiclesOnSpline(NVA)
// 	{
// 		// Safety:  make sure this vehicle is in a valid lane on the spline
// 		if( NVA.CurrentSplineLane < NumLanes )
// 		{
// 			// See if this vehicle qualifies
// 			if( (LaneMinDistances[NVA.CurrentSplineLane] < 0.f) || (NVA.CurrentSplinePos < LaneMinDistances[NVA.CurrentSplineLane]) )
// 			{
// 				LaneMinDistances[NVA.CurrentSplineLane] = NVA.CurrentSplinePos;
// 			}
// 		}
// 		else
// 		{
// 			`warn("Warning - Vehicle on spline with invalid lane!");
// 		}
// 	}
// 
// 	// Return the lane with the greatest minimum distance, or the first free lane (LaneMinDistance < 0.f)
// 	BestLane = INDEX_NONE;
// 	BestLaneDistance = 0.f;
// 	for( i = 0; i < NumLanes; ++i )
// 	{
// 		// If there's someone approaching this lane, skip it for consideration
// 		if( ReservedByVehicle[i] != None )
// 		{
// 			continue;
// 		}
// 
// 		CurrentDistance = LaneMinDistances[i];
// 
// 		// Found a free lane, use that
// 		if( CurrentDistance < 0.f )
// 		{
// 			BestLane = i;
// 			break;
// 		}
// 		else if( (CurrentDistance > BestLaneDistance) && (!bTestForMinDistance || (bTestForMinDistance && (CurrentDistance >= MinSpaceForSpawnedVehicles))) )
// 		{
// 			BestLane = i;
// 		}
// 	}
// 
// 	return BestLane;
}

simulated event RemoveVehicleFromSpline(NanoVehicleAgent Vehicle)
{
	// Remove from this splines list
	VehiclesOnSpline.RemoveItem(Vehicle);
	if( (Vehicle.CurrentSplineLane != INDEX_NONE) && (LastVehicleInLane[Vehicle.CurrentSplineLane] == Vehicle) )
	{
		LastVehicleInLane[Vehicle.CurrentSplineLane] = None;
	}

	// And reset pointer in vehicle
	Vehicle.CurrentSpline = None;	
	Vehicle.CurrentSplineLane = 0;

	UpdateTrafficDensity();
}

/** Updates, and if necessary, clears any vehicle reservations on this spline */
native function UpdateVehicleReservations();

simulated function SetTrafficLightState( ETrafficLightState NewState )
{
	if( NewState != CurrentState )
	{
		CurrentState = NewState;
	}
}

/** Adding support for toggling to save the LD's some time */
simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		CurrentState = ETLS_Green;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		CurrentState = ETLS_Red;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		CurrentState = (CurrentState == ETLS_Green ? ETLS_Red : ETLS_Green);
	}
}

/** Called from Kismet function to change light state */
simulated function OnSetTrafficLightState(SeqAct_SetTrafficLightState Action)
{
	CurrentState = Action.NewState;	
}

defaultproperties
{
	SupportedEvents.Add(class'SeqEvent_CrowdAgentReachedDestination')

	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.Crowd.T_Crowd_Spline'
	End Object

	Begin Object Class=ArrowComponent Name=ArrowComponent0
		bTreatAsASprite=True
		HiddenGame=true
	End Object
	Components.Add(ArrowComponent0)

	bStatic=true
	bCollideActors=false
	bBlockActors=false

	// SplineLoft properties
	bAcceptsLights=false

	ScaleX=0.0625f
	ScaleY=1.f

	//DeformMesh=StaticMesh'Nano_Proto_FlyingCarRoad.SM.Mesh.S_Proto_ProcRoadMesh'
	//DeformMeshMaterials(0)=MaterialInstanceConstant'Nano_Proto_FlyingCarRoad.Materials.MI_FlyingCarRoad_MasterDistance'
	WorldXDir=(X=0.f,Y=0.f,Z=-1.f)

	//BoundaryMesh=StaticMesh'Nano_Proto_FlyingCarRoad.SM.Mesh.S_Proto_ProcRoadBumperMesh'

	CurrentState=ETLS_Green

	bFlyingVehiclesOnly=TRUE
	bManageTraffic=TRUE
	// Traffic density == 1 car for every 2048 units of lane
	MaximumTrafficDensity=0.000195

	MinSpaceForSpawnedVehicles=700.f
	ReserveDistance=800.0
	DepartReserveDistance=200.0
	bDrawDebugInfo=FALSE
	
	SplineColor=(R=120,B=220,A=255)	

	SuggestedSpeed=1000.0f

	RoadWidth=512.f
	LaneWidth=512.f

	TickFrequency=0.1
	TickFrequencyDecreaseDistanceStart=8000
	TickFrequencyDecreaseDistanceEnd=12000
	TickFrequencyAtEndDistance=0.1

	bAllowPopManagerSpawningOnSpline=TRUE
}