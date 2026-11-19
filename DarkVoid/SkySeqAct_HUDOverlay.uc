class SkySeqAct_HUDOverlay extends SeqAct_Latent
    native;

var() float Duration;
var() float FadeIn;
var() bool bWipeIn;
var() bool bWipeOut;
var bool bStarted;
var bool bCancel;
var() float FadeOut;
var() MaterialInterface Material;
var() Texture2D Texture;
var() float XCenterLoc;
var() float YCenterLoc;
var() float Width;
var() float Height;
var float StartTime;
var float MaterialAlpha;
var SkyHUDOverlay overlay;

event CreateOverlay(HUD HUD)
{
    local SkyHUD SHud;

    SHud = SkyHUD(HUD);
    // End:0x1D
    if(SHud == none)
    {
        return;
    }
    // End:0x82
    if(overlay == none)
    {
        SHud.HUDOverlays.Insert(SHud.HUDOverlays.Length, 1);
        overlay = new Class'SkyHUDOverlay';
        SHud.HUDOverlays[SHud.HUDOverlays.Length - 1] = overlay;
    }
    overlay.MatInstance = new (none) Class'Engine.MaterialInstanceConstant';
    overlay.MatInstance.SetParent(Material);
    // End:0xF6
    if(Texture != none)
    {
        overlay.MatInstance.SetTextureParameterValue('Texture', Texture);
    }
    overlay.XLoc = XCenterLoc;
    overlay.YLoc = YCenterLoc;
    overlay.Width = Width;
    overlay.Height = Height;
    //return;    
}

event DestroyOverlay(HUD HUD)
{
    local int Index;
    local SkyHUD SHud;

    SHud = SkyHUD(HUD);
    // End:0x2A
    if((overlay == none) || SHud == none)
    {
        return;
    }
    Index = SHud.HUDOverlays.Find(overlay);
    SHud.HUDOverlays.Remove(Index, 1);
    overlay = none;
    //return;    
}
