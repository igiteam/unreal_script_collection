class TurokHudNoPlacement extends TurokHudElement
    transient
    native;

var private float mScrPctY;
var private bool mbDraw;
var private bool mbBlinkOn;
var private @NULL mIconTexture;
var private int mNumBlinks;
var private int mTotalBlinks;
var private float mBlinkTime;
var private float mBlinkLength;

// Export UTurokHudNoPlacement::execDrawHUD(FFrame&, void* const)
native function DrawHUD(@NULL HUD);

// Export UTurokHudNoPlacement::execReset(FFrame&, void* const)
native function Reset();

// Export UTurokHudNoPlacement::execSetVisible(FFrame&, void* const)
native function SetVisible(bool Show);

defaultproperties
{
    mScrPctY=0.7000000
    mbBlinkOn=true
    mIconTexture=Texture2D'TurokHud.NoPlacement.CannotDropChainGun_Icon'
    mTotalBlinks=3
    mBlinkLength=0.0800000
}