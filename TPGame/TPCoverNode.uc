class TPCoverNode extends CoverLink
	native
	placeable;


//***********************************************************************
// Variable Declaration
//***********************************************************************
var float CrouchAlignDist;

/** If true, the node will automatically adjust and link up with other cover nodes */
var() const bool bAutoSetup;

/** Additional weighting to apply when AI is evaluation cover */
var() const byte AIRating;

/** Distance used when aligning node to edges. Should match up player collision cylinder */
var const float EdgeAlignDist;

/** Distance used when aligning against corners */
var const float CornerAlignDist;

/** Distance threshold to treat two nodes as transitions */
var const float TransitionDist;

/** Distance used for checking lean fire links */
var const float LeanDist;

/** Distance used for checking popup fire links */
var const float PopupDist;

/** Linked node to the left of this node */
//var() const TPCoverNode LeftNode;
var() const NavReference LeftNode;

/** Linked node to the right of this node */
//var() const TPCoverNode RightNode;
var() const NavReference RightNode;

/** Linked node that can be transitioned to from this node */
//var() const TPCoverNode TransitionNode;
var() const NavReference TransitionNode;

/** Is this node current enabled for use? */
var() bool bEnabled;

/**
 * Contains information about what other cover nodes this node is
 * capable of firing on.
 */
struct native CoverFireLink
{
	/** Acceptable methods of attack to use when engaging the target node */
	var array<ECoverAction> CoverActions;
	/** Target node */
	var TPCoverNode TargetNode;
};

/** List of all attackable nodes */
var() const array<CoverFireLink> CoverFireLinks;

var() float m_DistenceToCheckAngleToEnemy;
//var() float m_DotProductToBeMoreThenToBeValidCoverFor;


/**
 * Contains information about what non "standard" sub cover behavior can be
 * performed while at this cover node
 */
struct native NodesSubCoverBehaviorInfo
{
	//var() SubCoverBehaviorInfo m_BlindFire;
	var() SubCoverBehaviorInfo m_PeekOut;
	//var() SubCoverBehaviorInfo m_StepOut;
	var() SubCoverBehaviorInfo m_WaveOn;
	//var() SubCoverBehaviorInfo m_LeanOut;
};

var() NodesSubCoverBehaviorInfo m_NodesSubCoverBehaviorInfo;


//***********************************************************************
// CPP Text
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//-----------------------------------------------------------------------
// Function:	GetPeekViewPoint()
// Description:
//-----------------------------------------------------------------------
native function vector GetPeekViewPoint( int SlotID, optional Controller forController);

//-----------------------------------------------------------------------
// Function:	FillPeekViewPoints()
// Description:
//-----------------------------------------------------------------------
native function FillPeekViewPoints( int SlotID, Controller forController);

//-----------------------------------------------------------------------
// Function:	IsSlotAvailableTo
// Description: No longer overridden now to check the the slot and the enabled flag
//-----------------------------------------------------------------------
native function bool IsSlotAvailableTo(int SlotID, Actor chkActor);
/*
{
	return (bEnabled && (CoverClaim == none ||
			chkActor == CoverClaim ||
			chkActor == CoverClaim.Pawn));
}
*/

/**
 * Returns true if this node's cover slot is claimed by a valid player.
 */
final function bool IsClaimed( int SoltIDNo )
{
	local CoverSlot slot;
	
	
	if( Slots.Length > SoltIDNo )
	{
		slot = Slots[SoltIDNo];
		
		return (slot.SlotOwner != None &&
				slot.SlotOwner.Pawn != None &&
				slot.SlotOwner.Pawn.Health > 0);
	}
	
	return false;
}

/**
 * Asserts a claim on this covernode by the specified player,
 * notifying the previous claim if applicable.
 */
 // CGH TODO Commented out for CoverLink Derived Test
/*final function Claim(Controller newClaim)
{
	if (newClaim != CoverClaim &&
		newClaim != None)
	{
		//if (CoverClaim != None)
		//{
		//	CoverClaim.NotifyCoverClaimRevoked(self);
		//}
		if (newClaim.Pawn != None &&
			newClaim.Pawn.Health > 0)
		{
			CoverClaim = newClaim;
		}
	}
}*/

/**
 * Negates the previous claim on this cover node.
 */
 // CGH TODO Commented out for CoverLink Derived Test
/*final function UnClaim(Controller oldClaim)
{
	if (oldClaim == CoverClaim)
	{
		CoverClaim = None;
	}
}*/

/**
 * Checks to see if the cover is claimed by the
 * specified controller
 */
native final function bool IsClaimedBy( int SlotID, Controller chkClaim);
/*
{
    if (CoverClaim == chkClaim)
    {
        return true;
    }

    return false;
}
*/

