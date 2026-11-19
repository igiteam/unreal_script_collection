//=============================================================================
// SASClimbPoint.uc
//
// Abstract base class of climbing navigation points.
// Climb nav points are placed at the top and bottom of an obstacle to be climbed
// (or in the case of walls, at either side of the wall).
//=============================================================================

class SASClimbPoint extends NavigationPoint
	native
	abstract;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

var const bool				mbUseAsEndPoint;	// If true, then point can be used as the end of a climb.
var const SASClimbPoint		mLinkedPoint;		// Point at other side of climb.
var const EClimbType		meClimbType;		// Type of climb (small step, large step, over wall etc)

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// SuggestMovePreparation
//
// Event called by engine movement code when pawn 'aOther' is about to move 
// to this point. Check to see if pawn needs to climb to reach the point. 
event bool SuggestMovePreparation(
	Pawn	aOther )
{
	// If pawn's current anchor point is our linked climb point and the anchor 
	// point has a climb type defined then it needs to switch to climbing state 
	// to reach this point.
	if ( (mLinkedPoint != None)
		&& (aOther.Anchor == mLinkedPoint)
		&& (mLinkedPoint.meClimbType != CLIMB_None) 
		&& aOther.ReachedDestination( mLinkedPoint, true ) )
	{
		if ( SASAIController( aOther.Controller ) != None )
		{
			if ( SASAIController( aOther.Controller ).StartClimbing( mLinkedPoint ) )
			{
				aOther.Controller.bPreparingMove = true;
				return true;
			}
		}
	}

	return false;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    bSpecialMove=true
    CollisionRadius=10.0000000
    bCollideWhenPlacing=false
}