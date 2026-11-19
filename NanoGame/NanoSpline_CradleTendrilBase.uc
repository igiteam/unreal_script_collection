/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
 
class NanoSpline_CradleTendrilBase extends SplineLoftActor
	native
	config(Game)
	abstract;

/** This determines whether or not this spline actor is a point where you can jump onto it **/
var() bool bMountPoint;

/** Setting this to true will foce the player to be dismounted from the spline. **/
var() bool bForceDismountPoint;

var StaticMeshComponent AttachMesh1;
var StaticMeshComponent AttachMesh2;
var StaticMeshComponent AttachMesh3;

/** This will multiply the speed of travel by this amount; **/
var() float SpeedMultiplerForThisSegment;

/** Distance away from main spline to surf  */
var()   float   SurfRadius;

/** Angle around spline to surf (added on top of Roll) */
var()   float   SurfRoll;

/** How fast you cruise along the tendril **/
var config float CradleTendrilSurfSpeed;

/** If the player is pressing forward or pulling backward on the thumstick we will modify the speed by these amounts **/
var config float ThumbstickFowardSpeedModifier;
var config float ThumbstickBackwardSpeedModifier;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}


cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	
	virtual void EditModeSelectedDraw(const FSceneView* View,FViewport* Viewport,FPrimitiveDrawInterface* PDI);
}

/** Util that works out where you should be when surfing on this tendril, taking into account SurfRadius and SurfRoll. */
native function vector GetSurfPosition(NanoSpline_CradleTendrilBase TargetTendril, float DistanceAlong);


defaultproperties
{
	bMountPoint=TRUE

	SpeedMultiplerForThisSegment=1.0f
	
	SurfRadius=200.0
	SurfRoll=0.0
}
	