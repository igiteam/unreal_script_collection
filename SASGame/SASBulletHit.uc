//=============================================================================
// SASBulletHit
// Emitter effects for bullet hitting stuff
//=============================================================================

class SASBulletHit extends Emitter
	abstract;

var bool mbNotInGermanBuild;

///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
//
simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	// In german build prevent blood effects appearing.
	if ( mbNotInGermanBuild && IsGermanBuild() )
	{
		Kill();
	}
}


///////////////////////////////////////////////////////////////////////////////
// Reset
//
// Destroy on restarting level.
simulated function Reset()
{
	Destroy();
}

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    RemoteRole=2
    bNetTemporary=true
}