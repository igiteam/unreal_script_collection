class MOHAHUDHealth extends MOHAHUDObj
    native;

var() int NumPills;
var() float fPillWarningPct;
var() float fWarningBlinkFreq;
var() Vector2D vBGPixelSize;
var() Vector2D vHealthBarUV;
var() Vector2D vHealthBarFillUV;
var() Vector2D vHealthBarUVSize;
var() Vector2D vHealthBarPixelSize;
var() Vector2D vHealthSymbolPixelSize;
var() Vector2D vHealthSymbolOffset;
var() Vector2D vHealthBarOffset;
var int iLastStartingBlinkPill;
var MOHAHUDImg HealthBackground;
var MOHAHUDImg HealthSymbol;
var array<MOHAHUDImg> HealthBar;
var array<MOHAHUDImg> HealthBarFill;
var array<MOHAHUDObj> HUDObjects;

// Export UMOHAHUDHealth::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDHealth::execEnableElement(FFrame&, void* const)
native function EnableElement(bool new_bRender);

// Export UMOHAHUDHealth::execOnResolutionChange(FFrame&, void* const)
native function OnResolutionChange(float resolutionScale);

// Export UMOHAHUDHealth::execSetRenderInMode(FFrame&, void* const)
native function SetRenderInMode(MOHAHUD.EHUDRenderMode RenderMode);

function Setup(float fPosX, float fPosY)
{
    local int I;

    SetSize(vBGPixelSize.X, vBGPixelSize.Y);
    SetPosition(fPosX, fPosY);
    JustifyXLeft();
    JustifyYBottom();
    HealthBackground = new Class'MOHAHUDImg';
    HealthBackground.MOHAHUD = MOHAHUD;
    HealthBackground.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    HealthBackground.Link(self, 1, 2);
    HealthBackground.SetSize(vBGPixelSize.X, vBGPixelSize.Y);
    HealthBackground.SetTileUV(0.0000000, 64.0000000);
    HealthBackground.SetTileSizeUV(256.0000000, 64.0000000);
    HealthBackground.JustifyXLeft();
    HealthBackground.JustifyYBottom();
    HealthSymbol = new Class'MOHAHUDImg';
    HealthSymbol.MOHAHUD = MOHAHUD;
    HealthSymbol.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    HealthSymbol.Link(self, 1, 2);
    HealthSymbol.SetRelativeOffset(int(vHealthSymbolOffset.X), int(vHealthSymbolOffset.Y));
    HealthSymbol.SetSize(vHealthSymbolPixelSize.X, vHealthSymbolPixelSize.Y);
    HealthSymbol.SetTileUV(0.0000000, 128.0000000);
    HealthSymbol.SetTileSizeUV(48.0000000, 48.0000000);
    HealthSymbol.JustifyXLeft();
    HealthSymbol.JustifyYBottom();
    HUDObjects[HUDObjects.Length] = HealthBackground;
    HUDObjects[HUDObjects.Length] = HealthSymbol;
    I = 0;
    J0x27E:

    // End:0x463 [Loop If]
    if(I < NumPills)
    {
        HealthBar[I] = new Class'MOHAHUDImg';
        HealthBar[I].MOHAHUD = MOHAHUD;
        HealthBar[I].UpdateImage(Texture2D'HUD.HUDMultiIcons02');
        HealthBar[I].Link(self, 1, 2);
        HealthBar[I].SetRelativeOffset(int(vHealthBarOffset.X + (vHealthBarPixelSize.X * float(I))), int(vHealthBarOffset.Y));
        HealthBar[I].SetSize(vHealthBarPixelSize.X, vHealthBarPixelSize.Y);
        HealthBar[I].SetTileUV(vHealthBarUV.X + (vHealthBarUVSize.X * float(I)), vHealthBarUV.Y);
        HealthBar[I].SetTileSizeUV(vHealthBarUVSize.X, vHealthBarUVSize.Y);
        HealthBar[I].JustifyXLeft();
        HealthBar[I].JustifyYBottom();
        HUDObjects[HUDObjects.Length] = HealthBar[I];
        I++;
        // [Loop Continue]
        goto J0x27E;
    }
    I = 0;
    J0x46A:

    // End:0x64F [Loop If]
    if(I < NumPills)
    {
        HealthBarFill[I] = new Class'MOHAHUDImg';
        HealthBarFill[I].MOHAHUD = MOHAHUD;
        HealthBarFill[I].UpdateImage(Texture2D'HUD.HUDMultiIcons02');
        HealthBarFill[I].Link(self, 1, 2);
        HealthBarFill[I].SetRelativeOffset(int(vHealthBarOffset.X + (vHealthBarPixelSize.X * float(I))), int(vHealthBarOffset.Y));
        HealthBarFill[I].SetSize(vHealthBarPixelSize.X, vHealthBarPixelSize.Y);
        HealthBarFill[I].SetTileUV(vHealthBarFillUV.X + (vHealthBarUVSize.X * float(I)), vHealthBarFillUV.Y);
        HealthBarFill[I].SetTileSizeUV(vHealthBarUVSize.X, vHealthBarUVSize.Y);
        HealthBarFill[I].JustifyXLeft();
        HealthBarFill[I].JustifyYBottom();
        HUDObjects[HUDObjects.Length] = HealthBarFill[I];
        I++;
        // [Loop Continue]
        goto J0x46A;
    }
    //return;    
}

event float GetHealthRatio()
{
    // End:0x73
    if(((MOHAHUD != none) && MOHAHUD.PlayerOwner != none) && MOHAPlayerPawn(MOHAHUD.PlayerOwner.Pawn) != none)
    {
        return MOHAPlayerPawn(MOHAHUD.PlayerOwner.Pawn).GetHealthRatio();        
    }
    else
    {
        return 0.0000000;
    }
    //return ReturnValue;    
}

event float GetVergeOfDeathHealthRatio()
{
    // End:0x73
    if(((MOHAHUD != none) && MOHAHUD.PlayerOwner != none) && MOHAPlayerPawn(MOHAHUD.PlayerOwner.Pawn) != none)
    {
        return MOHAPlayerPawn(MOHAHUD.PlayerOwner.Pawn).GetVergeOfDeathHealthRatio();        
    }
    else
    {
        return 0.0000000;
    }
    //return ReturnValue;    
}

defaultproperties
{
    NumPills=4
    fPillWarningPct=0.2500000
    fWarningBlinkFreq=2.0000000
    vBGPixelSize=(X=256.0000000,Y=60.0000000)
    vHealthBarUV=(X=64.0000000,Y=133.0000000)
    vHealthBarFillUV=(X=64.0000000,Y=165.0000000)
    vHealthBarUVSize=(X=32.0000000,Y=22.0000000)
    vHealthBarPixelSize=(X=32.0000000,Y=22.0000000)
    vHealthSymbolPixelSize=(X=48.0000000,Y=48.0000000)
    vHealthSymbolOffset=(X=25.0000000,Y=-3.0000000)
    vHealthBarOffset=(X=89.0000000,Y=-10.0000000)
    iLastStartingBlinkPill=-1
}