event PostBeginPlay()
{
	// calc the Dots for all the validity Angles
	// assumes the magnitue is 1 for both vectors
	local float radian;
	local float radianValLeft;
	local float radianValRight;
	local float radianValUp;
	local float radianValDown;
	local int idx;

	radian = 3.1415926535897932/180.0;

	for( idx = 0; idx < Slots.Length; idx++ )
	{
		if( Slots[idx].m_LeftValidityAngle < 0.001 )
		{
			Slots[idx].m_LeftValidityAngle = 60.0f;
		}
		radianValLeft = Slots[idx].m_LeftValidityAngle * radian;
		Slots[idx].m_LeftDotProductToBeMoreThenToBeValidCoverFor = Cos(radianValLeft);

		//`log(" ChadAI - m_LeftValidityAngle: " @ Slots[idx].m_LeftValidityAngle @ " radianValLeft: " @ radianValLeft @ " m_LeftDotProductToBeMoreThenToBeValidCoverFor: " @ Slots[idx].m_LeftDotProductToBeMoreThenToBeValidCoverFor@ "!");


		if( Slots[idx].m_RightValidityAngle < 0.001 )
		{
			Slots[idx].m_RightValidityAngle = 60.0f;
		}
		radianValRight = Slots[idx].m_RightValidityAngle * radian;
		Slots[idx].m_RightDotProductToBeMoreThenToBeValidCoverFor = Cos(radianValRight);

		//`log(" ChadAI - m_RightValidityAngle: " @ Slots[idx].m_RightValidityAngle @ " radianValRight: " @ radianValRight @ " m_RightDotProductToBeMoreThenToBeValidCoverFor: " @ Slots[idx].m_RightDotProductToBeMoreThenToBeValidCoverFor@ "!");

		if( Slots[idx].m_UpValidityAngle < 0.001 )
		{
			Slots[idx].m_UpValidityAngle = 50.0f;
		}
		radianValUp = Slots[idx].m_UpValidityAngle * radian;
		Slots[idx].m_UpDotProductToBeMoreThenToBeValidCoverFor = Cos(radianValUp);

		//`log(" ChadAI - m_UpValidityAngle: " @ Slots[idx].m_UpValidityAngle @ " radianValUp: " @ radianValUp @ " m_UpDotProductToBeMoreThenToBeValidCoverFor: " @ Slots[idx].m_UpDotProductToBeMoreThenToBeValidCoverFor@ "!");


		if( Slots[idx].m_DownValidityAngle < 0.001 )
		{
			Slots[idx].m_DownValidityAngle = 50.0f;
		}
		radianValDown = (3.1415926535897932/2.0) - (Slots[idx].m_DownValidityAngle * radian);
		Slots[idx].m_DownDotProductToBeMoreThenToBeValidCoverFor = Cos(radianValDown);

		//`log(" ChadAI - Cos m_DownValidityAngle not pi min angle: " @ Cos((Slots[idx].m_DownValidityAngle * radian)) );
		
		//`log(" ChadAI - Cos m_DownValidityAngle pi/2 min angle: " @ Cos(( (3.1415926535897932/2.0) - (Slots[idx].m_DownValidityAngle * radian) ) ) );


		//`log(" ChadAI - Cos of 1.7515926535897932384626433832795: " @ Cos(1.7515926535897932384626433832795) );

		//`log(" ChadAI - Cos of 1.3962634015954636615389526147909: " @ Cos(1.3962634015954636615389526147909) );


		//`log(" ChadAI - m_DownValidityAngle: " @ Slots[idx].m_DownValidityAngle @ " radianValDown: " @ radianValDown @ " m_DownDotProductToBeMoreThenToBeValidCoverFor: " @ Slots[idx].m_DownDotProductToBeMoreThenToBeValidCoverFor@ "!");

	}

	super.PostBeginPlay();
}


/**
 * Scripted support for toggling a covernode, checks
 * which operation to perform by looking at the
 * active input.
 *
 * Input 1: turn on
 * Input 2: turn off
 * Input 3: toggle
 */
simulated function OnToggle(SeqAct_Toggle action)
{
	local int idx;
	local TPAIController aicon;
	
	if (action.InputLinks[0].bHasImpulse)
	{
		// turn on
		bEnabled = true;
	}
	else
	if (action.InputLinks[1].bHasImpulse)
	{
		// turn off
		bEnabled = false;
	}
	else
	if (action.InputLinks[2].bHasImpulse)
	{
		// toggle
		bEnabled = !bEnabled;
	}
	
	// if no longer enabled and currently in use, notify the user
	// by going through each slot and seeing if claimed
	if (!bEnabled )
	{ 
		for( idx = 0; idx < Slots.Length; idx++ )
		{
			Slots[idx].bEnabled = bEnabled;
		
			if( Slots[idx].SlotOwner != None )
			{
				aicon = TPAIController(Slots[idx].SlotOwner);
				
				if( aicon.m_CoverMoveData.m_ReservedGoToCover_Clamied.Link == Self )
				{
					UnClaim(Slots[idx].SlotOwner, aicon.m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx, true );
				}
				
				if( aicon.m_CoverMoveData.m_CurrentCover_Clamied.Link == Self )
				{
					UnClaim(Slots[idx].SlotOwner, aicon.m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx, true );
				}
				
				if( aicon.m_CoverMoveData.m_PreviousCover_Not_Clamied.Link == Self )
				{
					UnClaim(Slots[idx].SlotOwner, aicon.m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx, true );
				}
				
			}
		}
	}
}

