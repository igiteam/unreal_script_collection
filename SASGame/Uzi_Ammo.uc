//=============================================================================
// Uzi_Ammo.uc
//
// Ammo type for Uzi 9mm weapons.
//=============================================================================

class Uzi_Ammo extends SASAmmo;

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    MinDamage=90
    MaxDamage=160
    Penetration=400
    MaxAmmo=150
    MyDamageType=Class'DamageType_9mm'
}