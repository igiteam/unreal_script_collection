/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class OLScout extends UDKScout
	native(AI);

defaultproperties
{
	Begin Object NAME=CollisionCylinder
		CollisionRadius=+0034.000000
	End Object

	PathSizes.Empty
	PathSizes(0)=(Desc=Crouched,Radius=5,Height=44)
	PathSizes(1)=(Desc=Human,Radius=5,Height=90)
	PathSizes(2)=(Desc=Small,Radius=5,Height=44)
	PathSizes(3)=(Desc=Common,Radius=30,Height=90)
	PathSizes(4)=(Desc=Max,Radius=60,Height=190)

	TestJumpZ=400
	TestGroundSpeed=350
	TestMaxFallSpeed=2500
	MaxStepHeight=20.0
	MaxJumpHeight=35.0
	MaxDoubleJumpHeight=600.0
	MinNumPlayerStarts=1
	WalkableFloorZ=0.78

	PrototypePawnClass=class'OLGame.OLEnemyPawn'
	SizePersonFindName=Human
	
	NavMeshGen_EntityHalfHeight=90.0
	NavMeshGen_StartingHeightOffset=95.0
	NavMeshGen_MaxDropHeight=35.0
	NavMeshGen_MaxPolyHeight=190.0

	NavMeshGen_StepSize=5.0f
}
