//=============================================================================
// ACTION_ChangeSide.uc
//
// Script action to change the side of the pawn possessed by the scripted
// controller.
// Side definitions in SASPawn.uc (SIDE_xxx consts). 
//=============================================================================

class ACTION_ChangeSide extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Actions) int mSide;	// Side to change to


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASPawn		myPawn;
	local Controller	C;	

	if ( aInterface.mAIController == None )
	{
		return true;
	}

	if ( aInterface.mAIController.Pawn != None )
	{
		myPawn = SASPawn( aInterface.mAIController.Pawn );
	}
	if ( myPawn == None )
	{
		LogHuman( "ACTION_ChangeSide.DoAction: "
			$aInterface.mAIController$" does not have a pawn or it is not of type SASPawn." );
		return true;	
	}

	// Don't allow squad members to change side.
	if ( SASSoldier( myPawn ) != None )
	{
		LogHuman( "ACTION_ChangeSide.DoAction: Cant change side of squad member "$myPawn );
		return true;
	}

	// Can't change to SIDE_None
	/*if ( mSide == SIDE_None )
	{
		LogHuman( "ACTION_ChangeSide.DoAction: Cant change to side -1 for pawn "$myPawn );
		return true;
	}

	// Can't change to squad side
	if ( mSide == SIDE_Squad )
	{
		LogHuman( "ACTION_ChangeSide.DoAction: Cant change to squad side for pawn "$myPawn );
		return true;
	}

	myPawn.mSide = ESASSide(mSide);
*/
	// Notify AI controller of side change, may need to change target.
	for ( C = mOwnerScript.Level.ControllerList; C != None; C = C.nextController )
	{
		if ( SASAIController( C ) != None)
		{
			SASAIController( C ).NotifyOtherChangedSide( myPawn );
		}
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mSide;
} 


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mSide=-1
    mActionString="Change Side"
}