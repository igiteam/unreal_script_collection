//=============================================================================
// SASBoobyTrapTrigger.uc
//
// Booby trap trigger class in SAS.
//=============================================================================

class SASBoobyTrapTrigger extends Volume
	placeable;

var SASBoobyTrapDevice		mBoobyTrapDevice;

//-----------------------------------------------------------------------------
// Member Vars
//

//-----------------------------------------------------------------------------
// Functions
//

//-----------------------------------------------------------------------------
// Touch
//
// Called when something touches the trigger.
event Touch ( Actor aTouched )
{
	// only interested in SASPawns
	if ( ( SASPawn ( aTouched ) != None ) && ( mBoobyTrapDevice != None ) )
	{
		mBoobyTrapDevice.TriggerTouched ( aTouched );
	}
}

//-----------------------------------------------------------------------------
// Untouch
//
event Untouch ( Actor aUntouched )
{
	// only interested in SASPawns
	if ( ( SASPawn ( aUntouched ) != None ) && ( mBoobyTrapDevice != None ) )
	{
		mBoobyTrapDevice.TriggerUntouched ( aUntouched );
	}
}

//-----------------------------------------------------------------------------
// Default Properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    BrushColor=(R=255,G=80,B=255,A=255)
    bColored=true
    bStatic=false
    bNoDelete=false
}