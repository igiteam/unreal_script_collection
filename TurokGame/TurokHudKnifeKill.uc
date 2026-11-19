class TurokHudKnifeKill extends TurokHudElement
    transient
    native;

var private float mScrPctY;
var private bool mbDraw;

// Export UTurokHudKnifeKill::execDrawHUD(FFrame&, void* const)
native function DrawHUD(@NULL HUD);

// Export UTurokHudKnifeKill::execReset(FFrame&, void* const)
native function Reset();

// Export UTurokHudKnifeKill::execSetVisible(FFrame&, void* const)
native function SetVisible(bool Show);

defaultproperties
{
    mScrPctY=0.7000000
}