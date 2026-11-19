class MOHAHUDHitIndicator extends MOHAHUDImg
    native;

var() float fHitIndicatorRadius;
var float fDamageYaw;

// Export UMOHAHUDHitIndicator::execShouldRender(FFrame&, void* const)
native function bool ShouldRender();

// Export UMOHAHUDHitIndicator::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

function Setup()
{
    UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    SetPosition(0.5000000, 0.5000000);
    SetSize(205.0000000, 205.0000000);
    SetTileSizeUV(190.0000000, 190.0000000);
    SetTileUV(35.0000000, 322.0000000);
    JustifyXCenter();
    JustifyYCenter();
    SetColor(byte(255), byte(255), byte(255), byte(255));
    EnableElement(false);
    //return;    
}

function SetDamageYaw(float fYaw)
{
    fDamageYaw = fYaw;
    //return;    
}

defaultproperties
{
    fHitIndicatorRadius=175.0000000
    RenderGroup=0
}