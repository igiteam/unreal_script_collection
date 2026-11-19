/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class NanoVehicleSpline_MagLev extends NanoVehicleSpline
	native(inherit)
	placeable;

/** Static Mesh to place along the path of the spline **/
var() StaticMesh    PathMesh;
/** List of actual mesh components along the spline **/
var private array<StaticMeshComponent>  PathMeshList;
/** Distance between PathMesh meshes along the path of the spline **/
var() float     PathMeshDistance;
/** Used for iterating over the entire spline path to update meshes **/
var transient bool  bMeshesAlreadyCalculated;

/** Radial extent of the traces done to check for potential targets to attract **/
var() float AttractionRadialDistance;
/** Since NZE traces are expensive, setting this allows a delay between attraction trace checks **/
var float   AttractionCheckPeriod;

/** Acceleration that should be applied to actors being attracted to the center of the maglev track **/
var() float ActorAttractAcceleration;

/** Time since we last started checking the spline for actors to attract **/
var private float   LastAttractionCheckTime;
/** The spline is broken down into this many evenly spaced segments based on its curviness (max of 3 per spline) **/
var private int             SegmentsToCheck;
var private transient int   SegmentsToCheckRemaining;

/** Struct to keep track of non-vehicle actors on this spline, and where they are **/
struct native LevitatingActorInfo
{
	var Actor   LevActor;
	var float   SplineOffset;
	var float   CurrentSplineSpeed;
};

/** An array of non-vehicle actors that are currently being levitated on this spline **/
var private transient array<LevitatingActorInfo>    LevitatingActors;

/** Max speed of actors that are caught in the levitating field...this does NOT count for normal vehicles on the actual spline! **/
var() float   MaxLevitaingSpeed;
/** Acceleration down the track of objects caught in the maglev field **/
var() float   MagLevAcceleration;

var() DynamicLightEnvironmentComponent  LightEnvironment;

/** If true, the traces used to approximate the spline for attraction will be drawn **/
var() bool    bDrawAttractTraces;

cpptext
{
	/** When the editor makes a change, we potentially need to rebuild the path meshes **/
	virtual void PostLoad();
	virtual void PostEditMove(UBOOL bFinished);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	/** In the tick, perform non-zero extent checks along the path of the spline to determine if there's anything that needs to be attracted **/
	virtual void TickSpecial( FLOAT DeltaSeconds );
};

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	ReattachPathMeshes();
	CalculateSplineSegments();
}

/** Gets the first path node in this chain, or returns this node if looped **/
native function NanoVehicleSpline_MagLev GetFirstNodeInChain();

/** Recalculates placement of PathMeshes along the length of the spline **/
native function RecalculatePathMeshes( optional float StartingOffset );

/** Reattaches all path mesh components without recalculating their positions **/
native function ReattachPathMeshes();

/** Calculates how many segments the spline should be divided into for attraction tracing based on the beginning and end tangents **/
native function CalculateSplineSegments();

/** Returns the location, spline speed, and tangent along the spline that the player should be attracted towards when caught up in the maglev field **/
native function GetMagLevAttractionInfo( Actor TestActor, out vector PathLoc, out vector PathDir, out float PathSpeed );

/** Returns an initial distance along the spline to attract the player to when caught up in the maglev field **/
native function float GetInitialMagLevAttractionPoint( vector TestLocation );

/** Returns whether or not the actor specified is being actively levitated by this spline **/
native function int GetLevitatingInfoIndex( Actor TestActor );

/** Called to add an actor to the spline's influence **/
simulated event AddActorToMagLevSpline( Actor ActorToAdd )
{
	local LevitatingActorInfo Info;
	local NanoInterface_MagLev MLI;
	local int ActorIndex;

	// Only add the actor if they are not already listed as being levitated
	ActorIndex = GetLevitatingInfoIndex(ActorToAdd);
	if( ActorIndex == INDEX_NONE )
	{
		Info.LevActor = ActorToAdd;
		Info.SplineOffset = GetInitialMagLevAttractionPoint(ActorToAdd.Location);
		// If there is a spline, set the initial velocity to be the actor's current velocity in the direction of the tangent of the spline
		if( Connections.Length > 0 )
		{
			Info.CurrentSplineSpeed = Normal(Connections[0].SplineComponent.GetTangentAtDistanceAlongSpline(Info.SplineOffset)) dot ActorToAdd.Velocity;
		}

		// Register the actor info so it will be updated in the tick
		LevitatingActors.AddItem(Info);

		// Notify the actor that they've been sucked in
		MLI = NanoInterface_MagLev(ActorToAdd);
		if( MLI != None )
		{
			MLI.BeginMagLevAttraction(self);
		}
	}
}

