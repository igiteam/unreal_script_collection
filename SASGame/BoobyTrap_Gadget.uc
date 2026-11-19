//=============================================================================
// BoobyTrap_Gadget
//
// example of a booby trap device on an innocent looking, discarded handbag
// just need to add a SASBoobyTrap trigger volume
//=============================================================================

class BoobyTrap_Gadget extends SASBoobyTrapDevice
	placeable;


//-----------------------------------------------------------------------------
// Default properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mMarkerClass=Class'SASEffects.Marker_BoobyTrap'
    mExplosionClass=Class'SASEffects.Explosion_BoobyTrap'
    StaticMesh=StaticMesh'TbeSm.ECM2_OBJECTS.obt217_boobytrap'
    DrawType=8
}