class MOHAHUDCompassBead extends MOHAHUDImg
    native;

var bool bActive;
var bool bOutOfCompassRange;
var bool bRenderIfOutofRange;
var bool bIsAboveOrBelow;
var Actor beadActor;
var float fCompassRadius_WS;
var() float fMinHeightDiffForAlpha;
var() float fHeightDiffAlpha;

// Export UMOHAHUDCompassBead::execGetCompassRadius(FFrame&, void* const)
native function float GetCompassRadius();

// Export UMOHAHUDCompassBead::execShouldRender(FFrame&, void* const)
native function bool ShouldRender();

// Export UMOHAHUDCompassBead::execUpdateAlpha(FFrame&, void* const)
native function UpdateAlpha();

function ToggleState(bool State)
{
    bRender = State;
    // End:0x22
    if(!State)
    {
        StopBlink();
    }
    //return;    
}

defaultproperties
{
    fCompassRadius_WS=3000.0000000
    fMinHeightDiffForAlpha=300.0000000
    fHeightDiffAlpha=0.3500000
}