/** Called to remove an actor from the spline's influence **/
simulated event RemoveActorFromMagLevSpline( Actor ActorToRemove )
{
	local NanoInterface_MagLev MLI;
	local LevitatingActorInfo LAI;
	local SplineComponent SplineComp;
	local int ActorIndex;

	// Only remove the actor if it is registered as being levitated
	ActorIndex = GetLevitatingInfoIndex(ActorToRemove);
	if( ActorIndex != INDEX_NONE )
	{
		// Transfer the velocity to the actor being removed
		SplineComp = (Connections.Length > 0) ? Connections[0].SplineComponent : None;
		if( SplineComp != None )
		{
			LAI = LevitatingActors[ActorIndex];
			LAI.LevActor.Velocity = LAI.CurrentSplineSpeed * Normal(SplineComp.GetTangentAtDistanceAlongSpline(LAI.SplineOffset));
		}
		
		// Unregister the actor from the spline
		LevitatingActors.Remove(ActorIndex, 1);

		// Notify the actor that they've been spit out
		MLI = NanoInterface_MagLev(ActorToRemove);
		if( MLI != None )
		{
			MLI.EndMagLevAttraction();
		}
	}
}

simulated event PassActorToNextMagLevSpline( LevitatingActorInfo ActorInfo, float MoveRemaining )
{
	local NanoVehicleSpline_MagLev NextSpline;
 	local float SplineLength;
	local NanoInterface_MagLev MLI;
 
 	if( Connections.Length > 0 )
 	{
 		SplineLength = Connections[0].SplineComponent.GetSplineLength();
 
 		// If this move is bigger than we can handle, so try to pass it off to the next spline in the appropriate direction
 		if( abs(MoveRemaining) > SplineLength )
 		{
 			if( (MoveRemaining < 0.f) && (LinksFrom.Length > 0) )
 			{
				NextSpline = NanoVehicleSpline_MagLev(LinksFrom[0]);
				MoveRemaining += SplineLength;
 			}
			else if( Connections.Length > 0 )
			{
				NextSpline = NanoVehicleSpline_MagLev(Connections[0].ConnectTo);
				MoveRemaining -= SplineLength;
			}

			if( NextSpline != None )
			{
				NextSpline.PassActorToNextMagLevSpline(ActorInfo, MoveRemaining);
			}
			else
			{
				// Couldn't find a spline to pass them off to, so drop them
				RemoveActorFromMagLevSpline(ActorInfo.LevActor);
			}
 		}
		else
		{
			// Add to this spline!
			if( MoveRemaining < 0.f )
			{
				MoveRemaining += SplineLength;
			}
			ActorInfo.SplineOffset = MoveRemaining;
			LevitatingActors.AddItem(ActorInfo);

			// Notify the actor that they've been passed on to a new spline
			MLI = NanoInterface_MagLev(ActorInfo.LevActor);
			if( MLI != None )
			{
				MLI.BeginMagLevAttraction(self);
			}
		}
 	}
	else
	{
		// Couldn't find a spline to pass them off to, so drop them
		RemoveActorFromMagLevSpline(ActorInfo.LevActor);
	}
}

defaultproperties
{
	DeformMesh=None

	PathMesh=StaticMesh'Nano_Proto_City_LOD_4.SM.Mesh.S_Proto_RailRing'

	PathMeshDistance=200.0

	AttractionRadialDistance=300.0
	AttractionCheckPeriod=0.15

	ActorAttractAcceleration=2500.0
	MagLevAcceleration=1250.0
	MaxLevitaingSpeed=2000.0

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
		bDynamic=FALSE
		InvisibleUpdateTime=10.0
		MinTimeBetweenFullUpdates=2.0
		TickGroup=TG_DuringAsyncWork
		bCastShadows=FALSE
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	bStatic=FALSE
}
