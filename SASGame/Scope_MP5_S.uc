//=============================================================================
// HK_MP5_Scope.uc
//
// Scope attachment for MP5.
//=============================================================================

class Scope_MP5_S extends SASWeaponScope;

#exec OBJ LOAD FILE=..\textures\SfxTx.utx PACKAGE=SfxTx


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mOverlay=Texture'SFXTx.Scopes.FxScr_GenScope'
    mCrosshair=Texture'SFXTx.Scopes.FxScr_crosshair'
    mCrosshairScale=0.7000000
}