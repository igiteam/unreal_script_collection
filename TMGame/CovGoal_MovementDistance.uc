
/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class CovGoal_MovementDistance extends CoverGoalConstraint
	native(TGAI);

var() float BestCoverDist; // desired distance to move
var() float MaxCoverDist;  // maximum distance to move
var() float MinCoverDist;  // minimum distance to move

var() bool	bMoveTowardGoal;
var() float MinDistTowardGoal;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
