class MOHAHUDTrueTriggerMeter extends MOHAHUDObj
    native;

var MOHAHUDImg hud_weaponTrueTriggerBG;
var MOHAHUDImg hud_weaponTrueTriggerBar;
var MOHAHUDImg hud_weaponTrueTriggerSlider_Top;
var MOHAHUDImg hud_weaponTrueTriggerSlider_Bottom;
var array<MOHAHUDObj> HUDObjects;

// Export UMOHAHUDTrueTriggerMeter::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDTrueTriggerMeter::execSetRenderInMode(FFrame&, void* const)
native function SetRenderInMode(MOHAHUD.EHUDRenderMode RenderMode);

// Export UMOHAHUDTrueTriggerMeter::execEnableElement(FFrame&, void* const)
native function EnableElement(bool new_bRender);

function Setup(float fPosX, float fPosY)
{
    SetPosition(fPosX, fPosY);
    JustifyXCenter();
    JustifyYCenter();
    hud_weaponTrueTriggerBG = new Class'MOHAHUDImg';
    hud_weaponTrueTriggerBG.MOHAHUD = MOHAHUD;
    hud_weaponTrueTriggerBG.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_weaponTrueTriggerBG.Link(self, 0, 0);
    hud_weaponTrueTriggerBG.SetSize(43.7000000, 359.2000000);
    hud_weaponTrueTriggerBG.SetTileSizeUV(29.0000000, 255.0000000);
    hud_weaponTrueTriggerBG.SetTileUV(228.0000000, 256.0000000);
    hud_weaponTrueTriggerBG.JustifyXCenter();
    hud_weaponTrueTriggerBG.JustifyYCenter();
    hud_weaponTrueTriggerBG.SetRenderGroup(7);
    hud_weaponTrueTriggerBG.EnableElement(false);
    hud_weaponTrueTriggerBar = new Class'MOHAHUDImg';
    hud_weaponTrueTriggerBar.MOHAHUD = MOHAHUD;
    hud_weaponTrueTriggerBar.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_weaponTrueTriggerBar.Link(self, 0, 0);
    hud_weaponTrueTriggerBar.SetSize(2.0000000, 2.0000000);
    hud_weaponTrueTriggerBar.SetTileSizeUV(2.0000000, 2.0000000);
    hud_weaponTrueTriggerBar.SetTileUV(207.0000000, 262.0000000);
    hud_weaponTrueTriggerBar.JustifyXCenter();
    hud_weaponTrueTriggerBar.JustifyYCenter();
    hud_weaponTrueTriggerBar.SetRenderGroup(6);
    hud_weaponTrueTriggerBar.EnableElement(false);
    hud_weaponTrueTriggerSlider_Top = new Class'MOHAHUDImg';
    hud_weaponTrueTriggerSlider_Top.MOHAHUD = MOHAHUD;
    hud_weaponTrueTriggerSlider_Top.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_weaponTrueTriggerSlider_Top.Link(self, 0, 0);
    hud_weaponTrueTriggerSlider_Top.SetSize(63.0000000, 32.0000000);
    hud_weaponTrueTriggerSlider_Top.SetTileSizeUV(63.0000000, 32.0000000);
    hud_weaponTrueTriggerSlider_Top.SetTileUV(64.0000000, 288.0000000);
    hud_weaponTrueTriggerSlider_Top.JustifyXCenter();
    hud_weaponTrueTriggerSlider_Top.JustifyYBottom();
    hud_weaponTrueTriggerSlider_Top.SetRenderGroup(7);
    hud_weaponTrueTriggerSlider_Top.EnableElement(false);
    hud_weaponTrueTriggerSlider_Bottom = new Class'MOHAHUDImg';
    hud_weaponTrueTriggerSlider_Bottom.MOHAHUD = MOHAHUD;
    hud_weaponTrueTriggerSlider_Bottom.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_weaponTrueTriggerSlider_Bottom.Link(self, 0, 0);
    hud_weaponTrueTriggerSlider_Bottom.SetSize(63.0000000, 32.0000000);
    hud_weaponTrueTriggerSlider_Bottom.SetTileSizeUV(63.0000000, 32.0000000);
    hud_weaponTrueTriggerSlider_Bottom.SetTileUV(0.0000000, 288.0000000);
    hud_weaponTrueTriggerSlider_Bottom.JustifyXCenter();
    hud_weaponTrueTriggerSlider_Bottom.JustifyYTop();
    hud_weaponTrueTriggerSlider_Bottom.SetRenderGroup(7);
    hud_weaponTrueTriggerSlider_Bottom.EnableElement(false);
    HUDObjects[0] = hud_weaponTrueTriggerBG;
    HUDObjects[1] = hud_weaponTrueTriggerBar;
    HUDObjects[2] = hud_weaponTrueTriggerSlider_Top;
    HUDObjects[3] = hud_weaponTrueTriggerSlider_Bottom;
    SetSize(float(hud_weaponTrueTriggerBG.SizeX), float(hud_weaponTrueTriggerBG.SizeY));
    //return;    
}
