/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class CoverLink_Movable extends CoverLink_Dynamic
	native;

cpptext
{
	virtual void BuildSlotInfo(INT SlotIdx,UBOOL bSeedPylon=FALSE, AScout* Scout=NULL);

protected:
	virtual void UpdateTurnTargets(AScout* Scout, INT SlotIdx);
};

/** If true, the associated InterpActor_MovableCover be pushed while in cover at this link */
var() bool bAllowPush;
/** If true, the associated InterpActor_MovableCover be pulled while in cover at this link */
var bool bAllowPull;
/** If true, the associated InterpActor_MovableCover be rotated while in cover at this link */
var bool bAllowRotate;
/** If true, the associated InterpActor_MovableCover be kicked while in cover at this link */
var() bool bAllowKick;
/** If true, the associated InterpActor_MovableCover can be moved sideways while at cover at this link */
var bool bAllowStrafeMove;
/** If true, hard impacts when entering cover will apply an impulse to the InterpActor_MovableCover */
var bool bAllowRoadieShove;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	UpdateCoverLink();

	// For Gears 3, we only want push
	bAllowPull = FALSE;
	bAllowRotate = FALSE;
	bAllowStrafeMove = FALSE;
	bAllowRoadieShove = FALSE;
}

defaultproperties
{
	bAllowPush=TRUE
	bAllowPull=FALSE
	bAllowRotate=FALSE
	bAllowKick=FALSE
	bAllowStrafeMove=FALSE
	bAllowRoadieShove=FALSE
	bSkipPathUpdate=TRUE
}