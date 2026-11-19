//=============================================================================
// HK_MP5_Scope.uc
//
// Scope attachment for Aug and SigSwat.
//=============================================================================

class Scope_Aug extends SASWeaponScope;

#exec OBJ LOAD FILE=..\textures\SfxTx.utx PACKAGE=SfxTx


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mOverlay=Texture'SFXTx.Scopes.FxScr_GenScope'
    mCrosshair=Texture'SFXTx.Scopes.FxScr_crosshair2'
    mCrosshairScale=0.8500000
}