simulated function OnAITurnCoverSlotOnOff(SeqAct_AITurnCoverSlotOnOff action)
{

	local TPAIController aicon;

   	//`log(" ChadAI - TOCoverNode::OnAITurnCoverSlotOnOff for: " @ Self @ " slotIdx: " @ action.SlotToToggle @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

	// see if the slot id in the action is valid
	if( Slots.Length > action.SlotToToggle )
	{
	
		// toggle the slot to the new value and if the new value is disabled
		// tell the slot owner
		
		Slots[action.SlotToToggle].bEnabled = action.bEnable;
		
		if( !action.bEnable )
		{
			aicon = TPAIController(Slots[action.SlotToToggle].SlotOwner);
			
			if( aicon != None )
			{
				if( aicon.m_CoverMoveData.m_ReservedGoToCover_Clamied.Link == Self && aicon.m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx ==  action.SlotToToggle )
				{
					UnClaim(Slots[action.SlotToToggle].SlotOwner, aicon.m_CoverMoveData.m_ReservedGoToCover_Clamied.SlotIdx, false );
				}
				
				if( aicon.m_CoverMoveData.m_CurrentCover_Clamied.Link == Self && aicon.m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx ==  action.SlotToToggle )
				{
					UnClaim(Slots[action.SlotToToggle].SlotOwner, aicon.m_CoverMoveData.m_CurrentCover_Clamied.SlotIdx, false );
				}
				
				if( aicon.m_CoverMoveData.m_PreviousCover_Not_Clamied.Link == Self && aicon.m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx ==  action.SlotToToggle )
				{
					UnClaim(Slots[action.SlotToToggle].SlotOwner, aicon.m_CoverMoveData.m_PreviousCover_Not_Clamied.SlotIdx, false );
				}
				
			}
		}
	}
}

/**
 * Returns true if the specified cover node is linked in some way to this
 * node.
 */
native noexport final function bool IsLinkedTo(TPCoverNode ChkCover);

/**
 * Returns the location that represents the viewpoint from this cover.
 */
native noexport final function vector GetViewPoint(int SlotID);

// simulated event Tick( float DeltaTime )
// {
// 	local int SlotIdx;
// 	local CoverSlot Slot;
// 	local Vector OwnerLoc;
// 	local byte R, G, B;
// 
//    	//`log(" ChadAI - - TPCoverNode:: event Tick " @ Self @" *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
// 
// }


/**
 * Searches for a fire link to the given cover node and returns the cover actions.
 */
 // CGH TODO Commented out for CoverLink Derived Test
/*final function bool GetFireLinkTo(TPCoverNode ChkCover, out array<ECoverAction> Actions)
{
	local int Idx;
	if (ChkCover != None)
	{
		Idx = CoverFireLinks.Find('TargetNode',ChkCover);
		if (Idx != -1)
		{
			Actions = CoverFireLinks[Idx].CoverActions;
			return true;
		}
	}
	return false;
}*/

/**
 * Searches for a fire link to the given cover node.
 */
// CGH TODO Commented out for CoverLink Derived Test
// native noexport final function bool HasFireLinkTo(TPCoverNode ChkCover);

//***********************************************************************
// Default Properties
//***********************************************************************
// AlignDist:  the distance from the wall the coverpoint is automatically
//			   placed
// EdgeAlignDist: distance away from an edge the cp is placed (this direction
//			   is parallel to the wall and an edge is considered what a guy would
//			   normally peak out of to shoot somebody)
// CornerAlignDist: distance away from the corner a cp is placed (this is for the
//					cp's that must be placed in the corner to properly get covernodes
//					to align to edges - the ones we care about)
// TransitionDist: NOT USED and nobody knows what it is
// PopupDist: vertical distance added to Midlevel and Crouching cps when determining if they
//			  can fire at a particular node
// LeanDist:  the horizontal distance used for leanleft and leanright checks for determining
//			  if they can fire at a particular node
// StandHeight:  used to determine if cover is standing/mid/crouching by doing line checks between
//				 croushing and mid then standheight and midheight
// MidHeight:
// CrouchHeight:
//
// IMPORTANT NOTES:
// There is some assness with the auto align path node business.  Depending on your settings, if you
// build paths twice in a row, you can get different results.  To help prevent this, I'm going to
// try these guidelines (this won't completely prevent it, but it should help).
//  1.  make sure alignDist is smaller than CornerAlignDist


