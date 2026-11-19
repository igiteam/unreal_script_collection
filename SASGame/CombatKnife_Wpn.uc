//=============================================================================
// CombatKnife_Wpn.uc
//
// Modes:
//			Single fire
//
// Primary fire:
//			Slash
//
// Secondary Fire:
//			Stab
//=============================================================================

class CombatKnife_Wpn extends SASKnifeWeapon;


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mHandAnims=MeshAnimation'WpAn.HANDS_KNIFE'
    mFPWeaponMeshClass=Class'CombatKnife_FPKnifeMesh'
    UsesAmmo=false
    mLineartWeapon=Texture'HUDTx.Weapon_Lineart.HUD_WL_Knife'
    mUnsightedFireAnim="1st_Attack1"
    mFireSounds=/* Array type was not detected. */
    AmmoName=Class'CombatKnife_DummyAmmo'
    AttachmentClass=Class'CombatKnife_WpnAttach'
    ItemName="Knife"
}