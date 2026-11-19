//=============================================================================
// SASEmitter.uc
//
// Abstract base class of particle emitters in SAS
//=============================================================================

class SASEmitter extends Emitter
	native
	abstract;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// TriggerParticle
//
// Fires off a single particle
function TriggerParticle ()
{
	Emitters[0].SpawnParticle (1);
	// Make sure particle system is awake
	Emitters[0].AllParticlesDead = false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    RemoteRole=1
}