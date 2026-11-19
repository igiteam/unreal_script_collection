/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPylon extends Pylon
	native
	placeable;


/** Whether or not this pylon is considered to be be a rooftop. (needed until we are all proc'd up / find a slick Z way to test)**/
var() bool bRooftop;

/** Whether or not this pylon is considered to be be a street. (needed so we can have sematics of knowing what is street level and also for possible LOD on path generation)**/
var() bool bStreet;

var() bool bExpandMantleChecks;
var() bool bExpandJumpChecks;

cpptext
{
	virtual void CreateExtraMeshData( AScout* Scout );

	virtual void HandleFailedAddNode( AScout* Scout, const FVector& StartPos, const FVector& EndPos );

	UBOOL SimulateJumpDestination( ANanoPawn* NP, const FVector& JumpStart, const FVector& JumpDir, FVector& out_JumpEnd, FVector& out_JumpVel, FLOAT& out_JumpDestFallZ, FVector opt_JumpBoost = FVector(0.f), FVector opt_JumpVelScale = FVector(1.f), UBOOL bDrawDebugInfo = FALSE );
	UBOOL SimulateMantleDestination( ANanoPawn* NP, const FVector& MantleStart, const FVector& MantleDir, FVector& out_MantleEnd, INT& out_MantleIdx, class UNSM_Mantle_Base*& out_MantleSM );
}



defaultproperties
{
	bExpandMantleChecks=TRUE
	bExpandJumpChecks=TRUE
}