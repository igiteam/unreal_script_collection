//=============================================================================
// ACTION_SetStance.uc
//
// Script action to set the stance of the controlled pawn.
//=============================================================================

class ACTION_SetStance extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) ESASStance	meStance;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
   SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	// Check stance is valid. (Some stances are no longer used)
	switch ( meStance )
	{
	case STANCE_Stooped_REMOVED:
		LogHuman( "ACTION_SetStance in script <"$aScript$"> has invalid stance 'stooped'. Please change to standing/crouched." );
		meStance = STANCE_Standing;
		break;

	case STANCE_Kneeling_REMOVED:
		LogHuman( "ACTION_SetStance in script <"$aScript$"> has invalid stance 'kneeling'. Please change to crouched." );
		meStance = STANCE_Crouched;
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASPawn	scriptedPawn;

	if ( aInterface.mAIController == None )
	{
		return true;
	}

	if ( aInterface.mAIController.Pawn != None )
	{
		scriptedPawn = SASPawn( aInterface.mAIController.Pawn );
		if ( scriptedPawn != None )
		{
			scriptedPawn.ChangeStanceImmediate( meStance );
		}
	}

	return true;
}

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Set Stance"
}