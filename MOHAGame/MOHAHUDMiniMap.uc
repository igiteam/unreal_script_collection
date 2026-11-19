class MOHAHUDMiniMap extends MOHAHUDImg
    native;

var MaterialInstance miniMapMat;
var MaterialInstance miniMapMat_Xenon;
var Vector2D vOrigin_WS;
var Vector2D vMapSize_WS;

// Export UMOHAHUDMiniMap::execShouldRender(FFrame&, void* const)
native function bool ShouldRender();

// Export UMOHAHUDMiniMap::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

function ToggleState(bool State)
{
    bRender = State;
    //return;    
}

defaultproperties
{
    vOrigin_WS=(X=4026.0000000,Y=7648.0000000)
    vMapSize_WS=(X=36000.0000000,Y=36000.0000000)
}