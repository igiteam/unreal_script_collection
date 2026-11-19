class MOHAHUDImg extends MOHAHUDObj
    native;

var Texture2D Image;
var float tileU;
var float tileV;
var float tileSizeU;
var float tileSizeV;

// Export UMOHAHUDImg::execUpdateImage(FFrame&, void* const)
native function UpdateImage(Texture2D new_image);

// Export UMOHAHUDImg::execSetTileUV(FFrame&, void* const)
native function SetTileUV(float U, float V);

// Export UMOHAHUDImg::execSetTileSizeUV(FFrame&, void* const)
native function SetTileSizeUV(float sizeU, float sizeV);

// Export UMOHAHUDImg::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDImg::execShouldRender(FFrame&, void* const)
native function bool ShouldRender();

function ToggleState(bool State)
{
    bRender = State;
    //return;    
}
