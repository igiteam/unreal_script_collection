//=============================================================================
// CombatKnife_DummyAmmo.uc
//
// 'Ammo' for knife weapons.
//=============================================================================

class CombatKnife_DummyAmmo extends SASAmmo;

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// HasAmmo
//
simulated event bool HasAmmo ()
{
	return true;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    Damage=220
    Penetration=0
    MaxAmmo=2000
}